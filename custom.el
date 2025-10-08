(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(epg-pinentry-mode 'loopback nil nil "Customized with use-package epa")
 '(package-selected-packages
   '(anzu auctex better-defaults combobulate company copilot copilot-chat dap-mode delight devdocs docker edit-indirect
          ellama elm-mode exec-path-from-shell expand-region fancy-battery flycheck-elm flycheck-pos-tip forge
          fringe-current-line gist git-link gptel graphviz-dot-mode hcl-mode helm-descbinds helm-pass helm-projectile
          idle-highlight-mode js2-refactor kubel kubernetes lsp-javacomp lsp-ui maxframe nyan-mode org-gcal org-jira
          org-journal paredit pushover python-pytest quelpa-use-package rainbow-delimiters rainbow-identifiers
          restart-emacs smartparens solarized-theme spaceline super-save treesit-auto undo-tree wgrep-helm))
 '(safe-local-variable-values
   '((eval setq-local dap-python-executable (string-trim (shell-command-to-string "poetry run which python")))
     (eval setq exec-path
           (append exec-path '("/Users/matthewbatema/dev/vynca-enterprise-hotfix/apps/vos-core-svc/.venv/bin")))
     (projectile-project-test-cmd
      . "git describe --tags && cd infrastructure/projects/auth0/nonprod/ && source ../auth0_dev_creds && terraform plan -refresh=false -out=plan.out && terraform show -json plan.out | tee plan.json | jq -rc '.resource_changes[] | select(.change.actions == [\"delete\"]) | .address' | tee missing_from_nonprod")
     (projectile-project-install-cmd
      . "cd infrastructure/projects/auth0/ && source ./auth0_dev_creds && ./fetch_dev_tenant_state_to_nonprod.sh")
     (projectile-project-install-cmd . "git describe --tags && poetry sync --no-ansi")
     (git-ls-extra-args "apps/vos-core-svc" "docs") (gptel-mode)
     (projectile-project-test-cmd
      . "git describe --tags && cd infrastructure/projects/auth0/nonprod/ && source ../auth0_mlb_sandbox_creds && terraform plan -refresh=false -out=plan.out && terraform show -json plan.out | tee plan.json | jq -rc '.resource_changes[] | select(.change.actions == [\"delete\"]) | .address' | tee missing_from_nonprod")
     (projectile-project-install-cmd
      . "cd infrastructure/projects/auth0/ && source ./auth0_mlb_sandbox_creds && ./fetch_dev_tenant_state_to_nonprod.sh")
     (projectile-project-test-cmd
      . "git describe --tags && cd infrastructure/projects/auth_0/nonprod/ && source ../auth0_mlb_sandbox_creds && terraform plan -refresh=false -out=plan.out && terraform show -json plan.out | tee plan.json | jq -rc '.resource_changes[] | select(.change.actions == [\"delete\"]) | .address' | tee missing_from_nonprod")
     (projectile-project-install-cmd
      . "cd infrastructure/projects/auth_0/ && source ./auth0_mlb_sandbox_creds && ./fetch_dev_tenant_state_to_nonprod.sh")
     (projectile-project-install-cmd . "git describe --tags && poetry install --sync")
     (projectile-project-test-cmd . "terraform plan -refresh=false")
     (projectile-project-test-cmd . "git describe --tags && ./run_ci.sh vos-core-svc-integration")
     (projectile-project-test-cmd . "git describe --tags && ./run_ci.sh")
     (projectile-project-test-cmd . "git describe --tags && poetry run pytest $(git ls-files -m vos_core tests)")
     (projectile-project-run-cmd . "git describe --tags && poetry run python -m vos_core serve")
     (eval setq exec-path (append exec-path '("/Users/matthewbatema/dev/vynca-enterprise/apps/vos-core-svc/.venv/bin")))
     (eval setq exec-path
           (append exec-path '("/Users/matthewbatema/dev/vynca-enterprise/apps/vos-core-svc/.venv/bin/python")))
     (projectile-project-run-cmd . "git describe --tags && cd apps/vos-core-svc/ && poetry run python -m vos_core serve")
     (projectile-project-test-cmd
      . "git describe --tags && cd apps/vos-core-svc/ && poetry run pytest $(git ls-files -m vos_core tests)")
     (projectile-project-run-cmd . "cd apps/vos-core-svc/ && poetry run python -m vos_core serve") (copilot-opt-in . t)
     (eval setq exec-path (append exec-path '("~/Library/Caches/pypoetry/virtualenvs/vos-core-svc-AUke3mro-py3.12/bin")))
     (projectile-project-test-cmd . "cd apps/vos-core-svc/ && poetry run pytest $(git ls-files -m vos_core tests)"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
