;;; -*- lexical-binding: t; -*-
;;; C++

(defun c++-mode-ggtags-hook ()
  (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
    (ggtags-mode 1)))

(use-package ggtags
  :demand t
  :bind (:map ggtags-mode-map
	      ("C-c g s" . 'ggtags-find-other-symbol)
	      ("C-c g h" . 'ggtags-view-tag-history)
	      ("C-c g r" . 'ggtags-find-reference)
	      ("C-c g f" . 'ggtags-find-file)
	      ("C-c g c" . 'ggtags-create-tags)
	      ("C-c g u" . 'ggtags-update-tags)
	      ("M-," . 'pop-tag-mark))
  :config
  (add-hook 'c-mode-common-hook #'c++-mode-ggtags-hook)
  (setq-local imenu-create-index-function #'ggtags-build-imenu-index))

(require 'cc-mode)
(require 'semantic)

(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)

(setq c-default-style "bsd")

(semantic-mode 1)

(provide 'module-c++)
