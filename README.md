# maths-api

Very simple example of a restful API written in [Haskell's Servant](https://github.com/haskell-servant/servant).

### Run it

Use [The Haskell Tool Stack](http://docs.haskellstack.org/en/stable/README.html)

Clone the repo from https://github.com/joefiorini/maths-api and switch to the cloned directory.

Run:

```
stack build
stack exec maths-api-exe
```

Then go to <http://localhost:8080/sum?operand=1&operand=2>. You should see a result of 3.
