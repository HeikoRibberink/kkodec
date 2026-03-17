import std/core/undiv

import kkodec/serialize
import kkodec/deserialize
import kkodec/formats/bin
import kkodec/formats/json
import kkodec/formats/show
import kkodec/tools/random

import hlib/ext/bytes

pub type foo
  Foo(y : int)
  Bar(x : int, y : (string, string))
  Baz(l : list<foo>)

// Automatically generated.
// Equality comparison of the `foo` type.
pub fun foo/(==)(this : foo, other : foo) : div bool
  match (this, other)
    (Foo(y), Foo(y')) -> y == y'
    (Bar(x, y), Bar(x', y')) -> x == x' && y == y'
    (Baz(l), Baz(l')) -> l == l'
    (_, _) -> False

// Automatically generated.
// Shows a string representation of the `foo` type.
pub fun foo/show(this : foo) : div string
  match this
    Foo(y) -> "Foo(y: " ++ y.show ++ ")"
    Bar(x, y) -> "Bar(x: " ++ x.show ++ ", y: " ++ y.show ++ ")"
    Baz(l) -> "Baz(l: " ++ l.show ++ ")"

fun foo/serialize(foo : foo) : serialized
  match foo
    Foo(y) -> Variant("Foo", 0, [
      field("y", y)
    ])
    Bar(x, y) -> Variant("Bar", 1, [
      field("x", x),
      field("y", y)
    ])
    Baz(l) -> Variant("Baz", 2, [
      ("l", Sequence(l.map(fn(x) x.pretend-decreasing.serialize)))
    ])

fun foo/deserialize() : <deserialize,pure> foo
  match deserialize-type("foo", ["Foo", "Bar", "Baz"])
    "Foo" -> Foo(field("y"))
    "Bar" -> Bar(field("x"), field("y", tuple2/deserialize))
    "Baz" -> Baz(field("l", list/deserialize))

fun main()
  for(1000) fn(_)
    val rand : foo = random()
    val rand-ser : json = rand.serialize.json
    val rand-deser : foo = rand-ser.dejson
    if rand != rand-deser then
      throw("Assertion failed: " ++ rand.show ++ " == " ++ rand-deser.show ++ " via " ++ show(rand-ser))
  for(1000) fn(i)
    val rand : foo = random()
    val rand-ser : bytes = rand.serialize.compact
    val rand-deser : foo = rand-ser.decompact
    if rand != rand-deser then
      throw("Assertion failed: " ++ rand.show ++ " == " ++ rand-deser.show ++ " via " ++ show(rand-ser))
