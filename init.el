;;MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(fset 'package-desc-vers 'package--ac-desc-version)
(package-initialize)
;;(elpy-enable)

;;PowerLine
(add-to-list 'load-path "~/.emacs.d/lisp/powerline/")
(require 'powerline)
(powerline-default-theme)

;;theme config
(add-to-list 'custom-theme-load-path "~/.emacs.d/theme/atom-one-dark-theme/")
(load-theme 'atom-one-dark t)

;;Rainbow-delimiters
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; make what-whereでSKK modulesで表示されるディレクトリを指定
;;(add-to-list 'load-path "/usr/local/share/emacs/24.3/site-lisp/skk")
;; M-x skk-tutorialでNo file found as 〜とエラーが出たときにskk-tut-fileを設定
;; make what-whereでSKK tutorialsで表示されるディレクトリ上のSKK.tutを指定
;;(setq skk-tut-file "/usr/share/skk/SKK.tut")
;;::(require 'skk)

;;(global-set-key "\C-x\C-j" 'skk-mode)

;;delete startup message
(setq inhibit-startup-message t)

;;scratch の初期メッセージを消す
(setq initial-scratch-message nil)

;;ツールバー不要
(tool-bar-mode 0)

;;delete Menu bar 
(menu-bar-mode 0)

;; バックアップファイルを作らない
(setq make-backup-files nil)
;; オートセーブファイルを作らない
(setq auto-save-default nil)
