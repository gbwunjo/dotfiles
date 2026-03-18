(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
	("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(setq inhibit-startup-screen t)

(global-display-line-numbers-mode 1)
(setq checkdoc-column-limit 200)

(show-paren-mode 1)

(recentf-mode 1)
(auto-save-mode -1)

(setq recentf-max-saved-items 50)

(save-place-mode 1)

(menu-bar-mode -1)

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; backup files
(setq make-backup-files nil)

(use-package catppuccin-theme
  :config
  (load-theme 'catppuccin :no-confirm)
  (setq catppuccin-flavor 'mocha)) ;; latte, frappe, macciato, mocha

(use-package ivy
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t))

(use-package counsel
  :after ivy
  :config
  (counsel-mode 1))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)))

(use-package projectile
  :config
  (projectile-mode +1)
  :bind-keymap
  ("C-c p" . projectile-command-map))

(use-package neotree
  :config
  (setq neo-smart-open t)
  (setq neo-window-width 40)
  (setq neo-autorefresh t)
  (setq projectile-switch-project-action 'neotree-projectile-action)
  :bind (("C-c t" . neotree-toggle)
	 ("C-c C-t" . neotree-projectile-action)))

(use-package duplicate-thing
  :bind
  (("C-c d" . duplicate-thing)))


;; window management
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)

(use-package which-key
  :config
  (which-key-mode))

(use-package ace-window
  :bind ("M-o" . ace-window)
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (set-face-attribute 'aw-leading-char-face nil
		      :height 2.0
		      :weight 'bold))

(global-set-key (kbd "C-c r") 'counsel-recentf)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(defun neotree-project-dir ()
  (interactive)
  (let ((project-dir (projectile-project-root))
	(file-name (buffer-file-name)))
    (neotree-toggle)
    (if project-dir
	(if (neo-global--window-exists-p)
	    (progn
	      (neotree-dir project-dir)
	      (neotree-find file-name)))
      (message "Could not find project root."))))

(use-package company
  :config
  (global-company-mode 1)
  (setq company-idle-delay 0.2)
  (setq company-minimum-prefix-length 1))

(use-package company-quickhelp
  :after company
  :config
  (company-quickhelp-mode 1))

(use-package rg
  :config
  (rg-enable-default-bindings))

;; fsharp
(use-package fsharp-mode
  :mode "\\.fs[iylx]?\\'"
  :hook (lsp-deferred highlight-indentation-mode))

(setq-default fsharp-indent-offset 4)

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

;; erlang
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

(use-package erlang
  :init
  (defvar erlang-root-dir "/usr/local/lib/erlang")
  (add-to-list 'exec-path (expand-file-name "bin" erlang-root-dir))
  (add-to-list 'load-path (expand-file-name "lib/tools-4.1.3/emacs" erlang-root-dir))

  :mode
  ("\\.erl\\'" . erlang-mode)
  ("\\.hrl\\'" . erlang-mode)

  :config
  (add-hook 'erlang-mode-hook
	    (lambda ()
	      (setq inferior-erlang-machine-options '("-sname" "emacs"))
	      (setq mode-name "erl"
		    erlang-compile-extra-opts '((i . "../include"))
		    )))

  (require 'erlang-start))

(use-package edts)

;; snippets
(use-package yasnippet
  :hook ((prog-mode . yas-minor-mode))
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :after yasnippet)

;; python
(use-package pyvenv
  :config
  (pyvenv-mode 1))

;; lsp-mode
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook  ((fsharp-mode . lsp-deferred)
	  (python-mode . lsp-deferred)
	  (ruby-mode . lsp-deferred)
	  (erlang-mode . lsp-deferred))

  :config
  (setq lsp-prefer-flymake nil)
  (setq lsp-enable-symbol-highlighting t)
  (setq lsp-signature-auto-activate t)
  (setq lsp-signature-render-documentation t)
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("elp" "server"))
		    :major-modes '(erlang-mode)
		    :priority 0
		    :server-id 'erlang-language-platform))

  :bind (:map lsp-mode-map
	      ("C-c l d" . lsp-describe-thing-at-point)
	      ("C-c l r" . lsp-rename)
	      ("C-c l a" . lsp-execute-code-action)
	      ("C-c l f" . lsp-format-buffer)))

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-position 'at-point)
  (setq lsp-ui-doc-delay 0.5)
  (setq lsp-ui-sideline-enable t)
  (setq lsp-ui-sideline-show-hover t))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(yaml-mode dockerfile-mode docker neotree projectile counsel ivy catppuccin-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
