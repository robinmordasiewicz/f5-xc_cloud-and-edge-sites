Managed K8s
===========

In order to publish our application to the Internet we will need to first understand how Managed k8s is viewed in the UI and CLI and then create the managed k8s resources including namespace, deployment, and service.  

Once that is complete we can publish the application to the internet by creating the origin pool and an HTTP Load Balancer.

In this lab, we will learn the following:

•  How to view and work with Managed K8s in the Console and global kubeconfig file to access and deploy publish a web server across the ADN to the Internet.

Log into F5 Distributed Cloud Console
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#. Click the Cloud and Edge Sites tile on the F5 Distributed Cloud Services home page.

   .. image:: images/xchomepage.png
      :width: 800px

#. Click Overview under Managed K8s on the left hand pane.

   .. image:: images/managedk8s.png
      :width: 250pt

#. Pick a Site and click the three dots under the "Action" column and then Download Global Kubeconfig.

   .. image:: images/globalkubeconfig.png
      :width: 800px

#. Locate your downloaded kubeconfig file, and follow the Kubernetes documentation to configure your local kubectl tool. 

   `Organizing Cluster Access Using kubeconfig Files <https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/>`_

#. Once you have configured your local kubectl tool, you should be able to manage for your managed k8s site using kubectl commands.

Viewing the K8s Cluster in UI and CLI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#. In XC Console Click on the Managed K8s Site you are working in, and view the following in the UI Dashboard, Nodes, Namespaces, Deployments, Services, and Pods

   .. image:: images/dasboard.png
      :width: 800px

   .. image:: images/nodes.png
      :width: 800px

   .. image:: images/namespaces.png
      :width: 800px

   .. image:: images/deployments.png
      :width: 800px

   .. image:: images/services.png
      :width: 800px
   
   .. image:: images/pods.png
      :width: 800px

CLI Commands to view Managed K8s Outputs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*Commands*
`Run the following commands and view the outputs.`

*View Nodes*

.. code-block:: console

   $ kubectl get nodes
   
.. code-block:: console

   $ kubectl get nodes -o wide

*View pods*

.. code-block:: console

   $ kubectl get pods -A
   $ kubectl get pods -o wide
   $ kubectl describe pod <podname> -n (namespace)
   
*View all deployment and service*

.. code-block:: console

   $ kubectl get deployment -A
   $ kubectl get svc -A

*View all resources*

.. code-block:: console

   $ kubectl get all -A
   
Deploy a Web Server to the Managed K8s Cluster
----------------------------------------------

In this lab, we will learn the following:

•  Deploy a Managed K8s workload utilizing a containerized app from a public registry

•  Deploy to the Managed K8s site

#. Goto the following repo and either clone or copy and paste the deployment manifest from the below link into a directory on your local machine. 

    `Web-Server-for-XC-Managed-K8s-Training <https://github.com/Nettas/Web-Server-for-XC-Managed-K8s-Training/blob/main/AppStack-GCP/server-deployment/deployment.yaml/>`_

#. Utlizing the Global kubeconfig deploy the manifest.

   *Change to the directory where you saved the Deployment File and Apply it*
      `kubectl apply -f "filename.yaml"`
   
#. Validate all resources were deployed

   *From UI follow the same steps from Lab1 Excercise 2.  Just search for resources in your created namespace*

   *From CLI just append with your created namespace*

   *Namespace*

   .. code-block:: console

      $ kubectl get namespace

   *Deployment*

   .. code-block:: console

      $ kubectl get deployment -n "namespace"

   *Pods*

   .. code-block:: console

      $ kubectl get pods -n "namespace"

   *Service*

   .. code-block:: console

      $ kubectl get svc -n "namespace"

   *Get All resources for the Namespace you created*

   .. code-block:: console

      $ kubectl get all -n "namespace"

Create Origin Pool
------------------

#. Navigate the left-side menu to ``Manage`` > ``Load Balancers``, then click ``Origin Pools``.

   .. image:: images/m-origin-pool.png
      :width: 800px
   
#. Click the **Add Origin Pool** button.

   .. image:: images/m3-add-origin-pools.png
      :width: 800px

#. On the New Origin Pool form:

   * Enter a **Name** for your pool (use the namespace you created i.e. s-iannetta)
   * Replace the **Port** value of *443* with *80*
   * Select **Add Item** under **Origin Servers**

   .. image:: images/m-origin-pool-name.png
      :width: 800px

#. Complete the **Origin Server** section by make the following changes, and click |add-item| and |save-and-exit| to close the **Origin Pool** dialogue.

   * **Select Type of Origin Server**: K8s Service Name of Origin Server on given Sites
   * **Service Name**: workloadname.namespace (make a note to remember this in creation stage)
   * **Site or Virtual Site**: Site select system/agility-vpc-site-one, two, or three depending on which site you selected for managedk8s
   * **Select Network on the site**: Outside Network

   .. image:: images/origin-pool.png
      :width: 800px
 
Publish to the Internet
-----------------------

#. Navigate the left-side menu to ``Manage`` > ``Load Balancers`` -> ``HTTP Load Balancers``, then click **Add HTTP Load Balancer**.

   .. image:: images/m-add-http.png
      :width: 800px
   
#. Enter a name for your HTTP Load Balancer in the **Metadata**.

   .. image:: images/m-http-name.png
      :width: 800px

#. In the **Basic Configuration** Section make the following changes:

   * **List of Domains**: <assigned-namespace>.lab-app.f5demos.com
   * **Select Type of Load Balancer**: HTTPS with Automatic Certificate
   * **Select Type of Load Balancer**: Checked

   .. image:: images/m-http-basic.png
      :width: 800px

#. In the **Default Origin Servers** Section click |add-item|

   .. image:: images/m-add-origin-server.png
      :width: 800px

#. Select your **Origin Pool**, which was created earlier in this lab, and Click |add-item|

   .. image:: images/m-select-origin-pool.png
      :width: 800px

#. In the Security Configuration section change the **Security Policies** to **"Do Not Apply Service Policies"** then click |save-and-exit|

   .. image:: images/m-security-configuration.png
      :width: 800px
   
#. After a few moments you should see a screen like the following:

   .. image:: images/m-http-status.png
      :width: 800px

.. note::
  - Please wait for the VIRTUAL_HOST_READY and Valid certificate status before proceeding

Now we are ready to test!

Open a browser tab and navigate to the domain you entered. 

In the example below it is *flying-ox.lab-app.f5demos.com*

Success will render a page like the following:

.. image:: images/websrv_output.png
   :width: 800px

.. |save-and-exit| image:: images/save-and-exit.png
   :height: 24px

.. |add-item| image:: images/add-item.png
   :height: 24px

.. |apply| image:: images/apply.png
   :height: 24px
