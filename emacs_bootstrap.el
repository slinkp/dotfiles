(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-refresh-contents)
(package-install 'use-package)

(custom-set-variables
 '(package-selected-packages
   ;; Unfortunate to have to duplicate this from .emacs
   '(yaml-mode aggressive-indent shadowenv helm-flycheck multi-web-mode git-link fill-column-indicator diminish sphinx-doc highlight-indentation flycheck s use-package pyvenv python-mode php-mode multiple-cursors markdown-preview-mode magit js2-mode jedi-core helm-projectile go-mode find-file-in-repository exec-path-from-shell dumb-jump ctable auto-complete)))

(package-install-selected-packages)
