# Garden of Eden

## Background Introduction

The [Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) is ... Please read Wikipedia directly; we omit the details here.

The main points are:
Every cell, which is either alive or dead, interacts with its eight neighbours. The game evolves. At each time step, the following transitions occur:

1. Any live cell with exactly two or three live neighbours survives.
2. Any dead cell with exactly three live neighbours becomes a live cell.
3. All other live cells die in the next generation. All other dead cells stay dead.

A Garden of Eden is a world in the Game of Life which does not have a predecessor world. Our goal is to decide whether the input world is a Garden of Eden. A world is an element of the set of all functions

$$
W := \{\, f \mid f : \mathbb{Z}_M \times \mathbb{Z}_N \to \{0, 1\} \,\}.
$$

We define one evolution step in the Game of Life by a function $F : W \to W$, which satisfies the rules of the Game of Life. A world $X$ is a predecessor of a world $G$ if $F(X) = G$, where $X$ is the world at time $t$ and $G$ is the world at time $t+1$. Here we use the torus version and PicoSAT to solve the SAT problem.

## Language & Valuation

- Language $P = \{\, p_{i,j} \mid (i,j) \in M \times N \,\}$
  - $p_{i,j}$ is the previous state $t$ (not current $t+1$)
- $v(p_{i,j}) = 1$ if $p_{i,j}$ is alive, otherwise $0$ (dead)
  - (assign function $v$)

$$
E_k(i,j) := \bigvee_{S \subseteq N(i,j),\ |S| = k} \Big( \bigwedge_{q \in S} p_q \wedge \bigwedge_{q \in N(i,j) \setminus S} \neg p_q \Big)
$$

where $N(i,j)$ is the set of the 8 neighbours of $(i,j)$, with coordinates taken mod $M$ and mod $N$.

## Theory

$$
\alpha_{i,j} := \big(p_{i,j} \wedge E_2(i,j)\big) \vee E_3(i,j) \qquad (G(i,j) = 1)
$$

$$
\delta_{i,j} := \big(p_{i,j} \wedge \neg E_2(i,j) \wedge \neg E_3(i,j)\big) \vee \big(\neg p_{i,j} \wedge \neg E_3(i,j)\big) \qquad (G(i,j) = 0)
$$

$$
\varphi_{i,j} :=
\begin{cases}
\alpha_{i,j} & \text{if } G(i,j) = 1, \\
\delta_{i,j} & \text{if } G(i,j) = 0.
\end{cases}
$$

$$
T := \{\, \varphi_{i,j} : (i,j) \in R \,\}
$$

$T$ is satisfiable iff $G$ has predecessor.

## Sizes

- $|E_2(i,j)| = \binom{8}{2}$ (DNF)
- $|E_3(i,j)| = \binom{8}{3}$ (DNF)
- $\alpha_{i,j}$
  - 84 terms in DNF
  - negation → 84 clauses in CNF, for $G(i,j) = 0$
- $\delta_{i,j}$

  $$
  \sum_{k \in \{0\} \cup [8] \setminus \{2,3\}} \binom{8}{k} + \sum_{k \in \{0\} \cup [8] \setminus \{3\}} \binom{8}{k} = 172 + 200 = 372 \text{ terms in DNF}
  $$

  - negation → 372 clauses in CNF, for $G(i,j) = 1$

## Identity

$$
\neg E_2 \wedge \neg E_3 \equiv \bigvee_{k \in \{0,1,4,\dots,8\}} E_k
$$

$$
\Big|\, \neg E_2 \wedge \neg E_3 \,\Big| = \sum_{k \in \{0,1,4,\dots,8\}} \binom{8}{k} = 172 \text{ terms in DNF}
$$
## How to Use

Run `anime.jl`, you will see either it is UNSAT or it is SAT with an evolutionary gif.

*Not finished, will add standard input soon, to be continued.*