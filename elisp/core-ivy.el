;;; -*- lexical-binding: t; -*-
;;; Ivy

(use-package ivy
  :demand t
  :diminish ivy-mode
  :bind (("<C-S-return>" . ivy-immediate-done))
  :config (ivy-mode 1))

(use-package counsel
  :demand t
  :diminish counsel-mode
  :bind (("M-x" . counsel-M-x)
	 ("C-x C-m" . counsel-M-x)
	 ("C-c C-m" . counsel-M-x)))

(use-package smex
  :custom (smex-save-file (format "%s/smex-items" private-directory)))

(use-package swiper
  :bind (("C-s" . swiper)))

(provide 'core-ivy)
