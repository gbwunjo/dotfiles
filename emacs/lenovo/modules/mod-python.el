;;; mod-python.el --- Python development configuration

;;; Commentary:
;; Python language support with Pyright LSP and type checking
;; Requires: npm install -g pyright
;;           pip install black isort

;;; Code:

;; ============================================================================
;; Python Mode
;; ============================================================================

(use-package python
  :mode ("\\.py\\'" . python-mode)
  :hook ((python-mode . lsp-deferred)
         (python-mode . (lambda ()
                          (setq tab-width 2)
                          (setq python-indent-offset 2)
                          (setq indent-tabs-mode nil))))
  :config
  (setq python-shell-interpreter "python3"))

;; ============================================================================
;; Pyright LSP - Type Checking
;; ============================================================================

(use-package lsp-pyright
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp-deferred)))
  :config
  (setq lsp-pyright-typechecking-mode "standard")
  (setq lsp-pyright-auto-import-completions t)
  (setq lsp-pyright-auto-search-paths t)
  (setq lsp-pyright-use-library-code-for-types t))

;; ============================================================================
;; Virtual Environments
;; ============================================================================

(use-package pyvenv
  :hook (python-mode . pyvenv-mode)
  :config
  (setq pyvenv-mode-line-indicator '(pyvenv-virtual-env-name ("[venv:" pyvenv-virtual-env-name "]")))
  (add-hook 'python-mode-hook
            (lambda ()
              (let ((venv-path (locate-dominating-file default-directory ".venv")))
                (when venv-path
                  (pyvenv-activate (concat venv-path ".venv"))))
              (let ((venv-path (locate-dominating-file default-directory "venv")))
                (when venv-path
                  (pyvenv-activate (concat venv-path "venv")))))))

;; ============================================================================
;; Formatting
;; ============================================================================

(use-package python-black
  :after python
  :hook (python-mode . python-black-on-save-mode-enable-dwim))

(use-package python-isort
  :after python
  :hook (python-mode . python-isort-on-save-mode))

;; ============================================================================
;; Docstrings
;; ============================================================================

(use-package python-docstring
  :hook (python-mode . python-docstring-mode))

;; ============================================================================
;; Testing
;; ============================================================================

(use-package python-pytest
  :after python
  :bind (:map python-mode-map
              ("C-c t t" . python-pytest-dispatch)
              ("C-c t f" . python-pytest-file)
              ("C-c t m" . python-pytest-function)
              ("C-c t r" . python-pytest-repeat)))

(provide 'mod-python)
;;; mod-python.el ends here
