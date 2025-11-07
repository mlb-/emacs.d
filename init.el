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
  :config (load-theme 'solarized-light t))

(use-package calendar
  :custom ((calendar-latitude 37.6239587)
           (calendar-longitude -122.0439688)))

(use-package sky-color-clock
  :disabled t
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
  :config (spaceline-emacs-theme))

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
  :delight ""
  :config (super-save-mode +1))

(use-package autorevert
  :delight auto-revert-mode)

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
  :delight helm-mode
  :config (helm-mode t))

(use-package helm-projectile
  :custom (projectile-completion-system 'helm)
  :config (helm-projectile-on))

(use-package helm-descbinds
  :after which-key
  :custom (helm-descbinds-disable-which-key nil)
  :config (helm-descbinds-mode))

(use-package which-key
  :delight ""
  :config (which-key-mode))

;; As per suggestion 4
(use-package ido-ubiquitous
  :disabled t
  :config (ido-ubiquitous))

;; As per suggestion 5
(use-package paredit
  :delight "()"
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
  :disabled t
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
  :disabled t
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
  :disabled t
  :after cider)

(use-package flycheck-clojure
  :disabled t
  :after cider
  :config (flycheck-clojure-setup))


(use-package anzu
  :delight ""
  :config (global-anzu-mode t))

;; colorcolumn/row?
;; relativenumber?
;; tabbar
(setq scroll-margin 1)
;; auto-resize splits

(use-package projectile
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
  (defun helm-projectile-grep-with-dir (&optional directory)
    (interactive "P")
    (when current-prefix-arg
      (setq directory (read-directory-name "Grep within: " nil (projectile-project-root) t)))
    (helm-projectile-grep directory))
  ;; (define-key projectile-command-map (kbd "s g") #'helm-projectile-grep)
  ;; (define-key projectile-command-map [remap helm-projectile-grep] #'helm-projectile-grep-with-dir)
  (define-key projectile-command-map (kbd "s g") #'helm-projectile-grep-with-dir)
  :bind-keymap ("C-c p" . projectile-command-map)
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
(use-package markdown-mode
  :custom ((markdown-command "grip - --export -"))
  )
;; erlang-mode?
(use-package magit
  ;; :pin melpa-stable
  :bind ("C-c g" . magit-status)
  :custom (magit-branch-prefer-remote-upstream '("master" "develop")))

(use-package bug-reference
  :after magit
  :hook (magit-mode-hook . bug-reference-mode))

(use-package forge
  :after magit
  :pin melpa)

(use-package magit-gitlab
  :disabled t
  :after magit
  :pin melpa-stable
  :ensure t
  :config
  ;; Update magit-mode-map such that pressing @ opens the magit-gitlab-mr transient
  (define-key magit-mode-map (kbd "@") 'magit-gitlab-mr)
  (transient-append-suffix 'magit-dispatch "!" '("@" "Act on MR" magit-gitlab-mr)))

(use-package magit-todos
  :disabled t
  :after magit
  :custom ((magit-todos-branch-list-merge-base-ref "@{u}" "Just ask the branch what its upstream is."))
  :config (magit-todos-mode 1))

(use-package git-link
  :preface (defun git-link-vynca-gitlab (host &rest args)
             (apply 'git-link-gitlab "gitlab.com" args))
  :config (add-to-list 'git-link-remote-alist '("vyngit" git-link-vynca-gitlab) git-link-remote-alist))

(use-package tex-site
  :ensure auctex)

(use-package flycheck
  :delight
  (flycheck-mode)
  (flyspell-mode)
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
  :delight smartparens-mode
  :hook ((hcl-mode-hook
          js2-mode-hook
          java-mode-hook
          json-mode-hook
          python-mode-hook) . turn-on-smartparens-strict-mode)
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
  :delight
  :hook (after-init-hook . global-company-mode)
  :custom ((lsp-completion-provider :capf))
  )

(use-package graphviz-dot-mode
  :mode "\\.dot$")

(use-package eldoc
  :delight ""
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
  :disabled t ; apparently I can use tramp-container?
  :custom (docker-tramp-use-names t))

(use-package undo-tree
  :delight ""
  :config (global-undo-tree-mode t))

(use-package yasnippet
  :disabled t
  :delight yas-minor-mode
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
  :bind (:map lsp-ui-mode-map
              ([remap xref-find-definitions] . 'lsp-ui-peek-find-definitions)
              ([remap xref-find-references] . 'lsp-ui-peek-find-references))
  :hook ((lsp-mode-hook . lsp-ui-mode)))

;; (use-package company-lsp)

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
  :delight ""
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
  :bind ("M-o" . ace-window))

(use-package alert
  :commands alert
  :custom (alert-user-configuration
           '(;; for gptel
             ((;(:status buried idle)
               (:category . "gptel"))
              pushover
              ((:continue . t)))
             ;; for compilation mode
             (((:status buried idle)
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
  :after alert
  :custom
  (pushover-user-key
   (plist-get (car (auth-source-search :host "pushover")) :token))
  :config
  ;; expose a `:style 'pushover` for `alert`
  (alert-define-style 'pushover
    :title "Send via Pushover"
    :notifier
    (lambda (info)
      (pushover-send
       (or (plist-get info :title) "Emacs alert")
       (or (plist-get info :message) "")))))


;; copilot?
(use-package quelpa
  ;; I had to install `gnu-tar`.
  ;; :custom ((quelpa-build-explicit-tar-format-p t "cuz I'm on OS X? Or do I need `brew install gnu-tar`?"))
  :init (quelpa-self-upgrade)
  )
;; (quelpa
;;  '(quelpa-use-package
;;    :fetcher git
;;    :url "https://github.com/quelpa/quelpa-use-package.git"))
(use-package quelpa-use-package)

(use-package copilot
  :quelpa (copilot :fetcher github
                   :repo "copilot-emacs/copilot.el"
                   :branch "main"
                   :files ("*.el"))
  :custom ((copilot-idle-delay 5))
  :bind (("C-c C-M-f" . copilot-diagnose)
         ("C-c M-f" . copilot-complete)
         :map copilot-completion-map
         ("C-g" . 'copilot-clear-overlay)
         ("M-p" . 'copilot-previous-completion)
         ("M-n" . 'copilot-next-completion)
         ("<tab>" . 'copilot-accept-completion)
         ("C-w" . 'copilot-accept-completion-by-word)
         ("C-l" . 'copilot-accept-completion-by-line))
  :init (setq exec-path (append exec-path '("/Users/matthewbatema/.nvm/versions/node/v22.14.0/bin")))
  :config (defun convert-md-headers-region (beg end)
            "Convert Markdown headers to Org headers in region."
            (interactive "r")
            (save-excursion
              (goto-char beg)
              (while (re-search-forward "^\\(#\\{1,6\\}\\)\\s-+" end t)
                (replace-match (make-string (length (match-string 1)) ?*) t t nil 1)))))

(use-package copilot-chat
  :quelpa (copilot-chat :fetcher github
                        :repo "chep/copilot-chat.el")
  :custom ((copilot-chat-follow t)
           ;; (copilot-chat-frontend 'markdown)
)
  :bind (("C-c M-F" . copilot-chat-transient))
  :config
  (defun copilot-chat--get-included-files-org (instance)
    "Generate a org header listing files from buffers in INSTANCE.
Argument INSTANCE is the copilot chat instance to get buffers from."
    (let* ((buffers (copilot-chat-buffers instance))
           (files (cl-remove-if #'null
                                (mapcar (lambda (buf)
                                          (when (buffer-live-p buf)
                                            (buffer-file-name buf)))
                                        buffers))))
      (when files
        (concat "* Included Files\n\n"
                (mapconcat (lambda (file)
                             (format "- ~%s~"
                                     (file-relative-name file
                                                         (copilot-chat-directory instance))))
                           files
                           "\n")
                "\n\n"))))

  (defun copilot-chat--add-files-from-org (instance org)
    "Parse ORG for file list and add them to INSTANCE buffers.
Argument INSTANCE is the copilot chat instance to modify.
Argument ORG is the text containing file paths to parse."
    (when (and org (string-match "* Included Files\n" org))
      (let ((files-section (substring org (match-end 0)))
            (base-dir (copilot-chat-directory instance))
            (file-paths nil))

        ;; Extract file paths from org list items
        (with-temp-buffer
          (insert files-section)
          (goto-char (point-min))
          (while (re-search-forward "- ~\\([^~]+\\)~" nil t)
            (push (match-string 1) file-paths)))

        ;; Add each file to the instance
        (dolist (rel-path file-paths)
          (let* ((full-path (expand-file-name rel-path base-dir))
                 (buf (and (file-exists-p full-path)
                           (find-file-noselect full-path))))
            (when buf
              (copilot-chat--add-buffer instance buf)))))))

  (defun copilot-chat-insert-included-files ()
    "Insert a org header listing files from current copilot chat instance."
    (interactive)
    (let* ((instance (copilot-chat--current-instance))
           (org (copilot-chat--get-included-files-org instance)))
      (when org
        (insert org))))

  (defun copilot-chat-update-buffers-from-org ()
    "Update current instance's buffers from org file list in current buffer."
    (interactive)
    (let ((instance (copilot-chat--current-instance))
          (org (buffer-substring-no-properties (point-min) (point-max))))
      (copilot-chat--add-files-from-org instance org)))

  ;; Add "Insert included files" command to the buffers transient
  (transient-append-suffix 'copilot-chat-transient-buffers "l"
    '("I" "Insert included files list" copilot-chat-insert-included-files))

  ;; Add "Update buffers from org" command after the previous one
  (transient-append-suffix 'copilot-chat-transient-buffers "I"
    '("U" "Update buffers from org" copilot-chat-update-buffers-from-org))

)

(use-package restart-emacs)

(use-package lsp-mode
  :hook (python-ts-mode-hook . lsp-mode)
  :custom ((lsp-pylsp-plugins-mypy-enabled t)
           (lsp-pylsp-plugins-ruff-enabled t)))

(use-package hcl-mode
  :mode "\\.tf$"
  )

(use-package kubel)
(use-package kubernetes)

(use-package dap-mode
  :after lsp-mode
  :commands dap-debug
  :config
  (require 'dap-python)
  (setq dap-python-debugger 'debugpy)
  )

(use-package python-pytest
  :after alert
  :custom ((python-pytest-executable "poetry run pytest"))
  :bind (("C-c C-S-p" . python-pytest-dispatch))
  :config
  ;; buffer-local scratch for one run
  (defvar-local my/pytest-start-time nil)

  (defun my/pytest-started ()
    "Remember start time + command line for the current pytest buffer."
    (setq my/pytest-start-time (current-time)))

  (defun my/pytest-parse-summary ()
    "Parse the final '== ... ==' pytest summary line in current buffer.
Handles optional '(h:mm:ss)' after seconds."
    (save-excursion
      (goto-char (point-max))
      (let* ((case-fold-search t)
             (summary
              (when (re-search-backward "^=\\{2,\\}\\s-+\\(.+?\\)\\s-+=\\{2,\\}\\s-*$" nil t)
                (match-string 1)))
             (tbl (make-hash-table :test 'eq)))
        (when summary
          ;; split on commas; duration may be glued to the last chunk
          (dolist (chunk (split-string summary "[[:space:]]*,[[:space:]]*" t))
            (let ((c chunk))
              ;; 1) pull out duration anywhere in the chunk, e.g., "in 1537.69s (0:25:37)"
              (when (string-match "in\\s-+\\([0-9.]+\\)s\\(?:\\s-*(\\([0-9:]+\\))\\)?\\s-*$" c)
                (puthash :duration (string-to-number (match-string 1 c)) tbl)
                ;; strip the duration tail so counts regex can match cleanly
                (setq c (replace-regexp-in-string
                         "\\s-*in\\s-+[0-9.]+s\\(?:\\s-*(\\([0-9:]+\\))\\)?\\s-*$" "" c)))
              ;; 2) counts like "15 passed", "3 warnings", etc.
              (when (string-match "\\`\\([0-9]+\\)\\s-+\\([[:alpha:]-]+\\)\\'" c)
                (puthash (intern (concat ":" (match-string 2 c)))
                         (string-to-number (match-string 1 c)) tbl))))
          ;; build plist + total (exclude :duration from total)
          (let ((plist '()) (total 0))
            (maphash (lambda (k v)
                       (setq plist (plist-put plist k v))
                       (unless (eq k :duration) (setq total (+ total v))))
                     tbl)
            (setq plist (plist-put plist :total total))
            (plist-put plist :summary summary))))))

  (defun my/pytest-extract-header ()
    "Extract `cwd:` and `cmd:` lines from a python-pytest buffer.
Returns a plist (:cwd PATH :cmd STR) or nil if not found."
    (save-excursion
      (goto-char (point-min))
      (let (cwd cmd)
        (when (re-search-forward "^cwd: \\(.*\\)$" nil t)
          (setq cwd (match-string 1)))
        (when (re-search-forward "^cmd: \\(.*\\)$" nil t)
          (setq cmd (match-string 1)))
        (when (or cwd cmd)
          (list :cwd cwd :cmd cmd)))))

  (defun my/pytest-finished ()
    "Notify with a compact summary when pytest finishes."
    (let* ((buf (current-buffer))
           (hdr (my/pytest-extract-header))
           (cwd (plist-get hdr :cwd))
           (cmd (plist-get hdr :cmd))
           (elapsed (when my/pytest-start-time
                      (float-time (time-subtract (current-time)
                                                 my/pytest-start-time))))
           (info (my/pytest-parse-summary))
           (duration (or (plist-get info :duration) elapsed))
           (line (or (plist-get info :summary)
                     "No summary line found."))
           (title (format "pytest finished (%s)"
                          (if duration (format "%.1fs" duration) "duration n/a")))
           (msg (string-join
                 (delq nil
                       (list
                        line
                        (and cwd (format "cwd: %s" cwd))
                        (and cmd (format "cmd: %s" cmd))))
                 "\n")))
      (display-buffer buf)
      (alert msg :title title :buffer buf))) ; uses your alert backends

  (add-hook 'python-pytest-started-hook  #'my/pytest-started)
  (add-hook 'python-pytest-finished-hook #'my/pytest-finished)
  )

(use-package treesit-auto
  :custom ((treesit-auto-install 'prompt)
           (treesit-auto-langs '(python json))
           )
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
  (add-to-list 'major-mode-remap-alist '(js-json-mode . json-ts-mode))
  (global-treesit-auto-mode)

  (defun treesit-which-function ()
    (treesit-defun-name (treesit-defun-at-point)))

  (add-hook 'python-ts-mode-hook (lambda ()
                                   (setq-local which-func-functions '(treesit-which-function))
                                   ))
  )

(use-package combobulate
  :hook ((python-ts-mode-hook . combobulate-mode))
  :custom (combobulate-key-prefix "C-c o")
  :bind ("C-c o" . combobulate)
  ;; :after treesit-auto
  :quelpa (combobulate :fetcher github
                       :repo "mickeynp/combobulate"))

(use-package ellama
  :custom (ellama-keymap-prefix "C-c l")
  )

(use-package code-review
  :disabled t ;; alas, looks like some sqlite dep error
)

(use-package fringe-current-line
  :config (global-fringe-current-line-mode)
  )

(use-package devdocs)

(use-package org-jira
  :custom ((jiralib-url "https://vyncahealthinc.atlassian.net")
           (org-jira-default-jql "assignee = currentUser() AND sprint IN openSprints() ORDER BY Rank ASC")
           (org-jira-done-states '("DONE"))
           (org-jira-priority-to-org-priority-alist '(("Highest" . ?A)
                                                      ("High" . ?B)
                                                      ("Low" . ?C)))
           (org-jira-progress-issue-flow '(("OPEN REQUEST" . "FULFILLING REQUEST")
                                           ("FULFILLING REQUEST" . "TESTING")
                                           ))
           (org-jira-use-status-as-todo t)
           (org-jira-custom-jqls '(
                                  (:jql "Sprint in openSprints() ORDER BY assignee ASC, Rank DESC" :limit 200 :filename "this-sprints-work")))))

(use-package gptel
  ;; wtf @ bug https://github.com/karthink/gptel/issues/556
  ;; :custom (gptel-backend (gptel-make-gh-copilot "Copilot"))
  :custom ((gptel-model 'gpt-5-mini))
  :after magit
  :config
  (setq gptel-backend (gptel-make-gh-copilot "Copilot"))

  ;; buffer-local scratch for one run
  (defvar-local my/gptel-start-time nil)

  (defun my/gptel-response-started ()
    "Mark the start of a gptel response in this buffer."
    (setq my/gptel-start-time (current-time)))

  (defun my/gptel--backend-name ()
    "Return a friendly backend/model string."
    (let ((backend (when (boundp 'gptel-backend) gptel-backend))
          (model   (when (boundp 'gptel-model)   gptel-model)))
      (format "%s%s"
              (cond
               ((symbolp backend) (symbol-name backend))
               ;; some backends are structs/objs; be defensive
               ((ignore-errors (slot-value backend 'name)))
               (t (format "%s" backend)))
              (if model (format " · %s" model) ""))))

  (defun my/gptel-response-finished (&rest _)
    "Notify when a gptel response completes (for long runs)."
    (let* ((buf (current-buffer))
           (elapsed (when my/gptel-start-time
                      (float-time (time-subtract (current-time) my/gptel-start-time))))
           (title (format "gptel finished (%s)"
                          (if elapsed (format "%.1fs" elapsed) "duration n/a")))
           ;; Try to include a compact hint of what finished.
           (msg (string-join
                 (delq nil
                       (list (buffer-name buf)
                             (my/gptel--backend-name)))
                 " — ")))
      (alert msg :title title :buffer buf :category "gptel")))

  (add-hook 'gptel-pre-response-hook  #'my/gptel-response-started)
  (add-hook 'gptel-post-response-hook #'my/gptel-response-finished)

  (defvar-local git-ls-extra-args nil
    "Extra arguments to pass to `git ls-files`.
    Set this in `.dir-locals.el` to customize behavior per repo.")

  (put 'git-ls-extra-args 'safe-local-variable
       (lambda (val)
         (and (listp val) (cl-every #'stringp val))))

  (defun git-ls ()
    "Return a list of tracked files in the current Git repository, optionally filtered."
    (let ((default-directory (magit-toplevel)))
      (unless default-directory
        (error "Not inside a Git repository"))
      (apply #'magit-git-lines "ls-files" git-ls-extra-args)))

  (gptel-make-tool
   :name "git-ls"
   :confirm t
   :description "List all Git-tracked files in the current repository."
   :category "Git"
   :function #'git-ls
   :args nil)

  (defun my/git-grep-files (pattern &optional
                                    ;; path
                                    case-insensitive)
    "Return a list of unique absolute file paths matching PATTERN using `git grep`.
;; If PATH is non-nil, limit the search to that path (relative to repo root).
If CASE-INSENSITIVE is non-nil, pass -i to git grep."
    (let* ((default-directory (or (magit-toplevel) (user-error "Not inside a Git repository")))
           (ci-flag (when case-insensitive "-i"))
           (args (delq nil
                       (append (list "grep" "-n" "--full-name" "--no-color"
                                     ;; pass case-flag if requested
                                     ci-flag
                                     "-e" pattern)
                               ;; path separator: if path provided, add "--" then path
                               ;; (when path (list "--" path))
                               ))))
      (apply #'magit-git-lines args)))

  (gptel-make-tool
   :name "my-search-files"
   :confirm t
   :description "Search repository using `git grep` and return a list of matching file paths."
   :category "Git"
   :function (lambda (pattern &optional
                              ;; path
                              case_insensitive)
               ;; return same shape as git-ls: a list of file path strings
               (my/git-grep-files pattern
                                  ;; path
                                  case_insensitive))
   :args (list
          '(:name "pattern" :type string :description "Pattern to search for (git grep -e)")
          ;; '(:name "path" :type "string" :description "Optional path within repo to restrict search" :optional t)
          '(:name "case_insensitive" :type boolean :description "Optional: make git grep case-insensitive" :optional t)))

  (defun git-current-branch-name ()
    "Return the name of the current Git branch."
    (let ((default-directory (magit-toplevel)))
      (unless default-directory
        (error "Not inside a Git repository"))
      (magit-git-string "rev-parse" "--abbrev-ref" "HEAD")))

  (gptel-make-tool
   :name "git-current-branch-name"
   :confirm t
   :description "Get the name of the current Git branch."
   :category "Git"
   :function #'git-current-branch-name
   :args nil)

  (defun magit-ddwim-diff-string ()
  "Return unified diff like Magit `dd`: BASE...HEAD where BASE is DWIM merge target."
  (let* ((default-directory (magit-toplevel))
         (base (or (magit-get-upstream-branch)      ; e.g. "origin/main" for the current branch
                   (magit-main-branch)       ; fallback: repo’s main branch name
                   "origin/HEAD")))
    (magit-git-lines "diff" "--no-ext-diff" "--patch" (format "%s...HEAD" base))))

  (gptel-make-tool
   :name "magit-ddwim-diff"
   :confirm t
   :description "Get a unified diff of the current branch against its upstream or main branch."
   :category "Git"
   :function #'magit-ddwim-diff-string
   :args nil)

  (defvar remove-nulls--excluded-keys '("avatarUrls" "iconUrl" "self" "customfield_10001" "worklog" "votes" "progress" "id")
    "Keys to exclude entirely from the JSON output.")

  (defun remove-nulls (obj)
    "Recursively remove nil values and excluded keys from OBJ."
    (cond
     ;; Alist: remove excluded keys and nil values, recurse into values
     ((and (listp obj) (not (vectorp obj)))
      (let ((cleaned (delq nil
                           (mapcar (lambda (pair)
                                     (when (and (consp pair)
                                                (not (member (format "%s" (car pair))
                                                             remove-nulls--excluded-keys)))
                                       (let ((v (remove-nulls (cdr pair))))
                                         (unless (null v)
                                           (cons (car pair) v)))))
                                   obj))))
        (if cleaned cleaned nil)))
     ;; Vector: recurse into elements
     ((vectorp obj)
      (apply 'vector (delq nil (mapcar #'remove-nulls obj))))
     ;; Otherwise return scalar
     (t obj)))

  (defun get-jira-ticket-json (ticket-key)
    "Fetch the raw JIRA issue for TICKET-KEY and return it as a JSON string, omitting null values."
    (let* ((raw (jiralib-get-issue ticket-key))
           (pruned (remove-nulls raw)))
      (json-encode pruned)))

  (gptel-make-tool
   :name "get-jira-ticket-json"
   :confirm t
   :description "Return the raw JIRA issue payload as a JSON string."
   :category "Jira"
   :function (lambda (ticket-key)
               (get-jira-ticket-json ticket-key))
   :args (list
          '(:name "ticket-key"
                  :type "string"
                  :description "The JIRA issue key, e.g. \"ABC-123\"")))

  (defun fetch-jira-sprint-tickets-for-user ()
    "Fetch JIRA issues assigned to the current user in active sprints.
Return the issues as a JSON-encoded string, sorted by rank in ascending order."
    (let* ((jql-query "assignee = currentUser() AND sprint in openSprints() AND ORDER BY rank ASC" 1)
           (issues (jiralib-do-jql-search jql-query))
           (filtered-issues (seq-remove #'null issues)))
      (json-encode filtered-issues)))

  (gptel-make-tool
   :name "get-my-jira-sprint-tickets-json"
   :confirm t
   :description "Fetch all JIRA issues assigned to the current user in active sprints, sorted by rank."
   :category "Jira"
   :function #'get-my-jira-sprint-tickets-json
   :args nil)

  ;; TODO: expose a JQL query tool
  ;; TODO: expose a mypy cache for file tool

  (defun git-cat-file (path &optional rev)
    "Return the contents of PATH at REV (defaults to HEAD) using `git cat-file`."
    (let ((default-directory (magit-toplevel)))
      (unless default-directory
        (error "Not inside a Git repository"))
      (let* ((rev (or rev "HEAD"))
             (blob (string-trim (magit-git-string "ls-tree" "-z" "-r" rev path)))
             (blob-id (when (string-match "\\b\\([0-9a-f]\\{40\\}\\)\\b" blob)
                        (match-string 1 blob))))
        (if blob-id
            (magit-git-output "cat-file" "-p" blob-id)
          (error "File not found at given rev: %s" path)))))

  (defun my/clipboard-text ()
    "Return system clipboard text, or fall back to kill ring."
    (or (and (fboundp 'gui-get-selection)
             (or (gui-get-selection 'CLIPBOARD nil)
                 (gui-get-selection 'CLIPBOARD 'STRING)))
        (let ((s (shell-command-to-string "pbpaste")))
          (unless (string-empty-p s) s))
        (current-kill 0 t)))

  (gptel-make-tool
   :name "clipboard-text"
   :confirm t
   :description "Get the current text content of the system clipboard."
   :category "System"
   :function #'my/clipboard-text
   :args nil)

  (setq gptel--known-presets
        '(
         (branch-prompt
          :description nil
          :backend "Copilot"
          :model gpt-5-mini
          :system "You are a large language model living in Emacs and a helpful assistant. Respond concisely.

Help me pick a branch name for my Jira ticket.

Don't use any prefix.

The branch name must start with the Jira ticket ID.

Use the `get-jira-ticket-json` tool to get the Jira ticket details.

Consider the ticket title and ticket description before providing a useful suffix for the branch name.

Use the `clipboard-text` tool to get the Jira ticket from my clipboard.
"
          :tools ("clipboard-text" "get-jira-ticket-json")
          :stream t
          :temperature 1.0
          :max-tokens nil
          :use-context system
          :track-media nil
          :include-reasoning t)
         (prompt-prompt
          :description nil
          :backend "Copilot"
          :model claude-sonnet-4
          :system default
          :tools ("get-jira-ticket-json" "git-current-branch-name" "git-ls")
          :stream t
          :temperature 1.0
          :max-tokens nil
          :use-context system
          :track-media nil
          :include-reasoning t)
         (mr-prompt
          :description nil
          :backend "Copilot"
          :model claude-sonnet-4
          :system "You are a large language model living in Emacs and a helpful assistant. Respond concisely.

You are my boss, an Engineering Manager, who happens to be an amazing Staff/Principal level Engineer in their own right,
and wants to help me also become a Staff/Principal Engineer. Read over the diff for my branch (`magit-ddwim-diff`) and
the associated Jira ticket (`git-current-branch-name` + `get-jira-ticket-json`) then:
- suggest a PR title that follows the Conventional Commits style
- in a markdown code block, write an PR (using Conventional Commits for both the PR title and each `Changes Made` entry)
- let me know if I've implemented too much beyond the scope of the ticket?
- let me know if I've missed implementation details or acceptance criteria from the ticket, especially in unit tests
- enumerate any added TODOs so I can resolve them or create follow-up tickets to address them
- clean it up (technically, readability, accessability, maintainability, testability, and any other sense that would be
  expected for my boss, a skilled former IC, to think of)

Please use the MR Template


"
          :tools ("get-jira-ticket-json" "git-current-branch-name" "magit-ddwim-diff")
          :stream t
          :temperature 1.0
          :max-tokens nil
          :use-context system
          :track-media nil
          :include-reasoning t)
         (mcp-meta-prompt
          :description "mcp-meta-prompt"
          :backend "Copilot"
          :model gpt-5-mini
          :system default
          :tools
          ("addCommentToJiraIssue"
           "atlassianUserInfo"
           "create_directory"
           "editJiraIssue"
           "edit_file"
           "get-jira-ticket-json"
           "getAccessibleAtlassianResources"
           "getJiraIssue"
           "getJiraIssueRemoteIssueLinks"
           "getJiraIssueTypeMetaWithFields"
           "get_file_info"
           "git-current-branch-name"
           "git-ls"
           "list_allowed_directories"
           "list_directory"
           "magit-ddwim-diff"
           "move_file"
           "my-search-files"
           "read_file"
           "read_multiple_files"
           "search"
           "searchJiraIssuesUsingJql"
           "sequentialthinking"
           "write_file")
          :stream t
          :temperature 1.0
          :max-tokens nil
          :use-context system
          :track-media nil
          :include-reasoning t)
         (mr-review
          :description nil
          :backend "Copilot"
          :model gpt-5-mini
          :system "
You are my boss, an Engineering Manager, who happens to be an amazing Staff/Principal level Engineer in their own right,
and wants to help me also become a Staff/Principal Engineer. Read over this MR and help me:
- let me know if I've implemented too much beyond the scope of the ticket?
- let me know if I've missed implementation details or acceptance criteria from the ticket, especially in unit tests
- enumerate any added TODOs so I can resolve them or create follow-up tickets to address them
- clean it up (technically, readability, accessability, maintainability, testability, and any other sense that would be
  expected for my boss, a skilled former IC, to think of)
"
          :tools
          ("addCommentToJiraIssue"
           "atlassianUserInfo"
           "download_attachment"
           "editJiraIssue"
           "execute_graphql"
           "getAccessibleAtlassianResources"
           "getJiraIssue"
           "getJiraIssueRemoteIssueLinks"
           "getJiraIssueTypeMetaWithFields"
           "get_branch_diffs"
           "get_commit"
           "get_commit_diff"
           "get_file_contents"
           "get_issue"
           "get_issue_link"
           "get_label"
           "get_merge_request"
           "get_merge_request_diffs"
           "get_namespace"
           "get_project"
           "get_project_events"
           "get_repository_tree"
           "get_users"
           "list_commits"
           "list_events"
           "list_group_iterations"
           "list_group_projects"
           "list_issue_discussions"
           "list_issue_links"
           "list_issues"
           "list_labels"
           "list_merge_requests"
           "list_namespaces"
           "list_project_members"
           "list_projects"
           "mr_discussions"
           "my_issues"
           "search"
           "searchJiraIssuesUsingJql"
           "search_repositories"
           "sequentialthinking"
           "verify_namespace")
          :stream t
          :temperature 1.0
          :max-tokens nil
          :use-context system
          :track-media nil
          :include-reasoning t)
         ;; insert new presets here
         )))

(use-package mcp
  :after gptel
  :custom
  ((mcp-hub-servers
    `(
      ;; ---  A. Fetch: super-basic web fetcher  ---
      ("fetch"
       :command "docker"
       :args ("run" "-i" "--rm" "--pull=always" "mcp/fetch"))
      ;; ("mcp-fetch"
      ;;  :command "npx"
      ;;  :args ("-y" "mcp-fetch"))
      ;; ("server-curl"
      ;;  :command "npx"
      ;;  :args ("-y" "@mcp-get-community/server-curl"))
      ;; ---  B. Filesystem: allow ~/dev as a sandbox  ---
      ;; NOTE: Docker image expects allowed dirs under /projects, so we bind mount.
      ("filesystem"
       :command "docker"
       :args ("run" "-i" "--rm"
              "--mount" ,(format "type=bind,src=%s,dst=/projects/vos-core-svc"
                                 (expand-file-name "~/dev/vynca-enterprise/apps/vos-core-svc/"))
              "--mount" ,(format "type=bind,src=%s,dst=/projects/prompts"
                                 (expand-file-name "~/dev/vynca-enterprise/prompts/"))
              "mcp/filesystem"
              "/projects"))
      ("atlassian"
       :command "npx"
       :args ("-y" "mcp-remote" "https://mcp.atlassian.com/v1/sse"))
      ("gitlab"
       :command "docker"
       :args ("run"
              "-i" "--rm"
              "-e" "GITLAB_PERSONAL_ACCESS_TOKEN"
              "-e" "GITLAB_API_URL"
              "-e" "GITLAB_READ_ONLY_MODE"
              "-e" "USE_GITLAB_WIKI"
              "-e" "USE_MILESTONE"
              "-e" "USE_PIPELINE"
              "iwakitakuma/gitlab-mcp")
       :env (:GITLAB_PERSONAL_ACCESS_TOKEN ,(funcall
                                             (plist-get (car (auth-source-search
                                                              :host "gitlab.com/api/v4"
                                                              :user "matthewbatema^mcp"
                                                              :max 1)) :secret))
                                           :GITLAB_API_URL "https://gitlab.com/api/v4"
                                           :GITLAB_READ_ONLY_MODE "true"
                                           :USE_GITLAB_WIKI "false"
                                           :USE_MILESTONE "false"
                                           :USE_PIPELINE "false"))
      ("sequentialthinking"
       :command "docker"
       :args ("run",
              "--rm",
              "-i",
              "mcp/sequentialthinking"))
      ;; more MCPs here
      ))
   (jsonrpc-default-request-timeout 300))

  :hook (after-init . mcp-hub-start-all-server)
  :config
  ;; Use the built-in hub so Emacs manages lifecycle (start/stop/restart)
  (require 'mcp-hub)
  (require 'gptel-integrations))

(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs ready in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

(pushover-send "emacs"
               "startup complete")
