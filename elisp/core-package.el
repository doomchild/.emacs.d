;;; -*- lexical-binding: t; -*-
;;; core-package

(require 'package)

(setq package-enable-at-startup nil
      package-install-upgrade-builtin t)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("elpa" . "http://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

;;Prevent saving user-selected packages into ~/.emacs.d/custom.el
(defun package--saved-selected-packages (&option VALUE opt)
  nil)

(use-package dash
  :ensure t
  :demand t)

(use-package s
  :ensure t
  :demand t)

(use-package f
  :ensure t
  :demand t)

(provide 'core-package)
