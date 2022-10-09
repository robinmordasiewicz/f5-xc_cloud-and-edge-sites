.. _labels:

Labels
======

Labels are meta attributes of the configuration objects. Labels can be used to do arbitrary classification of objects. Conceptually there are no restrictions on what labels you can add to an object.

Labels are made of two parts “key” and “value”. They are represented as “key=value” or “key(value)”.

**Examples**

* region=sf-bay-area, region(nyc-metro)
* deployment=production, deployment(staging)
* application=my-app, application(your-app)

In above example region, deployment and application are keys, sf-bay-area, nyc-metro, production, staging, my-app and your-app are values

If above labels were applied to site objects, then the following sets can be created:

* All sites in nyc-metro area : expression sites in “region in ( nyc-metro)”
* All sites in nyc-metro or sf-bay-area : expression sites in the “region in (nyc-metro, sf-bay-area)’
* All sites that are production and in sf-bay-area : expression sites in the “region in (sf-bay-area) and deployment in (production)”

Label Expressions
-----------------

Label expressions are used as “label selector expression” for selection of a set of objects. Label selectors are used in an object’s data-model to refer to dynamic set of other objects instead of hard references. For example, all sites to advertise VIP of virtual host, all endpoints to match in security policy, all endpoints to discover, all sites for application deployment, etc. It is a mechanism to create arbitrary subsets. Labels expressions can also be used as query parameters in list APIs

Any string that satisfies a label format can be used as labels on the objects. However, all labels are not the same. There are three types of labels:

* Known Labels - Known labels are labels that are defined a-priori (before use). Known labels need to have known keys.

* Implicit Labels - Implicit labels are implicit property of the object that can be used in policy language but cannot be assigned to objects. Currently, the only implicit label that is supported is geo-ip information for a client (it’s public ip address on the internet). Implicit labels are specific in their use - for example, geo-ip implicit labels are supported only for public ip in the context of service policy or network policy.

* Custom Labels - Labels that are assigned to objects on the fly with defining them on demand.

Known Keys and Known Labels
---------------------------

For consistency in labeling, it might be advantageous to advertise what labels to use. So there is the concept of known keys and known labels. These are implicit objects that can be configured in shared namespace of tenant so that other users can use these in a consistent way. Known keys are keys that can be used with user defined values. Known labels is a key-value pair that can be attached to objects.

Key are strings with format <key prefix>/<key>. Key prefix is usually domain names and is optional. Key follows DNS label format. For example, all F5 Distributed Cloud Services keys start with key prefix “ves.io”. Key = “ves.io/region''.

Labels are always of DNS label format.https://tools.ietf.org/html/rfc1035.

All F5 Distributed Cloud Services values are prefixed with “ves-io-”. E.g “ves.io/region=ves-io-sf-bay-area". Users are prevented from using “ves.io” key prefix and “ves-io-” value prefix.

Known keys and known labels available in “ves.io/shared” namespace are accessible by all tenants and can be used by everyone.
