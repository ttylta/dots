;; UI

(xterm-mouse-mode 1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(add-to-list 'default-frame-alist '(internal-border-width  . 30))
(set-face-background 'vertical-border "gray")
(set-face-foreground 'vertical-border (face-background 'vertical-border))
(window-divider-mode -1)
(setq-default indent-tabs-mode nil)
(set-face-attribute 'mode-line nil
                    :box '(:width 0))

(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

;; Default settings

(defvar user-temporary-file-directory
  (concat temporary-file-directory user-login-name "/"))
(make-directory user-temporary-file-directory t)
(setq backup-by-copying t)
(setq backup-directory-alist
      `(("." . ,user-temporary-file-directory)
        (,tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))

;; Expand package lists

(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org"   . "http://orgmode/elpa/")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(add-to-list 'load-path "~/.emacs.d/pkgs/")

;; Add xresources-theme
;;(load "xresources-theme")

(use-package ewal
  :init (setq ewal-use-built-in-always-p nil
              ewal-use-built-in-on-failure-p t
              ewal-built-in-palette "sexy-material"))
(use-package ewal-spacemacs-themes
  :init (progn
          (show-paren-mode +1))
  :config (progn
            (load-theme 'ewal-spacemacs-modern t)
            (enable-theme 'ewal-spacemacs-modern)))

;; Setup use-package

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)


;; EVIL Mode >:)

(use-package evil
             :ensure t
             :config
             (evil-mode 1))


;; Setup Flycheck

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(add-hook 'after-init-hook #'global-flycheck-mode)

;; Adds prose linting

(flycheck-define-checker proselint
  "A linter for prose."
  :command ("proselint" source-inplace)
  :error-patterns
  ((warning line-start (file-name) ":" line ":" column ": "
	    (id (one-or-more (not (any " "))))
	    (message) line-end))
  :modes (text-mode markdown-mode gfm-mode))

(add-to-list 'flycheck-checkers 'proselint)


;; Adds writegood

(use-package writegood-mode
  :ensure t)


;; Enable company-mode

(use-package company
  :ensure t
  :init
  (setq company-tooltip-align-annotations t)
  (setq company-dabbrev-downcase nil) ; case sensitive text completions
  (setq company-show-numbers t)       ; visual numbering of candidates
  :config
  (add-hook 'after-init-hook 'global-company-mode)

  ;; Make tab indentation and completion work properly
  (define-key company-mode-map [remap indent-for-tab-command]
    'company-indent-for-tab-command)
  (setq tab-always-indent 'complete) ; indent first, and then complete
  (defun company-indent-for-tab-command (&optional arg)
    (interactive "P")
    (let* ((functions-saved completion-at-point-functions)
           (completion-at-point-functions
            (lambda ()
              (let ((completion-at-point-functions functions-saved))
                (company-complete-common)))))
    (indent-for-tab-command arg)))
  )


;; Add to LSP
(use-package company-lsp 
  :commands company-lsp
  :config
  (push 'company-lsp company-backends))


;; Helm

(use-package helm
  :ensure t
  :init
  (setq helm-mode-fuzzy-match t)
  (setq helm-completion-in-region-fuzzy-match t)
  (setq helm-candidate-number-list 50))


;; LSP Related stuff

(require 'lsp-ui)
(add-hook 'lsp-mode-hook 'lsp-ui-mode)


;; Projectile

(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))


;; Neotree

(use-package neotree
             :ensure t
             :config
              (defun neotree-project-dir ()
                  "Open NeoTree using the git root."
                  (interactive)
                  (let ((project-dir (projectile-project-root))
                        (file-name (buffer-file-name)))
                    (neotree-toggle)
                    (if project-dir
                        (if (neo-global--window-exists-p)
                            (progn
                              (neotree-dir project-dir)
                              (neotree-find file-name)))
                      (message "Could not find git project root."))))
              (global-set-key [f8] 'neotree-toggle)
              (setq neo-smart-open t)
              (setq neo-theme (if window-system 'ascii 'arrow))
              (setq-default neo-show-hidden-files t))

(add-hook 'neotree-mode-hook
              (lambda ()
                (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
                (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-quick-look)
                (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
                (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)
                (define-key evil-normal-state-local-map (kbd "g") 'neotree-refresh)
                (define-key evil-normal-state-local-map (kbd "n") 'neotree-next-line)
                (define-key evil-normal-state-local-map (kbd "p") 'neotree-previous-line)
                (define-key evil-normal-state-local-map (kbd "A") 'neotree-stretch-toggle)
                (define-key evil-normal-state-local-map (kbd "H") 'neotree-hidden-file-toggle)))

;; Rusty stuff

(use-package rustic
  :ensure t)


;; Org

(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

(defun my/modify-org-done-face ()
  (setq org-fontify-done-headline t)
  (set-face-attribute 'org-done nil :strike-through t)
  (set-face-attribute 'org-headline-done nil
                      :strike-through t))

(eval-after-load "org"
  (add-hook 'org-add-hook 'my/modify-org-done-face))

(setq org-level-color-stars-only t)

;; Indent Guides

(use-package highlight-indent-guides
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))


;; Local, wiki-style links for markdown

(add-hook 'markdown-mode-hook
  (lambda ()
    ;; Open org-mode style links, [[file:relative.md]]
    (local-set-key (kbd "C-c C-o") 'org-open-at-point-global)))

(use-package lsp-mode
  :ensure t
  :commands lsp
  :config
  (add-to-list 'lsp-language-id-configuration '(clojure-mode . "clojure-mode"))
  :init
  (setq lsp-enable-indentation nil)
  (add-hook 'clojure-mode-hook #'lsp)
  (add-hook 'clojurec-mode-hook #'lsp)
  (add-hook 'clojurescript-mode-hook #'lsp)
  (add-hook 'prog-mode-hook #'lsp))


;; Make movement keys work like they should
(define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)

; Make horizontal movement cross lines                                    
(setq-default evil-cross-lines t)

;; Twittering mode

(setq twittering-icon-mode t)


;; Web dev

; Adds rsjx to js files
(add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))

;; keys

(global-set-key "\C-cg" 'writegood-mode)
(global-set-key "\C-cw" 'writeroom-mode)
(global-set-key "\C-cv" 'visual-line-mode)


;; funcs

(defun package-upgrade-all ()
  "Upgrade all packages automatically without showing *Packages* buffer."
  (interactive)
  (package-refresh-contents)
  (let (upgrades)
    (cl-flet ((get-version (name where)
                (let ((pkg (cadr (assq name where))))
                  (when pkg
                    (package-desc-version pkg)))))
      (dolist (package (mapcar #'car package-alist))
        (let ((in-archive (get-version package package-archive-contents)))
          (when (and in-archive
                     (version-list-< (get-version package package-alist)
                                     in-archive))
            (push (cadr (assq package package-archive-contents))
                  upgrades)))))
    (if upgrades
        (when (yes-or-no-p
               (message "Upgrade %d package%s (%s)? "
                        (length upgrades)
                        (if (= (length upgrades) 1) "" "s")
                        (mapconcat #'package-desc-full-name upgrades ", ")))
          (save-window-excursion
            (dolist (package-desc upgrades)
              (let ((old-package (cadr (assq (package-desc-name package-desc)
                                             package-alist))))
                (package-install package-desc)
                (package-delete  old-package)))))
      (message "All packages are up to date"))))

(defun serif-mode ()
  "Make current buffer use a serif font."
  (interactive)
  (setq buffer-face-mode-face '(:family "Lora" :height 120 :weight light))
  (buffer-face-mode))

(defun xresources-theme-color (name)
  "Read the color NAME (e.g. color5) from the X resources."
  (x-get-resource name ""))

;; Xresources

(let* ((foreground (xresources-theme-color "foreground"))
       (background (xresources-theme-color "background"))
       (color0 (xresources-theme-color "color0"))
       (color1 (xresources-theme-color "color1"))
       (color2 (xresources-theme-color "color2"))
       (color3 (xresources-theme-color "color3"))
       (color4 (xresources-theme-color "color4"))
       (color5 (xresources-theme-color "color5"))
       (color6 (xresources-theme-color "color6"))
       (color7 (xresources-theme-color "color7"))
       (color8 (xresources-theme-color "color8"))
       (color9 (xresources-theme-color "color9"))
       (color10 (xresources-theme-color "color10"))
       (color11 (xresources-theme-color "color11"))
       (color12 (xresources-theme-color "color12"))
       (color13 (xresources-theme-color "color13"))
       (color14 (xresources-theme-color "color14"))
       (color15 (xresources-theme-color "color15")))

(message (xresources-theme-color "background"))
`(set-face-attribute 'region nil :background ,color3 :foreground ,background)

;; Auto-generated

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (twittering-mode tabbar adaptive-wrap clojure-mode-extra-font-locking cider edit-indirect writeroom-mode ewal-spacemacs-themes ewal company lsp-mode evil use-package)))
 '(writeroom-bottom-divider-width 0))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Misc Tamsyn" :foundry "Misc" :slant normal :weight bold :height 117 :width normal))))
 `(header-line ((t (:background ,background))))
 `(highlight ((t (:background ,color2 :foreground ,background))))
 '(italic ((t (:underline t :slant italic))))
 '(lsp-ui-doc-background ((t (:background "white smoke"))))
 '(lsp-ui-sideline-code-action ((t (:foreground "burlywood"))))
 `(markdown-header-face-1 ((t (:inherit bold :background ,background :height 1.3))))
 `(markdown-header-face-2 ((t (:inherit bold :background ,background :height 1.2))))
 `(markdown-header-face-3 ((t (:background ,background :foreground "#F5C7CF" :weight normal :height 1.1))))
`(org-level-1 ((t (:background ,background))))
`(org-level-2 ((t (:background ,background))))
`(org-level-3 ((t (:background ,background))))
`(org-level-4 ((t (:background ,background))))
`(org-todo ((t (:background ,color4 :foreground ,color6))))
 `(region ((t (:background ,color3 :foreground ,background))))
 `(mode-line ((t (:background ,background :foreground "#C5C0B6" :box (:line-width 0)))))))
