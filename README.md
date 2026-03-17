# KKodec

KKodec is a framework for serializing and deserializing Koka data structures.

Anything using KKodec is either:
- A Koka data structure that knows how to serialize or deserialize itself,
- A data format that knows how to serialize or deserialize other things.

KKodec sits between these two objects, providing an interface that allows any
data structure to serialized and deserialized using any supported data format.

# Requirements

If you *only* want to use the framework, this library has no dependencies.

If you wish to use the example formats, you need to do the following:

- When [Installing](#Installing), make sure to add this submodule recursively,
  that is, use `git submodule add --recursive` in addition to the other arguments.
- Build the Koka compiler with 
  [this commit](https://github.com/TimWhiting/koka/commit/74f31a5a0409c69cd1c7723d2c7b3c43ca563e48) 
  merged. This is the head commit of [this pr](https://github.com/koka-lang/koka/pull/652).
  Check if the PR is already merged into your version of Koka; it wasn't at the
  time of writing, but it may be when you read this.
  Note that the state of Koka at the time of writing is such that I cannot make
  any guarantees about whether KKodec will work with any other compiler version.


# Installing

The easiest way to use this library is to add it as a git submodule:
```bash
git submodule add git@github.com:HeikoRibberink/kkodec.git ./include/kkodec/
```

Then you need to tell Koka to include this:
```bash
koka -i./include/kkodec/ <whatever you want here>
```

If you don't want to type this every time, use a wrapper that automatically
includes this, such as a Makefile, Justfile, a Nix wrapper or a Bash script.
