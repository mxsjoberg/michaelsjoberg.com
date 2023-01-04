<!--
    Genetic Algorithm Optimization in Python
    Michael Sjöberg
    Aug 27, 2022
-->

## <a name="1" class="anchor"></a> [Introduction](#1)

Genetic algorithms is a subclass of evolutionary computing and part of population-based search methods inspired by the theory of evolution. The theory of evolution states that an offspring has many characteristics of its parents, which implies population is stable, and variations in characterisitcs between individuals passed from one generation to the next often is due to inherited characteristics, where some percentage of offsprings survive to adulthood. Genetic algorithms borrow much of its terminology from biology, such as natural selection, evolution, gene, chromosome, mating, crossover, and mutation. Binary genetic algorithms (BGA) work well with continuous and discrete variables, can handle large number of decision variables, and optimize decision variables for cost functions. A BGA is less likely to get stuck in local minimum and often find global minimum. The common components of a BGA implementation are: variable encoding and decoding, fitness function (cost function), initial population, selection, mutation, offspring generation, and convergance condition.

#### <a name="1.1" class="anchor"></a> [Set-up](#1.1)

Install and import dependencies.

```python
import random
import math
# https://pypi.org/project/tabulate/
from tabulate import tabulate
```

## <a name="2" class="anchor"></a> [Genetic algorithm functions](#2)

BGA need decision variables to be represented as binary chromosomes, where each gene is coded by `M_BITS`, and need to be decoded before evaluated by cost function `f`. A population, `N_POP`, is a group of chromosomes, each representing a potential solution to `f`.

#### <a name="2.1.1" class="anchor"></a> [Encoding](#2.1.1)

The encoding equation is `B = (x - x_low) / [(x_high - x_low) / (2 ** m - 1)]` takes a number, `x`, range `[x_low, x_high]`, and precision `m`, and gives binary representation.

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

#### <a name="2.1.2" class="anchor"></a> [Decoding](#2.1.2)

The decoding equation is `x = x_low + B * [(x_high - x_low) / ((2 ** m) - 1)]`, which takes binary representation as input and gives decimal number.

```python
def decode(B, x_low, x_high, m):
    decoded = x_low + int((''.join(map(str, B))), 2) * ((x_high - x_low) / ((2 ** m) - 1))
    
    return decoded
```

```python
assert int(decode([1, 1, 0, 0, 1], -10, 14, 5)) == 9
assert round(decode([1, 0, 0, 0], 10, 20, 4), 2) == 15.33
```

### <a name="2.2" class="anchor"></a> [Initial population](#2.2)

The initial population is generated at random, encoded and decoded for consistency, evaluated using the cost function, and then appended to cost table (sorted). Note that the index in cost table is mainly for readability and should not be updated when table is sorted, so needs to be generated after every iteration.

```python
def generate_population(n_pop, x_range, y_range, m_bits, seed=False):
    if seed != False:
        random.seed(seed)
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

The `seed` parameter is used to set random seed to `42`, which should give same initial population as below (with same configuration variables).

```python
example_population = generate_population(
    n_pop=6,
    x_range=[5, 20],
    y_range=[-5, 15],
    m_bits=4,
    seed=42)
```

```python
print(tabulate(example_population, headers=['n', 'encoding', 'decoded x, y', 'cost'], floatfmt=".3f", tablefmt="simple"), end="\n\n")
#   n  encoding                  decoded x, y       cost
# ---  ------------------------  --------------  -------
#   0  [0, 0, 1, 0, 1, 1, 1, 0]  [7.0, 13.67]     22.160
#   1  [0, 0, 1, 1, 1, 1, 0, 1]  [8.0, 12.33]     30.680
#   2  [0, 0, 1, 1, 0, 0, 0, 0]  [8.0, -5.0]     100.000
#   3  [1, 0, 0, 0, 0, 1, 0, 1]  [13.0, 1.67]    119.140
#   4  [0, 1, 1, 1, 0, 0, 1, 1]  [12.0, -1.0]    126.000
#   5  [1, 1, 0, 1, 0, 0, 0, 1]  [18.0, -3.67]   213.030
```

### <a name="2.3" class="anchor"></a> [Generate offsprings](#2.3)

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

### <a name="2.4" class="anchor"></a> [Mutation](#2.4)

```python
def mutate(offsprings, mu, m_bits):
    nbits = round(mu * (len(offsprings) * m_bits * 2))
    for i in range(nbits):
        offspring = random.randint(0, len(offsprings) - 1)
        bit = random.randint(0, m_bits * 2 - 1)
        # swap bits
        if offsprings[offspring][bit] == 1:
            offsprings[offspring][bit] = 0
        else:
            offsprings[offspring][bit] = 1

    return offsprings
```

### <a name="2.5" class="anchor"></a> [Update population](#2.5)

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

## <a name="3" class="anchor"></a> [Running](#3)

Set configuration variables `M_BITS`, `N_POP`, `N_KEEP`, `MUTATE_RATE`, crossover locations, which could also be random, constraints, such as maxium number of iterations and range of decision variables, and define cost function.

```python
M_BITS = 4
N_POP = 4
N_KEEP = 2
MUTATE_RATE = 0.1

# generations
MAX_GEN = 10000

# cost function
def f(x, y):
    return -x * (y / 2 - 10)

# range
x_range = [10, 20]
y_range = [-5, 7]

# crossover
crossover = [3, 6]
```

Generate initial population.

```python
current_population = generate_population(N_POP, x_range, y_range, M_BITS)
print(tabulate(current_population, headers=['n', 'encoding', 'decoded x, y', 'cost'], floatfmt=".3f", tablefmt="github"), end="\n\n")
```

|   n | encoding                 | decoded x, y   |    cost |
|-----|--------------------------|----------------|---------|
|   0 | [1, 0, 0, 1, 1, 1, 0, 0] | [16.0, 4.6]    | 123.200 |
|   1 | [0, 1, 0, 0, 0, 1, 1, 0] | [12.67, -0.2]  | 127.970 |
|   2 | [0, 1, 1, 0, 0, 0, 1, 0] | [14.0, -3.4]   | 163.800 |
|   3 | [1, 0, 0, 1, 0, 1, 0, 0] | [16.0, -1.8]   | 174.400 |

Generate better population.

```python
for i in range(MAX_GEN):
    # generate offsprings
    offsprings = generate_offsprings(current_population, crossover)
    # mutate
    offsprings = mutate(offsprings, MUTATE_RATE, M_BITS)
    # update population
    current_population = update_population(current_population, offsprings, N_KEEP, x_range, y_range, M_BITS)

print(tabulate(current_population, headers=['n', 'encoding', 'decoded x, y', 'cost'], floatfmt=".3f", tablefmt="github"), end="\n\n")
```

|   n | encoding                 | decoded x, y   |   cost |
|-----|--------------------------|----------------|--------|
|   0 | [0, 0, 0, 0, 1, 1, 1, 1] | [10.0, 7.0]    | 65.000 |
|   1 | [0, 0, 0, 0, 1, 1, 1, 1] | [10.0, 7.0]    | 65.000 |
|   2 | [0, 0, 0, 0, 1, 1, 1, 1] | [10.0, 7.0]    | 65.000 |
|   3 | [0, 0, 0, 0, 1, 1, 1, 0] | [10.0, 6.2]    | 69.000 |


