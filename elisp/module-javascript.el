;;; -*- lexical-binding: t; -*-
;;; C#

(use-package js2-mode
  :mode "\\.js$")

(use-package json-mode
  :mode "\\.json$")

(defun json-to-single-line (beg end)
  "Collapse prettified json in region between BEG and END to a single line"
  (interactive "r")
  (if (use-region-p)
      (save-excursion
        (save-restriction
          (narrow-to-region beg end)
          (goto-char (point-min))
          (while (re-search-forward "\\s-+\\|\n" nil t)
            (replace-match ""))))
    (print "This function operates on a region")))

(provide 'module-javascript)
