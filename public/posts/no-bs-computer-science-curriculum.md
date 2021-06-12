No-BS Computer Science Curriculum  
Michael Sjoeberg  
November 10, 2020  
June 13, 2021

This is a work-in-progress list with recommended learning material and programming languages for computer science students. It works well on its own (for self-learners) or as a complement to the typical undergraduate degree in computer science, which is often lacking some lower-level details and mathematical content. The goal is to provide a more solid foundation to build upon. This list will be updated whenever I find that something is missing, incorrect, or to add additional learning material.

---

## Programming

Programming is the constant in most tasks related to computer science and computational problem solving, and should be the primary focus of any computer science curriculum (showcasing different uses in computer systems, application software, and so on). If you prefer to work on projects while learning, get ideas at [github.com/tuvtran/project-based-learning](https://github.com/tuvtran/project-based-learning).

### Foundation

The goal is to get comfortable with programming and to understand the software abstraction model (via Assembly, C/C++, and Python; low-level to high-level, with Python representing the highest-level of abstraction). You probably don't need to be fluent in Assembly (or any specific architecture), but it's a good idea to understand enough to be able to read and find errors.

**Assembly**

- x86, ARM (could also explore other architectures if more appropriate); see [x86 Assembly Guide](https://www.cs.virginia.edu/~evans/cs216/guides/x86.html) and [ARM Hardware and Assembly Language](https://www.cs.uaf.edu/courses/cs301/2014-fall/notes/arm-asm/)

- Get familiar with registers; see [x86 Assembly/X86 Architecture](https://en.wikibooks.org/wiki/X86_Assembly/X86_Architecture)

**C/C++**

- Learn basics of memory allocation and pointers; try to understand the assembly code for smaller programs (gcc -S option)

- Get familiar with C++ (could also get fluent if appropriate, it's a very powerful programming language)

**Python**

- Get fluent (look at some numerical libraries as well, especially NumPy, maybe Pandas)

- Try to implement game of life; see [Programming Projects for Advanced Beginners #2: Game of Life](https://robertheaton.com/2018/07/20/project-2-game-of-life/)

- Try to implement an interpreter; see [Let’s Build A Simple Interpreter](https://ruslanspivak.com/lsbasi-part1/)

- **Bonus:** Experiment with some quantum libraries (maybe [Qiskit](https://qiskit.org/), or [TensorFlow Quantum](https://www.tensorflow.org/quantum))

Recommended learning material: [Computer Systems: A Programmer's Perspective](https://www.amazon.com/Computer-Systems-OHallaron-Randal-Bryant/dp/1292101768), [The Art of Assembly Language](https://www.amazon.com/Art-Assembly-Language-2nd/dp/1593272073), [C Programming Language](https://www.amazon.com/Programming-Language-2nd-Brian-Kernighan/dp/0131103628), [A Tour of C++](https://www.amazon.com/Tour-2nd-Depth-Bjarne-Stroustrup/dp/0134997832), [Python Crash Course](https://www.amazon.com/Python-Crash-Course-2nd-Edition/dp/1593279280).

### Paradigm exposure

The goal is to get familiar with a range of programming paradigms, understand parts of the hardware abstraction model (via Verilog), and become a more confident computer scientist in general (via more advanced reading). A few notes on programming languages: C/C++ and Python are considered multi-paradigm (as in supporting more than one style), but more specifically imperative and structured (i.e. there are limited jump instructions, read this: [Edgar Dijkstra: Go To Statement Considered Harmful](https://homepages.cwi.nl/~storm/teaching/reader/Dijkstra68.pdf)).

**Haskell**

- Functional

- Try to build a compiler, transpiler, or parser; see [Building a modern functional compiler from first principles](http://dev.stephendiehl.com/fun/)

**Prolog**

- Logic-based

- Probably most popular logic programming language (could also explore Clojure.core.logic if more appropriate, see [clojure/core.logic](https://github.com/clojure/core.logic))

**Coq** (Gallina)

- Dependently-typed functional

- Probably most popular proof assistant; see [Coq in a Hurry](https://arxiv.org/abs/cs/0603118)

**Verilog**

- Hardware description language; probably most popular language to design and verify digital systems

- Try to implement designs at different abstraction levels (gate-level, register-transfer-level, behavioural-level); see [Verilog Tutorial](https://www.javatpoint.com/verilog)

Recommended learning material: [Thinking Functionally with Haskell](https://www.amazon.com/Thinking-Functionally-Haskell-Richard-Bird/dp/1107452643), [The Elements of Computing Systems](https://www.amazon.com/Elements-Computing-Systems-Building-Principles/dp/0262640686), [Structure and Interpretation of Computer Programs](https://www.amazon.com/Structure-Interpretation-Computer-Programs-Engineering/dp/0262510871).

What about object-oriented programming? This is a quote by Paul Graham (Viaweb, Y Combinator): "*[at] big companies, software tends to be written by large (and frequently changing) teams of mediocre programmers. Object-oriented programming imposes a discipline on these programmers that prevents any one of them from doing too much damage*", read this: [Why Arc Isn't Especially Object-Oriented](http://www.paulgraham.com/noop.html).

### Machine learning

The goal is to get exposed to machine learning and the idea that output is based on data instead of design, watch this: [Building the Software 2.0 Stack](https://databricks.com/session/keynote-from-tesla).

**Neural Networks** (Python)

- Get familiar with Keras, TensorFlow, and PyTorch; try challenges at [Kaggle: Competitions](https://www.kaggle.com/competitions) (or look at solutions if stuck)

- Try to build a neural network from scratch; see [How to build your own Neural Network from scratch in Python](https://towardsdatascience.com/how-to-build-your-own-neural-network-from-scratch-in-python-68998a08e4f6)

Recommended learning material: [The Hundred-Page Machine Learning Book](https://www.amazon.com/Hundred-Page-Machine-Learning-Book/dp/199957950X).

### "Modern" languages

The above topics provides familiarity with different paradigms and modern developments (such as ML). Below are a few more programming languages to consider, somewhat based on the "most loved" programming languages: [Stack Overflow Developer Survey 2020](https://insights.stackoverflow.com/survey/2020#most-loved-dreaded-and-wanted).
	
**Rust** (backed by Mozilla)

- Natural transition from C++, could also explore Scala if more familiar with Java

- Try to build an OS; see [Writing an OS in Rust](https://os.phil-opp.com/)

**Clojure**
 
- Lisp-like, could also explore Lisp if more appropriate

**Nim**

- Python-like but compiled, could also explore Lua if interested in embedded applications (or game development)

**Kotlin**

- Probably most popular language for Android development (see [Kotlin is now Google's preferred language for Android app development](https://techcrunch.com/2019/05/07/kotlin-is-now-googles-preferred-language-for-android-app-development)), compiles to JVM and JavaScript (could also explore JavaScript if more appropriate)

**Go** (backed by Google)

- Memory safe C (if you don't like Rust, could also explore Dart)

---

## Mathematics

Mathematics has a central role in any computer science curriculum. A solid foundation in selected mathematical topics can be highly valuable, especially in more advanced computing (not to mention ML).

### Foundation

The Goal is to get familiar with data structures and theory of computation, these topics could also be covered in recommended learning material for some programming languages.

**Discrete Mathematics**

- Get familar with sets, permutations, trees, graphs, and related concepts

- Try to implement common algorithms in different programming languages (optimize based on different conditions); get ideas at [The Algorithms](https://github.com/TheAlgorithms)

**Probability Theory**

- Learn basics of probability distributions and conditionality; see [Khan Academy: Statistics and probability](https://www.khanacademy.org/math/statistics-probability)

- **Bonus**: Try to implement concepts based on random processes (maybe MDP solver, see [aimacode](https://github.com/aimacode)), could also explore game theory if interested in AI applications

Recommended learning material: [Discrete Mathematics](https://www.amazon.com/Discrete-Mathematics-Gary-Chartrand/dp/1577667301), [Introduction to Algorithms](https://www.amazon.com/Introduction-Algorithms-3rd-MIT-Press/dp/0262033844).

### General topics

The goal is to build a strong general background in mathematics, such as typically taught in undergraduate science-related degrees. Many topics are useful in several tasks related to computer science, but in particular ML, computer vision, and scientifc computing.

**Calculus**

- Get familiar with derivatives and anti-derivatives, multivariable derivatives, and vector calculus 

- Learn basics of partial derivatives, Jacobian computations, and relevant optimization techniques

**Linear Algebra**

- Get familiar with vectors, spaces, matrix transformations, and related concepts

- Get familiar with inverse, determinant, and transpose (get fluent if interested in computer vision)

**Differential Equations**

- Learn basics of first-order, second-order, and partial differential equations

**Number Theory**

- Get familiar with common algorithms and related concepts; see [List of number theory topics](https://en.wikipedia.org/wiki/List_of_number_theory_topics)

- Try to solve computational problems; see [Project Euler](https://projecteuler.net/)

Recommended learning material: [Calculus: Early Transcendentals](https://www.amazon.com/Calculus-Early-Transcendentals-James-Stewart/dp/1285741552), [No bullshit guide to linear algebra](https://www.amazon.com/No-bullshit-guide-linear-algebra/dp/0992001021), [Ordinary Differential Equations](https://www.amazon.com/Ordinary-Differential-Equations-Dover-Mathematics/dp/0486649407), [Elementary Analysis: The Theory of Calculus](https://www.amazon.com/Elementary-Analysis-Calculus-Undergraduate-Mathematics/dp/1461462703), [Number Theory](https://www.amazon.com/Number-Theory-Dover-Books-Mathematics/dp/0486682528).

---

## Other

This section contains additional topics and commonly used tools, it's somewhat based on the "*missing semester*" by MIT: [The Missing Semester of Your CS Education](https://missing.csail.mit.edu/).

**Git**

- Probably most common version control system

**Bash**

- Domain-specific command language (Unix shell)

- Get familiar with frequently used commands at [Bash scripting cheatsheet](https://devhints.io/bash)

**JavaScript**

- Event-driven (control flow based on events)

- Get familiar if you ever want to build web applications, could also explore any of the other \*Script languages (TypeScript, CoffeeScript, or maybe AssemblyScript)

It's also a good idea to get familiar with virtual machines, such as Vagrant or Docker, build systems, such as Make, cloud platforms, such as AWS or Google Cloud, and parallel computing, such as CUDA or OpenCL. Finally, learning basics of working with notebooks is probably a good idea, such as Jupyter (Python), which is a very popular development environment for ML and deep learning.
