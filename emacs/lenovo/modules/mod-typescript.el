;;; mod-typescript.el --- TypeScript/JavaScript/React configuration

;;; Commentary:
;; Full TypeScript, JavaScript, JSX, TSX support with LSP
;; Requires: npm install -g typescript typescript-language-server

;;; Code:

;; ============================================================================
;; TypeScript Mode
;; ============================================================================

(use-package typescript-mode
  :mode ("\\.ts\\'" "\\.tsx\\'")
  :hook ((typescript-mode . lsp-deferred))
  :config
  (setq typescript-indent-level 2))

;; Better TSX support (TypeScript + JSX)
(use-package tsx-ts-mode
  :ensure nil  ;; Built into Emacs 29+
  :mode "\\.tsx\\'"
  :hook ((tsx-ts-mode . lsp-deferred)))

;; ============================================================================
;; JavaScript Mode
;; ============================================================================

(use-package js2-mode
  :mode "\\.js\\'"
  :hook ((js2-mode . lsp-deferred))
  :config
  (setq js2-basic-offset 2)
  (setq js-indent-level 2)
  (setq js2-strict-missing-semi-warning nil))

;; JSX support
(use-package rjsx-mode
  :mode "\\.jsx\\'"
  :hook ((rjsx-mode . lsp-deferred))
  :config
  (setq js2-basic-offset 2))

;; ============================================================================
;; JSON Mode
;; ============================================================================

(use-package json-mode
  :mode "\\.json\\'"
  :config
  (setq json-reformat:indent-width 2))

;; ============================================================================
;; Prettier - Code Formatting
;; ============================================================================

(use-package prettier-js
  :hook ((typescript-mode . prettier-js-mode)
         (js2-mode . prettier-js-mode)
         (rjsx-mode . prettier-js-mode)
         (json-mode . prettier-js-mode)
         (css-mode . prettier-js-mode)
         (web-mode . prettier-js-mode))
  :config
  (setq prettier-js-args '("--trailing-comma" "es5"
                           "--single-quote" "true"
                           "--print-width" "100")))

;; ============================================================================
;; ESLint Integration
;; ============================================================================

;; Use eslint from local node_modules
(defun my/use-local-eslint ()
  "Use local eslint from node_modules if available."
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/.bin/eslint" root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local lsp-eslint-server-command `("node" ,eslint "--stdio")))))

(add-hook 'typescript-mode-hook #'my/use-local-eslint)
(add-hook 'js2-mode-hook #'my/use-local-eslint)
(add-hook 'rjsx-mode-hook #'my/use-local-eslint)

;; ============================================================================
;; npm Integration
;; ============================================================================

(use-package npm-mode
  :hook ((typescript-mode js2-mode rjsx-mode) . npm-mode)
  :bind (:map npm-mode-keymap
              ("C-c n r" . npm-mode-npm-run)
              ("C-c n i" . npm-mode-npm-install)
              ("C-c n t" . npm-mode-npm-test)
              ("C-c n n" . npm-mode-npm-init)))

;; ============================================================================
;; Node.js REPL
;; ============================================================================

(use-package nodejs-repl
  :bind (:map js2-mode-map
              ("C-c C-e" . nodejs-repl-send-last-expression)
              ("C-c C-r" . nodejs-repl-send-region)
              ("C-c C-b" . nodejs-repl-send-buffer)
              ("C-c C-z" . nodejs-repl-switch-to-repl)))

;; ============================================================================
;; Add node_modules to exec path (for local tools)
;; ============================================================================

(use-package add-node-modules-path
  :hook ((typescript-mode js2-mode rjsx-mode) . add-node-modules-path))

;; ============================================================================
;; Tree-sitter for better syntax highlighting (Emacs 29+)
;; ============================================================================

(when (>= emacs-major-version 29)
  (setq treesit-language-source-alist
        '((typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
          (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
          (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")))
  
  ;; Remap modes to tree-sitter versions if available
  (setq major-mode-remap-alist
        '((typescript-mode . typescript-ts-mode)
          (js2-mode . js-ts-mode)
          (css-mode . css-ts-mode))))

(provide 'mod-typescript)
;;; mod-typescript.el ends here
