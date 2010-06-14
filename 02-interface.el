;; disable some ui components
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode -1)

;; stop cursor from blinking
(blink-cursor-mode 0)

;; no welcome message
(setq inhibit-startup-message t)

;; no echo area help on startup
(defun display-startup-echo-area-message ()
  (message ""))

;; display position in modeline
(setq line-number-mode t)
(setq column-number-mode t)

;; syntax highlighting everywhere
(global-font-lock-mode t)

;; show matching parnens (mixed style)
(show-paren-mode t)
(setq show-paren-delay 0.0)
(setq show-paren-style 'parenthesis)

;; hilight selection
(transient-mark-mode t)

;; make "yes or no" prompts show "y or n" instead
(fset 'yes-or-no-p 'y-or-n-p)

;; custom colors
(set-background-color "white")
(set-foreground-color "black")

;; switching
(iswitchb-mode 1)
(icomplete-mode 1)

;; no backup files
(setq make-backup-files nil)
(setq auto-save-default nil)

;; case insensitive completion
(setq completion-ignore-case t)

;; always indent new lines by default
(global-set-key "\r" 'newline-and-indent)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(setq require-final-newline 'visit-save)

;; mouse stuff
(setq
 mouse-1-click-in-non-selected-windows nil
 mouse-yank-at-point t)
(mouse-avoidance-mode 'exile)

(set-default
 'show-trailing-whitespace t)

(add-hook 'help-mode-hook
          (lambda ()
            (setq show-trailing-whitespace nil)))

(setq fill-column 80)

;; FIXME: doesn't work anymore
(highlight-beyond-fill-column)
