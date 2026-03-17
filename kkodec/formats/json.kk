module json

pub import std/data/json

pub import kkodec/kkodec
pub import kkodec/serialize
pub import kkodec/deserialize

import std/core/undiv

import hlib/ext/list

pub val kkodec : kkodec<json,total,pure> = Kkodec(json, dejson)

pub fun json(serialized : serialized) : json
  match serialized
    Variant(name, _, fields) ->
      JSObj([(name, JSObj(fields.map(fn((fname, fvalue)) (fname, fvalue.pretend-decreasing.json))))])
    Sequence(elems) -> JSList(elems.map(_.pretend-decreasing.json))
    Int(x) -> JSInt(x)
    String(x) -> JSString(x)

pub fun dejson(json : json, ?deserialize : () -> <deserialize,pure> a) : <pure> a
  var state := json
  handle(deserialize)
    fun deserialize-type(_name, variants)
      match state
        JSObj([(variant, fields)]) -> 
          state := fields
          variant
    fun deserialize-field(name, field-deserialize)
      match state
        JSObj(fields) ->
          val (fields', removed) = fields.remove-first fn((field-name, _))
            name == field-name
          state := JSObj(fields')
          match removed
            Just((_, value)) ->
              dejson(value, field-deserialize)
    fun deserialize-sequence(elem-deserializer)
      match state
        JSList(list) -> 
          with mask<local>
          list.map fn(elem)
            elem.dejson(elem-deserializer)
    fun deserialize-int()
      match state
        JSInt(x) -> x
    fun deserialize-string()
      match state
        JSString(x) -> x
