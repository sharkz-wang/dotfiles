;; emacs kicker --- kick start emacs setup
;; Copyright (C) 2010 Dimitri Fontaine
;;
;; Author: Dimitri Fontaine <dim@tapoueh.org>
;; URL: https://github.com/dimitri/emacs-kicker
;; Created: 2011-04-15
;; Keywords: emacs setup el-get kick-start starter-kit
;; Licence: WTFPL, grab your copy here: http://sam.zoy.org/wtfpl/
;;
;; This file is NOT part of GNU Emacs.

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

;; set local recipes
(setq
 el-get-sources
 '((:name buffer-move			; have to add your own keys
	  :after (progn
		   (global-set-key (kbd "<C-S-up>")     'buf-move-up)
		   (global-set-key (kbd "<C-S-down>")   'buf-move-down)
		   (global-set-key (kbd "<C-S-left>")   'buf-move-left)
		   (global-set-key (kbd "<C-S-right>")  'buf-move-right)))

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
      :url "https://github.com/magit/magit"
	  :after (progn
		   (global-set-key (kbd "C-x C-z") 'magit-status)))

   (:name org-mode
      :type git
      :url "https://github.com/jwiegley/org-mode"
	  :after (progn
		   (global-set-key (kbd "C-c t") 'org-todo)))

   (:name xscope
      :type git
      :url "https://github.com/dkogan/xcscope.el")

   (:name evil
      :type git
      :url "https://github.com/emacsmirror/evil")

   (:name yasnippet)
   (:name helm)
   (:name helm-gtags)

   (:name cedet)
   (:name function-args)

   (:name company-mode)
   ;; (:name helm-company)
   
   (:name projectile)
   (:name smartparens)

   (:name evil-matchit
      :type git
      :url "https://github.com/redguardtoo/evil-matchit")

   (:name sr-speedbar)
   (:name dtrt-indent)

   (:name molokai-theme
      :type git
      :url "https://github.com/hbin/molokai-theme")

   (:name goto-last-change		; move pointer back to last change
	  :after (progn
		   ;; when using AZERTY keyboard, consider C-x C-_
		   (global-set-key (kbd "C-x C-/") 'goto-last-change)))))

;; now set our own packages
(setq
 my:el-get-packages
 '(el-get				; el-get is self-hosting
   evil
   undo-tree
   evil-surround
   evil-numbers
   evil-leader
   evil-nerd-commenter
   smooth-scroll
   ace-jump-mode
   ;; evil-rails
   ;; evil-extra-operator
   ;; evil-args
   ;; switch-window			; takes over C-x o
   ))

;;
;; Some recipes require extra tools to be installed
;;
;; Note: el-get-install requires git, so we know we have at least that.
;;
(when (el-get-executable-find "cvs")
  (add-to-list 'my:el-get-packages 'emacs-goodies-el)) ; the debian addons for emacs

(when (el-get-executable-find "svn")
  (loop for p in '(psvn    		; M-x svn-status
		   )
	do (add-to-list 'my:el-get-packages p)))

(setq my:el-get-packages
      (append
       my:el-get-packages
       (loop for src in el-get-sources collect (el-get-source-name src))))

;; install new packages and init already installed packages
(el-get 'sync my:el-get-packages)

;; on to the visual settings
(setq inhibit-splash-screen t)		; no splash screen, thanks
(line-number-mode 1)			; have line numbers and
(column-number-mode 1)			; column numbers in the mode line

(tool-bar-mode -1)			; no tool bar with icons
(scroll-bar-mode -1)			; no scroll bars
(unless (string-match "apple-darwin" system-configuration)
  ;; on mac, there's always a menu bar drown, don't have it empty
  (menu-bar-mode -1))

;; choose your own fonts, in a system dependant way
;; (if (string-match "apple-darwin" system-configuration)
;;     (set-face-font 'default "Monaco-13")
;;   (set-face-font 'default "Monospace-10"))

(global-hl-line-mode)			; highlight current line
(global-linum-mode 1)			; add line numbers on the left
(setq linum-format "%d ")

;; avoid compiz manager rendering bugs
(add-to-list 'default-frame-alist '(alpha . 100))

;; under mac, have Command as Meta and keep Option for localized input
(when (string-match "apple-darwin" system-configuration)
  (setq mac-allow-anti-aliasing t)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none))

;; Use the clipboard, pretty please, so that copy/paste "works"
(setq x-select-enable-clipboard t)

;; Navigate windows with M-<arrows>
(windmove-default-keybindings 'meta)
(setq windmove-wrap-around t)

; winner-mode provides C-<left> to get back to previous window layout
(winner-mode 1)

;; whenever an external process changes a file underneath emacs, and there
;; was no unsaved changes in the corresponding buffer, just revert its
;; content to reflect what's on-disk.
(global-auto-revert-mode 1)

;; M-x shell is a nice shell interface to use, let's make it colorful.  If
;; you need a terminal emulator rather than just a shell, consider M-x term
;; instead.
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; If you do use M-x term, you will notice there's line mode that acts like
;; emacs buffers, and there's the default char mode that will send your
;; input char-by-char, so that curses application see each of your key
;; strokes.
;;
;; The default way to toggle between them is C-c C-j and C-c C-k, let's
;; better use just one key to do the same.
(require 'term)
(define-key term-raw-map  (kbd "C-'") 'term-line-mode)
(define-key term-mode-map (kbd "C-'") 'term-char-mode)

;; Have C-y act as usual in term-mode, to avoid C-' C-y C-'
;; Well the real default would be C-c C-j C-y C-c C-k.
(define-key term-raw-map  (kbd "C-y") 'term-paste)

;; use ido for minibuffer completion
(require 'ido)
(ido-mode t)
(setq ido-save-directory-list-file "~/.emacs.d/.ido.last")
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)
(setq ido-show-dot-for-dired t)

;; default key to switch buffer is C-x b, but that's not easy enough
;;
;; when you do that, to kill emacs either close its frame from the window
;; manager or do M-x kill-emacs.  Don't need a nice shortcut for a once a
;; week (or day) action.
(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)
(global-set-key (kbd "C-x B") 'ibuffer)

;; C-x C-j opens dired with the cursor right on the file you're editing
(require 'dired-x)

;; full screen
(defun fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen
		       (if (frame-parameter nil 'fullscreen) nil 'fullboth)))
(global-set-key [f11] 'fullscreen)

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

;(require 'evernote-mode)
;(defvar enh-enclient-command "/usr/bin/enclient.rb" "Name of the enclient.rb command")

(require 'molokai-theme)

;(require 'tabbar)
; (setq tabbar-buffer-groups-function nil)
;(tabbar-mode t)

(require 'org)
(setq org-startup-indented 1)
(setq org-clock-sound t)
(setq org-timer-default-timer 25)
;(global-set-key (kbd "C-c C-x ;") 'org-timer-set-timer)

(require 'xcscope)
(cscope-setup)
;; (require 'ascope)
;(ascope-init)
;; (ascope-init (getenv "PWD" ))
;; (setq pwd (getenv "PWD"))
;; (cond ((file-exists-p (expand-file-name "cscope.out" pwd))
;;       (ascope-init (concat pwd "/"))))

(defun nolinum ()
  (interactive)
  (global-linum-mode 0)
  (linum-mode 0)
)
(add-hook 'org-mode-hook 'nolinum)

(global-set-key (kbd "C-x C-h") 'tabbar-backward)
(global-set-key (kbd "C-x C-l") 'tabbar-forward)

(global-set-key (kbd "C-?") 'help-command)
(global-set-key (kbd "M-?") 'mark-paragraph)
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "M-h") 'backward-kill-word)

(setq scroll-step 1)
(setq scroll-margin 0
scroll-conservatively 0)
(setq-default scroll-up-aggressively 0.01
scroll-down-aggressively 0.01)

(require 'ace-jump-mode)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(define-key evil-normal-state-map " " 'ace-jump-mode)

; Set vertical split as default
;(setq split-height-threshold nil)
;(setq split-width-threshold 0)

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

(require 'saveplace)
(setq-default save-place t)

(require 'undo-tree)
(global-undo-tree-mode 1)

(require 'helm-config)
(require 'helm-grep)
;; ;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; ;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; ;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
;; (global-set-key (kbd "C-c h") 'helm-command-prefix)
;; (global-unset-key (kbd "C-x c"))
;; (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebihnd tab to do persistent action
;; (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
;; (define-key helm-map (kbd "C-z") 'helm-select-action) ; list actions using C-z
;; (define-key helm-grep-mode-map (kbd "<return>") 'helm-grep-mode-jump-other-window)
;; (define-key helm-grep-mode-map (kbd "n") 'helm-grep-mode-jump-other-window-forward)
;; (define-key helm-grep-mode-map (kbd "p") 'helm-grep-mode-jump-other-window-backward)
;; (when (executable-find "curl")
;; (setq helm-google-suggest-use-curl-p t))
;; (setq
;; helm-scroll-amount 4 ; scroll 4 lines other window using M-<next>/M-<prior>
;; helm-quick-update t ; do not display invisible candidates
;; helm-ff-search-library-in-sexp t ; search for library in `require' and `declare-function' sexp.
;; helm-split-window-in-side-p t ;; open helm buffer inside current window, not occupy whole other window
;; helm-candidate-number-limit 500 ; limit the number of displayed canidates
;; helm-ff-file-name-history-use-recentf t
;; helm-move-to-line-cycle-in-source t ; move to end or beginning of source when reaching top or bottom of source.
;; helm-buffers-fuzzy-matching t ; fuzzy matching buffer names when non-nil
;; ; useful in helm-mini that lists buffers
;; )
;; (add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)
;; (global-set-key (kbd "M-x") 'helm-M-x)
;; (global-set-key (kbd "M-y") 'helm-show-kill-ring)
;; (global-set-key (kbd "C-x b") 'helm-mini)
;; (global-set-key (kbd "C-x C-f") 'helm-find-files)
;; (global-set-key (kbd "C-c SPC") 'helm-all-mark-rings)
;; (global-set-key (kbd "C-c h o") 'helm-occur)
;; (global-set-key (kbd "C-c h C-c w") 'helm-wikipedia-suggest)
;; (global-set-key (kbd "C-c h x") 'helm-register)
;; ;; (global-set-key (kbd "C-x r j") 'jump-to-register)
;; (define-key 'help-command (kbd "C-f") 'helm-apropos)
;; (define-key 'help-command (kbd "r") 'helm-info-emacs)
;; (define-key 'help-command (kbd "C-l") 'helm-locate-library)
;; ;; use helm to list eshell history
;; (add-hook 'eshell-mode-hook
;; #'(lambda ()
;; (define-key eshell-mode-map (kbd "M-l") 'helm-eshell-history)))
;; ;;; Save current position to mark ring
;; (add-hook 'helm-goto-line-before-hook 'helm-save-current-pos-to-mark-ring)
;; ;; show minibuffer history with Helm
;; (define-key minibuffer-local-map (kbd "M-p") 'helm-minibuffer-history)
;; (define-key minibuffer-local-map (kbd "M-n") 'helm-minibuffer-history)
;; (define-key global-map [remap find-tag] 'helm-etags-select)
;; (define-key global-map [remap list-buffers] 'helm-buffers-list)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; PACKAGE: helm-swoop ;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Locate the helm-swoop folder to your path
;; (require 'helm-swoop)
;; ;; Change the keybinds to whatever you like :)
;; (global-set-key (kbd "C-c h o") 'helm-swoop)
;; (global-set-key (kbd "C-c s") 'helm-multi-swoop-all)
;; ;; When doing isearch, hand the word over to helm-swoop
;; (define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
;; ;; From helm-swoop to helm-multi-swoop-all
;; (define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)
;; ;; Save buffer when helm-multi-swoop-edit complete
;; (setq helm-multi-swoop-edit-save t)
;; ;; If this value is t, split window inside the current window
;; (setq helm-swoop-split-with-multiple-windows t)
;; ;; Split direcion. 'split-window-vertically or 'split-window-horizontally
;; (setq helm-swoop-split-direction 'split-window-vertically)
;; ;; If nil, you can slightly boost invoke speed in exchange for text color
;; (setq helm-swoop-speed-or-color t)
;; (helm-mode 1)

(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t
 )

(require 'helm-gtags)
(helm-gtags-mode 1)
;; Enable helm-gtags-mode
(add-hook 'dired-mode-hook 'helm-gtags-mode)
(add-hook 'eshell-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)

(require 'sr-speedbar)
;(add-hook 'after-init-hook '(lambda () (sr-speedbar-toggle)))
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

;; (define-key company-active-map (kbd "<return>") 'company-complete)
;; (define-key company-active-map (kbd "<tab>") 'company-select-next)

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

; M-x semantic-force-refresh
;(ede-cpp-root-project "project_root"
                      ;:file "/dir/to/project_root/Makefile"
                      ;:include-path '("/include1"
                                      ;"/include2") ;; add more include
					  ; paths here
                      ;:system-include-path '("~/linux"))

(projectile-global-mode 1)
(setq projectile-completion-system 'helm)

(global-set-key (kbd "RET") 'newline-and-indent)
(setq-default tab-width 8)
(require 'dtrt-indent)
(dtrt-indent-mode 1)

(setq dtrt-indent-verbosity 1)

(require 'smartparens-config)
(show-smartparens-global-mode +1)
(smartparens-global-mode 1)

(setq
	;; use gdb-many-windows by default
	gdb-many-windows t

	;; Non-nil means display source file containing the main routine at startup
	gdb-show-main t
)
