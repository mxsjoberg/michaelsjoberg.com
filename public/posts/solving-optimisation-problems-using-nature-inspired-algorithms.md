<!--
    Solving optimisation problems using nature-inspired algorithms
    Michael Sjöberg
    September 14, 2022
-->

## <a name="1" class="anchor"></a> [1. Introduction](#1)

*Keywords: search-based algorithms, optimisation problems, exhaustive search, Nelder-Mead downhill simplex method, line minimisation, random walk*

### <a name="1.1" class="anchor"></a> [Nature-inspired algorithms](#1.1)

Nature-inspired algorithms are optimisation algorithms based on natural phenomenon (note that most are search-based):

- local search, such as gradient descent, simplex method, line minimisation, and [Newton's method](https://en.wikipedia.org/wiki/Newton%27s_method)

- non-population based global search, such as grid search, random walk, exhaustive search, and [simulated annealing](https://en.wikipedia.org/wiki/Simulated_annealing)

- population based global search, such as genetic algorithm, evolution strategies, ant colony optimisation, particle optimisation, and differential evolution

Nature-inspired algorithms are used in biological computing, where biological process provides model (genetic algorithms, ant colony optimisation, artificial immune system), computational biology, where computing provides model (cellular automata), computation with biological mechanism, such as DNA computing, and are particularly useful to find solutions that would otherwise seem unusual or unintuitive, such as [Evolved antenna](https://en.wikipedia.org/wiki/Evolved_antenna). Below are a few optimisation problems where nature-inspired algorithms frequently are used:

- function minimisation, matrix sum minimisation, area of field maximisation, curve fitting, root finding
- optimal routes, such as travelling salesman problem, shipping routes
- grid world, eight queens problem, suduko puzzle solving
- production problems, such as shipping cost minimisation, antenna tower location, profit maximisation

Nature-inspired algorithms, and in particular evolutionary algorithms, are typically very good at approximating solutions, but computational complexity and cost can be a limiting factor in production.

### <a name="1.2" class="anchor"></a> [Optimisation problems](#1.2)

An optimisation problem can be solved numerically by adjusting input, also called decision variable, to some function to find minimum or maximum output, or analytically, such as using calculus:

- minimisation problem is the inverse of maximisation, so `y = MAX[x(10 - x)]` is equivalent to `y = MIN[-x(10 - x)]`

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

- least-squares problem (analytical solution), `MIN[f(x)] = ABS(Ax - B)`<sup>`2`</sup>, where matrix is symmetric, so `A = transpose(A)`, and transposition property is `transpose(AB) = transpose(B) transpose(A)`, then `x = inverse(transpose(A)A) (transpose(A)B)`

    ```python
    import numpy as np

    A = np.random.randint(1, 100, size = (3, 3))
    b = np.random.randint(1, 100, size = (3, 1))

    x = (np.linalg.inv(A.T @ A)) (@ A.T @ b)
    print(np.allclose(A @ x, b))
    # True

    # or numpy built in
    print(np.allclose(A @ np.linalg.lstsq(A, b, rcond = -1)[0], b))
    # True
    ```

- linear programming, `MIN[f(x)] = transpose(c)x`

An optimisation problem is either function-based (cost function) or trial-and-error, single or multiple variable, static or dynamic (subject to change), discrete or continuous, constrained or unconstrained (no boundary, most optimisation problems are constrained), random or minimum-seeking. The Lagrange multiplier method can be used to solve constrained optimisation problems, such as `MIN[f(x,y,z)]` subject to condition `g(x,y,z) = c`, where Lagrange function is `L(x,y,z,l) = f(x,y,z) + l(g(x,y,z) - c)`, `l` is Lagrange multiplier, and stationary point is `L(x,y,z,l) = 0`.

Analytical optimisation methods use mathematical tools based on calculus, which also provide the foundation for gradient-based algorithms, such as gradient descent, and are generally quick to converge to extremum. However, there are no indications whether global minimum or maximum is found (it is difficult to find all extrema), need to use derivatives, so bad with cliffs, boundaries, and discrete variables:

- extreme points, or extremum, are found using gradient, so setting first derivative function to zero, `f'(x) = 0`
- minimum and maximum are found at sign shifts, where maximum is when second derivative is less than zero, or `f''(x) < 0`, and minimum is when second derivative is greater than zero, or `f''(x) > 0`

#### <a name="1.2.1" class="anchor"></a> [Exhaustive search](#1.2.1)

The exhaustive search method, or brute-force, is a numerical method that can be used to search large but finite solution space using combinations of different variables. Brute-force methods do not get stuck in local minimum with fine sampling and work with both continuous or discontinuous functions (no derivatives). However, can take long time to find global minimum, which can be missed due to under-sampling, and only practical with small number of variables in limited search space. Searching larger area with not-as fine sampling before narrowing search to smaller region with finer sampling can improve performance.

#### <a name="1.2.2" class="anchor"></a> [Nelder-Mead method](#1.2.2)

The [Nelder-Mead method](https://en.wikipedia.org/wiki/Nelder%E2%80%93Mead_method), or downhill simplex method, can be used to find local minimum of function with several variables (note that a simplex is an elementary shape formed in dimension `n + 1`, such as 2D triangle, where points are referred to as best, good, and worst, or `BGW`):

- process to search for local minimum is repeated until acceptable error, points `BGW` are iterated when finding better points
- for example, `f(x,y) = x + y`, where `x = 2` and `y = 3`, gives `f(2,3) = 5`, where point `W = (4,5)` gives `f(4,5) = 9`, so move towards `(2,3)`
	- move towards local minimum (reflection, expansion), where reflection point is `R = M + (M - W) = 2M - W` and expanding point is `E = R + (R - M) = 2R - M`
    - contract around minimum (contraction, shrinking), where contraction points are `C`<sub>`1`</sub>`= (W + M)/2` and `C`<sub>`2`</sub>`= (M + R)/2`, and shrink towards `B`, so shrink point is `S = (B + W)/2` and midpoint is `M = (B + G)/2`

#### <a name="1.2.3" class="anchor"></a> [Line minimisation](#1.2.3)

The line minimisation method, or line search, start at random point and select direction to move until cost function changes (increases or decreases depending on goal). Line search methods are generally robust and fast to converge, but use gradients, so function need to be differentiable, not guaranteed to find global minimum, bad with discrete variables, and dependent on starting point (note that this is random selection):

1. initialise starting point
2. compute search direction
4. compute step length
5. update
    - `x`<sub>`k+1`</sub>`= x`<sub>`k`</sub>`- (f'(x`<sub>`k`</sub>`) / f''(x`<sub>`k`</sub>`))`
6. check convergence, or repeat from step 2

#### <a name="1.2.4" class="anchor"></a> [Random walk](#1.2.4)

The random walk method use random numbers to move in different directions, which is particularly useful to avoid getting stuck in local minimum or explore different regions to locate additional minimums, concentrate search to smaller region to refine solution:

1. initialise starting point and best point (note that this can be the same point)
2. evaluate starting point
3. generate random correction
4. update
    - `x`<sub>`k+1`</sub>`= x`<sub>`k`</sub>`+ (D`<sub>`k`</sub>`h`<sub>`k`</sub>`)`, where  `D` is random search direction matrix and `h` is step size vector
5. evaluate function at point and update best point
6. return best point, or repeat step 3

Methods using random numbers, such as random walk, work well with discrete and continuous variables, complicated functions, discontinuous functions, and non-differential functions (no derivatives). Random-based optimisation algorithms are generally not as sensitive to initial point selection, but more sensitive to control parameters (direction and step size), and most solutions are not repeatable, so multiple runs may be needed to verify some solution.

## <a name="2" class="anchor"></a> [2. Binary Genetic Algorithm](#2)

*Keywords: genetic algorithms, binary encoding and decoding, natural selection*

### <a name="2.1" class="anchor"></a> [Genetic algorithms](#2.1)

A genetic algorithm, such as binary genetic algorithm (BGA), which is a subclass of evolutionary computing, describe population-based methods inspired by theory of evolution to solve optimisation problems. The theory of evolution states that an offspring has many characteristics of its parents, which implies population is stable, variations in characterisitcs between individuals passed from one generation to the next, where some percentage of offspring survive to adulthood, often due to inherited characteristics. Genetic algorithms borrow much of terminology from biology, such as natural selection, evolution, gene, chromosome, mating, crossover, and mutation.

The compononents of BGA are variable encoding and decoding, fitness function, population, selection, mutation, offspring, and convergance. BGAs work well with continuous and discrete variables, can handle large number of decision variables and optimise decision variables with comples cost functions. It is less likely to get stuck in local minimum and tend to find global minimum.

#### <a name="2.1.1" class="anchor"></a> [Notation](#2.1.1)

|     |     |
| :-- | :-- |
| `N`<sub>`var`</sub> | number of decision variables of chromosome |
| `N`<sub>`bits`</sub> | total number of bits of chromosome |
| `N`<sub>`pop`</sub> | population size |
| `N`<sub>`pop`</sub>`N`<sub>`bits`</sub> | total number of bits in population |
| `X`<sub>`rate`</sub> | selection rate in step of natural selection |
| `N`<sub>`keep`</sub>`= N`<sub>`pop`</sub>`X`<sub>`rate`</sub> | number of chromosomes that are kept for each generation |
| `N`<sub>`pop`</sub>`- N`<sub>`keep`</sub> | number of chromosomes to be discarded |
| `x`<sub>`low`</sub> | lower bound of variable `x` |
| `x`<sub>`high`</sub> | upper bound of variable `x` |
| `P`<sub>`n`</sub> | probability of chromosome `n` in mating pool `N`<sub>`keep`</sub> to be chosen |
| `c`<sub>`n`</sub> | cost of chromosome `n` |
| `C`<sub>`n`</sub> | normalised cost of chromosome `n` |
| `mu` | mutation rate, which is probability of mutation |

Decision variables are represented by a chromosome, such as `[var`<sub>`1`</sub>`, var`<sub>`2`</sub>`, ..., var`<sub>`N`<sub>`var`</sub></sub>`]`, where each gene is coded by `m`-bits, so total number of bits per chromosome is `N`<sub>`bits`</sub>`= m(N`<sub>`var)`</sub>, and cost is evaluated by some cost function, and result typically is represented as sorted table, or cost table. A population, `N`<sub>`pop`</sub>, is group of chromosomes, each representing a potential solution, such as `f(x,y)`, where `x,y` represent some chromosome, such as `[1100011, 0011001]`.

**Example:** binary encoding and decoding, decimal 25.3125 (base 10) to binary `11001.0101` (base 2)

- convert to binary
    - repeat divide integer part by 2 until 0 (rounded down), non-even result gives `1`, otherwise `0`, then flip (read from decimal point and out)

        |     |     |     |
        | :-- | :-- | :-- |
        | `25 / 2` | `12.5` | `1` |
        | `12 / 2` | `6`    | `0` |
        | `6 / 2`  | `3`    | `0` |
        | `3 / 2`  | `1.5`  | `1` |
        | `1 / 2`  | `0.5`  | `1` |

    - repeat multiply fractional part by 2 until 1, result greater or qual to 1 gives `1`, otherwise `0`

        |     |     |     |
        | :-- | :-- | :-- |
        | `2(0.3125)` | `0.625` | `0` |
        | `2(0.625)` | `1.25` | `1` |
        | `2(0.25)` | `0.5` | `0` |
        | `2(0.5)` | `1` | `1` |

- convert to decimal

    - `1(2`<sup>`4`</sup>`) + 1(2`<sup>`3`</sup>`) + 0(2`<sup>`2`</sup>`) + 0(2`<sup>`1`</sup>`) + 1(2`<sup>`0`</sup>`) = 25` (integer part)
    
        ```python
        # python
        print(1 * (2 ** 4) + 1 * (2 ** 3) + 0 * (2 ** 2) + 0 * (2 ** 1) + 1 * (2 ** 0))
        # 25
        ```

    - `0(2`<sup>`-1`</sup>`) + 1(2`<sup>`-2`</sup>`) + 0(2`<sup>`-3`</sup>`) + 1(2`<sup>`-4`</sup>`) = 0.3125` (fractional part)

        ```python
        # python
        print(0 * (2 ** -1) + 1 * (2 ** -2) + 0 * (2 ** -3) + 1 * (2 ** - 4))
        # 0.3125
        ```

**Example:** bits required to achieve precision of `d` decimal places given range

- `[(x`<sub>`high`</sub>`- x`<sub>`low`</sub>`)/(10`<sup>`-d`</sup>`)] =< (2`<sup>`m`</sup>`) - 1`

    - if `x`<sub>`low`</sub>`= 25`, `x`<sub>`high`</sub>`= 100`, and `d = 2`, then `[(100 - 25) / (10`<sup>`- 2`</sup>`)] =< (2`<sup>`m`</sup>`) - 1` gives `m = 12.8729`, or about 13 bits

#### <a name="2.1.2" class="anchor"></a> [Natural selection](#2.1.2)

The selection process imitates natural selection, or survival of the fittest, where only best potential solutions are selected. A selection occur each generation, or iteration and selection rate, `X`<sub>`rate`</sub>, is fraction of population that survive. The number of chromosomes that are kept is `N`<sub>`keep`</sub>, where best are kept and worst will be discarded (replaced by offsprings):

- if `N`<sub>`pop`</sub>`= 8` and `X`<sub>`rate`</sub>`= 0.5`, then `N`<sub>`keep`</sub>`= N`<sub>`pop`</sub>`X`<sub>`rate`</sub>`= 8(0.5) = 4`, so keep best 4 chromosomes in cost table

In natural selection, thresholding is a computationally cheaper alternative to ` X`<sub>`rate`</sub> and used to determine which chromosomes to keep or discard, where chromosomes with cost lower than threshold survive and higher are discarded (minimisation). A new population is generated when no chromsome within threshold, where threshold can be updated with each generation.

### <a name="2.2" class="anchor"></a> [Selection](#2.2)

The selection process involves two chromosomes selected from mating pool to produce two new offsprings (note that offsprings are either kept or discarded based on parameters):

- pairing from top to bottom, chromosomes are paired two at a time starting from the top until `N`<sub>`keep`</sub> chromosomes are selected for mating, simple and easy to implement

- random pairing, uniform random number generator to select chromosomes, all chromosomes have chance to mate, introduce diversity into population

- weighted random pairing, or roulette wheel weighting, probabilities that are inversely proportional to cost assigned to chromosomes in mating pool, where chromosomes with lowest cost have greatest chance to mate
	- rank weighting is problem independent, probabilities are calculated once, so computationally cheaper, but small population have higher probability to select same chromosome
    - cost weighting is cost function dependent, tend to weight top chromosomes more when large spread in cost between top and bottom chromosomes, tend to weight chromosomes evenly when chromosomes have about same cost, probabilities are calculated each generation, so computationally expensive
- tournament selection, problem independent, work best with larger population size but sorting is time-consuming and computationally expensive, chromosomes with good quality have higher chance to be selected
    - randomly pick small subset of chromosomes from mating pool in `N`<sub>`keep`</sub>, where chromosomes with lowest cost in subset become parent

### <a name="2.3" class="anchor"></a> [Crossover](#2.3)

The crossover process create offsprings from parents selected in the selection process by exchanging information:

- single-point crossover
    1. crossover point randomly selected between first and last bits of parent chromosomes
    2. generate two offsprings by swapping chromosomes from crossover point between parents
    3. replace any two chromosomes to be discarded in pool `N`<sub>`pop`</sub>`- N`<sub>`keep`</sub>
    4. repeat from step 1 for next two parents until pool `N`<sub>`pop`</sub>`- N`<sub>`keep`</sub> is replaced
- double-point crossover, segments between two randomly generated crossover points are swapped between parents
- uniform crossover, bits are randomly selected for swapping between parents

### <a name="2.4" class="anchor"></a> [Mutation](#2.4)

A mutation is random alteration of certain bits in list of chromosomes, which is to allow algorithm to explore cost surface by introducing new information. The mutation process:

1. choose mutation rate, `mu`, which represent probability of mutation
2. determine number of bits to be mutated
    - with elitism, `mu(N`<sub>`pop`</sub>`- 1)N`<sub>`bits`</sub>
    - without elitism, `mu(N`<sub>`pop`</sub>`)N`<sub>`bits`</sub>
3. flip bits (at random or otherwise)

### <a name="2.5" class="anchor"></a> [Convergence](#2.5)

A convergence is the stop criteria, such as found acceptable solution, exceeded maximum number of iterations, no changes to chromosomes, no changes to cost, or population statistics on mean and minimum cost.

## <a name="3" class="anchor"></a> [3. Continuous Genetic Algorithm](#3)

In this section:

## <a name="4" class="anchor"></a> [4. Advanced topics in GA](#4)

In this section:

## <a name="5" class="anchor"></a> [5. Evolution strategies](#5)

In this section:

## <a name="6" class="anchor"></a> [6. Ant colony optimisation](#6)

In this section:

## <a name="7" class="anchor"></a> [7. Particle Swarm Optimisation](#7)

In this section:

## <a name="8" class="anchor"></a> [8. Differential evolution](#8)

In this section:




