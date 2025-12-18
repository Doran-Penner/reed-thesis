blarg okay
LET'S DO THIS RAAAAAAH

explaining mer-dag! what do they need to know

## distributed systems: intro, CAP
(unsure how many 389 comparisons I wanna make)

what is it
- multiple computers that can send messages to each other
- different from client-server: everyone is inherently the same

problems (✅ for needs mini-section)
- so many
- consensus/consistency (maybe its own section)
- availability
- peers joining/leaving
- time / ordering of events ✅

With all of that, how do we get the computers to coordinate on something? Assume that there will be network outages, so we need to support that; now compare availability and consistency

idea: only one authoritative copy of the data (best consistency)
- serializes all reads/writes
- doesn't have to be one central server --- each machine can own some disjoint subset of the data
- problem: always need connection or else can't get the true data
- can alleviate with caching etc, but we still have the stale data issue because sometimes connections are faulty
- what if that's okay?

idea: everyone has their own copy (best availability)
- no need for network access
- accept that we may not always have the most up-to-date copy (sacrifice some consistency for better availability and partition-tolerance)
- problem: how to combine different versions? (draw diagram here or later)

There are many different ways to build around the CAP issue, but we'll focus on this one.

## distributed systems: combining versions

Some version combines are easy. If I did something to my version and you did nothing, it feels pretty reasonable that you just take my new version. But what if we both made changes?

EXAMPLE

<!-- TODO should we cover the partial order? Not sure... -->

And how do we even know what changes happened and what comes before what?

## Lamport's partial order

To solve this, Lamport observed that operations in a system create a partial order. On a given machine, there is a total order of states: if (to a number counter) I add 3, then subtract 7, then add 50, there is a clear order. Between machines we only have a partial order. If (from the same starting state) I do 3 things and you do 5, there's no inherent order _between_ our states. DRAW DIAGRAM.

Lamport also defined a way to create a total order over the operations. AS OF THIS VERSION OF THE TALK I won't go into it right now, but you can read the very short paper or come talk to me afterward! For our purposes, we want to focus on that partial order. Given two divergent states, how do we combine them?

## Constructing CRDTs

Now we know what we want. We have a system that stores some version of the data on each machine, achieving availability and partition-tolerance. We don't get perfect consistency, but we will strive for **strong eventual consistency**: a guarantee that, with enough time and connection, everyone will _eventually_ have the same data. So... how do we combine different versions?

We want a **conflict-free replicated data type. Breaking that down, it...
- is a _data type_ (e.g. a list)
- is _replicated_ (multiple copies across the network)
- has a _conflict-free_ merging strategy (way to combine divergences that always succeeds). There are two main ways to do this: via states or operations.

### State-based

Join-semilattice on the states (send states)

Examples: max number, grow-only set...

### Op-based

Commutative operations (send ops)

Examples: bank value, grow-only set again

### Fancier structures

How do we make a set? Allows for adding and removing one element at a time. Shouldn't be too hard, right? INTERACTIVE
- issue: add and remove do not commute (ex: 2 adds and 1 remove)
- go over solutions: tombstone set, unique tags (e.g. photo album), counter on each item

### Comparing the two approaches

Note: both can emulate each other

Both types have issues...

State:
- need to send over the entire state
  - what if network is slow?
- can only "grow" since join-semilattice
- need to define LUB that'll work on everything

Op:
- need to store long op histories or and/or have strong network
  - what if network is unreliable?
- how does a new node join? need to transmit full state
- not all operations are naturally commutative

<!--
TODO where do we go from here? How do I transition to MerDag?
Well...
What does it do for us? What do we gain from using this graph?
spam ideas:
- delivery mechanism & guarantees for op-based and deltas
- vcs-style multiple versions
- making a kinda-crdt for normally-non-crdt data
  - the node payloads themselves aren't crdts
  - so merge is not trivial, merge node stores meaningful data
  - feels kinda like reinventing git but a bit more general and formal
- content-addressing (also mst) gives us state-based crdts with very nice properties. easier diffing, verified transmission, like deltas but it's built into the structure
-->

There are also some hybrid systems like delta-CRDTs, which send over state mutations: they're still state-based in essence but they do op-like things and only share the differences.

All of these have tradeoffs. State needs to send full state, ops need frequent sends or long op history. What if we could get both of these properties? We can exploit hashing and content addressing to achieve this.

## Background: hashing and content-addressing

A _hash function_ is a function that takes variable-length input and gives fixed-length output. Its output seems random to the human eye, and is hard to predict or backsolve: given the hash, there's no good way to figure out what input it came from (besides just trying a ton of things).

There are _collisions_ in a hash function --- two different inputs that hash to the same output. For our purposes, we're going to ignore that! We'll assume that a hash is a unique identifier of data. All of this stuff also works when we factor in collisions, but don't worry about it.

A _hash table_ is a big array that we can index with hashes. EXAMPLE. _Content addressing_ is when we store data in a hash table at its hash index. EXAMPLE! This lets us get a special kind of pointer to any data. But normal computer pointers reference a location in memory that is specific to the program being run. A "hash pointer" is defined by the data it points to and will always be the same no matter what machine we're on.

## Content-addressing CRDTs

So! We can use hashing and content-addressing to improve state-based CRDTs. For an example, let's work with a set (using any of the state-based merge methods we covered). If we both store a hash of our set states, we can just send those over. If they're the same, we don't need to do anything! We have the same hash so we have the same data. This is a massive improvement in this nice case. But in the case when we have different sets, we still need to send over the full state --- we don't have any cool hashing for "what changed in the different sets." Or... do we?

## Merkle Search Tree (or Prolly Tree, or Content-defined Merkle Tree)

There are a bunch of names for this data structure because it's been independently created a few times. It's officially a search tree (like a binary search tree), but we'll just focus on the keys and call it a set.

TODO how deep do I want to explain it?
EXPLAINING RAAAAAH

And now what do we have? We have dramatically improved the merge performance of state-based CRDTs. Instead of sending over the whole state, we first just send over our root hash. If those are different, we send that data block and compare its child hashes. Continue recursively! If the two trees are very different, we still have to send over a ton of data. But asymptotically, send data _proportional to the diff of the trees_. Then we can locally resolve the state differences using whatever state-based merge strategy we want.

## Building from that

By using this particular implementation of a set, we get the small-sharing of ops without needing to track our full history. What else can we do with content-addressing?

For "smaller" data (e.g. numbers), we don't need any of this complex tree structure --- we can juse hash the value itself and store that. For more complex data types, we can expand the MST to have values corresponding to these set-item keys, creating a key-value map. We can turn those "keys" into indices (0, 1, 2, etc) and we have a kind of array or list.

What about graphs? For a DAG, we can exploit the acyclic nature and have the graph pointers themselves be "hash-pointers," creating immutable structure that can easily be compared. There's another paper that I didn't cover which uses this to create a DAG of different states/changes for data, representing the Lamport partial order explicitly in a hash-pointed graph.

There's so much we can do. Thank you all for your time!

<!-- ## Aside: making sense to users -->

<!-- Beyond all the stuff we've done to make stuff consistent, it's even harder to end up with something that makes sense for users. TREE MOVE EXAMPLE. In these scenarios, there are a few ways to proceed. One is to shrug and say  "oh well." That's not ideal, but it's sometimes hard enough to get a working CRDT --- dealing with understandability can be too much. Another is to store multiple versions of confusing merges. This keeps all the information available to users, but doesn't really mesh with the whole "conflict-free" thing. The in-between method is to find a way of storing user-level conflicts inside a nonconflicting container structure. See pijul or talk to me about how this can work for e.g. version control conflicts. -->

<!-- LINK https://docs.google.com/presentation/d/1lWiRVOoUXkpIdi1GbAf12yogbe__gB_P_BlB1VLdfSU/edit?usp=sharing -->
