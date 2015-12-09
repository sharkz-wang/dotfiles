;;; sb-sankei.el --- shimbun backend for the Sankei News -*- coding: iso-2022-7bit; -*-

;; Copyright (C) 2003-2011, 2013-2015 Katsumi Yamaoka

;; Author: Katsumi Yamaoka <yamaoka@jpl.org>
;; Keywords: news

;; This file is a part of shimbun.

;; This program is free software: you can redistribute it and/or modify
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

;;; Code:

(require 'sb-multi)

(luna-define-class shimbun-sankei
		   (shimbun-japanese-newspaper shimbun-multi shimbun)
		   ())

(defvar shimbun-sankei-url "http://www.sankei.com/")

(defvar shimbun-sankei-top-level-domain "www.sankei.com")

(defvar shimbun-sankei-server-name "$B;:7P%K%e!<%9(B")

(defvar shimbun-sankei-group-table
  '(("top" "$B%K%e!<%9(B"
     "http://www.sankei.com/")
    ("flash" "$BB.Js(B"
     "http://www.sankei.com/flash/newslist/flash-n1.html")
    ("affairs" "$B;v7o(B"
     "http://www.sankei.com/affairs/newslist/affairs-n1.html")
    ("politics" "$B@/<#(B"
     "http://www.sankei.com/politics/newslist/politics-n1.html")
    ("world" "$B9q:](B"
     "http://www.sankei.com/world/newslist/world-n1.html")
    ("economy" "$B7P:Q(B"
     "http://www.sankei.com/economy/newslist/economy-n1.html")
    ("column" "$B%3%i%`(B"
     "http://www.sankei.com/column/newslist/column-n1.html")
    ("column.sankeisyo" "$B;:7P>6(B"
     "http://www.sankei.com/column/newslist/sankeisyo-n1.html")
    ("column.editorial" "$B<gD%(B"
     "http://www.sankei.com/column/newslist/editorial-n1.html")
    ("column.seiron" "$B@5O@(B"
     "http://www.sankei.com/column/newslist/seiron-n1.html")
    ("sports" "$B%9%]!<%D(B"
     "http://www.sankei.com/sports/newslist/sports-n1.html")
    ("entertainments" "$B%(%s%?%a(B"
     "http://www.sankei.com/entertainments/newslist/entertainments-n1.html")
    ("life" "$B%i%$%U(B"
     "http://www.sankei.com/life/newslist/life-n1.html")
    ("region.hokkaido-tohoku" "$BKL3$F;ElKL(B"
     "http://www.sankei.com/region/newslist/tohoku-n1.html")
    ("region.kanto" "$B4XEl(B"
     "http://www.sankei.com/region/newslist/kanto-n1.html")
    ("region.chubu" "$BCfIt(B"
     "http://www.sankei.com/region/newslist/chubu-n1.html")
    ("region.kinki" "$B6a5&(B"
     "http://www.sankei.com/region/newslist/kinki-n1.html")
    ("region.chugoku-shikoku" "$BCf9q;M9q(B"
     "http://www.sankei.com/region/newslist/chushikoku-n1.html")
    ("region.kyushu-okinawa" "$B6e=#2-Fl(B"
     "http://www.sankei.com/region/newslist/kyushu-n1.html")
    ("west.flash" "$B4X@>B.Js(B"
     "http://www.sankei.com/west/newslist/west-n1.html")
    ("west.affairs" "$B4X@>$G$-$4$H(B"
     "http://www.sankei.com/west/newslist/west_affairs-n1.html")
    ("west.sports" "$B4X@>%9%]!<%D(B"
     "http://www.sankei.com/west/newslist/west_sports-n1.html")
    ("west.life" "$B4X@>%i%$%U(B"
     "http://www.sankei.com/west/newslist/west_life-n1.html")
    ("west.economy" "$B4X@>7P:Q(B"
     "http://www.sankei.com/west/newslist/west_economy-n1.html")))

(defvar shimbun-sankei-category-name-alist
  '(("afr" . "$B;v7o(B") ("clm" . "$B%3%i%`(B") ("ecn" . "$B7P:Q(B") ("ent" . "$B%(%s%?%a(B")
    ("etc" . "$B$=$NB>(B") ("gqj" . "GQ JAPAN") ("lif" . "$B%i%$%U(B") ("plt" . "$B@/<#(B")
    ("prm" . "$B%W%l%_%"%`(B") ("spo" . "$B%9%]!<%D(B") ("wor" . "$B9q:](B")
    ("wst" . "$B4X@>(B"))
  "Alist used to convert author's name in the top and the flash groups.")

(defvar shimbun-sankei-x-face-alist
  ;; Faces used for the light background display.
  '(("default" . "\
Face: iVBORw0KGgoAAAANSUhEUgAAABsAAAAbBAMAAAB/+ulmAAAAD1BMVEX8/PwAAAD///+G
 d3j/AADv136FAAAAAXRSTlMAQObYZgAAAKtJREFUGNNNkN0VAiAIhfW4QMgEXhpAtA1y/5kS0
 IoHD59w+UvJLD/StdlT0n4p834o/NJTMeRA6hHhXwXTBbrEsmnOcOyzKBFxP92UWIcon26Z0S
 qgtzxBBtCiea4KMyVP1uEEEi9F232tIQwXMyBrvWVCfQoLrmVqwxpotfsvetC0zz/UwKP1vh4
 ExVTNh4ScBVvM1e6C1UjO/fZKxnpvXYjnJP5efucf+gA+DB8q52OUwwAAAABJRU5ErkJggg=="))
;;  ;; Faces used for the dark background display.
;;  '(("default" . "\
;;Face: iVBORw0KGgoAAAANSUhEUgAAABsAAAAbAgMAAADwuhzGAAAADFBMVEUAAAD///95
;; iIf/AACrdmo+AAAAAXRSTlMAQObYZgAAAJ9JREFUCNcdjzEOwjAMRb8jJZJhYEGcoKoQC
;; 0cgjGyASNWxI9zC4g5FnKGX4FqdgO9ESp4s5/9vA5AMnoWpOTeIfLdokcieVapf1Ei2wh
;; AnNoHrWO5rcnw8X28XStaBLMHkTMkJ0J6XrrFx6XJuaZGw/+4UtPj8QDakidXamXCoVNL
;; 7aqvZc+UYrOZeaFhzMwJzEG9Q3yB0U+cLQAvH+AOYXSEFLdF2GAAAAABJRU5ErkJggg=="))
  )

(defvar shimbun-sankei-expiration-days 7)

(luna-define-method shimbun-groups ((shimbun shimbun-sankei))
  (mapcar 'car shimbun-sankei-group-table))

(luna-define-method shimbun-current-group-name ((shimbun shimbun-sankei))
  (nth 1 (assoc (shimbun-current-group-internal shimbun)
		shimbun-sankei-group-table)))

(luna-define-method shimbun-index-url ((shimbun shimbun-sankei))
  (nth 2 (assoc (shimbun-current-group-internal shimbun)
		shimbun-sankei-group-table)))

(defvar shimbun-sankei-retry-fetching 1)

(luna-define-method shimbun-get-headers :around ((shimbun shimbun-sankei)
						 &optional range)
  (let ((group (shimbun-current-group-internal shimbun)))
    (cond ((string-equal "top" group)
	   (shimbun-sankei-get-headers-top shimbun range))
	  (t
	   (shimbun-sankei-get-headers shimbun range group)))))

(defun shimbun-sankei-get-headers (shimbun range group)
  "Get headers for a categorized group."
  (let ((regexp
	 (eval-when-compile
	   (concat
	    "<li>[\t\n ]*<a[\t\n ]+href=\""
	    ;; 1. url
	    "\\(\\(?:[^\"/]*/\\)+"
	    ;; 2. year (lower 2 digits)
	    "\\([1-9][0-9]\\)"
	    ;; 3. month
	    "\\([01][0-9]\\)"
	    ;; 4. day
	    "\\([0-3][0-9]\\)"
	    "/\\(?:[^\"/]+/\\)*"
	    ;; 5. category
	    "\\([a-z]+\\)"
	    ;; 6. serial number
	    "\\([^\"/]+\\)"
	    "-n[0-9]+\\.html\\)" ;; 1. url
	    "\">[\t\n ]*"
	    ;; 7. subject
	    "\\(\\(?:[^\t\n <]+[\t\n ]\\)*[^\t\n <]+\\)")))
	(maxyear (1+ (nth 5 (decode-time))))
	(rgrp (mapconcat 'identity (nreverse (split-string group "\\.")) "."))
	(index (shimbun-index-url shimbun))
	done st nd url year month day category id subj old time from headers)
    (while (not done)
      (if (re-search-forward regexp nil t)
	  (progn
	    (setq st (match-beginning 0)
		  nd (match-end 0)
		  url (match-string 1)
		  year (match-string 2)
		  month (match-string 3)
		  day (match-string 4)
		  category (match-string 5)
		  id (concat "<" category (match-string 6) "." rgrp "%"
			     shimbun-sankei-top-level-domain ">")
		  subj (match-string 7))
	    (if (shimbun-search-id shimbun id)
		(setq old t)
	      (goto-char st)
	      (setq time nil)
	      (if (shimbun-end-of-tag "li")
		  (progn
		    (goto-char nd)
		    (if (re-search-forward "\
<time>[\t\n ]*20[1-9][0-9]\\.[01]?[0-9]\\.[0-3]?[0-9][\t\n ]+\
\\([0-2][0-9]:[0-5][0-9]\\)[\t\n ]*</time>" (match-end 2) t)
			(setq time (match-string 1))
		      (goto-char (match-end 0)))
		    (goto-char nd)))
	      (setq from
		    (concat
		     (shimbun-server-name shimbun)
		     " ("
		     (or (and (string-equal "flash" group)
			      (cdr (assoc category
					  shimbun-sankei-category-name-alist)))
			 (shimbun-current-group-name shimbun))
		     ")"))
	      (push (shimbun-create-header
		     0 subj from
		     (shimbun-make-date-string
		      (min (+ 2000 (string-to-number year)) maxyear)
		      (string-to-number month)
		      (string-to-number day)
		      time)
		     id "" 0 0
		     (shimbun-expand-url url index))
		    headers)))
	(if (and (not old)
		 (re-search-forward
		  "<a[\t\n ]+href=\"\\([^\"]+\\)\"[\t\n ]+class=\"pageNext\""
		  nil t))
	    (shimbun-retrieve-url (shimbun-expand-url
				   (prog1
				       (or (match-string 1) (match-string 2))
				     (erase-buffer))
				   index))
	  (setq done t))))
    headers))

(defun shimbun-sankei-get-headers-top-1 (shimbun)
  "Return a header object after the point.
This is a subroutine that `shimbun-sankei-get-headers-top' uses."
  (let ((regexp
	 (eval-when-compile
	   (concat
	    "<a[\t\n ]+href=\""
	    ;; 1. url
	    "\\(\\(?:[^\"/]*/\\)+"
	    ;; 2. year (lower 2 digits)
	    "\\([1-9][0-9]\\)"
	    ;; 3. month
	    "\\([01][0-9]\\)"
	    ;; 4. day
	    "\\([0-3][0-9]\\)"
	    "/\\(?:[^\"/]+/\\)*"
	    ;; 5. category
	    "\\([a-z]+\\)"
	    ;; 6. serial number
	    "\\([^\"/]+\\)"
	    "-n[0-9]+\\.html\\)" ;; 1. url
	    "\">[\t\n ]*"
	    ;; 7. subject
	    "\\(\\(?:[^\t\n <]+[\t\n ]\\)*[^\t\n <]+\\)")))
	(maxyear (1+ (nth 5 (decode-time))))
	(index (shimbun-index-url shimbun))
	category id url year month day subj time from)
    (when (re-search-forward regexp nil t)
      (setq category (match-string 5)
	    id (concat "<" category (match-string 6) ".top%"
		       shimbun-sankei-top-level-domain ">"))
      (unless (shimbun-search-id shimbun id)
	(setq url (match-string 1)
	      year (min (+ 2000 (string-to-number (match-string 2))) maxyear)
	      month (string-to-number (match-string 3))
	      day (string-to-number (match-string 4))
	      subj (match-string 7))
	(goto-char (point-min))
	(when (re-search-forward "\
<time>[\t\n ]*\\([012]?[0-9]:[0-5]?[0-9]\\)[\t\n ]*</time>" nil t)
	  (setq time (match-string 1)))
	(setq from
	      (concat
	       (shimbun-server-name shimbun)
	       " ("
	       (or (cdr (assoc category
			       shimbun-sankei-category-name-alist))
		   (shimbun-current-group-name shimbun))
	       ")"))
	(shimbun-create-header
	 0 subj from
	 (shimbun-make-date-string year month day time)
	 id "" 0 0
	 (shimbun-expand-url url index))))))

(defun shimbun-sankei-get-headers-top (shimbun range)
  "Get headers for the `top' group."
  (let (header headers)
    ;; Top news
    (when (and (search-forward "<article>" nil t)
	       (shimbun-end-of-tag "article"))
      (save-restriction
	(narrow-to-region (goto-char (match-beginning 2)) (match-end 2))
	(when (setq header (shimbun-sankei-get-headers-top-1 shimbun))
	  (push header headers))
	(goto-char (point-max))))
    ;; Others
    (while (and (re-search-forward "\
<section[\t\n ]+\\(?:[^\t\n >]+[\t\n ]+\\)*\\(?:class\\|id\\)=\"mod" nil t)
		(shimbun-end-of-tag "section"))
      (save-restriction
	(narrow-to-region (goto-char (match-beginning 2)) (match-end 2))
	(when (and (search-forward "<ul>" nil t)
		   (shimbun-end-of-tag "ul"))
	  (save-restriction
	    (narrow-to-region (goto-char (match-beginning 2)) (match-end 2))
	    (while (and (search-forward "<li>" nil t)
			(shimbun-end-of-tag "li"))
	      (save-restriction
		(narrow-to-region (goto-char (match-beginning 2)) (match-end 2))
		(when (setq header (shimbun-sankei-get-headers-top-1 shimbun))
		  (push header headers))))))
	(goto-char (point-max))))
    (shimbun-sort-headers headers)))

(luna-define-method shimbun-multi-next-url ((shimbun shimbun-sankei)
					    header url)
  (shimbun-sankei-multi-next-url shimbun header url))

(defun shimbun-sankei-multi-next-url (shimbun header url)
  (prog1
      (when (re-search-forward
	     "<a[\t\n ]+href=\"\\([^\"]+\\)\"[\t\n ]+class=\"pageNext\""
	     nil t)
	(let ((next (or (match-string 1) (match-string 2))))
	  (unless (string-match "/more\\.html\\'" next)
	    (shimbun-expand-url next url))))
    (goto-char (point-min))))

(luna-define-method shimbun-clear-contents :around ((shimbun shimbun-sankei)
						    header)
  (shimbun-sankei-clear-contents shimbun header))

(defun shimbun-sankei-clear-contents (shimbun header)
  ;; Update Date header.
  (when (re-search-forward "\
<!-+[\t\n ]*date[\t\n ]*-+>\\(?:[\t\n ]*<[^>]*>\\)*[\t\n ]*\
\\(20[1-9][0-9]\\)\\.\\([01]?[0-9]\\)\\.\\([0-3]?[0-9]\\)[\t\n ]+\
\\([012]?[0-9]:[0-5]?[0-9]\\)\
\\(?:[\t\n ]*<[^>]*>\\)*[\t\n ]*<!-+[\t\n ]*date[\t\n ]+end[\t\n ]*-+>"
			    nil t)
    (shimbun-header-set-date
     header
     (shimbun-make-date-string
      (string-to-number (match-string 1))
      (string-to-number (match-string 2))
      (string-to-number (match-string 3))
      (match-string 4))))
  ;; Delete useless contents.
  (let (case-fold-search st)
    (goto-char (point-min))
    (while (re-search-forward "[\t\n ]*<!-+[\t\n ]+\
\\([Aa][Dd][\t\n ]+[^\t\n >]+\\(?:[\t\n ]+[^\t\n >]+\\)*\\)[\t\n ]*-+>[\t\n ]*"
			      nil t)
      (setq st (match-beginning 0))
      (when (re-search-forward
	     (concat "[\t\n ]*<!-+[\t\n ]+"
		     (regexp-quote (match-string 1))
		     "[\t\n ]*-+>[\t\n ]*")
	     nil t)
	(delete-region st (match-end 0))
	(insert "\n")))
    (goto-char (point-min))
    (while (re-search-forward "[\t\n ]*<!-+[\t\n ]+[Bb][Ee][Gg][Ii][Nn][\t\n ]+\
\\([Aa][Dd][\t\n ]+[^\t\n >]+\\(?:[\t\n ]+[^\t\n >]+\\)*\\)[\t\n ]*-+>[\t\n ]*"
			      nil t)
      (setq st (match-beginning 0))
      (when (re-search-forward
	     (concat "[\t\n ]*<!-+[\t\n ]+[Ee][Nn][Dd][\t\n ]+"
		     (regexp-quote (match-string 1))
		     "[\t\n ]*-+>[\t\n ]*")
	     nil t)
	(delete-region st (match-end 0))
	(insert "\n"))))
  (goto-char (point-min))
  (when (or (and (or (re-search-forward "\
<li[\t\n ]+\\(?:[^\t\n >]+[\t\n ]+\\)*class=\"boxGp\"" nil t)
		     (re-search-forward "\
<li[\t\n ]+\\(?:[^\t\n >]+[\t\n ]+\\)*class=\"boxFb\"" nil t)
		     (re-search-forward "\
<li[\t\n ]+\\(?:[^\t\n >]+[\t\n ]+\\)*class=\"boxTw\"" nil t))
		 (shimbun-end-of-tag "li" t)
		 (progn
		   (when (re-search-forward "\
<span[\t\n ]+\\(?:[^\t\n >]+[\t\n ]+\\)*class=\"pageProperty\"" nil t)
		     (shimbun-end-of-tag "span"))
		   t))
	    ;; Old articles
	    (and (re-search-forward "\
<span[\t\n ]+\\(?:[^\t\n >]+[\t\n ]+\\)*class=\"pageProperty\"" nil t)
		 (shimbun-end-of-tag "span"))
	    (re-search-forward "<!-+[\t\n ]*article[\t\n ]*-+>" nil t))
    (re-search-forward "\\(?:[\t\n ]*<[!/][^>]+>\\)*[\t\n ]*" nil t)
    (delete-region (point-min) (point))
    (when (re-search-forward "[\t\n ]*</article>" nil t)
      (delete-region (match-beginning 0) (point-max))
      (insert "\n")))
  (unless (memq (shimbun-japanese-hankaku shimbun) '(header subject nil))
    (shimbun-japanese-hankaku-buffer t))
  t)

(luna-define-method shimbun-footer :around ((shimbun shimbun-sankei)
					    header &optional html)
  (concat "<div align=\"left\">\n--&nbsp;<br>\n\
$B$3$N5-;v$NCx:n8"$O;:7P?7J9<R$K5"B0$7$^$9!#%*%j%8%J%k$O$3$A$i!'(B<br>\n\
<a href=\""
	  (shimbun-article-base-url shimbun header) "\">&lt;"
	  (shimbun-article-base-url shimbun header) "&gt;</a>\n</div>\n"))

(provide 'sb-sankei)

;;; sb-sankei.el ends here
