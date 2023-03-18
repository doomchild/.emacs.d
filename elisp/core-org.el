;;; -*- lexical-binding: t; -*-
;;; Org

(use-package org
  :ensure t
  :config (add-hook 'yas-minor-mode-on org-mode-hook))

(use-package org-jira
  :ensure t
  :after org)

(use-package org-roam
  :ensure t
  :after org
  :custom
  (org-roam-directory "~/org-roam")
  :bind (("C-; n l" . org-roam-buffer-toggle)
         ("C-; n f" . org-roam-node-find)
         ("C-; n i" . org-roam-node-insert))
  :config
  (org-roam-setup))

(provide 'core-org)
