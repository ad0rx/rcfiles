(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-enabled-themes '(tsdh-dark))
 '(org-agenda-files
   '("~/.notes" "~/Documents/orgs/bus_defender.org" "~/Documents/orgs/personal.org" "~/Documents/orgs/mercury.org"))
 '(org-enforce-todo-dependencies t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Mono" :foundry "DAMA" :slant normal :weight normal :height 158 :width normal)))))

(put 'dired-find-alternate-file 'disabled nil)
(setq inhibit-startup-message t)

(setq default-buffer-file-coding-system 'utf-8-unix)

;; Use spaces for indentation and no TAB characters
(setq-default indent-tabs-mode nil)

;; Add more space between lines
(setq-default line-spacing 6)

;; Improve org mode looks
;; (setq org-startup-indented t)

;; Add refile targets for capture mode to include org-agenda-files
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

;; Global keys for org flows
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; Tuning the refile command
(setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps t)

;; Configure State Kewords
;; C-c C-t t would set to TODO using
;; 'Fast Access to TODO States'
(setq org-todo-keywords
      '(
        (sequence "TODO(t)" "WAITING" "NEXT" "|" "DONE(d)")
        (sequence "REPORT(r)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f)")
        (sequence "|" "CANCELED(c)")
        ))

;; Cleanup whitespace before saving buffer
(add-hook 'before-save-hook 'whitespace-cleanup)

;; Auto fill mode for text buffers
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Line and column numbers
;;(global-linum-mode)
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

;; Support for pstart
;; Mapping function to add tramp / plink to notes file path
(defun add_plink_url (s)
  "Add URL to the front of string, used to open files on remote host"
  (print (concat "/plink:bwhitlock@plap#65534:" s))
  )

;; Open Notes on Plap
(defun pstart ()
  "Open Org Files and Agenda for work"
  (interactive)

  ;; List of notes files
  ;; The last element will be displayed in right pane
  (setq l_notes_files (list "~/Documents/orgs/personal.org"
                            "~/Documents/docker/docker.org"
                            "~/.notes"
                            "~/Documents/orgs/bus_defender.org"
                            "~/Documents/orgs/peraton.org"
                            "~/Documents/orgs/mercury.org"))

  ;; If we are on a windows machine, add plink / tramp support to file URL
  (cond
   ((string-equal system-name "latitude")
    (progn
      ))
   (t
    (progn

      ;; modify each entry in the list to have
      ;; '/plink:bwhitlock@plap#65534:' preceding the file name
      (setq l_notes_files (mapcar 'add_plink_url l_notes_files))
      )))

  (setq org-agenda-files l_notes_files)

  ;; Create buffers
  (setq l_buffers '())
  (dolist (elt l_notes_files)
    (push (find-file-noselect elt) l_buffers)
    )
  (print l_buffers)
  (org-agenda-list)
  (setq agendab (get-buffer (current-buffer)))
  (delete-window nil)

  ;; Create two windows side by side, how to name them?
  (setq leftWindow (selected-window))
  (split-window nil nil 'right)
  (setq rightWindow (window-in-direction 'right))

  ;; Place desired buffers in desired window
  (set-window-buffer leftWindow agendab)
  (set-window-buffer rightWindow (car l_buffers))

  ;;(toggle-frame-fullscreen)
  (toggle-frame-maximized)
  )

;; Verilog Mode Tweaks
(setq verilog-auto-newline nil)
(defun verilog-indent-untabify ()
  "Run Verilog batch indent on the buffer and remove TABS"
  (verilog-indent-buffer)
  (untabify (point-min) (point-max))
  )

(add-hook 'verilog-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'verilog-indent-untabify nil 'local)))
;; End Verilog Mode Tweaks


(add-to-list 'default-frame-alist '(height . 24))
(add-to-list 'default-frame-alist '(width . 80))

;; Auto git commit when save org buffer ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun org-is-scrum ()
 (setq s "scrum")
 (setq b (buffer-file-name))
 (if (eql nil (string-match s b))
    f
    t)
)

(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'after-save-hook
                      (lambda ()
                        (save-excursion
                          (unless (org-is-scrum)
                            (call-process-shell-command "make -k"))
                          )) nil 't)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
