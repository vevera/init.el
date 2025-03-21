;; (setq inhibit-startup-message t)
;; (setq package-enable-at-startup nil)
;; (setq w32-ralt-modifier 'super)  ;; Use Right Alt as Super

;; (defvar bootstrap-version)
;; (let ((bootstrap-file
;;        (expand-file-name
;;         "straight/repos/straight.el/bootstrap.el"
;;         (or (bound-and-true-p straight-base-dir)
;;             user-emacs-directory)))
;;       (bootstrap-version 7))
;;   (unless (file-exists-p bootstrap-file)
;;     (with-current-buffer
;;         (url-retrieve-synchronously
;;          "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
;;          'silent 'inhibit-cookies)
;;       (goto-char (point-max))
;;       (eval-print-last-sexp)))
;;   (load bootstrap-file nil 'nomessage))

;; (straight-use-package 'doom-themes)
;; (require 'doom-themes)

;;   ;; Global settings (defaults)
;;   (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
;;         doom-themes-enable-italic t) ; if nil, italics is universally disabled

;;   ;; Load the theme (doom-one, doom-molokai, etc); keep in mind that each
;;   ;; theme may have their own settings.
;;   (load-theme 'doom-one t)

;;   ;; Enable flashing mode-line on errors
;;   (doom-themes-visual-bell-config)

;;   ;; Enable custom neotree theme
;;   (doom-themes-neotree-config)  ; all-the-icons fonts must be installed!

;; (setq package-selected-packages '(lsp-mode yasnippet lsp-treemacs helm-lsp
;; 					   projectile hydra flycheck company avy which-key helm-xref dap-mode))

;; (when (cl-find-if-not #'package-installed-p package-selected-packages)
;;   (package-refresh-contents)
;;   (mapc #'package-install package-selected-packages))

;; ;; sample `helm' configuration use https://github.com/emacs-helm/helm/ for details
;; (helm-mode)
;; (require 'helm-xref)
;; (define-key global-map [remap find-file] #'helm-find-files)
;; (define-key global-map [remap execute-extended-command] #'helm-M-x)
;; (define-key global-map [remap switch-to-buffer] #'helm-mini)

;; (which-key-mode)
;; (add-hook 'c-mode-hook 'lsp)
;; (add-hook 'c++-mode-hook 'lsp)

;; (setq gc-cons-threshold (* 100 1024 1024)
;;       read-process-output-max (* 1024 1024)
;;       treemacs-space-between-root-nodes nil
;;       company-idle-delay 0.0
;;       company-minimum-prefix-length 1
;;       lsp-idle-delay 0.1)  ;; clangd is fast

;; (with-eval-after-load 'lsp-mode
;;   (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
;;   (require 'dap-cpptools)
;;   (yas-global-mode))

;; ;; (add-to-list 'lsp-clients-clangd-args "--compile-commands-dir=./build")
;; ;; (add-to-list 'lsp-clients-clangd-args "--query-driver=C:\\Program Files\\LLVM\\bin\\clang-cl.exe")

;; ;; (require 'eglot)
;; ;; (add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
;; ;; (add-hook 'c-mode-hook 'eglot-ensure)
;; ;; (add-hook 'c++-mode-hook 'eglot-ensure)

;; ;; Set initial frame size and position
;; (defun my/set-initial-frame ()
;;   (let* ((base-factor 0.40)
;; 	 (base-factor-height 0.80)
;; 	(a-width (* (display-pixel-width) base-factor))
;;         (a-height (* (display-pixel-height) base-factor-height))
;;         (a-left (truncate (/ (- (display-pixel-width) a-width) 2)))
;; 	(a-top (truncate (/ (- (display-pixel-height) a-height) 2))))
;;     (set-frame-position (selected-frame) a-left a-top)
;;     (set-frame-size (selected-frame) (truncate a-width)  (truncate a-height) t)))
;; (setq frame-resize-pixelwise t)
;; (my/set-initial-frame)
;; (put 'erase-buffer 'disabled nil)


(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)

(menu-bar-mode -1)

(setq visible-bell t)

(setq auto-save-file-name-transforms
      `((".*" ,(concat user-emacs-directory "auto-save/") t)))

(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

(set-face-attribute 'default nil :font "Fira Code Retina" :height 130)

(load-theme 'wombat)
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

(use-package ivy :ensure t)
(use-package swiper :ensure t)
(ivy-mode)

(global-set-key "\C-s" 'swiper)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)


(load-theme 'dracula t)

