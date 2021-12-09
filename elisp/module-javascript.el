;;; -*- lexical-binding: t; -*-
;;; Javascript and JSON

(use-package add-node-modules-path
  :demand t)

(use-package js-doc
  :demand t)

(use-package js2-refactor
  :demand t
  :config
  (js2r-add-keybindings-with-prefix "C-; C-r"))

(use-package xref-js2
  :demand t)

(defun dc/json-mode-hook ()
  (electric-pair-mode)
  (editorconfig-mode 1)
  (editorconfig-apply))

(use-package json-mode
  :mode "\\.json\\'"
  :config
  (add-hook 'json-mode-hook #'dc/json-mode-hook))

(defun dc/js2-mode-hook ()
  (add-hook 'js-mode-hook #'add-node-modules-path)
  (js2-refactor-mode)
  (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)
  (company-mode)
  (semantic-mode)
  (electric-pair-mode)
  (editorconfig-mode 1)
  (editorconfig-apply)
  (lsp))

(use-package js2-mode
  :mode "\\.js\\'"
  :bind (:map js2-mode-map
	  ("<tab>"  . js2-indent-bounce)
	  ("<backtab>" . js2-indent-bounce-backward)
          ("\C-ci" . js-doc-insert-function-doc)
          ("@" . js-doc-insert-tag)
          ("C-k" . js2r-kill)
          :map js-mode-map
          ("M-." . nil))
  :config
  (setq js-switch-indent-offset 2)
  (setq js2-basic-offset 2)
  (setq js2-bounce-indent-p t)
  (setq lsp-eslint-unzipped-path "~/.emacs.d/private/lsp/eslint")
  (setq lsp-eslint-node (string-trim (shell-command-to-string "which node")))
  (setq lsp-eslint-runtime (string-trim (shell-command-to-string "which node")))
  (setq lsp-eslint-server-command (list "node" (expand-file-name "~/.emacs.d/private/lsp/eslint/extension/server/out/eslintServer.js") "--stdio"))
  (setq lsp-eslint-library-choices-file (format "%s/.lsp-eslint-choices" temporary-directory))
  (add-hook 'js2-mode-hook #'js2-refactor-mode)
  (add-hook 'js2-mode-hook #'dc/js2-mode-hook))

;; NOTE(doomchild):  This override fixes js-mode's weird decision to indent declarations starting from the variable name instead of 'const'.  I have no idea why they did it that way, and it bugs the ever-living hell out of me.
(defun dc/js--multi-line-declaration-indentation ()
  "Helper function for `js--proper-indentation'.
Return the proper indentation of the current line if it belongs to a declaration
statement spanning multiple lines; otherwise, return nil."
  (let (forward-sexp-function ; Use Lisp version.
        at-opening-bracket)
    (save-excursion
      (back-to-indentation)
        (let ((pt (point)))
          (when (looking-at js--indent-operator-re)
            (goto-char (match-end 0)))
          ;; The "operator" is probably a regexp literal opener.
          (when (nth 3 (syntax-ppss))
            (goto-char pt)))
        (while (and (not at-opening-bracket)
                    (not (bobp))
                    (let ((pos (point)))
                      (save-excursion
                        (js--backward-syntactic-ws)
                        (or (eq (char-before) ?,)
                            (and (not (eq (char-before) ?\;))
                                 (prog2
                                     (skip-syntax-backward ".")
                                     (looking-at js--indent-operator-re)
                                   (js--backward-syntactic-ws))
                                 (not (eq (char-before) ?\;)))
                            (js--same-line pos)))))
          (condition-case nil
              (backward-sexp)
            (scan-error (setq at-opening-bracket t)))))))

(advice-add 'js--multi-line-declaration-indentation :override #'dc/js--multi-line-declaration-indentation)

;; NOTE(doomchild):  This override fixes js-mode's decision to indent lines forward so that they're under opening parens from previous lines.  I have no idea why anyone would want that, especially if they live in an 80-characters-per-line world like a lot of UNIX dorks do.
(defun dc/js--proper-indentation (parse-status)
  "Return the proper indentation for the current line."
  (save-excursion
    (back-to-indentation)
    (cond ((nth 4 parse-status)    ; inside comment
           (js--get-c-offset 'c (nth 8 parse-status)))
          ((nth 3 parse-status) 0) ; inside string
          ((when (and js-jsx-syntax (not js-jsx--indent-col))
             (save-excursion (js-jsx--indentation parse-status))))
          ((eq (char-after) ?#) 0)
          ((save-excursion (js--beginning-of-macro)) 4)
          ;; Indent array comprehension continuation lines specially.
          ((let ((bracket (nth 1 parse-status))
                 beg)
             (and bracket
                  (not (js--same-line bracket))
                  (setq beg (js--indent-in-array-comp bracket))
                  ;; At or after the first loop?
                  (>= (point) beg)
                  (js--array-comp-indentation bracket beg))))
          ((js--chained-expression-p))
          ((js--ctrl-statement-indentation))
          ((js--multi-line-declaration-indentation))
          ((nth 1 parse-status)
           (let ((same-indent-p (looking-at "[]})]"))
                 (switch-keyword-p (looking-at "default\\_>\\|case\\_>[^:]"))
                 (continued-expr-p (js--continued-expression-p))
                 (depth (length (nth 9 parse-status))))
             (goto-char (nth 1 parse-status)) ; go to the opening char
             (if (or (not js-indent-align-list-continuation)
                     (looking-at "[({[]\\s-*\\(/[/*]\\|$\\)")
                     (save-excursion (forward-char) (js--broken-arrow-terminates-line-p)))
                 (progn ; nothing following the opening paren/bracket
                   (skip-syntax-backward " ")
                   (when (eq (char-before) ?\)) (backward-list))
                   (back-to-indentation)
                   (js--maybe-goto-declaration-keyword-end parse-status)
                   (let* ((in-switch-p (unless same-indent-p
                                         (looking-at "\\_<switch\\_>")))
                          (same-indent-p (or same-indent-p
                                             (and switch-keyword-p
                                                  in-switch-p)))
                          (indent
                           (+
                            (cond
                             ((and js-jsx--indent-attribute-line
                                   (eq js-jsx--indent-attribute-line
                                       (line-number-at-pos)))
                              js-jsx--indent-col)
                             (t
                              (current-column)))
                            (cond (same-indent-p 0)
                                  (continued-expr-p
                                   (+ (* 2 js-indent-level)
                                      js-expr-indent-offset))
                                  (t
                                   (+ js-indent-level
                                      (pcase (char-after (nth 1 parse-status))
                                        (?\( js-paren-indent-offset)
                                        (?\[ js-square-indent-offset)
                                        (?\{ js-curly-indent-offset))))))))
                     (if in-switch-p
                         (+ indent js-switch-indent-offset)
                       indent)))
               ;; If there is something following the opening
               ;; paren/bracket, everything else should be indented at
               ;; the same level.
               (unless same-indent-p
                 (forward-char)
                 (skip-chars-forward " \t"))
               (+ js-indent-level (* js-indent-level depth)))))

          ((js--continued-expression-p)
           (+ js-indent-level js-expr-indent-offset))
          (t (prog-first-column)))))

(advice-add 'js--proper-indentation :override #'dc/js--proper-indentation)

(defun dc/minify-js-buffer-contents()
  "Minifies the buffer contents by removing whitespaces."
  (interactive)
  (delete-whitespace-rectangle (point-min) (point-max))
  (mark-whole-buffer)
  (goto-char (point-min))
  (while (search-forward "\n" nil t) (replace-match "" nil t)))

(defun dc/json-to-single-line (beg end)
  "Collapse prettified json in region between BEG and END to a single line."
  (interactive "r")
  (if (use-region-p)
      (save-excursion
        (save-restriction
          (narrow-to-region beg end)
          (goto-char (point-min))
          (while (re-search-forward "\\s-+\\|\n" nil t)
            (replace-match ""))))
    (print "This function operates on a region")))

(provide 'module-javascript)

;;; module-javascript.el ends here
