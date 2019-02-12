;;; -*- lexical-binding: t; -*-
;;; Flycheck

(use-package flycheck
  :config
  (add-hook 'csharp-mode-hook 'flycheck-mode)
  (add-hook 'markdown-mode-hook 'flycheck-mode)
  (add-hook 'yaml-mode-hook 'flycheck-mode))

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
