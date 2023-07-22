Genetic Algorithm Optimization
Michael Sjöberg
Jan 05, 2023
May 28, 2023
Python
Computational-Intelligence

In this post, we'll implement the binary genetic algorithm (BGA) in Python.


```python
import random
import math
# https://pypi.org/project/tabulate/
from tabulate import tabulate
```

```python
random.seed(1234)
```

Helper function to print table using `tabulate`.

```python
def print_table(population):
    print(tabulate(population, headers=['n', 'encoding', 'decoded x, y', 'cost'], floatfmt=".3f", tablefmt="simple"), end="\n\n")
```

## <a name="2" class="anchor"></a> [BGA](#2)

In BGA, decision variables are represented as binary chromosomes where each gene is encoded using a certain number of bits, `M_BITS`. The decision variables are encoded for selection, crossover, and mutation, and then decoded again to evaluate fitness using the cost function `f`. 

The population `N_POP` is a group of chromosomes. A chromosome represent a potential solution to the optimization problem.

### <a name="2.1" class="anchor"></a> [Encoding](#2.1)

The function for encoding a decimal number into its binary representation.

```python
def encode(x, x_low, x_high, m):
    decimal = round((x - x_low) / ((x_high - x_low) / (2 ** m - 1)))
    binary = []
    while decimal >= 1:
        if decimal % 2 == 1:
            binary.append(1)
        else:
            binary.append(0)
        decimal = math.floor(decimal / 2)
    while len(binary) < 4:
        binary.append(0)

    return list(reversed(binary))
```

```python
assert encode(9, -10, 14, 5) == [1, 1, 0, 0, 1]
```

The variables `x_low` and `x_high` are lower and upper bounds for `x`. The variable `m` is the number of bits used to encode genes (note that `m` is also referred to as `M_BITS`).

### <a name="2.2" class="anchor"></a> [Decoding](#2.2)

The function for decoding a binary representation into its decimal number, `x = x_low + B * ((x_high - x_low) / ((2 ** m) - 1))`, where `B` is binary value to convert into decimal.

```python
def decode(B, x_low, x_high, m):    
    return x_low + int((''.join(map(str, B))), 2) * ((x_high - x_low) / ((2 ** m) - 1))
```

```python
assert int(decode([1, 1, 0, 0, 1], -10, 14, 5)) == 9
```

### <a name="2.3" class="anchor"></a> [Generate population](#2.3)

The initial population is generated using `random`. The chromosomes are decoded and evaluated using the cost function `f` and then appended to the cost table, which is sorted in ascending order (lower cost is better).

```python
def generate_population(n_pop, x_range, y_range, m_bits):
    pop_lst = []
    for i in range(n_pop):
        x = random.randint(x_range[0], x_range[1])
        y = random.randint(y_range[0], y_range[1])
        # encoded values
        x_encoded = encode(x, x_range[0], x_range[1], m_bits)
        y_encoded = encode(y, y_range[0], y_range[1], m_bits)
        # decoded values
        x_decoded = round(decode(x_encoded, x_range[0], x_range[1], m_bits), 2)
        y_decoded = round(decode(y_encoded, y_range[0], y_range[1], m_bits), 2)
        # determine initial cost
        cost = round(f(x_decoded, y_decoded), 2)
        # append to list
        pop_lst.append([i, x_encoded + y_encoded, [x_decoded, y_decoded], cost])
    # sort on cost
    pop_lst.sort(key = lambda x: x[3])
    # update index
    for i in range(len(pop_lst)):
        pop_lst[i][0] = i

    return pop_lst
```

Here is an example population.

```python
example_population = generate_population(
    n_pop=6,
    x_range=[5, 20],
    y_range=[-5, 15],
    m_bits=4
)

print_table(example_population)
#   n  encoding                  decoded x, y       cost
# ---  ------------------------  --------------  -------
#   0  [0, 0, 0, 0, 0, 0, 1, 0]  [5.0, -2.33]     55.820
#   1  [0, 0, 1, 1, 1, 0, 0, 0]  [8.0, 5.67]      57.320
#   2  [0, 0, 0, 0, 0, 0, 0, 0]  [5.0, -5.0]      62.500
#   3  [0, 0, 0, 1, 0, 0, 1, 0]  [6.0, -2.33]     66.990
#   4  [0, 1, 1, 1, 0, 0, 0, 0]  [12.0, -5.0]    150.000
#   5  [1, 1, 1, 0, 0, 0, 1, 0]  [19.0, -2.33]   212.130
```

### <a name="2.4" class="anchor"></a> [Generate offsprings (double-point crossover)](#2.4)

In this post, offsprings are generated using double-point crossover, but there are many other methods.

```python
def generate_offsprings(population, crossover):
    n = 0
    offsprings_lst = []
    while n < len(population):
        offsprings_lst.append(population[n][1][0:crossover[0]] + population[n + 1][1][crossover[0]:crossover[1]] + population[n][1][crossover[1]:])
        offsprings_lst.append(population[n + 1][1][0:crossover[0]] + population[n][1][crossover[0]:crossover[1]] + population[n + 1][1][crossover[1]:])
        # pair-wise
        n += 2

    return offsprings_lst
```

Basically, this function:

- selects two parent chromosomes from the population
- chooses two points within them as crossover points (random or otherwise)
- split the chromosomes at these points to create four segments
- swap first and fourth segments between the two parent chromosomes to create two new offsprings

### <a name="2.5" class="anchor"></a> [Mutation](#2.5)

Mutation is the process used to introduce random changes to the chromosomes. Mutation is useful to allow the algorithm to explore a wider range of potential solutions and to avoid getting stuck in local optima.

```python
def mutate(offsprings, mu, m_bits):
    nbits = round(mu * (len(offsprings) * m_bits * 2))
    for i in range(nbits):
        offspring = random.randint(0, len(offsprings) - 1)
        bit = random.randint(0, m_bits * 2 - 1)
        # flip bits
        if offsprings[offspring][bit] == 1:
            offsprings[offspring][bit] = 0
        else:
            offsprings[offspring][bit] = 1

    return offsprings
```

The parameter `mu` (also referred to as `MUTATE_RATE`) is the mutation rate and is used with `M_BITS` to decide how many bits to flip. The bits are flipped at random.

### <a name="2.6" class="anchor"></a> [Update population](#2.6)

The population is updated by replacing some or all of the existing chromosomes with the new offsprings. The number of chromosomes that are kept from the previous population is determined by the `keep` parameter (also referred to as `N_KEEP`).

```python
def update_population(current_population, offsprings, keep, x_range, y_range, m_bits):
    offsprings_lst = []
    for i in range(len(offsprings)):
        # decoded values
        x_decoded = round(decode(offsprings[i][:4], x_range[0], x_range[1], m_bits), 2)
        y_decoded = round(decode(offsprings[i][4:], y_range[0], y_range[1], m_bits), 2)
        # determine initial cost
        cost = round(f(x_decoded, y_decoded), 2)
        # append to list
        offsprings_lst.append([i, offsprings[i], [x_decoded, y_decoded], cost])
    # sort on cost
    offsprings_lst.sort(key = lambda x: x[3])
    # update index
    for i in range(len(offsprings_lst)):
        offsprings_lst[i][0] = i
    # discard current population
    current_population[keep:] = offsprings_lst[:keep]
    # sort on cost
    current_population.sort(key = lambda x: x[3])
    # update index
    for i in range(len(current_population)):
        current_population[i][0] = i

    return current_population
```

The offsprings are evaluated using the cost function and sorted based on their fitness (lowest cost). The `N_KEEP` fittest offsprings then replaces the same number of least-fit chromosomes in the previous population.

## <a name="3" class="anchor"></a> [Testing](#3)

Below is the configuration variables used in this example.

```python
M_BITS = 4
N_POP = 4
N_KEEP = 2
MUTATE_RATE = 0.1
# max number of generations (feel free to change to stop at convergence)
MAX_GEN = 10000
# crossover points
crossover = [3, 6]
```

The cost function to minimize is `f(x, y) = -x * ((y / 2) - 10)`, where bounds for x-range is `[10, 20]`, and bounds for y-range is `[-5, 7]`.

```python
# cost function
def f(x, y): return -x * ((y / 2) - 10)
# range
x_range = [10, 20]
y_range = [-5, 7]
```

The initial population.

```python
current_population = generate_population(N_POP, x_range, y_range, M_BITS)
print_table(current_population)
#   n  encoding                  decoded x, y       cost
# ---  ------------------------  --------------  -------
#   0  [1, 0, 0, 0, 1, 1, 0, 0]  [15.33, 4.6]    118.040
#   1  [0, 0, 1, 1, 0, 0, 0, 1]  [12.0, -4.2]    145.200
#   2  [1, 1, 1, 0, 1, 0, 0, 1]  [19.33, 2.2]    172.040
#   3  [1, 1, 1, 0, 1, 0, 0, 1]  [19.33, 2.2]    172.040
```

The final population.

```python
for i in range(MAX_GEN):
    # generate offsprings
    offsprings = generate_offsprings(current_population, crossover)
    # mutate
    offsprings = mutate(offsprings, MUTATE_RATE, M_BITS)
    # update population
    current_population = update_population(
        current_population,
        offsprings,
        N_KEEP,
        x_range,
        y_range,
        M_BITS
    )

print_table(current_population)
#   n  encoding                  decoded x, y      cost
# ---  ------------------------  --------------  ------
#   0  [0, 0, 0, 0, 1, 1, 1, 1]  [10.0, 7.0]     65.000
#   1  [0, 0, 0, 0, 1, 1, 1, 1]  [10.0, 7.0]     65.000
#   2  [0, 0, 0, 0, 1, 1, 1, 1]  [10.0, 7.0]     65.000
#   3  [0, 0, 0, 0, 1, 1, 1, 1]  [10.0, 7.0]     65.000
```
