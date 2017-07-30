expressions produce values
statements do not

statement (doesnt produce value):
let x = 5

expression (does produce value):
5


a node is a thing that has a TokenLiteral() method that returns a string

a statement is a thing with a Node and a statementNode() method

a expression is a thing with a Node and a expressionNode() method

a programs is a list of statements

  identifier
  expression
  token

statement struct

token
Name Identifier
Value Expression
