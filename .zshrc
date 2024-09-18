# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/marc/.oh-my-zsh"
export AWS_PROFILE=sts
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="af-magic"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"


# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="%d/%m/%y %T"
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git terraform zsh-autosuggestions virtualenv asdf aws colorize git-prompt poetry)

export VIRTUAL_ENV_DISABLE_PROMPT=1
source $ZSH/oh-my-zsh.sh

# User configuration

# export LANG=en_US.UTF-8

#  Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nano'
else
   export EDITOR='nano'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# ####################################################################
alias zshconf="nano ~/.zshrc"

gitb() {
   git checkout -b "mv/$1"
}

gits() {
   git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)
}

gitd() {
   branch=$(git rev-parse --abbrev-ref HEAD)
   git checkout master && git branch -D ${branch} & git pull
}

gitf() {
   git push --force-with-lease
}

gita() {
   git commit --amend
}
# ####################################################################
# alias ohmyzsh="mate ~/.oh-my-zsh"
export PATH="/home/marc/bin:$PATH"
export PATH="/home/marc/.local/bin:$PATH"


export REDSHIFT_DB=prod

. $HOME/.asdf/asdf.sh

#export PATH="$HOME/.tfenv/bin:$PATH"
#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#export PATH="$PYENV_ROOT/shims:$PATH"

#if command -v pyenv 1>/dev/null 2>&1;
#	 then eval "$(pyenv init -)"
#fi

#eval "$(pyenv virtualenv-init -)"

fpath+=~/.zfunc
autoload -Uz compinit && compinit

unalias gsts
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$(yarn global bin)"

export AWS_DEFAULT_REGION=eu-west-1

function awslogin {
    config_dir=$HOME/.aws
    config_file=$config_dir/google_config
    config_docs='https://data.pennylane.tech/posts/local-setup/'

    # Checking that the config file exists, and contains the right keys
    if [[ ! -f $config_file ]] ; then
        echo -e "Missing $config_file, aborting. See setup instructions at \e]8;;$config_docs\a$config_docs\e]8;;\a."
        return 1
    fi

    . $config_file
    if [ -z "$google_email" ]; then
        echo "Missing key 'google_email' in $config_file."
        return 1
    elif [ -z "$google_idp_id" ]; then
        echo "Missing key 'google_idp_id' in $config_file."
        return 1
    elif [ -z "$google_sp_id" ]; then
        echo "Missing key 'google_sp_id' in $config_file."
        return 1
    elif [ -z "$aws_region" ]; then
        echo "Missing key 'aws_region' in $config_file."
        return 1
    fi

    # Configuring region for all AWS commands, using the default profile
    echo "[default]\nregion = ${aws_region}" > $config_dir/config
    # Google SAML login, followed by Codeartifact login
    gsts \
        --idp-id=$google_idp_id \
        --sp-id=$google_sp_id \
        --aws-region $aws_region \
        --cache-dir $config_dir \
        --verbose \
        --force \
        --username $google_email \
	--playwright-engine-channel "chrome"
    # echo "\nLogging in to Codeartifact..."
    # aws codeartifact login \
    #     --tool pip \
    #     --domain pennylane \
    #     --repository pypi-pennylane \
}

alias awslogin='awslogin'
