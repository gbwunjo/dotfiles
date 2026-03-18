;;; init.el --- Main Emacs Configuration

;;; Commentary:
;; Modular Emacs configuration for Go, Python, TypeScript/React development
;; All modules are in ~/.emacs.d/modules/

;;; Code:

;; ============================================================================
;; Package Management
;; ============================================================================

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; ============================================================================
;; Load Modules
;; ============================================================================

(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

;; Core settings (always load)
(require 'mod-core)           ;; Basic settings, theme, keybindings
(require 'mod-completion)     ;; Ivy, Counsel, Company
(require 'mod-project)        ;; Projectile, NeoTree, search
(require 'mod-editing)        ;; Multiple cursors, duplicate, etc.
(require 'mod-lsp)            ;; LSP configuration

;; Language modules (comment out any you don't need)
(require 'mod-go)             ;; Go development
(require 'mod-python)         ;; Python development
(require 'mod-typescript)     ;; TypeScript/JavaScript/React
(require 'mod-web)            ;; HTML, CSS, Tailwind

;; docker modes
(use-package docker
  :defer t
  :ensure t
  :config
  (setf docker-command "docker"
	docker-compose-command "docker-compose"
	docker-container-tramp-method "docker"))

(use-package dockerfile-mode
  :defer t
  :ensure t
  :config
  (setq dockerfile-mode-command "docker"))

(use-package yaml-mode
  :defer t
  :ensure t
  :mode
  ("\\.taml\\'" "\\.yml\\'")
  :custom-face
  (font-lock-variable-name-face ((t (:foreground "#cba6f7"))))
  :config)

;; ============================================================================
;; Custom Keybindings Summary
;; ============================================================================

;; File & Buffer Navigation:
;; C-x C-f       - Find file (counsel-find-file)
;; C-x b         - Switch buffer (ivy-switch-buffer)
;; C-c p f       - Find file in project
;; C-c p p       - Switch project
;; C-c r         - Recent files (counsel-recentf)
;; C-c t         - Toggle file tree (neotree)
;; C-c C-t       - Open file tree at project root

;; Search:
;; C-s           - Search in buffer (swiper)
;; C-c / s       - Search text in project (counsel-rg)
;; C-c / f       - Find files by name (fuzzy)
;; C-c / w       - Search word at cursor
;; C-c / p       - Switch project
;; C-c / b       - Switch buffer in project

;; Code Navigation (all languages):
;; M-.           - Go to definition
;; M-,           - Go back
;; C-c l d       - Describe thing at point (documentation)
;; C-c l r       - Rename symbol
;; C-c l a       - Code actions
;; C-c l f       - Format buffer

;; Window Management:
;; C-x 2         - Split horizontal
;; C-x 3         - Split vertical
;; C-x 0         - Close window
;; C-x <arrows>  - Move between windows

;; Editing:
;; C-c d         - Duplicate line/region
;; C-c m c       - Multiple cursors on lines
;; C->           - Mark next like this
;; C-<           - Mark previous like this

;; Python specific:
;; C-c t t       - Pytest dispatch
;; C-c t f       - Test file
;; C-c t m       - Test function

;; TypeScript/React specific:
;; C-c n r       - Run npm script
;; C-c n i       - npm install
;; C-c n t       - npm test

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(yaml-mode dockerfile-mode docker auto-rename-tag rainbow-mode emmet-mode scss-mode web-mode add-node-modules-path nodejs-repl npm-mode prettier-js json-mode rjsx-mode js2-mode typescript-mode python-pytest python-docstring python-isort python-black pyvenv lsp-pyright lsp-ivy move-text expand-region smartparens which-key rg neotree multiple-cursors lsp-ui ivy-rich ivy-prescient go-mode counsel-projectile company catppuccin-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
