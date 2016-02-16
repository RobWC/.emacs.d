;; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; If you want to create a file, visit that file with C-x C-f,
;; then enter the text in that file's own buffer.
(require 'json)

(defun get-data (champ-name)
  (url-retrieve-synchronously  (format "http://ddragon.leagueoflegends.com/cdn/6.2.1/data/en_US/champion/%s.json" champ-name))
  )

(with-current-buffer (get-data "Braum"))
