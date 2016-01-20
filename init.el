;; determine the system type

(if (eq system-name 'windows-nt)
    (print 'Welcome to Windows)
    (setenv "GOPATH" "C:\\Users\\rcameron\\Documents\\Github\\gopath")
  )

(if (eq system-name 'darwin)
    (print 'MACTOWN)
    ; set gopath
    (setenv "GOPATH" "/Users/rcameron/gopath")
  )

(require 'package)

(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

;; my packages
(defvar my-packages '(better-defaults paredit idle-highlight-mode ido-ubiquitous find-file-in-project ;;magit
				     smex scpaste monokai-theme
                                     auto-complete
                                     go-autocomplete go-eldoc go-mode go-errcheck
                                     go-scratch go-play
                                     popup))

(package-initialize)
;; install my packages
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; initalize packages
(dolist (p my-packages)
  (require p))

;; set theme
(load-theme 'monokai t)

;; set line numbers to be on
(global-linum-mode t)

;; go configuration
;; pickup the path from the shell
;(defun set-exec-path-from-shell-PATH ()
;  (let ((path-from-shell (replace-regexp-in-string
;                          "[ \t\n]*$"
;                          ""
;                         (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
;   (setenv "PATH" path-from-shell)
;   (setq eshell-path-env path-from-shell) ; for eshell users
;   (setq exec-path (split-string path-from-shell path-separator))))

;when window-system (set-exec-path-from-shell-PATH))

; run gofmt on save
;(setq exec-path (cons "/Users/rcameron/gopath/bin" exec-path))
;(add-hook 'before-save-hook 'gofmt-before-save)


;; run gofmt on save


;; godef
;; (defun my-go-mode-hook ()
  ; Call gofmt before savingb
  ; (add-hook 'before-save-hook 'gofmt-before-save)
  ; Godef jump key binding
  ;(local-set-key (kbd "M-.") 'godef-jump))

;(add-hook 'go-mode-hook 'my-go-mode-hook)
