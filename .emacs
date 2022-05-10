(put 'dired-find-alternate-file 'disabled nil)
(setq inhibit-startup-message t)
(setq default-buffer-file-coding-system 'utf-8-unix)

;; Use spaces for indentation and no TAB characters
(setq-default indent-tabs-mode nil)

;; Add more space between lines
(setq-default line-spacing 6)

;; Improve org mode looks
(setq org-startup-indented t)

;; Cleanup whitespace before saving buffer
(add-hook 'before-save-hook 'whitespace-cleanup)

;; Auto fill mode for text buffers
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Line and column numbers
(global-linum-mode)
(setq column-number-mode t)

;; Put backup files in a sane place
(cond
 ((string-equal system-type "windows-nt")
  (progn

    ;; Get the USERPROFILE Env Variable and use that for path to
    ;; emacs backups
    (setq user-profile (getenv "USERPROFILE"))
    (setq backups-path (concat user-profile "\\.emacs.d\\backups"))
    (setq backups-path (expand-file-name backups-path))
    (make-directory backups-path t)
    (setq backup-directory-alist (list (cons "." backups-path )) )

    ;; Auto save location
    (setq auto-saves (concat user-profile "\\.emacs.d\\auto-saves\\"))
    (setq auto-saves (expand-file-name auto-saves))
    (make-directory auto-saves t)
    (setq auto-save-file-name-transforms
          `((".*" , auto-saves t)))

    ))
 (t
  (progn
    (setq backup-directory-alist `(("." . "~/.emacs.d/backups/"))))))

;; Beginnings of align-to-char reimplementation
(defun align-to-str (s)
  "Align occurances of String to the same column in region"
  (interactive "sString: ")

  ;; Save current point, auto-restored after inner forms exec
  (save-excursion
  (setq max-column 0)
  (setq l-points (list))

  ;; Determine if string exists on current line
  (while (setq doline (search-forward s (line-end-position) t))

    ;; Move point to beginning of str
    (search-backward s)

    ;; Push this point onto list
    (push (point) l-points)

    ;; Track max-column
    (setq l-current-column (current-column))
    (if (> l-current-column max-column)
        (setq max-column l-current-column)
      nil
      )

    (forward-line)

    )

  (while l-points

    ;; move to position
    (goto-char (car l-points))

    ;; insert spaces
    (insert-char ?\s (- max-column (current-column)))

    ;; Set l-points to remaining points
    (setq l-points (cdr l-points)))

  ) ;; end save excursion
  )

;; Flyspell Support from exwinports
;; https://sourceforge.net/projects/ezwinports/files/hunspell-1.3.2-3-w32-bin.zip/
;;(setq ispell-program-name "C:/hunspell/bin/hunspell.exe")

;; Open Notes on Plap
(defun pstart ()
  "Open Org Files and Agenda for work"
  (interactive)

  (setq notes.busDefender "/plink:bwhitlock@plap#65534:~/bus_defender/notes.org")
  (setq notes.peraton     "/plink:bwhitlock@plap#65534:~/notes.org")
  (setq org-agenda-files (list notes.busDefender notes.peraton))

  ;; Create buffers
  (setq notes.busDefenderb (find-file-noselect notes.busDefender))
  (setq notes.peratonb     (find-file-noselect notes.peraton))
  (org-agenda-list)
  (setq agendab (get-buffer (current-buffer)))
  (delete-window nil)

  ;; Create two windows side by side, how to name them?
  (setq leftWindow (selected-window))
  (split-window nil nil 'right)
  (setq rightWindow (window-in-direction 'right))

  ;; Place desired buffers in desired window
  (set-window-buffer leftWindow agendab)
  (set-window-buffer rightWindow notes.busDefenderb)

  ;;(toggle-frame-fullscreen)
  (toggle-frame-maximized)
  )
