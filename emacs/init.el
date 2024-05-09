(global-display-line-numbers-mode 1)

(require 'transient)
(transient-define-prefix dispatch-goto-menu () "Documentation"
			 [["Line"
			   ("l" "End of line" end-of-line)
			   ("h" "Beginning of line" beginning-of-line-text)
			   ("m" "Mark line" meow-line)
			   ("n" "Line number..." meow-goto-line)]
			  ["Buffer"
			   ("b" "Beginning of buffer" beginning-of-buffer)
			   ("e" "End of buffer" end-of-buffer)]])

(defun meow-setup ()
  ;; (setq meow-cheatsheet-physical-layout meow-cheatsheet-physical-layout-iso)
  ;; (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwertz)
  (meow-thing-register 'angle
		       '(pair (";") (":"))
		       '(pair (";") (":")))

  (setq meow-char-thing-table
	'((?r . round)
	  (?s . square)
	  (?c . curly)
	  (?a . angle)
	  (?g . string)
	  (?p . paragraph)
	  (?l . line)
	  (?b . buffer)
	  (?d . defun)))

  (meow-leader-define-key
    ;; Use SPC (0-9) for digit arguments.
    '("1" . meow-digit-argument)
    '("2" . meow-digit-argument)
    '("3" . meow-digit-argument)
    '("4" . meow-digit-argument)
    '("5" . meow-digit-argument)
    '("6" . meow-digit-argument)
    '("7" . meow-digit-argument)
    '("8" . meow-digit-argument)
    '("9" . meow-digit-argument)
    '("0" . meow-digit-argument)
    '("-" . meow-keypad-describe-key)
    '("_" . meow-cheatsheet))

  (meow-normal-define-key
    ;; expansion
    '("0" . meow-expand-0)
    '("1" . meow-expand-1)
    '("2" . meow-expand-2)
    '("3" . meow-expand-3)
    '("4" . meow-expand-4)
    '("5" . meow-expand-5)
    '("6" . meow-expand-6)
    '("7" . meow-expand-7)
    '("8" . meow-expand-8)
    '("9" . meow-expand-9)
    '("ä" . meow-reverse)

    ;; movement
    '("k" . meow-prev)
    '("j" . meow-next)
    '("h" . meow-left)
    '("l" . meow-right)

    '("/" . meow-search)
    '("-" . meow-visit)
    ;; expansion
    '("K" . meow-prev-expand)
    '("J" . meow-next-expand)
    '("H" . meow-left-expand)
    '("L" . meow-right-expand)

    '("b" . meow-back-word)
    '("B" . meow-back-symbol)
    '("w" . meow-next-word)
    '("W" . meow-next-symbol)

    '("m" . meow-mark-word)
    '("M" . meow-mark-symbol)
    '("g" . dispatch-goto-menu)
    '("v" . meow-block)
    '("r" . meow-join)
    '("e" . meow-grab)
    '("E" . meow-pop-grab)
    '("s" . meow-swap-grab)
    '("S" . meow-sync-grab)
    '("q" . meow-cancel-selection)
    '("Q" . meow-pop-selection)

    '("t" . meow-till)
    '("f" . meow-find)

    '("," . meow-beginning-of-thing)
    '("." . meow-end-of-thing)
    '(";" . meow-inner-of-thing)
    '(":" . meow-bounds-of-thing)

    ;; editing
    '("d" . meow-kill)
    '("c" . meow-change)
    '("x" . meow-delete)
    '("y" . meow-save)
    '("p" . meow-yank)
    '("P" . meow-yank-pop)

    '("i" . meow-insert)
    '("a" . meow-append)
    '("o" . meow-open-below)
    '("O" . meow-open-above)

    '("u" . undo-only)
    '("U" . undo-redo)

    '("z" . open-line)
    '("Z" . split-line)

    '("ü" . indent-rigidly-left-to-tab-stop)
    '("+" . indent-rigidly-right-to-tab-stop)

    ;; ignore escape
    '("<escape>" . ignore)))
(require 'meow)
(meow-setup)
(meow-global-mode 1)
(load-theme 'nord t)
(require 'dashboard)
(dashboard-setup-startup-hook)
(setq dashboard-startup-banner 
      '("/home/gerald/Pictures/nix-snowflake-small.png" . "/home/gerald/Pictures/nix-snowflake-small.txt"))
(require 'use-package)
;; (use-package lsp-mode
;;   :commands lsp
;;   :ensure t
;;   :diminish lsp-mode
;;   :hook
;;   (elixir-mode . lsp)
;;   :init
;;   (add-to-list 'exec-path "elixir-ls"))
(require 'eglot)

(require 'elixir-mode)
(require 'python-mode)
(require 'nix-mode)

(add-hook 'elixir-mode-hook 'eglot-ensure)
(add-to-list 'eglot-server-programs `(elixir-mode "elixir-ls"))
(add-to-list 'eglot-server-programs `(python-mode "pylsp"))
(add-to-list 'eglot-server-programs `(nix-mode "rnix-lsp"))

;;(use-package yasnippet
;;  :hook (elixir-mode . yas-minor-mode))
;; (use-package flymake
;;  :hook (elixir-mode . flymake-mode))
(require 'org)
(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))
(require 'sketch-mode) 
