<!--
    A Scala Primer and Cheat Sheet
    Michael Sjöberg
    Jun 22, 2018
-->

## <a name="1" class="anchor"></a> [1. Introduction](#1)

Scala program structure (build and run with `$ scalac <filename>.scala && scala <filename>`).

```scala
object Main {
    // do something

    def main(args: Array[String]) {
        // do something
    }
}
```

Handling exceptions.

```scala
try {
    // do something
}
catch {
    case a: ArithmeticException => println("This is an arithmetic error: " + a)
    case b: Throwable => println("Error: " + b)
}
finally {
    // do something
}
```

Build and run in Sublime Text (build system).

```
{
    "cmd": ["scala", "$file"],
    "path": "$PATH:/usr/local/bin",
    "file_regex": "^(.+):(\\d+): .+: (.+)",
    "selector": "source.scala"
}
```

## <a name="2" class="anchor"></a> [2. Arithmetic Operators](#2)

Basic arithmetic operators.

```scala
10 + 20
// 30
20 - 10
// 10
10 * 20
// 200
20 / 10
// 2
```

Automatic floating point conversion.

```scala
10.0 + (10 + 20)
// 40.0
20.0 - (10 + 10)
// 0.0
10.0 * (10 * 2)
// 200.0
```

Be aware of this common division error.

```scala
30 / 20
// 1
30.0 / 20.0
// 1.5
```

Modulo (remainder).

```scala
12.5 % 10.0
// 2.5
10.0 % 20.0
// 10.0
```

TODO: move to list operations

Built in numerical operations.

```scala
List(1, 2, 3, 4).sum
// 10
List(1, 2, 3, 4).min
// 1
List(1, 2, 3, 4).max
// 4
```

## <a name="3" class="anchor"></a> [3. Variables](#3)

Use `val` keyword to make data immutable.

```scala
val x: Int = 6
val y: String = "String"
val z: Double = 1.05
```

```scala
x, y, z
// (6,String,1.05)
```

Use `getClass.getSimpleName` to get type.

```scala
x.getClass.getSimpleName
// int
y.getClass.getSimpleName
// String
z.getClass.getSimpleName
// double
```

Use `var` keyword to make data mutable.

```scala
var a = x
// 6
```

```scala
a = a + 2
// 8
```

Multiple assignments.

```scala
val (x, y, z) = (6, "String", 1.05)
// (6,String,1.05)
```

List assignments.

```scala
val List(d, t, v) = List(230, 45, 12)
// (230,45,12)
```

String assignments.

```scala
val string: String = "100B"
```

## <a name="4" class="anchor"></a> [4. Strings](#4)

### <a name="4.1" class="anchor"></a> [4.1 Indexing](#4.1)

```scala
val string: String = "proton"
```

Use `charAt` and `slice` to index and slice string.

```scala
string.charAt(0)
// p
string.slice(0,4)
// prot
```

Length of string.

```scala
string.length
// 6
```

Index and slice using `substring`.

```scala
string.substring(0, string.length)
// proton
string.substring(string.length - 4, string.length)
// oton
```

### <a name="4.2" class="anchor"></a> [4.2 Operations](#4.2)

String operations.

```scala
"kilo" ++ "meter"
// kilometer
"A" * 4
// AAAA
```

```scala
val string: String = "proton neutron"
```

```scala
string.capitalize
// Proton neutron
string.toUpperCase
// PROTON NEUTRON
string.toLowerCase
// proton neutron
```

#### <a name="4.2.1" class="anchor"></a> [Counting and finding letters in text](#4.2.1)

```scala
string.count(_ == 'p')
// 1
string.indexOf("t")
// 3
```

#### <a name="4.2.2" class="anchor"></a> [Removing whitespace from string](#4.2.2)

```scala
val string: String = "    some text    "
```

```scala
string.trim
// some text
```

## <a name="5" class="anchor"></a> [5. Data structures](#5)

### <a name="5.1" class="anchor"></a> [5.1 Lists](#5.1)

Lists are immutable.

```scala
val list_one: List[String] = List("Alpha", "Beta")
// List(Alpha, Beta)
val list_two: List[Any] = List(200, -2, List(1.0, 0.0))
// List(200, -2, List(1.0, 0.0))
```

```scala
val list_range: List[Int] = List.range(1, 10)
// List(1, 2, 3, 4, 5, 6, 7, 8, 9)
```

Concatenate lists.

```scala
val list_all = list_one ++ list_two
// List(Alpha, Beta, 200, -2, List(1.0, 0.0))
```

Create new list by adding item to an existing list.

```scala
val list_one_new = "Gamma"  :: list_one
// List(Gamma, Alpha, Beta)
```

List operations.

```scala
list_one_new.length
// 3
list_one_new.sorted
// List(Alpha, Beta, Gamma)
list_two.head
// 200
list_two.last
// List(1.0, 0.0)
```

```scala
list_range.filter(_ > 5)
// List(6, 7, 8, 9)
```

#### <a name="5.1.1" class="anchor"></a> [Create list from a string](#5.1.1)

```scala
val list_char: List[Char] = ("100B").toList
// List(1, 0, 0, B)
```

### <a name="5.2" class="anchor"></a> [5.2 Tuples](#5.2)

Tuples are immutable.

```scala
val tuple_one = (1.0, "String", 4)
// (1.0,String,4)
val tuple_two = ("Alpha", "Bravo", (1, 0))
// (Alpha,Bravo,(1,0))
```

```scala
tuple_one._2
// String
tuple_two._3._2
// 0
```

#### <a name="5.2.1" class="anchor"></a> [Assign values in tuple to variables](#5.2.1)

```scala
val (first, second, third) = ("Alpha", "Beta", "Gamma")
```

```scala
first
// Alpha
second
// Beta
third
// Gamma
```

### <a name="5.3" class="anchor"></a> [5.3 Maps](#5.3)

Maps are key-value pairs and immutable.

```scala
val map_any = Map("Adam" -> List("adam@email.com", 2445055),
                  "Bard" -> "bard@email.com" )
```

```scala
map_any("Adam")
// List(adam@email.com, 2445055)
```

```scala
map_any.contains("Bard")
// true
map_any.exists(_ == "Bard" -> "bard@email.com")
// true
```

Using `collection.mutable.Map` for mutable maps.

```scala
val map_mutable = scala.collection.mutable.Map[String, Int]()
```

```scala
map_mutable += ("Alpha" -> 1, "Beta" -> 2)
// Map(Beta -> 2, Alpha -> 1)
map_mutable -= "Beta"
// Map(Alpha -> 1)
```

```scala
map_mutable("Alpha") = 100
// Map(Alpha -> 100)
```

### <a name="5.4" class="anchor"></a> [5.4 Sets](#5.4)

Sets are immutable.

```scala
val set_numbers: Set[Int] = Set(1, 3, 5, 7, 9)
// Set(5, 1, 9, 7, 3)
```

```scala
set_numbers.contains(3)
// true
set_numbers.contains(2)
// false
```

Using `collection.mutable.Set` for mutable sets.

```scala
val set_mutable_one = scala.collection.mutable.Set(1, 3, 5)
val set_mutable_two = scala.collection.mutable.Set(5, 7, 9)
```

```scala
set_mutable_two += 11
// Set(9, 5, 7, 11)
set_mutable_two -= 11
// Set(9, 5, 7)
```

Set operations (using `clone` to copy).

```scala
val A = set_mutable_one.clone
val B = set_mutable_two.clone
```

```scala
A | B
// Set(9, 1, 5, 3, 7) 		(Union)
A & B
// Set(5) 					(Intersection)
A &~ B
// Set(1, 3) 				(Difference)
```

```scala
A union B
// Set(9, 1, 5, 3, 7)
A intersect B
// Set(5)
A diff B
// Set(1, 3)
```

Subsets.

```scala
A subsetOf B
// false
```

## <a name="6" class="anchor"></a> [6. Conditionals](#6)

### <a name="6.1" class="anchor"></a> [6.1 If-Else](#6.1)

```scala
val a: Double = 1.0
val b: Double = 5.0
```

```scala
if (a < 1.0) {
    // do something
}
else if (a == 1.0) {
    // do something
}
else {
    // do something
}
```

### <a name="6.2" class="anchor"></a> [6.2 Logical Operators](#6.2)

Booleans.

```scala
val T: Boolean = true
val F: Boolean = false
```

```scala
T || F
// true
T && (T && F)
// false
!T
// false
!(!T)
// true
```

Numbers.

```scala
1 == 2
// false
1 != 2
// true
```

## <a name="7" class="anchor"></a> [7. Loops](#7)

### <a name="7.1" class="anchor"></a> [7.1 For](#7.1)

```scala
val numbers: List[Int] = List(1, 2, 3, 4)
// List(1, 2, 3, 4)
```

```scala
for (number <- numbers) {
    // do something
}
```

Nested for loops.

```scala
for (i <- List.range(1, 5)) {
    for (j <- List.range(1, 5)) {
        // do something
    }
}
```

#### <a name="7.1.1" class="anchor"></a> [Using for-loops and maps](#7.1.1)

```scala
val map: Map[String, Int] = Map("Alpha" -> 1, "Beta" -> 2)
```

```scala
for ((key, value) <- map) {
    println(key, value)
// (Alpha,1) (Beta,2)
}
```

### <a name="7.2" class="anchor"></a> [7.2 While](#7.2)

```scala
var a = 0
var b = 5
```

```scala
while (a < b) {
    // do something
    a += 1
}
```

```scala
println(a)
// 5
```

## <a name="8" class="anchor"></a> [8. Functions](#8)

Functions are defined with `def` keyword.

```scala
def fun(): Boolean = {
    // do something
    return true
}
```

Addition operator as function.

```scala
def add(a:Int, b:Int): Int = {
    return a + b
}
```

```scala
add(2, 3)
// 5
```

Default arguments.

```scala
def add(a:Int, b:Int = 3): Int = {
    return a + b
}
```

```scala
add(2)
// 5
```

Multiple return values.

```scala
def add(a:Int, b:Int): (Int, Int, Int) = {
    var result = a + b
    return (a, b, result)
}
```

```scala
val (a, b, result) = add(2, 3)
// (2,3,5)
```

Documentation (scaladoc).

```scala
/** Documentation for fun.
 *
 *  @param arg an argument
 */
def fun(arg:Any) = {
    // do something
}
```

## <a name="9" class="anchor"></a> [9. Classes](#9)

Classes are defined with `class` keyword.

```scala
class Money(val a:Int, val c:String) {
    var amount: Int = a
    var currency: String = c
    
    override def toString = amount.toString ++ " " ++ currency
}
```

Create new instance of class.

```scala
val money = new Money(220, "EUR")
```

```scala
money.amount, money.currency
// (220,EUR)
```

Print use `toString`.

```scala
println(money)
// 220 EUR
```

Subclasses.

```scala
class VirtualMoney(override val a:Int, override val c:String, val d:String) extends Money(a, c) {
    var date: String = d
    
    override def toString = amount.toString ++ " " ++ currency ++ " (use before " ++ date ++ ")"
}
```

```scala
val virtual_money = new VirtualMoney(20, "DIS", "2018-12-31")
```

```scala
println(virtual_money)
// 20 DIS (use before 2018-12-31)
```

## <a name="10" class="anchor"></a> [10. Files](#10)

Use `io.Source` to read and write to files.

```scala
import scala.io.Source
```

Reading from files.

```scala
val file = Source.fromFile("path/to/file")
```

```scala
for (line <- file.getLines) {
    // do something
}
```

Use `close` to close file.

```scala
file.close
```

Write to text-file (using Java `io`).

```scala
import java.io._
```

```scala
val file = new File("path/to/file.txt")
```

```scala
val buffer = new BufferedWriter(new FileWriter(file))

buffer.write("Text.")
```

```scala
buffer.close
```

## <a name="11" class="anchor"></a> [11. Modules](#11)

### <a name="11.1" class="anchor"></a> [11.1 Calendar](#11.1)

```scala
import java.util.Calendar
import java.text.SimpleDateFormat
```

```scala
val now = Calendar.getInstance.getTime
// Sun Jun 17 19:18:49 CEST 2018
```

Date formats.

```scala
val year = new SimpleDateFormat("yyyy")
val month = new SimpleDateFormat("M")
val day = new SimpleDateFormat("d")
val hour = new SimpleDateFormat("H")
val minute = new SimpleDateFormat("m")
```

```scala
year.format(now)
// 2018
month.format(now)
// 6
day.format(now)
// 17
hour.format(now)
// 19
minute.format(now)
// 18
```

### <a name="11.2" class="anchor"></a> [11.2 Math](#11.2)

```scala
import scala.math._
```

```scala
scala.math.Pi
// 3.141592653589793
scala.math.E
// 2.718281828459045
```

Mathematical operations.

```scala
scala.math.pow(2, 3)
// 8.0
scala.math.floor(2.945)
// 2.0
scala.math.exp(1)
// 2.718281828459045
scala.math.sqrt(16)
// 4.0
```

```scala
scala.math.abs(-20)
// 20
```

```scala
scala.math.sin(4 * math.Pi / 180)
// 0.0697564737441253
```

Rounding values.

```scala
scala.math.round(2.945)
// 3
scala.math.round(2.495)
// 2
```

```scala
scala.math.rint(2.945 * 100) / 100
// 2.94
```
