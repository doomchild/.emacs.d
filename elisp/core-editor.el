;;; -*- lexical-binding: t; -*-
;;; Core editor packages

;; It's really irritating to select something only to have it not overwrite the region
(delete-selection-mode t)

;; No tabs.  EVER.
(setq-default indent-tabs-mode nil)

;; The most common kind of buffer I open is one for JSON manipulation, so that's the default buffer mode.
(setq-default major-mode 'json-mode)

(require 're-builder)
(setq reb-re-syntax 'string)

(setq-default display-fill-column-indicator-column 120)

(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

(use-package editorconfig
  :mode ("\\.?editorconfig$" . editorconfig-conf-mode)
  :config
  (setq editorconfig-exec-path "/usr/local/bin/editorconfig")
  (editorconfig-mode 1))

(when (and (version<= "29" emacs-version) (not (package-installed-p 'eglot)))
  (eglot-update))

(use-package highlight-indentation
  :hook
  ((python-mode . highlight-indentation-mode)
   (python-mode . highlight-indentation-current-column-mode)
   (yaml-mode . highlight-indentation-mode)
   (yaml-mode . highlight-indentation-current-column-mode)))

(when (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode))

(use-package magit)

(use-package origami
  :bind (:map origami-mode-map
	      ("C-; C-o t" . origami-recursively-toggle-node)
	      ("C-; C-o o" . origami-show-only-node)
	      ("C-; C-o r" . origami-reset))
  :hook ((prog-mode . origami-mode)))

(use-package projectile
  :bind (:map projectile-mode-map
              ("C-; p" . projectile-command-map))
  :custom
  (projectile-completion-system 'ivy)
  (projectile-known-projects-file (expand-file-name "projectile-bookmarks.eld" temporary-directory))
  (projectile-project-search-path '("~/code"))
  :hook ((prog-mode . projectile-mode)))

(use-package rainbow-delimiters
  :commands rainbow-delimiters-mode
  :hook (prog-mode . rainbow-delimiters-mode)
  :config (setq rainbow-delimiters-max-face-count 3))

(use-package treemacs
    :bind
  (:map global-map
        ("C-; C-t t" . treemacs)
        ("C-; C-t 0" . treemacs-select-window)
        ("C-; C-t C-f" . treemacs-find-file))
  :custom
  (treemacs-width 50)
  (treemacs-git-mode 'deferred)
  (treemacs-persist-file (expand-file-name "treemacs-persist" private-directory))
  (treemacs-hide-gitignored-files-mode nil))

(use-package treemacs-projectile
    :after (treemacs projectile)
    :ensure t)

;; These functions were shamelessly ripped from DOOM Emacs
(defun dc/yas-goto-start-of-field ()
  "Go to the beginning of a field"
  (interactive)
  (let* ((snippet (car (yas--snippets-at-point)))
	       (position (yas--field-start (yas--snippet-active-field snippet))))
    (if (= (point) position)
	      (move-beginning-of-line 1)
      (goto-char position))))

(defun dc/yas-goto-end-of-field ()
  (interactive)
  (let* ((snippet (car (yas--snippets-at-point)))
         (position (yas--field-end (yas--snippet-active-field snippet))))
    (if (= (point) position)
        (move-end-of-line 1)
      (goto-char position))))

(defun dc/yas-delete (&optional field)
  (interactive)
  (let ((field (or field (and yas--active-field-overlay
                              (overlay-buffer yas--active-field-overlay)
                              (overlay-get yas--active-field-overlay 'yas--field)))))
    (cond ((and field
                (not (yas--field-modified-p field))
                (eq (point) (marker-position (yas--field-start field))))
           (yas--skip-and-clear field)
           (yas-next-field 1))
          ((eq (point) (marker-position (yas--field-end field))) nil)
          (t (delete-char 1)))))

(use-package yasnippet
  :mode ("emacs\\.d/private/\\(snippets\\|templates\\)/.+$" . snippet-mode)
  :commands (yas-minor-mode
	     yas-minor-mode-on
	     yas-expand
	     yas-insert-snippet
	     yas-new-snippet
	     yas-visit-snippet-file)
  :init
  (defvar yas-minor-mode-map (make-sparse-keymap))
  (setq yas-verbosity 0
	yas-fallback-behavior 'call-other-command
	yas-indent-line 'auto
	yas-also-auto-indent-first-line t
	yas-snippet-dirs (list (concat user-emacs-directory "snippets")))

  (yas-global-mode 1)

  (add-hook 'emacs-lisp-mode-hook
	    (let ((original-action (lookup-key emacs-lisp-mode-map [tab])))
	     `(lambda ()
	        (setq yas/fallback-behavior
		      '(apply ,original-action))
	        (local-set-key [tab] 'yas-expand))))

  :bind (:map yas-keymap
	      ("C-e" . dc/yas-goto-end-of-field)
	      ("C-a" . dc/yas-goto-start-of-field)
	      ("<S-tab>" . yas-prev-field)
	      ("<M-backspace>" . dc/yas-clear-to-sof)
	      ("<delete>" . dc/yas-delete)))

(provide 'core-editor)
