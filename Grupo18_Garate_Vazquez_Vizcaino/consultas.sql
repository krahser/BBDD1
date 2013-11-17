#.
**Consulta normalizada**

```
select dniPaciente, nombreApellidoPaciente from paciente order by
dniPaciente asc
```
**Consulta desnormalizada**

``` 
select distinct(dniPaciente), nombreApellidoPaciente from internacion order by
dniPaciente asc
```

#.

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

