(require 'package)
;; determine the system type

;; utf8 mode
;; Set locale to UTF8
(set-language-environment 'utf-8)
(set-terminal-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
;; set the default to unix line endings
(set-buffer-file-coding-system 'utf-8-unix)


(add-to-list 'package-archives
             '("marmalade" . "https://marmalade-repo.org/packages/") t)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(add-to-list 'package-archives 
             '("org" . "http://orgmode.org/elpa/") t)

(when (not package-archive-contents)
  (package-refresh-contents))

;; hack for loading go-mode
(load-file (expand-file-name "~/.emacs.d/elpa/go-mode-20151226.1224/go-mode.el"))
(load-file (expand-file-name "~/.emacs.d/elpa/go-mode-20151226.1224/go-mode-autoloads.el"))
(load-file (expand-file-name "~/.emacs.d/pkgs/web-mode/web-mode.el"))

;; Windows specific stuff
(when (string-equal system-type "windows-nt")
  ;;
  ;; Pro-tip - some modules may not use the exec path, set the windows PATH correctly as well
  ;;
  ;;
  ;; Window tools
  ;; GNU Diff Utils - http://gnuwin32.sourceforge.net/packages/diffutils.htm
  ;; GNU TLS - for HTTPS connections from emacs - http://sourceforge.net/projects/ezwinports/files/
  
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
                                      slime
                                      flymake-cursor 
                                      dedicated ;; keeps windows from stupid town
                                      markdown-mode ;; dealing with markdown
                                      dockerfile-mode ;; docker stuff
                                      web-mode json-mode ;; json stuff
                                      flymake-jshint ;; js stuff
                                      yaml-mode ;; yaml stuff
                                      pymacs ;; python stuff
                                      dired-single  dired-details ;; dired made nice
                                      exec-path-from-shell find-file-in-project magit neotree
				      smex scpaste monokai-theme yaml-mode
                                      auto-complete markdown-mode rainbow-delimiters
                                      go-autocomplete go-eldoc go-mode go-errcheck ;; golang stuff
                                      autopair ido-hacks ido-vertical-mode go-scratch go-play
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

;; emacs tweaks
(setq-default indent-tabs-mode nil)      ;; no tabs!
(setq fill-column 80) ;; M-q should fill at 80 chars, not 75
(defalias 'qrr 'query-regexp-replace)
(fset 'yes-or-no-p 'y-or-n-p)  ;; only type `y` instead of `yes`
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward)  ;; buffernames that are foo<1>, foo<2> are hard to read. This makes them foo|dir  foo|otherdir
(setq desktop-load-locked-desktop "ask") ;; sometimes desktop is locked, ask if we want to load it.
(setq-default truncate-lines 1) ;; no wordwrap
(menu-bar-mode -1) ;; minimal chrome
(tool-bar-mode -1) ;; no toolbar
(scroll-bar-mode -1) ;; disable scroll bars
(setq visible-bell nil) ;; disable visual bell


;; server mode
(if (not server-mode)
    (server-start nil t))

;; tramp mode
(require 'tramp)
(setq tramp-default-method "ssh")

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

;; ido config
(require 'ido)
(ido-mode t)
(setq ido-enble-flex-matching t)

(require 'ido-vertical-mode)
(ido-vertical-mode)

(require 'ido-hacks)
(ido-hacks-mode)

;; lisp
(require 'slime)

;; web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.api\\'" . web-mode))
(add-to-list 'auto-mode-alist '("/some/react/path/.*\\.js[x]?\\'" . web-mode))

(setq web-mode-content-types-alist
  '(("json" . "/some/path/.*\\.api\\'")
    ("xml"  . "/other/path/.*\\.api\\'")
    ("jsx"  . "/some/react/path/.*\\.js[x]?\\'")))

;; javascript
(require 'flymake-jshint)
(add-hook 'js-mode-hook 'flymake-jshint-load)
(add-hook 'js-mode-hook 'flymake-mode)

;; python mode
;; python
(add-hook 'python-mode-hook (lambda () 
                                ;; This breaks the blog export, as the
                                ;; python snippet doesn't actually have
                                ;; a filename. Need to investigate
                                ;; flycheck for options. We'll just
                                ;; spawn a new emacs without this
                                ;; enabled for now.
                                (setq fill-column 80)
                                (flycheck-mode 1)
                                (fci-mode 1)))
  
(add-to-list 'auto-mode-alist '("\\.py" . python-mode))

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


(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

(defun my-go-mode-hook ()
  ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  ; Call Gofmt before saving
  (add-hook 'go-mode-hook 'go-eldoc-setup)
  (add-hook 'go-mode-hook #'enable-paredit-mode)
  (add-hook 'before-save-hook 'gofmt-before-save)
  (add-hook 'before-save-hook 'golint)

  
  ; Customize compile command to run go build

  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump))
(add-hook 'go-mode-hook 'my-go-mode-hook)

;; dired mode config
(defun dired-mode-setup ()
  (dired-hide-details-mode 1))
(add-hook 'dired-mode-hook 'dired-mode-setup)

;; starup config
(require 'dedicated)
(setq inhibit-startup-message t)
(desktop-save-mode 1)
(dired "~/")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(gofmt-show-errors (quote echo)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
