brotalk
=======

Ay bro!

Nothing to see here bro, just a school project.

assumptions
===========

  * initial information available on Twitter, with some specified hashtag
  * messages hidden in the ping protocol
  * limited redundancy about network topology
    * supernodes know how the information is distributed
    * each peer knows all supernodes
    * each peer has information about a part of the network topology
  * try to overcome NAT-related problems

protocol
========

response to greet:

  * update\_bros
  * elect myself if there are no supernodes I know
  * greet all the new nodes with the supernode address only (and self)
  * remove excessive regular nodes

sending messages (broadcast only):

  * send message to supernode
  * supernode forwards to all other supernodes
  * each node checks periodically

TODO
====

  * hook up TwitterWrapper
  * update #greet to support the election process, limit number of nodes and send only supernode addresses
  * implement sending messages
  * implement PingWrapper, hook up to Communicator
  * implement recovery mechanism
