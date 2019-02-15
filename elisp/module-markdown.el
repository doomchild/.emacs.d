;;; -*- lexical-binding: t; -*-
;;; Markdown support

(use-package markdown-mode
  :delight markdown-mode "Markdown"
  :commands (markdown-mode)
  :mode ("CONTRIBUTORS\\'"
	 "INSTALL\\'"
	 "LICENSE\\'"
	 "README\\'"
	 "\\.markdown\\'"
	 "\\.md\\'")
  :config (add-hook 'yas-minor-mode-on markdown-mode-hook))

(provide 'module-markdown)
