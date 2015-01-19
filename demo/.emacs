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

;; Disable menubar
(menu-bar-mode -1)

;; Disable toolbar
(tool-bar-mode -1)

;; Disable scrollbar
(scroll-bar-mode -1)

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

;; aliasing yes or no to y or n only
(defalias 'yes-or-no-p 'y-or-n-p)

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

;; ace-jump-mode
(require 'cl) ;; patch to fix ace-jump-mode
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

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

;; my package
; multiple-cursor (mc)
; expand-region
; magit
; slime
; ace jump mode

(fset 'demo
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([21 57 14 67108896 5 23 21 57 16 5 32 25 14 1] 0 "%d")) arg)))

