(put 'dired-find-alternate-file 'disabled nil)
(setq inhibit-startup-message t)

(setq default-buffer-file-coding-system 'utf-8-unix)

;; Change TABS to 2 spaces everywhere
(global-set-key "\t" (lambda () (interactive) (insert-char 32 2)))
