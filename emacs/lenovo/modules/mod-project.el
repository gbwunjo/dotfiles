;;; mod-project.el --- Project management and search

;;; Commentary:
;; Projectile, NeoTree, ripgrep, and project-wide search

;;; Code:

;; ============================================================================
;; Project Management
;; ============================================================================

(use-package projectile
  :config
  (projectile-mode +1)
  :bind-keymap
  ("C-c p" . projectile-command-map))

;; Better Ivy/Counsel integration with Projectile
(use-package counsel-projectile
  :after (counsel projectile)
  :config
  (counsel-projectile-mode 1))

;; ============================================================================
;; Tree File Browser
;; ============================================================================

(use-package neotree
  :config
  (setq neo-smart-open t)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (setq neo-window-width 30)
  (setq neo-autorefresh t)
  (setq projectile-switch-project-action 'neotree-projectile-action)
  :bind (("C-c t" . neotree-toggle)
         ("C-c C-t" . neotree-projectile-action)))

;; ============================================================================
;; Search - Ripgrep
;; ============================================================================

(use-package rg
  :config
  (rg-enable-default-bindings))

;; Edit search results directly
(use-package wgrep
  :config
  (setq wgrep-auto-save-buffer t))

;; Configure counsel-rg
(setq counsel-grep-base-command
      "rg -i -M 120 --no-heading --line-number --color never '%s' %s")

;; ============================================================================
;; Project Search Keybindings
;; ============================================================================

;; Using C-c / as search prefix (C-c s may conflict with other modes)
(global-set-key (kbd "C-c / s") 'counsel-rg)
(global-set-key (kbd "C-c / f") 'counsel-projectile-find-file)
(global-set-key (kbd "C-c / d") 'counsel-projectile-find-dir)
(global-set-key (kbd "C-c / b") 'counsel-projectile-switch-to-buffer)
(global-set-key (kbd "C-c / p") 'counsel-projectile-switch-project)

;; Search for word at point
(defun counsel-rg-thing-at-point ()
  "Search for the word at point using counsel-rg."
  (interactive)
  (counsel-rg (thing-at-point 'symbol)))

(global-set-key (kbd "C-c / w") 'counsel-rg-thing-at-point)

(provide 'mod-project)
;;; mod-project.el ends here
