(require 'nnir)

(setq
 gnus-select-method '(nnimap "perldition"
                             (nnimap-address "imap.perldition.org")
                             ;; I'd use 143 and starttls, but gnus seems buggy
                             ;; in reconnecting with that
                             (nnimap-server-port 993)
                             (nnimap-stream ssl))

 nnir-search-engine 'imap

 ;;; display threads in the summary buffer in a way humans can understand. for
 ;;; example like this:
 ;;
 ;; O   14.07.2010 21:40  Nicholas Clark   Re: Directions of perl 5 development
 ;; O   15.07.2010 16:46  Steffen Schwigo  ├►
 ;; O   15.07.2010 17:09  Nicholas Clark   │├►
 ;; O   17.07.2010 15:15  Steffen Schwigo  ││├►
 ;; O   17.07.2010 18:30  Ævar Arnfjörð B  ││└►
 ;; O   17.07.2010 22:14  chromatic        ││ ├►
 ;; O   18.07.2010 07:34  Joshua ben Jore  ││ └►
 ;; O   15.07.2010 20:36  Jesse Vincent    │└►
 ;; O   15.07.2010 17:37  Dave Rolsky      └►

 gnus-summary-line-format "%U%R%z %(%&user-date;  %ub%-15,15f %* %B%s%)\n"
 gnus-user-date-format-alist '((t . "%d.%m.%Y %H:%M"))
 gnus-summary-thread-gathering-function 'gnus-gather-threads-by-references
 gnus-thread-sort-functions '(gnus-thread-sort-by-date)
 gnus-sum-thread-tree-root ""
 gnus-sum-thread-tree-false-root ""
 gnus-sum-thread-tree-indent " "
 gnus-sum-thread-tree-vertical "│"
 gnus-sum-thread-tree-leaf-with-other "├► "
 gnus-sum-thread-tree-single-leaf "└► "

 ;; "INBOX" instead of "nnimap+perldition:INBOX"
 gnus-group-line-format "%M%S%p%P%5y:%B%(%G%)%O\n"

 gnus-outgoing-message-group "nnimap+perldition:Sent"
 gnus-gcc-mark-as-read t

 gnus-use-correct-string-widths t
 gnus-interactive-exit nil)

(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)
(add-hook 'gnus-message-setup-hook 'mml-secure-message-sign-pgpmime)

;; FIXME: no worky
(eval-after-load "mm-decode"
  '(add-to-list 'mm-automatic-display "application/pgp$"))
(eval-after-load "mm-decode"
  (quote (setq mm-automatic-display (remove "application/pgp-signature"
                                            mm-automatic-display))))

;; mutt-like 'd', which will set the deleted flag on imap articles
(defun rafl-gnus-summary-delete-article-forward (&optional n)
  (interactive "p")
  ;; I should probably turn off gnus-novice-user globally at some point, but for
  ;; now this is safer.
  (let ((gnus-novice-user nil))
    (gnus-summary-delete-article n))
  (gnus-summary-next-subject (if (< n 0) -1 1) t))

(add-hook 'gnus-summary-mode-hook
          (lambda ()
            (local-set-key (kbd "d")
                           'rafl-gnus-summary-delete-article-forward)))

(defun rafl-gnus-group-suspend ()
  (interactive)
  (gnus-group-save-newsrc)
  (goto-char (point-min))
  (gnus-group-suspend))

(add-hook 'gnus-group-mode-hook
          (lambda ()
            (local-set-key (kbd "z")
                           'rafl-gnus-group-suspend)))

(add-hook 'message-mode-hook
          (lambda ()
            (local-set-key (kbd "M-;")
                           'bbdb-complete-name)))

;; inline html mails, with pictures
(setq
 mm-inline-text-html-renderer 'mm-inline-text-html-render-with-w3m
 w3m-display-inline-image t
 gnus-article-wash-function 'gnus-article-wash-html-with-w3m)

(global-set-key (kbd "C-c m") 'gnus)

;; mail with gnus instead of plain message mode to get all the hooks, Gcc
;; settings, and whatnot
(global-set-key (kbd "C-x m")
                (lambda ()
                  (interactive)
                  (gnus)
                  (gnus-group-mail)))
