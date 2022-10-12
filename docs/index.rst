
:sd_hide_title:

F5 Distributed Cloud
====================

.. topic:: Workspace Guides

    The F5 Distributed Cloud console is divided into workspace tiles. https://|tenantname|/api

.. toctree::
   :titlesonly:
   :maxdepth: 1
   :hidden:

   intro.rst
   install-tools.rst
   administration_personal-management_credentials.rst
   cloud-and-edge-sites.rst
   distributed-apps.rst
   load-balancers.rst
   web-app-and-api-protection.rst


.. card:: Clickable Card (external)
    :link: https://example.com

    The entire card can be clicked to navigate to https://example.com.

.. card:: Clickable Card (internal)
    :link: cloud-and-edge-sites
    :link-type: ref

    The entire card can be clicked to navigate to the ``cards`` reference target.

.. grid:: 2

    .. grid-item-card::  Title 1
        :link: cloud-and-edge-sites
        :link-type: ref

        A

    .. grid-item-card::  Title 2
        :link: cloud-and-edge-sites
        :link-type: ref

        B
   

.. card:: Card Title
    :link: cloud-and-edge-sites
    :link-type: ref

    Header
    ^^^
    Card content
    +++
    Footer

.. grid:: 2
    :gutter: 1

    .. grid-item-card::

        A

    .. grid-item-card::

        B

.. grid:: 2
    :gutter: 3 3 4 5

    .. grid-item-card::

        A

    .. grid-item-card::

        B

.. grid:: 2

    .. grid-item-card::
        :columns: auto

        A

    .. grid-item-card::
        :columns: 12 6 6 6

        B

    .. grid-item-card::
        :columns: 12

        C


.. grid:: 1 1 2 2
    :gutter: 1

    .. grid-item::

        .. grid:: 1 1 1 1
            :gutter: 1

            .. grid-item-card:: Item 1.1

                Multi-line

                content

            .. grid-item-card:: Item 1.2

                Content

    .. grid-item::

        .. grid:: 1 1 1 1
            :gutter: 1

            .. grid-item-card:: Item 2.1

                Content

            .. grid-item-card:: Item 2.2

                Content

            .. grid-item-card:: Item 2.3

                Content



.. output-cell:: console

    hello world

.. prompt:: bash
   :prompts: (cool_project) $

   python3 -m pip install --upgrade sphinx-prompt

.. prompt:: bash
   :prompts: $

   python3 -m pip install --upgrade sphinx-prompt

.. prompt:: bash
   :prompts: (cool_project) $

   python3 -m pip install --upgrade sphinx-prompt

.. prompt:: text
   :prompts: $

   python3 -m pip install --upgrade sphinx-prompt
