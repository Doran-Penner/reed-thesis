# organization

Section notes should either live in the first section of each chapter or here; I'm undecided but lean towards "in the chapter."


# notes and todos

## general todos
(None)

## current outline

- background
  - dist. sys.
    - general intro
    - problems, cap theorem, lamport?, and so on
  - crdts
    - yep all the stuff
  - hashing, content addressing, etc
- prolly tree
  - search trees
  - merkle trees
  - content-defined chunking
  - what the prolly tree actually is
  - discussion vs mst and others
- prolly tree properties
  - proofs about read/write runtimes, etc
  - prolly tree as a crdt (incl. when the values are crdts)
  - ...?
- things you can do with prolly trees (maybe each is its own chapter)
  - dynamo-like
  - send data in op-like way
  - range tree for array; other data structures (we get JSON)
  - improve the cdc system (stuff that Dolt did)
  - and so on!

## misc

Improve bibliography and citations:

- Put all my possible references into the actual `.bib` file
- Put general references in each section that needs them. Don't need perfect quotes inline yet, but put the source next to the writing so I know what I'm sourcing.

In practice, CRDTs are not always useful! People want different semantics for difficult combinations. So we designers either need to make a best guess and stick with it, or let users configure it, or something.

State-based can only grow. We simulate removal with tombstones. Op-based doesn't have this problem on the surface. But it also assumes a strong network. If a peer is joining for the first time, it needs the full history --- or a current starting state or something, and I'm not 100% convinced that that works.


# thesis thesis
(All the things that I am "contributing" to the world; WIP as always.)

General outline:

- Distributed systems are cool/important
- CRDTs are useful for them
- This Prolly Tree thing solves some distributed systems problems (examples in the real world)
- Here’s how we can make it more flexible and/or powerful and/or etc, also just look it’s a great thing

## What's cool about Prolly Trees?

The Prolly Tree is pretty cool because a given state (set of items) always has a unique representation; furthermore, it's efficient to use.

## Range tree etc

Can use Prolly Trees as a range tree, thus creating an array-like interface.

- What are the efficiencies of this? Idk if it's worth benchmarking. But note that `diamond-types` uses that structure so it can't be that slow.

What about other large data types like trees, dags, graphs? Note that "small" data can just be directly hashed which is nice. The important part is the unicity of representation. Can we make a "file?" What does that look like — an array of bytes, a list of strings, a syntax tree based on some grammar, or what?

With key-value map, array, and "small stuff," we have JSON. That's worth mentioning because you can use JSON for pretty much anything --- not efficiently, but you can use it.

## Doing op-like things

Is there some way we can do Prolly Tree data transfer in an op-like way, sending over just what changed? Then we could swap between state-based and op-based info sharing depending on context.

Ooooh, the op-based system could send the full tree path of what changed (including old and new hashes) and reconciliation could happen fully on the destination. This feels like it reduces the communication latency a lot. Ooooooh.
Also do we even need the full tree path? Since it's a search tree, we could just send the root hash and the key-value change. Something to consider.

Also we could swap back and forth between the op-based system (send over each change as it happens) and the state-based system (send over root hash and do the full tree comparison every time) depending on speed and divergence and all that.

Idk how important/useful this is, but it still feels like a marginal improvement over full state comparison every time.

## Dynamo-like stuff

The CRDT setting imagines that all nodes have their own full copy of the data, and the “distributed” part is about how to reconcile different versions. But each node can do whatever it needs to do all on its own.

On the other hand, the Dynamo world imagines that all the nodes are working together in some way, parts of a whole. Each node might store only a few chunks of the whole search tree and queries are always to the whole network.

This is a really interesting contrast; it's a very different model, exchanging replication (and availability) for consistency amongst the group.

What if we don't replicate the Prolly Tree, but instead it's shared amongst peers? That would be really cool to analyze. You don't need trust because everything is hash-based and you can compute the hash yourself to verify.

We don't wanna get too into the details of how Dynamo and such work, but should be able to wave our hands and say "there is existing literature for that stuff." The question then is, "What to Prolly Trees help with here?" Maybe decreased trust, but I would need to do a bit of reading to be sure.

## Improving the CDC

Dolt already did this, but I can talk a bit about how to make the chunking better.
