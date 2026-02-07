;; Package Management
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)  ;; auto-install packages

;; Doom themes
(use-package doom-themes)
(load-theme 'doom-material-dark t)

;; UI Settings
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq ring-bell-function 'ignore)

;; Handle temporary files
(setq auto-save-default nil)   ;; Disable auto-saving
(setq make-backup-files nil)   ;; Disable backup~ files
(setq create-lockfiles nil)    ;; Disable .#lock files

;; Something Performace Wise via ChatGPT
(setq gc-cons-threshold (* 50 1000 1000))
(add-hook 'emacs-startup-hook (lambda () (setq gc-cons-threshold (* 2 1000 1000))))

;; Other Useful settings
(ido-mode 1)
(ido-everywhere 1)
(show-paren-mode 1)
(save-place-mode 1)          ;; Remember cursor positions in files
(global-auto-revert-mode 1)  ;; if file changes on disk reload its buffer

;; Line Numbers
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

;; Set Theme
;;(load-theme 'wombat t)

;; Set Font
(set-face-attribute 'default nil :font "Iosevka ExtraLight Extended" :height 115)







(setq org-hide-emphasis-markers t)
(setq org-startup-folded 'overview)
(setq org-confirm-babel-evaluate nil)

(setq org-src-window-setup 'current-window)
(setq org-src-preserve-indentation t)
(setq org-edit-src-content-indentation 0)
(setq org-ellipsis " ▼ ")

(setq org-indent-indentation-per-level 3)
(add-hook 'org-mode-hook 'org-indent-mode)

(use-package org-modern
  :hook (org-mode . org-modern-mode)
  :custom
  ;; Headings & Lists
  (org-modern-star '("◉" "○" "◆" "◇" "▶" "▷"))
  (org-modern-list '((?- . "•") (?+ . "‣") (?* . "⁃")))
  ;; Checkboxes
  (org-modern-checkbox
   '((?X . "🟩") (?- . "▢") (?\s . "⬜")))
  ;; Tables & blocks
  (org-modern-table-vertical 1)
  (org-modern-table-horizontal 1)
  (org-modern-block-fringe 4)
  (org-modern-block-name t)
  (org-modern-block-border t)
  ;; Tags & todo keywords
  (org-modern-todo t)
  (org-modern-tag t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-level-1 ((t (:inherit default :weight normal :height 1.5))))
 '(org-level-2 ((t (:inherit default :height 1.4))))
 '(org-level-3 ((t (:inherit default :height 1.3))))
 '(org-level-4 ((t (:inherit default :height 1.2))))
 '(org-level-5 ((t (:inherit default :height 1.1))))
 '(org-level-6 ((t (:inherit default :height 1.1))))
 '(org-level-7 ((t (:inherit default :height 1.1))))
 '(org-level-8 ((t (:inherit default :height 1.1)))))


(require 'org-tempo)
(setq org-structure-template-alist
      '(("c"      . "src c")
        ("cpp"    . "src cpp")
        ("py"     . "src python")
        ("sh"     . "src shell")
	("script" . "src shell-script")
        ("js"     . "src js")
        ("el"     . "src emacs-lisp")
	("lisp"   . "src lisp")
	("mk"     . "src makefile")))

(with-eval-after-load 'org
  (add-to-list 'org-file-apps '("\\.png\\'" . "feh %s"))
  (add-to-list 'org-file-apps '("\\.jpg\\'" . "feh %s"))
  (add-to-list 'org-file-apps '("\\.jpeg\\'" . "feh %s"))
  (add-to-list 'org-file-apps '("\\.gif\\'" . "feh %s"))
  (add-to-list 'org-file-apps '("\\.webp\\'" . "feh %s"))
  (add-to-list 'org-file-apps '("\\.svg\\'" . "feh %s"))
  (add-to-list 'org-file-apps '("\\.mp4\\'" . "mpv %s")))









;; ────────────────────────────────────────────────────────────────────────────────────────────────────
;; CONFIG STATE & HELPERS
;; ────────────────────────────────────────────────────────────────────────────────────────────────────

(defvar my/config
  '(:term-name "*my-terminal*"
	       :term-below t
	       :shell-cmd "bash %f"))


(defun my/config-toggle (key)
  "Toggle boolean KEY in `my/config` plist."
  (setf my/config
	(plist-put my/config key
		   (not (plist-get my/config key)))))


;; ────────────────────────────────────────────────────────────────────────────────────────────────────
;; TERMINAL TOGGLE SYSTEM
;; ────────────────────────────────────────────────────────────────────────────────────────────────────

(defun my/term-name ()
  (plist-get my/config :term-name))

(defun my/term-buffer ()
  (get-buffer (my/term-name)))

(defun my/term-window ()
  (get-buffer-window (my/term-name)))

(defun my/terminal-visible-p ()
  "Checks if terminal buffer is visible in window. window or nil"
  (when-let ((win (my/term-window)))
    (if (window-live-p win) win nil)))

(defun my/terminal-focused-p ()
  "Checks if terminal is visible and also point is on terminal. t or nil"
  (when-let ((win (my/terminal-visible-p)))
    (eq win (selected-window))))

(defun my/create-terminal ()
  "Creates a terminal buffer in background"
  (unless (my/term-buffer)
    (save-window-excursion
      (let ((buf (ansi-term (getenv "SHELL"))))
	(with-current-buffer buf
	  (rename-buffer (my/term-name)))))))

(defun my/show-terminal (&optional switch)
  "Creates terminal in split window if not created and puts point in window."
  (my/create-terminal)

  (let ((win (my/terminal-visible-p)))
    (when (not win)
      (setf win (if (plist-get my/config :term-below)
		    (split-window nil -15 'below)
		  (split-window nil -100 'right)))
      (set-window-buffer win (my/term-buffer)))
    (when switch
      (select-window win))))

(defun my/hide-terminal ()
  "Hides terminal if point is in terminal window."
  (if (my/terminal-focused-p)
      (delete-window (my/term-window))))

(defun my/toggle-terminal ()
  "Toggles terminal if point is in terminal window then hide otherwise show."
  (interactive)
  (if (my/terminal-focused-p)
      (my/hide-terminal)
    (my/show-terminal t)))

(defun my/move-terminal ()
  "Moves terminal toggle between below & right."
  (interactive)
  (my/config-toggle :term-below)
  (when (my/terminal-visible-p)
    (my/hide-terminal))
  (my/show-terminal t))


;; ────────────────────────────────────────────────────────────────────────────────────────────────────
;; KEYBINDINGS
;; ────────────────────────────────────────────────────────────────────────────────────────────────────

(global-set-key (kbd "C-`") #'my/toggle-terminal)
(global-set-key (kbd "C-M-`") #'my/move-terminal)













































(defun my/prettier-stdin-filepath ()
  (cond
   ((derived-mode-p 'js-mode 'js-ts-mode) "stdin.js")
   ((derived-mode-p 'typescript-mode 'typescript-ts-mode) "stdin.ts")
   ((derived-mode-p 'css-mode) "stdin.css")
   ((derived-mode-p 'html-mode) "stdin.html")
   (t "stdin.js")))

(defun my/format-buffer ()
  (interactive)
  (let ((cursor (point)))
    (cond
     ((derived-mode-p 'org-mode)
      (org-indent-indent-buffer))
     
     ((derived-mode-p 'c-mode 'c++-mode)
      (call-process-region
       (point-min) (point-max) "clang-format" t t nil))

     ((derived-mode-p 'python-mode)
      (call-process-region
       (point-min) (point-max) "black" t t nil "-" "--quiet"))

     ((derived-mode-p 'html-mode 'css-mode 'js-mode 'js-ts-mode 'typescript-mode 'typescript-ts-mode)
      (call-process-region
       (point-min) (point-max) "prettier" t t nil "--stdin-filepath"
       (or buffer-file-name (my/prettier-stdin-filepath))))

     (t (message "Formatter not defined for mode")))
    (goto-char cursor)))

(global-set-key (kbd "C-c f") #'my/format-buffer)









(defun my/term-send-command (command)
  "Send COMMAND to ansi-term BUFFER-NAME."
  (my/show-terminal)
  (with-current-buffer (get-buffer (plist-get my/config :term-name))
    (goto-char (point-max))
    (term-send-raw-string (concat command "\n"))))

(defun my/helper--lang-context-p (mode language)
  (or
   (derived-mode-p mode)
   (and (derived-mode-p 'org-mode)
	(org-in-src-block-p)
	(string=
	 (org-element-property :language (org-element-context))
	 language))))

(defun my/helper--quotes-balanced-p (str)
  "Return t if single and double quotes are balanced in STR."
  (let ((single 0)
	(double 0))
    (cl-loop for c across str do
	     (cond
	      ((eq c ?') (setq single (1+ single)))
	      ((eq c ?\") (setq double (1+ double)))))
    (and (= (% single 2) 0)
	 (= (% double 2) 0))))

(defun my/helper--shell-last-expression ()
  "Return last shell command before point."
  (save-excursion
    (let ((end (point))
	  (start (point))
	  (done nil))
      (while (and (not done)
		  (re-search-backward "\n" nil t))
	(let ((candidate (buffer-substring-no-properties
			  (1+ (point)) end)))
	  (when (my/helper--quotes-balanced-p candidate)
	    (setq start (1+ (point)))
	    (setq done t))))
      (string-trim
       (buffer-substring-no-properties start end)))))

(defun my/eval-last-expression ()
  (interactive)
  (cond
   ((my/helper--lang-context-p 'sh-mode "shell")
    (my/term-send-command (my/helper--shell-last-expression)))

   ((my/helper--lang-context-p 'lisp-mode "lisp")
    (my/term-send-command (thing-at-point 'sexp t)))

   (t
    (message "context not supported"))))

(global-set-key (kbd "C-M-e") #'my/eval-last-expression)










(defun my/get-lang-extension (lang)
  (cond
   ((string= lang "shell")     ".sh")
   ((string= lang "c")      ".c")
   ((string= lang "python") ".py")
   (t                       ".txt")))

(defun my/create-file (path lang content)
  (let* ((ext  (my/get-lang-extension lang))
	 (file (if path path (make-temp-file "my-" nil ext))))
    (when (and path (file-name-directory path))
      (make-directory (file-name-directory path) t))
    (with-temp-file file (insert content))
    file))

(defun my/build-lang-command (file lang libs)
  (let ((cmd (plist-get my/config
			(intern (format ":%s-cmd" lang)))))
    (when cmd
      (let ((cmd1 (replace-regexp-in-string "%f" file cmd t t)))
	(if libs
	    (replace-regexp-in-string "&&" (concat libs " &&") cmd1 t t)
	  cmd1)))))

(defun my/org-src-block-p ()
  (when (derived-mode-p 'org-mode)
    (let ((el (org-element-context)))
      (when (eq (org-element-type el) 'src-block)
	el))))

(defun my/extract-org-src-block ()
  (when-let ((el  (my/org-src-block-p)))
    (let ((header (org-babel-parse-header-arguments
		   (org-element-property :parameters el))))
      (list
       :lang (org-element-property :language el)
       :path (alist-get :path header)
       :libs (alist-get :libs header)
       :run  (alist-get :run header)
       :body (org-element-property :value el)))))

(defun my/run-org-src-block ()
  (interactive)
  (when-let* ((data (my/extract-org-src-block))
	      (run  (plist-get data :run)))

    (let ((lang    (plist-get data :lang))
	  (path    (plist-get data :path))
	  (libs    (plist-get data :libs))
	  (content (plist-get data :body)))

      (let* ((file (my/create-file path lang content))
	     (cmd  (my/build-lang-command file lang libs)))
	(message file)
	(message cmd)
	(unless cmd
	  (error "No command for language %s" lang))

	(my/term-send-command cmd)))))


(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-<return>")
	      #'my/run-org-src-block))
