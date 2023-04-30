<!--
    Lecture notes on nature-inspired learning algorithms
    Michael Sjöberg
-->

*This is a draft. This post is adapted from my own notes taken during postgraduate studies at King's College London.*

## <a name="1" class="anchor"></a> [1. Introduction](#1)

### <a name="1.1" class="anchor"></a> [1.1 Evolutionary algorithms](#1.1)

Evolutionary algorithms are search-based global optimization algorithms based on natural phenomenon:

- local search, such as gradient descent, simplex method, line minimization, [Newton's method](https://en.wikipedia.org/wiki/Newton%27s_method)
- non-population based global search, such as grid search, random walk, exhaustive search, [simulated annealing](https://en.wikipedia.org/wiki/Simulated_annealing)
- population based global search, such as genetic algorithm, evolution strategies, ant colony optimization, particle swarm optimization, differential evolution

Evolutionary algorithms are very good at approximating solutions, but computational complexity and cost can be a limiting factor in production environments (see [Evolved antenna](https://en.wikipedia.org/wiki/Evolved_antenna)).

### <a name="1.2" class="anchor"></a> [1.2 Optimization problems](#1.2)

An optimization problem can be solved numerically by adjusting the input (decision variable), to some function to find minimum or maximum output. Goal is to the find decision variable that gives minimum or maximum output.

A minimization problem is the inverse of maximization, so finding `y = MAX[x(10 - x)]` is equivalent to `y = MIN[-x(10 - x)]`.

```python
y = lambda x : x * (10 - x)
def MAX(fn, res, range_):
    for n in range_: res.append((n, fn(n)))
    return print(max(res, key = lambda tuple: tuple[1]))

MAX(y, [], range(100))
# (5, 25)
```

```python
y = lambda x : -x * (10 - x)
def MIN(fn, res, range_):
    for n in range_: res.append((n, fn(n)))
    return print(min(res, key = lambda tuple: tuple[1]))

MIN(y, [], range(100))
# (5, -25)
```

Optimization problems can be function-based (cost function) or trial-and-error, static or dynamic (subject to change), constrained or unconstrained (most optimization problems are constrained).

To solve a constrained optimization problem:

- [Lagrange multiplier method](https://en.wikipedia.org/wiki/Lagrange_multiplier), `MIN[f(x,y,z)]` s.b. `c = g(x,y,z)`
    - Lagrange function is `L(x,y,z,l) = f(x,y,z) + l(g(x,y,z) - c)`, where `l` is the Lagrange multiplier, then stationary point is `L(x,y,z,l) = 0`


#### <a name="1.2.1" class="anchor"></a> [Exhaustive search](#1.2.1)

An exhaustive search method, or brute-force, is a numerical method that can be used to search a large but finite solution space using combinations of different variables.

Brute-force methods do not get stuck in local minimum with fine sampling and work with both continuous or discontinuous functions (no derivatives). However, brute-force can take long time to find global best, or missed due to under-sampling, and only practical with small number of variables in limited search space.

#### <a name="1.2.2" class="anchor"></a> [Nelder-Mead method](#1.2.2)

The [Nelder-Mead method](https://en.wikipedia.org/wiki/Nelder%E2%80%93Mead_method), or downhill simplex method, can be used to find local minimum of function with several variables (a simplex is an elementary shape formed in dimension `n + 1`, such as 2D triangle, where points are referred to as best, `B`, good, `G`, and worst, `W`.

The process to search for local minimum is repeated until acceptable error and the points `BGW` are iterated when finding better points:

- `f(x,y) = x + y` with `x = 2` and `y = 3` gives `f(2,3) = 5`, and point `W = (4,5)` gives `f(4,5) = 9`, so move towards `(2,3)`, which is smaller (minimum)

    - move towards local minimum (reflection, expansion), where reflection point is `R = M + (M - W) = 2M - W` and expanding point is `E = R + (R - M) = 2R - M`

    - contract around minimum (contraction, shrinking), where contraction points are `C1 = (W + M) / 2` and `C2 = (M + R) / 2`, and shrink towards `B`, so shrink point is `S = (B + W) / 2` and midpoint is `M = (B + G) / 2`

#### <a name="1.2.3" class="anchor"></a> [Line minimization](#1.2.3)

A line minimization method, or line search, starts at a random point and selects direction to move until cost function changes (increases or decreases depending on goal).

Line search methods are generally robust and fast to converge, but use gradients, so function need to be differentiable, and is not guaranteed to find global minimum:

1. initialise starting point
2. compute search direction
4. compute step length
5. update
    - `x[k+1] = x[k] - f'(x[k]) / f''(x[k]`
6. check convergence, or repeat from step 2

#### <a name="1.2.4" class="anchor"></a> [Random walk](#1.2.4)

The random walk method use random numbers to move in different directions, which is particularly useful to avoid getting stuck in local minimum or explore different regions to locate additional minimums, concentrate search to smaller region to refine solution:

1. initialise starting point and best point (this can be the same point)
2. evaluate starting point
3. generate random correction
4. update
    - `x[k+1] = x[k] + D[k] * h[k]` where `D` is random search direction matrix and `h` is step size vector
5. evaluate function at point and update best point
6. return best point, or repeat step 3

Random walk and other methods using random numbers work with discrete and continuous variables, discontinuous functions and non-differential functions (no derivatives), and not as sensitive to initial point selection but more sensitive to control parameters (direction and step size).

Note that solutions found using random numbers are not repeatable so multiple runs may be needed to verify.

## <a name="2" class="anchor"></a> [2. Genetic algorithms (GA)](#2)

Genetic algorithms describe population-based methods that are inspired by natural selection. 

> Natural selection is the differential survival and reproduction of individuals due to differences in phenotype. It is a key mechanism of evolution, the change in the heritable traits characteristic of a population over generations. Charles Darwin popularised the term "natural selection", contrasting it with artificial selection, which is intentional, whereas natural selection is not. [Wikipedia](https://en.wikipedia.org/wiki/Natural_selection)

Darwin's theory of evolution states that an offspring has many characteristics of its parents, which implies population is stable, and variations in characterisitcs between individuals passed from one generation to the next often is from inherited characteristics, where some percentage of offsprings survive to adulthood. 

### <a name="2.1" class="anchor"></a> [2.1 Binary Genetic Algorithms](#2.1)

Binary genetic algorithms (BGA) work well with continuous and discrete variables and can handle large number of decision variables. The decision variables are evaluated with cost functions. BGA is less likely to get stuck in local minimum.

#### <a name="2.1.1" class="anchor"></a> [Notation](#2.1.1)

|     |     |
| :-- | :-- |
| `N[var]` | number of decision variables of chromosome|
| `N[bits]` | total number of bits of chromosome |
| `N[pop]` | population size |
| `N[pop]N[bits]` | total number of bits in population |
| `X` | selection rate in step of natural selection |
| `N[keep] = XN[pop]` | number of chromosomes that are kept for each generation |
| `N[pop] - N[keep]` | number of chromosomes to be discarded |
| `x[low]` | lower bound of variable `x` |
| `x[high]` | upper bound of variable `x` |
| `P[n]` | probability of chromosome `n` in mating pool `N[keep]` to be chosen |
| `c[n]` | cost of chromosome `n` |
| `C[n]` | normalised cost of chromosome `n` |
| `mu` | mutation rate, which is probability of mutation |

Decision variables are represented as chromosomes, such as `[v[1], v[2], ..., v[N[var]]`, where each gene is coded by `m`-bits, so total number of bits per chromosome is `N[bits] = mN[var]`, cost is evaluated by some cost function, and result is presented as sorted table, or cost table (most fit at top).

A population, `N[pop]`, is a group of chromosomes, each representing a potential solution to function, such as `f(x,y)`, where `(x, y)` represent some chromosome, such as `[1100011, 0011001]`.

#### <a name="2.1.2" class="anchor"></a> [Natural selection in binary](#2.1.2)

The selection process imitates natural selection, where only best potential solutions are selected. A selection occur each generation, or iteration, and selection rate, `X`, is fraction of population that survive.

The number of chromosomes that are kept is `N[keep]`, where best are kept and worst are discarded (replaced by offsprings):

- `N[pop] = 8` and `X = 0.5`, then `N[keep] = X * N[pop] = 8 * 0.5 = 4`, so keep best four chromosomes

Note that thresholding is computationally cheaper to selection rate, where chromosomes with costs lower than threshold survive and higher are discarded (minimization). A new population is generated when no chromsomes are within threshold (threshold can be updated with each iteration).

#### <a name="2.1.3" class="anchor"></a> [Binary encoding and decoding](#2.1.2)

Below is an example of binary encoding and decoding:

- convert 25.3125 (base 10) integer part to binary by repeatedly dividing integer part by 2 until 0 (rounded down), non-even result gives 1, otherwise 0, then flip (read from decimal point and out), then 

|          |      |     |
| :------- | :--- | :-- |
| `25 / 2` | 12.5 | 1   |
| `12 / 2` | 6    | 0   |
| `6 / 2`  | 3    | 0   |
| `3 / 2`  | 1.5  | 1   |
| `1 / 2`  | 0.5  | 1   |

- convert 25.3125 (base 10) fraction part to binary by repeatedly multiplying fractional part by 2 until 1, result greater or qual to 1 gives 1, otherwise 0

|              |       |     |
| :----------- | :---- | :-- |
| `2 * 0.3125` | 0.625 | 0   |
| `2 * 0.625`  | 1.25  | 1   |
| `2 * 0.25`   | 0.5   | 0   |
| `2 * 0.5`    | 1     | 1   |

- convert `11001.0101` (base 2) integer part to decimal

```python
print(1 * (2 ** 4) + 1 * (2 ** 3) + 0 * (2 ** 2) + 0 * (2 ** 1) + 1 * (2 ** 0))
# 25
```

- convert `11001.0101` (base 2) fractional part to decimal

```python
print(0 * (2 ** -1) + 1 * (2 ** -2) + 0 * (2 ** -3) + 1 * (2 ** - 4))
# 0.3125
```

#### <a name="2.1.4" class="anchor"></a> [Bits required to achieve precision](#2.1.3)

Below is an example to find bits required to achieve precision of `d` decimal places given a range:

- `(x[high] - x[low]) / 10 ** -d <= 2 ** m - 1`
    
    - `x[low] = 25`, `x[high] = 100`, and `d = 2`, then `(100 - 25) / 10 ** -2 <= 2 ** m - 1` gives `m <= 12.8729`, so about 13 bits

### <a name="2.2" class="anchor"></a> [2.2 Selection](#2.2)

The selection process involves selecting two chromosomes from the mating pool to produce two new offsprings, and the offsprings are either kept or discarded based on parameters:

- pairing from top to bottom, chromosomes are paired two at a time starting from the top until $N_{keep}$ chromosomes are selected for mating, simple and easy to implement

- random pairing, uniform random number generator to select chromosomes, all chromosomes have chance to mate, introduce diversity into population

#### <a name="2.2.1" class="anchor"></a> [Weighted random pairing](#2.2.1)

Weighted random pairing, or roulette wheel weighting, assign probabilities that are inversely proportional to cost to chromosomes in mating pool, where chromosomes with lowest cost have greatest chance to mate:

- rank weighting is problem independent, probabilities are calculated once, so computationally cheaper, but small population have higher probability to select same chromosome

- cost weighting is cost function dependent, tend to weight top chromosomes more when large spread in cost between top and bottom chromosomes, tend to weight chromosomes evenly when chromosomes have about same cost, probabilities are calculated each generation, so computationally expensive

#### <a name="2.2.2" class="anchor"></a> [Tournament selection](#2.2.2)

Tournament selection is problem independent and work best with larger population size, but sorting is time-consuming and computationally expensive, chromosomes with good quality have higher chance to be selected

- randomly pick small subset of chromosomes from mating pool in `N[keep]`, where chromosomes with lowest cost in subset become parent

### <a name="2.3" class="anchor"></a> [2.3 Crossover and mutation](#2.3)

The crossover process create offsprings by exchanging information between parents selected in the selection process:

- single-point crossover
    1. crossover point randomly selected between first and last bits of parent chromosomes
    2. generate two offsprings by swapping chromosomes from crossover point between parents
    3. replace any two chromosomes to be discarded in pool `N[pop] - N[keep]`
    4. repeat from step 1 for next two parents until pool `N[pop] - N[keep]` is replaced

- double-point crossover, segments between two randomly generated crossover points are swapped between parents

- uniform crossover, bits are randomly selected for swapping between parents

A mutation is a random alteration of certain bits in cost table with chromosomes, this is to allow the algorithm to explore a wider cost surface by introducing new information:

1. choose mutation rate, `mu`, which represent probability of mutation

2. determine number of bits to be mutated
    - with elitism, `mu(N[pop] - 1) * N[bits]`
    - without elitism, `mu(N[pop]) * N[bits]`

3. flip bits (at random or otherwise)

Note that the selection, crossover, and mutation processes should continue until the population meets some stopping criteria (convergence), such as finding an acceptable solution, exceeded maximum number of iterations, no changes to chromosomes, no changes to cost, or population statistics on mean and minimum cost.

## <a name="3" class="anchor"></a> [3. Continuous Genetic Algorithm](#3)

Continuous genetic algorithms (CGA) are similar to a binary genetic algorithm, except that the chromosome is represented by a string of real numbers, and the crossover and mutation process is different. It is more logical to represent machine precision in floating-point and results in faster execution (no encoding and decoding).

CGAs can deal with complex problems with high dimensionality and only limited to internal precision errors in computers.

### <a name="3.1" class="anchor"></a> [3.1 Crossover and mutation](#3.1)

Crossover is similar to BGA, but exchanging variables instead of bits, so the crossover point is a random number between first and last variable of parent chromosomes:

- blending is a linear process done for all variables left and right of crossover point, blending ensure that we do not introduce more extreme variables than already present in population (sometimes disadvantage)

    - `O[1] = B * P[1][m] + (1 - B) * P[2][m]` and `O[2] = (1 - B) * P[1][m] + B * P[2][m]`, where `B` is random variable between 0 and 1 (blending), `O[n]` is offspring, `P[n]` is parent chromosomes, and `m` is `m`-th variable in parent

- extrapolation allows introduction of variables outside of parent values (can be discarded if outside allowed range)

    - `O[1] = P[1][m] - B(P[1][n] - P[2][n])` and `O[2] = P[2][m] + B(P[1][n] - P[2][n])`, where `B` is random variable

In CGA, total number of variables that can be mutated in population is `mu * (N[pop] - 1) * N[var]` (elitism) and mutate chosen variables `P'[n] = P[n] + C * N[n](0, 1)`, where `C` is constant and `N[n](0, 1)` is normal distribution.

## <a name="4" class="anchor"></a> [4. Advanced topics in GA](#4)

#### <a name="4.0.1" class="anchor"></a> [Handling expensive cost functions](#4.0.1)

A complicated cost function can be computationally expensive and time consuming for evaluation. Here are a few approaches to reduce the number of function evaluations:

- identical chromosomes are not evaluated more than once (duplicate evaluation)
- only allow unique chromosomes in population
- duplicate offsprings are discarded (search time is less than evaluation time)
- only evaluate cost of offsprings with mutated chromosomes

### <a name="4.0.2" class="anchor"></a> [Multiple-objective optimization](#4.0.2)

Multiple-objective optimization refers to optimizing for a set of cost functions where objectives conflict:

- optimizing one cost function degrade the other (not always possible to optimize all cost functions)
- goal is to find feasible solution (maximizing yield or minimizing cost) 


## <a name="5" class="anchor"></a> [5. Evolution strategies](#5)

In this section:

## <a name="6" class="anchor"></a> [6. Ant colony optimisation](#6)

In this section:

## <a name="7" class="anchor"></a> [7. Particle Swarm Optimisation](#7)

In this section:

## <a name="8" class="anchor"></a> [8. Differential evolution](#8)

In this section:




