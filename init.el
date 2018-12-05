(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
	("melpa" . "https://melpa.milkbox.net/packages/")
	("org" . "https://orgmode.org/elpa/"))
      package-archive-priorities
      '(("melpa" . 20)
 ("gnu" . 15)))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(require 'bind-key)
(show-paren-mode 1)
(setq slime-lisp-implementations '((sbcl ("/usr/bin/sbcl"))))
(require 'slime)
(autoload 'slime-highlight-edits-mode "slime-highlight-edits" nil t)
(require 'slime-autoloads)
(require 'slime-company)
(slime-setup '(slime-fancy slime-asdf slime-banner slime-company))
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(pdf-tools-install)
(add-to-list 'auto-mode-alist '("\\sbclrc$" . lisp-mode))
(add-to-list 'auto-mode-alist '("/etc/sbclrc$" . lisp-mode))
(ido-mode 1)
(setq dired-dwim-target t)

(use-package expand-region
  :ensure t
  :bind
  (("C-." . 'er/expand-region)
   ("C->" . 'er/contract-region)))

(use-package elisp-slime-nav
  :ensure t
  :config
  (progn
    (require 'elisp-slime-nav)
    (mapcar
	 (lambda (hook) (add-hook hook 'elisp-slime-nav-mode))
	 '(emacs-lisp-mode-hook ielm-mode-hook))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(global-highlight-parentheses-mode t)
 '(hl-paren-colors
   (quote
    ("green" "medium spring green" "green yellow" "medium aquamarine")))
 '(initial-buffer-choice "~/common-lisp")
 '(org-babel-load-languages (quote ((lisp . t) (emacs-lisp . t))))
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-irc org-mhe org-rmail org-w3m)))
 '(package-selected-packages
   (quote
    (org hydra paredit helm pdf-tools slime slime-company)))
 '(pdf-tools-enabled-modes
   (quote
    (pdf-history-minor-mode pdf-isearch-minor-mode pdf-links-minor-mode pdf-misc-minor-mode pdf-outline-minor-mode pdf-misc-size-indication-minor-mode pdf-misc-menu-bar-minor-mode pdf-annot-minor-mode pdf-sync-minor-mode pdf-misc-context-menu-minor-mode pdf-cache-prefetch-minor-mode pdf-occur-global-minor-mode)))
 '(pdf-view-display-size (quote fit-width))
 '(pdf-view-midnight-colors (quote ("white" . "gray18")))
 '(slime-company-after-completion nil)
 '(slime-company-completion (quote simple))
 '(slime-truncate-lines t)
 '(wdired-allow-to-change-permissions (quote advanced)))

;; helm config from Sacha Chua
(use-package helm
  :ensure t
  :diminish helm-mode
  :init
  (progn
    (require 'helm-config)
    (setq helm-candidate-number-limit 100)
    ;; From https://gist.github.com/antifuchs/9238468
    (setq helm-idle-delay 0.0 ; update fast sources immediately (doesn't).
	  helm-input-idle-delay 0.01  ; this actually updates things
                                      ; reeeelatively quickly.
	  helm-yas-display-key-on-candidate t
	  helm-quick-update t
	  helm-M-x-requires-pattern nil
	  helm-ff-skip-boring-files t)
    (helm-mode))
  :config
  (progn
    (require 'helm-command)
    (define-key helm-M-x-map "\C-h" 'delete-backward-char))
  :bind (("C-c h" . helm-mini)
	 ("<f1> a" . helm-apropos)
	 ("C-x C-b" . helm-buffers-list)
	 ("C-x b" . helm-buffers-list)
	 ("M-y" . helm-show-kill-ring)
	 ("M-x" . helm-M-x)
	 ("C-x c o" . helm-occur)
	 ("C-x c s" . helm-swoop)
	 ("C-x c y" . helm-yas-complete)
	 ("C-x c Y" . helm-yas-create-snippet-on-region)
	 ("C-x c SPC" . helm-all-mark-rings)))

(use-package paredit
  :ensure t
  :config
  (progn
    (require 'paredit)
    (autoload 'enable-paredit-mode "paredit" "Turn on paredit" t)
    (add-hook 'lisp-mode-hook #'enable-paredit-mode)
    (add-hook 'ielm-mode-hook #'enable-paredit-mode)
    (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
    (add-hook 'slime-repl-mode-hook #'enable-paredit-mode)))

(use-package hydra
  :ensure t
  :config
  (defhydra hydra-paredit-home-row (global-map "C-c p")
    "qwerty joystick style"
    ("j" paredit-backward "left")
    ("l" paredit-forward "right")
    ("i" paredit-backward-up "up")
    ("k" paredit-forward-down "down")
    ("u" paredit-backward-down "prev")
    ("o" paredit-forward-up "next")
    ("(" paredit-wrap-round)
    ("C-t" transpose-sexps)
    ("0" universal-argument)
    ("1" digit-argument)
    ("2" digit-argument)
    ("3" digit-argument)
    ("4" digit-argument)
    ("5" digit-argument)  
    ("6" digit-argument)
    ("7" digit-argument)
    ("8" digit-argument)
    ("9" digit-argument)
    (";" er/expand-region) 
    (":" er/contract-region)))

(setq org-confirm-babel-evaluate nil
      org-src-fontify-natively t
      org-src-tab-acts-natively t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
