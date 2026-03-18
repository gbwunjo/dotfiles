;;; mod-editing.el --- Editing enhancements

;;; Commentary:
;; Multiple cursors, duplicate lines, and other editing utilities

;;; Code:

;; ============================================================================
;; Multiple Cursors
;; ============================================================================

(use-package multiple-cursors
  :bind (("C-c m c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c m a" . mc/mark-all-like-this)))

;; ============================================================================
;; Duplicate Line/Region
;; ============================================================================

(defun duplicate-line-or-region ()
  "Duplicate current line or region."
  (interactive)
  (if (region-active-p)
      (let ((text (buffer-substring (region-beginning) (region-end))))
        (goto-char (region-end))
        (insert text))
    (let ((line (buffer-substring (line-beginning-position) (line-end-position))))
      (end-of-line)
      (newline)
      (insert line))))

(global-set-key (kbd "C-c d") 'duplicate-line-or-region)

;; ============================================================================
;; Smart Parentheses
;; ============================================================================

(use-package smartparens
  :config
  (require 'smartparens-config)
  (smartparens-global-mode 1))

;; ============================================================================
;; Expand Region - Incrementally select larger regions
;; ============================================================================

(use-package expand-region
  :bind (("C-=" . er/expand-region)
         ("C--" . er/contract-region)))

;; ============================================================================
;; Move Text - Move lines/regions up and down
;; ============================================================================

(use-package move-text
  :bind (("M-<up>" . move-text-up)
         ("M-<down>" . move-text-down)))

(provide 'mod-editing)
;;; mod-editing.el ends here
