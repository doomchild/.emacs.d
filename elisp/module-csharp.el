;;; -*- lexical-binding: t; -*-
;;; C#

(use-package csharp-mode
  :demand t
  :mode "\\.cs$")

(use-package omnisharp
  :bind (:map omnisharp-mode-map
	      ("." . omnisharp-add-dot-and-auto-complete))
  :config (add-hook 'csharp-mode-hook 'omnisharp-mode))

(provide 'module-csharp)
