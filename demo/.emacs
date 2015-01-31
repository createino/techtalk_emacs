(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(custom-enabled-themes (quote (manoj-dark))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "unknown" :slant normal :weight normal :height 98 :width normal)))))

;--------------------;
;;; User Interface ;;;
;--------------------;

;; No splash screen ...
(setq inhibit-startup-message t)

;; If using gui version
(when window-system
  (menu-bar-mode -1) ;; Disable menubar
  (tool-bar-mode -1) ;; Disable toolbar
  (scroll-bar-mode -1) ;; Disable scrollbar
  (tooltip-mode -1)) ;; Disable tooltip

;; always use spaces, not tabs, when indenting
(setq indent-tabs-mode nil)

;; require final newlines in files when they are saved
(setq require-final-newline t)

;----------------;
;;; Extra Repo ;;;
;----------------;

;; load marmalade repo
(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))

;---------------------;
;;; Startup options ;;;
;---------------------;

;; Auto-enabled ido-mode
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)  ; fuzzy matching is a must have

;; change list-buffers to ibuffer
(defalias 'list-buffers 'ibuffer)

;-----------------------------------------;
;;; make frequently used commands short ;;;
;-----------------------------------------;

;; aliasing ace-jump-mode
(defalias 'ajm 'ace-jump-mode)
(defalias 'ajcm 'ace-jump-char-mode)

(define-key global-map (kbd "C-c a") 'ace-jump-char-mode)

;; aliasing yes or no to y or n only
(defalias 'yes-or-no-p 'y-or-n-p)

;; set backup directory
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;-------------------------;
;;; Custom Key Bindings ;;;
;-------------------------;

;; change Alt-x to F8
(global-set-key (kbd "<f8>") 'execute-extended-command)

;; font in/decrease
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; commenting region

(global-set-key (kbd "C-;") 'comment-or-uncomment-region)

;; hippie expand
(global-set-key (kbd "M-/") 'hippie-expand)

;; magit-status
(global-set-key (kbd "C-x g") 'magit-status)

;; make cursor movement keys under right hand's home-row
(global-set-key (kbd "M-i") 'previous-line)
(global-set-key (kbd "M-k") 'next-line)
(global-set-key (kbd "M-j") 'backward-char)
(global-set-key (kbd "M-l") 'forward-char)

;; expand region setup
; (require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;------------------------------;
;;; org-html-publisher setup ;;;
;------------------------------;

(require 'org-publish)
(setq org-publish-project-alist
      '(
	("org-notes"
	 :base-directory "~/org/"
	 :base-extension "org"
	 :publishing-directory "~/org/public_html/"
	 :recursive t
	 :publishing-function org-publish-org-to-html
	 :headline-levels 2             ; Just the default for this project.
	 :auto-preamble t
	 )

	("org-static"
	 :base-directory "~/org/"
	 :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
	 :publishing-directory "~/org/public_html/"
	 :recursive t
	 :publishing-function org-publish-attachment
	 )

	("pdf"
	 :base-directory "~/org/"
	 :base-extension "org"
	 :publishing-directory "~/org/exports"
	 :publishing-function org-publish-org-to-pdf)

	("all" :components ("org-notes" "org-static pdf"))

	)
      )

;; create custom latex class
(require 'org-latex)
(add-to-list 'org-export-latex-classes
      '("tesis"
         "\\documentclass[hidelinks, a4paper, oneside]{article}
         [NO-DEFAULT-PACKAGES]
         [PACKAGES]
         [EXTRA]"
         ("\\section{%s}" . "\\section*{%s}")
         ("\\subsection{%s}" . "\\subsection*{%s}")
         ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
         ("\\paragraph{%s}" . "\\paragraph*{%s}")
         ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; set ipython as the interpreter
(setq
 python-shell-interpreter "ipython"
 python-shell-interpreter-args ""
 python-shell-prompt-regexp "In \\[[0-9]+\\]: "
 python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
 python-shell-completion-setup-code
   "from IPython.core.completerlib import module_completion"
 python-shell-completion-module-string-code
   "';'.join(module_completion('''%s'''))\n"
 python-shell-completion-string-code
   "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

;; try to automagically figure out indentation
(setq py-smart-indentation t)

;---------------;
;;; yasnippet ;;;
;---------------;
(add-to-list 'load-path "~/.emacs.d/elpa/yasnippet-0.8.0/")
(require 'yasnippet)
(yas-global-mode 1)

;-------------------;
;;; Auto-complete ;;;
;-------------------;

(add-to-list 'load-path "~/.emacs.d/elpa/popup-0.5")
(add-to-list 'load-path "~/.emacs.d/elpa/auto-complete-1.4")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elpa/auto-complete-1.4/dict")
(ac-config-default)

;-----------------;
;; ace-jump-mode ;;
;-----------------;
;; patch to fix ace-jump-mode
(require 'cl)
;(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;; When org-mode starts it (org-mode-map) overrides the ace-jump-mode.
(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key (kbd "\C-c SPC") 'ace-jump-mode)))

;----------------------;
;;; for demo purpose ;;;
;----------------------;

;; save keyboard macro
(defun my/save-macro (name)
  "save a macro. Take a name as argument
     and save the last defined macro under 
     this name at the end of your .emacs"
  (interactive "SName of the macro: ")  ; ask for the name of the macro    
  (kmacro-name-last-macro name)         ; use this name for the macro    
  (find-file user-init-file)            ; open ~/.emacs or other user init file 
  (goto-char (point-max))               ; go to the end of the .emacs
  (newline)                             ; insert a newline
  (insert-kbd-macro name)               ; copy the macro 
  (newline)                             ; insert a newline
  (switch-to-buffer nil))               ; return to the initial buffer

;; jumpstarting emacs
(defun my/demo-jump-start ()
  (interactive)
    (find-file "~/git/techtalk_emacs/demo/emacs_docs.tex")
    (split-window-horizontally)
    (other-window 1)
    (find-file "~/git/techtalk_emacs/demo/emacs_docs.pdf")
    (other-window 1)
    (split-window-vertically)
    (other-window 1)
    (shell)
    ;(goto-char (point-max))
    ;(recenter-top-bottom 0)
    (shrink-window 20)
    (enlarge-window-horizontally 5)
)

;; quickly open ipython demo
(defun my/ipython ()
  (interactive)
  (split-window-vertically)
  (other-window 1)
  (python-shell-switch-to-shell)
  (switch-to-buffer "speech.org")
  (other-window 1)
  ;(switch-to-buffer "~/git/techtalk_emacs/demo/demo.py")
  (find-file "~/git/techtalk_emacs/demo/demo.py")
  (other-window 1)
  (switch-to-buffer "*Python[/home/banteng/git/techtalk_emacs/demo/demo.py]*")
  ;(switch-to-buffer "*Python*")
)

;; quickly create and name shell
(defun create-shell ()
    "creates a shell with a given name"
    (interactive);; "Prompt\n shell name:")
    (let ((shell-name (read-string "shell name: " nil)))
    (shell (concat "*" shell-name "*"))))

(global-set-key (kbd "M-S") 'create-shell)


;------------------------;
;;; key-chord bindings ;;;
;------------------------;

(package-initialize)
(key-chord-mode 1)
;(key-chord-define-global "jj" 'save-buffer)
(key-chord-define-global "jk" 'switch-to-buffer)
;(key-chord-define-global ";;" 'ace-jump-char-mode)
;(key-chord-define-global "io" 'other-window)
;(key-chord-define-global "dd" 'dired-at-point)
;(key-chord-define-global "gg" 'magit-status)


(fset 'my/demo-macro
   (lambda (&optional arg) "Keyboard
   macro." (interactive "p") (kmacro-exec-ring-item (quote ([1
   67108921 14 67108896 5 23 67108921 16 5 32 25 14] 0 "%d"))
   arg)))

;------------------;
;;; speech start ;;;
;------------------;

(defun my/speech-start ()
  (interactive)
  (set-face-attribute 'default nil :height 140)
  (find-file "~/git/techtalk_emacs/speech.org")
  (auto-fill-mode 1) ;; auto multi line when 70 chars hitted
  (org-display-inline-images 1) ;; display image
  ;(set-frame-parameter nil 'fullscreen 'fullboth) ;; set full screen
  (set-frame-parameter nil 'fullscreen 'maximized) ;; set maximized
  (flymake-mode 1)) ;; spelling checker

(defun my/work ()
  (interactive)
  (find-file "~/Dropbox/agenda/coret.org")  ;; open todo.org agenda
  (set-frame-parameter nil 'fullscreen 'fullboth))

;; F11 key to toggle full screen mode
(defun toggle-fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen 
		       (if (frame-parameter nil 'fullscreen)
			   nil
			 'fullboth)))

(global-set-key [f11] 'toggle-fullscreen)

;; switch to default font interface
(defun my/default-font ()
  (interactive)
  (set-face-attribute 'default nil :height 100))

;; switch to bigger font
(defun my/bigger-font ()
  (interactive)
  (set-face-attribute 'default nil :height 200))

;; switch to custom font size
(defun my/set-font (n)
  (interactive "P")
  (set-face-attribute 'default nil :height n))


;----------------;
;;; my package ;;;
;----------------;

;; 0. multiple-cursor (mc)
;; 1. expand-region
;; 2. magit
;; 3. slime
;; 4. ace jump mode
;; 5. yasnippet
;; 6. iy-go-to-char.el
;; 7. key-chord.el
;; 8. evil-mode
;; 9. undo-tree
;; 10. markdown-mode
;; 11. visual-regexp
;; 12. visual-regexp-steroids
;; 13. helm


;---------------;
;;; helm mode ;;;
;---------------;

(helm-mode t)

;-----------------------;
;;; xml cleaner macro ;;;
;-----------------------;

(fset 'xml_cleaner
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([1 67108896 19 47 19 19 19 19 13 23 19 46 2 67108896 19 60 47 117 114 108 62 13 23 1 67108896 5 134217848 114 101 112 108 97 9 115 116 114 9 13 13 14 1] 0 "%d")) arg)))


;-------------------------------;
;;; activate windmove package ;;;
;-------------------------------;

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)


;-------------------------;
;;; flask server runner ;;;
;-------------------------;

(defun add-to-PATH (dir)
  """Add the specified path element to the Emacs PATH
  https://dreid.org/2010/02/mimicing-source-virtualenvbinactivate.html/"""
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
    (shell-command (concat dir "bin/python " dir "run.py &")
		   (get-buffer-create "*flask-out*"))))

(defun flask-run (dir)
  (interactive "DEnter the directory to be run: ")
  (add-to-PATH dir)
  (virtualenv-activate dir))

;-------------------------;
;;; toggle window split ;;;
;-------------------------;

(defun toggle-window-split ()
  "quickly switch from horizontal to vertical, vice versa"
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
	     (next-win-buffer (window-buffer (next-window)))
	     (this-win-edges (window-edges (selected-window)))
	     (next-win-edges (window-edges (next-window)))
	     (this-win-2nd (not (and (<= (car this-win-edges)
					 (car next-win-edges))
				     (<= (cadr this-win-edges)
					 (cadr next-win-edges)))))
	     (splitter
	      (if (= (car this-win-edges)
		     (car (window-edges (next-window))))
		  'split-window-horizontally
		'split-window-vertically)))
	(delete-other-windows)
	(let ((first-win (selected-window)))
	  (funcall splitter)
	  (if this-win-2nd (other-window 1))
	  (set-window-buffer (selected-window) this-win-buffer)
	  (set-window-buffer (next-window) next-win-buffer)
	  (select-window first-win)
	  (if this-win-2nd (other-window 1))))))

(define-key ctl-x-4-map "t" 'toggle-window-split)


;--------------------------------;
;;; let me google that for you ;;;
;--------------------------------;

(defun my/lmgtfy ()
  "Googles a query or region if any."
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (if mark-active
	(buffer-substring (region-beginning) (region-end))
      (read-string "Google: ")))))


;--------------------------------------------------------;
;;; quick newline up and above                         ;;;
;--------------------------------------------------------;
; http://whattheemacsd.com/editing-defuns.el-01.html

(defun open-line-below ()
  (interactive)
  (end-of-line)
  (newline)
  (indent-for-tab-command))

(defun open-line-above ()
  (interactive)
  (beginning-of-line)
  (newline)
  (forward-line -1)
  (indent-for-tab-command))

(global-set-key (kbd "<C-return>") 'open-line-below)
(global-set-key (kbd "<C-S-return>") 'open-line-above)
