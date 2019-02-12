;;; -*- lexical-binding: t; -*-
;;; Ivy

(use-package ivy
  :demand t
  :diminish ivy-mode
  :config (ivy-mode 1))

(use-package counsel
  :demand t
  :diminish counsel-mode
  :bind (("M-x" . counsel-M-x)
	 ("C-x C-m" . counsel-M-x)
	 ("C-c C-m" . counsel-M-x)))

(use-package smex
  :custom (smex-save-file (format "%s/smex-items" private-directory)))

(use-package swiper)

(provide 'core-ivy)
