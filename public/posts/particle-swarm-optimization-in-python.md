Particle Swarm Optimization in Python
Michael Sjöberg
Jan 16, 2023
May 27, 2023

## <a name="1" class="anchor"></a> [Introduction](#1)

In this post, we'll implement particle swarm optimization (PSO) in Python. Here's a good definition of PSO from [Wikipedia](https://en.wikipedia.org/wiki/Particle_swarm_optimization):

> In computational science, particle swarm optimization (PSO) is a computational method that optimizes a problem by iteratively trying to improve a candidate solution with regard to a given measure of quality. It solves a problem by having a population of candidate solutions, here dubbed particles, and moving these particles around in the search-space according to simple mathematical formula over the particle's position and velocity. Each particle's movement is influenced by its local best known position, but is also guided toward the best known positions in the search-space, which are updated as better positions are found by other particles. This is expected to move the swarm toward the best solutions.

Nothing is needed except Python and `random`.

```python
import random
```

## <a name="2" class="anchor"></a> [The algorithm](#2)

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

The above function generates a swarm of particles for use by rest of the algorithm. The function takes two arguments, `x_0`, the starting position of the swarm (initial guess), and `n_par`, the number of particles in the swarm. It loops through each particle, generating a random velocity and adding the particle to the swarm as a dictionary with its properties.

#### Updating velocity

The velocity of each particle is updated based on its current position, local best position that the particle has encountered so far, and global best position that has been encountered by other particles. The `r_1` and `r_2` parameters are used to introduce randomness into the movement, which is useful to prevent getting stuck in local optima.

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

The configuration variables, **constant inertia weight**, **cognitive constant**, and **social constant** are used to influence the relative movement of particles in the solution space.

```python
# constant inertia weight
weight = 0.5
# cognative constant
c_1 = 1
# social constant
c_2 = 2
```

The `weight` constant is used to control balance between current velocity and previous velocity, `c_1` is used to control influence of local best position on movement (**cognative constant**, higher value is more likely to move towards local best), `c_2` is used to control influence of global best position on movement (**social constant**, higher value is more likely to move towards global best).

#### Updating positions

Nothing fancy here. The position is simply updated by adding the velocity to the current position.

```python
def update_position(position, velocity):
    position = position + velocity
    return position
```

#### Fitness evaluation

The fitness of each particle is evaluated using a cost function, which is then used as basis to update velocity and position.

The `iterate_swarm` function moves the swarm through one iteration of the algorithm. It takes four arguments, `f`, which is the cost function to be minimized, `swarm`, which is the list of particles, `bounds`, which specifies the bounds on the search space (constraints), and `global_best` and `global_pos`, which are the best error and position found so far by any particle.

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
            velocity[i] = update_velocity(
                velocity[i],
                position[i],
                position_best[i],
                global_pos[i]
            )
            position[i] = update_position(
                position[i],
                velocity[i]
            )
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

The function iterates over each particle in the swarm, updates its local best position and error if necessary, and updates the global best position and error if the particle's position yields a better result than the current global best.

The particle velocity and position are then updated using the `update_velocity` and `update_position` functions. If bounds are specified, the position is checked to ensure it is within the bounds. Finally, the function returns the updated swarm, the global best error, and the global best position.

## <a name="3" class="anchor"></a> [Testing](#3)

In the below examples, the maximum number of iterations is set to `50` (should be enough for our examples), and random seed is set to `42`, so that the algorithm will generate the exact same result given the given configuration variables.

```python
MAX_ITERATIONS = 50
random.seed(1234)
```

### Single variable with bounds

In this example, the cost function is `x[0] ** 5 - 3 * x[0] ** 4 + 5`, where `x`-range is `[0, 4]` (note that `x: [x_1, x_2, ..., x_n]`, representing `x`, `y`, `z`, etc.).

```python
# minimize x^5 - 3x^4 + 5 over [0, 4]
def f(x): return x[0] ** 5 - 3 * x[0] ** 4 + 5
```

```python
# reset global
global_best = -1
global_pos = -1
# initial swarm
swarm = generate_swarm(x_0=[5], n_par=15)
# iterate swarm
for i in range(MAX_ITERATIONS):
    swarm, global_best, global_pos = iterate_swarm(
        f,
        swarm,
        bounds=[(0, 4)],
        global_best=global_best,
        global_pos=global_pos
    )
assert (global_best, global_pos) == (-14.91, [2.39])
```

### Multiple variables no bounds

In this example, the cost function is `-(5 + 3 * x[0] - 4 * x[1] - x[0] ** 2 + x[0] * x[1] - x[1] ** 2)` with no bounds.

```python
# minimize -(5 + 3x - 4y - x^2 + x y - y^2)
def f(x): return -(5 + 3 * x[0] - 4 * x[1] - x[0] ** 2 + x[0] * x[1] - x[1] ** 2)
```

```python
# reset global
global_best = -1
global_pos = -1
# initial swarm
swarm = generate_swarm(x_0=[5, 5], n_par=15)
# iterate swarm
for i in range(MAX_ITERATIONS):
    swarm, global_best, global_pos = iterate_swarm(
        f,
        swarm,
        global_best=global_best,
        global_pos=global_pos
    )
assert (global_best, global_pos) == (-9.33, [0.67, -1.67])
```

