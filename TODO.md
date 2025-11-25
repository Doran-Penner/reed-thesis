## misc

improve that bibliography

## Writing outline

aaaaaaah what am I gonna write about aaaaaaah

title: content-addressable replicated data types (teehee)

intro: intro stuff idunno

btw I could use quarto to roughly group the chapters (after intro) into quarto `part`s to separate background from my work. Just an idea!

### background (crdt)

what is the problem and what are desirable things? p2p stuff, distributed systems, fault tolerance, cap theorem, etc; availability, partition tolerance, problem of conflicts

what is a crdt? How it gets around the cap problem, the value it gives for p2p and distributed systems

state-based, op-based, deltas... different formal ways to make a crdt (maybe save delta for later)

talk about simple crdt stuff, examples; then talk about more complex stuff and the tradeoffs that we need to make to guarantee conflict-free
- discuss partial order on some operations, lamport time

(at some point, either here or later, claim that we can't solve all problems in the way that the user wants. so we either focus on the most-reasonable automation or we somehow leave it up to the user)

### background (hashing, merkle trees, blockchain?, b-trees, any other useful info)

yeah talk about that stuff

### main-ish focus

introduce merkle search tree...
- formal paper
- perhaps use dolt's version (and prove stuff about it formally)
- so much explanation
- drive the main point: efficiently stores diffs and feels like it has the potential (like what dolt does) to reliably reference deltas / states in an efficient way

merkle-dag as well...
- talk about all the uses (logical clock, crdt dag, payloads, etc)
- we can use the dag structure to carry the partial order of operations/states, and payload can be crdt ops/states (or maybe even a non-crdt payload)

### my stuff

now we get to my contributions! (which are a work in progress :D)

try to make MST-like structure for array/list? what about other large data types like trees, dags, graphs?

formalize merging the merkle-dag nodes

maybe go down the rabbit hole of compacting the dag, dropping nodes, squishing long lines of nodes, blockchain-like problems

using this merkle-dag structure with crdt payloads and store application-level conflicts (not "real" crdt conflicts) like pijul
- I think this is cool but I'm not sure what I can actually contribute in this direction

what about non-crdt payloads? Similar to above, focus on how to merge structure into something that needs user-level "flattening" or resolution
