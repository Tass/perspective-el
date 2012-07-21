;;; wmctrl.el -- interface with window manager script
;;
;; Copyright (C) 2012 Tim O'Callaghan <timo@dspsrv.com>
;;
;; Licensed under the same terms as Emacs.
;;
;; By: Tim O'Callaghan
;; http://github.com/timoc/perspective-el
;; Created: 2012-06-21
;; Version: 1.0
;; Keywords: workspace, desktop, frames
;;
;; to handle switching desktops, and interrogating the window manager
;;

;;; Commentary:

;; This package provides a mechanism to get and set the desktop of a
;; frame.

;;; Code:

;;-------------- some example wmctrl commands
;; list all windows id, titles, geomerties etc
;; $ wmctrl -l -G -p

(defvar wmctrl-path "wmctrl"
  "path to wmctrl tool")

(defvar wmctrl-debug "wmctrl"
  "used to write debugging messages ")

(defun wmctrl-max-desktop-id ()
  "Returns the identifer of the desktop of the calling frame as a
string. The identifier is a number between 0 and the maximum
number of desktops"
  (let ((desktop-id
         (replace-regexp-in-string
          "\\(^[[:space:]\n]*\\|[[:space:]\n]*$\\)" ""
          (shell-command-to-string
           (concat wpersp-wmctrl-path
                   " -d | tail -1 | awk '{ print $1 }'")))))
    (when wmctrl-debug
      (message "== max desktop-id:%s" desktop-id))
    desktop-id))

(defun wmctrl-get-desktop-id ()
  "Returns the identifer of the desktop of the calling frame as a
string. The identifier is a number between 0 and the maximum
number of desktops"
  (let ((desktop-id
         (replace-regexp-in-string
          "\\(^[[:space:]\n]*\\|[[:space:]\n]*$\\)" ""
          (shell-command-to-string
           (concat wpersp-wmctrl-path
                   " -d | grep '\*' | awk '{ print $1 }'")))))
    (when wmctrl-debug
      (message "== get desktop-id:%s" desktop-id))
    desktop-id))

(defun wmctrl-set-desktop-id (desktop &rest frame)
  "Move the current/passed in frame to the desktop supplied."
  (when persp-use-wpersp
    (let ((hex-window-id
           (format "0x%x" (string-to-number
                           (frame-parameter
                            (or frame (selected-frame)) 'outer-window-id)))))
      (when wmctrl-debug
        (message "== set desktop-id:%s for window-id:%s" desktop hex-window-id))
      ;; uses wmctrl - e.g wmctrl -i -r 0x4a000a0 -t 0
      (call-process wpersp-wmctrl-path nil nil nil
                    "-i" "-t" desktop
                    "-r" hex-window-id))
    ))

(provide 'wmctrl)
;;; wmctrl.el ends here
