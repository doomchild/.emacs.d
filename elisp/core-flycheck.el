;;; -*- lexical-binding: t; -*-
;;; Flycheck=

(use-package flycheck
  :demand t
  :config
  (setq flycheck-javascript-eslint-executable "~/.nvm/versions/node/v10.15.3/bin/eslint")
  (add-hook 'csharp-mode-hook 'flycheck-mode)
  (add-hook 'markdown-mode-hook 'flycheck-mode)
  (add-hook 'yaml-mode-hook 'flycheck-mode)
  (add-hook 'js2-mode-hook 'flycheck-mode)

  (setq-default flycheck-disabled-checkers
    (append flycheck-disabled-checkers
      '(javascript-jshint json-jsonlist))))

(defun dc/shell-command-to-string (&rest cmd)
  (replace-regexp-in-string
   "\r?\n$"
   ""
   (shell-command-to-string (mapconcat 'identity cmd " "))))

(eval-after-load 'flycheck
  (setq
   flycheck-markdown-markdownlint-cli-config "~/.markdownlintrc"
   flycheck-markdown-markdownlint-cli-executable (dc/shell-command-to-string "which markdownlint")))

(provide 'core-flycheck)
