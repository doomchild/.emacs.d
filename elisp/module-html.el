;;; -*- lexical-binding: t; -*-
;;; HTML

(use-package sgml-mode
  :delight html-mode "HTML"
  :preface
  (defun me/html-set-pretty-print-function ()
    (setq me/pretty-print-function #'sgml-pretty-print))
  :hook
  ((html-mode . me/html-set-pretty-print-function)
   (html-mode . sgml-electric-tag-pair-mode)
   (html-mode . sgml-name-8bit-mode)
   (html-mode . toggle-truncate-lines))
  :config (setq-default sgml-basic-offset 2))

(provide 'module-html)
