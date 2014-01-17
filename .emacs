(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(setq molokai-theme-kit t)
(load-theme 'molokai t)

;;
;; ace jump mode major function
;; 
(add-to-list 'load-path "~/.emacs.d/")
(autoload
	'ace-jump-mode
	"ace-jump-mode"
	"Emacs quick move minor mode"
	t)
;; you can select the key you prefer to
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;; 
;; enable a more powerful jump back function from ace jump mode
;;
(autoload
	'ace-jump-mode-pop-mark
	"ace-jump-mode"
	"Ace jump back:-)"
	t)
(eval-after-load "ace-jump-mode"
	'(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

(require 'linum)
