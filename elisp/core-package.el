;;; -*- lexical-binding: t; -*-
;;; core-package

(require 'package)

(setq package-enable-at-startup nil)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

;;Prevent saving user-selected packages into ~/.emacs.d/custom.el
(defun package--saved-selected-packages (&option VALUE opt)
  nil)

(use-package s
  :demand t)

(use-package f
  :demand t)

(provide 'core-package)
