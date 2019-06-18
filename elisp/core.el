;;; -*- lexical-binding: t; -*-
;;; core settings

(defconst private-directory (expand-file-name "private" user-emacs-directory))
(defconst temporary-directory (format "%s/temp" private-directory)
  "Hostname-based elisp temp directory")

;;; Core settings
;;; UTF-8 or bust
(set-charset-priority 'unicode)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq
  locale-coding-system 'utf-8
  default-process-coding-system '(utf-8-unix . utf-8-unix))

;;; Emacs customizations
(setq
  custom-file "~/.emacs.d/custom.el"
  inhibit-startup-message t
  confirm-kill-emacs 'y-or-n-p
  delete-old-versions -1
  vc-make-backup-files nil
  default-buffer-file-coding-system 'utf-8
  gc-cons-threshold (* 100 1024 1024) ;; 100 MB
  ;; Allow font-lock-mode to do background parsing
  jit-lock-stealth-time 1
  jit-lock-chunk-size 1000
  jit-lock-defer-time 0.05
  gnutls-min-prime-bits 4096
  echo-keystrokes 0.2
  use-package-always-ensure t)

(when (file-exists-p custom-file)
  (load custom-file))

(defun package--save-selected-packages (&rest opt) nil)

;;; Backups
(setq
 auto-save-default nil
 create-lockfiles nil
 make-backup-files nil)

(fset 'yes-or-no-p 'y-or-n-p)
(tool-bar-mode -1)
(display-time-mode 1)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(provide 'core)
