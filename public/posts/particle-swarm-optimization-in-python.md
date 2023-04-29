<!--
    Particle Swarm Optimization in Python
    Michael Sjöberg
    Jan 16, 2023
-->

## <a name="1" class="anchor"></a> [Introduction](#1)

<!-- Particle swarm optimization (PSO) is a computational method used to find the optimal solution to problems. It is based on the behavior of large groups in nature, such as flocks of birds and swarms of insects, where individuals work together to find food or a new home. In PSO, each possible solution is represented by a particle that moves around in the solution space. The particles are guided by their own best solution (local best), as well as the best solution found by other particles (global best). -->

In this post, we'll implement particle swarm optimization (PSO) using Python. Here's the definition from [Wikipedia](https://en.wikipedia.org/wiki/Particle_swarm_optimization):

> In computational science, particle swarm optimization (PSO)[1] is a computational method that optimizes a problem by iteratively trying to improve a candidate solution with regard to a given measure of quality. It solves a problem by having a population of candidate solutions, here dubbed particles, and moving these particles around in the search-space according to simple mathematical formula over the particle's position and velocity. Each particle's movement is influenced by its local best known position, but is also guided toward the best known positions in the search-space, which are updated as better positions are found by other particles. This is expected to move the swarm toward the best solutions.

### <a name="1.1" class="anchor"></a> [Setup](#1.1)

Install and import dependencies.

```python
import random
```

## <a name="2" class="anchor"></a> [Particle Swarm Optimization (PSO)](#2)

### <a name="2.1" class="anchor"></a> [Initialization](#2.1)

The starting particles are randomly placed in the solution space.

```python
def generate_swarm(x_0, n_par):
    # dimensions (number of variables)
    dimensions = len(x_0)
    swarm = []
    # generate particles
    for i in range(0, n_par):
        position = []
        # best position
        position_best = -1
        # particle velocity
        velocity = []
        # particle error (cost)
        error = -1
        # best error (cost)
        error_best = error
        # position and velocity
        for i in range(0, dimensions):
            position.append(x_0[i])
            velocity.append(random.uniform(-1, 1))
        # append particle
        swarm.append({
            "dimensions": dimensions,
            "position": position,
            "position_best": position_best,
            "velocity": velocity,
            "error": error,
            "error_best": error_best
        })

    return swarm
```

A swarm is a list of particles, where each particle is represented as a dictionary (parameters are key-value pairs), `n_par` is number of particles, and `x_0` is starting position (initial guess).

### <a name="2.2" class="anchor"></a> [Velocity update](#2.2)

The velocity of each particle is updated based on its current position, local best position that the particle has encountered so far, and global best position that has been encountered by other particles. The `r_1` and `r_2` parameters are used to introduce randomness into the movement, which can be useful to prevent getting stuck in local optima.

```python
def update_velocity(velocity, position, position_best, global_pos):
    # random bias
    r_1 = random.random()
    r_2 = random.random()
    # update velocity
    velocity_cognative = c_1 * r_1 * (position_best - position)
    velocity_social = c_2 * r_2 * (global_pos - position)
    velocity = weight * velocity + velocity_cognative + velocity_social
    
    return velocity
```

The configuration variables: constant inertia weight, cognitive constant, social constant, are used to control the movement of the particles in the solution space.

```python
# constant inertia weight
weight = 0.5
# cognative constant
c_1 = 1
# social constant
c_2 = 2
```

The `weight` constant is used to control balance between current velocity and previous velocity, `c_1` is used to control influence of local best position on movement (cognative constant, higher value is more likely to move towards local best), `c_2` is used to control influence of global best position on movement (social constant, higher value is more likely to move towards global best).

### <a name="2.3" class="anchor"></a> [Position update](#2.3)

The position of each particle is updated based on its current velocity.

```python
def update_position(position, velocity):
    position = position + velocity
    
    return position
```

### <a name="2.4" class="anchor"></a> [Evaluation](#2.4)

The fitness of each particle is evaluated using the cost function, which is then used to update velocity and position.

```python
def iterate_swarm(f, swarm, bounds=None, global_best=-1, global_pos=-1):
    # iterate particles and evaluate cost function
    for j in range(0, len(swarm)):
        dimensions = swarm[j]["dimensions"]
        position = swarm[j]["position"]
        error_best = swarm[j]["error_best"]
        # evaluate new error (cost)
        error = swarm[j]["error"] = f(position)
        # update local best position if current position gives better local error
        if (error < error_best or error_best == -1):
            swarm[j]["position_best"] = position
            swarm[j]["error_best"] = error
        position_best = swarm[j]["position_best"]
        velocity = swarm[j]["velocity"]
        # update global best if position of current particle gives best global error
        if (error < global_best or global_best == -1):
            global_pos = list(position)
            global_best = float(error)
        # update particle velocity and position
        for i in range(0, dimensions):
            velocity[i] = update_velocity(velocity[i], position[i], position_best[i], global_pos[i])
            position[i] = update_position(position[i], velocity[i])
            # check bounds
            if bounds:
                # max value for position
                if (position[i] > bounds[i][1]):
                    position[i] = bounds[i][1]
                # min value for position
                if (position[i] < bounds[i][0]):
                    position[i] = bounds[i][0]
    # return
    return swarm, round(global_best, 2), [round(pos, 2) for pos in global_pos]
```

## <a name="3" class="anchor"></a> [Running PSO](#3)

In the below examples, the maximum number of iterations is set to `50`, which should be enough, and random seed is set to `1234`, so that the algorithm will generate the same result given the same configuration variables.

```python
MAX_ITERATIONS = 50
```

```python
random.seed(1234)
```

### <a name="3.1" class="anchor"></a> [**Example 1:** single variable with bounds](#3.1)

In this example, the cost function is `x[0] ** 5 - 3 * x[0] ** 4 + 5`, where x-range is `[0, 4]` (note that `x: [x_1, x_2, ..., x_n]`).

```python
# minimize x^5 - 3x^4 + 5 over [0, 4]
def f(x):
    return x[0] ** 5 - 3 * x[0] ** 4 + 5
```

```python
# reset global
global_best = -1
global_pos = -1
# initial swarm
swarm = generate_swarm(x_0=[5], n_par=15)
# iterate swarm
for i in range(MAX_ITERATIONS):
    swarm, global_best, global_pos = iterate_swarm(f, swarm, bounds=[(0, 4)], global_best=global_best, global_pos=global_pos)
print((global_best, global_pos))
# (-14.91, [2.4])
```

```python
assert (global_best, global_pos) == (-14.91, [2.4])
```

### <a name="3.2" class="anchor"></a> [**Example 2:** multiple variables](#3.2)

In this example, the cost function is `-(5 + 3 * x[0] - 4 * x[1] - x[0] ** 2 + x[0] * x[1] - x[1] ** 2)` with no bounds.

```python
# minimize -(5 + 3x - 4y - x^2 + x y - y^2)
def f(x):
    return -(5 + 3 * x[0] - 4 * x[1] - x[0] ** 2 + x[0] * x[1] - x[1] ** 2)
```

```python
# reset global
global_best = -1
global_pos = -1
# initial swarm
swarm = generate_swarm(x_0=[5, 5], n_par=15)
# iterate swarm
for i in range(MAX_ITERATIONS):
    swarm, global_best, global_pos = iterate_swarm(f, swarm, global_best=global_best, global_pos=global_pos)
print((global_best, global_pos))
# (-9.33, [0.67, -1.67])
```

```python
assert (global_best, global_pos) == (-9.33, [0.67, -1.67])
```

