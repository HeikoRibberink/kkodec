module serialize

pub type serialized
  Variant(name : string, index : int, fields : list<(string, serialized)>)
  Sequence(elems : list<serialized>)
  Int(x : int)
  String(x : string)

pub fun field(name : string, value : a, ^?serialize : a -> e serialized) : e (string, serialized)
  (name, value.serialize)

pub fun int/serialize(x : int) : e serialized
  Int(x)

pub fun string/serialize(x : string) : e serialized
  String(x)

pub fun tuple2/serialize(tup : (a, b), ^?a/serialize : a -> e serialized, ^?b/serialize : b -> e serialized) : e serialized
  val (a, b) = tup
  Variant("", 0, [
    field("0", a),
    field("1", b)
  ])

pub fun unit/serialize(()) : e serialized
  Variant("unit", 0, [])

pub fun list/serialize(list : list<a>, ?serialize : a -> e serialized) : e serialized
  Sequence(list.map(serialize))

