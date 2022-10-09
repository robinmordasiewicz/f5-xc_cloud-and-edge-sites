Kubeconfig
==========

Download the kubeconfig and install to your client.

.. tabs::

   .. group-tab:: UI

      Navigate to :menuselection:`Cloud and Edge Sites --> Managed K8s --> Overview`, click the |three-dots|  and click :bdg-primary-line:`Download Global Kubeconfig`

      .. image:: images/cloud-and-edge-sites-k8s-cluster-download-kubeconfig.png
         :width: 800px

      #. Provide a unique :menuselection:`Name`
      #. Under :menuselection:`Access --> VoltConsoleAccess` select :menuselection:`Enable VoltConsole API Access`.
      #. In :menuselection:`Cluster Wide Applications` enable :menuselection:`Show Advanced Fields` |toggle|.
      #. Select :menuselection:`Add Cluster Wide Applications`
      #. Under :menuselection:`Add Cluster Wide Applications` click :bdg-primary-line:`Configure`

      .. image:: images/cloud-and-edge-sites-k8s-cluster-configure1.png
         :width: 800px
       
      Click :bdg-primary-line:`Add Item`
        
      .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo1.png
         :width: 800px
       
      Select :menuselection:`Argo CD` and click :bdg-primary-line:`Configure`
        
      .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo2.png
         :width: 800px

      Set :menuselection:`Local Domain` to **localdomain.local**  and click :bdg-primary-line:`Configure`
        
      .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo3.png
         :width: 800px

      Type a unique password and click :bdg-primary:`Blindfold`
        
      .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo4.png
         :width: 800px

      Click :bdg-primary:`Apply`
        
      .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo5.png
         :width: 800px

      Click :bdg-primary:`Apply`
        
      .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo6.png
         :width: 800px

      Click :bdg-primary:`Apply`
        
      .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo7.png
         :width: 800px

      Click :bdg-primary:`Save and Exit`
        
      .. image:: images/cloud-and-edge-sites-k8s-cluster-save-and-exit.png
         :width: 800px
      
   .. group-tab:: vesctl

      Replace highlighted values in :file:`k8s_cluster.json`

      .. literalinclude:: manifests/k8s_cluster.json
         :emphasize-lines: 3
         :language: json

      .. code-block:: console

         $ vesctl configuration create k8s_cluster -i k8s_cluster.json
         Created

      .. literalinclude:: manifests/k8s_cluster-created.yaml
         :language: yaml


