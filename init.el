(require 'package)
;; determine the system type

(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

(when (not package-archive-contents)
  (package-refresh-contents))

(load-file (expand-file-name "~/.emacs.d/elpa/go-mode-20151226.1224/go-mode.el"))
(load-file (expand-file-name "~/.emacs.d/elpa/go-mode-20151226.1224/go-mode-autoloads.el"))

;; set the default to unix line endings
(set-buffer-file-coding-system 'utf-8-unix)

;; Windows specific stuff
(when (string-equal system-type "windows-nt")
  ;;
  ;; Pro-tip - some modules may not use the exec path, set the windows PATH correctly as well
  ;;
  ;;
  ;; Window tools
  ;; GNU Diff Utils - http://gnuwin32.sourceforge.net/packages/diffutils.htm
  
  ;; setup tls trust files
  (setq gnutls-trustfiles (expand-file-name "~/.emacs.d/certs/cacert.pem"))
  (message "Loading Windows config...")
  
    (when (file-accessible-directory-p "c:/Users/rcameron")
      ;; setup exec path
      (setq exec-path '(
                        "C:/Program Files/Git/Bin"
                        "C:/Users/rcameron/Documents/Github/gopath/bin"
                        "C:/Program Files/Emacs/bin"
                        "C:/Program Files (x86)/GnuWin32/bin"
                        ))
      (setenv "GOPATH" "c:/Users/rcameron/Documents/Github/gopath")
      (add-to-list 'load-path "C:/Users/rcameron/Documents/GitHub/gopath/src/github.com/golang/lint/misc/emacs")
      (add-to-list 'load-path "C:/Users/rcameron/Documents/Github/gopath/src/github.com/dougm/goflymake")
      (load-file  "C:/Users/rcameron/Documents/Github/gopath/src/golang.org/x/tools/cmd/oracle/oracle.el")
     ) 

    (when (file-accessible-directory-p "c:/Users/rwcam_000")

      (message "Welcome home!")
      ;; setup exec path
      (setq exec-path '(
                        "C:/Program Files/Git/Bin"
                        "C:/Users/rwcam_000/Documents/Github/gopath/bin"
                        "C:/Program Files/Emacs/bin"
                        "C:/Program Files (x86)/GnuWin32/bin"
                        ))

      (setenv "GOPATH" "c:/Users/rwcam_000/Documents/Github/gopath")
      (add-to-list 'load-path "C:/Users/rwcam_000/Documents/Github/gopath/src/github.com/golang/lint/misc/emacs")
      (add-to-list 'load-path "C:/Users/rwcam_000/Documents/Github/gopath/src/github.com/dougm/goflymake")
      (load-file "C:/Users/rwcam_000/Documents/Github/gopath/src/golang.org/x/tools/cmd/oracle/oracle.el")
      
      ))

;; mac specific platform
(when (string-equal system-type 'darwin)
    (message "Loading Mac OS X config....")

    (setq exec-path '(
		      "/bin"
		      "/usr/bin"
                      "/usr/local/bin"
                      "/Users/rcameron/gopath/bin"
                     ))
  
    ; set gopath
    (setenv "GOPATH" "/Users/rcameron/gopath")
    (add-to-list 'load-path "/Users/rcameron/gopath/src/github.com/golang/lint/misc/emacs")
    (add-to-list 'load-path "/Users/rcameron/gopath/src/github.com/dougm/goflymake")
    (load-file "/Users/rcameron/gopath/src/golang.org/x/tools/cmd/oracle/oracle.el") 
  )

(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))


;; my packages
(defvar my-packages '(better-defaults paredit idle-highlight-mode ido-ubiquitous
                                     exec-path-from-shell find-file-in-project magit neotree
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

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

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
;;(eldoc-add-command 'paredit-backward-delete 'paredit-close-round)
(add-hook 'slime-repl-mode-hook (lambda() (paredit-mode +1)))

;1; enable autocomplete
(ac-config-default)
(require 'auto-complete-config)

;; set line numbers to be on
(global-linum-mode t)

;; helper functions
(defun unix-file ()
  "Change the current buffer to Latin 1 with Unix line-ends."
  (interactive)
  (set-buffer-file-coding-system 'utf-8-unix t))

(defun dos-file ()
  "Change the current buffer to Latin 1 with DOS line-ends."
  (interactive)
  (set-buffer-file-coding-system 'utf-8-dos t))

(defun mac-file ()
  "Change the current buffer to Latin 1 with Mac line-ends."
  (interactive)
  (set-buffer-file-coding-system 'utf-8-mac t))
;; go configuration

;; Tools to install
;; go get -u github.com/dougm/goflymake
;; go get -u github.com/golang/lint/golint
;; go get -u golang.org/x/tools/cmd/goimports
;; go get -u github.com/kisielk/errcheck

(require 'go-mode-autoloads)
(require 'golint)
(require 'go-eldoc)
(require 'go-autocomplete)
(require 'go-flymake)

(defun my-go-mode-hook ()
  ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  ; Call Gofmt before saving
  (add-hook 'go-mode-hook 'go-eldoc-setup)
  (add-hook 'before-save-hook 'gofmt-before-save)
  (add-hook 'before-save-hook 'golint)
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump))
(add-hook 'go-mode-hook 'my-go-mode-hook)

;; starup config
(setq inhibit-startup-message t)
(desktop-save-mode 1)
(dired "~/")
