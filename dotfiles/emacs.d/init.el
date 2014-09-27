;; Determine the OS Environment
(setq windows (or (eq system-type 'windows-nt)
                  (eq system-type 'cygwin)
                  (eq system-type 'ms-dos)))

;; Create a pidfile for the running emacs process
(setq pidfile "~/.tmp/emacs.pid")
(add-hook 'emacs-startup-hook
          (lambda ()
            (with-temp-file pidfile
              (insert (number-to-string (emacs-pid))))))
(add-hook 'kill-emacs-hook
          (lambda ()
            (when (file-exists-p pidfile)
              (delete-file pidfile))))

;; Set Default Encoding
(set-language-environment "utf-8")

;; Setup List of Packages
(require 'package)
(package-initialize)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

;; Download Required Packages
(require 'cl)
(defvar packages
  '(ace-jump-mode
    doctags
    yasnippet-bundle
    el-autoyas
    go-mode
    haskell-mode
    helm-c-yasnippet
    markdown-mode
    yas-jit
    workgroups
    zenburn-theme))

(defun packages-installed-p ()
  (loop for p in packages
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))

(unless (packages-installed-p)
  (package-refresh-contents)
  (dolist (p packages)
    (when (not (package-installed-p p))
      (package-install p))))

;; Use Zenburn Theme
(load-theme 'zenburn t)

;; Customize Window Decorators
(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)
(add-to-list 'default-frame-alist '(font . "Monospace-9"))
(when (not windows) (set-default-font "Monospace-9"))

;; Doctags
(require 'semantic)
(require 'doctags)
(define-key global-map (kbd "C-S-j") 'doctags-document-current-tag)

;; Tabs and Editing
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq whitespace-line-column 80)
(setq whitespace-style '(face tabs empty trailing lines-tail))
(global-whitespace-mode 1)

;; Parens Highlighting
(require 'paren)
(setq show-paren-style 'parenthesis)
(show-paren-mode +1)
(electric-pair-mode +1)

;; Prevent pause from breaking emacs
(define-key global-map (kbd "<pause>") 1)

;; Editing Configs
(setq gac-automatically-push-p t)

;; IDO
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-save-directory-list-file "~/.tmp/ido.last")
(ido-mode 1)

;; Yasnippet
(require 'yasnippet-bundle)
;;(yas-global-mode 1)

;; Ace-Jump Mode
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;; Setup Lisp and Slime
(setq slime-repl-history-file "~/.tmp/slime-history")
(if windows
    (setq inferior-lisp-program "wx86cl64")
  (setq inferior-lisp-program "sbcl"))
(when (file-exists-p "~/quicklisp/slime-helper.el")
  (load "~/quicklisp/slime-helper.el")
)

;; SSH with Tramp
(require 'tramp)
(setq tramp-default-user "william")
(if windows (setq tramp-default-method "plink"))

;; IRC
(require 'tls)

;; Haskell
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

;; Latex Stuff
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(setq TeX-PDF-mode t)

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'tex-mode-hook 'flyspell-mode)
(add-hook 'bibtex-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTex t)

;; Easy spell check
(add-hook 'flyspell-mode-hook 'flyspell-buffer)
(global-set-key (kbd "<f8>") 'ispell-word)

;; Treat 'y' or <CR> as yes, 'n' as no.
(fset 'yes-or-no-p 'y-or-n-p)
(define-key query-replace-map [return] 'act)
(define-key query-replace-map [?\C-m] 'act)

;; ORG
(require 'org-install)
(add-hook 'org-mode-hook 'flyspell-mode)
(add-hook 'org-mode-hook 'visual-line-mode)
(add-to-list 'auto-mode-alist '("README$" . org-mode))
(add-to-list 'auto-mode-alist '("TODO$" . org-mode))
;;(add-hook 'org-mode-hook 'org-indent-mode)

;; Disable symlink confirmation
(setq vc-follow-symlinks nil)

;; Load the local el file
(when (file-exists-p "~/.emacs.d/local.el")
  (load "~/.emacs.d/local.el"))

;; Workgroups
(require 'workgroups)
(workgroups-mode 1)
(setq wg-morph-on 'nil)
(setq wg-path "~/.emacs.d/workgroups")
(when (file-exists-p wg-path)
  (wg-load wg-path))

;; Indentation
(defun setup-sh-mode ()
  (interactive)
  (setq sh-basic-offset 2
        sh-indentation 2))
(add-hook 'sh-mode-hook 'setup-sh-mode)
