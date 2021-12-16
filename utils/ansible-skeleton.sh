#!/bin/bash

describe() {
cat <<EOF
ansible.cfg               # Configuration file for Ansible behavior
requirements.yml          # Pinning down application dependencies (pip freeze)
system.yml                # master playbook (use includes or imports)
playbooks/                # referred playbooks (environments, situations)
   development.yml        # development env playbook
   production.yml         # production env playbook
   situational.yml        # a playbook for some situation
inventories/              # Flexibility and separation for larger environments
   production/
      hosts               # inventory file for production servers
      group_vars/
         group1.yml       # here we assign variables to particular groups
         group2.yml
      host_vars/
         hostname1.yml    # here we assign variables to particular systems
         hostname2.yml
   development/
      hosts               # inventory file for development environment
      group_vars/
         group1.yml       # here we assign variables to particular groups
         group2.yml
      host_vars/
         hostname1.yml    # here we assign variables to particular systems
         hostname2.yml
roles/                    # put here only your own roles for versioning
    common/               # this hierarchy represents a "role"
        tasks/            #
            main.yml      #  <-- tasks file can include smaller files if warranted
        handlers/         #
            main.yml      #  <-- handlers file
        templates/        #  
            ntp.conf.j2   #  <-- templates end in .j2
        files/            #
            bar.txt       #  <-- files for use with the copy resource
            foo.sh        #  <-- script files for use with the script resource
        vars/             #
            main.yml      #  <-- variables associated with this role
        defaults/         #
            main.yml      #  <-- default lower priority variables for this role
        meta/             #
            main.yml      #  <-- role dependencies
        library/          # roles can also include custom modules
        module_utils/     # roles can also include custom module_utils
        lookup_plugins/   # or other types of plugins, like lookup in this case
library/                  # if any custom modules, put them here (optional)
filter_plugins/           # if any custom filter plugins, put them here (optional)
tools/                    # External tools like Vagrant, Postman collections, etc.
EOF
}

usage() {
  echo "Create Ansible playbook or playbook role skeletons..."
  echo "https://github.com/jarirajari"
  echo ""
  echo "Usage:"
  echo "bash ansible-skeleton.sh -d"
  echo "bash ansible-skeleton.sh -p <new-playbook-name>"
  echo "bash ansible-skeleton.sh -r <playbook-name>/<new-role-name>"
  exit 1
}

if [ "$1" = "-d" ]; then
  describe
elif [ "$#" -ne 2 ]; then
  usage
elif [ "$1" = "-p" ]; then
  echo "creating playbook '$2'"
  if [ -d "$2" ]; then
    echo "it already exists!"
  else
    mkdir -p "$2"
    cd "$2"
    mkdir -p library filter_plugins roles/common/{tasks,handlers,templates,files,vars}
    touch system.yml roles/common/tasks/{main.yml,README.md} roles/common/handlers/{main.yml,README.md} roles/common/templates/{ntp.conf.j2,README.md} roles/common/files/{foo.sh,bar.txt,README.md} roles/common/vars/{main.yml,README.md} site.yml
    mkdir -p inventories/{production,development}/{group_vars,host_vars}
    touch inventories/{production,development}/hosts inventories/{production,development}/group_vars/{group1.yml,group2.yml} inventories/{production,development}/host_vars/{hostname1.yml,hostname2.yml}
    mkdir -p playbooks tools
    touch ansible.cfg requirements.yml playbooks/{development.yml,production.yml,situational.yml}
  fi
elif [ "$1" = "-r" ]; then
  echo "creating role '$2'"
  projectrole=$2
  project="${projectrole%*/*}"
  role="${projectrole#*/*}"
  dir="$project/roles/$role"
  if [ -d "$dir" ]; then
    echo "it already exists!"
  elif [ ! -d "$project" ]; then
    echo "please specify project!"
  else
    mkdir -p "$dir"
    cd "$dir"
    mkdir -p {tasks,handlers,templates,files,vars,meta,library,module_utils,lookup_plugins}
    touch {tasks,handlers,vars,meta}/main.yml
  fi
else 
  usage
fi