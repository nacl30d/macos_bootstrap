#!/usr/bin/env bash

GIT_REPO="https://github.com/d-salt/macos_bootstrap"
GIT_DIR="${HOME}/.macos_bootstrap"

: "Install ansible" && {
    if type ansible > /dev/null 2>&1; then
        echo 'You have already install ansible!'
    else
        if ! type pip > /dev/null 2>&1; then
            curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
            python get-pip.py --user
        fi

        sudo pip install ansible

        if ! type ansible > /dev/null 2>&1; then
            echo 'Error: Faild to install ansible'
            exit 1;
        fi
    fi
    }

: "Download Ansible Playbooks" && {
    if type git > /dev/null 2>&1; then
        git clone ${GIT_REPO}.git ${GIT_DIR}
    elif type curl > /dev/null 2>&1; then
        curl -LO ${GIT_REPO}/archive/master.tar.gz
        tar zxvf master.tar.gz ${GIT_DIR}
    else
        echo 'Required: git or curl'
        exit 1;
    fi
}

: "Run Ansible Palybook" && {
    cd ${GIT_DIR}
    ansible-playbook main.yml -i inventory/hosts    
}
