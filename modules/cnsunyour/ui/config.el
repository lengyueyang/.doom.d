;;; cnsunyour/ui/config.el -*- lexical-binding: t; -*-

;; dashboard banner image
(setq fancy-splash-image
      (let* ((banners (directory-files "~/.doom.d/banner" 'full (rx ".png" eos)))
             (banner (elt banners (random (length banners)))))
        banner))

;; 当前系统分辨率超过1600X100,则判断为大显示器
(defun cnsunyour/is-large-display-p()
  (let* ((display-width (x-display-pixel-width))
         (display-height (x-display-pixel-height)))
    (and (>= display-width 1600) (>= display-height 1000))))

;; Set doom font family and size
(setq doom-font (font-spec :family "Sarasa Mono SC" :size (if (cnsunyour/is-large-display-p) 16 14)))

;; 设定popup的窗口形式为右侧开启，宽度为40%
;; (set-popup-rule! "^\\*" :side 'right :size 0.5 :select t)

;; 80列太窄，120列太宽，看着都不舒服，100列正合适
;; (setq-default fill-column 100)

;; 虚拟换行设置
;; (setq-default visual-fill-column-width 120)
;; (global-visual-fill-column-mode 1)
;; (global-visual-line-mode 1)

;; To fix the issue: Unable to load color "brightblack"
(after! hl-fill-column
  (set-face-background 'hl-fill-column-face "#555555"))

(after! doom-modeline
  (setq doom-modeline-icon t
        doom-modeline-major-mode-icon t
        doom-modeline-major-mode-color-icon t
        doom-modeline-buffer-state-icon t
        doom-modeline-buffer-modification-icon t
        doom-modeline-enable-word-count t
        doom-modeline-indent-info t))

(after! lsp-ui
  (setq lsp-ui-doc-position 'at-point
        lsp-ui-flycheck-enable t
        lsp-ui-sideline-ignore-duplicate t
        lsp-ui-sideline-update-mode 'point
        lsp-enable-file-watchers nil
        lsp-ui-doc-enable t)
  (if (featurep 'xwidget-internal)
      (setq lsp-ui-doc-use-webkit t)))

;; winum，使用SPC+[0-9]选择窗口
(after! winum
  (map! :leader
        "0" #'winum-select-window-0-or-10
        "1" #'winum-select-window-1
        "2" #'winum-select-window-2
        "3" #'winum-select-window-3
        "4" #'winum-select-window-4
        "5" #'winum-select-window-5
        "6" #'winum-select-window-6
        "7" #'winum-select-window-7
        "8" #'winum-select-window-8
        "9" #'winum-select-window-9))

;; 拆分窗口时默认把焦点定在新窗口，doom为了和vim保持一致，竟然把这点改回去了
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; 使用相对行号
(setq display-line-numbers-type 'relative)

;; Enabling Font Ligatures in emacs-mac-port
(when (eq window-system 'mac)
  (mac-auto-operator-composition-mode))

;; 调整Mac下窗口和全屏显示方式
(when (eq window-system 'ns)
  (setq ns-use-thin-smoothing t)
  (setq ns-use-native-fullscreen nil)
  (setq ns-use-fullscreen-animation nil))

;; 调整启动时窗口大小/最大化/全屏
;; (pushnew! initial-frame-alist '(width . 200) '(height . 48))
(add-hook 'window-setup-hook #'toggle-frame-maximized)
;; (add-hook 'window-setup-hook #'toggle-frame-fullscreen)

;; 每天根据日出日落时间换主题
(use-package! theme-changer
  :after doom-theme
  :config
  (change-theme '(doom-one-light
                  doom-acario-light
                  doom-nord-light
                  doom-opera-light
                  doom-solarized-light
                  doom-tomorrow-day)
                '(doom-one
                  doom-city-lights
                  doom-challenger-deep
                  doom-dracula
                  doom-gruvbox
                  doom-Iosvkem
                  doom-vibrant
                  doom-molokai
                  doom-moonlight
                  doom-oceanic-next
                  doom-peacock
                  doom-spacegrey
                  doom-snazzy
                  doom-wilmersdorf)))

(use-package! awesome-tab
  :commands (awesome-tab-mode)
  :init
  (defhydra hydra-tab (:pre (awesome-tab-mode t)
                       :post (awesome-tab-mode -1))
    "
   ^^^^Fast Move             ^^^^Tab                    ^^Search            ^^Misc
  -^^^^--------------------+-^^^^---------------------+-^^----------------+-^^---------------------------
     ^_k_^   prev group    | _C-a_^^     select first | _b_ switch buffer | _C-k_   kill buffer
   _h_   _l_ switch tab    | _C-e_^^     select last  | _g_ switch group  | _C-S-k_ kill others in group
     ^_j_^   next group    | _a_^^       ace jump     | ^^                | ^^
   ^^0 ~ 9^^ select window | _C-h_/_C-l_ move current | ^^                | ^^
  -^^^^--------------------+-^^^^---------------------+-^^----------------+-^^---------------------------
  "
    ("h" awesome-tab-backward-tab)
    ("j" awesome-tab-forward-group)
    ("k" awesome-tab-backward-group)
    ("l" awesome-tab-forward-tab)
    ("a" awesome-tab-ace-jump)
    ("C-a" awesome-tab-select-beg-tab)
    ("C-e" awesome-tab-select-end-tab)
    ("C-h" awesome-tab-move-current-tab-to-left)
    ("C-l" awesome-tab-move-current-tab-to-right)
    ("b" ivy-switch-buffer)
    ("g" awesome-tab-counsel-switch-group)
    ("C-k" kill-current-buffer)
    ("C-S-k" awesome-tab-kill-other-buffers-in-current-group)
    ("q" nil "quit"))
  :bind
  (("s-t" . hydra-tab/body)))