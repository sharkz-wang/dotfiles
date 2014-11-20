;;; molokai-theme.el --- Yet another molokai theme for Emacs 24

;; Copyright (C) 2013 Huang Bin

;; Author: Huang Bin <embrace.hbin@gmail.com>
;; URL: https://github.com/hbin/molokai-theme
;; Version: 0.8

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; This is another molokai dark theme for Emacs 24.
;; Equiped with my favorites.

;;; Requirements:
;;
;; Emacs 24

;;; Code:
(deftheme molokai "The molokai color theme for Emacs 24")

(let ((class '((class color) (min-colors 89)))
      ;; molokai palette
      (molokai-white          "#d0d0d0")
      (molokai-red            "#d7005f")
      (molokai-darkwine       "#d7005f")
      (molokai-wine           "#d7005f")
      (molokai-maroon         "#d7005f")
      (molokai-pink           "#d7005f")
      (molokai-orange         "#ff8700")
      (molokai-orange+5       "#ff8700")
      (molokai-darkgoldenrod  "#ff8700")
      (molokai-wheat          "#afaf87")
      (molokai-yellow         "#afaf87")
      (molokai-green          "#87ff00")
      (molokai-chartreuse     "#87ff00")
      (molokai-lime           "#87ff00")
      (molokai-olive          "#87ff00")
      (molokai-aqua           "#5fd7ff")
      (molokai-teal           "#5fd7ff")
      (molokai-blue           "#5fd7ff")
      (molokai-slateblue      "#5fd7ff")
      (molokai-dodgerblue     "#5fd7ff")
      (molokai-purple         "#af5fff")
      (molokai-palevioletred  "#af5fff")
      (molokai-grey-2         "#bcbcbc")
      (molokai-grey-1         "#8f8f8f")
      (molokai-grey           "#808080")
      (molokai-grey+2         "#403d3d")
      (molokai-grey+3         "#4c4745")
      (molokai-grey+5         "#232526")
      (molokai-grey+10        "#585858")
      (molokai-dark           "#000000")

      ;; Not configured yet
      (molokai-fg             "#f8f8f0")
      (molokai-bg             "#1b1d1e")

      (molokai-base01         "#465457")
      (molokai-base02         "#455354")
      (molokai-base03         "#293739"))
  (custom-theme-set-faces
   'molokai

   ;; base
   `(default ((t (:background ,molokai-bg :foreground ,molokai-fg :weight bold))))
   `(cursor ((t (:background ,molokai-fg :foreground ,molokai-bg :weight bold))))
   `(fringe ((t (:foreground ,molokai-base02 :weight bold :background ,molokai-bg))))
   `(highlight ((t (:background ,molokai-grey))))
   `(region ((t (:background  ,molokai-grey+2))
             (t :inverse-video t)))
   `(warning ((t (:foreground ,molokai-palevioletred :weight bold))))

   ;; font lock
   `(font-lock-builtin-face ((t (:foreground ,molokai-chartreuse :weight bold))))
   `(font-lock-comment-face ((t (:foreground ,molokai-base01 :weight bold))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,molokai-base01 :weight bold))))
   `(font-lock-constant-face ((t (:foreground ,molokai-purple :weight bold))))
   `(font-lock-doc-string-face ((t (:foreground ,molokai-darkgoldenrod :weight bold))))
   `(font-lock-function-name-face ((t (:foreground ,molokai-chartreuse :weight bold))))
   `(font-lock-keyword-face ((t (:foreground ,molokai-pink :weight bold))))
   `(font-lock-negation-char-face ((t (:foreground ,molokai-wine :weight bold))))
   `(font-lock-preprocessor-face ((t (:inherit (font-lock-builtin-face)))))
   `(font-lock-regexp-grouping-backslash ((t (:inherit (bold)))))
   `(font-lock-regexp-grouping-construct ((t (:inherit (bold)))))
   `(font-lock-string-face ((t (:foreground ,molokai-darkgoldenrod :weight bold))))
   `(font-lock-type-face ((t (:foreground ,molokai-blue :weight bold))))
   `(font-lock-variable-name-face ((t (:foreground ,molokai-orange :weight bold))))
   `(font-lock-warning-face ((t (:foreground ,molokai-palevioletred :weight bold))))

   ;; mode line
   `(mode-line ((t (:foreground ,molokai-fg :weight bold
                                :background ,molokai-base03
                                :box nil))))
   `(mode-line-buffer-id ((t (:weight bold))))
   `(mode-line-inactive ((t (:foreground ,molokai-fg :weight bold
                                         :background ,molokai-base02
                                         :box nil))))

   ;; search
   `(isearch ((t (:foreground ,molokai-dark :weight bold :background ,molokai-wheat :weight bold))))
   `(isearch-fail ((t (:foreground ,molokai-wine :weight bold :background ,molokai-darkwine))))

   ;; linum-mode
   `(linum ((t (:foreground ,molokai-grey-2 :weight bold :background ,molokai-grey+5))))

   ;; hl-line-mode
   `(hl-line-face ((,class (:background ,molokai-grey+5)) (t :weight bold)))
   `(hl-line ((,class (:background ,molokai-grey+5)) (t :weight bold)))

   ;; TODO
   ;; ido-mode
   ;; flycheck
   ;; show-paren
   ;; rainbow-delimiters
   ;; highlight-symbols
   ))

(defcustom molokai-theme-kit nil
  "Non-nil means load molokai-theme-kit UI component"
  :type 'boolean
  :group 'molokai-theme)

(defcustom molokai-theme-kit-file
  (concat (file-name-directory
           (or (buffer-file-name) load-file-name))
          "molokai-theme-kit.el")
  "molokai-theme-kit-file"
  :type 'string
  :group 'molokai-theme)

(if (and molokai-theme-kit
         (file-exists-p molokai-theme-kit-file))
    (load-file molokai-theme-kit-file))

;;;###autoload
(and load-file-name
     (boundp 'custom-theme-load-path)
     (add-to-list 'custom-theme-load-path
                  (file-name-as-directory
                   (file-name-directory load-file-name))))

(provide-theme 'molokai)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; molokai-theme.el ends here
