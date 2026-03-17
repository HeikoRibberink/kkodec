module random

import std/num/random
import std/num/float64

import hlib/patterns/generator

import kkodec/deserialize

// Create a random object that implements `deserialize`.
pub fun random(seq-branching-factor : float64 = 0.5, max-string-len : int = 256, ?deserialize : () -> <deserialize,pure> a) : <pure,random> a
  handle(deserialize)
    fun deserialize-type(name, variants : list<string>)
      variants[random-int() % variants.length].unjust
    fun deserialize-field(name, field-deserialize) 
      random(seq-branching-factor, max-string-len, field-deserialize)
    fun deserialize-sequence(elem-deserializer)
      generator
        while {random-float64() < seq-branching-factor}
          val rand = 
            random(seq-branching-factor, max-string-len, elem-deserializer)
          yield(rand)
      .collect
    fun deserialize-int()
      random-int()
    fun deserialize-string()
      val len = random-int() % max(max-string-len, 1)
      list(0, len) fn(_)
        ((random-int() % 127) + 1).char
      .string
