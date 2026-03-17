module deserialize

pub div effect deserialize
  ctl deserialize-type(name : string, variants : list<string>) : string
  ctl deserialize-field(name : string, ?deserialize : () -> <deserialize,pure> a) : a
  ctl deserialize-sequence(?deserializer : () -> <deserialize,pure> a) : list<a>
  ctl deserialize-int() : int
  ctl deserialize-string() : string

pub fun field(name : string, ?deserialize : () -> <deserialize,pure> a) : <deserialize,pure> a
  deserialize-field(name)

pub fun int/deserialize()
  deserialize-int()

pub fun string/deserialize()
  deserialize-string()

pub fun list/deserialize(?deserialize : () -> <deserialize,pure> a) : <deserialize,pure> list<a>
  deserialize-sequence(deserialize)

pub fun tuple2/deserialize(?a/deserialize : () -> <deserialize,pure> a, ?b/deserialize : () -> <deserialize,pure> b) : <deserialize,pure> (a, b)
  match deserialize-type("tuple2", [""])
    "" -> (field("0"), field("1"))
  
