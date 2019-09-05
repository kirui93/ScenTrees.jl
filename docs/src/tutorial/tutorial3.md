```@meta
CurrentModule = ScenTrees
```

# Scenario Lattices

If the data process is Markovian, we approximate the process with a _scenario lattice_ instead of a scenario tree. Scenario lattices are natural discretizations of the Markov processes.

A scanrio lattice is similar to a scenario tree but has an added requirement that all nodes in stage `t` have the same children. This makes the description of a scanrio lattice less than for a scenario tree as a scenario lattice can only be described by its name, states of the nodes in the lattice and the probabilities of treansition in the lattice. 

In a scenario lattice, the total number of nodes is equal to the total number of states which is equal to the sum of the elements in the branching vector.


Consider the scenario lattice below with branching structure `1x2x3x4x5`:

![Example of a scenario lattice](../assets/ExampleLattice2.pdf)

In the above scenario lattice, the total number of nodes are `1+2+3+4+5 = 15` nodes and the total number of edges in the lattice are `(1x2)+(2x3)+(3x4)+(4x5) = 40` edges. A scenario tree with the same branching structure has 153 nodes and 153 links. This shows that, in a lattice, the number of variables do not grow exponentially as it does in a scenario tree. However, the number of possible paths in a scenario lattice is larger than in a scenario tree.
