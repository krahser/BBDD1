Internacion
===========

(codHospital, dniPaciente, fechaInicioInternacion,
cantDiasInternacion, telefonoInternacionPaciente,
direccionInternacionPaciente, ciudadInternacionPaciente,
obraSocialInternacion, nombreApellidoPaciente, domicilioPaciente,
ciudadPaciente, obraPrimaria, obraSecundaria, nombreHospital,
domicilioHospital, ciudadHospital, directorHospital,
cantidadHabitaciones, doctorAtencion, insumoInternacion) 

- Cc: (dniPaciente, fechaInicioInternacion, doctorAtencion,
  insumoInternacion)

#. df1: dniPaciente -> nombreApellidoPaciente, domicilioPaciente,
ciudadPaciente, obraPrimaria, obraSecundaria

#. df2: codHospital-> nombre, domicilioHospital, ciudadHospital,
directorHospital, cantidadHabitaciones

#. df3: domicilioHospital, ciudadHospital -> cantidadHabitaciones,
  nombre, codHospital, directorHospital 

#. df4: dniPaciente, fechaInicioInternacion -> codHospital,
cantDiasInternacion, telefonoInternacionPaciente,
direccionInternacionPaciente, ciudadInternacionPaciente,
obraSocialInternacion 

#. df5: dniPaciente, fechaInicioInternacion -> domicilioHospital,
ciudadHospital, cantDiasInternacion, telefonoInternacionPaciente,
direccionInternacionPaciente, ciudadInternacionPaciente,
obraSocialInternacion 


Normalización
=============

#. df1: dniPaciente -> nombreApellidoPaciente, domicilioPaciente,
ciudadPaciente, obraPrimaria, obraSecundaria


#. df2: codHospital-> nombre, domicilioHospital, ciudadHospital,
 directorHospital, cantidadHabitaciones 

#. df3: domicilioHospital, ciudadHospital -> cantidadHabitaciones,
nombre, codHospital, directorHospital 

**Por transitividad**
*codHospital -> domicilioHospital, ciudadHospital*
Entonces:

#. df2: codHospital -> cantidadHabitaciones, nombre, codHospital,
 directorHospital, domicilioHospital, ciudadHospital,

#. df3: dniPaciente, fechaInicioInternacion -> codHospital,
   
   dniPaciente, fechaInicioInternacion -> cantDiasInternacion,

   telefonoInternacionPaciente, direccionInternacionPaciente,
   obraSocialInternacion
   
   
   
   codHospital -> ciudadInternacionPaciente

----

INTERNACION (codHospital, dniPaciente, fechaInicioInternacion, cantDiasInternacion,
======telefonoInternacionPaciente, direccionInternacionPaciente, 
======ciudadInternacionPaciente, obraSocialInternacion)

PACIENTE (dniPaciente, nombreApellidoPaciente, domicilioPaciente,
ciudadPaciente,

======obraPrimaria, obraSecundaria)

HOSPITAL (codHospital, nombre, domicilioHospital, ciudadHospital, directorHospital,
======cantidadHabitaciones)

ATENCIONINTERNACION
====== (dniPaciente, fechaInicioInternacion, doctorAtencion)

INSUMOINTERNACION
====== (dniPaciente, fechaInicioInternacion, insumoInternacion)



2. Listar los dni, nombre y apellido de todos los pacientes ordenados
 por dni en forma ascendente. Realice la consulta en ambas bases. 
 ¿Qué diferencia nota? 
 
 La diferencia que resalta es la repetición de información en la base
 de datos que esta desnormalizada, requiere realizar la operacion
 distinct para listar los dni y nombre de los pacientes solo una vez.
 
 Esta funcion adicional hace que la consulta tenga un tiempo de
 respuesta mucho mayor.
 
 En la base normalizada los datos son visualizados en menos de 1
 segundo, mientras que en la base de datos desnormalizada requiere 6
 segundos aproximadamente.

----
**Consulta normalizada**

```
select dniPaciente, nombreApellidoPaciente from paciente order by
dniPaciente asc
```

----
**Consulta desnormalizada**

``` 
select distinct(dniPaciente), nombreApellidoPaciente from internacion order by
dniPaciente asc
```

----

3. Hallar aquellos pacientes que para todas sus internaciones siempre
hayan usado su obra social primaria (nunca la obra social secundaria).
Realice la consulta en ambas bases. 

Normalizada
===========


Con el join tarda mas en obtener los resultados
```
/*3 que pasa si la hago con un left join y borro una subconsulta*/
select dniPaciente, nombreApellidoPaciente from paciente p where  not
exists (select * from internacion i where p.dniPaciente =
i.dniPaciente and obraSocialInternacion = obraSecundaria) and exists
(select * from internacion i where p.dniPaciente = i.dniPaciente and
obraSocialInternacion = obraPrimaria);
```
Con el distinct tarda mas la duracion de la consulta
```
select distinct(p.dniPaciente), p.nombreApellidoPaciente from paciente p right outer join internacion i on (i.dniPaciente=p.dniPaciente) where  not exists (select * from internacion i where p.dniPaciente = i.dniPaciente and obraSocialInternacion = obraSecundaria) and obraSocialInternacion = obraPrimaria;
```

desnormalizada
==============

La segunda consulta es mas rapida
```
/*3*/
select distinct(dniPaciente), nombreApellidoPaciente from internacion p where  not exists (select * from internacion i where p.dniPaciente = i.dniPaciente and i.obraSocialInternacion = p.obraSecundaria) and exists (select * from internacion i where p.dniPaciente = i.dniPaciente and i.obraSocialInternacion = p.obraPrimaria);
select distinct(dniPaciente), nombreApellidoPaciente from internacion where dniPaciente not in (select dniPaciente from internacion where obraSecundaria = obraSocialInternacion)
```

4. Crear una vista que muestre los dni de los pacientes y los códigos de hospitales de la ciudad donde vive el paciente. Realice la vista en ambas bases.

En este tengo dudas
-------------------

- Distinct a las tuplas?

#. Normalizada

```
create view dni_hospitales as select codPaciente, codHospital from paciente join hospital on (ciudadHospital=ciudadPaciente);
//group by dnipaciente,codHospital;
```
272849
#. Desnormalizada

```
create view dni_hospitales as select  h.codHospital,i.dniPaciente from
(select distinct(dniPaciente),ciudadPaciente from internacion) i join (select distinct(codHospital),ciudadHospital from internacion) h on  (i.ciudadPaciente=h.ciudadHospital) group by h.codHospital,i.dniPaciente order by h.codHospital;
```
254650

Aca voy a ir tirando las pruebas que voy realizando.

Normalizada
```
select count(dniPaciente) from hospital join paciente on
(ciudadPaciente=ciudadHospital) where codHospital=117 group by
codHospital;
```
Desnormalizada

```
select count(distinct(dniPaciente)) from internacion where
codHospital=117 group by codHospital;
```

Estas consultas devuelven numeros distintos la diferencia que tengo es
de 2k tuplas aproximadamente.





5. En la base normalizada, hallar los pacientes que se internaron en todos los hospitales de la ciudad en la que viven. Realice la misma utilizando y sin utilizar la vista creada en el ej 4.

- 1. calcular la cantidad de hospitales por ciudad
- 2. calcular todas las internaciones de un paciente por ciudad, eliminar los repetidos y contar
- 3. Restar (1-2) si = a 0 estuvo en todos lo hospitales de la ciudad


6. Hallar los pacientes que hayan declarado, en alguna de sus internaciones, el mismo domicilio y ciudad que figura en su DNI. Realice la consulta en ambas bases.


producto natural entre internacion y paciente, igualando las tablas de ciudadPaciente = ciudadInternacionPaciente, domicilioPaciente = direccionInternacionPaciente

Desnormalizada
==============

```
select dniPaciente, nombreApellidoPaciente from internacion where ciudadPaciente = ciudadInternacionPaciente and direccionInternacionPaciente=domicilioPaciente group by dniPaciente, nombreApellidoPaciente;
```


7. Para aquellas internaciones que tengan registrados mas de 3 insumos, listar el DNI del paciente, el código de hospital, la fecha de internación y la cantidad de insumos utilizados. Realice la consulta en ambas bases.

(count insumoInternacion group by dniPaciente, fechaInternacion) > 3 dniPaciente,codHospital,fechaInternacion, insumos

Desnormalizada
==============

```
select dniPaciente, codHospital, fechaInicioInternacion, count(insumoInternacion) from internacion group by dniPaciente, codHospital, fechaInicioInternacion having count(insumoInternacion) > 3;
```



8. Agregar la siguiente tabla:
