;;; -*- lexical-binding: t; -*-
;;; Typescript

(defvar import-regex-from)
(setq import-regex-from "^import \\({[[:space:]]\\)?\\([[:alnum:],[:space:]]+\\)\\([[:space:]]}\\)?[[:space:]]+from \\(\".*\"\\);?")

(defvar import-regex-to)
(setq import-regex-to "const \\1\\2\\3 = require(\\4);")

(defvar raw-function-regex-from)
(setq raw-function-regex-from "^function \\([[:alpha:]]+\\)(\\([[:alpha:]]+\\): [[:alpha:]<>]+): [\]\[[:alpha:]():=<>[:space:]]+ {$")

(defvar raw-function-regex-to)
(setq raw-function-regex-to "function \\1(\\2) {")

(defvar export-default-function-regex-from)
(setq export-default-function-regex-from "^export default function \\([[:alnum:]]+\\)(\\([[:alnum:]]+\\)[\]:[:alpha:][:space:]<>\[{}}]*): [\][:alpha:]\[\(\):[:space:]=<>]+ {\n\\([[:ascii:]\n]*\\)}$")

(defvar export-default-function-regex-to)
(setq export-default-function-regex-to "function \\1(\\2) {\n\\3}\n\nmodule.exports = \\1;")

(defvar export-function-regex-from)
(setq export-function-regex-from "^export function \\([[:alnum:]]+\\)(\\([[:alnum:]]+\\)[\]:[:alpha:][:space:]<>\[]*): [[:alpha:]]+ {\n\\([[:ascii:]\n]*\\)}$")

(defvar export-function-regex-to)
(setq export-function-regex-to "function \\1(\\2) {\\n\\3}\n\nmodule.exports = { \\1 };")

(defvar as-regex-from)
(setq as-regex-from " as [\]\[[:alpha:],[:space:]]+\\(,\\)?")

(defvar as-regex-to)
(setq as-regex-to "\\1")

(defun replace-all-regex (from to)
  (while (re-search-forward from nil t)
    (replace-match to)))

(defun untypescript()
  (interactive)
  (beginning-of-buffer)
  (replace-all-regex "^import { v4 as uuid } from \"uuid\";" "const { v4: uuid } = require(\"uuid\");")
  (beginning-of-buffer)
  (replace-all-regex import-regex-from import-regex-to)
  (beginning-of-buffer)
  (replace-all-regex raw-function-regex-from raw-function-regex-to)
  (beginning-of-buffer)
  (replace-all-regex as-regex-from as-regex-to)
  (beginning-of-buffer)
  (replace-all-regex export-default-function-regex-from export-default-function-regex-to)
  (beginning-of-buffer)
  (replace-all-regex export-function-regex-from export-function-regex-to))

(defun dc/typescript-hook ()
  (company-mode 1)
  (semantic-mode 1)
  (electric-pair-mode 1)
  (editorconfig-mode 1)
  (editorconfig-apply)
  (lsp))

(defun dc/typescript--proper-indentation (parse-status)
  "Return the proper indentation for the current line."
  (save-excursion
    (back-to-indentation)
    (let ((member-expr-p (looking-at "\\.")))
      (cond ((nth 4 parse-status) ;; Inside a comment.
             (typescript--get-c-offset 'c (nth 8 parse-status)))
            ((nth 8 parse-status) 0) ;; Inside a string.
            ((typescript--ctrl-statement-indentation)) ;; Control statements.
            ((eq (char-after) ?#) 0) ;; Looking at a pragma.
            ;; Inside a list of things. Note that in the TS contents, the curly braces
            ;; marking code blocks are "list of things".
            ((nth 1 parse-status)
             (let ((indent-start (point))
                   (same-indent-p (looking-at "[]})]"))
                   (switch-keyword-p (looking-at "\\_<default\\_>\\|\\_<case\\_>[^:]"))
                   (continued-expr-p (typescript--continued-expression-p))
                   (list-start (nth 1 parse-status)))
               (goto-char list-start)
               (if (looking-at "[({[]\\s-*\\(/[/*]\\|$\\)")
                   (progn
                     (skip-syntax-backward " ")
                     (cond
                      ((or (typescript--backward-to-parameter-list)
                           (eq (char-before) ?\)))
                       ;; Take the curly brace as marking off the body of a function.
                       ;; In that case, we want the code that follows to see the indentation
                       ;; that was in effect at the beginning of the function declaration, and thus
                       ;; we want to move back over the list of function parameters.
                       (condition-case nil
                           (backward-list)
                         (error nil)))
                      ((looking-back "," nil)
                       ;; If we get here, we have a comma, spaces and an opening curly brace. (And
                       ;; (point) is just after the comma.) We don't want to move from the current position
                       ;; so that object literals in parameter lists are properly indented.
                       nil)
                      (t
                       ;; In all other cases, we don't want to move from the curly brace.
                       (goto-char list-start)))
                     (back-to-indentation)
                     (let* ((in-switch-p (unless same-indent-p
                                           (looking-at "\\_<switch\\_>")))
                            (same-indent-p (or same-indent-p
                                               (and switch-keyword-p
                                                    in-switch-p)))
                            (indent
                             (cond (same-indent-p
                                    (current-column))
                                   (continued-expr-p
                                    (if (not member-expr-p)
                                        (+ (current-column) (* 2 typescript-indent-level)
                                           typescript-expr-indent-offset)
                                      (goto-char indent-start)
                                      (typescript--compute-member-expression-indent)))
                                   (t
                                    (+ (current-column) typescript-indent-level)))))
                       (if (and in-switch-p typescript-indent-switch-clauses)
                           (+ indent typescript-indent-level)
                         indent)))
                 (when (and (not same-indent-p)
                            typescript-indent-list-items)
                   (forward-char)
                   (skip-chars-forward " \t"))
                 (if continued-expr-p
                     (if (not member-expr-p)
                         (progn (back-to-indentation)
                                (+ (current-column) typescript-indent-level
                                   typescript-expr-indent-offset))
                       (goto-char indent-start)
                       (typescript--compute-member-expression-indent))
                   (current-column)))))

            ((typescript--continued-expression-p) ;; Inside a continued expression.
             (if member-expr-p
                 (typescript--compute-member-expression-indent)
               (+ typescript-indent-level typescript-expr-indent-offset)))
            (t 0)))))

(advice-add 'typescript--proper-indentation :override #'dc/typescript--proper-indentation)

(use-package typescript-mode
    :mode "\\.ts\\'"
    :demand t
    :config
    (add-hook 'typescript-mode-hook #'dc/typescript-hook))

(provide 'module-typescript)

;;; module-typescript.el ends here
