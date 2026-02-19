# organization

Section notes should either live in the first section of each chapter or here; I'm undecided but lean towards "in the chapter."


# notes and todos

## general todos
(None)

## intro rewrite

Based on my notes, write dist systems background again (incl. p2p, assumed infrastructure, etc)

Given that, rewrite later background stuff a bit

- Do a proper editor re-write
- Be more formal with definitions and such
- Get references --- even if not exactly citing, make `@` citations at the start of each section so I have them

Should I, in the background, do what Jim said and say something like "I'm interested in distributed hash tables?" Something to think about.

- Find academic references for the dependency subjects; that’ll get me more formal definitions that I can use.
- Use those references to give more formal treatment of dependency topics, and eventually the Prolly Tree itself.
- Write a lot about distributed systems background, mindset, et cetera. Don’t need paper references quite yet but ask Jim for them.
- Hold off on the rest of the general background — there’s a lot in the air right now and I want to pin down the start and finish before going too hard on the middle.

## prolly tree explanation

Don't need to actually explain B-trees. Should talk about (desirable properties of) search trees in general, and can mention B-trees as a cool related thing or an example.

Also, I feel confident using the Dolt version of the tree — it has fewer weird questions like “what if there’s a big hash level gap” or whatever. (And I keep going back and forth about the merits of the MST vs Prolly tree, but I just gotta pick something.) Also it gives me more room to do proofs about operation runtime and such. I will definitely discuss the differences and merits of each approach (MST vs Prolly Tree). For now, what name should I use? I think I should call my section “Prolly Trees” since that’s more in line with what’s actually happening.

- Re-write the B-tree section to just discuss search trees.
- Mention that there are different MST-like things and redirect to a future discussion section.

## misc

Improve bibliography and citations:

- Put all my possible references into the actual `.bib` file
- Put general references in each section that needs them. Don't need perfect quotes inline yet, but put the source next to the writing so I know what I'm sourcing.

In practice, CRDTs are not always useful! People want different semantics for difficult combinations. So we designers either need to make a best guess and stick with it, or let users configure it, or something.

State-based can only grow. We simulate removal with tombstones. Op-based doesn't have this problem on the surface. But it also assumes a strong network. If a peer is joining for the first time, it needs the full history --- or a current starting state or something, and I'm not 100% convinced that that works.

Replicache (https://doc.replicache.dev/concepts/how-it-works) allegedly uses a prolly tree and CRDT for their auto-sync product. It's a client-server setup where the client rebases their changes on top of the servers'. You can write your own conflict resolution code. Something called "server reconciliation" is involved?


# thesis thesis
(All the things that I am "contributing" to the world; WIP as always.)

try to make MST-like structure for array/list? what about other large data types like trees, dags, graphs? Note that "small" data can just be directly hashed which is nice.

- Distributed systems are cool/important
- CRDTs are useful for them
- This MST thing solves some distributed systems problems (examples in the real world)
- Here’s how we can make it more flexible and/or powerful and/or etc, also just look it’s a great thing

MST thoughts...

- The MST is pretty cool because a given state (set of items) always has a unique representation; furthermore, it's efficient to use. If I want to make other CaRDTs, this is what matters.
- We can make other data structures with an MST, e.g. a list as a kind of range tree. That could be cool and useful. Or we could implement a new system from scratch! The important part is the unicity of representation. Can we make a "file?" What does that look like — an array of bytes, a list of strings, a syntax tree based on some grammar, or what?
- Re: MST's future ideas. Is there some way we can do MST data transfer in an op-like way, sending over just what changed? Then we could swap between state-based and op-based info sharing depending on context. Ooooh, the op-based system could send the full tree path of what changed (including old and new hashes) and reconciliation could happen fully on the destination. This feels like it reduces the communication latency a lot. Ooooooh.
- Also we could swap back and forth between the op-based system (send over each change as it happens) and the state-based system (send over root hash and do the full tree comparison every time) depending on speed and divergence and all that.

Jim and I had a really good moment about mental model and setting. The CRDT setting imagines that all nodes have their own full copy of the data, and the “distributed” part is about how to reconcile different versions. But each node can do whatever it needs to do all on its own. On the other hand, the Dynamo world imagines that all the nodes are working together in some way, parts of a whole. Each node might store only a few chunks of the whole search tree and queries are always to the whole network. This is a really interesting contrast; it's a very different model, exchanging replication (and availability) for consistency amongst the group. Has anyone done anything with this? That would be really cool to analyze. Then my thesis' thesis focuses on all the different things you can do with an MST: make it op-based, use it in a Dynamo-like way (but hashes mean you don't need as much trust), and so on with all my other thoughts.
