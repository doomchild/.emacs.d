;;; -*- lexical-binding: t; -*-
;;; Font Stuff

(when (member "Inconsolata for Powerline" (font-family-list))
  (set-face-attribute 'default nil :font "Inconsolata for Powerline" :height 160))

(provide 'core-font)
