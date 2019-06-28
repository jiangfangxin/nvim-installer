#!/bin/bash

# Name
#       install.sh - Install and config neovim automaticly on Ubuntu and Mac.
# 
# SYNOPSIS
#       install.sh [-c] [-h|--help] [-u]
# 
# DESCRIPTION
#       install.sh is a bash shell which can help people install and config vim automaticly on Ubuntu and Mac.
#       This installer will use git to fetch vim themes and plugins from github. If git not installed before,
#       it will try to install git by apt (for Ubuntu) or brew (for Mac). If brew not found on Mac, this installer
#       will try to install it after get your permission.
#
#       The default theme is tomasr/molokai. The default plugin manager is junegunn/vim-plug.
#
# COMMAND LINE OPTIONS
#       -c
#               Clean all backup.
#
#       -h, --help
#               Prints the usage for the interpreter executable and exits.
#
#       -u      Only update the ~/.vimrc
#
# AUTHOR
#       jiangfangxin
#
# REPOSITORY
#       https://github.com/jiangfangxin/neovim-installer

# Variables
startDir=$PWD
quit() {
    cd $startDir
    exit $1     # Exit with a number code.
}

cd $(dirname $0)
workDir=$PWD

initDir=$HOME/.config/nvim
colorDir=$HOME/.config/nvim/colors
pluginManagerDir=$HOME/.local/share/nvim/site/autoload
pluginsDir=$HOME/.local/share/nvim/plugged

# Theme
themeRepostry=https://github.com/tomasr/molokai.git
themeFilePath=colors/molokai.vim

# Plugin Manager
pluginManagerRepostry=https://github.com/junegunn/vim-plug.git
pluginManagerPath=plug.vim

# System check
if [[ "$OSTYPE" == "darwin"* ]] || [[ "$OSTYPE" == "linux"* && -x "$(which apt)" ]]; then
    echo "System supported."
else
    echo "System not support."
    quit 1
fi

# Functions
installHomeBrewIfMac() {
    if [[ "$OSTYPE" == "darwin"* && ! -x "$(which brew)" ]]; then
        read -p "Package manager HomeBrew not exits, do you want to install it? [y/n] " choice
        if [ "$choice" == "y" ]; then
            # There always has ruby on mac.
            if /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; then
                echo "HomeBrew installed."
            else
                echo "Install HomeBrew failed."
                quit 1
            fi
        else
            echo "Install abort due to without HomeBrew, you can install it permaticly later."
            quit 1
        fi
    fi
}

installGit() {
    if [ ! -x "$(which git)" ]; then
        read -p "Git is not exist, try to install it? [y/n] " choice
        if [ "$choice" == "y" ]; then
            case "$OSTYPE" in
                "darwin"*) # Mac
                    if brew install git; then
                        echo "Git installed."
                    else
                        echo "Install Git failed."
                        quit 1
                    fi;;
                "linux"*) # Ubuntu
                    if sudo apt install git; then
                        echo "Git installed."
                    else
                        echo "Install Git failed."
                        quit 1
                    fi;;
            esac
        else
            echo "Install abort due to without git."
            quit 1
        fi
    fi
}

installNeovim() {
    case "$OSTYPE" in
        "darwin"*) # Mac
            if brew install neovim; then
                echo "Neovim installed."
            else
                echo "Install neovim failed."
                quit 1
            fi;;
        "linux"*) # Ubuntu
            # Install from the source on Ubuntu.
            git clone https://github.com/neovim/neovim.git neovim
            cd neovim
            git checkout stable
            make CMAKE_BUILD_TYPE=Release
			if sudo make install; then
                echo "Neovim installed."
                cd ../
            else
                echo "Install neovim failed."
                quit 1
            fi;;
    esac
}

cleanOldBackup() {
    all=0       # If delete all backup.
    prefix=""   # Backup file prefix, like: /home/name/.config/nvim/init.vim~, or like: /home/name/.config/nvim/colors~
    suffix=""   # Backup file suffix, like: .tar.gz
    for i in $@; do
        if [[ $i == "-"* ]]; then
            if [ $i == "-a" ]; then
                all=1
            else
                echo "Unkonwn option: $i."
            fi
        else
            if [ -z $prefix ]; then
                prefix=$i
            elif [ -z $suffix ]; then
                suffix=$i
            else
                echo "Unkonwn param: $i."
            fi
        fi
    done

    if [ $all == 1 ]; then
        for f in $prefix*$suffix; do
            rm $f
            echo "Backup file $f be deleted."
        done
    elif [ $(ls $prefix*$suffix 2>/dev/null | wc -l) -gt 3 ]; then   # Only delete backup when count more than 3.
        # Delete backup more than 30 days.
        # The date syntax has some diffrent between Ubuntu and Mac.
        case "$OSTYPE" in
            "darwin"*) lastMonth=$(date -v -30d +%Y%m%d%H%M%S) ;;       # Mac
            "linux"*)  lastMonth=$(date -d "-30 days" +%Y%m%d%H%M%S) ;; # Ubuntu
        esac
        for f in $prefix*$suffix; do
            # Delete path only leave time to compare.
            time=${f/$prefix/}
            time=${time/$suffix/}
            if [ $time -lt $lastMonth ]; then
                rm $f
                echo "Old backup file $f be deleted."
            fi
        done
    fi    
}

installConfig() {
    # Merge neovim config to one init.vim file
    cat config/basic.vim > init.vim
        echo "config/basic.vim > init.vim"
    cat config/theme.vim >> init.vim
        echo "config/theme.vim >> init.vim"
    cat config/search.vim >> init.vim
        echo "config/search.vim >> init.vim"
    cat config/file.vim >> init.vim
        echo "config/file.vim >> init.vim"
    cat config/netrw.vim >> init.vim
        echo "config/netrw.vim >> init.vim"
    cat config/fn.vim >> init.vim
        echo "config/fn.vim >> init.vim"
    cat config/edit.vim >> init.vim
        echo "config/edit.vim >> init.vim"
    cat config/plugin.vim >> init.vim
        echo "config/plugin.vim >> init.vim"
    cat config/mac-keyboard.vim >> init.vim
        echo "config/mac-keyboard.vim >> init.vim"
    cat config/clipboard.vim >> init.vim
        echo "config/clipboard.vim >> init.vim"

    # Check init.vim
    if [ -f $initDir/init.vim ]; then
        if cmp init.vim $initDir/init.vim; then
            # Same
            echo "init.vim has no change, no need to update."
        else
            # Use newer init.vim and backup old one.
            mv $initDir/init.vim $initDir/init.vim~$(date +%Y%m%d%H%M%S)
            echo "Old init.vim backuped."
            cp init.vim $initDir/
            echo "init.vim updated."
        fi
    else
        # ~/.config/nvim/init.vim not exist.
        cp init.vim $initDir/
        echo "init.vim updated."
    fi

    # Delete old backup
    cleanOldBackup $initDir/init.vim~
}

installTheme() {
    # Check neovim colors
    if [ -d $colorDir ]; then
        if [ -n "$(ls $colorDir)" ]; then
            # Has other colers
            cd $(dirname $colorDir)
            tar -czf $colorDir~$(date +%Y%m%d%H%M%S).tar.gz $(basename $colorDir)
            cd $workDir
            echo "Old theme backuped."
            rm -r $colorDir/*
        fi
    else
        mkdir -p $colorDir
    fi

    if [ -d theme ]; then
        rm -rf theme
    fi

    git clone $themeRepostry theme
    cp theme/$themeFilePath $colorDir/
    echo "Theme updated."
    
    cleanOldBackup $colorDir~ .tar.gz
}

installPluginManager() {
    if [ -d $pluginManagerDir ]; then
        if [ -n "$(ls $pluginManagerDir)" ]; then
            # Backup old plugin manager
            cd $(dirname $pluginManagerDir)
            tar -czf $pluginManagerDir~$(date +%Y%m%d%H%M%S).tar.gz $(basename $pluginManagerDir)
            cd $workDir
            echo "Old plugin manager backuped."
            rm -r $pluginManagerDir/*
        fi
    else
        mkdir -p $pluginManagerDir
    fi

    if [ -d pluginManager ]; then
        rm -rf pluginManager
    fi

    git clone $pluginManagerRepostry pluginManager
    cp pluginManager/$pluginManagerPath $pluginManagerDir/
    echo "Plugin manager updated."

    cleanOldBackup $pluginManagerDir~ .tar.gz
}

installPluginNeedTools() {
    echo "Start install plugin need tools."
    # Plugin [rking/ag.vim](https://github.com/rking/ag.vim) needed.
    case "$OSTYPE" in
        "darwin"*) brew install the_silver_searcher;;   # Mac
        "linux"*)  sudo apt install silversearcher-ag;; # Ubuntu
    esac
    # Plugin [Shougo/deoplete.nvim](https://github.com/Shougo/deoplete.nvim.git) needed.
    case "$OSTYPE" in
        "darwin"*) brew install python3;;     # Mac
        "linux"*)  sudo apt install python3;; # Ubuntu
    esac
    pip3 install pynvim
    # Plugin [phpactor/phpactor](https://github.com/phpactor/phpactor.git) needed.
    case "$OSTYPE" in
        "darwin"*) brew install composer;;     # Mac
        "linux"*)  sudo apt install composer;; # Ubuntu
    esac
    echo "Tools installed.";
}

installPlugins() {
    echo "Start install plugins..."
    nvim -c PlugClean! -c PlugInstall -c qall
    echo "Plugin installed."
}

echoHelp() {
    cat << EOF
Usage: install.sh [-c] [-h|--help] [-u]
Options:
-c         : Clean all backup.
-h, --help : Show usage an options.
-u         : Only combine and update init.vim.
EOF
}

# Main
main() {
    if [ $# == 0 ]; then
        echo "Start nvim-installer."
        echo "Checking install environment..."
        installHomeBrewIfMac
        installGit
        installNeovim
        installConfig
        installTheme
        installPluginManager
        installPluginNeedTools
        installPlugins
        echo "Neovim installed, all configured."
    else
        for i in $@; do
            if [[ $i == "-h" || $i == "--help" ]]; then
                echoHelp
            elif [ $i == "-u" ]; then
                echo "Start update init.vim."
                installConfig
            elif [ $i == "-c" ]; then
                echo "Start clean all backup."
                cleanOldBackup -a $initDir/init.vim~
                cleanOldBackup -a $colorDir~ .tar.gz
                cleanOldBackup -a $pluginManagerDir~ .tar.gz
                echo "All backup cleaned."
            else
                echo "Unknown option: $i."
            fi
        done
    fi
    quit 0
}

# Run
main $@
