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

(use-package diminish)

(when (memq window-system '(mac ns x))
  (use-package exec-path-from-shell)
  (exec-path-from-shell-initialize))

(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
	 ("C->" . mc/mark-next-like-this)
	 ("C-<" . mc/mark-previous-like-this)
	 ("C-c C->" . mc/mark-all-like-this)))

(use-package popup-kill-ring
  :bind ("M-y" . popup-kill-ring))

(provide 'core-extensions)
