;;; -*- lexical-binding: t; -*-
;;; Javascript and JSON

(use-package js-doc
  :demand t)

(use-package js2-refactor
  :demand t
  :config
  (js2r-add-keybindings-with-prefix "C-; C-r"))

(use-package xref-js2
  :demand t)

(use-package json-mode
  :mode "\\.json$")

(defun dc/js2-mode-hook ()
  (js2-refactor-mode)
  (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)
  (tern-mode)
  (company-mode)
  (electric-pair-mode)
  (editorconfig-mode 1))

(use-package js2-mode
  :mode "\\.js$"
  :after (js-doc js2-refactor xref-js2)
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
  (setq tern-command (append tern-command '("--no-port-file")))
  (add-hook 'js2-mode-hook #'js2-refactor-mode)
  (add-hook 'js2-mode-hook #'dc/js2-mode-hook))

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
