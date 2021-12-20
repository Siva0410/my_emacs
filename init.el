;;; init.el --- My init.el  -*- lexical-binding: t; -*-
;;; Commentary:

;;; Code:
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  (customize-set-variable
   'package-archives '(("org"   . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu"   . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))


(leaf leaf
  :config
  (leaf leaf-convert :ensure t)
  (leaf leaf-tree
    :ensure t
    :custom ((imenu-list-size . 30)
             (imenu-list-position . 'left))))


(leaf macrostep
  :ensure t
  :bind (("C-c e" . macrostep-expand)))


;;---------------------------------------------------------------------------------------

(leaf flame-conf
  :doc "Flame Config"
  :config
  (load-theme 'atom-one-dark t)
  (tool-bar-mode 0)
  (menu-bar-mode 0)
  (global-display-line-numbers-mode)
  (add-to-list 'default-frame-alist
	       '(alpha 0.95 0.95))
  :custom ((inhibit-startup-message . t)
           ((initial-scratch-message))))


(leaf rainbow-delimiters
  :doc "highlight parentheses"
  :hook ((prog-mode-hook . rainbow-delimiters-mode)))


(leaf smartparens
  :require smartparens-config
  :ensure t
  :setq-default ((sp-highlight-pair-overlay))
  :config
  (smartparens-global-mode t))


(leaf prog-mode
  :doc "highlight indent"
  :hook ((prog-mode-hook . highlight-indent-guides-mode))
  :custom ((highlight-indent-guides-method quote character)))


(leaf modeline-conf
  :doc "Modeline Config"
  :require powerline
  :config
  (powerline-default-theme)
  (column-number-mode t)
  (line-number-mode t) 

  (leaf smartmodeline
    :custom ((sml/no-confirm-load-theme . t)
	     (sml/theme quote dark)
	     (sml/shorten-directory . -1))
    :config
    (sml/setup))

  ;;nyan-mode
  (leaf nyan-mode
    :config
    (nyan-mode 1)))


(leaf system-conf
  :doc "System Config"
  :custom ((make-backup-files)
	   (auto-save-default)
	   (ring-bell-function quote ignore))
  :config
  (fset 'yes-or-no-p 'y-or-n-p))


(leaf key-conf
  :doc "Keyboard Config"
  :preface
  (defun other-window-or-split nil
    (interactive)
    (when (one-window-p)
      (split-window-horizontally))
    (other-window 1))
  :bind  (("C-h" . delete-backward-char)
          ("C-t" . other-window-or-split)
          ("C-;" . comment-dwim)
          ("C-x C-d" . dired-jump)))

(leaf sequential-command-conf
  :doc "C-a or C-e toggle"
  :require sequential-command-config
  :config
  (sequential-command-setup-keys))


(leaf dired-conf
  :bind ((dired-mode-map
	  ("C-t" . other-window-or-split)))
  :require dired
  :custom ((dired-dwim-target . t)
	   (dired-recursive-copies quote always)))


(leaf peep-dired
  :bind ((dired-mode-map
	  ("P" . peep-dired))
	 (peep-dired-mode-map
	  ("P" . peep-dired))
	 (peep-dired-mode-map
	  ("p" . peep-dired-prev-file))
	 (peep-dired-mode-map
	  ("n" . peep-dired-next-file))
	 (peep-dired-mode-map
	  ("C-p" . dired-previous-line))
	 (peep-dired-mode-map
	  ("C-n" . dired-next-line)))
  :custom ((peep-dired-cleanup-eagerly)
	   (peep-dired-enable-on-directories . t)
	   (peep-dired-ignored-extensions quote
					  ("mkv" "iso" "mp4")))
  :require peep-dired)


(leaf kill-ring
  :doc "pop past kill-ring buffer"
  :bind (("C-x y" . browse-kill-ring))
  :require browse-kill-ring
  :config
  (browse-kill-ring-default-keybindings))


(leaf magit
  :bind (("C-x g" . magit-status)
	 (magit-mode-map
	  ("C-p" . magit-section-backward))
	 (magit-mode-map
	  ("C-n" . magit-section-forward)))
  :require magit)


(leaf docker
  :bind ("C-x v" . docker)
  ;;        (magit-mode-map
  ;;         ("C-p" . magit-section-backward))
  ;;        (magit-mode-map
  ;;         ("C-n" . magit-section-forward)))
  :ensure t
  :require docker)


(leaf dockerfile-mode
  :ensure t
  :mode (("Dockerfile\\'" . dockerfile-mode)))
  ;; :require dockerfile-mode)

(leaf docker-compose-mode
  :ensure t
  :require docker-compose-mode)

(leaf docker-tramp
  :ensure t
  :require docker-tramp-compat
  :config
  (set-variable 'docker-tramp-use-names t))

(leaf ivy
  :require ivy
  :custom ((ivy-use-virtual-buffers . t)
	   (enable-recursive-minibuffers . t)
	   (ivy-height . 30)
	   (ivy-extra-directories)
	   (ivy-re-builders-alist quote
				  ((t . ivy--regex-plus))))
  :config
  (ivy-mode 1) 
  (leaf ivy-counsel
    :bind (("M-x" . counsel-M-x)
	   ("C-x C-f" . counsel-find-file)
           ("C-S-s" . counsel-imenu))
    :config
    (setq counsel-find-file-ignore-regexp (regexp-opt
					   '("./" "../"))))
  
  (leaf ivy-counsel
    :bind (("M-x" . counsel-M-x)
	   ("C-x C-f" . counsel-find-file))
    :config
    (setq counsel-find-file-ignore-regexp (regexp-opt
					   '("./" "../"))))
  (leaf ivy-swiper
    :bind (("C-s" . swiper))
    :custom ((swiper-include-line-number-in-search . t))))


(leaf company
  :require company
  :preface
  (defun company-insert-candidate2 (candidate)
    (when (>
	   (length candidate)
	   0)
      (setq candidate (substring-no-properties candidate))
      (if (eq
	   (company-call-backend 'ignore-case)
	   'keep-prefix)
	  (insert
	   (company-strip-prefix candidate))
	(if (equal company-prefix candidate)
	    (company-select-next)
	  (delete-region
	   (-
	    (point)
	    (length company-prefix))
	   (point))
	  (insert candidate)))))

  (defun company-complete-common2 nil
    (interactive)
    (when (company-manual-begin)
      (if (and
	   (not (cdr company-candidates))
	   (equal company-common
		  (car company-candidates)))
	  (company-complete-selection)
	(company-insert-candidate2 company-common))))

  (defun company-quit-and-enter nil
    (interactive)
    (company-abort)
    (newline))

  (defun company-eshell-quit-and-enter nil
    (interactive)
    (company-abort)
    (eshell-send-input))

  :after t
  :bind (("C-M-i" . company-complete)
	 (company-active-map
	  ("C-n" . company-select-next)
	  ("C-p" . company-select-previous)
	  ([tab]
	   . company-complete-selection)
	  ("C-i" . company-complete-selection)
	  ("C-h")
	  ("C-S-h" . company-show-doc-buffer)
	  ("C-s" . company-filter-candidates)
	  ([tab]
	   . company-complete-common2)
	  ([backtab]
	   . company-select-previous)
	  ("RET" . company-quit-and-enter)
	  ([return]
	   . company-quit-and-enter)))
  :custom ((company-auto-expand)
	   (company-transformers quote
			         (company-sort-by-backend-importance))
	   (company-idle-delay . 0)
	   (company-minimum-prefix-length . 2)
	   (company-selection-wrap-around . t)
	   (completion-ignore-case . t)
	   (company-dabbrev-downcase)
	   (company-dabbrev-char-regexp . "\\(\\sw\\|\\s_\\|_\\|-\\)"))
  :config
  (add-hook 'eshell-mode-hook
	    (lambda nil
	      (define-key company-active-map
		(kbd "RET")
		'company-eshell-quit-and-enter)))
  (add-hook 'eshell-mode-hook
	    (lambda nil
	      (define-key company-active-map
		[return]
		'company-eshell-quit-and-enter))))


(leaf multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
	 ("C->" . mc/mark-next-like-this)
	 ("C-<" . mc/mark-previous-like-this)
	 ("C-c C-<" . mc/mark-all-like-this)
	 (mc/keymap
	  ("<return>")))
  :require multiple-cursors)


(leaf hugo
  :doc "enable hugo command"
  :after t
  :require ox-hugo)


(leaf golang-lsp
  :preface
  (defun lsp-go-install-save-hooks nil
    (add-hook 'before-save-hook #'lsp-format-buffer t t)
    (add-hook 'before-save-hook #'lsp-organize-imports t t))

  :hook ((go-mode-hook . lsp-deferred)
	 (go-mode-hook . lsp-go-install-save-hooks))
  :require lsp-mode)


(leaf golang
  :preface
  (defun lsp-go-install-save-hooks nil
    (add-hook 'before-save-hook #'lsp-format-buffer t t)
    (add-hook 'before-save-hook #'lsp-organize-imports t t))

  :config
  (leaf go-mode
    :ensure t
    :mode ("\\.go\\'")
    :hook ((go-mode-hook . lsp-go-install-save-hooks)))

  (leaf lsp-mode
    :ensure t
    :commands lsp-deferred lsp
    :hook ((go-mode-hook . lsp-deferred)
           (lsp-mode-hook . yas-minor-mode))
    :setq (lsp-enable-snippet . t))


  (leaf lsp-ui
    :ensure t
    :custom (lsp-ui-doc-use-childframe . nil)
    :commands lsp-ui-mode))


(leaf c-lsp
  :require ccls
  :setq ((ccls-executable . "/home/shiba/.emacs.d/ccls/Release/ccls")))

(leaf lsp-ui
  :hook ((lsp-mode-hook . lsp-ui-mode)
	 (lsp-mode-hook . yas-minor-mode)))

(leaf lsp-mode
  :hook ((c-mode-hook . lsp)
	 (c++-mode-hook . lsp))
  :setq ((lsp-enable-snippet . t)
	 (lsp-prefer-flymake)
	 (lsp-prefer-capf . t)))

;; ;;----------------------------------------------;;
;; ;;                  SKK CONFIG                  ;;
;; ;;----------------------------------------------;;
;; ;; font conf
;; (set-fontset-font t 'japanese-jisx0208 "TakaoGothic")
;; (add-to-list 'face-font-rescale-alist '(".*Takao .*" . 1.0))

;; (require 'skk)
;; (global-set-key (kbd "C-x j") 'skk-mode)
;; (setq skk-share-private-jisyo t) 

;; (setq skk-jisyo-code 'utf-8)

;; (setq skk-henkan-strict-okuri-precedence t)

;; ;; 句読点変更
;; (setq-default skk-kutouten-type 'en)
;; ;; 半角カナ
;; (setq skk-use-jisx0201-input-method t)

;; ;; cursors color setting
;; (set-cursor-color "#ffffff")

;; (setq skk-cursor-hiragana-color "gold")
;; (setq skk-cursor-katakana-color "chartreuse")
;; (setq skk-cursor-jisx0208-latin-color "deeppink")
;; (setq skk-cursor-jisx0201-color "darkorange")
;; (setq skk-cursor-latin-color "skyblue")
;; (setq skk-cursor-abbrev-color "violet")

;; ;; ";"をsticky shiftに用いることにする
;; (setq skk-sticky-key ";")


;; ;; 候補表示
;; ;; (setq skk-show-inline t)   ; 変換候補の表示位置
;; ;; (setq skk-show-tooltip t) ; 変換候補の表示位置
;; ;; (setq skk-show-candidates-always-pop-to-buffer t) ; 変換候補の表示位置
;; ;; (setq skk-henkan-number-to-display-candidates 2) ; 候補表示件数を2列に

;; ;; 動的候補表示
;; (setq skk-dcomp-activate t) ; 動的補完
;; (setq skk-dcomp-multiple-activate t) ; 動的補完の複数候補表示
;; (setq skk-dcomp-multiple-rows 10) ; 動的補完の候補表示件数

;; ;; 動的補完の複数表示群のフェイス
;; (set-face-foreground 'skk-dcomp-multiple-face "Black")
;; (set-face-background 'skk-dcomp-multiple-face "LightGoldenrodYellow")
;; (set-face-bold 'skk-dcomp-multiple-face nil)
;; ;; 動的補完の複数表示郡の補完部分のフェイス
;; (set-face-foreground 'skk-dcomp-multiple-trailing-face "dim gray")
;; (set-face-bold 'skk-dcomp-multiple-trailing-face nil)
;; ;; 動的補完の複数表示郡の選択対象のフェイス
;; (set-face-foreground 'skk-dcomp-multiple-selected-face "White")
;; (set-face-background 'skk-dcomp-multiple-selected-face "LightGoldenrod4")
;; (set-face-bold 'skk-dcomp-multiple-selected-face nil)
;; ;; 動的補完時にC-nで次の補完へ
;; ;; (define-key skk-j-mode-map (kbd "C-n") 'skk-completion-wrapper) 


;; ;;----------------------------------------------;;
;; ;;                 CODE CONFIG                  ;;
;; ;;----------------------------------------------;;

;; ;; flycheck
;; (global-flycheck-mode)
;; ;; (add-hook 'python-mode-hook 'flycheck-mode)
;; ;; (add-hook 'c++-mode-hook 'flycheck-mode)
;; ;; (add-hook 'c-mode-hook 'flycheck-mode)

;; ;; lsp-mode

;; (add-hook 'python-mode-hook #'lsp)

;; (global-set-key (kbd "M-.") 'xref-find-definitions)
;; (global-set-key (kbd "M-/") 'xref-find-references)
;; (global-set-key (kbd "M-,") 'xref-pop-marker-stack)

;;---------------------------------------------------------------------------------------
(provide 'init)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here
