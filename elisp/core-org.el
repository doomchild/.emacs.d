;;; -*- lexical-binding: t; -*-
;;; Org

(use-package org
  :ensure t
  :init
  (add-hook 'org-mode-hook #'yas-minor-mode-on)
  (add-hook 'org-babel-after-execute-hook #'org-redisplay-inline-images)
  :config
  (setq org-edit-src-content-indentation 0)
  (org-babel-do-load-languages 'org-babel-load-languages '((dot . t))))

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
