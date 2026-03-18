;;; mod-completion.el --- Completion frameworks

;;; Commentary:
;; Ivy, Counsel, Swiper, Company for fuzzy finding and auto-completion

;;; Code:

;; ============================================================================
;; Ivy/Counsel/Swiper - Fuzzy Finding & Completion
;; ============================================================================

(use-package ivy
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-height 15)
  (setq ivy-wrap t)
  (setq ivy-extra-directories nil))

(use-package counsel
  :after ivy
  :config
  (counsel-mode 1))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)))

;; Rich display for Ivy results
(use-package ivy-rich
  :after ivy
  :config
  (ivy-rich-mode 1)
  (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line))

;; Better fuzzy sorting (remembers your choices)
(use-package prescient
  :config
  (prescient-persist-mode 1))

(use-package ivy-prescient
  :after (ivy prescient)
  :config
  (ivy-prescient-mode 1))

;; ============================================================================
;; Company - Auto-completion
;; ============================================================================

(use-package company
  :config
  (global-company-mode 1)
  (setq company-idle-delay 0.2)
  (setq company-minimum-prefix-length 1)
  (setq company-tooltip-align-annotations t))

;; Bind recent files
(global-set-key (kbd "C-c r") 'counsel-recentf)

(provide 'mod-completion)
;;; mod-completion.el ends here
