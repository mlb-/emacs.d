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

(require-package 'zenburn-theme)
(load-theme 'zenburn t)

(require-package 'nyan-mode)
(nyan-mode t)

;; Thanks, technomancy! (https://github.com/technomancy/emacs-starter-kit/)
(require-package 'better-defaults)
;; And, as per suggestion 1
;(require-package 'ido-hacks)
;; And, as per suggestion 2
;(setq ido-use-virtual-buffers t)
;; And, as per suggestion 3
;(require-package 'smex)
;(smex-initialize)
;(global-set-key (kbd "M-x") 'smex)
;(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
;(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(require-package 'helm)
(helm-mode t)

;; As per suggestion 4
;(require-package 'ido-ubiquitous)
;(ido-ubiquitous)

;; As per suggestion 5
(require-package 'paredit)
(eval-after-load 'paredit
                 '(progn
                    (define-key paredit-mode-map (kbd "M-{") 'paredit-wrap-curly)
                    (define-key paredit-mode-map (kbd "M-[") 'paredit-wrap-square)))

(add-hook 'emacs-lisp-mode-hook 'paredit-mode)

;; As per suggestion 6
(require-package 'idle-highlight-mode)
(defun my-coding-hook ()
  (make-local-variable 'column-number-mode)
  (column-number-mode t)
  (if window-system (hl-line-mode t))
  (idle-highlight-mode t))

(add-hook 'prog-mode-hook 'my-coding-hook)

;; Clojure support

(require-package 'anzu)
(global-anzu-mode t)

;; colorcolumn/row?
;; relativenumber?
;; tabbar
(setq scroll-margin 1)
;; pre-save delete-trailing-whitespace
;; auto-resize splits
;; projectionist-like dispatch?
;; sudo-write
(require-package 'markdown-mode)
;; erlang-mode?
;; magit

(require-package 'auctex)

(require-package 'exec-path-from-shell)
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; syntastic -- flycheck?
;; tagbar
;; surround -- change balanced pairs
;; unimpaired?
;; nerdtree
;; speeddating

(require-package 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; look at evil-jumper
;; compare company-mode vs auto-complete
;; evil-mode?

(require-package 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
(pending-delete-mode t)

(require-package 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
