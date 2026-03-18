;;; mod-core.el --- Core settings and theme

;;; Commentary:
;; Basic Emacs settings, appearance, and terminal optimizations

;;; Code:

;; ============================================================================
;; Basic Settings
;; ============================================================================

;; Disable startup screen
(setq inhibit-startup-screen t)

;; Show line numbers
(global-display-line-numbers-mode 1)

;; Show matching parentheses
(show-paren-mode 1)

;; Column number in mode line
(column-number-mode 1)

;; Enable recent files
(recentf-mode 1)
(setq recentf-max-saved-items 50)

;; Better scrolling
(setq scroll-conservatively 100)

;; Remember cursor position in files
(save-place-mode 1)

;; Terminal-friendly settings
(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; UTF-8 everywhere
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; Don't create backup files
(setq make-backup-files nil)
(setq auto-save-default nil)

;; y/n instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; Highlight current line
(global-hl-line-mode 1)

;; ============================================================================
;; Theme
;; ============================================================================

(use-package catppuccin-theme
  :config
  (load-theme 'catppuccin :no-confirm)
  (setq catppuccin-flavor 'mocha)) ;; Options: latte, frappe, macchiato, mocha

;; ============================================================================
;; Which-key - Shows available keybindings
;; ============================================================================

(use-package which-key
  :config
  (which-key-mode))

;; ============================================================================
;; Window Navigation
;; ============================================================================

(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)

(provide 'mod-core)
;;; mod-core.el ends here
