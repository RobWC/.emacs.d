(require 'package)
;; determine the system type

(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

;; windows specific stuff
(if (eq system-type 'windows-nt)
    (message "Loading Windows config...")
    (add-to-list 'exec-path "c:/Program\ Files/Git/Bin")
  
    (when (file-accessible-directory-p "c:/Users/rcameron")
      (setenv "GOPATH" "c:/Users/rcameron/Documents/Github/gopath")
      (add-to-list 'exec-path "c:/Users/rcameron/Documents/Github/gopath/bin")
      (add-to-list 'load-path "C:/Users/rcameron/Documents/Github/gopath/src/github.com/golang/lint/misc/emacs")
      (load-file  "C:/Users/rcameron/Documents/Github/gopath/src/golang.org/x/tools/cmd/oracle/oracle.el")
    )

    (when (file-accessible-directory-p "c:/Users/rwcam_000")
      (setenv "GOPATH" "c:/Users/rwcam_000/Documents/Github/gopath")
      (add-to-list 'exec-path "c:/Users/rwcam_000/Documents/Github/gopath")
      (add-to-list 'load-path "C:/Users/rwcam_000/Documents/Github/gopath/src/github.com/golang/lint/misc/emacs")
    )
  )

;; mac specific platform
(if (eq system-type 'darwin)
    (message "Loading Mac OS X config....")
  
    ; set gopath
    (setenv "GOPATH" "/Users/rcameron/gopath")
    (add-to-list 'exec-path "/usr/local/bin")
  )

(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

;; my packages
(defvar my-packages '(better-defaults paredit idle-highlight-mode ido-ubiquitous
                                     find-file-in-project magit neotree
				     smex scpaste monokai-theme yaml-mode slime
                                     auto-complete markdown-mode rainbow-delimiters
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

;; enable paredit
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(eldoc-add-command 'paredit-backward-delete 'paredit-close-round)
(add-hook 'slime-repl-mode-hook (lambda() (paredit-mode +1)))

;1; enable autocomplete
(ac-config-default)
(require 'auto-complete-config)

;; set line numbers to be on
(global-linum-mode t)

;; go configuration
(require 'golint)
(add-hook 'go-mode-hook 'go-eldoc-setup)
(setq gofmt-command "goimports")
; Call Gofmt before saving
(add-hook 'before-save-hook 'gofmt-before-save)

;; godef
(defun my-go-mode-hook ()
  ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump))
(add-hook 'go-mode-hook 'my-go-mode-hook)
