<!--
    A Python Primer and Cheat Sheet
    Michael Sjöberg
    Nov 4, 2018
-->

## <a name="1" class="anchor"></a> [1. Introduction](#1)

Python program structure (build and run with `$ python <filename>.py`).

```python
#!/usr/bin/python

def main():
    # do something
    return

if (__name__ == "__main__"):
    main()
```

Handling exceptions.

```python
try:
    # do something
except ZeroDivisionError:
    print('Cannot divide with zero.')
    # do something
except Exception as e:
    print('Error: ' + str(e))
    # do something
finally:
    # do something
```

## <a name="2" class="anchor"></a> [2. Arithmetic Operators](#2)

Basic arithmetic operators.

```python
10 + 20
# 30
20 - 10
# 10
10 * 20
# 200
20 / 10
# 2
```

Power operator.

```python
10 ** 2
# 100
```

Automatic floating point conversion.

```python
10.0 + (10 + 20)
# 40.0
20.0 - (10 + 10)
# 0.0
10.0 * (10 * 2)
# 200.0
```

Be aware of this common division error.

```python
30 / 20
# 1
30.0 / 20.0
# 1.5
```

Integer divison (quotient).

```python
20.0 // 20.0
# 1.0
30.0 // 20.0
# 1.0
40.0 // 20.0
# 2.0
```

Modulo (remainder).

```python
12.5 % 10.0
# 2.5
10.0 % 20.0
# 10.0
```

Built in numerical operations.

```python
abs(-20)
# 20
sum([1, 2, 3, 4])
# 10
min(1, 2, 3, 4)
# 1
max(1, 2, 3, 4)
# 4
```

Rounding values.

```python
round(2.945)
# 3.0
round(2.495)
# 2.0
```

```python
round(2.945, 2)
# 2.94
```

## <a name="3" class="anchor"></a> [3. Variables](#3)

Basic variables.

```python
x = 6
y = 'String'
z = 1.05
a = x
```

```python
x, y, z, a
# (6, 'String', 1.05, 6)
```

Using `type` built-in.

```python
type(x)
# int
type(y)
# str
type(z)
# float
type(a)
# int
```

Multiple assignments.

```python
x = a = 6
```

```python
y, z = 'String', 1.05
```

```python
x, y, z, a
# (6, 'String', 1.05, 6)
```

List assignments.

```python
d, t, v = [230, 45, 12]
# (230, 45, 12)
```

String assignments.

```python
a, b, c, d = '100B'
# ('1', '0', '0', 'B')
```

```python
string = '100B'
number = string[:3]
letter = string[3:]
```

```python
number, letter
# ('100', 'B')
```

Delete a variable.

```python
del n
```

```python
n
# NameError: name 'n' is not defined
```

## <a name="4" class="anchor"></a> [4. Strings](#4)

### <a name="4.1" class="anchor"></a> [4.1 Indexing](#4.1)

String indexing.

```python
string = 'proton'
```

```python
string[:]
# proton
string[:2]
# pr
string[-2:]
# on
string[1:3]
# ro
```

Reverse a string.

```python
string[::-1]
# notorp
```

Skip every second character.

```python
string[0:-1:2]
# poo
```

### <a name="4.2" class="anchor"></a> [4.2 Operations](#4.2)

String operations.

```python
string = 'proton neutron'
```

```python
string.capitalize()
# Proton neutron
string.title()
# Proton Neutron
string.upper()
# PROTON NEUTRON
string.lower()
# proton neutron
```

```python
string.center(20, '.')
# ...proton neutron...
```

```python
string.isdigit()
# False
string.islower()
# True
string.isupper()
# False
```

#### <a name="4.2.1" class="anchor"></a> [Counting and finding letters in text](#4.2.1)

```python
string.count('p', 0, len(string))
# 1
string.find('t', 1, len(string))
# 3
```

#### <a name="4.2.2" class="anchor"></a> [Removing whitespace from a string](#4.2.2)

```python
string = '    some text    '
```

```python
string.lstrip()
# 'some text    '
string.rstrip()
# '    some text'
string.strip()
# 'some text'
```

## <a name="5" class="anchor"></a> [5. Data structures](#5)

### <a name="5.1" class="anchor"></a> [5.1 Lists](#5.1)

Lists are mutable.

```python
list_one = ['REMOVE', 'RANDOM']
list_two = [200, -2, [1.0, 0.0]]
```

```python
list_one[0] = 'ADD'
# ['ADD', 'RANDOM']
list_one[1]
# RANDOM
```

Length of lists.

```python
len(list_one)
# 2
len(list_two)
# 3
```

Concatenate lists.

```python
list = list_one + list_two
# ['ADD', 'RANDOM', 200, -2, [1.0, 0.0]]
```

List operations.

```python
list.append('NULL')
# ['ADD', 'RANDOM', 200, -2, [1.0, 0.0], 'NULL']
list.sort()
# [-2, 200, [1.0, 0.0], 'ADD', 'NULL', 'RANDOM']
```

#### <a name="5.1.1" class="anchor"></a> [Create list from a string](#5.1.1)

```python
list_string = list('100B')
# ['1', '0', '0', 'B']
```

### <a name="5.2" class="anchor"></a> [5.2 Tuples](#5.2)

Tuples are immutable.

```python
tuple_one = (1.0, 'String', 4)
tuple_two = ('Alpha', 'Bravo', (1, 0))
```

```python
tuple_one
# (1.0, 'String', 4)
tuple_two
# ('Alpha', 'Bravo', (1, 0))
tuple_two[2][1]
# 0
```

Concatenate tuples.

```python
tuple = tuple_one + tuple_two
# (1.0, 'String', 4, 'Alpha', 'Bravo', (1, 0))
```

#### <a name="5.2.1" class="anchor"></a> [Create tuple from a list](#5.2.1)

```python
tuple_list = tuple([100, 'B'])
# (100, 'B')
```

### <a name="5.3" class="anchor"></a> [5.3 Dictionaries](#5.3)

Dictionaries are key-value pairs.

```python
dict = {'Adam': ['adam@email.com', 2445055], 'Bard': 'bard@email.com'}
```

```python
dict
# {'Adam': ['adam@email.com', 2445055], 'Bard': 'bard@email.com'}
dict['Adam']
# ['adam@email.com', 2445055]
dict['Adam'][1]
# 2445055
```

Dictionaries are mutable.

```python
dict['Bard'] = 'bard@anotheremail.com'
```

```python
dict
# {'Adam': ['adam@email.com', 2445055], 'Bard': 'bard@anotheremail.com'}
```

Add and remove items.

```python
dict['Cole'] = 'cole@email.com'
```

```python
dict
# {'Cole': 'cole@email.com', 'Adam': ['adam@email.com', 2445055], 'Bard': 'bard@anotheremail.com'}
```

```python
del dict['Cole']
# {'Adam': ['adam@email.com', 2445055], 'Bard': 'bard@anotheremail.com'}
```

```python
'Adam' in dict
# True
```

#### <a name="5.3.1" class="anchor"></a> [Create dictionary from a list of tuples](#5.3.1)

```python
dict_list_tuples = dict([(1, "x"), (2, "y"), (3, "z")])
```

```python
dict_list_tuples
# {1: 'x', 2: 'y', 3: 'z'}
```

### <a name="5.4" class="anchor"></a> [5.4 Sets](#5.4)

Sets are unordered collections.

```python
set = {1.0, 10, 'String', (1, 0, 1, 0)}
```

```python
set
# set([(1, 0, 1, 0), 10, 'String', 1.0])
```

```python
'String' in set
# True
'Java' in set
# False
```

Add and remove from set.

```python
set.add('Python')
# set(['Python', (1, 0, 1, 0), 10, 'String', 1.0])
```

```python
set.remove('Python')
# set([(1, 0, 1, 0), 10, 'String', 1.0])
```

Set operations.

```python
set_one = {1, 2, 3}
# set([1, 2, 3])
set_two = {3, 4, 5}
# set([3, 4, 5])
```

```python
set_one | set_two
# set([1, 2, 3, 4, 5])      (Union)
set_one & set_two
# set([3])                  (Intersection)
set_one - set_two
# set([1, 2])               (Difference)
set_one ^ set_two
# set([1, 2, 4, 5])         (Symmetric difference)
```

Subset and superset.

```python
set_a = {1, 2}
set_b = {1, 2}
set_c = {1, 2, 3, 4, 5}
```

```python
set_a < set_b
# False                     (Strict subset)
set_a <= set_b
# True                      (Subset)
set_c > set_a
# True                      (Strict superset)
```

## <a name="6" class="anchor"></a> [6. Conditionals](#6)

### <a name="6.1" class="anchor"></a> [6.1 If-Else](#6.1)

```python
a = 1.0
b = 5.0
```

```python
if (a < 1.0):
    # do something
elif (a == 1.0):
    # do something
else:
    # do something
```

#### <a name="6.1.1" class="anchor"></a> [Single line expressions](#6.1.1)

```python
c = (a / b) if a != 0 else a
# 0.2
```

### <a name="6.2" class="anchor"></a> [6.2 Logical Operators](#6.2)

Booleans.

```python
T = True
F = False
```

```python
T or F
# True
T and (T and F)
# False
```

```python
not T
# False
not (not T)
# True
```

Numbers.

```python
1 == 2
# False
1 != 2
# True
```

## <a name="7" class="anchor"></a> [7. Loops](#7)

### <a name="7.1" class="anchor"></a> [7.1 For](#7.1)

```python
numbers = [1, 2, 3, 4]
```

```python
for number in numbers:
    # do something
```

Nested for loops.

```python
for i in range(10):
    for j in range(10):
        # do something
```

#### <a name="7.1.1" class="anchor"></a> [Using for-loops and dictionaries](#7.1.1)

```python
dict = {'Alpha': 1, 'Beta': 2}
```

```python
for key in dict.keys():
    print(key)
# Alpha
# Beta
for value in dict.values():
    print(value)
# 1
# 2
for key, value in dict.items():
    print(key, value)
# ('Alpha', 1)
# ('Beta', 2)
```

### <a name="7.2" class="anchor"></a> [7.2 While](#7.2)

```python
a = 0
b = 5
```

```python
while (a < b):
    # do something
    a += 1
```

```python
print(a)
# 5
```

## <a name="8" class="anchor"></a> [8. Functions](#8)

Functions are defined with `def` keyword.

```python
def function(arg):
    # do something
    return
```

Power operator as function.

```python
def power(base, x):
    return base ** x
```

```python
power(2, 3)
# 8
```

Default arguments.

```python
def power(base, x = 3):
    return base ** x
```

```python
power(2)
# 8
```

Multiple return values.

```python
def power(base, x):
    result = base ** x
    return result, base
```

```python
result, base = power(2, 3)
# (8, 2)
```

Docstrings.

```python
def function(arg):
    '''This is a docstring.'''
    return
```

```python
print (function.__doc__)
# This is a docstring.
```

## <a name="9" class="anchor"></a> [9. Classes](#9)

Classes are defined with `class` keyword.

```python
class Money (object):
    def __init__(self, amount, currency):
        self.amount = amount
        self.currency = currency
    def __str__(self):
        return str(self.amount) + ' ' + self.currency
```

Create a new instance of class.

```python
money = Money(220, 'EUR') 
```

```python
money.amount, money.currency
# (220, 'EUR')
```

Print use `__str__`.

```python
print(money)
# 220 EUR
```

Subclasses.

```python
class VirtualMoney (Money):
    def __init__(self, date):
        self.date = date
    def __str__(self):
        return str(self.amount) + ' ' + self.currency + ' (use before ' + self.date + ')'
```

```python
virtual_money = VirtualMoney('2018-12-31')
```

```python
virtual_money.amount = 20
virtual_money.currency = 'DIS'
```

```python
virtual_money
# 20 DIS (use before 2018-12-31)
```

## <a name="10" class="anchor"></a> [10. Files](#10)

Reading from files.

```python
with open('path/to/file', 'r') as file:
    file.read()
```

```python
content = open('path/to/file', 'r').read()
```

Read lines from text-file.

```python
with open('path/to/file.txt', 'r') as file:
    for line in file.readlines():
        # do something
```

Write to text-file.

```python
with open('path/to/file.txt', 'w') as file:
    file.write('This is some text to write.')
```

## <a name="11" class="anchor"></a> [11. Modules](#11)

### <a name="11.1" class="anchor"></a> [11.1 Datetime](#11.1)

```python
from datetime import datetime
from datetime import timedelta
```

```python
now = datetime.now()
# 2018-06-15 18:23:51.500993
future = now + timedelta(12)
# 2018-06-27 18:23:59.351647
```

```python
now.year
# 2018
now.month
# 6
now.day
# 15
now.hour
# 18
now.minute
# 23
```

Difference between dates.

```python
difference = future - now
```

```python
difference
# 12 days, 0:00:00
difference.days
# 12
```

### <a name="11.2" class="anchor"></a> [11.2 Math](#11.2)

```python
import math
```

```python
math.pi
# 3.14159265359
math.e
# 2.71828182846
```

Mathematical operations.

```python
math.floor(2.945)
# 2.0
math.trunc(2.945)
# 2
math.factorial(5)
# 120
math.exp(1)
# 2.71828182846
math.sqrt(16)
# 4.0
```

```python
math.sin(4 * math.pi / 180)
# 0.0697564737441
```
