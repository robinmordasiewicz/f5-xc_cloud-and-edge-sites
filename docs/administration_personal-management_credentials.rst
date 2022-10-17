.. _credentials:

Credentials
===========

.. topic:: Authentication

    The API requests support two types of authentication: API Token and API Certificate. It is recommended to use API certificates as they offer more robust security via Mutual TLS (mTLS) authentication. The API tokens are used with one-way TLS authentication.

Tenant Certificate
------------------

* Select the :guilabel:`Administration` tile on the F5 Distributed Cloud Services home page.

  .. image:: images/home-administration.png
     :class: no-scaled-link
     :width: 100%

* Click :menuselection:`Personal Management --> Credentials` and click :bdg-primary-line:`Add Credentials`

  .. image:: images/administration-personal-management-credentials-add.png
     :class: no-scaled-link
     :width: 100%

* Name your credentials

  .. image:: images/add-credentials.png
     :class: no-scaled-link
     :width: 100%

* Move the cert to workstation

  .. code-block:: console
     :substitutions:
     :caption: Upload cert to workstation

     $ scp -P |workstationsshport| |tenantname|.console.ves.volterra.io.api-creds.p12 |workstationusername|@|workstationhostname|:~/

* Choose to either remove the cert/key passphrase, or set a password environment variable for the cert file

  .. tabs::

     .. tab:: Remove passphrase

        .. code-block:: console
           :substitutions:
           :caption: Create cert

           $ openssl pkcs12 -in ~/|tenantname|.console.ves.volterra.io.api-creds.p12 -nodes -nokeys -out ~/vescred.cert
           Enter Import Password:

        .. code-block:: console
           :substitutions:
           :caption: Create key

           $ openssl pkcs12 -in ~/|tenantname|.console.ves.volterra.io.api-creds.p12 -nodes -nocerts -out ~/vesprivate.key
           Enter Import Password:

        .. code-block:: console
           :substitutions:
           :caption: Create ~/.vesconfig

           $ cat <<EOF > ~/.vesconfig
           $ server-urls: https://|tenantname|.console.ves.volterra.io/api
           $ key: $HOME/vesprivate.key
           $ cert: $HOME/vescred.cert
           $ EOF

     .. tab:: Export passphrase

        .. code-block:: console
           :caption: Enter the cert password and press <enter-key>

           $ read -s VES_P12_PASSWORD

        .. code-block:: console
           :caption: export the password environment variable

           $ export VES_P12_PASSWORD

        .. code-block:: console
           :substitutions:
           :caption: Create ~/.vesconfig

           $ cat <<EOF > ~/.vesconfig
           $ server-urls: https://|tenantname|.console.ves.volterra.io/api
           $ p12-bundle: /home/ubuntu/|tenantname|.console.ves.volterra.io.api-creds.p12
           $ EOF

Tenant API Token
----------------

API requests using the API Token authentication method must provide the token in the Authorization request header. Requests using API Token authentication will have the same RBAC assigned as the user who created the API Token.

.. image:: images/create-api-token.png
   :class: no-scaled-link
   :width: 100%

.. image:: images/api-token-copy.png
   :class: no-scaled-link
   :width: 100%

Github Account
--------------

.. code-block:: console
   :substitutions:
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
   ✓ Logged in as |github-username|

.. code-block:: console
   :substitutions:
   :caption: Configure github settings

   $ git config --global user.email "|github-user-email|"
   $ git config --global user.name "|github-user-name|"

