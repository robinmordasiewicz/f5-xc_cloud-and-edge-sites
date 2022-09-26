.. _canary-ab-bluegreen:

A/B Testing vs Canary Release vs Blue Green Deployment
======================================================

A/B Testing
-----------

* In simple terms A/B testing is a way to compare two versions of something to determine which performs better .
* In an A/B test, some percentage of your users automatically receives “version A” and other receives “version B.
* It is a controlled experiment process. To run the experiment user groups are split into 2 groups. Group “A,” often called the “control group,” continues to receive the existing product version, while Group “B,” often called the “treatment group”, receives a different experience, based on a specific hypothesis about the metrics to be measured
* At the end the results from 2 groups which is a variety of metrics is compared to determine which version performed better.

Canary Testing
--------------

* Canary Testing is a way to reduce risk and validate new software by releasing software to a small percentage of users. With canary testing, you can deliver new features to certain groups of users at a time.
* Since the new feature is only distributed to a small number of users, its impact is relatively small and changes can be reversed quickly should the new code prove to be buggy.
* It is a technique to reduce the risk of introducing a new software version in production by slowly rolling out the change to a small subset of users before rolling it out to the entire infrastructure and making it available to everybody.
* While canary releases are a good way to detect problems and regressions, A/B testing is a way to test a hypothesis using variant implementations.

Blue/Green Deployment
---------------------

* Blue-green deployment is a software deployment strategy which utilizes two production environments (a “blue environment” and a “green environment”) in order to make the software deployment process easier and safer.
* The two production environments are kept as identical as possible, and when new code is deployed, it is pushed to the environment that is currently inactive. Once the new changes have been tested in production, a router can then switch to point to the environment where the new changes are live, making for a smooth cut-over.
* One of the main benefits of blue-green deployments is disaster recovery. Because there are two identical environments for production, if new changes are rolled out to one (say the blue version) and any issues are discovered, a router can just switch back to the other environment (green version) which has the old version of the code with zero downtime.
* Blue-green deployment can be used for canary testing by simply having the router direct a percentage of your traffic to new version of the code to see how it performs with live traffic, before rolling out the change to 100% of your users.

.. image:: images/ab-canary-bluegreen.png
   :width: 800px

