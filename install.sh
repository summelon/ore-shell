# !/bin/bash

# --- function ---
display_info()
{
    echo ""
    echo ">>>>>>>"
    echo "$1"
    echo "<<<<<<<"
    echo ""
}


exec_as_root()
{
    if [ $EUID -eq 0 ]; then
        echo "Run as super user ..."
        eval "$1"
    else
        echo "Run as user: $(whoami)..."
        eval "sudo $1"
    fi
}


# --- Add ppa ---
display_info "Updating ..."
exec_as_root "apt update" && \
    exec_as_root "apt install software-properties-common -y"

display_info "Adding vim ppa ..."
exec_as_root "add-apt-repository ppa:jonathonf/vim -y" && \
    display_info "Successfully added vim ppa"

display_info "Adding bashtop ppa ..."
exec_as_root "add-apt-repository ppa:bashtop-monitor/bashtop -y" && \
    display_info "Successfully added bashtop ppa"


# --- Apt install ---
display_info "Installing applications ..."
exec_as_root "apt update" && exec_as_root "apt install \
    zsh \
    byobu \
    vim exuberant-ctags\
    cmake python3-dev python3-pip build-essential \
    git curl \
    -y" && display_info "Applications installed"


# --- Pip install ---
display_info "Installing python module ..."
python3 -m pip install -U \
    flake8 pylint


# --- Vim ---
display_info "Preparing environment for vim ..."
cp vimrc ""$HOME"/.vimrc" && \
    display_info "Moved vimrc to "$HOME", Installing vim plugin ..."
vim -es -u ""$HOME"/.vimrc" -i NONE -c "PlugInstall" -c "qa" && \
    display_info "Installation done"


# --- ZSH ---
display_info "Preparing environment for zsh ..."
CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp zshrc ""$HOME"/.zshrc" && \
    sed -i -e "/^export ZSH/c \export ZSH=""$HOME"/.oh-my-zsh"" "$HOME"/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
display_info "ZSH setting done"


# --- Byobu ---
display_info "Preparing environment for byobu ..."
if [ ! -d ""$HOME"/.byobu/" ]; then
    mkdir ""$HOME"/.byobu"
    echo "Created .byobu directory"
fi
echo "set -g default-shell /usr/bin/zsh" >> ~/.byobu/.tmux.conf
echo "set -g default-command /usr/bin/zsh" >> ~/.byobu/.tmux.conf
echo "set -g default-terminal \"xterm-256color\"" >> ~/.byobu/.tmux.conf
display_info "Byobu setting done"
