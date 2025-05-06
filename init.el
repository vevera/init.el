;must do..
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
(set-face-attribute 'default nil :font "Fira Code Retina" :height 100)

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

;making emacs my own editor, keys that i use a lot being maped to 
;easy bindings
(use-package general)

(general-auto-unbind-keys)

(general-create-definer my-custom-def
  :prefix "C-SPC"
  :prefix-command 'my-custom-cmd
  :prefix-map 'my-custom-map)

(my-custom-def "C-SPC" '(set-mark-command :which-key "select text")
  "n" '(switch-to-next-buffer :which-key "go to the next buffer")
  "p" '(switch-to-prev-buffer :which-key "go to the prev buffer")
  "C-n" '(switch-to-next-buffer :which-key "go to the next buffer")
  "C-p" '(switch-to-prev-buffer :which-key "go to the prev buffer")
  "o" '(other-window :which-key "go to the next window")
  "i" (lambda ()
	(interactive)
	(setq current-prefix-arg '(-1))
	(call-interactively ' other-window))
  :which-key "go to the prev window"
  "kk" '(delete-window :which-key "delete the currenct window")
  "kd" '(clang-format :which-key "clang-formating file"))

;preventing emacs from editing this file ..
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;my favorite theme
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

(use-package company)

(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)
(add-hook 'javascript-mode-hook 'eglot-ensure)

(use-package rg)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

(add-to-list 'auto-mode-alist '("\\.ts\\'" . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . javascript-mode))

(use-package neotree)
(global-set-key [f8] 'neotree-toggle)

(setq neo-window-position 'right)

(defun somefunction ()
  (interactive)
  (funcall 'shell-command "cd c: &") 
)
