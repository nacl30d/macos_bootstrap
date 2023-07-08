#!/usr/bin/env bash

GIT_REPO="https://github.com/nacl30d/macos_bootstrap"
GIT_DIR="${HOME}/.macos_bootstrap"

: "Install ansible" && {
    if type ansible > /dev/null 2>&1; then
        echo 'You have already install ansible!'
    else
        if type pip3 > /dev/null 2>&1; then
            PIPCMD=pip3
        elif ! type pip > /dev/null 2>&1; then
            curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
            python get-pip.py --user
            PIPCMD=pip
        fi

        xcode-select --install # looks like it's required xcode-select to run pip

        sudo ${PIPCMD} install ansible

        if ! type ansible > /dev/null 2>&1; then
            echo 'Error: Faild to install ansible'
            exit 1;
        fi
    fi
    }

: "Download Ansible Playbooks" && {
    if type git > /dev/null 2>&1; then
        if -d ${GIT_DIR}; then
            cd ${GIT_DIR}
            git pull
        else
            git clone ${GIT_REPO}.git ${GIT_DIR}
        fi
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
