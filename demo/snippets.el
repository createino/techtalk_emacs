;--------------------------------;
;;; let me google that for you ;;;
;--------------------------------;

(defun lmgtfy ()
  "Googles a query or region if any."
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (if mark-active
	(buffer-substring (region-beginning) (region-end))
      (read-string "Google: ")))))


;-------------------------;
;;; flask server runner ;;;
;-------------------------;

(defun add-to-PATH (dir)
  "Add the specified path element to the Emacs PATH
  https://dreid.org/2010/02/mimicing-source-virtualenvbinactivate.html/"
  ;(interactive "DEnter directory to be added to PATH: ")
  (if (file-directory-p dir)
      (setenv "PATH"
              (concat (expand-file-name dir)
                      path-separator
                      (getenv "PATH")))))
 
(defun virtualenv-activate (dir)
  ;(interactive "DEnter directory to be run: ")
  (setenv "VIRTUAL_ENV" dir)
  (add-to-PATH (concat dir "/bin"))
  (add-to-list 'exec-path (concat dir "/bin"))
  (let ((default-directory dir))
    (shell-command (concat dir "bin/python " dir "run.py &"))))

(defun flask-run (dir)
  (interactive "DEnter the directory to be run: ")
  (add-to-PATH dir)
  (virtualenv-activate dir))


;---------------------------;
;;; custom editing example ;;;
;---------------------------;

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


;------------------------------------------------;
;;; xahlee turn block into html list           ;;;
;;; https://github.com/xahlee/xah-html-mode.el ;;;
;------------------------------------------------;

(defun get-selection-or-unit (unit)
  "Return the string and boundary of text selection or UNIT under cursor.

If `use-region-p' is true, then the region is the unit.  Else,
it depends on the UNIT. See `unit-at-cursor' for detail about
UNIT.

Returns a vector [text a b], where text is the string and a and b
are its boundary.

Example usage:
 (setq bds (get-selection-or-unit 'line))
 (setq inputstr (elt bds 0) p1 (elt bds 1) p2 (elt bds 2)  )"
  (interactive)

  (let ((p1 (region-beginning)) (p2 (region-end)))
    (if (use-region-p)
        (vector (buffer-substring-no-properties p1 p2) p1 p2 )
      (unit-at-cursor unit) ) ) )

(defun xhm-lines-to-html-list ()
  (interactive)
  (let (bds p1 p2 ξinput-str resultStr)
    (setq bds (get-selection-or-unit 'block))
    (setq ξinput-str (elt bds 0) p1 (elt bds 1) p2 (elt bds 2))
    (save-excursion
      (setq resultStr
            (with-temp-buffer
              (insert ξinput-str)
              (delete-trailing-whitespace)
              (goto-char 1)
              (while
                  (search-forward-regexp  "\.html$" nil t)
                (backward-char 1)
                (xah-all-linkify))

              (goto-char 1)
              (while
                  (not (equal (line-end-position) (point-max)))
                (beginning-of-line) (insert "<li>")
                (end-of-line) (insert "</li>")
                (forward-line 1 ))

              (beginning-of-line) (insert "<li>")
              (end-of-line) (insert "</li>")

              (goto-char 1)
              (insert "<ul>\n")
              (goto-char (point-max))
              (insert "\n</ul>")

              (buffer-string))))
    (delete-region p1 p2)
    (insert resultStr)))
