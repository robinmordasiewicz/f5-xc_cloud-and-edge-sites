.. glossary::

   workload
      Workload is used to configure and deploy a workload in Virtual Kubernetes. A workload may be part of an application. Workload encapsulates all the operational characteristics of Kubernetes workload, storage, and network objects (deployments, statefulsets, jobs, persistent volume claims, configmaps, secrets, and services) configuration, as well as configuration related to where the workload is deployed and how it is advertised using L7 or L4 load balancers. A workload can be one of simple service, service, stateful service or job. Services are long running workloads like web servers, databases, etc. and jobs are run to completion workloads. Services and jobs can be deployed on regional edges or customer sites. Services can be exposed in-cluster or on Internet by L7 or L4 load balancer or on sites using an advertise policy.

   registry
      A container registry object is used to configure a private network location from which the application container images are fetched.

   vk8s
      What is VK8s

   tenant
      Tenant is an entity that is the owner of a given set of configuration and infrastructure. Tenant is the owner of all configuration objects that a user with given tenant-id has created. Tenant is fundamental concept of isolation, and a tenant cannot access any objects or infrastructure of other tenants.

   namespace
      Tenant’s configuration objects are grouped under namespaces. Namespaces can be thought of as administrative domains. All the objects of the same kind need to have unique names in a given namespace. Namespace themselves must be unique within a tenant. In this document namespace will be referred as <tenant>/<namespace>, which will be globally unique.

   site
      Site is a physical or cloud location where F5 Nodes are deployed. Site can be a public cloud location like AWS VPC, Azure VNET, GCP VPC, physical datacenter, or an edge location like manufacturing Site, factory, retail store, restaurant, charging stations, robots, etc. Even though F5® Distributed Cloud’s Regional Edges are available as Sites for F5® Distributed Cloud Mesh (Mesh) or F5® Distributed Cloud App Stack (App Stack) services, they are not marked in F5® Distributed Cloud Console (Console) or APIs as “customer Sites”. 

   regional-edge
      Regional Edges (RE) in F5 Distributed Cloud Global Infrastructure - F5 Distributed Cloud points of presence with their own highly meshed backbone are used to provide customer services (eg. Mesh or App Stack). These points of presence are also used to connect multiple customer Sites to each other. These REs can also be used to expose customer services to the public internet. These RE sites can also be used to run customer applications so that they are closer to end consumers on public Internet or their distributed application locations.
