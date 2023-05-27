Genetic Algorithm Optimization in Python
Michael Sjöberg
Jan 05, 2023
May 27, 2023

## <a name="1" class="anchor"></a> [Introduction](#1)

Genetic algorithms are a type of computational method that uses concepts from biology, such as natural selection and evolution, to find solutions to problems. They are a subclass of evolutionary computing and are used to search through a large set of potential solutions to find the best one. A binary genetic algorithm (BGA) is one type of genetic algorithm effective at working with both continuous and discrete variables, as well as optimizing many decision variables at once.

To use a BGA, we need to define its components, which includes encoding and decoding system for variables, fitness function to evaluate potential solutions, initial population of solutions, and rules for selection, mutation, and generating new solutions.

#### Dependencies

Dependencies needed.

```python
import random
import math
# https://pypi.org/project/tabulate/
from tabulate import tabulate
```

In the examples, the random seed is set to `1234`, so the algorithm will generate the same initial population and results given the same configuration variables.

```python
random.seed(1234)
```

Helper function to print table using `tabulate`.

```python
def print_table(population):
    print(tabulate(population, headers=['n', 'encoding', 'decoded x, y', 'cost'], floatfmt=".3f", tablefmt="simple"), end="\n\n")
```

## <a name="2" class="anchor"></a> [The algorithm](#2)

The decision variables are represented as binary chromosomes, where each gene in the chromosome is encoded using a certain number of bits, `M_BITS`, and must be decoded before it can be evaluated by the cost function, `f`. A population, `N_POP`, is a group of chromosomes, with each chromosome representing a potential solution to the optimization problem (cost function). The BGA works by searching through the population of chromosomes, selecting the fittest ones, and generating new solutions through crossover and mutation.

#### Encoding

The function for encoding decimal number into a binary representation is as follows.

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

The values `x_low` and `x_high` represent the lower and upper bounds of range within which the decimal number `x` must be. The value `m` is the number of bits used to encode each gene in the binary representation (it is also denoted as `M_BITS`).

#### Decoding

The function for decoding binary representation into a decimal number is `x = x_low + B * ((x_high - x_low) / ((2 ** m) - 1))`, where `B` is binary value to convert into decimal.

```python
def decode(B, x_low, x_high, m):    
    return x_low + int((''.join(map(str, B))), 2) * ((x_high - x_low) / ((2 ** m) - 1))
```

```python
assert int(decode([1, 1, 0, 0, 1], -10, 14, 5)) == 9
```

#### Generate population

The initial population of potential solutions are generated randomly and then encoded into binary chromosomes. The chromosomes are decoded and evaluated using the cost functio and then appended to a cost table, which is sorted in ascending order (smaller is better fit).

It is important to note that the index in the cost table should not be tied to a specific chromosome, as the population may change over time. Therefore, the index should be updated after each iteration in the BGA process, as there will be better solutions added to the population.

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

```python
example_population = generate_population(
    n_pop=6,
    x_range=[5, 20],
    y_range=[-5, 15],
    m_bits=4)

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

#### Generate offsprings (double-point crossover)

To generate offsprings using double-point crossover, we need to select two parent chromosomes from the population and choose two points within them as crossover points (at random or otherwise). We then split the chromosomes at these points to create four segments. The first and fourth segments are swapped between the two parent chromosomes to create two new offsprings.

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

This process combines characteristics from both parent chromosomes in the offsprings, allowing for greater diversity in the population.

#### Mutation

In genetic algorithms, mutation is a process by which small random changes are made to the chromosomes in the population. These changes, or mutations, are introduced to allow the algorithm to explore a wider range of potential solutions and avoid getting stuck in local minima.

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

The parameter `mu` is the mutation rate (it is also denoted as `MUTATE_RATE`) and is used with `M_BITS` to decide how many bits to flip. The bits are flipped at random.

#### Update population

The population is updated by replacing a number of the existing chromosomes with the new offsprings that have been generated through crossover and mutation. The number of chromosomes that are kept from the previous population is determined by the `keep` parameter (it is also denoted as `N_KEEP`).

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

The offsprings are evaluated using the cost function and sorted based on their fitness. The `N_KEEP` fittest offsprings are then appended to the previous population to create an updated population, which is the starting point for the next generation.

## <a name="3" class="anchor"></a> [Testing](#3)

In the below example, we are using configuration variables `M_BITS:4`, `N_POP:4`, `N_KEEP:2`, `MUTATE_RATE:0.1`, number of generations is set to `10000`, and crossover locations are `[3, 6]`, which also could be selected at random.

```python
M_BITS = 4
N_POP = 4
N_KEEP = 2
MUTATE_RATE = 0.1
# number of generations
MAX_GEN = 10000
# crossover
crossover = [3, 6]
```

The cost function is `f(x, y) = -x * ((y / 2) - 10)`, where x-range is `[10, 20]` and y-range is `[-5, 7]`.

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
