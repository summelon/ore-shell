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



# --- Apt install ---
display_info "Installing applications ..."
exec_as_root "pacman -Syyu" && exec_as_root "pacman -S \
    zsh \
    byobu \
    bashtop \
    vim \
    ctags\
    cmake \
    git curl \
    -yy" && display_info "Applications installed"


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
