;;; my-show-definitions.el --- Show the definitions in a buffer -*- lexical-binding: t -*-

;; Copyright (C) 2010-2018 Vitor Quintanilha Barbosa

;; Author: Vitor <vitorqb@gmail.com>
;; Version: 0.0.1
;; Maintainer: Vitor <vitorqb@gmail.com>
;; Created: 2019-02-27
;; Keywords: elisp
;; Homepage: https://github.com/vitorqb/my-show-definitions

;; This file is not part of GNU Emacs.

;; Do whatever you want. No warranties.

;;; code

(require 'cl)
(require 'dash)
(require 'dash-functional)

(defun my-show-definitions-flatten-imenu-index-alist (orig-lst)
  (cl-labels ((flatten (acc prfx todo)
                       (if (equal nil todo)
                           acc
                         (-let* (((el     . rest)    todo)
                                 ((el-car . el-cdr)  el))
                           (flatten
                            (if (listp el-cdr)
                                ;; el-cdr -> list, el-car -> Name
                                (append (flatten '() (concat el-car " - ") el-cdr) acc)
                              ;; el-cdr -> marker|number, el-car -> Name
                              (cons (cons (concat prfx el-car) el-cdr) acc))
                            prfx
                            rest)))))
    (reverse (flatten '() "" orig-lst))))

(defun my-show-definitions ()
  (interactive)
  (-let* ((number-lt-0? (-andfn (-rpartial '< 0) 'numberp))
          (definitions-alist (->> (imenu--make-index-alist)
                                  (my-show-definitions-flatten-imenu-index-alist)
                                  (-remove (-compose number-lt-0? #'cdr))))
          (old-buff (current-buffer))
          (row-prefix (-> old-buff
                          buffer-file-name
                          file-name-nondirectory
                          (concat ":")
                          (propertize 'invisible t)))
          (get-row (lambda (x) (with-current-buffer old-buff
                                 (line-number-at-pos x)))))
    (switch-to-buffer-other-window (generate-new-buffer "*MyShowDefinitions*"))
    (seq-do (lambda (x)
              (-let* (((name . marker-or-pos) x)                      
                      (row (funcall get-row marker-or-pos)))
                (insert row-prefix (number-to-string row) ":" name "\n")))
            definitions-alist)
    (grep-mode)))

(provide 'my-show-definitions)
;;; my-show-definitions.el ends here
