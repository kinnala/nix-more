;;; nix-more.el --- Extensions to nix-mode  -*- lexical-binding: t; -*-

;; Copyright (C) 2021 Tom Gustafsson

;; Author: Tom Gustafsson <name@example.com>
;; URL: https://github.com/kinnala/nix-more
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1"))
;; Keywords: nix

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;;; Requirements

(require 'nix-search)
(require 'bui)

;;;; Variables

(defvar nix-more--package-cache nil
  "Cache variable for the list of packages.")

;;;; Commands

;;;###autoload
(defun nix-more-find-package-definition ()
  "Find the file containing the definition of a package."
  (interactive)
  (find-file
   (string-trim
    (shell-command-to-string
     (concat
      "EDITOR=echo nix edit "
      (completing-read "Package: " (nix-more--list-packages-cached)))))))

;;;###autoload
(defun nix-more-list-system-profiles ()
  "Display a list of system profiles."
  (interactive)
  (bui-get-display-entries 'nix-more--system-profiles 'list))

;;;; Functions

;;;;; Private

(defun nix-more--list-packages-cached ()
  "Return a list of packages."
  (if (not nix-more--package-cache)
      (setq nix-more--package-cache (nix-search "" "")))
  (symbol-value 'nix-more--package-cache))

(defun nix-more--line->entry (line)
  (let ((l (s-split " " line)))
    `((name . ,(car (-take-last 3 l)))
      (date . ,(car (-take-last 5 l)))
      (path . ,(car (-take-last 1 l))))))

(defun nix-more--get-system-profiles ()
  (mapcar 'nix-more--line->entry
          (s-split "\n" (shell-command-to-string
                         "ls -l /nix/var/nix/profiles/ | grep store"))))

(bui-define-interface nix-more--system-profiles list
  :buffer-name "*System profiles*"
  :get-entries-function 'nix-more--get-system-profiles
  :format '((name nil 20 t)
            (date nil 8 t)
            (path bui-list-get-file-name 40 t))
  :sort-key '(name))

;;;; Footer

(provide 'nix-more)

;;; nix-more.el ends here
