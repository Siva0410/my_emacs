
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;;theme config
(load-theme 'tango-dark t)


;; make what-whereでSKK modulesで表示されるディレクトリを指定
;;(add-to-list 'load-path "/usr/local/share/emacs/24.3/site-lisp/skk")
;; M-x skk-tutorialでNo file found as 〜とエラーが出たときにskk-tut-fileを設定
;; make what-whereでSKK tutorialsで表示されるディレクトリ上のSKK.tutを指定
;;(setq skk-tut-file "/usr/share/skk/SKK.tut")
;;::(require 'skk)

;;(global-set-key "\C-x\C-j" 'skk-mode)

;;scratch の初期メッセージを消す
(setq initial-scratch-message "")

;; スタートアップメッセージを非表示
(setq inhibit-startup-screen t)

;;ツールバー不要
(tool-bar-mode -1)

;; Emacsからの質問をy/nで回答する
(fset 'yes-or-no-p 'y-or-n-p)

;; show-paren-mode：対応する括弧を強調して表示する
(show-paren-mode t)
(setq show-paren-delay 0) ;表示までの秒数。初期値は0.125
(setq show-paren-style 'expression)    ;括弧内も強調

;; ミニバッファの履歴を保存する
(savehist-mode t)
(setq history-length 10000)		;履歴数

;; バックアップファイルを作らない
(setq make-backup-files nil)
;; オートセーブファイルを作らない
(setq auto-save-default nil)

;; 選択範囲に色をつける
(transient-mark-mode t
(set-face-background 'region "DeepSkyBlue") ;選択範囲の色

;; コメントアウトのスタイル
(setq comment-style 'box)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; フレーム関連
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 起動時のフレーム設定
(setq initial-frame-alist
   (append (list
　　　;; 表示位置
      '(top . 0)
      '(left . 0)
　　　;; サイズ
      '(width . 190)  ;横
      '(height . 100)) ;縦
     initial-frame-alist)))
(setq default-frame-alist initial-frame-alist)

;; フレームに何文字目かも表示
(column-number-mode t)
;; タイトルバーにファイルのフルパスを表示
(setq frame-title-format "%f")

;;C-h backspace
(keyboard-translate ?\C-h ?\C-?)


;;フレーム透過
(set-frame-parameter (selected-frame) 'alpha '(95 50))

;;Ctrl+TAB で次のバッファーへ移動する
(global-set-key (kbd "<C-tab>") 'next-buffer)
(global-set-key (kbd "<C-S-tab>") 'previous-buffer)


