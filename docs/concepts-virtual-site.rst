.. _virtual-site:

Virtual Site
============

A virtual Site is a tool for indirection. Instead of doing configuration on each Site, it allows for performing a given configuration on set (or group) of Sites. Virtual Site is a configuration object that defines the Sites that members of the set.

Set of Sites in the virtual Site is defined by label expression. So we can have a virtual Site of all Sites that have “deployment in (production) and region in (sf-bay-area)”. This expression will all production Sites in sf-bay-area.

Virtual Site object is used in Site mesh group, virtual Site is used in application deployment, advertise policy or service discovery of endpoints. These label expressions can create intersecting subsets, Hence a given Site is allowed to belong many virtual Sites.

Concept of “where”
------------------

Technically an endpoint (for example, DNS server, k8s API or any such name to be resolved) should resolve finally to virtual network and IP address. Since it is not always convenient or even possible to provide a virtual network and an ip address, we provide the capability of defining “where” in many API(s). This concept of “where” makes it easier to perform configuration and policy definition upfront.

Value of “where” can be any one of the following:

* Virtual Site: configuration applied “where” all Sites selected by virtual Site and Site local network type on that Site. Name will be resolved there or discovery will done be on all these Sites.
* Virtual Site, network type: configuration applied to “where” all Sites selected by virtual Site and network type on those Sites.
* Site, network type: configuration is applied on this specific Site and virtual network of given type.
* Virtual network: configuration is applied to all Sites “where” this network is present.
