.. _preparemanifests:

Prepare Manifest
================

.. topic:: Authentication

    The API requests support two types of authentication: API Token and API Certificate. It is recommended to use API certificates as they offer more robust security via Mutual TLS (mTLS) authentication. The API tokens are used with one-way TLS authentication.

Github Account
--------------

.. code-block:: console
   :emphasize-lines: 3,6,10
   :substitutions:
   :caption: Initialize github authentication - get a personal access token from a github account


gh repo fork robinmordasiewicz/f5-xc-iac --clone

   $ gh auth login
   ? What account do you want to log into?  [Use arrows to move, type to filter]
   > GitHub.com
     GitHub Enterprise Server
   ? What is your preferred protocol for Git operations?  [Use arrows to move, type to filter]
   > HTTPS
     SSH
   ? How would you like to authenticate GitHub CLI?  [Use arrows to move, type to filter]
     Login with a web browser
   > Paste an authentication token
     Tip: you can generate a Personal Access Token here https://github.com/settings/tokens
     The minimum required scopes are 'repo', 'read:org', 'workflow'.
   ? Paste your authentication token: ***************************************
   - gh config set -h github.com git_protocol https
   ✓ Configured git protocol
   ✓ Logged in as |githubusername|

.. code-block:: console
   :substitutions:
   :caption: Configure github settings

   $ git config --global user.email "|githubuseremail|"
   $ git config --global user.name "|githubuserfullname|"


