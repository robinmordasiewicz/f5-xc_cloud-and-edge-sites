.. _install-tools:

:sd_hide_title:

Install Tools
==============

.. topic:: Install software tools

    Install software tools.

Tools
-----

.. tabs::

   .. tab:: kubectl

      .. code-block:: console
         :caption: Install kubectl

         $ sudo apt-get update
         $ sudo apt-get install -y ca-certificates curl
         $ sudo apt-get install -y apt-transport-https
         $ sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
         $ echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
         $ sudo apt-get update
         $ sudo apt-get install -y kubectl
         $ kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
         $

   .. tab:: vesctl

      .. code-block:: console
         :caption: Install vesctl

         $ curl -LO "https://vesio.azureedge.net/releases/vesctl/$(curl -s https://downloads.volterra.io/releases/vesctl/latest.txt)/vesctl.linux-amd64.gz"
         $ gunzip vesctl.linux-amd64.gz
         $ sudo mv vesctl.linux-amd64 /usr/local/bin/vesctl
         $ sudo chown root:root /usr/local/bin/vesctl
         $ sudo chmod 755 /usr/local/bin/vesctl
         $ vesctl completion bash | sudo tee /etc/bash_completion.d/vesctl > /dev/null
         $

   .. tab:: terraform

      * https://www.terraform.io/cli/install/apt
      * https://developer.hashicorp.com/terraform/downloads
      * https://registry.terraform.io/providers/volterraedge/volterra/latest
      * https://github.com/f5devcentral/terraform-volterra
      * https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/volterra_voltstack_site
      * https://registry.terraform.io/providers/volterraedge/volterra/latest/docs/resources/volterra_k8s_cluster
      * https://github.com/f5devcentral/f5-professional-services/blob/main/examples/f5-distributed-cloud/terraform/single-protected-app/main.tf

      .. code-block:: console
         :caption: Install terraform
 
         $ sudo apt update
         $ sudo apt -y install software-properties-common gnupg2 curl
         $ wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
         $ echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
         $ sudo apt update && sudo apt install terraform
         $

   .. tab:: utilities

      .. code-block:: console
         :caption: Install jq yamllint
 
         $ sudo apt update
         $ sudo apt -y install jq
         $ sudo snap install yq
         $ sudo apt-get install -y yamllint

   .. tab:: gh

      .. code-block:: console
         :caption: Install gh

         $ type -p curl >/dev/null || sudo apt install curl -y
         $ curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
         $ sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
         $ echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
         $ sudo apt update \
         $ sudo apt install gh -y
         $

      .. code-block:: console
         :caption: Initialize github authentication - get a personal access token from a github account

         $ gh auth login
         ? What account do you want to log into? GitHub.com
         ? What is your preferred protocol for Git operations? HTTPS
         ? Authenticate Git with your GitHub credentials? Yes
         ? How would you like to authenticate GitHub CLI? Paste an authentication token
         Tip: you can generate a Personal Access Token here https://github.com/settings/tokens
         The minimum required scopes are 'repo', 'read:org', 'workflow'.
         ? Paste your authentication token: ****************************************
         - gh config set -h github.com git_protocol https
         ✓ Configured git protocol
         ✓ Logged in as <github-username>

      .. code-block:: console
         :caption: Configure github settings

         $ git config --global user.email "email@example.com"
         $ git config --global user.name "FirstName LastName"

   .. tab:: powerline

      .. code-block:: console
         :caption: Install powerline

         $ sudo add-apt-repository universe
         $ sudo apt install --yes powerline
         $

      .. code-block:: console
         :caption: Confgure bash prompt

         $ echo 'powerline-daemon -q' >> $HOME/.bashrc
         $ echo 'POWERLINE_BASH_CONTINUATION=1' >> $HOME/.bashrc
         $ echo 'POWERLINE_BASH_SELECT=1' >> $HOME/.bashrc
         $ echo 'source /usr/share/powerline/bindings/bash/powerline.sh' >> $HOME/.bashrc
         $

      .. code-block:: console
         :caption: Confgure vim

         $ echo 'python3 from powerline.vim import setup as powerline_setup' >> $HOME/.vimrc
         $ echo 'python3 powerline_setup()' >> $HOME/.vimrc
         $ echo 'python3 del powerline_setup' >> $HOME/.vimrc
         $ echo 'set laststatus=2' >> $HOME/.vimrc

   .. tab:: moreutils

      .. code-block:: console
         :caption: Install to use sponge

         $ sudo apt get install --yes moreutils



