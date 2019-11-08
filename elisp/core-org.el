;;; -*- lexical-binding: t; -*-
;;; Org

(use-package org
  :ensure t
  :config (add-hook 'yas-minor-mode-on org-mode-hook))

(use-package org-jira
  :ensure t
  :after org)

(provide 'core-org)
