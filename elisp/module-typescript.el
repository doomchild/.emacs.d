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
  (company-mode)
  (electric-pair-mode 1)
  (editorconfig-mode 1)
  (editorconfig-apply)
  (lsp))

(use-package typescript-mode
    :mode "\\.ts\\'"
    :demand t
    :config
    (add-hook 'typescript-mode-hook #'dc/typescript-hook))

(provide 'module-typescript)

;;; module-typescript.el ends here
