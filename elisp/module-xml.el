;;; -*- lexical-binding: t; -*-
;;; XML

(defun xml-pretty-print (beg end &optional arg)
  "Reformat the region between BEG and END.
    With optional ARG, also auto-fill."
  (interactive "*r\nP")
  (let ((fill (or (bound-and-true-p auto-fill-function) -1)))
    (sgml-mode)
    (when arg (auto-fill-mode))
    (sgml-pretty-print beg end)
    (nxml-mode)
    (auto-fill-mode fill)))

(setq nxml-slash-auto-complete-flag t)

(provide 'module-xml)
