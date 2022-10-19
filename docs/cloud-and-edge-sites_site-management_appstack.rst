Datacenter Edge
===============

**Create Appstack Site**

.. tabs::

   .. group-tab:: UI

      * In :menuselection:`Cloud and Edge Sites`, navigate to :menuselection:`Manage --> Site Management --> App Stack Sites` and click :bdg-primary:`Add App Stack Site`

        .. image:: images/cloud-and-edge-sites_site-management_add-appstack-site.png
           :class: no-scaled-link
           :width: 100%

      * Fill in the form using the following values, and click |save-and-exit|

        #. :menuselection:`Name`: Provide a unique :bdg-primary-line:`<site-name>`
        #. :menuselection:`Basic Configuration --> Generic Server Certified Hardware`: select :bdg-primary-line:`kvm-voltstack-combo`.
        #. :menuselection:`Basic Configuration --> Order Master Node`: enter a unique :bdg-primary-line:`<node-name>`.
        #. :menuselection:`Basic Configuration --> Geographic Address`: enter a :bdg-primary-line:`<Geographic Address>`.
        #. :menuselection:`Basic Configuration --> Coordinates --> Latitude`: enter site coordinates :bdg-primary-line:`<47.605199>`.
        #. :menuselection:`Basic Configuration --> Coordinates --> Longitude`: enter site coordinates :bdg-primary-line:`<-122.330996>`.

        .. image:: images/cloud-and-edge-sites_site-management_add-appstack-site_save-and-exit.png
           :class: no-scaled-link
           :width: 100%

      * The site appears in the list and indicates **Waiting for Registration**

        .. image:: images/cloud-and-edge-sites_site-management_list-appstack-site.png
           :class: no-scaled-link
           :width: 100%

   .. group-tab:: vesctl

      Replace highlighted values in :file:`appstack_site.json`

      .. literalinclude:: ../manifests/appstack_site.json
         :language: yaml
         :emphasize-lines: 3,14,20,22,23,27

      .. code-block:: console

         $ vesctl configuration apply voltstack_site -i appstack_site.json
         Created

      **vesctl command output**

      .. literalinclude:: outputs/appstack_site.yaml
         :language: yaml

      * Execute the following command to see the appstack object

        .. code-block:: console

           $ vesctl configuration list voltstack_site site-name -n system
           +-----------+-----------+--------+
           | NAMESPACE |   NAME    | LABELS |
           +-----------+-----------+--------+
           | system    | site-name | <None> |
           +-----------+-----------+--------+

      * Execute the following command to see the appstack site object config in json format

        .. code-block:: console

           $ vesctl configuration get voltstack_site site-name -n system --outfmt json

        Notice the site is **Waiting for Registration**

        .. literalinclude:: outputs/appstack_site.json
           :emphasize-lines: 67
           :language: json

