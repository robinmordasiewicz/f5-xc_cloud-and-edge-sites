.. _prerequisites:
:sd_hide_title:

Pre-Requisites
==============

.. topic:: Pre-Requisites

    Install command line tools, certificates, and token

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
         :caption: Initialize github authentication - get a personal access token from your github account

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

         $ git config --global user.email "you@example.com"
         $ git config --global user.name "Your Name"

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


Authentication
--------------

The API requests support two types of authentication: API Token and API Certificate. It is recommended to use API certificates as they offer more robust security via Mutual TLS (mTLS) authentication. The API tokens are used with one-way TLS authentication.

Certificate
^^^^^^^^^^^

#. Select the :guilabel:`Administration` tile on the F5 Distributed Cloud Services home page.

   .. image:: images/home-administration.png
      :class: no-scaled-link
      :width: 100%

#. Click :menuselection:`Personal Management --> Credentials` and click :bdg-primary-line:`Add Credentials`

   .. image:: images/administration-personal-management-credentials-add.png
      :class: no-scaled-link
      :width: 100%

#. Name your credentials

   .. image:: images/add-credentials.png
      :class: no-scaled-link
      :width: 100%

#. Install cert

   .. code-block:: console
      :caption: Upload cert to jumpbox

      $ scp -P 47000 ~/Downloads/f5-xc-lab-app.console.ves.volterra.io.api-creds-2.p12 ubuntu@<your-jumpbox-hostname>.access.udf.f5.com:~/


   .. tabs::

      .. tab:: export passphrase

         .. code-block:: console
            :caption: Enter your password and press <enter-key>

            $ read -s VES_P12_PASSWORD

         .. code-block:: console

            $ export VES_P12_PASSWORD

         .. code-block:: console
            :caption: ~/.vesconfig

            $ cat <<EOF >> ~/.vesconfig
            $ server-urls: https://f5-xc-lab-app.console.ves.volterra.io/api
            $ key: /home/ubuntu/vesprivate.key
            $ cert: /home/ubuntu/vescred.cert
            $ EOF

         .. code-block:: console
            :caption: vesctl commmand

            $ vesctl cfg list namespace -n system

      .. tab:: strip passphrase

         .. code-block:: console
            :caption: Create cert

            $ openssl pkcs12 -in ~/f5-xc-lab-app.console.ves.volterra.io.api-creds.p12 -nodes -nokeys -out ~/vescred.cert
            Enter Import Password:

         .. code-block:: console
            :caption: Create key

            $ openssl pkcs12 -in ~/f5-xc-lab-app.console.ves.volterra.io.api-creds.p12 -nodes -nocerts -out ~/vesprivate.key
            Enter Import Password:

         .. code-block:: console
            :caption: ~/.vesconfig

            $ cat <<EOF >> ~/.vesconfig
            $ server-urls: https://acmecorp.console.ves.volterra.io/api
            $ p12-bundle: /home/ubuntu/acmecorp.console.ves.volterra.io.volterra.us/api
            $ EOF

         .. code-block:: console
            :caption: vesctl commmand

            $ vesctl cfg list namespace -n system

API Token
^^^^^^^^^

API requests using the API Token authentication method must provide the token in the Authorization request header. Requests using API Token authentication will have the same RBAC assigned as the user who created the API Token.

.. image:: images/create-api-token.png
   :class: no-scaled-link
   :width: 100%

.. image:: images/api-token-copy.png
   :class: no-scaled-link
   :width: 100%

.. code-block:: console
   :caption: curl to api endpoint

   $ curl https://f5-xc-lab-app.console.ves.volterra.io/api/web/namespaces -H "Authorization: APIToken H7RD1JKWZtM7BUd677s0fzGVxbY="
   $ curl https://f5-xc-lab-app.console.ves.volterra.io/api/config/namespaces/system/sites -H "Authorization: APIToken H7RD1JKWZtM7BUd677s0fzGVxbY="


