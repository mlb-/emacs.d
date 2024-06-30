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

(use-package calendar
  :custom ((calendar-latitude 37.6239587)
           (calendar-longitude -122.0439688)))

(use-package sky-color-clock
  :load-path "~/.emacs.d/sky-color-clock"
  :custom ((sky-color-clock-enable-emoji-icon nil)
           (sky-color-clock-enable-xpm-icon t))
  :config
  (sky-color-clock-initialize calendar-latitude)
  (sky-color-clock-initialize-openweathermap-client (plist-get (car (auth-source-search :host "openweathermap"))
                                                               :token)
                                                    5322745 ;; Hayward - 94544
                                                    )
  (add-to-list 'global-mode-string '(:eval (sky-color-clock))))

(use-package nyan-mode
  :config (nyan-mode t))

(use-package spaceline-config
  :ensure spaceline
  :config (spaceline-spacemacs-theme))

(use-package fancy-battery
  :config
  (defun battery-pmset ()
    "Get battery status information using `pmset'.

The following %-sequences are provided:
%L Power source (verbose)
%B Battery status (verbose)
%b Battery status, empty means high, `-' means low,
   `!' means critical, and `+' means charging
%p Battery load percentage
%h Remaining time in hours
%m Remaining time in minutes
%t Remaining time in the form `h:min'"
    (let (power-source load-percentage battery-status battery-status-symbol
                       remaining-time hours minutes)
      (with-temp-buffer
        (ignore-errors (call-process "pmset" nil t nil "-g" "ps"))
        (goto-char (point-min))
        (when (re-search-forward "\\(?:Currentl?y\\|Now\\) drawing from '\\(AC\\|Battery\\) Power'" nil t)
          (setq power-source (match-string 1))
          (when (re-search-forward "^ -InternalBattery-0[ \t]+\\(?:(id=[0-9]+)[ \t]+\\)?" nil t)
            (when (looking-at "\\([0-9]\\{1,3\\}\\)%")
              (setq load-percentage (match-string 1))
              (goto-char (match-end 0))
              (cond ((looking-at "; charging")
                     (setq battery-status "charging"
                           battery-status-symbol "+"))
                    ((< (string-to-number load-percentage) battery-load-critical)
                     (setq battery-status "critical"
                           battery-status-symbol "!"))
                    ((< (string-to-number load-percentage) battery-load-low)
                     (setq battery-status "low"
                           battery-status-symbol "-"))
                    (t
                     (setq battery-status "high"
                           battery-status-symbol "")))
              (when (re-search-forward "\\(\\([0-9]+\\):\\([0-9]+\\)\\) remaining"  nil t)
                (setq remaining-time (match-string 1))
                (let ((h (string-to-number (match-string 2)))
                      (m (string-to-number (match-string 3))))
                  (setq hours (number-to-string (+ h (if (< m 30) 0 1)))
                        minutes (number-to-string (+ (* h 60) m)))))))))
      (list (cons ?L (or power-source "N/A"))
            (cons ?p (or load-percentage "N/A"))
            (cons ?B (or battery-status "N/A"))
            (cons ?b (or battery-status-symbol ""))
            (cons ?h (or hours "N/A"))
            (cons ?m (or minutes "N/A"))
            (cons ?t (or remaining-time "N/A")))))
  (fancy-battery-mode))

(use-package super-save
  :diminish ""
  :config (super-save-mode +1))

(use-package autorevert
  :diminish auto-revert-mode)

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

(use-package which-key
  :diminish ""
  :config (which-key-mode))

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

(transient-mark-mode 0)

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
  :bind-keymap ("C-c p" . projectile-command-map)
  :delight '(:eval (concat " [" (projectile-project-name) "]"))
  :custom ((projectile-use-git-grep t)
           (projectile-switch-project-action 'projectile-vc)
           (projectile-per-project-compilation-buffer t))
  :init
  (defmacro projectile-compilation-buffer-name-for-command (command-name)
    "Wrap `projectile-compilation-buffer-name`, since `projectile`
     clears `compilation-buffer-name-function`."
    `(lambda (compilation-mode)
       (let* ((original-name (funcall ,(symbol-function 'projectile-compilation-buffer-name) compilation-mode))
              (i (+ 2 (s-index-of "*" (substring original-name 1)))))
         (concat (substring original-name 0 i)
                 "[" ,command-name "]"
                 (substring original-name i)))))
  (defun projectile-run-project--namespace-buffer (orig-fun &rest args)
    (cl-letf (((symbol-function 'projectile-compilation-buffer-name)
               (projectile-compilation-buffer-name-for-command "Run")))
      (apply orig-fun args)))
  (defun projectile-install-project--namespace-buffer (orig-fun &rest args)
    (cl-letf (((symbol-function 'projectile-compilation-buffer-name)
               (projectile-compilation-buffer-name-for-command "Install")))
      (apply orig-fun args)))
  (defun projectile-test-project--namespace-buffer (orig-fun &rest args)
    (cl-letf (((symbol-function 'projectile-compilation-buffer-name)
               (projectile-compilation-buffer-name-for-command "Test")))
      (apply orig-fun args)))
  (defun projectile-compile-project--namespace-buffer (orig-fun &rest args)
    (cl-letf (((symbol-function 'projectile-compilation-buffer-name)
               (projectile-compilation-buffer-name-for-command "Compile")))
      (apply orig-fun args)))
  :config
  (projectile-global-mode t)
  (advice-add 'projectile-run-project
              :around
              #'projectile-run-project--namespace-buffer)
  (advice-add 'projectile-install-project
              :around
              #'projectile-install-project--namespace-buffer)
  (advice-add 'projectile-test-project
              :around
              #'projectile-test-project--namespace-buffer)
  (advice-add 'projectile-compile-project
              :around
              #'projectile-compile-project--namespace-buffer))

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

(use-package bug-reference
  :after magit
  :hook (magit-mode-hook . bug-reference-mode))

(use-package magithub
  :disabled t
  :after magit
  :pin melpa-stable
  :config (magithub-feature-autoinject t))

(use-package git-link)

(use-package tex-site
  :ensure auctex)

(use-package flycheck
  :diminish ((flycheck-mode . "")
             (flyspell-mode . ""))
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

(use-package smartparens-config
  :ensure smartparens
  :demand t
  :hook ((js2-mode-hook
          java-mode-hook
          json-mode-hook) . turn-on-smartparens-strict-mode)
  :bind (:map smartparens-strict-mode-map
              ("M-J" . 'sp-join-sexp)
              ("]" . 'sp-up-sexp))
  :config (sp-use-paredit-bindings))

(use-package js2-mode
  :mode "\\.js$")

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

(customize-set-variable 'fill-column 120)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(use-package gist
  :defer t)

(use-package rainbow-identifiers
  :hook (prog-mode-hook . rainbow-identifiers-mode))

(use-package docker)

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

(use-package lsp-ui
  :bind (:map lsp-ui-mode-map
              ([remap xref-find-definitions] . 'lsp-ui-peek-find-definitions)
              ([remap xref-find-references] . 'lsp-ui-peek-find-references))
  :hook ((lsp-mode-hook . lsp-ui-mode)))

(use-package company-lsp)

(use-package lsp-javacomp
  :after company-lsp
  :commands lsp-javacomp-enable
  :hook (java-mode-hook . (lambda ()
                          (lsp-javacomp-enable)
                          ;; Use company-lsp as the company completion backend
                          (set (make-variable-buffer-local 'company-backends) '(company-lsp))
                          ;; Optional company-mode settings
                          (set (make-variable-buffer-local 'company-idle-delay) 0.1)
                          (set (make-variable-buffer-local 'company-minimum-prefix-length) 1)))

  :config
  (lsp-javacomp-install-server))

(use-package elm-mode
  :after company
  :custom ((elm-format-on-save t)
           (elm-sort-imports-on-save t))
  :config (add-to-list 'company-backends 'company-elm))

(use-package flycheck-elm
  :after elm-mode
  :hook ((flycheck-mode-hook . flycheck-elm-setup)))

(use-package whitespace
  :diminish ""
  :hook (((prog-mode-hook text-mode-hook) . whitespace-mode)
         (before-save-hook . whitespace-cleanup))
  :custom ((whitespace-line-column 120 "limit line length")
           (whitespace-style '(face tabs empty trailing lines-tail))))

(use-package org-gcal
  :after org
  :preface (setq creds (car (auth-source-search :host "org-gcal")))
  :custom ((org-gcal-client-id (plist-get creds :client-id))
           (org-gcal-client-secret (plist-get creds :client-secret))
           (org-gcal-file-alist (mapcar (lambda (e)
                                          (cons (plist-get e :calendar-id)
                                                (concat "~/org/gcal/" (plist-get e :org-file))))
                                        ;; Move the configuration from
                                        ;; here into authfiles, with
                                        ;; entries like:
                                        ;; machine org-gcal-entry calendar-id you@gmail.com org-file you.org
                                        (auth-source-search :host "org-gcal-entry"
                                                            :max 20))))
  :config (org-gcal-fetch))

(use-package ace-window
  :custom (aw-keys '(?j ?k ?l ?\; ?m ?, ?. ?/))
  :bind ("M-o" . ace-window))

(use-package alert
  :commands alert
  :custom (alert-user-configuration '((((:status buried idle)
                                        (:mode . "^compilation-mode$"))
                                       pushover
                                       ((:continue . t)))
                                      (nil notifier nil)
                                      (nil log nil))))

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

(use-package org
  :bind (("C-c c" . org-capture)
         ("C-c a" . org-agenda))
  :custom ((org-directory "~/org")
           (org-default-notes-file (concat org-directory "/01_notes.org"))
           (org-agenda-files (append (list org-default-notes-file)
                                     (file-expand-wildcards "~/org/gcal/*.org")))
           (org-refile-targets '((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 2)))
           (org-agenda-include-diary t)
           (org-log-into-drawer t)
           (org-log-state-notes-insert-after-drawers t)
           (org-capture-templates '(("t" "Task" entry (file+headline "" "Tasks")
                                     "* TODO %?\n  %u\n  %a")
                                    ("m" "Meeting" entry (file+headline "" "Meetings")
                                     "* TODO %?\n  %u\n  %a" :clock-in t)))
           (org-agenda-span 'day))
  :config (add-to-list 'org-modules 'habits))

(use-package org-journal
  :after org)

(use-package auth-source
  :custom (auth-sources (list "~/.authinfo.gpg"
                              "~/.authinfo"
                              "~/.netrc")))

(use-package epa
  :custom (epa-pinentry-mode 'loopback))

(use-package helm-pass
  :commands helm-pass)

(use-package wgrep-helm
  :custom ((wgrep-auto-save-buffer t "I use git, so autosave is cool")))

(use-package pushover
  :custom (pushover-user-key (plist-get (car (auth-source-search :host "pushover"))
                                        :token)))

(use-package restart-emacs)

(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs ready in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

(pushover-send "emacs"
               "startup complete")
