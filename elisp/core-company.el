;;; -*- lexical-binding: t; -*-
;;; Company

(use-package company
  :bind (:map company-active-map
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous))
  :config
  (add-to-list 'company-backends 'company-omnisharp)
  (add-hook 'csharp-mode-hook 'company-mode))

(provide 'core-company)
