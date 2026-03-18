;;; mod-lsp.el --- Language Server Protocol configuration

;;; Commentary:
;; Shared LSP configuration for all languages

;;; Code:

;; ============================================================================
;; LSP Mode
;; ============================================================================

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-prefer-flymake nil)
  (setq lsp-enable-symbol-highlighting t)
  (setq lsp-signature-auto-activate t)
  (setq lsp-signature-render-documentation t)
  (setq lsp-eldoc-hook nil)  ;; Disable eldoc to avoid conflicts
  (setq lsp-modeline-diagnostics-enable t)
  (setq lsp-modeline-code-actions-enable t)
  (setq lsp-headerline-breadcrumb-enable t)
  (setq lsp-semantic-tokens-enable t)
  (setq lsp-enable-imenu t)
  (setq lsp-completion-provider :capf)
  :bind (:map lsp-mode-map
              ("C-c l d" . lsp-describe-thing-at-point)
              ("C-c l r" . lsp-rename)
              ("C-c l a" . lsp-execute-code-action)
              ("C-c l f" . lsp-format-buffer)
              ("C-c l g" . lsp-find-references)
              ("C-c l i" . lsp-goto-implementation)
              ("C-c l t" . lsp-goto-type-definition)))

;; ============================================================================
;; LSP UI
;; ============================================================================

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-position 'at-point)
  (setq lsp-ui-doc-delay 0.5)
  (setq lsp-ui-doc-show-with-cursor t)
  (setq lsp-ui-sideline-enable t)
  (setq lsp-ui-sideline-show-hover nil)
  (setq lsp-ui-sideline-show-diagnostics t)
  (setq lsp-ui-sideline-show-code-actions t)
  (setq lsp-ui-peek-enable t)
  :bind (:map lsp-ui-mode-map
              ("C-c l p d" . lsp-ui-peek-find-definitions)
              ("C-c l p r" . lsp-ui-peek-find-references)))

;; ============================================================================
;; LSP Ivy Integration
;; ============================================================================

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol
  :bind (:map lsp-mode-map
              ("C-c l s" . lsp-ivy-workspace-symbol)))

(provide 'mod-lsp)
;;; mod-lsp.el ends here
