CargoTube
=========

Table of Contents
=================

* [Description](#description)
* [Goals](#goals)
* [Features](#features)
* [License](#license)


Description
===========
CargoTube is a pub/sub and rpc software router.
CargoTube can be used to connect various clients
for publication and subscribing to topics as well
as remote procedure calling.

CargoTube implements the wamp protocol, specified
at https://wamp-proto.org/.

Pull Requests, Bug Reports, Comments and any other kind of feedback is welcome.

[Back to TOC](#table-of-contents)


Goals
=====

The goals of the CargoTube project are:

* specification compliant
* reliable
* well tested
* code easy to reason about


That means we implement according to the specification and if
there is a communication issue with a client we will only fix it
if the communication is according to the specification.

We want CargoTube to be reliable. This means for us to loose as
little messages as possible and if we lost a message we want to
be able to track it.

Our aim is to have a code coverage of 80% or above in unit testing,
so we can find issues in new code easily.

Cleaner Code and simple code supports to reach the above goals, so
we go for it.

[Back to TOC](#table-of-contents)

Features
========

CargoTube implements

* the complete basic profile (if something is missing from the basic profile this is a bug and please report it)
* partially the [Advanced Profile](https://wamp-proto.org/static/rfc/draft-oberstet-hybi-crossbar-wamp.html#rfc.section.14)
  * RawSocket Transport
  * Batched Websocket Transport
  * Subscriber Black- and Whitelisting
  * Publisher Exclusion
  * Caller Identification
  * Publisher Identification
  * Session Meta API
  * Subscription Meta API
  * Registration Meta API

Please fill in an issue for needed features.

[Back to TOC](#table-of-contents)




License
=======
CargoTube is released under the CDDL-1.0.
See license file for more information.

[Back to TOC](#table-of-contents)
