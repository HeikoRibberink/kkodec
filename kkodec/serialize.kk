module serialize

pub type serialized
  Variant(name : string, index : int, fields : list<(string, serialized)>)
  Sequence(elems : list<serialized>)
  Int(x : int)
  String(x : string)

pub fun field(name : string, value : a, ^?serialize : a -> serialized) : (string, serialized)
  (name, value.serialize)

pub fun int/serialize(x : int) : serialized
  Int(x)

pub fun string/serialize(x : string) : serialized
  String(x)

pub fun tuple2/serialize(tup : (a, b), ^?a/serialize : a -> serialized, ^?b/serialize : b -> serialized) : serialized
  val (a, b) = tup
  Variant("", 0, [
    field("0", a),
    field("1", b)
  ])

pub fun unit/serialize(()) : pure serialized
  Variant("unit", 0, [])

pub fun list/serialize(list : list<a>, ?serialize : a -> serialized) : serialized
  Sequence(list.map(serialize))

