;;; -*- lexical-binding: t; -*-
;;; Yaml

(use-package yaml-mode
  :mode "\\.yaml"
  :bind (:map yaml-mode-map
	      ("C-m" . 'newline-and-indent)))

(provide 'module-yaml)
