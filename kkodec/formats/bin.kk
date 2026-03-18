module bin

pub import std/core/bytes
pub import std/num/int32
pub import std/num/int64

pub import kkodec/kkodec
pub import kkodec/serialize
pub import kkodec/deserialize

import std/core/undiv

import hlib/ds/bytesb
import hlib/ext/bslice
import hlib/ext/bytes
import hlib/ext/int64

pub val kkodec : kkodec<bytes,total,pure> = Kkodec(compact, decompact)

fun fold-to-compact(serialized : serialized, bytesb : bytesb) : bytesb
  match serialized
    Variant(_, index, fields) ->
      fields.foldl(bytesb.append(index.int64)) fn(bytesb', (_, field-value))
        field-value.pretend-decreasing.fold-to-compact(bytesb')
    Sequence(elems) ->
      elems.foldl(bytesb.append(elems.length.int64)) fn(bytesb', elem)
        elem.pretend-decreasing.fold-to-compact(bytesb')
    Int(x) -> bytesb.append(x.int64)
    String(x) -> 
      val b = x.bytes
      bytesb.append(b.length.int64).append(b)

pub fun compact(serialized : serialized) : bytes
  serialized.fold-to-compact(bytesb/empty()).bytes

pub fun decompact(data : bytes, ?deserialize : () -> <deserialize,pure> a) : <pure> a
  data.slice.ref.stateful-decompact(?deserialize)

fun stateful-decompact(data : ref<h, bslice>, ?deserialize : () -> <deserialize,pure> a) : <pure,st<h>> a
  handle(deserialize)
    fun deserialize-type(_name, variants : list<string>)
       match (!data).next-int64
         Just((variant-index, data')) ->
           data := data'
           variants[variant-index.int].expect(variants.show ++ variant-index.int.show)
    fun deserialize-field(_name, field-deserializer)
      stateful-decompact(data, field-deserializer)
    fun deserialize-sequence(elem-deserializer)
      match (!data).next-int64
        Just((len, data')) ->
          data := data'
          list(1,len.int) fn(_ : int)
            stateful-decompact(data, elem-deserializer)
    fun deserialize-int()
      match (!data).next-int64
        Just((x, data')) ->
          data := data'
          x.int
    fun deserialize-string()
      match (!data).next-int64
        Just((len, data')) ->
          val first = data'.subslice(0, len.int)
          data := first.after
          first.bytes.string

fun main()
  String("").compact.trace-show
