* Tasks
** DONE Conceptos claves
   CLOSED: [2013-12-10 Tue 16:44]
** DONE Segunda forma normal
   CLOSED: [2013-12-10 Tue 16:45]
** DONE Tercera forma normal
   CLOSED: [2013-12-10 Tue 16:53]
** DONE Boyce-cod (BCNF)
   CLOSED: [2013-12-10 Tue 17:12]
** TODO Cuarta forma normal
** TODO Quinta forma normal


  

* Conceptos claves


** Propiedades indeseables
- Repetición de información
- Mala representacion de la información
- Perdida de información

** Definiciones
*** Dependencias funcionales
, Las dependencias funcionales sirven para dar semántica a las tablas y para
definir restricciones sobre las mismas. Una dependencia funcional significa que para un
X dado siempre se recupera el mismo valor de Y




*** Superclave
, Una superclave es un conjunto K de atributos, los cuales conjuntamente, identifican únivocamente a una entidad
en el conjunto de entidades. Si k es superclave cualquier conjunto que contenga K es superclave.



*** Clave candidata
, Una clave candidata es una superclave en la cual ningún subconjunto propio es superclave.
Puede existir más de una clave candidata.




*** Clave primaria
, Es la clave candidata que resulta del proceso de normalización




*** Atributo primo
, Si es miembro de cualquier clave candidata




*** Axiomas de amstrong


**** Axiomas básicos

***** Transitividad

, a->b y b->c entonces a->c

***** Reflexibilidad

, X es un conjunto de atributos y Y esta incluido en X entonces X->Y

***** Aumento

, Si X->Y y Z es un conjunto de atributos, entonces, Z,X->Z,Y


**** Axiomas que se deducen a partir de los axiomas básicos

***** Unión

, Si X->Y y X->Z entonces X->YZ

***** Descomposición

, Si X->Y,Z entonces X->Y y X->Z

***** Pseudotransitividad

, Si se tiene X->Y y Y,Z->W entonces X,Z->W



*** Análisis:


**** Perdida de información

, R= R1 union R2
R1 intersección R2 es clave en el esquema R1
R1 intersección R2 es clave en el esquema R2


**** Perdida de dependecias funcionales

, a) los atributos de la dependencia funcional original quedaron todos incluidos en alguna de las particiones generadas
  b) los atributos de la dependencia funcional original quedaron distribuidos en más de una partición





* Primera forma normal

, Se prohíben los atributos multivaluados (aquellos que tienen múltiples valores), los atributos compuestos
(aquellos compuestos a su vez de otros atributos) y sus combinaciones.

* Segunda forma normal

, Si esta en 1FN y todo atributo no primo depende funcionalmente de manera total de la clave primaria.

* Tercera forma normal

, Si esta en 2FN y ningún atributo no primo de R depende transitivamente de la clave primaria.
Siempre que una dependencia funcional X->A se cumple en R o
 1) A es un atributo primo de R
 2) X es superclave de R

* Boyce-code

, siempre que una dependencia funcional X->A es válida en R, entonces X es superclave de R

* Cuarta forma normal

, si:
 1) No existen dependencias multivaluadas o
 2) sólo existe una dependencia multivaluada trivial
































