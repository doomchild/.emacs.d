;;; -*- lexical-binding: t; -*-
;;; Company

;taken from https://gist.github.com/rswgnu/85ca5c69bb26551f3f27500855893dbe
(defun dc/company-complete ()
    "Insert the common part of all candidates or the current selection.
The first time this is called, the common part is inserted, the second
time, or when the selection has been changed, the selected candidate is
inserted."
    (interactive)
    (if company-mode
        (when (company-manual-begin)
          (if (or company-selection-changed
                  (eq last-command 'company-complete-common))
              (call-interactively 'company-complete-selection)
            (call-interactively 'company-complete-common)
            (setq this-command 'company-complete-common)))
      (completion-at-point)))

;taken from https://github.com/company-mode/company-mode/issues/614#issuecomment-261835950
(defun dc/company-stop-input-and-space ()
  "Stop completing and input a space,a workaround of a semantic issue `https://github.com/company-mode/company-mode/issues/614'"
  (interactive)
  (company-abort)
  (insert " "))

(use-package company-tern
  :demand t
  :bind (:map tern-mode-keymap
          ("M-." . nil)
          ("M-," . nil)))

(use-package company-c-headers
  :demand t
  :config
  (add-to-list 'company-c-headers-path-system "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/c++/4.2.1"))

(use-package company
  :bind (:map company-active-map
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
          ("<tab>" . dc/company-complete)
	  ("<space>" . dc/company-stop-input-and-space))
  :config
  (setq company-dabbrev-downcase nil)
  (setq company-idle-delay 0.2)
  (setq company-backends (delete 'company-semantic company-backends))
  (add-to-list 'company-backends 'company-c-headers)
  (add-to-list 'company-backends 'company-omnisharp)
  (add-hook 'csharp-mode-hook 'company-mode)
  (add-hook 'c-mode-common-hook 'company-mode))

(provide 'core-company)
