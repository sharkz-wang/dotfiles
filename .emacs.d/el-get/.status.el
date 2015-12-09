((Fill-Column-Indicator status "installed" recipe
			(:name Fill-Column-Indicator :type git :url "https://github.com/alpaker/Fill-Column-Indicator"))
 (ac-cider status "installed" recipe
	   (:name ac-cider :type git :url "https://github.com/clojure-emacs/ac-cider"))
 (adaptive-wrap status "installed" recipe
		(:name adaptive-wrap :description "This package provides the `adaptive-wrap-prefix-mode' minor mode which sets\nthe wrap-prefix property on the fly so that single-long-line paragraphs get\nword-wrapped in a way similar to what you'd get with M-q using\nadaptive-fill-mode, but without actually changing the buffer's text." :website "http://elpa.gnu.org/packages/adaptive-wrap.html" :type elpa))
 (auctex status "installed" recipe
	 (:name auctex :type git :url "https://github.com/jwiegley/auctex"))
 (avy status "installed" recipe
      (:name avy :type git :url "https://github.com/abo-abo/avy"))
 (cedet status "installed" recipe
	(:name cedet :website "http://cedet.sourceforge.net/" :description "CEDET is a Collection of Emacs Development Environment Tools written with the end goal of creating an advanced development environment in Emacs." :type git :url "http://git.code.sf.net/p/cedet/git" :build
	       `(("sh" "-c" "touch `find . -name Makefile`")
		 ("make" ,(format "EMACS=%s"
				  (shell-quote-argument el-get-emacs))
		  "clean-all")
		 ("make" ,(format "EMACS=%s"
				  (shell-quote-argument el-get-emacs)))
		 ("make" ,(format "EMACS=%s"
				  (shell-quote-argument el-get-emacs))
		  "-C" "contrib"))
	       :build/berkeley-unix
	       `(("sh" "-c" "touch `find . -name Makefile`")
		 ("gmake" ,(format "EMACS=%s"
				   (shell-quote-argument el-get-emacs))
		  "clean-all")
		 ("gmake" ,(format "EMACS=%s"
				   (shell-quote-argument el-get-emacs)))
		 ("gmake" ,(format "EMACS=%s"
				   (shell-quote-argument el-get-emacs))
		  "-C" "contrib"))
	       :build/windows-nt
	       `(("sh" "-c" "touch `/usr/bin/find . -name Makefile` && make FIND=/usr/bin/find"))
	       :features nil :lazy nil :post-init
	       (if
		   (or
		    (featurep 'cedet-devel-load)
		    (featurep 'eieio))
		   (message
		    (concat "Emacs' built-in CEDET has already been loaded!  Restart" " Emacs to load CEDET from el-get instead."))
		 (load
		  (expand-file-name "cedet-devel-load.el" pdir)))))
 (cider status "installed" recipe
	(:name cider :description "CIDER is a Clojure IDE and REPL." :type github :pkgname "clojure-emacs/cider" :depends
	       (seq queue clojure-mode pkg-info spinner)))
 (cl-lib status "installed" recipe
	 (:name cl-lib :builtin "24.3" :type elpa :description "Properly prefixed CL functions and macros" :url "http://elpa.gnu.org/packages/cl-lib.html"))
 (clojure-mode status "installed" recipe
	       (:name clojure-mode :website "https://github.com/clojure-emacs/clojure-mode" :description "Emacs support for the Clojure language." :type github :pkgname "clojure-emacs/clojure-mode"))
 (company-mode status "installed" recipe
	       (:name company-mode :website "http://company-mode.github.io/" :description "Modular in-buffer completion framework for Emacs" :type github :pkgname "company-mode/company-mode"))
 (cperl-mode status "installed" recipe
	     (:name cperl-mode :website "https://github.com/jrockway/cperl-mode" :description "Perl code editing commands for Emacs" :type github :pkgname "jrockway/cperl-mode" :depends mode-compile :compile "cperl-mode.el" :provide cperl-mode :post-init
		    (defalias 'perl-mode 'cperl-mode)))
 (dash status "installed" recipe
       (:name dash :description "A modern list api for Emacs. No 'cl required." :type github :pkgname "magnars/dash.el"))
 (deferred status "installed" recipe
   (:name deferred :description "Simple asynchronous functions for emacs lisp." :type github :pkgname "kiwanami/emacs-deferred"))
 (dtrt-indent status "installed" recipe
	      (:name dtrt-indent :description "A minor mode that guesses the indentation offset originally used for creating source code files and transparently adjusts the corresponding settings in Emacs." :type github :pkgname "jscheid/dtrt-indent" :features
		     (dtrt-indent)
		     :post-init
		     (dtrt-indent-mode 1)))
 (el-get status "installed" recipe
	 (:name el-get :website "https://github.com/dimitri/el-get#readme" :description "Manage the external elisp bits and pieces you depend upon." :type github :branch "master" :pkgname "dimitri/el-get" :info "." :compile
		("el-get.*\\.el$" "methods/")
		:features el-get :post-init
		(when
		    (memq 'el-get
			  (bound-and-true-p package-activated-list))
		  (message "Deleting melpa bootstrap el-get")
		  (unless package--initialized
		    (package-initialize t))
		  (when
		      (package-installed-p 'el-get)
		    (let
			((feats
			  (delete-dups
			   (el-get-package-features
			    (el-get-elpa-package-directory 'el-get)))))
		      (el-get-elpa-delete-package 'el-get)
		      (dolist
			  (feat feats)
			(unload-feature feat t))))
		  (require 'el-get))))
 (emacs-w3m status "installed" recipe
	    (:name emacs-w3m :description "A simple Emacs interface to w3m" :type cvs :website "http://emacs-w3m.namazu.org/" :module "emacs-w3m" :url ":pserver:anonymous@cvs.namazu.org:/storage/cvsroot" :build
		   `(("autoconf")
		     ("./configure" ,(format "--with-emacs=%s" el-get-emacs))
		     ("make"))
		   :build/windows-nt
		   (("sh" "./autogen.sh")
		    ("sh" "./configure")
		    ("make"))
		   :info "doc"))
 (emacs-ycmd status "installed" recipe
	     (:name emacs-ycmd :type git :url "https://github.com/abingham/emacs-ycmd"))
 (epl status "installed" recipe
      (:name epl :description "EPL provides a convenient high-level API for various package.el versions, and aims to overcome its most striking idiocies." :type github :pkgname "cask/epl"))
 (evil status "installed" recipe
       (:name evil :website "https://bitbucket.org/lyro/evil" :description "Evil is an extensible vi layer for Emacs. It\n       emulates the main features of Vim, and provides facilities\n       for writing custom extensions." :type hg :url "https://bitbucket.org/lyro/evil" :features evil :depends
	      (undo-tree goto-chg)
	      :build
	      (("make" "info" "all"))
	      :build/berkeley-unix
	      (("gmake" "info" "all"))
	      :build/darwin
	      `(("make" ,(format "EMACS=%s" el-get-emacs)
		 "info" "all"))
	      :info "doc"))
 (evil-leader status "installed" recipe
	      (:name evil-leader :website "http://github.com/cofi/evil-leader" :description "Add <leader> shortcuts to Evil, the extensible vim\n       emulation layer" :type github :pkgname "cofi/evil-leader" :features evil-leader :depends evil))
 (evil-matchit status "installed" recipe
	       (:name evil-matchit :type github :description "Vim matchit ported to Evil" :pkgname "redguardtoo/evil-matchit" :depends evil))
 (evil-nerd-commenter status "installed" recipe
		      (:name evil-nerd-commenter :website "http://github.com/redguardtoo/evil-nerd-commenter" :description "Comment/uncomment lines efficiently. Like Nerd Commenter in Vim" :type github :pkgname "redguardtoo/evil-nerd-commenter" :depends evil))
 (evil-numbers status "installed" recipe
	       (:name evil-numbers :website "http://github.com/cofi/evil-numbers" :description "Increment/decrement numbers in Evil, the extensible vim\n       emulation layer. Like C-a/C-x in vim.\n\n       After installation, you will need to add a key-binding for evil-numbers.\n       For example:\n\n       (define-key evil-normal-state-map (kbd \"C-c +\") 'evil-numbers/inc-at-pt)\n       (define-key evil-normal-state-map (kbd \"C-c -\") 'evil-numbers/dec-at-pt)" :type github :pkgname "cofi/evil-numbers" :features evil-numbers :depends evil))
 (evil-org-mode status "installed" recipe
		(:name evil-org-mode :type git :url "https://github.com/edwtjo/evil-org-mode"))
 (evil-surround status "installed" recipe
		(:name evil-surround :website "http://github.com/timcharper/evil-surround" :description "Emulate Tim Pope's surround.vim in evil, the extensible vim\n       emulation layer for emacs" :type github :pkgname "timcharper/evil-surround" :features evil-surround :post-init
		       (global-evil-surround-mode 1)
		       :depends evil))
 (f status "installed" recipe
    (:name f :website "https://github.com/rejeep/f.el" :description "Modern API for working with files and directories in Emacs" :depends
	   (s dash)
	   :type github :pkgname "rejeep/f.el"))
 (function-args status "installed" recipe
		(:name function-args :description "Shows C++ function arguments using Semantic" :type github :pkgname "abo-abo/function-args" :depends
		       (cedet swiper)))
 (ggtags status "installed" recipe
	 (:name ggtags :description "Use GNU Global in Emacs." :type github :pkgname "leoliu/ggtags"))
 (golden-ratio status "installed" recipe
	       (:name golden-ratio :description "Automatic resizing of Emacs windows to the golden ratio" :type github :pkgname "roman/golden-ratio.el"))
 (goto-chg status "installed" recipe
	   (:name goto-chg :description "Goto the point of the most recent edit in the buffer." :type emacswiki :features goto-chg))
 (helm status "installed" recipe
       (:name helm :description "Emacs incremental and narrowing framework" :type github :pkgname "emacs-helm/helm" :autoloads "helm-autoloads" :build
	      (("make"))
	      :build/darwin
	      `(("make" ,(format "EMACS_COMMAND=%s" el-get-emacs)))
	      :build/windows-nt
	      (let
		  ((generated-autoload-file
		    (expand-file-name "helm-autoloads.el"))
		   \
		   (backup-inhibited t))
	      (update-directory-autoloads default-directory)
	      nil)))
(helm-dash status "installed" recipe
(:name helm-dash :description "Browse Dash docsets inside emacs" :depends helm :type github :pkgname "areina/helm-dash"))
(helm-gtags status "installed" recipe
(:name helm-gtags :description "GNU GLOBAL Helm interface." :type github :pkgname "syohex/emacs-helm-gtags" :depends
(helm)))
(highlight-parentheses status "installed" recipe
(:name highlight-parentheses :description "Highlight the matching parentheses surrounding point." :type github :pkgname "nschum/highlight-parentheses.el"))
(history status "installed" recipe
(:name history :type git :url "https://github.com/boyw165/history"))
(indent-guide status "installed" recipe
(:name indent-guide :description "show vertical lines to guide indentation." :website "https://github.com/zk-phi/indent-guide" :type github :pkgname "zk-phi/indent-guide"))
(langtool status "installed" recipe
(:name langtool :description "Emacs frontend for LanguageTool (http://www.languagetool.org/)." :type github :pkgname "mhayashi1120/Emacs-langtool"))
(magit status "installed" recipe
(:name magit :after
(progn
(global-set-key
(kbd "C-x C-z")
'magit-status))
:website "https://github.com/magit/magit#readme" :description "It's Magit! An Emacs mode for Git." :type github :pkgname "magit/magit" :branch "master" :minimum-emacs-version "24.4" :depends
(dash)
:provide
(with-editor)
:info "Documentation" :load-path "lisp/" :compile "lisp/" :build
`(("make" ,(format "EMACSBIN=%s" el-get-emacs)
"docs")
("touch" "lisp/magit-autoloads.el"))
:build/berkeley-unix
`(("gmake" ,(format "EMACSBIN=%s" el-get-emacs)
"docs")
("touch" "lisp/magit-autoloads.el"))
:build/windows-nt
(with-temp-file "lisp/magit-autoloads.el" nil)))
(markdown-mode status "installed" recipe
(:name markdown-mode :description "Major mode to edit Markdown files in Emacs" :website "http://jblevins.org/projects/markdown-mode/" :type git :url "git://jblevins.org/git/markdown-mode.git" :prepare
(add-to-list 'auto-mode-alist
'("\\.\\(md\\|mdown\\|markdown\\)\\'" . markdown-mode))))
(mode-compile status "installed" recipe
(:name mode-compile :description "Smart command for compiling files according to major-mode." :type http :url "https://raw.github.com/emacsmirror/mode-compile/master/mode-compile.el" :load-path
(".")))
(molokai-theme status "installed" recipe
(:name molokai-theme :type git :url "https://github.com/hbin/molokai-theme"))
(monokai-emacs-theme status "installed" recipe
(:name monokai-emacs-theme :type git :url "https://github.com/oneKelvinSmith/monokai-emacs"))
(org-mode status "installed" recipe
(:name org-mode :after
(progn
(global-set-key
(kbd "C-c t")
'org-todo))
:website "http://orgmode.org/" :description "Org-mode is for keeping notes, maintaining ToDo lists, doing project planning, and authoring with a fast and effective plain-text system." :type git :url "git://orgmode.org/org-mode.git" :info "doc" :build/berkeley-unix `,(mapcar
(lambda
(target)
(list "gmake" target
(concat "EMACS="
(shell-quote-argument el-get-emacs))))
'("oldorg"))
:build `,(mapcar
(lambda
(target)
(list "make" target
(concat "EMACS="
(shell-quote-argument el-get-emacs))))
'("oldorg"))
:load-path
("." "contrib/lisp" "lisp")
:load
("lisp/org-loaddefs.el")))
(package status "installed" recipe
(:name package :description "ELPA implementation (\"package.el\") from Emacs 24" :builtin "24" :type http :url "http://repo.or.cz/w/emacs.git/blob_plain/ba08b24186711eaeb3748f3d1f23e2c2d9ed0d09:/lisp/emacs-lisp/package.el" :shallow nil :features package :post-init
(progn
(let
((old-package-user-dir
(expand-file-name
(convert-standard-filename
(concat
(file-name-as-directory default-directory)
"elpa")))))
(when
(file-directory-p old-package-user-dir)
(add-to-list 'package-directory-list old-package-user-dir)))
(setq package-archives
(bound-and-true-p package-archives))
(mapc
(lambda
(pa)
(add-to-list 'package-archives pa 'append))
'(("ELPA" . "http://tromey.com/elpa/")
("melpa" . "http://melpa.org/packages/")
("gnu" . "http://elpa.gnu.org/packages/")
("marmalade" . "http://marmalade-repo.org/packages/")
("SC" . "http://joseito.republika.pl/sunrise-commander/"))))))
(paredit status "installed" recipe
(:name paredit :description "Minor mode for editing parentheses" :type http :prepare
(progn
(autoload 'enable-paredit-mode "paredit")
(autoload 'disable-paredit-mode "paredit"))
:url "http://mumble.net/~campbell/emacs/paredit.el"))
(pkg-info status "installed" recipe
(:name pkg-info :description "Provide information about Emacs packages." :type github :pkgname "lunaryorn/pkg-info.el" :depends
(dash epl)))
(popup status "installed" recipe
(:name popup :website "https://github.com/auto-complete/popup-el" :description "Visual Popup Interface Library for Emacs" :type github :submodule nil :depends cl-lib :pkgname "auto-complete/popup-el"))
(projectile status "installed" recipe
(:name projectile :description "Project navigation and management library for Emacs." :type github :pkgname "bbatsov/projectile" :depends
(dash s f pkg-info)))
(queue status "installed" recipe
(:name queue :description "Queue data structure" :type elpa))
(s status "installed" recipe
(:name s :description "The long lost Emacs string manipulation library." :type github :pkgname "magnars/s.el"))
(semantic-refactor status "installed" recipe
(:name semantic-refactor :type git :url "https://github.com/tuhdo/semantic-refactor"))
(seq status "installed" recipe
(:name seq :description "Sequence manipulation library for Emacs" :builtin "25" :type github :pkgname "NicolasPetton/seq.el"))
(smex status "installed" recipe
(:name smex :after
(progn
(setq smex-save-file "~/.emacs.d/.smex-items")
(add-hook 'ido-setup-hook
(lambda nil
(define-key ido-completion-map
(kbd "C-h")
'delete-backward-char)
(define-key ido-completion-map
(kbd "C-n")
'ido-next-match)
(define-key ido-completion-map
(kbd "C-p")
'ido-prev-match)
(define-key ido-completion-map
(kbd "C-? f")
'smex-describe-function)
(define-key ido-completion-map
(kbd "C-? w")
'smex-where-is)))
(global-set-key
(kbd "M-x")
'smex)
(global-set-key
(kbd "M-X")
'smex-major-mode-commands))
:description "M-x interface with Ido-style fuzzy matching." :type github :pkgname "nonsequitur/smex" :features smex :post-init
(smex-initialize)))
(smooth-scroll status "installed" recipe
(:name smooth-scroll :description "Minor mode for smooth scrolling." :type emacswiki :features smooth-scroll))
(spinner status "installed" recipe
(:name spinner :description "Emacs mode-line spinner for operations in progress." :type github :pkgname "Bruce-Connor/spinner.el"))
(sr-speedbar status "installed" recipe
(:name sr-speedbar :type emacswiki :description "Same frame speedbar" :prepare
(global-set-key
(kbd "s-s")
'sr-speedbar-toggle)))
(swiper status "installed" recipe
(:name swiper :description "Gives you an overview as you search for a regex." :type github :pkgname "abo-abo/swiper"))
(uncrustify-mode status "installed" recipe
(:name uncrustify-mode :type git :url "https://github.com/koko1000ban/emacs-uncrustify-mode"))
(undo-tree status "installed" recipe
(:name undo-tree :description "Treat undo history as a tree" :website "http://www.dr-qubit.org/emacs.php" :type git :url "http://www.dr-qubit.org/git/undo-tree.git/"))
(yasnippet status "installed" recipe
(:name yasnippet :website "https://github.com/capitaomorte/yasnippet.git" :description "YASnippet is a template system for Emacs." :type github :pkgname "capitaomorte/yasnippet" :compile "yasnippet.el" :submodule nil :build
(("git" "submodule" "update" "--init" "--" "snippets")))))
