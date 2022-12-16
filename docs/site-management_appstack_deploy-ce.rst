Deploy CE
=========

.. tabs::

   .. group-tab:: UI

      * Using a browser log-in to the CE

        * https://|CE-IP-ADDRESS|:65500
        * default username: **admin**
        * default password: **Volterra123**
          
      * Click :bdg-primary:`Configure Now`
      
        .. image:: images/cloud-and-edge-sites_site-management_deploy-appstack-ce-1.png
            :class: no-scaled-link
            :width: 100%

      * Fill in the form using the following values, and click :bdg-primary`Save configuration`

        #. :menuselection:`Device Configuration --> * Cluster name`: Provide the site cluster name
        #. :menuselection:`Device Configuration --> Hostname`: provide a unique hostname.
        #. :menuselection:`Device Configuration --> Certified Hardware`: select :bdg-primary-line:`kvm-voltstack-combo`
        #. :menuselection:`Location --> Latitude`: provide :bdg-primary-line:`<47.605199>`
        #. :menuselection:`Location --> Longitude`: provide :bdg-primary-line:`<-122.330996>`

        .. image:: images/cloud-and-edge-sites_site-management_deploy-appstack-ce-2.png
           :class: no-scaled-link
           :width: 100%

      * The CE advances to the :bdg-warning:`Approval` stage.

        .. image:: images/cloud-and-edge-sites_site-management_deploy-appstack-ce-3.png
           :class: no-scaled-link
           :width: 100%

   .. group-tab:: console

      * SSH or access the console with default username: **admin** and default password **Volterra123**
   
        .. code-block:: console

           $ ssh admin@10.1.1.5

           UNAUTHORIZED ACCESS TO THIS DEVICE IS PROHIBITED
           All actions performed on this device are audited
           admin@10.1.1.5's password:

           |     $$$$$$\  $$\   $$\                $$$$$$\  $$\       $$$$$$\
           |     $$  __$$\ \__|  $$ |              $$  __$$\ $$ |      \_$$  _|
           |     $$ /  \__|$$\ $$$$$$\    $$$$$$\  $$ /  \__|$$ |        $$ |
           |     \$$$$$$\  $$ |\_$$  _|  $$  __$$\ $$ |      $$ |        $$ |
           |      \____$$\ $$ |  $$ |    $$$$$$$$ |$$ |      $$ |        $$ |
           |     $$\   $$ |$$ |  $$ |$$\ $$   ____|$$ |  $$\ $$ |        $$ |
           |     \$$$$$$  |$$ |  \$$$$  |\$$$$$$$\ \$$$$$$  |$$$$$$$$\ $$$$$$\
           |      \______/ \__|   \____/  \_______| \______/ \________|\______|
           WELCOME IN SITE CLI
           This allows to:
           - configure registration information
           - factory reset of the Node
           - collect debug information for support
           Use TAB to select various options.

      * Enter command: **configure**

        #. Enter token from `token link`
        #. Enter the <site-name>
        #. Enter the <host-name>
        #. Enter latitude and longitude
        #. Leave **fleet name** ``empty``
        #. Select certified hardware: **kvm-volstack-combo**

        .. code-block:: console

           $ configure
           ? What is your token? bd42d5f5-a2a1-4bf3-b493-94b19de1c858
           ? What is your site name? [optional] site-name
           ? What is your hostname? [optional] node-name
           ? What is your latitude? [optional] 47.605199
           ? What is your longitude? [optional] -122.330996
           ? What is your default fleet name? [optional]
           ? Select certified hardware: kvm-volstack-combo
           ? Select primary outside NIC: eth0
           certifiedHardware: kvm-volstack-combo
           clusterName: site-name
           hostname: node-name
           latitude: 47.605198
           longitude: -122.33099
           primaryOutsideNic: eth0
           token: bd42d5f5-a2a1-4bf3-b493-94b19de1c858
           ? Confirm configuration? Yes

   .. group-tab:: curl

      * Edit the :file:`ce-register.json` and change values

        .. literalinclude:: ../manifests/ce-register.json
           :language: json

      * Run the following curl command to remotely configure the CE node.

        .. code-block:: console

           $ curl -k \
             -u "admin:Volterra123" \
             -H 'Content-Type: application/json' \
             -d @ce-register.json \
             https://10.1.1.5:65500/api/ves.io.vpm/introspect/write/ves.io.vpm.config/update


