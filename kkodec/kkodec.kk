module kkodec

pub import kkodec/deserialize
pub import kkodec/serialize

// A pair of a serializer to `d` using effects `e` and a deserializer from `d` using effects `f`.
pub struct kkodec<d::V,e::E,f::E>
  serializer : (serialized : serialized) -> e d
  deserializer : forall<a> (data : d, ?deserialize : () -> <deserialize,pure> a) -> f a
