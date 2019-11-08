;;; -*- lexical-binding: t; -*-
;;; Python

(use-package python
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python3" . python-mode)
  :commands python-mode
  :init
  (add-hook 'python-mode-hook 'flycheck-mode)
  (setq python-shell-interpreter "python3"))

(use-package python-black
  :demand t
  :after python
  :init
  (setq python-black-on-save-mode t))

(use-package anaconda-mode
  :after python
  :init
  (add-hook 'python-mode-hook 'anaconda-mode)
  (add-hook 'python-mode-hook 'anaconda-eldoc-mode)
  (add-hook 'python-mode-hook 'eldoc-mode)

  (setq anaconda-mode-installation-directory (concat private-directory "/anaconda/")
	anaconda-mode-eldoc-as-single-line t))

(use-package company-anaconda
  :after anaconda-mode)

(provide 'module-python)
