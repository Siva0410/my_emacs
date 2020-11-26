;; auto-install
;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/auto-install/"))
;; (require 'auto-install)
;; (auto-install-update-emacswiki-package-name t)
;; (auto-install-compatibility-setup)

;;MELPA
;; (require 'package)
;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;; (package-initialize)

(require 'package)

;; package-archivesを上書き
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ;; ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("org" . "https://orgmode.org/elpa/")
        ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless package-archive-contents (package-refresh-contents))

;; 以下、追加するパッケージ
(unless (package-installed-p 'atom-one-dark-theme)
  (package-install 'atom-one-dark-theme))
(unless (package-installed-p 'powerline)
  (package-install 'powerline))
(unless (package-installed-p 'smart-mode-line)
  (package-install 'smart-mode-line))
(unless (package-installed-p 'nyan-mode)
  (package-install 'nyan-mode))
(unless (package-installed-p 'rainbow-delimiters)
  (package-install 'rainbow-delimiters))
(unless (package-installed-p 'counsel)
  (package-install 'counsel))
(unless (package-installed-p 'sequential-command)
  (package-install 'sequential-command))
(unless (package-installed-p 'elpy)
  (package-install 'elpy))
(unless (package-installed-p 'smartrep)
  (package-install 'smartrep))
(unless (package-installed-p 'magit)
  (package-install 'magit))
(unless (package-installed-p 'ox-hugo)
  (package-install 'ox-hugo))
;;----------------------------------------------;;
;;                FLAME CONFIG
;;----------------------------------------------;;

;;theme config
(load-theme 'atom-one-dark t)

;; ウィンドウを透明にする
;; アクティブウィンドウ／非アクティブウィンドウ（alphaの値で透明度を指定）
(add-to-list 'default-frame-alist '(alpha . (0.95 0.95)))

;;delete startup message
(setq inhibit-startup-message t)
;;scratch の初期メッセージを消す
(setq initial-scratch-message nil)

;;ツールバー不要
(tool-bar-mode 0)

;;delete Menu bar 
(menu-bar-mode 0)

;;  行番号を表示
(if (version<= "26.0.50" emacs-version)
    (global-display-line-numbers-mode))

;;----------------------------------------------;;
;;              MODE LINE CONFIG
;;----------------------------------------------;;

;;PowerLine
(require 'powerline)
(powerline-default-theme)

;;smart-mode-line
(defvar sml/no-confirm-load-theme t)
(defvar sml/theme 'dark) 
(defvar sml/shorten-directory -1)
(sml/setup)

(column-number-mode t) ;; modelineに列番号の表示
(line-number-mode t) ;; modelineに行番号の表示

;;nyan-mode
(nyan-mode 1)

;;----------------------------------------------;;
;;               SYSTEM CONFIG
;;----------------------------------------------;;

;; バックアップファイルを作らない
(setq make-backup-files nil)

;; オートセーブファイルを作らない
(setq auto-save-default nil)

;; "yes or no" の選択を "y or n" にする
(fset 'yes-or-no-p 'y-or-n-p)

;; bufferの最後でカーソルを動かそうとしても音をならなくする
(defun next-line (arg)
  (interactive "p")
  (condition-case nil
      (line-move arg)
    (end-of-buffer)))

;; エラー音をならなくする
(setq ring-bell-function 'ignore)

;;----------------------------------------------;;
;;              KEYBOARD CONFIG
;;----------------------------------------------;;
;; expand C-a C-a and C-e C-e
(require 'sequential-command-config)
(sequential-command-setup-keys)

;;C-h => backspace
(global-set-key "\C-h" 'delete-backward-char)

;;magit
(global-set-key (kbd "C-x g") 'magit-status)

;;C-t other window
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p) (split-window-horizontally))
  (other-window 1))

(global-set-key (kbd "C-t") 'other-window-or-split)

;;----------------------------------------------;;
;;                 CODE CONFIG
;;----------------------------------------------;;

;; ivy設定
(require 'ivy)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(setq ivy-height 30) ;; minibufferのサイズを拡大！（重要）
(setq ivy-extra-directories nil)
(setq ivy-re-builders-alist
      '((t . ivy--regex-plus)))

;; counsel設定
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file) ;; find-fileもcounsel任せ！
(setq counsel-find-file-ignore-regexp (regexp-opt '("./" "../")))


(global-set-key "\C-s" 'swiper)
(setq swiper-include-line-number-in-search t) ;; line-numberでも検索可能

;;Rainbow-delimiters
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default)))
 '(package-selected-packages
   (quote
    (counsel magit elpygen smartrep helm-flycheck flycheck elpy smart-mode-line nyan-mode rainbow-delimiters))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;company-mode
(require 'company)
(global-company-mode) ; 全バッファで有効にする

(with-eval-after-load 'company
  (setq company-auto-expand t) ;; 1個目を自動的に補完
  (setq company-transformers '(company-sort-by-backend-importance)) ;; ソート順
  (setq company-idle-delay 0) ; 遅延なしにすぐ表示
  (setq company-minimum-prefix-length 2) ; デフォルトは4
  (setq company-selection-wrap-around t) ; 候補の最後の次は先頭に戻る
  (setq completion-ignore-case t)
  (setq company-dabbrev-downcase nil)
  (global-set-key (kbd "C-M-i") 'company-complete)
  ;; C-n, C-pで補完候補を次/前の候補を選択
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map [tab] 'company-complete-selection) ;; TABで候補を設定
  (define-key company-active-map (kbd "C-h") nil) ;; C-hはバックスペース割当のため無効化
  (define-key company-active-map (kbd "C-S-h") 'company-show-doc-buffer) ;; ドキュメント表示はC-Shift-h
)

;;----------------------------------------------;;
;;               ORG-MODE CONFIG
;;----------------------------------------------;;

(with-eval-after-load 'ox
  (require 'ox-hugo))

;;----------------------------------------------;;
;;                 PYTHON CONFIG
;;----------------------------------------------;;

;;elpy enable
(elpy-enable)
(setq elpy-rpc-virtualenv-path 'current)
(setq elpy-rpc-python-command "python3")
;;use flycheck
(when (require 'flyckeck nil t)
  (remove-hook 'elpy-modules 'elpy-module-flymake)
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(define-key elpy-mode-map (kbd "C-c C-v") 'helm-flycheck)
(require 'smartrep)   
(smartrep-define-key elpy-mode-map "C-c"
  '(("C-n" . flycheck-next-error)
    ("C-p" . flycheck-previous-error)))
