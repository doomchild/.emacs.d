;;; -*- lexical-binding: t; -*-
;;; Docker support

(use-package dockerfile-mode
  :delight dockerfile-mode "Dockerfile"
  :mode "Dockerfile\\'")

(use-package docker-compose-mode)

(provide 'module-docker)
