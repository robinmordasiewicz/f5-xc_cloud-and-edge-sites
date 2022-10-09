Site Tokens
===========

.. tabs::

   .. group-tab:: UI

      #. Navigate to :menuselection:`Manage --> Site Management --> Site Tokens` and click :bdg-primary-line:`Add K8s Cluster`

         .. image:: images/cloud-and-edge-sites-site-token-add.png
            :width: 800px

      #. Name the token, and click :bdg-primary:`Add Site Tokenn`

         .. image:: images/cloud-and-edge-sites-site-token-create.png
            :width: 800px

      #. The site token appears with the :menuselection:`UID` field, copy this value for registering the CE node.

         .. image:: images/cloud-and-edge-sites-site-token-results.png
            :width: 800px

   .. group-tab:: vesctl

      Replace highlighted values in :file:`token.json`

      .. literalinclude:: manifests/token.json
         :emphasize-lines: 3
         :language: json

      .. code-block:: console

         $ vesctl configuration create token -i token.json
         Created

      **vesctl command output**

      .. literalinclude:: outputs/token.yaml
         :emphasize-lines: 22
         :language: yaml
      
      **The site token appears with the UID field, copy this value for registering the CE node in subsequent steps**

