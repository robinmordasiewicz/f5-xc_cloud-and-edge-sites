Accept Registration
===================

.. tabs::

   .. group-tab:: UI

      * In :menuselection:`Cloud and Edge Sites`, navigate to :menuselection:`Manage --> Site Management --> Registrations` and click :material-outlined:`check_box;2em;sd-text-primary`

        .. image:: images/cloud-and-edge-sites_site-management_registration-approve.png
            :class: no-scaled-link
            :width: 100%

      * Review that all fields are populated, an click :bdg-primary:`Save and Exit`

        .. image:: images/cloud-and-edge-sites_site-management_registration-approve_save-and-exit.png
            :class: no-scaled-link
            :width: 100%

      * In :menuselection:`Cloud and Edge Sites`, navigate to :menuselection:`Sites --> Site List`. The site transitions to a **Provisioning** state for ~20 minutes. Go get a :fa:`coffee` and resume when the site is online.

        .. image:: images/cloud-and-edge-sites_site-list.png
            :class: no-scaled-link
            :width: 100%

      * After ~20 minutes the **Customer Edge Admin** console reports :bdg-success:`Provisioned`

        .. image:: images/cloud-and-edge-sites_site-management_deploy-appstack-ce_provisioned.png
            :class: no-scaled-link
            :width: 100%

   .. group-tab:: vesctl

      * View the registrions using vesctl

        .. code-block:: console
  
           $ vesctl configuration get registration -n system
           +-----------+----------------------------------------+------------------------------------+
           | NAMESPACE |                  NAME                  |               LABELS               |
           +-----------+----------------------------------------+------------------------------------+
           | system    | r-616f9b3b-6fdc-4bc4-b979-ccecee7a61ec | map[domain:                        |
           |           |                                        | host-os-version:centos-7-2009-30   |
           |           |                                        | hw-model:standard-pc-q35-ich9-2009 |
           |           |                                        | hw-serial-number: hw-vendor:qemu   |
           |           |                                        | hw-version:pc-q35-3-1              |
           |           |                                        | ves.io/provider:ves-io-UNKNOWN]    |
           +-----------+----------------------------------------+------------------------------------+

      * Get just the registration name value using vesctl

        .. code-block:: console

           $ vesctl configuration list registration -n system --outfmt json | jq '.items' | jq -r '.[0].name'
           r-616f9b3b-6fdc-4bc4-b979-ccecee7a61ec

      * Accept the registration using the name field in the request. Go get a :fa:`coffee` and resume when the site is online.

        .. code-block:: console

           $ vesctl request rpc registration.CustomAPI.RegistrationApprove -i approval_req.json --uri /public/namespaces/system/registration/r-616f9b3b-6fdc-4bc4-b979-ccecee7a61ec/approve --http-method POST

      * After ~20 minutes the site reports :bdg-success:`ONLINE`
 
        .. code-block:: console

           $ vesctl configuration get site site-name -n system --outfmt json | jq -r ".spec.site_state"
           ONLINE

