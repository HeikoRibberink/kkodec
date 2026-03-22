module streaming-bin

import kkodec/kkodec
import kkodec/formats/bin

import std/core/undiv

import hlib/ds/bytesb
import hlib/ext/bslice
import hlib/ext/bytes
import hlib/ext/int64
import hlib/ext/ssize-t

pub effect ctl write-bytes(bytes : bytes) : ()

pub effect ctl read-bytes(len : ssize_t) : bytes

pub val kkodec : forall<e,f> kkodec<(),<write-bytes|e>,<pure,read-bytes|f>> = Kkodec(bin, fn((), ?deserialize) {debin(deserialize)})

pub fun write-int64(i : int64) : write-bytes ()
  bytes/alloc(8.ssize_t).write-bytes

pub fun bin(serialized : serialized) : write-bytes ()
  match serialized
    Variant(_, index, fields) ->
      index.int64.write-int64
      fields.foreach fn((_, field-value))
        field-value.pretend-decreasing.bin
    Sequence(elems) ->
      elems.foreach fn(elem)
        elem.pretend-decreasing.bin
    Int(x) -> x.int64.write-int64
    String(x) -> 
      val b = x.bytes
      b.length.int64.write-int64
      b.write-bytes

pub fun read-int64() : read-bytes int64
  read-bytes(8.ssize_t).int64/unsafe-index(0.ssize_t)

pub fun debin(?deserialize : () -> <deserialize,pure> a) : <pure,read-bytes> a
  handle(deserialize)
    fun deserialize-type(_name, variants : list<string>)
      val i = read-int64()
      variants[i.int].unjust
    fun deserialize-field(_name, field-deserializer)
      debin(field-deserializer)
    fun deserialize-sequence(elem-deserializer)
      val len = read-int64()
      list(1,len.int) fn(_)
        debin(elem-deserializer)
    fun deserialize-int()
      read-int64().int
    fun deserialize-string()
      val len = read-int64()
      read-bytes(len.ssize_t).string
