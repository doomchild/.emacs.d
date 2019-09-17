;;; -*- lexical-binding: t; -*-
;;; Base extensions

(use-package ace-window
  :commands ace-window
  :bind (("C-; w" . ace-window))
  :config (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package avy
  :commands (avy-goto-char avy-goto-line)
  :bind (("C-; c" . avy-goto-char)
          ("C-; l" . avy-goto-line))
  :config (setq avy-all-windows nil
            avy-background t))

(use-package awscli-capf
  :ensure t
  :commands (awscli-capf-add)
  :hook ((sh-mode . awscli-capf-add)
          (shell-mode . awscli-capf-add)))

(use-package csv-mode
  :config
  (setq-default csv-align-padding 2))

(use-package diminish)

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :demand t
  :config
  (exec-path-from-shell-initialize))

(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
          ("C->" . mc/mark-next-like-this)
          ("C-<" . mc/mark-previous-like-this)
          ("C-c C->" . mc/mark-all-like-this))
  :config (setq mc/lists-file (expand-file-name ".mc-lists.el" private-directory)))

(use-package popup-kill-ring
  :bind ("M-y" . popup-kill-ring))

(provide 'core-extensions)
