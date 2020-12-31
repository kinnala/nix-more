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
      (ivy-read "Package: " (nix-more--list-packages-cached)))))))

;;;; Functions

;;;;; Public

(defun package-name-foo (args)
  "Return foo for ARGS."
  (foo args))

;;;;; Private

(defun nix-more--list-packages-cached ()
  "Return a list of packages."
  (if (not nix-more--package-cache)
      (setq nix-more--package-cache (nix-search "" "")))
  (symbol-value 'nix-more--package-cache))

;;;; Footer

(provide 'nix-more)

;;; nix-more.el ends here
