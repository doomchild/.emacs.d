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
   lsp-csharp-omnisharp-roslyn-server-dir (format "%s/lsp/omnisharp-roslyn/latest/omnisharp-roslyn" private-directory)
   lsp-csharp-omnisharp-roslyn-binary-path (format "%s/OmniSharp" lsp-csharp-omnisharp-roslyn-server-dir)))

(provide 'module-csharp)
