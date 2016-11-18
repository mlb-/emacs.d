;;; I'm a dog using emacs. HALP! I don't know what I'm doing.

;; Yay packages!
(require 'package)
;; Do I need these other repos? Who knows!
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ;;("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(use-package use-package
  :custom ((use-package-hook-name-suffix "" "Don't magically append `-hook` for me.")
           (use-package-always-ensure t)
           (use-package-verbose t)))

(use-package delight)

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :config (exec-path-from-shell-initialize))

(use-package solarized-theme
  :config (load-theme 'solarized-dark t))

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
  :pin melpa-stable
  :custom ((cider-repl-pop-to-buffer-on-connect nil
                                                "Don't be rude.")
           (cider-test-show-report-on-success t
                                              "See what passed."))
  :commands (cider-jack-in cider-connect)
  :init
  (defun repl-connected-alert ()
    (alert "Clojure REPL connected"
           :title "CIDER"))
  (defun cider-tests-finished-alert ()
    (alert "Finished running test(s)"
           :title "CIDER"))
  :hook ((cider-connected-hook . repl-connected-alert)
         (cider-test-report-mode-hook . cider-tests-finished-alert)))
(use-package clojure-mode
  :after compile
  :config
  (add-to-list 'compilation-error-regexp-alist-alist
               '(lein-test
                 "^FAIL in (.+) (\\(.+\\):\\([0-9]+\\))$"
                 1
                 2
                 nil))
  (add-to-list 'compilation-error-regexp-alist 'lein-test))
(use-package clj-refactor
  :pin melpa-stable
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
;; auto-resize splits

(use-package projectile
  :delight '(:eval (concat " [" (projectile-project-name) "]"))
  :custom ((projectile-use-git-grep t)
           (projectile-switch-project-action 'projectile-vc))
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
  :pin melpa-stable
  :bind ("C-c g" . magit-status)
  :custom (magit-branch-prefer-remote-upstream '("master" "develop")))

(use-package magithub
  :after magit)

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
(use-package evil
  :disabled t)

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

(use-package yaml-mode
  :mode "\\.yml$")

(use-package maxframe
  :if (string-equal (window-system) "ns")
  :hook (window-setup-hook . toggle-frame-fullscreen)
  :config (set-face-attribute 'default nil :height 140))

(use-package whitespace
  :diminish ""
  :hook (((prog-mode-hook text-mode-hook) . whitespace-mode)
         (before-save-hook . whitespace-cleanup))
  :custom ((whitespace-line-column 80 "limit line length")
           (whitespace-style '(face tabs empty trailing lines-tail))))

(use-package alert
  :commands alert
  :custom (alert-default-style 'notifier))

(use-package compile
  :init
  (defun compile-finish-hook (buf why)
    (display-buffer buf)
    (alert why :buffer buf))
  (defun ansi-color-compilation-buf ()
    (when (eq major-mode 'compilation-mode)
      (interactive)
      (ansi-color-apply-on-region compilation-filter-start (point-max))))
  :hook ((compilation-finish-functions . compile-finish-hook)
         (compilation-filter-hook . ansi-color-compilation-buf)))
