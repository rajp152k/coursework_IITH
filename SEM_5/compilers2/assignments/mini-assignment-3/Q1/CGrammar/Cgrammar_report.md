## compilers 2 : mini-assignment 3
## Raj Patil CS18BTECH11039

---

# C grammar :

```bash
$ yacc CGrammar.y 
> CGrammar.y: warning: 1 shift/reduce conflict [-Wconflicts-sr]
```

a single shift reduce conflict occurs in the C grammar

a good report can be immediately observed by using 

`yacc -rall CGrammar.y`

---
     
State 333 conflicts: 1 shift/reduce

.... going to state 333 :


State 333

  192 selection_statement: IF '(' expression ')' statement .  [IDENTIFIER, CONSTANT, STRING_LITERAL, SIZEOF, INC_OP, DEC_OP, CASE, DEFAULT, IF, ELSE, SWITCH, WHILE, DO, FOR, GOTO, CONTINUE, BREAK, RETURN, '(', '&', '*', '+', '-', '~', '!', ';', '{', '}']
  193                    | IF '(' expression ')' statement . ELSE statement

    ELSE  shift, and go to state 343

    ELSE      [reduce using rule 192 (selection_statement)]
    $default  reduce using rule 192 (selection_statement)


here we can see that the conflict is resolved by reduction using rule 192.
