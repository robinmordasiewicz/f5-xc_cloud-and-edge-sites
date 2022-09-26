Distributed Application Management
==================================

.. topic:: Kubernetes

    F5 Distributed Cloud Services provide a tenant with a representative application cluster where customer deploys their applications and based on configuration our distributed control plane will replicate and manage them across multiple sites. In addition to containerized applications, the platform also provides the ability to manage virtual machines.
    interpreted as body elements.

.. objective

What we are going to learn.

.. toctree::
   :caption: Guided Labs
   :glob:
   :maxdepth: 1

   virtual.rst
   managed.rst

**Resources**

For more core concepts, please review `F5 Distributed Cloud documentation <https://docs.cloud.f5.com/docs/ves-concepts>`_

Core concepts
^^^^^^^^^^^^^

   *Pods in vK8s*
      `The core concept in application management on Kubernetes is a Pod. Pod is the basic and smallest execution unit that can be created, deployed, and managed in Kubernetes. A Pod consumes compute, memory, and storage resources and needs a network identity. A Pod contains single or multiple containers but it is a single instance of an application in Kubernetes.`

   *Service*
      `A service with one or more containers with configurable number of replicas that can be deployed on a selection of Regional Edge sites or customer sites and advertised within the cluster where is it deployed, on the Internet, or on other sites using TCP or HTTP or HTTPS load balancer.`

   For more core concepts, please review `F5 Distributed Cloud documentation <https://docs.cloud.f5.com/docs/ves-concepts/dist-app-mgmt>`_

