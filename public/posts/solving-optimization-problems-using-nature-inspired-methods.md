<!--
    Solving Optimization Problems using Nature-Inspired Methods
    Michael Sjöberg
    November 16, 2022
-->

Related content: [Genetic Algorithm Optimization in Python](/programming/python/other/genetic-algorithm-optimization)

## <a name="1" class="anchor"></a> [1. Introduction](#1)

### <a name="1.1" class="anchor"></a> [1.1 Nature-inspired methods](#1.1)

Nature-inspired methods are search-based optimization algorithms based on natural phenomenon,

- local search
    - gradient descent, simplex method, line minimization, [Newton's method](https://en.wikipedia.org/wiki/Newton%27s_method)
- non-population based global search
    - grid search, random walk, exhaustive search, [simulated annealing](https://en.wikipedia.org/wiki/Simulated_annealing)
- population based global search
    - genetic algorithm, evolution strategies, ant colony optimization, particle optimization, differential evolution

Nature-inspired methods are often used in biological computing, where biological process provides model (e.g., genetic algorithms, ant colony optimization, artificial immune system), computational biology, where computing provides model (e.g., cellular automata), computation with biological mechanism, such as DNA computing, and are particularly suitable to find solutions that are unusual or unintuitive (e.g., [Evolved antenna](https://en.wikipedia.org/wiki/Evolved_antenna)). Evolutionary algorithms are very good at approximating solutions, but computational complexity and cost can be a limiting factor in production.

### <a name="1.2" class="anchor"></a> [1.2 Optimisation problems](#1.2)

An optimization problem can be solved numerically by adjusting the input, or decision variable, to some function to find minimum or maximum output (note that goal is to the find decision variable that gives minimum or maximum output):

- minimization problem is the inverse of maximization, so finding $y = \textbf{MAX}\left[x(10 - x)\right]$ is equivalent to $y = \textbf{MIN}\left[-x(10 - x)\right]$

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

- least-squares problem (analytical solution), $\textbf{MIN}\left[f(x)\right] = \|Ax - b\|^{2}$, where matrix is symmetric, so $A = A^{T}$, and transposition property is $(Ab)^{T} = b^{T} A^{T}$, then $x = (A^{T} A)^{-1} (A^{T} b)$

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

Solutions to optimization problems can be function-based (cost function) or trial-and-error, static or dynamic (subject to change), constrained or unconstrained (note that most optimization problems are constrained). To solve a constrained optimization problem:

- [Lagrange multiplier method](https://en.wikipedia.org/wiki/Lagrange_multiplier), $\textbf{MIN}\left[f(x, y, z)\right]$ subject to condition $c = g(x, y, z)$, Lagrange function is $L(x, y, z, l) = f(x, y, z) + l(g(x, y, z) - c)$, where $l$ is Lagrange multiplier, and stationary point is $L(x, y, z, l) = 0$.

##### <a name="1.2.1" class="anchor"></a> [Exhaustive search](#1.2.1)

An exhaustive search method, or brute-force, is a numerical method that can be used to search a large but finite solution space using combinations of different variables. Brute-force methods do not get stuck in local minimum with fine sampling and work with both continuous or discontinuous functions (no derivatives). However, brute-force can take long time to find global minimum, or missed due to under-sampling, and only practical with small number of variables in limited search space.

##### <a name="1.2.2" class="anchor"></a> [Nelder-Mead method](#1.2.2)

The [Nelder-Mead method](https://en.wikipedia.org/wiki/Nelder%E2%80%93Mead_method), or downhill simplex method, can be used to find local minimum of function with several variables (a simplex is an elementary shape formed in dimension $n+1$, such as 2D triangle, where points are referred to as best ($B$), good ($G$), and worst ($W$):

- process to search for local minimum is repeated until acceptable error, points $BGW$ are iterated when finding better points
- for example, $f(x, y) = x + y$, where $x = 2$ and $y = 3$, gives $f(2,3) = 5$, where point $W = (4,5)$ gives $f(4,5) = 9$, so move towards $(2,3)$
	- move towards local minimum (reflection, expansion), where reflection point is $R = M + (M - W) = 2M - W$ and expanding point is $E = R + (R - M) = 2R - M$
    - contract around minimum (contraction, shrinking), where contraction points are $C_{1} = \frac{W + M}{2}$ and $C_{2} = \frac{M + R}{2}$, and shrink towards $B$, so shrink point is $S = \frac{B + W}{2}$ and midpoint is $M = \frac{B + G}{2}$

##### <a name="1.2.3" class="anchor"></a> [Line minimisation](#1.2.3)

A line minimisation method, or line search, starts at random point and selects direction to move until cost function changes (increases or decreases depending on goal). Line search methods are generally robust and fast to converge, but use gradients, so function need to be differentiable, and is not guaranteed to find global minimum:

1. initialise starting point
2. compute search direction
4. compute step length
5. update, $x_{k+1} = x_{k} - \frac{f'(x_{k})}{f''(x_{k)})}$
6. check convergence, or repeat from step 2

##### <a name="1.2.4" class="anchor"></a> [Random walk](#1.2.4)

The random walk method use random numbers to move in different directions, which is particularly useful to avoid getting stuck in local minimum or explore different regions to locate additional minimums, concentrate search to smaller region to refine solution:

1. initialise starting point and best point (note that this can be the same point)
2. evaluate starting point
3. generate random correction
4. update, $x_{k+1} = x_{k} + D_{k} h_{k}$, where $D$ is random search direction matrix and $h$ is step size vector
5. evaluate function at point and update best point
6. return best point, or repeat step 3

Random walk, and other methods using random numbers, work well with discrete and continuous variables, complicated functions, discontinuous functions, and non-differential functions (no derivatives). Random-based optimisation algorithms are not as sensitive to initial point selection, but more sensitive to control parameters (direction and step size), and most solutions are not repeatable, so multiple runs may be needed to verify some solution.

## <a name="2" class="anchor"></a> [2. Binary Genetic Algorithm](#2)

### <a name="2.1" class="anchor"></a> [2.1 Genetic algorithms](#2.1)

Genetic algorithms is a subclass of evolutionary computing and describe population-based methods inspired by theory of evolution. The theory of evolution states that an offspring has many characteristics of its parents, which implies population is stable, and variations in characterisitcs between individuals passed from one generation to the next often is due to inherited characteristics, where some percentage of offsprings survive to adulthood. Genetic algorithms borrow much of its terminology from biology, such as natural selection, evolution, gene, chromosome, mating, crossover, and mutation. 

Binary genetic algorithms (BGA) work well with continuous and discrete variables, can handle large number of decision variables and optimize decision variables with cost functions. BGA is less likely to get stuck in local minimum and tend to find global minimum. Common components of the BGA are variable encoding and decoding, fitness function, population, selection, mutation, offspring, and convergance.

##### <a name="2.1.1" class="anchor"></a> [Notation](#2.1.1)

|     |     |
| :-- | :-- |
| $N_{var}$ | number of decision variables of chromosome |
| $N_{bits}$ | total number of bits of chromosome |
| $N_{pop}$ | population size |
| $N_{pop} N_{bits}$ | total number of bits in population |
| $X_{rate}$ | selection rate in step of natural selection |
| $N_{keep} = N_{pop} X_{rate}$ | number of chromosomes that are kept for each generation |
| $N_{pop} - N_{keep}$ | number of chromosomes to be discarded |
| $x_{low}$ | lower bound of variable $x$ |
| $x_{high}$ | upper bound of variable $x$ |
| $P_{n}$ | probability of chromosome $n$ in mating pool $N_{keep}$ to be chosen |
| $c_{n}$ | cost of chromosome $n$ |
| $C_{n}$ | normalised cost of chromosome $n$ |
| $\mu$ | mutation rate, which is probability of mutation |

Decision variables are represented as chromosomes, such as $[v_{1}, v_{2}, ..., v_{N_{var}}]$, where each gene is coded by $m$-bits, so total number of bits per chromosome is $N_{bits} = m(N_{var})$, cost is evaluated by some cost function, and result is typically presented as sorted table, or cost table. A population, $N_{pop}$, is a group of chromosomes, each representing a potential solution to function, such as $f(x, y)$, where $(x, y)$ represent some chromosome (e.g., $[1100011, 0011001]$).

##### <a name="2.1.2" class="anchor"></a> [Natural selection](#2.1.2)

The selection process imitates natural selection, i.e. survival of the fittest, where only best potential solutions are selected. A selection occur each generation, or iteration, and selection rate, $X_rate$, is fraction of population that survive. The number of chromosomes that are kept is $N_{keep}$, where best are kept and worst will be discarded (replaced by offsprings):

- if $N_{pop} = 8$ and $X_{rate} = 0.5$, then $N_{keep} = N_{pop} X_{rate} = 8(0.5) = 4$, so keep best 4 chromosomes in cost table

In natural selection, thresholding is a computationally cheaper alternative to $X_{rate}$ and used to determine which chromosomes to keep or discard, where chromosomes with cost lower than threshold survive and higher are discarded (minimization). A new population is generated when no chromsome within threshold, where threshold can be updated with each generation.

---

#### <a name="2.1.3" class="anchor"></a> [**Example**: binary encoding and decoding](#2.1.2)

Below is an example of binary encoding and decoding a decimal, 25.3125 (base 10), to binary, $11001.0101$ (base 2):

- convert to binary
    - repeat divide integer part by 2 until 0 (rounded down), non-even result gives 1, otherwise 0, then flip (read from decimal point and out)

        |     |     |     |
        | :-- | :-- | :-- |
        | $\frac{25}{2}$ | 12.5 | 1 |
        | $\frac{12}{2}$ | 6    | 0 |
        | $\frac{6}{2}$  | 3    | 0 |
        | $\frac{3}{2}$  | 1.5  | 1 |
        | $\frac{1}{2}$  | 0.5  | 1 |

    - repeat multiply fractional part by 2 until 1, result greater or qual to 1 gives 1, otherwise 0

        |     |     |     |
        | :-- | :-- | :-- |
        | $2(0.3125)$ | 0.625 | 0 |
        | $2(0.625)$  | 1.25  | 1 |
        | $2(0.25)$   | 0.5   | 0 |
        | $2(0.5)$    | 1     | 1 |

- convert to decimal

    - integer part, $1(2^{4}) + 1(2^{3}) + 0(2^{2}) + 0(2^{1}) + 1(2^{0}) = 25$
    
        ```python
        # python
        print(1 * (2 ** 4) + 1 * (2 ** 3) + 0 * (2 ** 2) + 0 * (2 ** 1) + 1 * (2 ** 0))
        # 25
        ```

    - fractional part, $0(2^{-1}) + 1(2^{-2}) + 0(2^{-3}) + 1(2^{-4}) = 0.3125$

        ```python
        # python
        print(0 * (2 ** -1) + 1 * (2 ** -2) + 0 * (2 ** -3) + 1 * (2 ** - 4))
        # 0.3125
        ```

---

#### <a name="2.1.4" class="anchor"></a> [**Example**: bits required to achieve precision](#2.1.3)

Below is an example to find bits required to achieve precision of $d$ decimal places given a range:

- $\frac{x_{high} - x_{low}}{10^{-d}} \leq 2^{m} - 1$
    
    - if $x_{low} = 25$, $x_{high} = 100$, and $d = 2$
    
    - then $\frac{100 - 25}{10^{-2}} \leq 2^{m} - 1$ gives $m = 12.8729$, or about 13 bits

---

### <a name="2.2" class="anchor"></a> [Selection](#2.2)

The selection process involves selecting two chromosomes from the mating pool to produce two new offsprings, and the offsprings are either kept or discarded based on parameters:

- pairing from top to bottom, chromosomes are paired two at a time starting from the top until $N_{keep}$ chromosomes are selected for mating, simple and easy to implement

- random pairing, uniform random number generator to select chromosomes, all chromosomes have chance to mate, introduce diversity into population

- weighted random pairing, or roulette wheel weighting, probabilities that are inversely proportional to cost assigned to chromosomes in mating pool, where chromosomes with lowest cost have greatest chance to mate
	- rank weighting is problem independent, probabilities are calculated once, so computationally cheaper, but small population have higher probability to select same chromosome
    - cost weighting is cost function dependent, tend to weight top chromosomes more when large spread in cost between top and bottom chromosomes, tend to weight chromosomes evenly when chromosomes have about same cost, probabilities are calculated each generation, so computationally expensive
- tournament selection, problem independent, work best with larger population size but sorting is time-consuming and computationally expensive, chromosomes with good quality have higher chance to be selected
    - randomly pick small subset of chromosomes from mating pool in $N_{keep}$, where chromosomes with lowest cost in subset become parent

### <a name="2.3" class="anchor"></a> [Crossover](#2.3)

The crossover process create offsprings by exchanging information between parents selected in the selection process:

- single-point crossover
    1. crossover point randomly selected between first and last bits of parent chromosomes
    2. generate two offsprings by swapping chromosomes from crossover point between parents
    3. replace any two chromosomes to be discarded in pool $N_{pop} - N_{keep}$
    4. repeat from step 1 for next two parents until pool $N_{pop} - N_{keep}$ is replaced
- double-point crossover, segments between two randomly generated crossover points are swapped between parents
- uniform crossover, bits are randomly selected for swapping between parents

### <a name="2.4" class="anchor"></a> [Mutation](#2.4)

A mutation is random alteration of certain bits in cost table with chromosomes, this is to allow the algorithm to explore a wider cost surface by introducing new information. The mutation process:

1. choose mutation rate, $\mu$, which represent probability of mutation
2. determine number of bits to be mutated
    - with elitism, $\mu(N_{pop} - 1) N_{bits}$
    - without elitism, $\mu(N_{pop}) N_{bits}$
3. flip bits (at random or otherwise)

### <a name="2.5" class="anchor"></a> [Convergence](#2.5)

A convergence is the stop criteria, such as finding an acceptable solution, exceeded maximum number of iterations, no changes to chromosomes, no changes to cost, or population statistics on mean and minimum cost.

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




