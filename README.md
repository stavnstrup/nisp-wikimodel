# NISP Wiki data model

This repository contains the specification *model.xml* and import stylesheets necessary to build a semantic wiki implementation of the NISP database.

The Wiki data model is almost a one-to-one mapping of the concepts used in the [XML based data model](https://stavnstrup.github.io/nisp-tools/nisp-database-schema.html) with a few exceptions:

* Only the core concepts i.e. *Basic Standards Profile*, *Capability Profile*,  *Profile*, *Service Profile*, *Standard*, *Organization* and *Taxonomy Node* are implemented.
* XML elements, which are either container elements or elements created for usability reasons have been removed, as they do no contribute to the data-model and are therefore unnecessary in the Wiki model.
* In the XML version of the NISP DB, we never delete standards or profiles, but only marks elements as deleted. We have not ported any deleted elements to the Wiki platform. But the historical elements will continue to be available [here](https://nisp.nw3.dk/).
* All the child elements of the *document* element used by the *standard* element are not transferred to the Wiki. But of course the document element attributes is ported to the Wiki.

The document element is described in the XML DTD as

~~~{.dtd}
<!ELEMENT document (substandards?, correction*, alsoknown?, comment?)>

<!ATTLIST document
          orgid   CDATA #REQUIRED
          pubnum  CDATA #REQUIRED
          date    CDATA #REQUIRED
          title   CDATA #REQUIRED
          version CDATA #IMPLIED
          note    CDATA #IMPLIED>
~~~

N.B. one major difference between the two data models is that almost all attributes have changed name. This reason for this change is:

* Very few IP CaT members knew anything about the old data model and are therefore not affected by the change.
* The new vocabulary is identical to the vocabulary used in the EM-Wiki and are therefore familiar to users of the EM-Wiki.

# Core concepts

All the [core concepts in Wiki](https://wiki.nisp.nato.int/index.php/Concepts) are described below:

## Simple concepts

The *Organisation*, *Taxonomy Node* and the *Standard* concept are straightforward and requires little explanation:

* [Organizations](https://wiki.nisp.nato.int/index.php/Project:Concept_-_Organizations) describe all organizations in the database. An organization can *own* a standard and another organisation is *responsible party* for a standard. A *responsible party* is therefore an organization, who takes the role as a domain expert for a specific standard.
* [Taxonomy Nodes](https://wiki.nisp.nato.int/index.php/Project:Concept_-_Taxonomy_Nodes) are nodes in the [C3 Taxonomy](https://www.nato.int/cps/en/natohq/topics_157573.htm?). We currently only use a subset of the nodes in the Taxonomy.
* [Standards](https://wiki.nisp.nato.int/index.php/Project:Concept_-_Standards) are the most important part of the NISP database and describes all standards used by one or more profiles.

## Profiles

Profiles in NISP comes in two flavours:

* The *Basic Standards Profile* which in NISP is presented as the *mandatory* standards in volume 2 and the *candidate* standards in volume 3.
* Community Of Interest (COI) profiles, which are modelled in NISP using the concepts *Capability Profile*, *Profile* and *Service Profile*.

In NISP 9, we presented more or less a prettyfied version the internal data structure of the Basic Standards Profile and the COI profiles, and this version is therefore a good illustration of the data-model. In NISP 11 the way we represent the Basic Standards Profile different, but that not mean that the model is not still valid.

### Base Standards Profile

The *Base Standards Profile* is in NISP Vol 1 described as: "The Basic Standards Profile specifies the technical, operational, and business standards that are generally applicable in the context of the Alliance and the NATO Enterprise". We present this as mandatory standards in volume 2 and candidate standards in volume 3.

In the XML version the *Basic Standards Profile* consists of one or more of the *Basic Standards Service Profile* element. We only implement the later in the Wiki, since that is all that is necessary. Each *Basic Standards Service Profile* element therefore describes the mandatory and candidate standards for a specific taxonomy node. In volume 2 and 3 we list the taxonomy nodes and recommended standards. An example on this can be found [here](https://archive.nisp.nw3.dk/nisp-9.0/volume2/ch03s02.html). Note that in NISP 9 we used to list both mandatory and candidate (at that time called emerging) standards in the same document.

An example of a Basic Standards Service Profile is the profile used for [Informal Messaging Services](https://wiki.nisp.nato.int/index.php/BSP-Informal_Messaging_Services).

Currently a responsible party typically recommends, if standard should be registered as mandatory or candidate for one or more taxonomy nodes. Since this might cause conflict in implementation, it is therefore the goal that is model is dropped and we instead have a single responsible party for a *Basic Standards Service Profile*, which there only contains the minimum set of standards necessary to implement the functionality of a given taxonomy node. We have therefore added the attribute *Responsible* to the concept.

### Community of Interest profiles

A COI profiles such as e.g. the Federated Mission Networking (FMN) profile is implemented as a tree structure. A profile may therefore composed of a number of subprofiles and each of those sub-profiles may as well be composed of a number of profiles. In NISP with use tree slightly different profile concepts to implement the tree. The three profile concepts are *Capability Profile*,  *Profile* and *Service Profile*.

We use these concepts in the following way:

* The *Capability Profile* concept is used for the root of the tree.
* The *Service Profile* concept is used for the leaves of the tree.
* The *Profile* concept is used for all the other nodes in the tree.

The implementation of a capability profile for FMN Spiral 2 can be found [here](https://nisp.nw3.dk/capabilityprofile/fmn2.html). You can see the whole tree if you click on the "Topography" tab, or you can traverse down the tree clicking on the sub-profile links.

The same concepts are also implemented in the Wiki, see [here](https://wiki.nisp.nato.int/index.php/Fmn2) for an example of the FMN Spiral 2 implementation.

Currently, we do not present FMN 2 in the NISP documents, but only links to the canonical specification. In NISP version 9, we did render a version of the [FMN Spiral 1.1 profile](https://archive.nisp.nw3.dk/nisp-9.0/volume3/apgs03.html).

# Naming conventions

In the Wiki each instance of a concept is implemented as a page. We therefore need a convention on how to name the individual pages.

Most objects have an id in the XML database, but often they are to cryptic to use. Therefore the following convention is used:

* Each standard use it's id to name the page.
* Each capability profile, profile and service profile currently use the id, but it is the plan to use the name of the profile instead.
* The basic standards service profiles do not have an id, they are named using the taxonomy node title prefixed with 'BSP-'.
* Taxonomy nodes use the title as name
* Organizations use a capitalized form of their name


# What has not be implemented

Two of the concepts *Catalog Items* and *Cover Documents*, which originally was part of the draft data model, have not been implemented yet. The main reason is lack of experience with the data modelling language, but also because these concepts was not part of the NISP XML implementation.

# TO DO

* Change name of all capability profiles, profiles and service profiles.
