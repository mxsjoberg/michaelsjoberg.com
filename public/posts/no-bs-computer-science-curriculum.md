<!--
    No-BS Computer Science Curriculum
    Michael Sjöberg
    November 10, 2020
-->

## <a name="1" class="anchor"></a> [1. Introduction](#1)

This is an evolving list with learning material and recommended programming languages for computer science students. It works well on its own (for self-learners) or in addition to an undergraduate degree in computer science (or related field). The goal is to provide a solid foundation to build upon, degree or no degree. It will be updated to fix broken links and to keep learning material up to date. If you are interested in computer science and engineering (and have plenty of time to spare), see [github.com/michaelsjoeberg/the-ultimate-computer-science-and-engineering-curriculum](https://github.com/mixmaester/the-ultimate-computer-science-and-engineering-curriculum).

## <a name="2" class="anchor"></a> [2. Programming](#2)

Programming is the most important skill in computer science and computational problem solving and should be the primary focus of any computer science curriculum (with use cases in computer systems, application software development, theorem proving, and so on). If you prefer to work on projects while learning, see [github.com/tuvtran/project-based-learning](https://github.com/tuvtran/project-based-learning).

### <a name="2.1" class="anchor"></a> [2.1 Foundation](#2.1)

The goal is to get comfortable with programming and to understand the software abstraction model (via Python, C, and Assembly; high-level to low-level, with Python representing the highest-level of abstraction). You most likely don't need to be fluent in any Assembly language (they are mostly compilation targets), but to be able to read and find errors in assembly generated by smaller programs is probably a good idea.

#### <a name="2.1.1" class="anchor"></a> [Python](#2.1.1)

- Get proficient or fluent (very powerful programming language with a lot of support, look at some numerical libraries as well, especially NumPy)
- Try to implement an interpreter; see [Let’s Build A Simple Interpreter](https://ruslanspivak.com/lsbasi-part1/)
- **Bonus:** Try to implement game of life; see [Programming Projects for Advanced Beginners #2: Game of Life](https://robertheaton.com/2018/07/20/project-2-game-of-life/).

#### <a name="2.1.2" class="anchor"></a> [C](#2.1.2)

- Learn basics of memory allocation and pointers; try to understand the assembly code generated for smaller programs (gcc -S option)
- Get familiar with C++ (could also get proficient or fluent if appropriate)

#### <a name="2.1.3" class="anchor"></a> [Assembly](#2.1.3)

- x86, ARM (could also explore other architectures if more appropriate); see [x86 Assembly Guide](https://www.cs.virginia.edu/~evans/cs216/guides/x86.html) and [ARM Hardware and Assembly Language](https://www.cs.uaf.edu/courses/cs301/2014-fall/notes/arm-asm/)
- Get familiar with registers; see [x86 Assembly/X86 Architecture](https://en.wikibooks.org/wiki/X86_Assembly/X86_Architecture)

Recommended learning material:

- [Computer Systems: A Programmer's Perspective](https://www.amazon.com/Computer-Systems-OHallaron-Randal-Bryant/dp/1292101768)
- [The Art of Assembly Language](https://www.amazon.com/Art-Assembly-Language-2nd/dp/1593272073)
- [C Programming Language](https://www.amazon.com/Programming-Language-2nd-Brian-Kernighan/dp/0131103628)
- [A Tour of C++](https://www.amazon.com/Tour-2nd-Depth-Bjarne-Stroustrup/dp/0134997832)
- [Python Crash Course](https://www.amazon.com/Python-Crash-Course-2nd-Edition/dp/1593279280)

### <a name="2.2" class="anchor"></a> [2.2 Paradigm exposure](#2.2)

The goal is to get familiar with a range of programming paradigms, understand parts of the hardware abstraction model (via Verilog), and become a more confident computer programmer in general. A few notes on programming languages: Python and C (and C++) are considered multi-paradigm (as in supporting more than one style), and more specifically: imperative and structured.

#### <a name="2.2.1" class="anchor"></a> [Haskell](#2.2.1)

- Functional

#### <a name="2.2.2" class="anchor"></a> [Prolog](#2.2.2)

- Declarative and probably most popular logic-based programming language
- **Bonus:** Get familiar with Coq (one of the most popular theorem provers); see [Coq in a Hurry](https://arxiv.org/pdf/cs/0603118.pdf)

#### <a name="2.2.3" class="anchor"></a> [Verilog](#2.2.3)

- Hardware description language; probably most popular language to design and verify digital systems
- **Bonus:** Try to implement designs at different abstraction levels (gate-level, register-transfer-level, behavioral-level); see [Verilog Tutorial](https://www.javatpoint.com/verilog)

Recommended learning material:

- [Thinking Functionally with Haskell](https://www.amazon.com/Thinking-Functionally-Haskell-Richard-Bird/dp/1107452643)
- [The Elements of Computing Systems](https://www.amazon.com/Elements-Computing-Systems-Building-Principles/dp/0262640686)
- [Structure and Interpretation of Computer Programs](https://www.amazon.com/Structure-Interpretation-Computer-Programs-Engineering/dp/0262510871)

### <a name="2.3" class="anchor"></a> [2.3 Machine learning](#2.3)

The goal is to get exposed to machine learning and the idea that output is based on data instead of design, watch this talk by Andrej Karpathy (former director of AI at Tesla): [Building the Software 2.0 Stack](https://databricks.com/session/keynote-from-tesla).

#### <a name="2.3.1" class="anchor"></a> [Neural Networks (Python)](#2.3.1)

- Get familiar with Scikit-learn, PyTorch, and TensorFlow (or any other similar framework if more appropriate)
- **Bonus:** Try to build a neural network from scratch; see [How to build your own Neural Network from scratch in Python](https://towardsdatascience.com/how-to-build-your-own-neural-network-from-scratch-in-python-68998a08e4f6)

Recommended learning material:

- [The Hundred-Page Machine Learning Book](https://www.amazon.com/Hundred-Page-Machine-Learning-Book/dp/199957950X)

### <a name="2.4" class="anchor"></a> [2.4 "Modern" languages](#2.4)

The above topics provides familiarity with different paradigms and modern developments (such as ML). Below are few more programming languages to consider, somewhat based on the "most loved" programming languages: [Stack Overflow Developer Survey 2020](https://insights.stackoverflow.com/survey/2020#most-loved-dreaded-and-wanted).

#### <a name="2.4.1" class="anchor"></a> [Rust](#2.4.1)

- Natural transition from C++, could also explore Scala if more familiar with Java, backed by Mozilla
- **Bonus:** Try to build an operating system; see [Writing an OS in Rust](https://os.phil-opp.com/)

#### <a name="2.4.2" class="anchor"></a> [Clojure](#2.4.2)

- Lisp-like, could also explore Lisp if more appropriate

#### <a name="2.4.3" class="anchor"></a> [Nim](#2.4.3)

- Python-like but compiled

#### <a name="2.4.4" class="anchor"></a> [Kotlin](#2.4.4)

- Probably most popular language for Android development (see [Kotlin is now Google's preferred language for Android app development](https://techcrunch.com/2019/05/07/kotlin-is-now-googles-preferred-language-for-android-app-development)), compiles to JVM and JavaScript (could also explore Lua if interested in embedded applications or game development)

#### <a name="2.4.5" class="anchor"></a> [Go](#2.4.5)

- Memory safe C (if you don't like Rust, could also explore Dart), backed by Google

## <a name="3" class="anchor"></a> [3. Mathematics](#3)

Mathematics has a central role in any computer science curriculum and a solid foundation in selected mathematical topics can be highly valuable, especially in more advanced computing tasks (not to mention ML).

### <a name="3.1" class="anchor"></a> [3.1 Basics](#3.1)

The Goal is to get familiar with data structures and theory of computation, these topics could also be covered in recommended learning material for some programming languages.

#### <a name="3.1.1" class="anchor"></a> [Discrete Mathematics](#3.1.1)

- Get familiar with sets, permutations, trees, graphs, and related concepts
- **Bonus:** Try to implement common algorithms in different programming languages (optimize based on different conditions); see [The Algorithms](https://github.com/TheAlgorithms)

#### <a name="3.1.2" class="anchor"></a> [Probability](#3.1.2)

- Learn basics of probability distributions and conditionality; see [Khan Academy: Statistics and probability](https://www.khanacademy.org/math/statistics-probability)
- **Bonus:** Try to implement concepts based on random processes (such as MDP solver, see [aimacode](https://github.com/aimacode)), could also explore game theory if more appropriate

Recommended learning material:

- [Discrete Mathematics](https://www.amazon.com/Discrete-Mathematics-Gary-Chartrand/dp/1577667301)
- [Introduction to Algorithms](https://www.amazon.com/Introduction-Algorithms-3rd-MIT-Press/dp/0262033844)

### <a name="3.2" class="anchor"></a> [3.2 General topics](#3.2)

The goal is to build a strong general background in mathematics, such as typically taught in undergraduate science-related degrees. Many topics are useful in several tasks related to computer science, ML, computer vision, and scientific computing.

#### <a name="3.2.1" class="anchor"></a> [Calculus](#3.2.1)

- Get familiar with derivatives and anti-derivatives, multivariable derivatives, and vector calculus 
- **Bonus:** Learn basics of partial derivatives, Jacobian computations, and relevant optimization techniques

#### <a name="3.2.2" class="anchor"></a> [Linear Algebra](#3.2.2)

- Get familiar with vectors, spaces, matrix transformations, and related concepts (get fluent if interested in computer vision)
- **Bonus:** Implement inverse, determinant, and transpose in some programming language

#### <a name="3.2.3" class="anchor"></a> [Differential Equations](#3.2.3)

- Learn basics of first-order, second-order, and partial differential equations

#### <a name="3.2.4" class="anchor"></a> [Number Theory](#3.2.4)

- Get familiar with topics in number theory (any interesting); see [List of number theory topics](https://en.wikipedia.org/wiki/List_of_number_theory_topics)
- **Bonus:** Try to solve computational problems; see [Project Euler](https://projecteuler.net/)

Recommended learning material:

- [Calculus: Early Transcendentals](https://www.amazon.com/Calculus-Early-Transcendentals-James-Stewart/dp/1285741552)
- [No bullshit guide to linear algebra](https://www.amazon.com/No-bullshit-guide-linear-algebra/dp/0992001021)
- [Ordinary Differential Equations](https://www.amazon.com/Ordinary-Differential-Equations-Dover-Mathematics/dp/0486649407)
- [Elementary Analysis: The Theory of Calculus](https://www.amazon.com/Elementary-Analysis-Calculus-Undergraduate-Mathematics/dp/1461462703)
- [Number Theory](https://www.amazon.com/Number-Theory-Dover-Books-Mathematics/dp/0486682528)

## <a name="4" class="anchor"></a> [4. Other skills](#4)

This section contains additional topics and commonly used tools, somewhat based on the "missing semester" at MIT, see [The Missing Semester of Your CS Education](https://missing.csail.mit.edu/).

### <a name="4.1" class="anchor"></a> [4.1 Systems](#4.1)

The goal is to get comfortable with version control and working with computer systems (in the context of programming).

#### <a name="4.1.1" class="anchor"></a> [Git](#4.1.1)

- Probably most common version control system

#### <a name="4.1.2" class="anchor"></a> [Bash](#4.1.2)

- Domain-specific command language (Unix shell); get familiar with frequently used commands at [Bash scripting cheatsheet](https://devhints.io/bash)

It is also a good idea to get familiar with virtual machines, such as Vagrant or Docker, build systems, such as Make, and parallel computing (if appropriate), such as CUDA or OpenCL.

### <a name="4.2" class="anchor"></a> [4.2 Web technologies](#4.2)

The goal is to get familiar with web technologies and to develop a basic website.

#### <a name="4.2.1" class="anchor"></a> [JavaScript](#4.2.1)

- Event-driven programming language (control flow based on events)
- Get proficient if you want to work in web development; see [JavaScript](https://developer.mozilla.org/en-US/docs/Learn/JavaScript)

Finally, it is probably a good idea to get used to working with cloud platforms, such as AWS or Google Cloud, and notebooks, such as Jupyter (Python), which is a very popular web-based development environment for ML and deep learning.
