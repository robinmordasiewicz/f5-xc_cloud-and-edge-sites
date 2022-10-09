Managed K8s
===========

.. topic:: Create K8s Cluster

   Enabling a managed K8s cluster on a Customer Edge instance requires to first create the K8s Cluster object and then apply it during a site creation. It is possible to create a newly managed K8s cluster as part of a site creation process. This lab demonstates creating a K8s cluster before site creation.

.. tabs::

   .. group-tab:: UI

      * Navigate to :menuselection:`Cloud and Edge Sites --> Manage --> Manage K8s --> K8s Clusters` and click :bdg-primary:`Add K8s Cluster`

        .. image:: images/cloud-and-edge-sites-k8s-clusters-add.png
           :class: no-scaled-link
           :width: 100%

      * Fill in the form using the following values.

        #. :menuselection:`Name`: Provide a unique name.
        #. :menuselection:`Access --> VoltConsoleAccess`: select :bdg-primary-line:`Enable VoltConsole API Access`.
        #. :menuselection:`Cluster Wide Applications`: enable Show Advanced Fields :material-regular:`toggle_on;2em;sd-text-primary`
        #. :menuselection:`Cluster Wide Applications --> K8s Cluster Wide Applications`: select :bdg-primary-line:`Add Cluster Wide Applications`
        #. :menuselection:`Cluster Wide Applications --> Add Cluster Wide Applications` click :bdg-primary-line:`Configure >`

        .. image:: images/cloud-and-edge-sites-k8s-cluster-configure1.png
           :class: no-scaled-link
           :width: 100%
       
      * Click :bdg-primary-line:`Add Item`
        
        .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo1.png
           :class: no-scaled-link
           :width: 100%
       
      * Select :bdg-primary-line:`Argo CD` and click :bdg-primary-line:`Configure >`
        
        .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo2.png
           :class: no-scaled-link
           :width: 100%

      * Set :menuselection:`Local Domain` to **localdomain.local**  and click :bdg-primary-line:`Configure >`
        
        .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo3.png
           :class: no-scaled-link
           :width: 100%

      * Type a unique password and click :bdg-primary:`Blindfold`
        
        .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo4.png
           :class: no-scaled-link
           :width: 100%

      * Click :bdg-primary:`Apply`
        
        .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo5.png
           :class: no-scaled-link
           :width: 100%

      * Click :bdg-primary:`Apply`
        
        .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo6.png
           :class: no-scaled-link
           :width: 100%

      * Click :bdg-primary:`Apply`
        
        .. image:: images/cloud-and-edge-sites-k8s-cluster-add-argo7.png
           :class: no-scaled-link
           :width: 100%

      * Click :bdg-primary:`Save and Exit`
        
        .. image:: images/cloud-and-edge-sites-k8s-cluster-save-and-exit.png
           :class: no-scaled-link
           :width: 100%

      * The created K8s cluster appears in the list.
        
        .. image:: images/cloud-and-edge-sites-k8s-clusters-list.png
           :class: no-scaled-link
           :width: 100%
      
   .. group-tab:: vesctl

      * Replace highlighted values in file: :file:`k8s_cluster.json`

        .. literalinclude:: manifests/k8s_cluster.json
           :emphasize-lines: 3
           :language: json

      * Execute the following command to create the k8s cluster object

        .. code-block:: console
 
           $ vesctl configuration create k8s_cluster -i k8s_cluster.json
           Created

      * View the vesctl output

        .. literalinclude:: outputs/k8s_cluster.yaml
           :language: yaml

      * Execute the following command to see the k8s cluster object

        .. code-block:: console

           $ vesctl configuration list k8s_cluster site-name -n system
           +-----------+-----------+--------+
           | NAMESPACE |   NAME    | LABELS |
           +-----------+-----------+--------+
           | system    | site-name | <None> |
           +-----------+-----------+--------+

      * Execute the following command to see the k8s cluster object config in json format

        .. code-block:: console

           $ vesctl configuration get k8s_cluster site-name -n system --outfmt json

