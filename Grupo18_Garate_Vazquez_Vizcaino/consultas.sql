1.
**Consulta normalizada**
```
select dniPaciente, nombreApellidoPaciente from paciente order by dniPaciente asc
```
**Consulta desnormalizada**

``` 
select distinct(dniPaciente), nombreApellidoPaciente from internacion order by asc
```

2.
**consulta normalizada**
```
 select dniPaciente, nombreApellidoPaciente from paciente p where not exists (select * from internacion i where obraSecundaria = obraSocialInternacion and p.dniPaciente=i.dniPaciente);
```
**consulta desnormalizada**
```
select distinct(dniPaciente), nombreApellidoPaciente from internacion p where  not exists (select * from internacion i where p.dniPaciente = i.dniPaciente and i.obraSocialInternacion = p.obraSecundaria) and exists (select * from internacion i where p.dniPaciente = i.dniPaciente and i.obraSocialInternacion = p.obraPrimaria);
```
3.
