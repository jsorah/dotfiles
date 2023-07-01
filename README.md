# dotfiles
My dot file configurations.

Inspired by - 
* http://randomartifacts.blogspot.com/2012/10/a-proper-cygwin-environment.html
* https://github.com/ghuntley/terminator-solarized/
* https://github.com/adobe-fonts/source-code-pro
* https://sanctum.geek.nz/cgit/dotfiles.git/about/

# Ansible
- Install latest available python and pip on system
  - `dnf install python3 python3-pip`
- Install ansible
  - `python -m pip install --user ansible`
  - alternatively, follow the guide [here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-with-pip)
- Clone this repo
  - `mkdir ~/repos-personal && cd repos-personal && git clone https://github.com/jsorah/dotfiles.git`
- run the playbooks under /ansible directory
  - `ansible-galaxy install -r requirements.yml`
  - `ansible-playbook bootstrap-packages.yml --ask-become-pass`
  - `ansible-playbook bootstrap-playbook.yml`
  - `ansible-playbook bootstrap-devtools.yml`
  - start new shell
  - `ansible-playbook sdkman-playbook.yml`
- manual stuff
  - get plugins installed for vim (maybe this can be an ansible task?)
    - `vim +PlugUpdate`
  - install fzf
    - `~/.fzf/install.sh`
  - install gitmux
    - `cd repos-software/gitmux && go install`
  - install starship
    - `curl -sS https://starship.rs/install.sh | sh -s - --bin-dir=/home/${USERNAME}/.local/bin
    - add the eval to ~/.bashrc
