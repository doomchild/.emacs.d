;;; -*- lexical-binding: t; -*-
;;; GodotScript

(use-package gdscript-mode
  :ensure t
  :hook (gdscript-mode . eglot-ensure)
  :after eglot
  :config
  (require 'seq)

  (with-eval-after-load 'eglot
    (let ((filtered-servers (seq-filter (lambda (cell) (not (equal (car cell) 'gdscript-mode))) eglot-server-programs)))
      (setq eglot-server-programs filtered-servers)
      (add-to-list 'eglot-server-programs '(gdscript-mode "localhost" 6008))))
  :custom
  (gdscript-eglot-version 3)
  (gdscript-godot-executable "/Applications/Godot_mono.app/Contents/MacOS/Godot"))

;; (with-eval-after-load 'eglot
;;   (let ((filtered-servers (seq-filter (lambda (cell)
;;   (setq eglot-server-programs (seq-filter (lambda (cell) (not (equal (car cell) 'gdscript-mode)))))
;;   (add-to-list 'eglot-server-programs '(gdscript-mode "localhost" 6008)))

(provide 'module-godot)
