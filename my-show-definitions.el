;;; my-show-definitions.el --- Show the definitions in a buffer -*- lexical-binding: t -*-

;; Copyright (C) 2010-2018 Vitor Quintanilha Barbosa

;; Author: Vitor <vitorqb@gmail.com>
;; Version: 0.0.1
;; Maintainer: Vitor <vitorqb@gmail.com>
;; Created: 2018-10-28
;; Keywords: elisp
;; Homepage: https://github.com/vitorqb/mylisputils/blob/development/mylisputils.el

;; This file is not part of GNU Emacs.

;; Do whatever you want. No warranties.

;;; code

(require 'cl)
(require 'dash)
(require 'dash-functional)

(defun my-show-definitions-flatten-imenu-index-alist (orig-lst)
  (cl-labels
      ((flatten (acc prfx lst)
                (if (equal nil lst)
                    acc
                  (-let* (((el     . rest)    lst)
                          ((el-car . el-cdr)  el))
                    (if (not (listp el-cdr))
                        (flatten
                         (cons (cons (concat prfx el-car) el-cdr) acc)
                         prfx rest)
                      (flatten
                       (append (flatten '() (concat el-car " - ") el-cdr) acc)
                       prfx
                       rest))))))
    (reverse (flatten '() "" orig-lst))))

(defun my-show-definitions ()
  (interactive)
  (-let* ((definitions-alist (->> (imenu--make-index-alist)
                                  (my-show-definitions-flatten-imenu-index-alist)
                                  (-remove (lambda (x) (--> x
                                                            (cdr it)
                                                            (and (numberp it)
                                                                 (< it 0)))))))
          (old-buff (current-buffer))
          (buff (generate-new-buffer "*MyShowDefinitions*")))
    (switch-to-buffer-other-window buff)
    (insert "Matches\n")
    (seq-do
     (lambda (x)
       (insert (file-name-nondirectory (buffer-file-name old-buff)) ":")
       (-let [(name . marker-or-pos) x]
         (insert (number-to-string
                  (if (markerp marker-or-pos)
                      (--> marker-or-pos
                           (marker-position it)
                           (with-current-buffer old-buff
                             (line-number-at-pos it)))
                    marker-or-pos)))
         (insert ":" name)
         (insert "\n")))
     definitions-alist)
    (grep-mode)))

(provide 'my-show-definitions)
;;; my-show-definitions.el ends here
