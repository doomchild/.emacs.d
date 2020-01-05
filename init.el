;;; -*- lexical-binding: t; -*-
;;; main init

(defconst emacs-start-time (current-time))

(add-to-list 'load-path (concat user-emacs-directory "elisp"))

(require 'core)
;(require 'core-permissions)
(require 'core-package)
(require 'core-extensions)
(require 'core-font)
(require 'core-theme)
(require 'core-modeline)
(require 'core-org)
(require 'core-ivy)
(require 'core-editor)
(require 'core-company)
(require 'core-flycheck)
(require 'module-c++)
(require 'module-cloudformation)
(require 'module-csharp)
(require 'module-docker)
(require 'module-html)
(require 'module-javascript)
(require 'module-lisp)
(require 'module-markdown)
(require 'module-python)
(require 'module-yaml)
(require 'module-xml)

(if (file-readable-p (concat user-emacs-directory (file-name-as-directory "private") "private.el"))
  (load-file (concat user-emacs-directory (file-name-as-directory "private") "private.el")))

(let ((elapsed (float-time (time-subtract (current-time) emacs-start-time))))
  (message "Loaded configuration in %.3fs" elapsed))
