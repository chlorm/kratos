; ---------------------------
;     Syntax Highlighting
; ---------------------------
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'monokai t)

; ---------------------------
;        Line Numbers
; ---------------------------
(global-linum-mode 1)
(setq linum-format " %d ") ; Pad space around numbers

(column-number-mode 1)

(setq default-frame-alist
      (append default-frame-alist
       '((foreground-color . "Black")
 (background-color . "White")
 (cursor-color . "SkyBlue")
 )))