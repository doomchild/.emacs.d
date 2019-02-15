;;; -*- lexical-binding: t; -*-
;;; main init

(defconst emacs-start-time (current-time))

(add-to-list 'load-path (concat user-emacs-directory "elisp"))

(require 'core)
(require 'core-package)
(require 'core-extensions)
(require 'core-font)
(require 'core-theme)
(require 'core-modeline)
(require 'core-ivy)
(require 'core-editor)
(require 'core-company)
(require 'core-flycheck)
(require 'module-cloudformation)
(require 'module-csharp)
(require 'module-docker)
(require 'module-html)
(require 'module-lisp)
(require 'module-markdown)
(require 'module-yaml)

(let ((elapsed (float-time (time-subtract (current-time) emacs-start-time))))
  (message "Loaded configuration in %.3fs" elapsed))
