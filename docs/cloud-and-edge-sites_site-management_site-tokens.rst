Site Tokens
===========

.. tabs::

   .. group-tab:: UI

      #. Navigate to :menuselection:`Manage --> Site Management --> Site Tokens` and click :bdg-primary-line:`Add K8s Cluster`

         .. image:: images/cloud-and-edge-sites-site-token-add.png
            :class: no-scaled-link
            :width: 100%

      #. Name the token, and click :bdg-primary:`Add Site Token`

         .. image:: images/cloud-and-edge-sites-site-token-create.png
            :class: no-scaled-link
            :width: 100%

      #. The site token appears with the :menuselection:`UID` field, copy this value for registering the CE node.

         .. image:: images/cloud-and-edge-sites-site-token-results.png
            :class: no-scaled-link
            :width: 100%

   .. group-tab:: vesctl

      Replace highlighted values in :file:`token.json`

      .. literalinclude:: manifests/token.json
         :emphasize-lines: 3
         :language: json

      .. code-block:: console

         $ vesctl configuration apply token -i token.json
         Created

      **vesctl command output**

      .. literalinclude:: outputs/token.yaml
         :emphasize-lines: 22
         :language: yaml
      
      .. code-block:: console

         $ vesctl configuration list token -n system
         +-----------+---------------------+--------+
         | NAMESPACE |        NAME         | LABELS |
         +-----------+---------------------+--------+
         | system    | site-name-token     | <None> |
         +-----------+---------------------+--------+

      **The site token appears with the UID field, copy this value for registering the CE node in subsequent steps**

      .. code-block:: console

         $ vesctl configuration get token site-token --outfmt json -n system | jq -r ".system_metadata.uid"
         be4204f5-a2a1-4bf3-b493-86753091c858

