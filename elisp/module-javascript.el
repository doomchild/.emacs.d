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
  :mode "\\.json$"
  :config
  (add-hook 'json-mode-hook #'dc/json-mode-hook))

(defun dc/js2-mode-hook ()
  (add-hook 'js-mode-hook #'add-node-modules-path)
  (js2-refactor-mode)
  (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)
  (company-mode)
  (electric-pair-mode)
  (editorconfig-mode 1)
  (editorconfig-apply)
  (lsp))

(use-package js2-mode
  :mode "\\.js$"
  :after (js-doc js2-refactor xref-js2 lsp)
  :bind (:map js2-mode-map
	  ("<tab>"  . js2-indent-bounce)
	  ("<backtab>" . js2-indent-bounce-backward)
          ("\C-ci" . js-doc-insert-function-doc)
          ("@" . js-doc-insert-tag)
          ("C-k" . js2r-kill)
          :map js-mode-map
          ("M-." . nil))
  :config
  (setq js-indent-level 2)
  (setq js-switch-indent-offset 2)
  (setq js2-basic-offset 2)
  (setq js2-bounce-indent-p t)
  (setq lsp-eslint-library-choices-file (format "%s/.lsp-eslint-choices" temporary-directory))
  (add-hook 'js2-mode-hook #'js2-refactor-mode)
  (add-hook 'js2-mode-hook #'dc/js2-mode-hook))

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
