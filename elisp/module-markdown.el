;;; -*- lexical-binding: t; -*-
;;; Markdown support

(use-package markdown-mode
  :commands (markdown-mode)
  :mode "\\.md"
  :config (add-hook 'yas-minor-mode-on markdown-mode-hook))

(provide 'module-markdown)
