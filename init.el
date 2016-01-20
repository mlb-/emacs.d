;;; I'm a dog using emacs. HALP! I don't know what I'm doing.

;; Yay packages!
(require 'package)
;; Do I need these other repos? Who knows!
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ;("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))
(package-initialize)

;; Shamelessly stolen!
(defun require-package (package &optional min-version no-refresh)
  "Install given PACKAGE, optionally requiring MIN-VERSION.
If NO-REFRESH is non-nil, the available package lists will not becall
re-downloaded in order to locate PACKAGE."
  (if (package-installed-p package min-version)
      t
    (if (or (assoc package package-archive-contents) no-refresh)
        (package-install package)
      (progn
        (package-refresh-contents)
        (require-package package min-version t)))))

(require-package 'use-package)

(use-package use-package
  :custom (use-package-hook-name-suffix "" "Don't magically append `-hook` for me."))

(use-package delight)

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :config (exec-path-from-shell-initialize))

(use-package zenburn-theme
  :config (load-theme 'zenburn t))

(use-package nyan-mode
  :config (nyan-mode t))

(use-package super-save
  :diminish ""
  :config (super-save-mode +1))

;; Thanks, technomancy! (https://github.com/technomancy/emacs-starter-kit/)
(use-package better-defaults)
;; And, as per suggestion 1
(use-package ido-hacks
  :disabled t)
;; And, as per suggestion 2
;;(setq ido-use-virtual-buffers t)
;; And, as per suggestion 3
(use-package smex
  :disabled t
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands)
         ;; This is your old M-x.
         ("C-c C-c M-x" . execute-extended-command))
  :config (smex-initialize))

;;; Thanks, https://tuhdo.github.io/helm-intro.html
(use-package helm-config
  :ensure helm
  :demand t
  :custom (helm-command-prefix-key "C-c h" "Avoid fat-fingering C-c C-x.")
  :bind (("M-x" . helm-M-x)
         ("M-y" . helm-show-kill-ring)
         ("C-x b" . helm-mini)
         ("C-x C-f" . helm-find-files)
         ("C-c h" . helm-command-prefix)
         ("C-h SPC" . helm-all-mark-rings)
         :map helm-command-map
         ("o" . helm-occur))
  :diminish helm-mode
  :config (helm-mode t))

(use-package helm-projectile
  :custom (projectile-completion-system 'helm)
  :config (helm-projectile-on))

(use-package helm-descbinds
  :config (helm-descbinds-mode))

;; As per suggestion 4
(use-package ido-ubiquitous
  :disabled t
  :config (ido-ubiquitous))

;; As per suggestion 5
(use-package paredit
  :diminish "()"
  :hook ((emacs-lisp-mode-hook . paredit-mode)
         (cider-repl-mode-hook . paredit-mode)
         (clojure-mode-hook . paredit-mode))
  :bind (:map paredit-mode-map
              ("M-{" . paredit-wrap-curly)
              ("M-[" . paredit-wrap-square)))

;; As per suggestion 6
(use-package idle-highlight-mode
  :init
  (defun my-coding-hook ()
    (make-local-variable 'column-number-mode)
    (column-number-mode t)
    (if window-system (hl-line-mode t))
    (idle-highlight-mode t))
  :hook (prog-mode-hook . my-coding-hook))

(use-package cider
  :custom (cider-repl-pop-to-buffer-on-connect nil
                                               "Don't be rude."))
(use-package clojure-mode)
(use-package clj-refactor
  :after cider)

(use-package flycheck-clojure
  :after cider
  :config (flycheck-clojure-setup))


(use-package anzu
  :diminish ""
  :config (global-anzu-mode t))

;; colorcolumn/row?
;; relativenumber?
;; tabbar
(setq scroll-margin 1)
;; pre-save delete-trailing-whitespace
;; auto-resize splits

(use-package projectile
  :bind-keymap ("C-c p" . projectile-command-map)
  :delight '(:eval (concat " [" (projectile-project-name) "]"))
  :custom (projectile-use-git-grep t)
  :config (projectile-global-mode t))

;; Welcome screen begone!
(setq inhibit-startup-message t)

;; sudo-write
(use-package tramp
  :config
  (add-to-list 'tramp-default-proxies-alist
               '(nil "root" "/ssh:%h:"))
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))
(use-package markdown-mode)
;; erlang-mode?
(use-package magit
  :bind ("C-c g" . magit-status))

(use-package tex-site
  :ensure auctex)

(use-package flycheck
  :hook ((after-init-hook . global-flycheck-mode)
         (prog-mode-hook . flyspell-prog-mode)))

(use-package flycheck-pos-tip
  :after flycheck
  :config (flycheck-pos-tip-mode))

;; tagbar
;; surround -- change balanced pairs
;; unimpaired?
;; nerdtree
;; speeddating

(use-package rainbow-delimiters
  :hook ((prog-mode-hook . rainbow-delimiters-mode)
         (cider-repl-mode-hook . rainbow-delimiters-mode)))

;; evil-jumper
(use-package evil)

(defun electric-pair ()
  "If at end of line, insert character pair without surrounding spaces.
    Otherwise, just insert the typed character."
  (interactive)
  (if (eolp) (let (parens-require-spaces) (insert-pair)) (self-insert-command 1)))

(use-package js2-mode
  :mode "\\.js$"
  :custom (js2-basic-offset 2
                            "Not gonna let callback hell make me scroll offscreen")
  :config (add-hook 'js2-mode-hook
                         (lambda ()
                           (define-key js2-mode-map "(" 'electric-pair)
                           (define-key js2-mode-map "{" 'electric-pair)
                           (define-key js2-mode-map "[" 'electric-pair))))

(use-package js2-refactor
  :after js2-mode
  :hook (js2-mode-mode . js2-refactor-mode)
  :config (js2r-add-keybindings-with-prefix "C-c C-m"))

(use-package expand-region
  :bind ("C-=" . er/expand-region)
  :config (pending-delete-mode t))

(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)
         ("M-S-<mouse-1>" . mc/add-cursor-on-click)))

(use-package company
  :diminish ""
  :hook (after-init-hook . global-company-mode)
  :bind ("TAB" . company-indent-or-complete-common))

(use-package graphviz-dot-mode
  :mode "\\.dot$")

(use-package eldoc
  :diminish ""
  :hook ((emacs-lisp-mode-hook . eldoc-mode)
         (cider-mode-hook . eldoc-mode))
  :custom (eldoc-idle-delay 0.1
                            "I'm impatient."))

(setq-default indent-tabs-mode nil)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(use-package gist
  :defer t)

(use-package rainbow-identifiers
  :hook (prog-mode-hook . rainbow-identifiers-mode))

(use-package docker-tramp
  :custom (docker-tramp-use-names t))

(use-package undo-tree
  :diminish ""
  :config (global-undo-tree-mode t))

(use-package yasnippet
  :disabled t
  :diminish yas-minor-mode
  :config (yas-global-mode t))

(setq visible-bell nil)

(setq save-interprogram-paste-before-kill t)
