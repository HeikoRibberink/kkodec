module show

pub import kkodec/serialize

pub fun serializer(serialized : serialized) : div string
  match serialized
    Variant(name, _, fields) ->
      name ++ "(" ++ fields.map(fn((fname, fvalue)) fname ++ ": " ++ serializer(fvalue)).join(", ") ++ ")"
    Sequence(elems) ->
      "[" ++ elems.map(serializer).join(", ") ++ "]"
    Int(x) ->
      x.show
    String(x) -> x.show
