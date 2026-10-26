## Language & valuation

- language P: {p(i,j) for all i,j in MxN}
  - p(i,j) is the previous state t (not current t+1)
- v(p(i,j)) = 1 if p(i,j) is alive, otherwise 0 (dead)
  - (assign function v)

## Rules

- G(i,j) = 1 <=> (center alive ∧ exactly 2) ∨ (exactly 3) <=> (p(i,j) ∧ C(8,2) ∨ C(8,3) )
- G(i,j) = 0 <=> (center alive ∧ ¬exactly 2 ∧ ¬exactly 3) ∨ (center dead ∧ ¬exactly 3) <=> (p(i,j) ∧ ¬(C(8,2)) ∧ ¬(C(8,3))) ∨ ¬(p(i,j) ∧ ¬(C(8,3))))

## Theory

- α_{i,j} := (p(i,j) ∧ E₂(i,j)) ∨ E₃(i,j)  (G(i,j)=1)
- δ_{i,j} := (p(i,j) ∧ ¬E₂(i,j) ∧ ¬E₃(i,j)) ∨ (¬p(i,j) ∧ ¬E₃(i,j))  (G(i,j)=0)
- If G(i, j) = 1, let φ_{i,j} := α_{i,j}
- If G(i, j) = 0, let φ_{i,j} := δ_{i,j}

T := { φ_{i,j} : (i, j) ∈ R }

## Sizes

- |E₂(i,j)| = C(8,2) (DNF)
- |E₃(i,j)| = C(8,3) (DNF)
- α_{i,j}
  - 84 terms in DNF
  - negation → 84 clauses in CNF, for G(i,j)=0
- δ_{i,j}
  - C(8,k) for k in {0}U[8] \ {2,3} + C(8,k) for k in {0}U[8] \ {3} = 172 + 200 = 372 terms in DNF
  - negation → 372 clauses in CNF, for G(i,j)=1

## Identity

¬E₂ ∧ ¬E₃ ≡ ⋁_{k ∈ {0,1,4,…,8}} E_k = C(8,k) for k in {0,1,4,…,8}
