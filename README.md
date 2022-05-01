# dotfiles
My dot file configurations.

Inspired by - 
* http://randomartifacts.blogspot.com/2012/10/a-proper-cygwin-environment.html
* https://github.com/ghuntley/terminator-solarized/
* https://github.com/adobe-fonts/source-code-pro
* https://sanctum.geek.nz/cgit/dotfiles.git/about/

# Ansible
- Install latest available python on system
- Install ansible
  - `python -m pip install --user ansible`
  - alternatively, follow the guide [here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-with-pip)
- run the playbook under /ansible directory
  - `ansible-playbook bootstrap-playbook.yml`
