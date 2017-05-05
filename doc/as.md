

## directive


### .def

Begin defining debugging information for a symbol name; the definition extends until the .endef directive is encountered.

https://sourceware.org/binutils/docs/as/Def.html


### .scl

Set the storage-class value for a symbol. This directive may only be used inside a .def/.endef pair. Storage class may flag whether a symbol is static or external, or it may record further symbolic debugging information.

https://sourceware.org/binutils/docs/as/Scl.html

 type   | value
--------|----------
normal  | 2
static  | 3


### .type

https://sourceware.org/binutils/docs/as/Type.html

