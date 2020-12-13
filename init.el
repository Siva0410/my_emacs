(require 'package)
;; package-archivesを上書き
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ;; ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("org" . "https://orgmode.org/elpa/")
        ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless package-archive-contents (package-refresh-contents))

;; M-x package-install-select-packages
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; auto-install 
;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/auto-install/"))
;; (require 'auto-install)
;; (auto-install-update-emacswiki-package-name t)
;; (auto-install-compatibility-setup)

;;----------------------------------------------;;
;;                FLAME CONFIG                  ;;
;;----------------------------------------------;;

;;theme config
(load-theme 'atom-one-dark t)

;; ウィンドウを透明にする
;; アクティブウィンドウ／非アクティブウィンドウ（alphaの値で透明度を指定）
(add-to-list 'default-frame-alist '(alpha . (0.95 0.95)))

;;delete startup message
(setq inhibit-startup-message t)
;;scratch の初期メッセージを消す
(setq initial-scratch-message nil)

;;ツールバー不要
(tool-bar-mode 0)

;;delete Menu bar 
(menu-bar-mode 0)

;;  行番号を表示
(if (version<= "26.0.50" emacs-version)
    (global-display-line-numbers-mode))

;;----------------------------------------------;;
;;              MODE LINE CONFIG                ;;
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
;;               SYSTEM CONFIG                  ;;
;;----------------------------------------------;;
;; (set-language-environment "Japanese")
;; (set-default-coding-systems 'utf-8)
;; (set-terminal-coding-system 'utf-8)
;; (set-keyboard-coding-system 'utf-8)
;; (set-buffer-file-coding-system 'utf-8)

;; バックアップファイルを作らない
(setq make-backup-files nil)

;; オートセーブファイルを作らない
(setq auto-save-default nil)

;; "yes or no" の選択を "y or n" にする
(fset 'yes-or-no-p 'y-or-n-p)

;; delete beap
(setq ring-bell-function 'ignore)

;;----------------------------------------------;;
;;              KEYBOARD CONFIG                 ;;
;;----------------------------------------------;;
;; expand C-a C-a and C-e C-e
(require 'sequential-command-config)
(sequential-command-setup-keys)

;;C-h => backspace
(global-set-key "\C-h" 'delete-backward-char)

;;magit
(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)
(define-key magit-mode-map (kbd "C-p") 'magit-section-backward)
(define-key magit-mode-map (kbd "C-n") 'magit-section-forward)


;;C-t other window
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p) (split-window-horizontally))
  (other-window 1))

(global-set-key (kbd "C-t") 'other-window-or-split)

;; C-; Comment out
(global-set-key (kbd "C-;") 'comment-dwim)

(defun insert-single-quote ()
  (interactive)
  (insert "'")
  (insert "'")
  (backward-char))

(defun insert-double-quote ()
  (interactive)
  (insert "\"")
  (insert "\"")
  (backward-char))

;; C-' C-" insert '' ""
(global-set-key (kbd "C-'") 'insert-single-quote)
(global-set-key (kbd "C-\"") 'insert-double-quote)

;; M-r switch next buffer
(global-set-key (kbd "M-r") 'switch-to-next-buffer)
;; C-r switch prev buffer
(global-set-key (kbd "C-r") 'switch-to-prev-buffer)

;; jump current directory
(global-set-key (kbd "C-x C-d") 'dired-jump)

;; C-S-s
(global-set-key (kbd "C-S-s") 'counsel-imenu)

;; C-x C-u upcase-region
(put 'upcase-region 'disabled nil)
;; C-x C-l downcase-region
(put 'downcase-region 'disabled nil)



;;(use-package google-translate)
(require 'google-translate)

(defun google-translate-enja-or-jaen (&optional string)
  "Translate words in region or current position. Can also specify query with C-u"
  (interactive)
  (setq string
        (cond ((stringp string) string)
              (current-prefix-arg
               (read-string "Google Translate: "))
              ((use-region-p)
               (buffer-substring (region-beginning) (region-end)))
              (t
               (thing-at-point 'word))))
  (let* ((asciip (string-match
                  (format "\\`[%s]+\\'" "[:ascii:]’“”–")
                  string)))
    (run-at-time 0.1 nil 'deactivate-mark)
    (google-translate-translate
     (if asciip "en" "ja")
     (if asciip "ja" "en")
     string)))

(global-set-key (kbd "C-c t") 'google-translate-enja-or-jaen)
;;(bind-key "C-t" 'google-translate-enja-or-jaen) 

;; Fix error of "Failed to search TKK"
(defun google-translate--get-b-d1 ()
    ;; TKK='427110.1469889687'
  (list 427110 1469889687))


;;----------------------------------------------;;
;;                  SKK CONFIG                  ;;
;;----------------------------------------------;;
;; font conf
(set-fontset-font t 'japanese-jisx0208 "TakaoGothic")
(add-to-list 'face-font-rescale-alist '(".*Takao .*" . 1.0))

(require 'skk)
(global-set-key (kbd "C-x j") 'skk-mode)
(setq skk-share-private-jisyo t) 

(setq skk-jisyo-code 'utf-8)

(setq skk-henkan-strict-okuri-precedence t)

;; 句読点変更
(setq-default skk-kutouten-type 'en)
;; 半角カナ
(setq skk-use-jisx0201-input-method t)

;; cursors color setting
(set-cursor-color "#ffffff")

(setq skk-cursor-hiragana-color "gold")
(setq skk-cursor-katakana-color "chartreuse")
(setq skk-cursor-jisx0208-latin-color "deeppink")
(setq skk-cursor-jisx0201-color "darkorange")
(setq skk-cursor-latin-color "skyblue")
(setq skk-cursor-abbrev-color "violet")

;; ";"をsticky shiftに用いることにする
(setq skk-sticky-key ";")


;; 候補表示
;; (setq skk-show-inline t)   ; 変換候補の表示位置
;; (setq skk-show-tooltip t) ; 変換候補の表示位置
;; (setq skk-show-candidates-always-pop-to-buffer t) ; 変換候補の表示位置
;; (setq skk-henkan-number-to-display-candidates 2) ; 候補表示件数を2列に

;; 動的候補表示
(setq skk-dcomp-activate t) ; 動的補完
(setq skk-dcomp-multiple-activate t) ; 動的補完の複数候補表示
(setq skk-dcomp-multiple-rows 10) ; 動的補完の候補表示件数

;; 動的補完の複数表示群のフェイス
(set-face-foreground 'skk-dcomp-multiple-face "Black")
(set-face-background 'skk-dcomp-multiple-face "LightGoldenrodYellow")
(set-face-bold 'skk-dcomp-multiple-face nil)
;; 動的補完の複数表示郡の補完部分のフェイス
(set-face-foreground 'skk-dcomp-multiple-trailing-face "dim gray")
(set-face-bold 'skk-dcomp-multiple-trailing-face nil)
;; 動的補完の複数表示郡の選択対象のフェイス
(set-face-foreground 'skk-dcomp-multiple-selected-face "White")
(set-face-background 'skk-dcomp-multiple-selected-face "LightGoldenrod4")
(set-face-bold 'skk-dcomp-multiple-selected-face nil)
;; 動的補完時にC-nで次の補完へ
;; (define-key skk-j-mode-map (kbd "C-n") 'skk-completion-wrapper) 


;;----------------------------------------------;;
;;                 CODE CONFIG                  ;;
;;----------------------------------------------;;

;; flycheck
(global-flycheck-mode)
;; (add-hook 'python-mode-hook 'flycheck-mode)
;; (add-hook 'c++-mode-hook 'flycheck-mode)
;; (add-hook 'c-mode-hook 'flycheck-mode)

;; lsp-mode
(add-hook 'lsp-mode-hook 'lsp-ui-mode)
(add-hook 'lsp-mode-hook 'yas-minor-mode)
(add-hook 'python-mode-hook #'lsp)
(add-hook 'c-mode-hook #'lsp)
(add-hook 'c++-mode-hook #'lsp)
(setq lsp-enable-snippet t)
(setq lsp-prefer-flymake nil)
(setq lsp-prefer-capf t)

(global-set-key (kbd "M-.") 'xref-find-definitions)
(global-set-key (kbd "M-/") 'xref-find-references)
(global-set-key (kbd "M-,") 'xref-pop-marker-stack)

(require 'ccls)
(setq ccls-executable "/home/shiba/.emacs.d/ccls/Release/ccls")

;; highlight indent
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'character)
;; ivy設定
(require 'ivy)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(setq ivy-height 30) ;; minibufferのサイズを拡大！（重要）
(setq ivy-extra-directories nil)
(setq ivy-re-builders-alist
      '((t . ivy--regex-plus)))

;; counsel設定
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file) ;; find-fileもcounsel任せ！
(setq counsel-find-file-ignore-regexp (regexp-opt '("./" "../")))


(global-set-key "\C-s" 'swiper)
(setq swiper-include-line-number-in-search t) ;; line-numberでも検索可能

;;Rainbow-delimiters
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;;company-mode
(require 'company)
(global-company-mode) ; 全バッファで有効にする
;; (push 'company-lsp company-backends)

(with-eval-after-load 'company
  (setq company-auto-expand nil) ;; 1個目を自動的に補完
  (setq company-transformers '(company-sort-by-backend-importance)) ;; ソート順
  (setq company-idle-delay 0) ; 遅延なしにすぐ表示
  (setq company-minimum-prefix-length 2) ; デフォルトは4
  (setq company-selection-wrap-around t) ; 候補の最後の次は先頭に戻る
  (setq completion-ignore-case t)
  (setq company-dabbrev-downcase nil)
  (setq company-dabbrev-char-regexp "\\(\\sw\\|\\s_\\|_\\|-\\)")    ; -や_などを含む語句も補完
  (global-set-key (kbd "C-M-i") 'company-complete)
  ;; C-n, C-pで補完候補を次/前の候補を選択
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map [tab] 'company-complete-selection) ;; TABで候補を設定
  (define-key company-active-map (kbd "C-i") 'company-complete-selection) ;; C-iで候補を設定
  (define-key company-active-map (kbd "C-h") nil) ;; C-hはバックスペース割当のため無効化
  (define-key company-active-map (kbd "C-S-h") 'company-show-doc-buffer) ;; ドキュメント表示はC-Shift-h
  (define-key company-active-map (kbd "C-s") 'company-filter-candidates)

  (defun company-insert-candidate2 (candidate)
    (when (> (length candidate) 0)
      (setq candidate (substring-no-properties candidate))
      (if (eq (company-call-backend 'ignore-case) 'keep-prefix)
	  (insert (company-strip-prefix candidate))
	(if (equal company-prefix candidate)
	    (company-select-next)
          (delete-region (- (point) (length company-prefix)) (point))
	  (insert candidate))
	)))

  (defun company-complete-common2 ()
    (interactive)
    (when (company-manual-begin)
      (if (and (not (cdr company-candidates))
	       (equal company-common (car company-candidates)))
	  (company-complete-selection)
	(company-insert-candidate2 company-common))))

  ;; TABで共通を補完 or next
  (define-key company-active-map [tab] 'company-complete-common2)
  (define-key company-active-map [backtab] 'company-select-previous) 


  ;; C-m or Enter で候補無視して改行(要検討)
  (defun company-quit-and-enter ()
    (interactive)
    (company-abort)
    (newline))

  (defun company-eshell-quit-and-enter ()
    (interactive)
    (company-abort)
    (eshell-send-input))

  (define-key company-active-map (kbd "RET") 'company-quit-and-enter)
  (define-key company-active-map [return] 'company-quit-and-enter)
  (add-hook 'eshell-mode-hook (lambda () (define-key company-active-map (kbd "RET") 'company-eshell-quit-and-enter)))
  (add-hook 'eshell-mode-hook (lambda () (define-key company-active-map [return] 'company-eshell-quit-and-enter)))
  )

;; Multiple Cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(define-key mc/keymap (kbd "<return>") nil)

;;----------------------------------------------;;
;;                 ESHELL CONFIG                ;;
;;----------------------------------------------;;
(setq shell-pop-shell-type '("eshell" "*eshell*" (lambda () (eshell))))
(global-set-key (kbd "C-]") 'shell-pop)

;;----------------------------------------------;;
;;               ORG-MODE CONFIG                ;;
;;----------------------------------------------;;

(with-eval-after-load 'ox
  (require 'ox-hugo))

;;----------------------------------------------;;
;;               DIRED-MODE CONFIG              ;;
;;----------------------------------------------;;
(require 'dired)
(define-key dired-mode-map (kbd "C-t") 'other-window-or-split)

;; set the other dired buf as default dist
(setq dired-dwim-target t)

;; recursive copy
(setq dired-recursive-copies 'always)

(require 'peep-dired)
;; peep-dired conf
(define-key dired-mode-map (kbd "P") 'peep-dired)
(define-key peep-dired-mode-map (kbd "P") 'peep-dired)
(define-key peep-dired-mode-map (kbd "p") 'peep-dired-prev-file)
(define-key peep-dired-mode-map (kbd "n") 'peep-dired-next-file)
(define-key peep-dired-mode-map (kbd "C-p") 'dired-previous-line)
(define-key peep-dired-mode-map (kbd "C-n") 'dired-next-line)




;; cleanup dired buffer
(setq peep-dired-cleanup-eagerly nil)

;; enable dired mode on directory
(setq peep-dired-enable-on-directories t) 

;; ignore files
(setq peep-dired-ignored-extensions '("mkv" "iso" "mp4"))

;;----------------------------------------------;;
;;               KILL RING CONFIG               ;;
;;----------------------------------------------;;

(require 'browse-kill-ring)
(global-set-key (kbd "C-x y") 'browse-kill-ring)
(browse-kill-ring-default-keybindings)

;;----------------------------------------------;;
;;                   GDB CONFIG                 ;;
;;----------------------------------------------;;
;; gud-overlay-arrow-position nilでエラー
(setq gud-tooltip-display
      '((and gud-overlay-arrow-position
	     (eq (tooltip-event-buffer gud-tooltip-event)
		 (marker-buffer gud-overlay-arrow-position)))))

;; gdb バッファの C-c C-c でプログラムを停止
(setq gdb-gud-control-all-threads nil)

;; input/output バッファ抑制
(setq gdb-display-io-nopopup t)

(defadvice gdb-display-buffer (around gdb-display-buffer)
  (let (window)
    (setq window ad-do-it)
    (set-window-dedicated-p window nil)
    window
  ))
(ad-activate 'gdb-display-buffer)

;; gdb バッファの C-c C-c ではプログラムが停止しなかったので、修正
(defun my-gud-stop ()
  (interactive)
  (comint-interrupt-subjob)
  (gud-stop-subjob)
  )

;; 上記 my-gud-stop 関数を C-cC-c に登録する関数
(defun my-gud-mode-func ()
  (define-key (current-local-map) "\C-c\C-c" 'my-gud-stop)
  )
;; フックに登録
(add-hook 'gud-mode-hook 'my-gud-mode-func)
;;----------------------------------------------;;
;;                    Mew CONFIG                ;;
;;----------------------------------------------;;

(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)

;; Optional setup (Read Mail menu):
(setq read-mail-command 'mew)

;; Optional setup (e.g. C-xm for sending a message):
(autoload 'mew-user-agent-compose "mew" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'mew-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'mew-user-agent
      'mew-user-agent-compose
      'mew-draft-send-message
      'mew-draft-kill
      'mew-send-hook))

;;----------------------------------------------;;
;;                 PYTHON CONFIG                ;;
;;----------------------------------------------;;

;;elpy enable
(elpy-enable)
(setq elpy-rpc-virtualenv-path 'current)
(setq elpy-rpc-python-command "python3")
;; ;;use flycheck
;; (when (require 'flyckeck nil t)
;;   (remove-hook 'elpy-modules 'elpy-module-flymake)
;;   (add-hook 'elpy-mode-hook 'flycheck-mode))

;;jedi
;; (require 'jedi-core)
;; (setq jedi:complete-on-dot t)
;; (setq jedi:use-shortcuts t)
;; (add-hook 'python-mode-hook 'jedi:setup)
;; (add-to-list 'company-backends 'company-jedi) ; backendに追加

;; (define-key elpy-mode-map (kbd "C-c C-v") 'helm-flycheck)
;; (require 'smartrep)   
;; (smartrep-define-key elpy-mode-map "C-c"
;;   '(("C-n" . flycheck-next-error)
;;     ("C-p" . flycheck-previous-error)))
