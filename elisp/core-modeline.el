;;; -*- lexical-binding: t; -*-
;;; Modeline

(use-package smart-mode-line-atom-one-dark-theme)
(use-package smart-mode-line
  :custom
  (sml/theme 'atom-one-dark)
  (sml/no-confirm-load-theme t)
  :config
  (sml/setup))

(provide 'core-modeline)
