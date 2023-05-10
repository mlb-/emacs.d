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
  :config (exec-path-from-shell-initialize)
          (exec-path-from-shell-copy-env "JAVA_HOME")
)

(use-package solarized-theme
  :config (load-theme 'solarized-dark t))

(use-package calendar
  :custom ((calendar-latitude 37.6239587)
           (calendar-longitude -122.0439688)))

(use-package sky-color-clock
  :disabled t
  ;; Gotta clone from https://github.com/zk-phi/sky-color-clock til I
  ;; get around to using https://github.com/quelpa/quelpa-use-package
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
  ;; Is this a "fix" for the clock not always renderig in the bar?
  ;; :after sky-color-clock
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
(use-package helm
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
  :after which-key
  :custom (helm-descbinds-disable-which-key nil)
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
  :disabled t
  ;;:pin melpa-stable
  :bind ("C-c g" . magit-status)
  :custom (magit-branch-prefer-remote-upstream '("master" "develop" "dev")))

(use-package magit-gitflow
  :hook (magit-mode-hook . turn-on-magit-gitflow))

(use-package bug-reference
  :after magit
  :custom ((bug-reference-bug-regexp "\\(?2:[A-Z]+-[0-9]+\\)"))
  :hook ((magit-mode-hook
          org-mode-hook
          org-agenda-mode-hook) . bug-reference-mode)
  :config (setq bug-reference-url-format "https://apixio.atlassian.net/browse/%s"))

(use-package forge
  :after magit
  :pin melpa)
(use-package sqlite3)


(use-package git-link)

(use-package tex-site
  :ensure auctex)

(use-package flycheck
  :diminish ((flycheck-mode . "")
             (flyspell-mode . ""))
  :hook ((after-init-hook . global-flycheck-mode)
         ;; (prog-mode-hook . flyspell-prog-mode)
))

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
  :hook ((ein:notebook-multilang-mode-hook
          inferior-python-mode-hook
          java-mode-hook
          js2-mode-hook
          json-mode-hook
          groovy-mode-hook
          python-mode-hook
          ;; python-shell-setup-codes
          scala-mode-hook) . turn-on-smartparens-strict-mode)
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

(use-package company-quickhelp
  :after company
  :config (company-quickhelp-mode))

(use-package graphviz-dot-mode
  :mode "\\.dot$")

(use-package eldoc
  :diminish ""
  :hook ((emacs-lisp-mode-hook . eldoc-mode)
         (cider-mode-hook . eldoc-mode))
  :custom (eldoc-idle-delay 0.1
                            "I'm impatient."))

(setq-default indent-tabs-mode nil)

(customize-set-variable 'fill-column
                        100)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(use-package gist
  :defer t)

(use-package rainbow-identifiers
  :hook (prog-mode-hook . rainbow-identifiers-mode))

(use-package docker)

(use-package docker-tramp
  :disabled t ; apparently I can use tramp-container?
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
  :config (set-face-attribute 'default nil :height 120))

(use-package lsp-ui
  :custom (lsp-ui-flycheck-enable t)
  :bind (:map lsp-ui-mode-map
              ([remap xref-find-definitions] . 'lsp-ui-peek-find-definitions)
              ([remap xref-find-references] . 'lsp-ui-peek-find-references))
  :hook ((lsp-mode-hook . lsp-ui-mode)))

(use-package groovy-mode
  :mode "\\.groovy")

(use-package scala-mode
  :custom ((scala-indent:align-parameters t))
  :interpreter "scala"
  :mode "\\.scala$")

;; Enable sbt mode for executing sbt commands
(use-package sbt-mode
  :custom ((sbt:program-options '("-Dsbt.supershell=false") "sbt-supershell kills sbt-mode:  https://github.com/hvesalai/emacs-sbt-mode/issues/152"))
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map)
  )

(use-package lsp-mode
  ;; Optional - enable lsp-mode automatically in scala files
  :hook  (scala-mode-hook . lsp)
         (lsp-mode-hook . lsp-lens-mode)
         (lsp-mode-hook . lsp-enable-which-key-integration)
  :config
  ;; Uncomment following section if you would like to tune lsp-mode performance according to
  ;; https://emacs-lsp.github.io/lsp-mode/page/performance/
  ;;       (setq gc-cons-threshold 100000000) ;; 100mb
  ;;       (setq read-process-output-max (* 1024 1024)) ;; 1mb
  ;;       (setq lsp-idle-delay 0.500)
  ;;       (setq lsp-log-io nil)
  ;;       (setq lsp-completion-provider :capf)
  (setq lsp-prefer-flymake nil))

;; Add metals backend for lsp-mode
(use-package lsp-metals
  :disabled t
  :config (setq lsp-metals-treeview-show-when-views-received t))

;; Enable nice rendering of documentation on hover
;;   Warning: on some systems this package can reduce your emacs responsiveness significally.
;;   (See: https://emacs-lsp.github.io/lsp-mode/page/performance/)
;;   In that case you have to not only disable this but also remove from the packages since
;;   lsp-mode can activate it automatically.
(use-package lsp-ui)

;; lsp-mode supports snippets, but in order for them to work you need to use yasnippet
;; If you don't want to use snippets set lsp-enable-snippet to nil in your lsp-mode settings
;;   to avoid odd behavior with snippets and indentation
(use-package yasnippet)

;; Use company-capf as a completion provider.
;;
;; To Company-lsp users:
;;   Company-lsp is no longer maintained and has been removed from MELPA.
;;   Please migrate to company-capf.
(use-package company
  :hook (scala-mode . company-mode)
  :config
  (setq lsp-completion-provider :capf))

;; Use the Debug Adapter Protocol for running tests and debugging
(use-package posframe
  ;; Posframe is a pop-up tool that must be manually installed for dap-mode
  )
(use-package dap-mode
  :hook
  (lsp-mode . dap-mode)
  (lsp-mode . dap-ui-mode)
  (python-mode-hook . (lambda ()
                        (require 'dap-python)
                        ))
  )

(use-package lsp-java
  :hook (java-mode-hook . lsp)
  :custom ((lsp-java-java-path "/Users/mbatema/.jenv/versions/11.0.10/bin/java")))

(defun sort-java-imports-like-intellij ()
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (let* ((beg (progn (search-forward-regexp "^package")
                         (end-of-line)
                         (point)))
             (end (progn (search-forward-regexp "^\\(public\\|private\\|protected\\|class\\|@\\|/\\*\\)")
                         (previous-line)
                         (end-of-line)
                         (point)))
             (imports (thread-last (buffer-substring beg end)
                                   (s-split "\n")
                                   (seq-remove #'string-empty-p)))
             (other-imports (thread-last imports
                                         (seq-remove (lambda (import)
                                                       (or (string-match "^import java" import)
                                                           (string-match "^import static" import))))
                                         (seq-sort #'string<)
                                         (s-join "\n")))
             (java-imports (thread-last imports
                                        (seq-filter (lambda (import) (string-match "^import java" import)))
                                        (seq-sort #'string<)
                                        (s-join "\n")))
             (static-imports (thread-last imports
                                          (seq-filter (lambda (import) (string-match "^import static" import)))
                                          (seq-sort #'string<)
                                          (s-join "\n"))))
        (delete-region beg end)
        (insert "\n")
        (when (s-present? other-imports) (insert "\n" other-imports "\n"))
        (when (s-present? java-imports) (insert "\n" java-imports "\n"))
        (when (s-present? static-imports) (insert "\n" static-imports "\n")))))

(use-package helm-lsp)

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
  :custom ((whitespace-line-column 100 "limit line length")
           (whitespace-style '(face tabs empty trailing lines-tail))))

(use-package copy-as-format)

(use-package company-emoji
  :after company
  :init (add-to-list 'company-backends 'company-emoji))

(use-package emojify
  :after slack
  :hook (slack-mode . emojify-mode))

(use-package slack
  :preface
  (setq url-http-extra-headers nil
        oauth--token-data nil
        url-callback-function nil
        url-callback-arguments nil)
  :hook (after-init . slack-start)
  :custom ((slack-prefer-current-team t))
  :config
  (slack-register-team
   :name "Apixio"
   :default t
   :client-id "emacs-slack"
   :client-secret "hunter2"
   :token (plist-get (car (auth-source-search :host "apixio.slack.com"))
                     :token)))

(use-package org-jira
  :custom ((jiralib-url "https://apixio.atlassian.net"))
  ;; Mnr2dzSV1YP5qtF08mRI21E3
  )

(use-package ox-jira
  :after org)

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

(use-package wanderlust
  :commands (wl
             wl-other-frame
             wl-draft
             wl-user-agent-compose)
  :custom (;; IMAP settings
           (elmo-imap4-default-server "imap.gmail.com")
           (elmo-imap4-default-user "mbatema@apixio.com")
           (elmo-imap4-default-authenticate-type 'clear)
           (elmo-imap4-default-port '993)
           (elmo-imap4-default-stream-type 'ssl)
           ;; SMTP settings
           (wl-smtp-connection-type 'starttls)
           (wl-smtp-posting-port 587)
           (wl-smtp-authenticate-type "plain")
           (wl-smtp-posting-user "mbatema@apixio.com")
           (wl-smtp-posting-server "smtp.gmail.com")
           (wl-local-domain "gmail.com")
           ;; Folders
           (wl-default-folder "%inbox")
           (wl-default-spec "%")
           (wl-draft-folder "%[Gmail]/Drafts") ; Gmail IMAP
           (wl-trash-folder "%[Gmail]/Trash")
           (wl-folder-check-async t)
           ;; Credentials
           (elmo-passwd-storage-type 'auth-source))
  :config
  (setq elmo-imap4-use-modified-utf7 t)
  (if (boundp 'mail-user-agent)
      (setq mail-user-agent 'wl-user-agent))
  (if (fboundp 'define-mail-user-agent)
      (define-mail-user-agent
        'wl-user-agent
        'wl-user-agent-compose
        'wl-draft-send
        'wl-draft-kill
        'mail-send-hook)))

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
                                     "* TODO %?\n  %u\n  %a" :clock-in t)
                                    ("c" "Clock notes" entry (clock)
                                     "* Notes for %U\n  From: %a\n%?")
                                    ("W" "Weekly update" entry (file "")
                                     "* TODO Weekly update\n  DEADLINE: <%(org-read-date nil nil \"Fri\") 10:00>"
                                     :immediate-finish t)
                                    ("w" "Weekly update item" item (file+headline "" "TODO Weekly update")
                                     "%?")
                                    ("D" "Weekly Darren Demo Prep" entry (file "")
                                     "* TODO Weekly Darren Demo Prep\n  DEADLINE: <%(org-read-date nil nil \"+2Thu\") 14:00>"
                                     :immediate-finish t)
                                    ("d" "Darren Demo update item" item (file+headline "" "TODO Weekly Darren Demo Prep")
                                     "%?")))
           (org-agenda-clockreport-parameter-plist '(:link t :maxlevel 3))
           (org-babel-load-languages (append org-babel-load-languages
                                             (list (cons 'shell t))))
           (org-agenda-span 'day))
  :config (add-to-list 'org-modules 'habits))

(use-package org-journal
  :after org)

(use-package ob-mermaid
  :after org
  :config
  (add-to-list 'org-babel-load-languages '(mermaid . t))
  (setq ob-mermaid-cli-path "~/.nvm/versions/node/v7.0.0/bin/mmdc")
  )

(use-package auth-source
  :custom (auth-sources (list "~/.authinfo.gpg"
                              "~/.authinfo"
                              "~/.netrc")))

(use-package epa
  :custom (epa-pinentry-mode 'loopback))

(use-package helm-pass
  :commands helm-pass)

(use-package auto-virtualenv
  :disabled t
  :after projectile
  :config
  (add-hook 'python-mode-hook 'auto-virtualenv-set-virtualenv)
  (add-hook 'window-configuration-change-hook 'auto-virtualenv-set-virtualenv)
  (add-hook 'focus-in-hook 'auto-virtualenv-set-virtualenv)
  )

;; (setq python-shell-interpreter "/Users/mbatema/.pyenv/shims/ipython"
      ;; python-shell-interpreter-args "-i --simple-prompt")
;; (setq elpy-shell-echo-output nil)
;; (setq python-shell-prompt-detect-failure-warning nil)
;; (setq python-shell-completion-native-enable nil)
(use-package elpy
  :disabled t
  :after auto-virtualenv
  :custom ((elpy-rpc-python-command "python")
           (elpy-shell-starting-directory 'current-directory "use folder file is in, for .python-version reasons")
           (elpy-shell-use-project-root nil))
  :config (elpy-enable))

(use-package pyenv-mode
  :disabled t
  :after projectile
  :config (pyenv-mode)
  (defun ssbb-pyenv-hook ()
    "Automatically activates pyenv version if .python-version file exists."
    (f-traverse-upwards
     (lambda (path)
       (let ((pyenv-version-path (f-expand ".python-version" path)))
         (if (f-exists? pyenv-version-path)
             (progn (pyenv-mode-set (s-trim (f-read-text pyenv-version-path 'utf-8)))
                    t))))))
  (add-hook 'projectile-after-switch-project-hook 'ssbb-pyenv-hook)
)

(use-package ein
  :commands ein:jupyter-server-start
  :config
  (setq ein:jupyter-default-notebook-directory "~/dev")
  (require 'ein-loaddefs)
  (require 'ein-notebook)
  (require 'ein-subpackages))

(use-package company-jedi
  :disabled t
  :config
  (add-to-list 'company-backends 'company-jedi))

(use-package lsp-python-ms
  :disabled t
  :hook (python-mode-hook . (lambda ()
                              (require 'lsp-python-ms)
                              (lsp))))

;; (use-package)



(use-package wgrep-helm
  :custom ((wgrep-auto-save-buffer t "I use git, so autosave is cool")))

(use-package protobuf-mode)

(use-package es-mode)

(use-package pushover
  :custom (pushover-user-key (plist-get (car (auth-source-search :host "pushover"))
                                        :token)))

(use-package circleci-api
  :custom (circleci-api-token (plist-get (car (auth-source-search :host "circleci"))
                                         :token))
  )

(if nil
    (progn
      (circleci-api-org-slug "github" "Apixio")
      (circleci-api-get-pipelines (circleci-api-org-slug "github" "Apixio"))
      (circleci-api-get-project (circleci-api-project-slug "github" "Apixio" "apx-interop")
                                :sync t
                                :handler (cl-function
                                          (lambda (&key data &allow-other-keys)
                                            (insert (format "\n;; %S" data)))))
      (circleci-api-get-project-pipelines (circleci-api-project-slug "github" "Apixio" "python-apxapi")
                                          :sync t
                                     :handler (cl-function
                                               (lambda (&key data &allow-other-keys)
                                                 (insert (format "\n%S" (alist-get 'items data))))))

      (circleci-api-trigger-pipeline (circleci-api-project-slug "github" "Apixio" "python-apxapi")
                                     :branch "tqdm_slack_updater"
                                     :pipeline-parameters '((force-publish . t))
                                     :sync t
                                     :handler (cl-function
                                               (lambda (&key data &allow-other-keys)
                                                 (insert (format "\n;; %S" data)))))

      (circleci-api-trigger-pipeline (circleci-api-project-slug "github" "Apixio" "python-apxapi")
                                     :branch "tqdm_slack_updater"
                                     :pipeline-parameters '((force-publish . t))
                                     :sync t
                                     :handler (cl-function
                                               (lambda (&key data &allow-other-keys)
                                                 (insert (format "\n;; %S" data)))))
      (circleci-api-trigger-pipeline (circleci-api-project-slug "github" "Apixio" "mono")
                                     :branch "hackday-2022-pirate-edition"
                                     :pipeline-parameters '((force_publish . t)
                                                            (force_docker_build . t))
                                     :sync t
                                     :handler (cl-function
                                               (lambda (&key data &allow-other-keys)
                                                 (insert (format "\n;; %S" data)))))
      ;; ((number . 1829) (state . "pending") (id . "92976bfb-9333-4b64-b248-742ee547d642") (created_at . "2023-05-04T10:22:25.511Z"))


      (circleci-api-get-my-project-pipelines (circleci-api-project-slug "github" "Apixio" "mono")
                                             :sync t
                                             :handler (cl-function
                                                       (lambda (&key data &allow-other-keys)
                                                         (insert (format "\n%S" (alist-get 'items data))))))
      (circleci-api-get-pipeline-workflows "5309c9a1-c9cd-4316-8651-03e1f531ceef"
                                           :sync t
                                           :handler (cl-function
                                                     (lambda (&key data &allow-other-keys)
                                                       (insert (format "\n;; %S" (alist-get 'items data))))))
      (circleci-api-get-workflow-jobs "b7ccb4ba-2642-476e-84a4-41bbc9e218a7"
                                      :sync t
                                      :handler (cl-function
                                                (lambda (&key data &allow-other-keys)
                                                  (insert (format "\n;; %S" (alist-get 'items data))))))
      (circleci-api-run-paginated-request
       (concat (circleci-api--route--project
                (circleci-api-project-slug "github" "Apixio" "python-apxapi"))
               "/job"
               "/157"
               )
       :sync t
       :handler (cl-function
                 (lambda (&key data &allow-other-keys)
                   (insert (format "\n;; %S" data))))
       )

      (magit-get "remote.origin.url")
      (magit-get-@{push}-branch)
      (magit-get-push-branch)

      ;; v1 api?
      ))

(use-package org-ai
  :commands (org-ai-mode
             org-ai-global-mode)
  :init
  (add-hook 'org-mode-hook #'org-ai-mode) ; enable org-ai in org-mode
  (org-ai-global-mode) ; installs global keybindings on C-c M-a
  :config
  ;; (setq org-ai-default-chat-model "gpt-3.5-turbo")
  (org-ai-install-yasnippets) ; if you are using yasnippet and want `ai` snippets
)

(use-package quelpa
  ;; :custom ((quelpa-build-explicit-tar-format-p t "cuz I'm on OS X? Or do I need `brew install gnu-tar`?"))
  :init (quelpa-self-upgrade)
  )
(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://github.com/quelpa/quelpa-use-package.git"))
(use-package quelpa-use-package
  :custom ((use-package-ensure-function 'quelpa "trying out quelpa and quelpa-use-package")))
(use-package copilot
  :quelpa (copilot :fetcher github
                   :repo "zerolfx/copilot.el"
                   :branch "main"
                   :files ("dist" "*.el"))
  )

(use-package restart-emacs)

(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs ready in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

(if (= emacs-major-version 28)
    (add-to-list 'image-types 'svg))

(pushover-send "emacs"
               "startup complete")

(put 'narrow-to-region 'disabled nil)
