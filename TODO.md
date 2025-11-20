## Template cleanup

What to do first? Some maintenance before I even start writing.

### Remove Sam stuff
- [x] His actual main content
- [x] Baked-in stuff like the Samasaur1 github link
- [x] Change title, author, etc
- [x] Address his README? At the least, overwrite it
So... am I done? Should probably do all of the next section, then history rewrite as needed.

### File cleanup
- [ ] Formatter
- [ ] Nix file changes
- [ ] Move the abstract etc to folders
- [ ] Direnv
- [ ] License?
- [ ] Whatever github/keep-tex/etc workflow I want for feedback

### Sam's future work stuff
- Pick a style (from <https://www.zotero.org/styles>). I'm using biblatex instead of citeproc (so the bibliography can go in the right place), so the style repository may not apply.
- Automatic drop caps in main matter chapters (combo of pandoc filter and latex macro)
- Unify chapter/appendix/bibliography hrule offsets
- index
- "list of clarifications" where i list terms that have more than one name and which name I will be using throughout my thesis
- list of terms that aren't abbreviations (e.g. "dictionary" to mean list of key-value pairs)
- how to cite BEPs (ideally they show up as "BEP 0003" in the document instead of the author's last name)
- make all libraries (BencodeKit, TorrentFileKit, etc.) Nix flakes that are inputs to this flake, so that I can grab their last modification info and inject it into the document
- switch back to using pandoc's citeproc and <https://pandoc.org/MANUAL.html#placement-of-the-bibliography> to place the bibliography in the right location
- use the section symbol when referring to sections? <https://tex.stackexchange.com/questions/208933/how-to-show-symbol-when-i-refer-a-chapter>
- improve hexdump formatting
- change big number font (it doesn't match section numbers)
- improve swift syntax highlighting

- https://cameronpatrick.com/post/2023/07/quarto-thesis-formatting


## Writing outline

aaaaaaah what am I gonna write about aaaaaaah

title: content-addressable replicated data types (teehee)

### background (crdt)

what is the problem and what are desirable things? p2p stuff, fault tolerance, cap theorem, etc; availability, partition tolerance, problem of conflicts

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

try to make MST-like structure for array/list? what about other large data types?

formalize merging the merkle-dag nodes

maybe go down the rabbit hole of compacting the dag, dropping nodes, squishing long lines of nodes, blockchain-like problems

using this merkle-dag structure with crdt payloads and store application-level conflicts (not "real" crdt conflicts) like pijul
- I think this is cool but I'm not sure what I can actually contribute in this direction
