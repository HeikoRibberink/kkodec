# KKodec

KKodec is a framework for serializing and deserializing Koka data structures.

Anything using KKodec is either:
- A Koka data structure that knows how to serialize or deserialize itself,
- A data format that knows how to serialize or deserialize other things.

KKodec sits between these two objects, providing an interface that allows any
data structure to serialized and deserialized using any supported data format.
