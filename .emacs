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

   ;; Vim-emulation
   (:name evil)
   (:name evil-matchit)
   (:name evil-surround)
   (:name evil-numbers)
   (:name evil-leader)
   (:name evil-nerd-commenter)
   (:name evil-org-mode
	  :type git
	  :url "https://github.com/edwtjo/evil-org-mode")
   (:name evil-visual-mark-mode
	  :type git
	  :url "https://github.com/roman/evil-visual-mark-mode")

   (:name evil-jumper)

   (:name golden-ratio)
   (:name adaptive-wrap)
   (:name ace-window
	  :type git
	  :url "https://github.com/abo-abo/ace-window")

   (:name undo-tree)
   (:name paredit)
   (:name highlight-parentheses)

   (:name avy
		:type git
		:url "https://github.com/abo-abo/avy")
   (:name history
		:type git
		:url "https://github.com/boyw165/history")
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
	  :after (progn
		   (global-set-key (kbd "C-x C-z") 'magit-status)))

   (:name deferred)
   (:name popup)

   (:name company-mode)
   (:name emacs-ycmd
		:type git
		:url "https://github.com/abingham/emacs-ycmd")
   (:name cedet)
   (:name yasnippet)

   (:name elpy)

   (:name helm-dash)

   (:name emacs-w3m)

   (:name semantic-refactor
		:type git
		:url "https://github.com/tuhdo/semantic-refactor")

   (:name function-args)

   (:name ggtags)
   (:name helm)
   (:name helm-gtags)

   (:name f)
   (:name projectile)

   (:name uncrustify-mode
		:type git
		:url "https://github.com/koko1000ban/emacs-uncrustify-mode")

   (:name linum-relative)

   (:name sr-speedbar)
   (:name dtrt-indent)

   ;(:name ess)

   (:name auctex
		:type git
		:url "https://github.com/jwiegley/auctex")
   (:name langtool)

   (:name cperl-mode)
   
   (:name clojure-mode)
   (:name cider)
   (:name ac-cider
		:type git
		:url "https://github.com/clojure-emacs/ac-cider")

   (:name org-mode
	  :after (progn
		   (global-set-key (kbd "C-c t") 'org-todo)))

   (:name markdown-mode)

   (:name indent-guide)

   (:name Fill-Column-Indicator
      :type git
      :url "https://github.com/alpaker/Fill-Column-Indicator")

   (:name hl-spotlight
      :type elpa)

   (:name molokai-theme
	  :type git
	  :url "https://github.com/hbin/molokai-theme")

   (:name monokai-emacs-theme
	  :type git
	  :url "https://github.com/oneKelvinSmith/monokai-emacs")
   ))

;; install new packages and init already installed packages
(el-get 'sync (loop for src in el-get-sources collect (el-get-source-name src)))

(setq inhibit-splash-screen t)		; no splash screen, thanks
(line-number-mode 1)			; have line numbers and
(column-number-mode 1)			; column numbers in the mode line

(set-default-font "Deja Vu Sans Mono-14")
;(set-face-attribute 'default nil :height 140)

(tool-bar-mode -1)			; no tool bar with icons
(scroll-bar-mode -1)			; no scroll bars
(menu-bar-mode -1)

(global-hl-line-mode)			; highlight current line

(global-linum-mode 1)			; add line numbers on the left
(setq linum-format 'linum-relative)

(require 'linum-relative)
(setq linum-relative-current-symbol "")
(custom-set-faces
  '(linum-relative-current-face ((t :inherit hl-spotlight :foreground "#FF8700"))))

(defadvice linum-update (around hl-linum-update)
		     (let ((linum-current-line-number (line-number-at-pos)))
			       ad-do-it))
(ad-activate 'linum-update)

(add-hook 'linum-before-numbering-hook
		  (lambda ()
			(if (eq linum-format 'linum-format-func)
			  (setq-local linum-format-fmt
						  (let ((w (length (number-to-string
											 (count-lines (point-min) (point-max))))))
							(concat " %" (number-to-string w) "d   ")))
			  (setq linum-relative-format
					(let ((w (length (number-to-string
									   (count-lines (point-min) (point-max))))))
					  (concat " %" (number-to-string w) "s   "))))))

(defun linum-format-func (line)
  (concat
   (propertize (format linum-format-fmt line) 'face
			   (if (eq linum-current-line-number line)
			   '((t :inherit hl-spotlight :foreground "#FF8700"))
			   '((t :inherit linum))))))

(define-key evil-normal-state-map ";" '(lambda () (interactive)
										 (if (eq linum-format 'linum-format-func)
										   (setq linum-format 'linum-relative)
										   (setq linum-format 'linum-format-func))))

(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-h") 'delete-backward-char)
(define-key isearch-mode-map (kbd "C-h") 'isearch-del-char)

(setq browse-url-browser-function (quote browse-url-firefox))
;(setq browse-url-browser-function 'w3m-goto-url-new-session)

(define-key global-map (kbd "C-w") 'evil-delete-backward-word)
(define-key global-map (kbd "C-x C-o") 'ff-find-other-file)

(setq-default indent-tabs-mode t)
(setq c-default-style "k&r")
(setq-default tab-width 8)
;(defvaralias 'c-basic-offset 'tab-width)

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

(global-set-key (kbd "C-x C-x") 'ido-switch-buffer)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
(global-set-key (kbd "C-x b") 'helm-buffers-list)
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

(evil-jumper-mode t)
(evil-visual-mark-mode t)

(add-hook 'org-mode-hook
    (lambda () (modify-syntax-entry ?_ "w")))
(add-hook 'c-mode-hook
    (lambda () (modify-syntax-entry ?_ "w")))
(add-hook 'c++-mode-hook
    (lambda () (modify-syntax-entry ?_ "w")))
(add-hook 'python-mode-hook
    (lambda () (modify-syntax-entry ?_ "w")
				(elpy-enable)
				(flymake-mode t)
				(global-set-key (kbd "C-c C-d") 'elpy-doc)))
(add-hook 'emacs-lisp-mode-hook
    (lambda () (modify-syntax-entry ?_ "w")))

(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader "\\")
(define-key evil-visual-state-map (kbd "\\ c i") 'evilnc-comment-or-uncomment-lines)
(require 'evil-surround)
(require 'evil-nerd-commenter)

(require 'evil-org)

(define-key evil-normal-state-map (kbd "_") '(lambda () (interactive)
						 (message (buffer-file-name
							   (window-buffer (minibuffer-selected-window))))))

(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
(define-key evil-normal-state-map (kbd "C-w") 'ace-window)
(define-key global-map (kbd "C-c w") 'ace-window)
(defvar aw-dispatch-alist
  '((?x aw-delete-window " Ace - Delete Window")
    (?m aw-swap-window " Ace - Swap Window")
    (?n aw-flip-window)
    (?l aw-flip-window)
    (?v aw-split-window-vert " Ace - Split Vert Window")
    (?b aw-split-window-horz " Ace - Split Horz Window")
    (?i delete-other-windows " Ace - Maximize Window")
    (?o delete-other-windows))
  "List of actions for `aw-dispatch-default'.")

;; (setcdr evil-insert-state-map [escape])
;; (define-key evil-insert-state-map
;; 	(read-kbd-macro evil-toggle-key) 'evil-emacs-state)
;; (define-key evil-insert-state-map [escape] 'evil-normal-state)

;; Cursor motion in wrapped lines
(define-key evil-normal-state-map "j" 'evil-next-visual-line)
(define-key evil-normal-state-map "k" 'evil-previous-visual-line)

(defadvice evil-insert-state (around emacs-state-instead-of-insert-state activate)
  (evil-emacs-state))

(define-key evil-emacs-state-map (kbd "C-r") 'evil-paste-from-register)
(define-key evil-emacs-state-map (kbd "C-o") 'evil-execute-in-normal-state)

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

;(require 'molokai-theme)
(require 'monokai-theme)

(hl-spotlight-mode 1)
(setq hl-spotlight-height 0)
(custom-set-faces
  '(hl-spotlight ((t :inherit highlight :weight bold))))

;; make scroll smooth
(setq scroll-step 1)
(setq scroll-margin 0
scroll-conservatively 0)
(setq-default scroll-up-aggressively 0.01
scroll-down-aggressively 0.01)

(define-key global-map (kbd "C-c SPC") 'avy-goto-char)
(define-key evil-normal-state-map (kbd "SPC") 'avy-goto-char)

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

;; Making GNU Global support more languages
;; 1) Install Exuberant Ctags
;; 2) Run `pip install pygments`
;; 3) Copy /usr/local/share/gtags/gtags.conf to ~/.globalrc
;; 4) Update ~/.globalrc: change pigments-parser.la and exuberant-ctags.la to *.so and correct their path
;; 5) Build tags by running `gtags --gtagslabel=pygments`
(require 'helm-gtags)
(add-hook 'dired-mode-hook 'helm-gtags-mode)
(add-hook 'eshell-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'python-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

(setq
    helm-gtags-ignore-case t
    helm-gtags-auto-update t
    helm-gtags-use-input-at-cursor t
    helm-gtags-pulse-at-cursor t
    helm-gtags-prefix-key "\C-c g"
    helm-gtags-suggested-key-mapping t
)

(define-key helm-gtags-mode-map (kbd "C-c g S") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "C-c g d") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "C-c g p") 'helm-gtags-find-pattern)
(define-key helm-gtags-mode-map (kbd "C-c g f") 'helm-gtags-find-files)
(define-key helm-gtags-mode-map (kbd "C-c g r") 'helm-gtags-find-rtag)
(define-key helm-gtags-mode-map (kbd "C-c g s") 'helm-gtags-find-symbol)
(define-key helm-gtags-mode-map (kbd "C-c g t") 'helm-gtags-find-tag)

(require 'sr-speedbar)
(setq sr-speedbar-width 25)
(setq sr-speedbar-auto-refresh t)
(setq sr-speedbar-right-side nil)
(setq speedbar-show-unknown-files t)
(setq speedbar-use-images nil)

(global-set-key (kbd "C-\\") '(lambda () (interactive)
								(if (sr-speedbar-exist-p)
								  (sr-speedbar-close)
								  (if (sr-speedbar-buffer-exist-p speedbar-buffer)
									(sr-speedbar-open)
									(progn (sr-speedbar-open) (evil-goto-first-line))))))

;; (add-hook 'emacs-startup-hook (lambda () (sr-speedbar-open) (other-window 1)))
(add-hook 'speedbar-mode-hook '(lambda () (linum-mode 0) (visual-line-mode 0)))

(require 'semantic)
;(global-semanticdb-minor-mode 1)
;(global-semantic-idle-scheduler-mode 1)
(semantic-mode 1)
;(global-semantic-idle-summary-mode 1)
(global-semantic-stickyfunc-mode 1)

;(semantic-add-system-include "/usr/include/boost" 'c++-mode)
;(semantic-add-system-include "~/linux/kernel")
;(semantic-add-system-include "~/linux/include")

(require 'srefactor)
(define-key c-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
(define-key c++-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)

(require 'company)
(add-hook 'after-init-hook #'global-company-mode)
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 1)
(setq company-show-numbers t)
(setq company-selection-wrap-around t)
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map (kbd "TAB") 'company-select-next)
(define-key company-active-map (kbd "C-h") 'delete-backward-char)
(define-key company-active-map (kbd "C-w") 'evil-delete-backward-word)

;(define-key company-active-map (kbd "SPC") (lambda () (interactive) (company-complete-selection) (insert " ")))
;(define-key company-active-map (kbd ".") (lambda () (interactive) (company-complete-selection) (insert ".")))
;(define-key company-active-map (kbd "-") (lambda () (interactive) (company-complete-selection) (insert "-")))
;(define-key company-active-map (kbd ")") (lambda () (interactive) (company-complete-selection) (insert ")")))
;(define-key company-active-map (kbd "}") (lambda () (interactive) (company-complete-selection) (insert "}")))
;(define-key company-active-map (kbd ">") (lambda () (interactive) (company-complete-selection) (insert ">")))
;(define-key company-active-map (kbd ";") (lambda () (interactive) (company-complete-selection) (insert ";")))

;; ycmd Installation
;; 1) git clone https://github.com/Valloric/ycmd.git
;; 2) git submodule update --init --recursive
;; 3) install mono-xbuild and mono-devel
;; 4) ./build.py --clang-completer --omnisharp-completer --gocode-completer --system-libclang

;(add-hook 'after-init-hook #'global-flycheck-mode)
(require 'ycmd)
(add-hook 'after-init-hook #'global-ycmd-mode)
(setq ycmd-force-semantic-completion t)
(set-variable 'ycmd-server-command (list "python" (expand-file-name "/opt/ycmd/ycmd")))
(set-variable 'ycmd-global-config "/opt/ycmd/cpp/ycm/.ycm_extra_conf.py")
(require 'company-ycmd)
(company-ycmd-setup)
;(require 'flycheck-ycmd)
;(flycheck-ycmd-setup)

(require 'yasnippet)
(yas-global-mode 1)

(global-set-key (kbd "M-/") 'yas-expand)

(defvar company-mode/enable-yas t
  "Enable yasnippet for all backends.")
(defun company-mode/backend-with-yas (backend)
  (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
	  backend
	(append (if (consp backend) backend (list backend))
			'(:with company-yasnippet))))
(setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))

(require 'cc-mode)
(defun private-c-c++-mode-hook ()

                ;; Auto indenting and pairing curly brace
    (defun c-mode-insert-lcurly ()
      (interactive)
      (insert "{")
      (let ((pps (syntax-ppss)))
        (when (and (eolp) (not (or (nth 3 pps) (nth 4 pps)))) ;; EOL and not in string or comment
          (c-indent-line)
          (insert "\n\n}")
          (c-indent-line)
          (forward-line -1)
          (c-indent-line))))
    (define-key c-mode-base-map "{" 'c-mode-insert-lcurly)

	(require 'uncrustify-mode)
	;(uncrustify-mode 1)
	(setq uncrustify-config-path "~/.uncrustify/linux-kernel.cfg")

	(defun company-transform-c-c++ (candidates)
	  (let ((deleted))
		(mapcar #'(lambda (c)
					(if (string-prefix-p "_" c)
					  (progn
						(add-to-list 'deleted c)
						(setq candidates (delete c candidates)))))
				candidates)
		(append candidates (nreverse deleted))))
	(setq-local company-transformers
				(append company-transformers '(company-transform-c-c++)))
)
(define-key c-mode-map (kbd "C-c C-c") 'compile)
(add-hook 'c-mode-hook 'private-c-c++-mode-hook)

(define-key c++-mode-map (kbd "C-c C-c") 'compile)
(add-hook 'c++-mode-hook 'private-c-c++-mode-hook)

(defun private-cperl-mode-hook ()
	;; (defun cperl-mode-insert-lcurly ()
	;;   (interactive)
	;;   (insert "{")
	;;   (let ((pps (syntax-ppss)))
	;; 	(when (and (eolp) (not (or (nth 3 pps) (nth 4 pps)))) ;; EOL and not in string or comment
	;; 	  (c-indent-line)
	;; 	  (insert "\n\n}")
	;; 	  (c-indent-line)
	;; 	  (forward-line -1)
	;; 	  (c-indent-line))))
	;; (define-key global-map "{" 'cperl-mode-insert-lcurly)
	(define-key global-map (kbd "C-c C-c") 'compile)
)
(add-hook 'cperl-mode-hook 'private-cperl-mode-hook)

(add-to-list 'auto-mode-alist '("\\.R\\'" . R-mode))
(defun load-company-ess ()
)
(add-hook 'R-mode-hook 'load-company-ess)

(require 'projectile)
(projectile-global-mode 1)
(setq projectile-indexing-method 'native)
(setq projectile-enable-caching t)
(setq projectile-completion-system 'helm)
(define-key projectile-mode-map (kbd "C-c p s g") 'helm-projectile-grep)

(require 'dtrt-indent)
(dtrt-indent-mode 1)
(setq dtrt-indent-verbosity 0)

(setq gdb-many-windows t)
(setq gdb-show-main t)

; M-x semantic-force-refresh
;(ede-cpp-root-project "project_root"
                      ;:file "/dir/to/project_root/Makefile"
                      ;:include-path '("/include1"
                                      ;"/include2") ;; add more include
					  ; paths here
                      ;:system-include-path '("~/linux"))

;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
(setq backup-directory-alist '((".*" . "~/.emacs.d/backups/")))

;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/autosaves/" t)
(make-directory "~/.emacs.d/backups/" t)

;(defun my-emacs-lisp-mode-hook ()
  ;(highlight-indentation)
  ;(set-face-background 'highlight-indentation-face "#303030"))
;(add-hook 'emacs-lisp-mode-hook 'my-emacs-lisp-mode-hook)

;; (add-hook 'window-scroll-functions 'update-linum-format nil t)
;; (defun update-linum-format (window start)
;;     (interactive)
;;     (setq linum-format "%9d "))

;(require 'indent-guide)
;(indent-guide-global-mode 1)
;(setq indent-guide-recursive t)
;; (setq indent-guide-char ":")

(defvar endless/margin-display
    `((margin left-margin) ,(propertize "-----" 'face 'linum))
	  "String used on the margin.")

(defvar-local endless/margin-overlays nil
  "List of overlays in current buffer.")

(defun endless/setup-margin-overlays ()
  "Put overlays on each line which is visually wrapped."
  (interactive)
  (let ((ww (- (window-width)
               (if (= 0 (or (cdr fringe-mode) 1)) 1 0)))
        ov)
    (mapc #'delete-overlay endless/margin-overlays)
    (save-excursion
      (goto-char (point-min))
      (while (null (eobp))
        ;; On each logical line
        (forward-line 1)
        (save-excursion
          (forward-char -1)
          ;; Check if it has multiple visual lines.
          (while (>= (current-column) ww)
            (endles/make-overlay-at (point))
            (forward-char (- ww))))))))

(defun endles/make-overlay-at (p)
  "Create a margin overlay at position P."
  (push (make-overlay p (1+ p)) endless/margin-overlays)
  (overlay-put
   (car endless/margin-overlays) 'before-string
   (propertize " "  'display endless/margin-display)))

; (add-hook 'linum-before-numbering-hook #'endless/setup-margin-overlays)

;; Set default splitting approach to vertical split
;(setq split-height-threshold nil)
;(setq split-width-threshold 80)

;(require 'golden-ratio)
;(golden-ratio-mode 1)

;; Line wrapping settings
(setq-default truncate-lines nil)
(require 'adaptive-wrap)
(add-hook 'visual-line-mode-hook 'adaptive-wrap-prefix-mode)
(global-visual-line-mode 1)

(require 'history)
(history-mode 1)
(define-key global-map (kbd "C-x .") 'history-next-history)
(define-key global-map (kbd "C-x ,") 'history-prev-history)
(define-key global-map (kbd "C-x /") 'history-add-history)

(paredit-mode 1)
(define-key global-map (kbd "M-)") 'paredit-forward-slurp-sexp)
(define-key global-map (kbd "M-(") 'paredit-backward-slurp-sexp)
(define-key global-map (kbd "M-}") 'paredit-forward-barf-sexp)
(define-key global-map (kbd "M-{") 'paredit-backward-barf-sexp)

;(show-paren-mode 1)

(require 'highlight-parentheses)
(global-highlight-parentheses-mode 1)

(defun evilnc-default-hotkeys ()
	"Set the hotkeys of evil-nerd-comment"
	(interactive)
	(global-set-key (kbd "M-;") 'evilnc-comment-or-uncomment-lines)
	(global-set-key (kbd "C-c l") 'evilnc-comment-or-uncomment-to-the-line)
	(global-set-key (kbd "C-c c") 'evilnc-copy-and-comment-lines)
	(global-set-key (kbd "C-c p") 'evilnc-comment-or-uncomment-paragraphs)

	(define-key evil-normal-state-map "\\ci" 'evilnc-comment-or-uncomment-lines)
	(define-key evil-normal-state-map "\\cl" 'evilnc-comment-or-uncomment-to-the-line)
	(define-key evil-normal-state-map "\\cc" 'evilnc-copy-and-comment-lines)
	(define-key evil-normal-state-map "\\cp" 'evilnc-comment-or-uncomment-paragraphs)
	(define-key evil-normal-state-map "\\cr" 'comment-or-uncomment-region))
(evilnc-default-hotkeys)

(defun beginning-of-indentation-or-line ()
  "Move point to the beginning of text on the current line; if that is already
   the current position of point, then move it to the beginning of the line."
  (interactive)
  (let ((pt (point)))
    (beginning-of-line-text)
    (when (eq pt (point))
      (beginning-of-line))))
(global-set-key (kbd "C-a") 'beginning-of-indentation-or-line)

(add-hook 'w3m-mode-hook (lambda () (linum-mode 0) (indent-guide-mode 0)))
;;change w3m user-agent to android
(setq w3m-user-agent "Mozilla/5.0 (Linux; U; Android 2.3.3; zh-tw; HTC_Pyramid Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.")

;;quick access hacker news
(defun hn ()
  (interactive)
  (browse-url "http://news.ycombinator.com"))

;;quick access reddit
(defun reddit (reddit)
  "Opens the REDDIT in w3m-new-session"
  (interactive (list
                (read-string "Enter the reddit (default: Linux): " nil nil "Linux" nil)))
  (browse-url (format "http://m.reddit.com/r/%s" reddit))
  )

;;i need this often
(defun wikipedia-search (search-term)
  "Search for SEARCH-TERM on wikipedia"
  (interactive
   (let ((term (if mark-active
                   (buffer-substring (region-beginning) (region-end))
                 (word-at-point))))
     (list
      (read-string
       (format "Wikipedia (%s):" term) nil nil term)))
   )
  (browse-url
   (concat
    "http://en.m.wikipedia.org/w/index.php?search="
    search-term
    ))
  )

;;when I want to enter the web address all by hand
(defun w3m-open-site (site)
  "Opens site in new w3m session with 'http://' appended"
  (interactive
   (list (read-string "Enter website address(default: w3m-home):" nil nil w3m-home-page nil )))
  (w3m-goto-url-new-session
   (concat "http://" site))) 
 
(setq helm-dash-docsets-path (expand-file-name "~/.emacs.d/docsets"))
(setq helm-dash-common-docsets '("C" "C++" "Perl" "Python_2" "Python_3" "Clojure" "R"))

;; AucTeX
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
;(require 'langtool)
(setq langtool-language-tool-jar "~/LanguageTool-3.0/languagetool-commandline.jar")
(setq reftex-plug-into-AUCTeX t)
(setq TeX-PDF-mode t)
 
;; Use Skim as viewer, enable source <-> PDF sync
;; make latexmk available via C-c C-c
;; Note: SyncTeX is setup via ~/.latexmkrc (see below)
(add-hook 'LaTeX-mode-hook (lambda ()
  (push
    '("latexmk" "latexmk -pdf %s" TeX-run-TeX nil t
      :help "Run latexmk on file")
    TeX-command-list)))
(add-hook 'TeX-mode-hook '(lambda () (setq TeX-command-default "latexmk")))
 
(setq TeX-view-program-selection '((output-pdf "PDF Viewer")))
(setq TeX-view-program-list
     '(("PDF Viewer" "xpdf -g %n %o %b")))
