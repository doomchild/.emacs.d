;;; -*- lexical-binding: t; -*-
;;; Font Stuff

(defun dc/server-font-hook ()
  (when (member "Inconsolata for Powerline" (font-family-list))
    (set-face-attribute 'default nil :font "Inconsolata for Powerline" :height 160))
  (remove-hook 'server-after-make-frame-hook #'dc/server-font-hook))

(add-hook 'server-after-make-frame-hook #'dc/server-font-hook)

(if (not (daemonp))
    (when (member "Inconsolata for Powerline" (font-family-list))
      (set-face-attribute 'default nil :font "Inconsolata for Powerline" :height 160)))

(provide 'core-font)
