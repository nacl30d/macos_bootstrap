#!/usr/bin/env bash

GIT_REPO="https://github.com/nacl30d/macos_bootstrap"
GIT_DIR="${HOME}/.macos_bootstrap"

: "Meet pre-requirements" && {
    if ! xcode-select --install 2>&1 | grep -q "already installed"; then
        echo "Find installation dialog and install xcode-select."
        exit 1;
    fi
}

: "Download Ansible Playbooks" && {
    if type git > /dev/null 2>&1; then
        if [ -d "${GIT_DIR}" ]; then
            cd "${GIT_DIR}"
            git pull --no-ff
        else
            git clone "${GIT_REPO}.git" "${GIT_DIR}"
        fi
    elif type curl > /dev/null 2>&1; then
        curl -LO "${GIT_REPO}/archive/master.tar.gz"
        tar zxvf master.tar.gz "${GIT_DIR}"
    else
        echo 'Required: git or curl'
        exit 1;
    fi
}

: "Into working directory" && {
    cd "${GIT_DIR}" || (echo "ERROR: Unknown directory '${GIT_DIR}'" && exit 1)
}

: "Install ansible" && {
    if type ansible > /dev/null 2>&1; then
        echo 'You have already install ansible!'
    else
        if ! type python3 > /dev/null 2>&1; then
            echo "ERROR: python3 not found."
            exit 1;
        fi

        # Setup virtual environment
        python3 -m venv "${GIT_DIR}"
        source "${GIT_DIR}/bin/activate"

        if ! type pip3 > /dev/null 2>&1; then
            echo "ERROR: pip3 not found."
            exit 1;
        fi

        pip3 install ansible

        if ! type ansible > /dev/null 2>&1; then
            echo 'Error: Faild to install ansible'
            exit 1;
        fi
    fi
}

: "Run Ansible Palybook" && {
    ansible-playbook main.yml -i inventory/hosts
}
