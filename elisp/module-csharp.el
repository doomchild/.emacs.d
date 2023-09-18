;;; -*- lexical-binding: t; -*-
;;; C#

(defvar dc/omnisharp-root-directory (format "%s/lsp/omnisharp-roslyn" private-directory))

(if (version<= emacs-version "29")
    (progn
      (defun dc/csharp-mode-hook ()
        (editorconfig-mode 1)
        (editorconfig-apply)
        (lsp))

      (use-package csharp-mode
        :demand t
        :mode "\\.cs\\'"
        :after company
        :config
        (add-hook 'dc/csharp-mode-hook #'lsp)

        (setq
         lsp-csharp-omnisharp-roslyn-server-dir dc/omnisharp-root-directory
         lsp-csharp-omnisharp-roslyn-binary-path (format "%s/OmniSharp" dc/omnisharp-root-directory))))
  (progn
    (defun dc/csharp-mode-hook ()
      (editorconfig-mode 1)
      (editorconfig-apply)
      (tree-sitter-hl-mode))

    (add-hook 'csharp-mode-hook #'dc/csharp-mode-hook)

    (with-eval-after-load 'eglot
      (let ((omnisharp-program-path (format "%s/OmniSharp" dc/omnisharp-root-directory)))
        (add-to-list 'eglot-server-programs `(csharp-mode ,(format "%s/lsp/omnisharp-roslyn/Omnisharp" private-directory) "-lsp" "-stdio"))
      )))
  )

(provide 'module-csharp)
