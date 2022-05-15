;;; -*- lexical-binding: t; -*-
;;; C#

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
    lsp-csharp-omnisharp-roslyn-store-path (format "%s/download/omnisharp-roslyn.zip" private-directory)
    lsp-csharp-omnisharp-roslyn-server-dir (format "%s/lsp/omnisharp-roslyn/latest/omnisharp-roslyn" private-directory)
    lsp-csharp-server-install-dir (format "%s/lsp/omnisharp-roslyn" private-directory)))

(provide 'module-csharp)
