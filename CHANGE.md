## Modification Note
V3.9
* add sshfs support for root mode
* add support for install summary, more easy to update certain package
* revise makeLink.sh, skip already linked tool
* fix bug install cmake: check install status, then soft link it if failed
* in practice, ag was better than rg on Vim search, so keep install ag
* auto detect OS platform | skipping already installed packages
* correct key parameter of config file adjusting to current system
* add support for MAC system
* .ycm_extra_conf.py adjust c++ include dir/version
* .vimrc adjust python3 interpreter path
* use downloads/ to store all packages wget/clone
* safe to run installation routine many times
* compile newly gcc/c++ version if not support c++ 11
* add number of cpu core check, make -j [cores]
* add YouCompleteMe
* use oneKey.sh replace of some small scripts

V3.1
* use tmux plugin manager for Tmux plugins.
* add tmux-resurrect and update install.sh
* update .tmux.conf and files associated
* reformat function call for some 'case' switch.
* add regret mode for autoHandle script.

V2.1
* for 'backup' mode, add mechanism to check if file to be backuped exists.
* add alias for 'grep'
* change name autoUpdate.sh => autoHandle.sh
* add dry mode and re-format code logic.
* use cat << instead of many echo for this script.

V1.0
* user-friendly manipulate for backup | restore | confirm | clean .
