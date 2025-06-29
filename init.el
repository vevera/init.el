;; -*- lexical-binding: t; -*-

;; -*- lexical-binding: t; -*-

;; This configs are comming from this link:
;; https://github.com/doomemacs/doomemacs/blob/665b627b7c07c8d29ec8d334588cecc2ba308248/docs/faq.org#how-does-doom-start-up-so-quickly
(setq package-quickstart t)

(setq gc-cons-threshold most-positive-fixnum ; 2^61 bytes
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
  (lambda ()
    (setq gc-cons-threshold 16777216 ; 16mb
          gc-cons-percentage 0.1)))

(defvar doom-gc-cons-threshold gc-cons-threshold)
        
(defun doom-defer-garbage-collection-h ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun doom-restore-garbage-collection-h ()
  ;; Defer it so that commands launched immediately after will enjoy the
  ;; benefits.
  (run-at-time
   1 nil (lambda () (setq gc-cons-threshold doom-gc-cons-threshold))))

(add-hook 'minibuffer-setup-hook #'doom-defer-garbage-collection-h)
(add-hook 'minibuffer-exit-hook #'doom-restore-garbage-collection-h)

(defvar doom--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
  (lambda ()
    (setq file-name-handler-alist doom--file-name-handler-alist)))

;;end of copy/paste


(setq native-comp-speed 3)
(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)

(menu-bar-mode -1)

(setq visible-bell t)

;i think this is not working yet.. but it is suposed to prevent the auto
;save files to appear everywhere.
(setq auto-save-file-name-transforms
      `((".*" ,(concat user-emacs-directory "auto-save/") t)))
(setq lock-file-name-transforms `((".*" ,(concat user-emacs-directory "auto-save/") t)))

;this i think is working, the backup files are now in a safe place
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;i use mostly msvc compiler so this help the setup of
;the enviroment when i call the compile cmd
(setq compile-command "vcvars64.bat && ")

;display column and line numbers
(column-number-mode)
(global-display-line-numbers-mode t)

(dolist (mode '(org-mode-hook
		shell-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;nice font that the youtube guy use, might change that in the future.
(set-face-attribute 'default nil :font "Cascadia Code Light" :height 110)

;necessary to install other packages
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;ivy helps in the searchs with swiper
(use-package ivy)
(use-package swiper)
(ivy-mode)

(global-set-key "\C-s" 'swiper)
(global-set-key "\C-r" 'swiper-isearch-backward)
(global-unset-key (kbd "C-x C-c"))

(use-package all-the-icons)

;nice looking footer
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

;helper when I dont know yet the key I want to press
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idle-delay 0.3))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil))

;set the switch buffer key to a more easy one
(global-set-key (kbd "C-M-j") 'counsel-switch-buffer)

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package clang-format)
(setq clang-format-style "file")

(defun other-previous-window ()
    (interactive)
	(setq current-prefix-arg '(-1))
	(call-interactively ' other-window))

;;hydra
(use-package hydra)

(defhydra hydra-window (:color "pink")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out")  
  ("n" switch-to-next-buffer "previous")
  ("p" switch-to-prev-buffer "next")
  ("o" other-window :which-key "go to the next window")
  ("i" other-previous-window :which-key "go to the prev window")
  ("k" delete-window :which-key "delete the current window")
  ("3" split-window-right "split the window")
  ("2" split-window-below "split the window down")
  ("+" balance-windows "balance everything")
  ("]" enlarge-window-horizontally "enlarge window h")
  ("[" shrink-window-horizontally "shrink window h")    
  ("6" enlarge-window "enlarge window v")
  ("7" shrink-window "shrink window v")
  ("c" compile "compile")
)

(define-key global-map (kbd "C-x C-C") 'hydra-window/body)
(define-key global-map (kbd "C-c C-x") 'hydra-window/body)
(define-key global-map (kbd "C-x c") 'hydra-window/body)

(defhydra hydra-undo (global-map "C-x u")
  "undo"
  ("u" undo "undo")
  ("r" undo-redo "redo")
  )

(use-package general)
(general-create-definer my-custom-def
  :prefix "C-c c"
  :prefix-command 'my-custom-cmd
  :prefix-map 'my-custom-map)

(my-custom-def
   "kd" '(clang-format :which-key "clang-formating file")
   ";" '(comment-or-uncomment-region :which-key "coment region")
   "mf" '(make-frame :which-key "make frame")
   "fn" '(next-window-any-frame :which-key "next frame")
   "g" '(revert-buffer :which-key "go back no file system")
   "cr" '(counsel-rg :which-key "counsel rg" )
   "rg" '(rg :which-key "rg"))

;making emacsn my own editor, keys that i use a lot being maped to 
;easy bindings

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;my favorite themeoo  
(use-package dracula-theme)
(load-theme 'dracula t)

;maximize on startup
(set-frame-parameter nil 'fullscreen 'maximized)

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-c p" . projectile-command-map)))

(add-to-list 'projectile-globally-ignored-directories ".cmake_artifacts")
(add-to-list 'projectile-globally-ignored-directories ".git")
(add-to-list 'projectile-globally-ignored-directories ".vscode")
(add-to-list 'projectile-globally-ignored-directories "cmake_modules")
(add-to-list 'projectile-globally-ignored-directories "node_modules")
(add-to-list 'projectile-globally-ignored-directories "qt_6_6_0")
(add-to-list 'projectile-globally-ignored-directories "Build")

(use-package eglot)
(use-package go-mode)
(use-package company)

(setq major-mode-remap-alist
 '((yaml-mode . yaml-ts-mode)
   (bash-mode . bash-ts-mode)
   (js2-mode . js-ts-mode)
   (typescript-mode . typescript-ts-mode)
   (json-mode . json-ts-mode)
   (css-mode . css-ts-mode)
   (python-mode . python-ts-mode)
   (c-mode . c-ts-mode)
   (c++-mode . c++-ts-mode)
   (go-mode . go-ts-mode)))

(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'c-ts-mode-hook 'eglot-ensure)
(add-hook 'c++-ts-mode-hook 'eglot-ensure)
(add-hook 'javascript-mode-hook 'eglot-ensure)
(add-hook 'typescript-ts-mode-hook 'eglot-ensure)
(add-hook 'go-ts-mode 'eglot-ensure)

(use-package rg)
(setq indent-tabs-mode nil)
(setq tab-width 4)
(setq indent-line-function 'insert-tab)

(setq go-ts-mode-indent-offset tab-width)

(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-ts-mode))

(use-package neotree)
(global-set-key [f8] 'neotree-toggle)
(setq neo-window-fixed-size nil)

(setq neo-window-position 'right)

(use-package magit :ensure t)

(defun somefunction ()
  (interactive)
  (funcall 'shell-command "cd c: &") 
 )
