;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

(setq make-backup-files nil)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))


(put 'dired-find-alternate-file 'disabled nil)

(add-to-list 'load-path
             "~/.emacs.d/plugins/yasnippet")

;;(ido-mode t)

(define-key global-map [remap find-file] #'helm-find-files)
(define-key global-map [remap switch-to-buffer] #'helm-mini)
(add-hook 'prog-mode-hook #'lsp)

(require 'yasnippet)
(yas-global-mode 1)

(when (>= emacs-major-version 24)
  (progn
    ;; load emacs 24's package system. Add MELPA repository.
    (require 'package)
    (add-to-list
     'package-archives
     '("melpa" . "https://melpa.org/packages/")
     t))

  (when (< emacs-major-version 27) (package-initialize)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(tsdh-dark))
 '(custom-safe-themes
   '("8e0021d033df8614db35f0d054af9f2f8cde994d09fe6d02d20b86cd683a5bd7" default))
 '(package-selected-packages
   '(protobuf-mode protobuf-ts-mode lsp-mode yasnippet lsp-treemacs helm-lsp projectile hydra flycheck company avy which-key helm-xref dap-mode))
 '(undo-tree-visualizer-diff t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "ivory")))))



(require 'lsp-mode)
(add-hook 'go-mode-hook #'lsp-deferred)

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)
(add-hook 'python-mode-hook #'lsp-deferred)


(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))




(use-package lsp-ui
  :commands lsp-ui-mode)

;;(use-package lsp-pyright
;;  :ensure t
;;  :hook (python-mode .(lambda ()
;;			(require 'lsp-pyright)
;;			(lsp))))
(use-package elpy
  :ensure t
  :init
  (elpy-enable))

(use-package flycheck)

(use-package company
  :after lsp-mode
  :hook (prog-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package lsp-mode
  :hook
  ((python-mode . lsp)))



(global-undo-tree-mode)


(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)


;; diff 2023-11-01
;;(setq package-selected-packages '(yasnippet lsp-treemacs helm-lsp
;;    projectile hydra company avy which-key helm-xref dap-mode))

(setq package-selected-packages '(lsp-mode yasnippet lsp-treemacs helm-lsp
    projectile hydra flycheck company avy which-key helm-xref dap-mode))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

;; sample `helm' configuration use https://github.com/emacs-helm/helm/ for details
;;(helm-mode)
;;(require 'helm-xref)
;;(define-key global-map [remap find-file] #'helm-find-files)
;;(define-key global-map [remap execute-extended-command] #'helm-M-x)
;;(define-key global-map [remap switch-to-buffer] #'helm-mini)

(which-key-mode)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  (yas-global-mode))


(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                2000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-header-scroll-indicators        '(nil . "^^^^^^")
          treemacs-hide-dot-git-directory          t
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-project-follow-into-home        nil
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
  :after (treemacs)
  :ensure t
  :config (treemacs-set-scope-type 'Tabs))


(setq make-backup-files nil)


(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))


;; Enable vertico
;;(use-package vertico
;;  :init
;;  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
;;  )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))


(add-hook 'dired-mode-hook 'dired-omit-mode)




    (setq ibuffer-saved-filter-groups
          (quote (("default"
                   ("dired" (mode . dired-mode))
                   ("perl" (mode . cperl-mode))
                   ("erc" (mode . erc-mode))
                   ("planner" (or
                               (name . "^\\*Calendar\\*$")
                               (name . "^diary$")
                               (mode . muse-mode)))
                   ("emacs" (or
                             (name . "^\\*scratch\\*$")
                             (name . "^\\*Messages\\*$")))
                   ("svg" (name . "\\.svg")) ; group by file extension
                   ("gnus" (or
                            (mode . message-mode)
                            (mode . bbdb-mode)
                            (mode . mail-mode)
                            (mode . gnus-group-mode)
                            (mode . gnus-summary-mode)
                            (mode . gnus-article-mode)
                            (name . "^\\.bbdb$")
                            (name . "^\\.newsrc-dribble")))))))



    (add-hook 'ibuffer-mode-hook
              (lambda ()
                (ibuffer-switch-to-saved-filter-groups "default")))



    (require 'ibuf-ext)
    (add-to-list 'ibuffer-never-show-predicates "^\\*")


(global-set-key (kbd "C-x C-b") 'ibuffer)


(setq ibuffer-formats
      '((mark modified read-only " "
              (name 50 50 :left :elide) ; change: 30s were originally 18s
              " "
              (size 9 -1 :right)
              " "
              (mode 16 16 :left :elide)
              " " filename-and-process)
        (mark " "
              (name 16 -1)
              " " filename)))

(setq
 erc-nick "jenia2"     ; Our IRC nick
 erc-user-full-name "Eugene") ; Our /whois name


(global-set-key (kbd "M-x") 'helm-M-x)

(dap-mode 1)
(require 'dap-python)
;; if you installed debugpy, you need to set this
;; https://github.com/emacs-lsp/dap-mode/issues/306
(setq dap-python-debugger 'debugpy)



(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

;; window move
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))



(setq column-number-mode t)


(setcar mode-line-position
        '(:eval (format "%3d%%" (/ (window-start) 0.01 (point-max)))))

(scroll-bar-mode -1)
(tool-bar-mode -1)


(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))


(require 'general)
(general-define-key
 :states 'motion
 "M-." 'lsp-ui-peek-find-definitions)


(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))



;;(require 'switch-window)
;;(global-set-key (kbd "C-x o") 'switch-window)
;;(global-set-key (kbd "C-x 1") 'switch-window-then-maximize)
;;(global-set-key (kbd "C-x 2") 'switch-window-then-split-below)
;;(global-set-key (kbd "C-x 3") 'switch-window-then-split-right)
;;(global-set-key (kbd "C-x 0") 'switch-window-then-delete)
;;
;;(global-set-key (kbd "C-x 4 d") 'switch-window-then-dired)
;;(global-set-key (kbd "C-x 4 f") 'switch-window-then-find-file)
;;(global-set-key (kbd "C-x 4 m") 'switch-window-then-compose-mail)
;;(global-set-key (kbd "C-x 4 r") 'switch-window-then-find-file-read-only)
;;
;;(global-set-key (kbd "C-x 4 C-f") 'switch-window-then-find-file)
;;(global-set-key (kbd "C-x 4 C-o") 'switch-window-then-display-buffer)
;;
;;(global-set-key (kbd "C-x 4 0") 'switch-window-then-kill-buffer)



(global-set-key (kbd "M-o") 'ace-window)


(require 'devil)
(global-devil-mode)
(global-set-key (kbd "C-,") 'global-devil-mode)



(defun mouse-click-on-dired ()
  (interactive)
  (let ((file (dired-get-file-for-visit)))
    (if (file-directory-p file)
	(dired-maybe-insert-subdir file)
      (dired-display-file))))

(eval-after-load "dired"
  '(progn
     (define-key dired-mode-map [mouse-2] 'mouse-click-on-dired)))
(put 'upcase-region 'disabled nil)



(add-to-list 'display-buffer-alist
                    `(,(rx bos "*helm" (* not-newline) "*" eos)
                         (display-buffer-in-side-window)
                         (inhibit-same-window . t)
                         (window-height . 0.4)))
(with-eval-after-load 'eglot
  (add-to-list 'eglot-stay-out-of 'flymake)
  )


(setq lsp-warn-no-matched-clients nil)


(lsp-treemacs-sync-mode 1)


(use-package web-mode
   :ensure t
   :mode (("\\.ts\\'" . web-mode)
          ("\\.js\\'" . web-mode)
          ("\\.mjs\\'" . web-mode)
          ("\\.tsx\\'" . web-mode)
          ("\\.jsx\\'" . web-mode))
   :config
   (setq web-mode-content-types-alist
	 '(("jsx" . "\\.js[x]?\\'"))))



(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)


(setq-default cursor-type '(bar . 2))
(set-cursor-color "white")



(require 'helm-projectile)
(helm-projectile-on)


;;(global-set-key (kbd "C-x C-f") 'helm-projectile)

;;https://www.reddit.com/r/emacs/comments/qutm19/performance_issue_in_lsp_and_pyright_due_to/
  (use-package lsp-pyright
    :ensure t
    :init
    (setq lsp-pyright-multi-root nil))



(setq eldoc-mode nil)
(setq lsp-eldoc-enable-hover nil)
(setq lsp-ui-sideline-enable nil)
(setq lsp-ui-sideline-show-code-actions nil)
(setq lsp-ui-sideline-show-diagnostics nil)


(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C-c c-f") 'sgml-skip-tag-forward)


(global-set-key (kbd "C-S-f") 'forward-to-word)


(projectile-mode +1)
;; Recommended keymap prefix on macOS
(define-key projectile-mode-map (kbd "M-p") 'projectile-command-map)
;; Recommended keymap prefix on Windows/Linux
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)


(setq projectile-project-search-path '("~/git/"))
