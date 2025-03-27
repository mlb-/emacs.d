(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(epg-pinentry-mode 'loopback nil nil "Customized with use-package epa")
 '(package-selected-packages
   '(code-review typescript-mode copilot-chat ellama combobulate treesit-auto poetry pytest python-pytest dap-mode dap magit-todos kubel kubernetes dockerfile-mode edit-indirect hcl-mode forge magit yaml closql emacsql copilot editorconfig quelpa-use-package quelpa company-lsp yaml-mode which-key wgrep-helm undo-tree super-save spaceline solarized-theme smartparens restart-emacs rainbow-identifiers rainbow-delimiters pushover org-journal org-gcal nyan-mode maxframe lsp-ui lsp-javacomp js2-refactor idle-highlight-mode helm-projectile helm-pass helm-descbinds graphviz-dot-mode git-link gist flycheck-pos-tip flycheck-elm flycheck-clojure fancy-battery expand-region exec-path-from-shell elm-mode docker delight company clj-refactor better-defaults auctex anzu ace-window))
 '(safe-local-variable-values
   '((projectile-project-test-cmd . "git describe --tags && cd infrastructure/projects/auth0/nonprod/ && source ../auth0_mlb_sandbox_creds && terraform plan -refresh=false -out=plan.out && terraform show -json plan.out | tee plan.json | jq -rc '.resource_changes[] | select(.change.actions == [\"delete\"]) | .address' | tee missing_from_nonprod")
     (projectile-project-install-cmd . "cd infrastructure/projects/auth0/ && source ./auth0_mlb_sandbox_creds && ./fetch_dev_tenant_state_to_nonprod.sh")
     (projectile-project-test-cmd . "git describe --tags && cd infrastructure/projects/auth_0/nonprod/ && source ../auth0_mlb_sandbox_creds && terraform plan -refresh=false -out=plan.out && terraform show -json plan.out | tee plan.json | jq -rc '.resource_changes[] | select(.change.actions == [\"delete\"]) | .address' | tee missing_from_nonprod")
     (projectile-project-install-cmd . "cd infrastructure/projects/auth_0/ && source ./auth0_mlb_sandbox_creds && ./fetch_dev_tenant_state_to_nonprod.sh")
     (projectile-project-install-cmd . "git describe --tags && poetry install --sync")
     (projectile-project-test-cmd . "terraform plan -refresh=false")
     (projectile-project-test-cmd . "git describe --tags && ./run_ci.sh vos-core-svc-integration")
     (projectile-project-test-cmd . "git describe --tags && ./run_ci.sh")
     (projectile-project-test-cmd . "git describe --tags && poetry run pytest $(git ls-files -m vos_core tests)")
     (projectile-project-run-cmd . "git describe --tags && poetry run python -m vos_core serve")
     (eval setq exec-path
           (append exec-path
                   '("/Users/matthewbatema/dev/vynca-enterprise/apps/vos-core-svc/.venv/bin")))
     (eval setq exec-path
           (append exec-path
                   '("/Users/matthewbatema/dev/vynca-enterprise/apps/vos-core-svc/.venv/bin/python")))
     (projectile-project-run-cmd . "git describe --tags && cd apps/vos-core-svc/ && poetry run python -m vos_core serve")
     (projectile-project-test-cmd . "git describe --tags && cd apps/vos-core-svc/ && poetry run pytest $(git ls-files -m vos_core tests)")
     (projectile-project-run-cmd . "cd apps/vos-core-svc/ && poetry run python -m vos_core serve")
     (copilot-opt-in . t)
     (eval setq exec-path
           (append exec-path
                   '("~/Library/Caches/pypoetry/virtualenvs/vos-core-svc-AUke3mro-py3.12/bin")))
     (projectile-project-test-cmd . "cd apps/vos-core-svc/ && poetry run pytest $(git ls-files -m vos_core tests)"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
