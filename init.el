(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

;; my packages
(defvar my-packages '(better-defaults paredit idle-highlight-mode
				     ido-ubiquitous
				     find-file-in-project magit
				     smex scpaste auto-complate
				     go-eldoc go-mode go-errcheck
				     go-scratch go-play popup))

;; install my packages
(package-initialize)
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; set line numbers to be on
(global-linum-mode t)

;go configuration
; pickup the path from the shell
(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))

; run gofmt on save
(setq exec-path (cons "/Users/rcameron/gopath/bin" exec-path))
(add-hook 'before-save-hook 'gofmt-before-save)

; set gopath
(setenv "GOPATH" "/Users/rcameron/gopath")
