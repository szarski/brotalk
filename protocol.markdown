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
