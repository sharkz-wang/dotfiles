(require 'cl)				; common lisp goodies, loop

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil t)
  (url-retrieve
   "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
   (lambda (s)
     (end-of-buffer)
     (eval-print-last-sexp))))

;; now either el-get is `require'd already, or have been `load'ed by the
;; el-get installer.

;; set recipes
 (setq
 el-get-sources
 '(
   (:name el-get)

   (:name evil)
   (:name evil-matchit)
   (:name evil-surround)
   (:name evil-numbers)
   (:name evil-leader)
   (:name evil-nerd-commenter)

   (:name undo-tree)
   (:name ace-jump-mode)
   (:name smooth-scroll)

   (:name smex				; a better (ido like) M-x
	  :after (progn
		(setq smex-save-file "~/.emacs.d/.smex-items")
		(add-hook 'ido-setup-hook
		    (lambda ()
			(define-key ido-completion-map (kbd "C-h") 'delete-backward-char)
			
			(define-key ido-completion-map (kbd "C-n") 'ido-next-match)
			(define-key ido-completion-map (kbd "C-p") 'ido-prev-match)

			(define-key ido-completion-map (kbd "C-? f") 'smex-describe-function)
			(define-key ido-completion-map (kbd "C-? w") 'smex-where-is)))

			(global-set-key (kbd "M-x") 'smex)
			(global-set-key (kbd "M-X") 'smex-major-mode-commands)))

   (:name magit				; git meet emacs, and a binding
      :type git
	  :after (progn
		   (global-set-key (kbd "C-x C-z") 'magit-status)))

   (:name org-mode
      :type git
	  :after (progn
		   (global-set-key (kbd "C-c t") 'org-todo)))

   (:name yasnippet)
   (:name helm)
   (:name helm-gtags)

   (:name cedet)
   (:name function-args)

   (:name company-mode)
   ;; (:name helm-company)
   
   (:name projectile)
   (:name smartparens)

   (:name sr-speedbar)
   (:name dtrt-indent)

   (:name molokai-theme
      :type git
      :url "https://github.com/hbin/molokai-theme")

   ))

;; install new packages and init already installed packages
(el-get 'sync (loop for src in el-get-sources collect (el-get-source-name src)))

(setq inhibit-splash-screen t)		; no splash screen, thanks
(line-number-mode 1)			; have line numbers and
(column-number-mode 1)			; column numbers in the mode line

(tool-bar-mode -1)			; no tool bar with icons
(scroll-bar-mode -1)			; no scroll bars
(unless (string-match "apple-darwin" system-configuration)
;; on mac, there's always a menu bar drown, don't have it empty
(menu-bar-mode -1))

(global-hl-line-mode)			; highlight current line
(global-linum-mode 1)			; add line numbers on the left
(setq linum-format "%d ")

(global-set-key (kbd "RET") 'newline-and-indent)
(setq-default tab-width 8)
(global-set-key (kbd "C-h") 'delete-backward-char)

;; under mac, have Command as Meta and keep Option for localized input
(when (string-match "apple-darwin" system-configuration)
  (setq mac-allow-anti-aliasing t)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none))

;; Use the clipboard, pretty please, so that copy/paste "works"
(setq x-select-enable-clipboard t)

(setq windmove-wrap-around t)

;; whenever an external process changes a file underneath emacs, and there
;; was no unsaved changes in the corresponding buffer, just revert its
;; content to reflect what's on-disk.
(global-auto-revert-mode 1)

(require 'ido)
(ido-mode t)
(setq ido-save-directory-list-file "~/.emacs.d/.ido.last")
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)
(setq ido-show-dot-for-dired t)

(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)
(global-set-key (kbd "C-x C-x") 'ido-switch-buffer)
(global-set-key (kbd "C-x B") 'ibuffer)

;; C-x C-j opens dired with the cursor right on the file you're editing
(require 'dired-x)

;; full screen
(defun fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen
		       (if (frame-parameter nil 'fullscreen) nil 'fullboth)))

(require 'package)
; marmalade repo
(add-to-list 'package-archives
	'("marmalade" . "http://marmalade-repo.org/packages/") t)
; MELPA repo
(add-to-list 'package-archives
	'("melpa" . "http://melpa.milkbox.net/packages/") t)

(require 'evil)
(evil-mode t)

(require 'evil-surround)
(require 'evil-nerd-commenter)
(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader "\\")

;; (setcdr evil-insert-state-map [escape])
;; (define-key evil-insert-state-map
;; 	(read-kbd-macro evil-toggle-key) 'evil-emacs-state)
;; (define-key evil-insert-state-map [escape] 'evil-normal-state)

(defadvice evil-insert-state (around emacs-state-instead-of-insert-state activate)
  (evil-emacs-state))

(define-key evil-emacs-state-map (kbd "C-r") 'evil-paste-from-register)
(define-key evil-emacs-state-map (kbd "C-o") 'evil-normal-state)

(define-key evil-emacs-state-map [escape] 'evil-normal-state)
(define-key evil-emacs-state-map "k" #'cofi/maybe-exit-kj)
(define-key evil-emacs-state-map "j" #'cofi/maybe-exit-jk)

(evil-define-command cofi/maybe-exit-kj ()
  :repeat change
  (interactive)
  (let ((modified (buffer-modified-p)))
    (insert "k")
    (let ((evt (read-event (format "Insert %c to exit insert state" ?j)
               nil 0.5)))
      (cond
       ((null evt) (message ""))
       ((and (integerp evt) (char-equal evt ?j))
    (delete-char -1)
    (set-buffer-modified-p modified)
    (push 'escape unread-command-events))
       (t (setq unread-command-events (append unread-command-events
                          (list evt))))))))

(evil-define-command cofi/maybe-exit-jk ()
  :repeat change
  (interactive)
  (let ((modified (buffer-modified-p)))
    (insert "j")
    (let ((evt (read-event (format "Insert %c to exit insert state" ?k)
               nil 0.5)))
      (cond
       ((null evt) (message ""))
       ((and (integerp evt) (char-equal evt ?k))
    (delete-char -1)
    (set-buffer-modified-p modified)
    (push 'escape unread-command-events))
       (t (setq unread-command-events (append unread-command-events
                          (list evt))))))))

(require 'org)
(setq org-startup-indented 1)
(setq org-clock-sound t)
(setq org-timer-default-timer 25)

(defun nolinum ()
  (interactive)
  (global-linum-mode 0)
  (linum-mode 0)
)
(add-hook 'org-mode-hook 'nolinum)

(require 'molokai-theme)

;; make scroll smooth
(setq scroll-step 1)
(setq scroll-margin 0
scroll-conservatively 0)
(setq-default scroll-up-aggressively 0.01
scroll-down-aggressively 0.01)

(require 'ace-jump-mode)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(define-key evil-normal-state-map " " 'ace-jump-mode)

(require 'compile)
;; (add-hook 'c-mode-hook
;; 	  (lambda ()
;; 		 (unless (file-exists-p "Makefile")
;; 			  (set (make-local-variable 'compile-command)
;; 		   ;; emulate make's .c.o implicit pattern rule, but with
;; 		   ;; different defaults for the CC, CPPFLAGS, and CFLAGS
;; 		   ;; variables:
;; 		   ;; $(CC) -c -o $@ $(CPPFLAGS) $(CFLAGS) $<
;; 				   (let ((file (file-name-nondirectory buffer-file-name)))
;; 		     (format "%s -c -o %s.o %s %s %s"
;; 			     (or (getenv "CC") "gcc")
;; 			     (file-name-sans-extension file)
;; 			     (or (getenv "CPPFLAGS") "-DDEBUG=9")
;; 			     (or (getenv "CFLAGS") "-ansi -pedantic -Wall -g")
;; 			       file))))))
 (add-hook 'c-mode-hook
           (lambda ()
	          (unless (file-exists-p "Makefile")
		           (set (make-local-variable 'compile-command)
                    ;; emulate make's .c.o implicit pattern rule, but with
                    ;; different defaults for the CC, CPPFLAGS, and CFLAGS
                    ;; variables:
                    ;; $(CC) -c -o $@ $(CPPFLAGS) $(CFLAGS) $<
				    (let ((file (file-name-nondirectory buffer-file-name)))
                      (format "%s -o %s %s %s %s %s"
                              (or (getenv "CC") "gcc")
                              (file-name-sans-extension file)
                              (or (getenv "CPPFLAGS") "-DDEBUG=9")
                              (or (getenv "CFLAGS") "-ansi -pedantic -Wall -g")
			      file (format "%s%s" "&& ./" (file-name-sans-extension file))))))))

(require 'yasnippet)
(yas-global-mode 1)

(require 'saveplace)
(setq-default save-place t)

(require 'undo-tree)
(global-undo-tree-mode 1)

(require 'helm-config)
(require 'helm-grep)
;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))
(define-key helm-map (kbd "C-h") 'delete-backward-char)

(require 'helm-gtags)
(helm-gtags-mode 1)
(setq
    helm-gtags-ignore-case t
    helm-gtags-auto-update t
    helm-gtags-use-input-at-cursor t
    helm-gtags-pulse-at-cursor t
    helm-gtags-prefix-key "\C-cg"
    helm-gtags-suggested-key-mapping t
)

(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)

(require 'sr-speedbar)
(setq sr-speedbar-right-side nil)

(require 'cc-mode)
(require 'semantic)

(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(semantic-mode 1)
(global-semantic-idle-summary-mode 1)
(global-semantic-stickyfunc-mode 1)

;(semantic-add-system-include "/usr/include/boost" 'c++-mode)
;(semantic-add-system-include "~/linux/kernel")
;(semantic-add-system-include "~/linux/include")

(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(company-semantic 1)

(eval-after-load 'company
  '(progn
     (setq company-minimum-prefix-length 1)
     (setq company-idle-delay 0.2)
     (setq company-selection-wrap-around t)
     (define-key company-active-map (kbd "C-h") 'delete-backward-char)
     (define-key company-active-map (kbd "C-n") 'company-select-next)
     (define-key company-active-map (kbd "C-p") 'company-select-previous)
     (define-key company-active-map (kbd "TAB") 'company-select-next)
     (define-key company-active-map (kbd "C-\\") 'company-show-doc-buffer)
     (define-key company-active-map [tab] 'company-select-next)))

(require 'projectile)
(projectile-global-mode 1)
(setq projectile-completion-system 'helm)

(require 'dtrt-indent)
(dtrt-indent-mode 1)
(setq dtrt-indent-verbosity 0)

(require 'smartparens-config)
(show-smartparens-global-mode +1)
(smartparens-global-mode 1)

(setq gdb-many-windows t)
(setq gdb-show-main t)

; M-x semantic-force-refresh
;(ede-cpp-root-project "project_root"
                      ;:file "/dir/to/project_root/Makefile"
                      ;:include-path '("/include1"
                                      ;"/include2") ;; add more include
					  ; paths here
                      ;:system-include-path '("~/linux"))

(add-hook 'org-timer-start-hook
    (lambda ()
      ;;(delete-file "~/.pomodoro")
      (find-file "~/.pomodoro")
      (insert (number-to-string org-timer-current-timer))
      ;;(write-file "~/.pomodoro")
      ;;(kill-buffer)
    ))

(add-hook 'org-timer-stop-hook
    (lambda ()
    ))
