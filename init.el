(require 'package)
;; determine the system type

(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

(when (not package-archive-contents)
  (package-refresh-contents))

;; windows specific stuff
(when (string-equal system-type "windows-nt")
  
  ;; setup tls trust files
  (setq gnutls-trustfiles (expand-file-name "~/.emacs.d/certs/cacert.pem"))
  (load-file (expand-file-name "~/.emacs.d/elpa/go-mode-20151226.1224/go-mode.el"))
  (load-file (expand-file-name "~/.emacs.d/elpa/go-mode-20151226.1224/go-mode-autoloads.el"))
  (message "Loading Windows config...")
  
    (when (file-accessible-directory-p "c:/Users/rcameron")
      ;; setup exec path
      (setq exec-path '(
                        "C:/Program Files/Git/Bin"
                        "C:/Users/rcameron/Documents/Github/gopath/bin"
                        "C:/Program Files/Emacs/bin"
                        ))
      (setenv "GOPATH" "c:/Users/rcameron/Documents/Github/gopath")
      (add-to-list 'load-path "C:/Users/rcameron/Documents/Github/gopath/src/github.com/golang/lint/misc/emacs")
      (load-file  "C:/Users/rcameron/Documents/Github/gopath/src/golang.org/x/tools/cmd/oracle/oracle.el")
      )

    (when (file-accessible-directory-p "c:/Users/rwcam_000")

      (message "Welcome home!")
      ;; setup exec path
      (setq exec-path '(
                        "C:/Program Files/Git/Bin"
                        "c:/Users/rwcam_000/Documents/Github/gopath/bin"
                        ))

      (setenv "GOPATH" "c:/Users/rwcam_000/Documents/Github/gopath")
      (add-to-list 'load-path "C:/Users/rwcam_000/Documents/Github/gopath/src/github.com/golang/lint/misc/emacs")
      (load-file "C:/Users/rwcam_000/Documents/Github/gopath/src/golang.org/x/tools/cmd/oracle/oracle.el")
      ))

;; mac specific platform
(when (string-equal system-type 'darwin)
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

;; go configuration
(require 'go-mode-autoloads)
(require 'golint)
(require 'go-eldoc)
(require 'go-autocomplete)
(add-hook 'go-mode-hook 'go-eldoc-setup)
(add-hook 'before-save-hook #'gofmt-before-save)
(setq gofmt-command "goimports")
