;;; helm-git.el --- Helm extension for Git.

;; Copyright (C) 2012 Marian Schubert
;; URL: https://github.com/maio/helm-git

;; This file is NOT part of GNU Emacs.

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; This library provides easy project management and navigation. The
;; concept of a project is pretty basic - just a folder containing
;; special file. Currently git, mercurial and bazaar repos are
;; considered projects by default. If you want to mark a folder
;; manually as a project just create an empty .projectile file in
;; it. See the README for more details.
;;
;;; Code:

(require 'helm-config)
(require 'magit)

(defun helm-git-root-dir ()
  (magit-git-string "rev-parse" "--show-toplevel"))

(defun helm-git-file-full-path (name)
  (expand-file-name name (helm-git-root-dir)))

(defun helm-git-find-file (name)
  (find-file (helm-git-file-full-path name)))

(defun helm-c-git-files ()
  (magit-git-lines "ls-files" "--full-name" "--" (helm-git-root-dir)))

(defvar helm-c-source-git-files
  `((name . "Git files list")
    (candidates . helm-c-git-files)
    (volatile)
    (keymap . ,helm-generic-files-map)
    (help-message . helm-generic-file-help-message)
    (mode-line . helm-generic-file-mode-line-string)
    (match helm-c-match-on-basename)
    (type . file)
    (action . (lambda (candidate)
                (helm-git-find-file candidate))))
  "Helm Git files source definition")

(defun helm-git-find-files ()
  (interactive)
  (helm :sources '(helm-c-source-git-files)))

(provide 'helm-git)
