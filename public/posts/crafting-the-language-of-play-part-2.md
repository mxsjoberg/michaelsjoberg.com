<!-- Crafting the Language of Play, Part 2: Assignment and swap
Michael Sjöberg
Jul 14, 2023
Jul 14, 2023 -->

This is the second post in a series of posts on implementing the new non-trivial programming language, PlayCode. It is open source and all code is available [here](https://github.com/mixmaester/playcode).

In this post, the goal is to implement this subset:

```python
# program           ::= assignment | swap_statement | PRINT expression
# assignment        ::= IDENTIFIER EQUALS expression
# swap_statement    ::= SWAP IDENTIFIER IDENTIFIER
# expression        ::= term ((PLUS | MINUS) term)*
# term              ::= factor ((MULTIPLY | DIVIDE) factor)*
# factor            ::= IDENTIFIER | INTEGER | LPAR expression RPAR

# tokens
PRINT       = "PRINT"
SWAP        = "SWAP" # PART 2
INTEGER     = "INTEGER"
PLUS        = "+"
MINUS       = "-"
MULTIPLY    = "*"
DIVIDE      = "/"
LPAR        = "("
RPAR        = ")"
EQUALS      = "=" # PART 2

RESERVED = [
    "PRINT",
    "SWAP" # PART 2
]
```

## <a name="1" class="anchor"></a> [Assignment](#1)

To implement assignments, we first need to add the new token types.

```python
class TokenType(Enum):
    ...
    ASSIGN      = 101
    IDENTIFIER  = 200
    ...
    EQUALS      = 501
```

The `ASSIGN` token type is only used to make the AST more readable, there is no `m_value`.

```python
class Token(object):
    def __init__(self, m_type, m_value=None):
        ...
```

I am adding identifiers to symbol table when first seen in lexer. I also have a case for `=`, which is used by parser to know when to parse an assignment.

```python
symbol_table = {}
```

```python
def tokenize(source):
    ...

    while current_char_index < len(source):
        current_char = source[current_char_index]
        match current_char:
            ...
            case '=':
                tokens.append(Token(TokenType.EQUALS, EQUALS))
                current_char_index += 1
            case _:
                if current_char.isdigit():
                    ...
                elif current_char.isalpha():
                    ...
                    # identifier
                    else:
                        symbol_table[identifier.lower()] = None
                        tokens.append(Token(TokenType.IDENTIFIER, identifier.lower()))
                else:
                    raise Exception("Unknown character:", current_char)

    return tokens
```

The parser is updated to handle assignments.

```python
def parse_program(tokens, current_token_index):
    ...
    # assignment
    if current_token.m_type == TokenType.IDENTIFIER:
        program.append(Token(TokenType.ASSIGN))
        assignment, current_token_index = parse_assignment(tokens, current_token_index, identifier=current_token)
        program.append(assignment)
    # swap_statement
    elif current_token.m_value == SWAP:
        program.append(current_token)
        swap_statement, current_token_index = parse_swap_statement(tokens, current_token_index)
        program.append(swap_statement)
    ...

    return program, current_token_index
```

Using the `ASSIGN` token to group the assignments.

```
Token(TokenType.ASSIGN)
    Token(TokenType.IDENTIFIER, 'x')
    Token(TokenType.INTEGER, '4')
```

The assignment production rule matches the `IDENTIFIER` token (in `parse_program`) and then the `EQUALS` token.

```python
# assignment ::= IDENTIFIER EQUALS expression
def parse_assignment(tokens, current_token_index, identifier):
    assignment = []
    # assignment_dict = {}
    current_token = tokens[current_token_index]
    current_token_index += 1

    # EQUALS
    if current_token.m_type == TokenType.EQUALS:
        assignment.append(identifier)
        # expression
        expression, current_token_index = parse_expression(tokens, current_token_index)
        assignment.append(expression)
        symbol_table[identifier.m_value] = expression
    else:
        raise Exception("parse_assignment", "Unexpected token:", tokens[current_token_index])

    return assignment, current_token_index
```
