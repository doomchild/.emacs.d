;;; -*- lexical-binding: t; -*-
;;; core-package

(require 'package)

(setq package-enable-at-startup nil)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("elpa" . "http://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

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
