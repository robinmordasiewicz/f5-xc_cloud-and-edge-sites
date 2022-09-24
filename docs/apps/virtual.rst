Virtual K8s
===========

vK8s objects have a reference to the virtual-site which selects the sites on which the application can be deployed, secured, and operated.  The virtual-site reference of vK8s is used as the default virtual-site for the given vK8s.

Configure a Virtual k8s cluster, deploy and scale a containerized workload from a private registry.

Workload is used to configure and deploy a workload in Virtual Kubernetes. A workload may be part of an application. Workload encapsulates all the operational characteristics of Kubernetes workload, storage, and network objects (deployments, statefulsets, jobs, persistent volume claims, configmaps, secrets, and services) configuration, as well as configuration related to where the workload is deployed and how it is advertised using L7 or L4 load balancers. A workload can be one of simple service, service, stateful service or job. Services are long running workloads like web servers, databases, etc. and jobs are run to completion workloads. Services and jobs can be deployed on regional edges or customer sites. Services can be exposed in-cluster or on Internet by L7 or L4 load balancer or on sites using an advertise policy.

A service with one or more containers with configurable number of replicas that can be deployed on a selection of Regional Edge sites or customer sites and advertised within the cluster where is it deployed, on the Internet, or on other sites using TCP or HTTP or HTTPS load balancer.

For more core concepts, please review `F5 Distributed Cloud documentation <https://docs.cloud.f5.com/docs/ves-concepts/dist-app-mgmt>`_

..  contents:: The following topics will be covered in this lab.
    :local:
    :backlinks: none
    :depth: 1

Create Cluster
--------------

Create a Virtual Kubernetes Cluster on a Virtual Site.

Sites and Virtual Sites
^^^^^^^^^^^^^^^^^^^^^^^

#. Select the ``Distributed Apps`` tile on the F5 Distributed Cloud Services home page.

   .. image:: images/distributedappclick.png
      :width: 800px

#. Within the Distributed Apps side menu and under ``Manage``, click ``Virtual Sites``. A Virtual site has been pre-configured for the lab and shared to all students. The Virtual site **agility-k8s-vsite** contains three customer edge sites.

   .. image:: images/manage-virtualsites.png
      :width: 800px

Create Virtual k8s
^^^^^^^^^^^^^^^^^^

#. Click ``Applications`` > ``Virtual K8s``, and then click |add-virtual-K8s|

   .. image:: images/distributedappclickaddvirtualk8s.png
      :width: 800px

#. Enter the site **Name** using your Firstname initial and Lastname and append **-vk8s** at the end. Ex: For Andrew Smith, the site name will be **asmith-vk8s**, then click |add-item|

   .. image:: images/distributedappclickvirtualk8ssettings.png
      :width: 800px

#. Under ``Virtual Sites`` select **agility-k8s-vsite**, then |save-and-exit|

   .. image:: images/distributedappclickvirtualk8ssettings2.png
      :width: 800px

   .. warning:: Virtual K8s "|create-in-progress|" may take five minutes to complete

   .. image:: images/distributedappclickvirtualk8screate-in-progress.png
      :width: 800px


Deploy Workload
---------------

#. When Virtual K8s shows as "|ready|", click the virtual site to display details.

   .. image:: images/distributedappclickvirtualk8sready.png
      :width: 800px

#. Click ``Workloads`` in the properties tab, and then click |Add-VK8s-Workload|

   .. image:: images/apps-vk8s-add-vk8s-workload.png
      :width: 800px

Container Service
^^^^^^^^^^^^^^^^^

#. Complete the **Metadata** section by providing a **Name**, then select **Service** from the **Type of Workload** list. Next, select **Configure** within the **Service** sub-section.

   .. image:: images/vk8s-workload-create-workload-configure.png
      :width: 800px

#. Select |add-item| within the **Containers** section.

   .. image:: images/6add_container.png
      :width: 800px

#. Complete the **Container Configuration** section by providing a **Name** and details for which image to use.

   * **Name**: asmith-container 
   * **Image Name**: coleman.azurecr.io/f5xcdemoapp
   * **Container Registry**: Private Registry
   * **Private Registry**: shared/azure-registry

   .. image:: images/7container_config.png
      :width: 800px

Associate to Virtual Site
^^^^^^^^^^^^^^^^^^^^^^^^^

#. Within the **Deploy Options** section, set **Where to Deploy the Workload** to *Customer Virtual Sites*, then **Configure** within the **Customer Virtual Sites** section.

   .. image:: images/8deploy_options.png
      :width: 800px

#. Select your vK8s site name from **List of Virtual Sites to Deploy**, then |apply|

   .. image:: images/9select_customer_site.png
      :width: 800px

Service Advertisement
^^^^^^^^^^^^^^^^^^^^^

#. Within the **Advertise Options** section, set **Options to Advertise the Workload** to *Advertise in Cluster*, then select **Configure** within the **Advertise in Cluster** section.

   .. image:: images/10select_advertise_options.png
      :width: 800px

#. Within the **Select Port to Advertise** section, set **Select Port to Advertise** to *Port*, click |apply| and then |save-and-exit|

   - **Port**: 3000
   - **Application Protocol**: HTTP

   .. image:: images/11set_advertise_port.png
      :width: 800px

#. The workload has been added. The vsite that vk8s is deployed on consists of 3 sites, so there are 3 pods in total.

   .. image:: images/12verify_3_workload_sites_pods.png
      :width: 800px

Scale Deployment
----------------

Modify Virtual K8s Deployment to Scale Replicas.

#. Select ``Deployments``, then select the menu under **Actions** for your deployment, then ``Edit``

   .. image:: images/14edit_deployment.png
      :width: 800px

#. Ensure **Edit** mode is enabled, expand the **spec** section, and modify **replicas** from *1* to *3* and select **Save**

   .. image:: images/15modify_deployment_spec.png
      :width: 800px

Review Scaled vK8s Deployment
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#. It may take a few moments, but on the vK8s cluster dashboard, number of **Running Pods** should increase to 9. Upon refreshing the list, you may notice the number of **Sites with Error** gradually decrease as **Running Pods** increases.

   .. image:: images/16review_scaled_deployment.png
      :width: 800px

View Results with kubectl
-------------------------

kubectl may be used to manage Virtual k8s.

Install kubectl
^^^^^^^^^^^^^^^

Insert instructions to install kubectl

Configure kubeconfig
^^^^^^^^^^^^^^^^^^^^

Download the kubeconfig file to access virtual k8s.

#. Click the distributed apps tile on the F5 Distributed Cloud Services home page.

   .. image:: images/distributedappclick.png
      :width: 800px

#. Click virtual K8s under the applications section.

   .. image:: images/distributedappclickvirtualk8s.png
      :width: 250pt

#. Click the three dots under the "Action" column and then click Kubeconfig.

   .. image:: images/distributedappclickvirtualk8kubeconfig.png
      :width: 800px

#. Click the config kubeconfig is downloaded, and follow the Kubernetes documentation to configure your local kubctl tool. 

   `Organizing Cluster Access Using kubeconfig Files <https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/>`_

kubectl commands
^^^^^^^^^^^^^^^^

Run the following commands and view the outputs.  Why are there different outputs before and after increasing the replicas?

*View Nodes*

.. code-block:: console

   $ kubectl get nodes
   $ kubectl get nodes -o wide
   
*View pods*

.. code-block:: console
 
   $ kubectl get pods
   $ kubectl get pods -o wide
   $ kubectl describe pod <podname>
   
*View deployment and service*

.. code-block:: console

   $ kubectl get deployment agility
   $ kubectl get svc agility

*View all resources in your namespace*

.. code-block:: console

   $ kubectl get all

*View output of the pod in yaml format*

.. code-block:: console

   $ kubectl get pods <podname> -o yaml
 
*View output of the deployment in yaml format*

.. code-block:: console

   $ kubectl get deployment agility -o yaml

*View output of the service in yaml format*

.. code-block:: console

   $ kubectl get svc agility -o yaml
   
*Save the output of the deployment in yaml format*

.. code-block:: console

   $ kubectl get deployment -o yaml > agility.yaml

*View the saved yaml deployment*

.. code-block:: console

    $ cat agility.yaml

Advertise on the Internet
-------------------------

In order to view the kubernetes workload with a browser, create an HTTP-LB to advertise the site on the internet.

Create Origin Pool
^^^^^^^^^^^^^^^^^^

#. Navigate the left-side menu to ``Manage`` > ``Load Balancers``, then click ``Origin Pools``.

   .. image:: images/m-origin-pool.png
      :width: 800px
   
#. Click the **Add Origin Pool** button.

   .. image:: images/m3-add-origin-pools.png
      :width: 800px

#. On the New Origin Pool form:

   * Enter a **Name** for your pool
   * Replace the **Port** value of *443* with *3000*
   * Select |add-item| under ``Origin Servers``

   .. image:: images/m-origin-pool-name.png
      :width: 800px

#. Complete the **Origin Server** section by make the following changes and click |add-item|

   * **Select Type of Origin Server**: K8s Service Name of Origin Server on given Sites
   * **Service Name**: workloadname.namespace (make a note to remember this in creation stage)
   * **Site or Virtual Site**: Virtual Site select shared/agility-k82-site
   * **Select Network on the site**: vK8s Networks on Site

   .. image:: images/m3-add-origin-server.png
      :width: 800px
 
#. Click |save-and-exit| near the **Origin Pool** dialogue.

Create HTTP Load-Balancer
^^^^^^^^^^^^^^^^^^^^^^^^^

#. Navigate the left-side menu to ``Manage`` > ``Load Balancers`` > ``HTTP Load Balancers``, then click **Add HTTP Load Balancer**.

   .. image:: images/m-add-http.png
      :width: 800px 
   
#. Enter a name for your HTTP Load Balancer in the **Metadata** section.

   .. image:: images/m-http-name.png
      :width: 800px 

#. In the **Basic Configuration** Section make the following changes:

   - **List of Domains**: Use your {namespace}.lab-app.f5demos.com
   - **Select Type of Load Balancer**: HTTPS with Automatic Certificate
   - **Select Type of Load Balancer**: Make sure this is checked

   .. image:: images/m-http-basic.png
      :width: 800px 

#. In the **Default Origin Servers** Section click |add-item|

   .. image:: images/m-add-origin-server.png
      :width: 800px 

#. Select the **Origin Pool**, and click |add-item|

   .. image:: images/m-select-origin-pool.png
      :width: 800px 

#. In the Security Configuration section change the **Security Policies** to *"Do Not Apply Service Policies"* then click |save-and-exit|

   .. image:: images/m-security-configuration.png
      :width: 800px 
   
#. After a few moments you should see a screen like the following:

   .. image:: images/m-http-status.png
      :width: 800px 

.. note::
  - Please wait for the VIRTUAL_HOST_READY and Valid certificate status before proceeding

Open a browser tab and navigate to the domain you entered. 

In the example below it is **flying-ox.lab-app.f5demos.com**

Success will render a page like the following:

.. image:: images/m-http-page.png

Please note the country name. 

Refresh your browser a few times and notice what happens to the country name. 

.. |save-and-exit| image:: images/save-and-exit.png
   :height: 20px

.. |add-item| image:: images/add-item.png
   :height: 24px

.. |apply| image:: images/apply.png
   :height: 24px

.. |add-virtual-K8s| image:: images/add-virtual-K8s.png
   :height: 20px

.. |ready| image:: images/ready.png
   :height: 16px

.. |create-in-progress| image:: images/create-in-progress.png
   :height: 16px

.. |Add-VK8s-Workload| image:: images/Add-VK8s-Workload.png
   :height: 20px


