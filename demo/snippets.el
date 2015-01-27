(defun lmgt ()
  "Googles a query or region if any."
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (if mark-active
	(buffer-substring (region-beginning) (region-end))
      (read-string "Google: ")))))


(defun my/insert-line-before (times)
  "Inserts a newline(s) above the line containing the cursor."
  (interactive "P")
  (save-excursion
    (move-beginning-of-line 1)
    (newline times)))

(global-set-key (kbd "C-S-o")
		'my/insert-line-before)

; line_1 abcdefghij
; line_2 klmnopqrst
