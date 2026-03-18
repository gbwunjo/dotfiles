;;; mod-go.el --- Go development configuration

;;; Commentary:
;; Go language support with gopls LSP
;; Requires: go install golang.org/x/tools/gopls@latest
;;           go install golang.org/x/tools/cmd/goimports@latest

;;; Code:

(use-package go-mode
  :mode "\\.go\\'"
  :hook ((go-mode . lsp-deferred)
         (before-save . (lambda ()
                          (when (eq major-mode 'go-mode)
                            (lsp-format-buffer)
                            (lsp-organize-imports)))))
  :config
  (setq gofmt-command "goimports")
  ;; Display tabs as 4 spaces (visual only, files still use real tabs)
  (add-hook 'go-mode-hook (lambda ()
                            (setq tab-width 2))))

(provide 'mod-go)
;;; mod-go.el ends here
