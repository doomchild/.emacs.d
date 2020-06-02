;;; -*- lexical-binding: t; -*-
;;; Flycheck=

(defun dc/shell-command-to-string (&rest cmd)
  (replace-regexp-in-string
   "\r?\n$"
   ""
   (shell-command-to-string (mapconcat 'identity cmd " "))))

(use-package flycheck
  :demand t
  :config
  (setq flycheck-javascript-eslint-executable (dc/shell-command-to-string "which eslint"))
  (add-hook 'csharp-mode-hook 'flycheck-mode)
  (add-hook 'markdown-mode-hook 'flycheck-mode)
  (add-hook 'yaml-mode-hook 'flycheck-mode)
  (add-hook 'js2-mode-hook 'flycheck-mode)

  (setq-default flycheck-disabled-checkers
    (append flycheck-disabled-checkers
      '(javascript-jshint json-jsonlist))))

(eval-after-load 'flycheck
  (setq
   flycheck-markdown-markdownlint-cli-config "~/.markdownlintrc"
   flycheck-markdown-markdownlint-cli-executable (dc/shell-command-to-string "which markdownlint")))

(provide 'core-flycheck)
