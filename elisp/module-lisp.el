;;; -*- lexical-binding: t; -*-
;;; Lisp

(use-package slime
  :defer t
  :config
  (setq
    inferior-lisp-program (executable-find "sbcl")
    slime-contribs '(slime-fancy)
    slime-net-coding-system 'utf-8-unix)
  (load (expand-file-name "~/quicklisp/slime-helper.el"))
  (add-hook 'slime-repl-mode-hook #'rainbow-delimiters-mode))

(provide 'module-lisp)
