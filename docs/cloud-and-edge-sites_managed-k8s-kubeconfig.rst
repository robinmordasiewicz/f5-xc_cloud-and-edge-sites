Kubeconfig
==========

Download the kubeconfig and install to your client.

.. tabs::

   .. group-tab:: UI

      Navigate to :menuselection:`Cloud and Edge Sites --> Managed K8s --> Overview`, click the |three-dots|  and click :bdg-primary-line:`Download Global Kubeconfig`

      .. image:: images/cloud-and-edge-sites-k8s-cluster-download-kubeconfig.png
         :class: no-scaled-link
         :width: 100%

      #. Provide a unique :menuselection:`Name`
      #. Under :menuselection:`Access --> VoltConsoleAccess` select :menuselection:`Enable VoltConsole API Access`.
      #. In :menuselection:`Cluster Wide Applications` enable :menuselection:`Show Advanced Fields` |toggle|.
      #. Select :menuselection:`Add Cluster Wide Applications`
      #. Under :menuselection:`Add Cluster Wide Applications` click :bdg-primary-line:`Configure`

      .. image:: images/cloud-and-edge-sites-k8s-cluster-configure1.png
         :class: no-scaled-link
         :width: 100%
       
      Click :bdg-primary-line:`Add Item`
        
      .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo1.png
         :class: no-scaled-link
         :width: 100%
       
      Select :menuselection:`Argo CD` and click :bdg-primary-line:`Configure`
        
      .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo2.png
         :class: no-scaled-link
         :width: 100%

      Set :menuselection:`Local Domain` to **localdomain.local**  and click :bdg-primary-line:`Configure`
        
      .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo3.png
         :class: no-scaled-link
         :width: 100%

      Type a unique password and click :bdg-primary:`Blindfold`
        
      .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo4.png
         :class: no-scaled-link
         :width: 100%

      Click :bdg-primary:`Apply`
        
      .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo5.png
         :class: no-scaled-link
         :width: 100%

      Click :bdg-primary:`Apply`
        
      .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo6.png
         :class: no-scaled-link
         :width: 100%

      Click :bdg-primary:`Apply`
        
      .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo7.png
         :class: no-scaled-link
         :width: 100%

      Click :bdg-primary:`Save and Exit`
        
      .. image:: images/cloud-and-edge-sites-k8s-cluster-save-and-exit.png
         :class: no-scaled-link
         :width: 100%
      
   .. group-tab:: vesctl

      Replace highlighted values in :file:`k8s_cluster.json`

      .. literalinclude:: manifests/k8s_cluster.json
         :emphasize-lines: 3
         :language: json

      .. code-block:: console

         $ vesctl configuration create k8s_cluster -i k8s_cluster.json
         Created

      .. literalinclude:: outputs/k8s_cluster.yaml
         :language: yaml


