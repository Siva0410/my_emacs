;;MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;;----------------------------------------------;;
;;              MODE LINE CONFIG
;;----------------------------------------------;;

;;PowerLine
(add-to-list 'load-path "~/.emacs.d/lisp/powerline/")
(require 'powerline)
(powerline-default-theme)

;;smart-mode-line
(defvar sml/no-confirm-load-theme t)
(defvar sml/theme 'dark) 
(defvar sml/shorten-directory -1)
(sml/setup)

(column-number-mode t) ;; 列番号の表示
(line-number-mode t) ;; 行番号の表示

;;nyan-mode
(nyan-mode 1)

;;----------------------------------------------;;
;;                FLAME CONFIG
;;----------------------------------------------;;

;;theme config
(add-to-list 'custom-theme-load-path "~/.emacs.d/theme/atom-one-dark-theme/")
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

;;----------------------------------------------;;
;;               SYSTEM CONFIG
;;----------------------------------------------;;

;; バックアップファイルを作らない
(setq make-backup-files nil)

;; オートセーブファイルを作らない
(setq auto-save-default nil)

;; "yes or no" の選択を "y or n" にする
(fset 'yes-or-no-p 'y-or-n-p)

;;----------------------------------------------;;
;;              KEYBOARD CONFIG
;;----------------------------------------------;;

;;C-h => backspace
(global-set-key "\C-h" 'delete-backward-char)

;;----------------------------------------------;;
;;                 CODE CONFIG
;;----------------------------------------------;;

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
    (flycheck elpy smart-mode-line nyan-mode rainbow-delimiters))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;company-mode
(require 'company)
;;(global-company-mode) ; 全バッファで有効にする 
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
;;                 PYTHON CONFIG
;;----------------------------------------------;;

;;elpy enable
(elpy-enable)
(setq elpy-rpc-virtualenv-path 'current)

;; use flycheck
(when (require 'flyckeck nil t)
  (remove-hook 'elpy-modules 'elpy-module-flymake)
  (add-hook 'elpy-mode-hook 'flycheck-mode))
