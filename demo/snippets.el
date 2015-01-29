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
