;; This is literally just copying the minimum necessary from my .emacs
;; to load all my packages via straight.el ..
;; It's just a time-saver at install time so that straight won't install
;; a ton of packages the first time I run emacs on a new host.

(defconst slinkp:config-dir "~/.emacs.d/" "")

;; utility function to auto-load other config files
(defun slinkp:load-config-file (filelist)
  (dolist (file filelist)
    (load (expand-file-name 
           (concat slinkp:config-dir file)))
    (message "Loaded config file:%s" file)
    ))

(slinkp:load-config-file
 '("setup-native-comp"
   "package-install"
   ))
