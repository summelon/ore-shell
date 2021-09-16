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
    ncurses-term \
    zsh byobu vim \
    python3-dev python3-pip build-essential \
    git curl \
    locales \
    gcc-8 g++-8 make \
    pkg-config autoconf automake \
    python3-docutils \
    libseccomp-dev libjansson-dev \
    libyaml-dev libxml2-dev -y" && \
    exec_as_root "update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8" && \
    display_info "Applications installed"


# --- Pip install ---
display_info "Installing python module ..."
python3 -m pip install -U \
    flake8 pylint bpython cmake

# --- Ctags ---
display_info "Building universal-ctags ..."
git clone https://github.com/universal-ctags/ctags
cd ctags
./autogen.sh && \
    ./configure && \
    make && \
    exec_as_root "make install"
cd ..


# --- Vim ---
display_info "Preparing environment for vim ..."
cp vimrc ""$HOME"/.vimrc" && \
    display_info "Moved vimrc to "$HOME", Installing vim plugin ..."
vim -es -u ""$HOME"/.vimrc" -i NONE -c "PlugInstall" -c "qa" && \
    display_info "Installation done"
cp filetype.vim  ""$HOME"/.vim/filetype.vim"


# --- ZSH ---
display_info "Preparing environment for zsh ..."

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
cp zshrc ""$HOME"/.zshrc" && \
    sed -i -e "/^export ZSH/c \export ZSH=""$HOME"/.oh-my-zsh"" "$HOME"/.zshrc

    # Spaceship theme
git clone https://github.com/denysdovhan/spaceship-prompt.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship-prompt --depth=1
ln -s ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/spaceship.zsh-theme

    # Auto-Suggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    # Syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Fix misalignment bug
localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
echo 'export LANG=en_US.utf8' >> ~/.zshrc

display_info "ZSH setting done"


# --- Byobu ---
display_info "Preparing environment for byobu ..."
if [ ! -d ""$HOME"/.byobu/" ]; then
    mkdir ""$HOME"/.byobu"
    echo "Created .byobu directory"
fi
echo "set -g default-shell /usr/bin/zsh" >> ~/.byobu/.tmux.conf
echo "set -g default-command /usr/bin/zsh" >> ~/.byobu/.tmux.conf
echo "set -g default-terminal \"tmux-256color\"" >> ~/.byobu/.tmux.conf
display_info "Byobu setting done"
