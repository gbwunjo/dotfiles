;;; mod-web.el --- HTML, CSS, Tailwind configuration

;;; Commentary:
;; HTML, CSS, SCSS, and Tailwind CSS support
;; Requires: npm install -g vscode-langservers-extracted (for CSS LSP)
;;           npm install -g @tailwindcss/language-server

;;; Code:

;; ============================================================================
;; Web Mode - HTML and Templates
;; ============================================================================

(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.erb\\'" . web-mode)
         ("\\.ejs\\'" . web-mode)
         ("\\.vue\\'" . web-mode)
         ("\\.hbs\\'" . web-mode)
         ("\\.handlebars\\'" . web-mode))
  :hook ((web-mode . lsp-deferred))
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-enable-current-column-highlight t))

;; ============================================================================
;; CSS Mode
;; ============================================================================

(use-package css-mode
  :mode "\\.css\\'"
  :hook ((css-mode . lsp-deferred))
  :config
  (setq css-indent-offset 2))

;; ============================================================================
;; SCSS/SASS Mode
;; ============================================================================

(use-package scss-mode
  :mode "\\.scss\\'"
  :hook ((scss-mode . lsp-deferred))
  :config
  (setq scss-compile-at-save nil))

;; ============================================================================
;; Tailwind CSS
;; ============================================================================

;; LSP support for Tailwind (class name completion)
;; Make sure Tailwind LSP is installed: npm install -g @tailwindcss/language-server
(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration '(web-mode . "html"))
  
  ;; Register Tailwind CSS LSP
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection '("tailwindcss-language-server" "--stdio"))
    :activation-fn (lsp-activate-on "html" "css" "scss" "javascript" "javascriptreact" "typescript" "typescriptreact")
    :server-id 'tailwindcss
    :add-on? t  ;; Run alongside other LSP servers
    :priority -1)))

;; Tailwind CSS class sorting (optional)
(defun my/sort-tailwind-classes ()
  "Sort Tailwind CSS classes in the current line or region."
  (interactive)
  (let* ((bounds (if (use-region-p)
                     (cons (region-beginning) (region-end))
                   (bounds-of-thing-at-point 'line)))
         (text (buffer-substring-no-properties (car bounds) (cdr bounds)))
         ;; Simple class sorting - alphabetical within the class attribute
         (sorted (replace-regexp-in-string
                  "class=\"\\([^\"]+\\)\""
                  (lambda (match)
                    (let* ((classes (match-string 1 match))
                           (class-list (split-string classes))
                           (sorted-classes (sort class-list #'string<)))
                      (format "class=\"%s\"" (string-join sorted-classes " "))))
                  text)))
    (delete-region (car bounds) (cdr bounds))
    (insert sorted)))

;; ============================================================================
;; Emmet - HTML/CSS abbreviations
;; ============================================================================

(use-package emmet-mode
  :hook ((web-mode . emmet-mode)
         (css-mode . emmet-mode)
         (scss-mode . emmet-mode)
         (rjsx-mode . emmet-mode)
         (typescript-mode . (lambda ()
                              (when (string-match-p "\\.tsx\\'" (buffer-file-name))
                                (emmet-mode)))))
  :config
  (setq emmet-expand-jsx-className? t)  ;; Use className for JSX
  (setq emmet-self-closing-tag-style " /"))

;; ============================================================================
;; Rainbow Mode - Color highlighting in CSS
;; ============================================================================

(use-package rainbow-mode
  :hook ((css-mode . rainbow-mode)
         (scss-mode . rainbow-mode)
         (web-mode . rainbow-mode)))

;; ============================================================================
;; CSS Color Preview
;; ============================================================================

;; Show color swatches inline
(add-hook 'css-mode-hook
          (lambda ()
            (setq-local show-paren-style 'parenthesis)))

;; ============================================================================
;; Auto-rename paired HTML tags
;; ============================================================================

(use-package auto-rename-tag
  :hook ((web-mode . auto-rename-tag-mode)
         (rjsx-mode . auto-rename-tag-mode)))

;; ============================================================================
;; Useful Keybindings for Web Development
;; ============================================================================

;; Quick toggle between component and its CSS/test file
(defun my/toggle-component-file ()
  "Toggle between a component file and its related files (CSS, test, etc.)."
  (interactive)
  (let* ((current-file (buffer-file-name))
         (base-name (file-name-sans-extension current-file))
         (extension (file-name-extension current-file))
         (dir (file-name-directory current-file)))
    (cond
     ;; From .tsx/.jsx to .css/.scss/.module.css
     ((member extension '("tsx" "jsx"))
      (let ((css-file (concat base-name ".css"))
            (scss-file (concat base-name ".scss"))
            (module-css (concat base-name ".module.css"))
            (module-scss (concat base-name ".module.scss")))
        (cond
         ((file-exists-p module-scss) (find-file module-scss))
         ((file-exists-p module-css) (find-file module-css))
         ((file-exists-p scss-file) (find-file scss-file))
         ((file-exists-p css-file) (find-file css-file))
         (t (message "No related CSS file found")))))
     ;; From CSS back to component
     ((member extension '("css" "scss"))
      (let* ((clean-base (replace-regexp-in-string "\\.module\\'" "" base-name))
             (tsx-file (concat clean-base ".tsx"))
             (jsx-file (concat clean-base ".jsx")))
        (cond
         ((file-exists-p tsx-file) (find-file tsx-file))
         ((file-exists-p jsx-file) (find-file jsx-file))
         (t (message "No related component file found"))))))))

(global-set-key (kbd "C-c w t") 'my/toggle-component-file)

(provide 'mod-web)
;;; mod-web.el ends here
