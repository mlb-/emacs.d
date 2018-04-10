(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(alert-user-configuration
   (quote
    ((((:status buried idle)
       (:mode . "^compilation-mode$"))
      pushover
      ((:continue . t)))
     (nil notifier nil)
     (nil log nil))))
 '(aw-keys (quote (106 107 108 97 115 100 102)) t)
 '(calendar-latitude 37.6239587 t)
 '(calendar-longitude -122.0439688 t)
 '(cider-repl-pop-to-buffer-on-connect nil t)
 '(cider-test-show-report-on-success t t)
 '(docker-tramp-use-names t)
 '(eldoc-idle-delay 0.1)
 '(elpy-rpc-python-command "python2")
 '(elpy-shell-use-project-root nil)
 '(epa-pinentry-mode (quote loopback))
 '(helm-command-prefix-key "C-c h")
 '(jiralib-url "https://apixio.atlassian.net")
 '(magit-branch-prefer-remote-upstream (quote ("master" "develop")))
 '(magit-diff-arguments nil)
 '(org-agenda-files
   (quote
    ("~/org/01_notes.org" "~/org/gcal/apixio_meals.org" "~/org/gcal/cater2me_cal.org" "~/org/gcal/gcal.org" "~/org/gcal/holiday_cal.org" "~/org/gcal/namely_cal.org" "~/org/gcal/team_cal.org")))
 '(org-agenda-include-diary t)
 '(org-default-notes-file "~/org/01_notes.org")
 '(org-directory "~/org")
 '(org-gcal-client-id
   "728858386604-l0jusukrscapt1tv0hfelpnlfdofpbqk.apps.googleusercontent.com")
 '(org-gcal-client-secret "g2bpW0zhi_6WjKNiQmgibpUO")
 '(org-gcal-file-alist (quote (("mbatema@apixio.com" . "~/org/gcal.org"))))
 '(org-jira-property-overrides (quote (("Work Hours" . "estimate"))))
 '(org-log-into-drawer t)
 '(org-log-state-notes-insert-after-drawers t)
 '(package-selected-packages
   (quote
    (org-gcal org-jira ox-gfm htmlize ob-mermaid flycheck-mypy lsp-python-ms esup s3ed company-emoji emojify scala-mode ein robots-txt-mode lsp-ui company-lsp gist lsp-javacomp projectile git-link docker-compose-mode dockerfile-mode ob-shell ob-sh wanderlust groovy-mode apiwrap flycheck-elm elm-mode ox-confluence gitter ox-jira restart-emacs which-key fancy-battery spaceline delight yaml-mode use-package undo-tree super-save solarized-theme smartparens slack rainbow-identifiers rainbow-delimiters pyenv-mode py-autopep8 pushover pandoc org-journal nyan-mode n4js maxframe markdown-mode js2-refactor jade-mode idle-highlight-mode helm-projectile helm-pass helm-descbinds graphviz-dot-mode flycheck-pos-tip flycheck-clojure expand-region exec-path-from-shell es-mode ensime elpy dot-mode docker diminish copy-as-format company-quickhelp company-jedi clj-refactor better-defaults auctex anzu ace-window)))
 '(projectile-completion-system (quote helm))
 '(projectile-switch-project-action (quote projectile-vc))
 '(projectile-use-git-grep t)
 '(pushover-user-key "umr451kc8cap2iqkxxnpho48voc9qe")
 '(safe-local-variable-values
   (quote
    ((projectile-project-run-cmd . "APX_VAULT_TOKEN=$(python -c 'import apxapi; print(apxapi.session().get_vault_token())') sbt -Dbcprovpath=/Users/$(whoami)/Downloads/bcprov-jdk15on-1.58.jar -Dbcfipspath=/Users/$(whoami)/Downloads/bc-fips-1.0.2.jar clean \"run server application-dev.yaml\" -jvm-debug 5005 &> log.log")
     (projectile-project-run-cmd . "spark-submit --master local[4] --driver-memory 4g --class com.apixio.sparkapps.ocr.OcrApp target/apx-spark-apps.jar")
     (projectile-project-run-cmd . "pip install .")
     (projectile-project-test-cmd . "tox")
     (projectile-project-compilation-cmd . "rm -rf ~/.m2/repository/apixio/scala-common_* ~/.ivy2/{cache,local}/apixio/scala-common_*; sbt clean publishM2")
     (projectile-project-compilation-cmd . "rm -rf ~/.m2/repository/apixio/apixio-pipeline*; mvn clean -Dmaven.test.skip=true install")
     (projectile-project-compilation-cmd . "rm -rf ~/.m2/repository/apixio/app-platform-bizlogic_* ~/.ivy2/cache/apixio/app-platform-bizlogic_*; sbt clean publishM2")
     (projectile-project-run-cmd . "sbt clean \"run server application-dev.yaml\" -jvm-debug 5005 &> log.log")
     (projectile-project-run-cmd . "sbt clean run -jvm-debug 5005 &> log.log")
     (projectile-project-compilation-cmd . "rm -rf ~/.m2/repository/apixio/scala-common_* ~/.ivy2/cache/apixio/scala-common_*; sbt clean publishM2")
     (projectile-project-compilation-cmd . "LC_ALL=C java -cp ../../Downloads/bcpkix-jdk15on-1.47.jar:$(echo buildable/target/apixio-hadoop-jobs-*-SNAPSHOT.jar) com.apixio.ocr.OcrTest ~/Desktop/known_text/54263ca2-3d0d-4900-945b-d9294f94e147.pdf")
     (projectile-project-test-cmd . "mvn clean test")
     (projectile-project-run-cmd . "rm -rf ~/.m2/repository/apixio/apixio-hadoop-jobs; mvn -f buildable/pom.xml -U clean -Dmaven.test.skip=true package")
     (projectile-project-run-cmd . "sbt clean \"run server\" -jvm-debug 5005 &> log.log")
     (projectile-project-compilation-cmd . "rm -rf ~/.m2/repository/apixio/apixio-hadoop-jobs; mvn -f buildable/pom.xml -U clean -Dmaven.test.skip=true package")
     (projectile-project-run-cmd . "LC_ALL=C java -cp ../../Downloads/bcpkix-jdk15on-1.47.jar:$(echo buildable/target/apixio-hadoop-jobs-*-SNAPSHOT.jar) com.apixio.ocr.OcrTest ~/Desktop/known_text/54263ca2-3d0d-4900-945b-d9294f94e147.pdf")
     (projectile-project-compilation-cmd . "rm -rf ~/.m2/repository/apixio/apixio-hadoop-jobs; mvn -f buildable/pom.xml -U clean -Dmaven.test.skip=true deploy")
     (projectile-project-test-cmd . "mvn -T1C -U -f buildable/pom.xml clean test")
     (projectile-project-run-cmd . "sbt clean test:run -jvm-debug 5005 &> log.log")
     (projectile-project-run-cmd . "sbt clean \"run server src/test/resources/application.yaml\" -jvm-debug 5005 &> log.log")
     (projectile-project-compilation-cmd . "rm -rf ~/.m2/repository/apixio/swagger-ui-resources; mvn clean -Dmaven.test.skip=true install")
     (projectile-project-test-cmd . "robot -d reports test_cases")
     (projectile-project-compilation-cmd . "rm -rf ~/.m2/repository/apixio/scala-common_*; sbt clean publishM2")
     (projectile-project-compilation-cmd . "rm -rf ~/.m2/repository/apixio/application-dropwizard-base_*; sbt clean publishM2")
     (projectile-project-compilation-cmd . "sbt \"release with-defaults\"")
     (projectile-project-compilation-cmd . "rm -rf ~/.m2/repository/apixio/application-dropwizard-base_2.11; sbt clean publishM2")
     (projectile-project-compilation-cmd . "sbt clean rpm:publish")
     (projectile-project-compilation-cmd . "sbt clean rpm:deploy")
     (projectile-project-run-cmd . "sbt clean \"run server src/test/resources/application.yaml\"")
     (projectile-project-run-cmd . "mvn release:clean -Darguments=\"-DskipTests\" release:prepare < /dev/null")
     (projectile-project-compilation-cmd . "rm -rf ~/.m2/repository/apixio/scala-common_2.11; sbt clean publishM2")
     (projectile-project-run-cmd . "sbt \"release with-defaults\"")
     (projectile-project-test-cmd . "sbt clean test")
     (projectile-project-run-cmd . "sbt clean \"run server application.yaml\"")
     (projectile-project-compilation-cmd . "rm -rf ~/.m2/repository/apixio/apixio-metrics*; mvn clean -Dmaven.test.skip=true install")
     (projectile-project-run-cmd . "mvn release:prepare")
     (projectile-project-run-cmd . "rm -rf ~/.m2/repository/apixio/scala-common_2.11; sbt clean publishM2")
     (projectile-project-run-cmd . "sbt clean publishM2")
     (projectile-project-run-cmd . "sbt clean \"run server application-dev.yaml\"")
     (projectile-project-run-cmd . "sbt clean publishLocal")
     (projectile-project-run-cmd . "sbt \"run server application.yaml\"")
     (projectile-project-run-cmd . "sbt \"run server application-dev.yaml\""))))
 '(sky-color-clock-enable-emoji-icon nil)
 '(sky-color-clock-enable-xpm-icon t)
 '(use-package-always-ensure t)
 '(use-package-hook-name-suffix "")
 '(use-package-verbose t)
 '(whitespace-line-column 80)
 '(whitespace-style (quote (face tabs empty trailing lines-tail))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
