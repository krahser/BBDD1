2.
**Consulta normalizada**
```
select dniPaciente, nombreApellidoPaciente 
from paciente 
order by dniPaciente asc
```
**Consulta desnormalizada**

``` 
select distinct(dniPaciente), nombreApellidoPaciente 
from internacion 
order by asc
```

3.
**consulta normalizada**
```
 select dniPaciente, nombreApellidoPaciente 
from paciente p 
where not exists (select * 
      	  	  from internacion i 
		  where obraSecundaria = obraSocialInternacion and p.dniPaciente=i.dniPaciente);
```
**consulta desnormalizada**
```
select distinct(dniPaciente), nombreApellidoPaciente 
from internacion p 
where  not exists (select * 
       	   	   from internacion i 
		   where p.dniPaciente = i.dniPaciente and i.obraSocialInternacion = p.obraSecundaria) and exists (select * from internacion i where p.dniPaciente = i.dniPaciente and i.obraSocialInternacion = p.obraPrimaria);
```

4.

Teniendo en cuenta que la catedra menciono en el foro[1] que hay que aplicar (Cod 1). se verifico que el nombre la ciudad coincida en la base de datos desnormalizada(Cod 2) esto nos indico que tambien teniamos que actualizar la base desnormalizada(Cod 3)

(Cod 1)
```
update hospital 
set ciudadhospital ='General Pacheco' 
where codHospital=111;
```

(Cod 2)
```
select distinct(dniPaciente) 
from internacion 
where ciudadPaciente='General Pacheco';
select distinct(dniPaciente) 
from internacion 
where ciudadPaciente='General  Pacheco';
select distinct(codHospital) 
from internacion 
ggwhere ciudadHospital= 'General Pacheco';
select distinct(codHospital) 
from internacion 
where ciudadHospital= 'General  Pacheco';
```

(Cod 3)
```
update internacion 
set ciudadhospital ='General Pacheco' 
where ciudadhospital='General  Pacheco';
```


Con esas consideraciones el ejercicio nos quedo resuelto

**Consulta normalizada**
```
create view dniPacientecodHospital as 
       select dniPaciente, codHospital 
       from paciente join hospital on (ciudadHospital=ciudadPaciente);
```

**consulta desnormalizada**

El problema que se nos presento es que los dni y los codigos de hospital, siento campos disjuntos, estan repetidos en las tuplas. en primera instancia tratamos de planificar la solucion con subconsultas en el form, pero eso no esta permitido para realizar en las vistas.

```
create view pacienteCiudad as select distinct(dniPaciente),ciudadPaciente 
from internacion;
create view hospitalCiudad as select distinct(codHospital),ciudadHospital 
from internacion;
create view dniPacientecodHospital as select dniPaciente, codHospital 
from pacienteCiudad join hospitalCiudad on (ciudadHospital = ciudadPaciente);
```

5.
**consulta normalizada**
SELECT DISTINCT dniPaciente FROM paciente p
  WHERE NOT EXISTS (
    SELECT * FROM hospital h WHERE NOT EXISTS (
      SELECT * FROM internacion i
       WHERE i.dniPaciente = p.dniPaciente);

select p.dniPaciente, count(i.codHospital), hospitales_paciente,(select count(*) from hospital h where h.ciudadHospital = ciudadPaciente) as cantidad
from paciente p
inner join internacion i on p.dniPaciente = i.dniPaciente
inner join hospital h on p.ciudadPaciente = h.ciudadHospital
group by p.dniPaciente
having hospitales_paciente = cantidad


6.
**Normalizada**
select p.dniPaciente
from paciente p
inner join internacion i on p.dniPaciente = i.dniPaciente
where p.ciudadPaciente = i.ciudadInternacionPaciente and p.domicilioPaciente = i.direccionInternacionPaciente
group by p.dniPaciente
 
**Desnormalizada**
select dniPaciente
from internacion
where ciudadPaciente = ciudadInternacionPaciente and domicilioPaciente = direccionInternacionPaciente
group by dniPaciente

7.
select codHospital, i.dniPaciente, i.fechaInicioInternacion, count(insumoInternacion) as cantidad_insumos
from internacion i
inner join insumointernacion ii on i.dniPaciente = ii.dniPaciente
where i.fechaInicioInternacion = ii.fechaInicioInternacion
having cantidad_insumos > 3



9.
DELIMITER $$

CREATE PROCEDURE `update_internacionesporpaciente`()
BEGIN

DECLARE terminado int DEFAULT 0;
DECLARE usuario char(16);
DECLARE fecha datetime;
DECLARE dni int(11);
DECLARE nroInternaciones int;
DECLARE internaciones CURSOR FOR
  select dniPaciente, count(*)
  from internacion
  group by dniPaciente;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET terminado = 1;

DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
DECLARE EXIT HANDLER FOR SQLWARNING ROLLBACK;

SET usuario = CURRENT_USER();
SET fecha = NOW();

START TRANSACTION;

OPEN internaciones;

read_loop: LOOP
  FETCH internaciones INTO dni, nroInternaciones;
  INSERT INTO internacionesporpaciente(dniPaciente, cantidaInternaciones, fechaultimaactualizacion, usuario)
         VALUES(dni, nroInternaciones, fecha, usuario);
  IF terminado = 1 THEN
    LEAVE read_loop;
  END IF;
END LOOP;

CLOSE internaciones;

COMMIT;

END

10.
DELIMITER $$

CREATE TRIGGER after_internacion_insert AFTER INSERT ON internacion
FOR EACH ROW BEGIN
  update internacionesporpaciente
  set cantidaInternaciones = cantidaInternaciones + 1,
      fechaultimaactualizacion = NOW(),
      usuario = CURRENT_USER()
  where dniPaciente = NEW.dniPaciente;
END

11-12
DELIMITER $$

CREATE PROCEDURE `agregar_internacion`(
	IN dniPaciente int(11),
	IN codHospital int(11),
	IN fechaInternacion datetime,
	IN cantDiasInternacion int(11),
	IN telefonoInternacion varchar(45),
	IN doctorAtencion varchar(50),
	IN insumoAtencion varchar(30)
)
BEGIN
	START TRANSACTION;
	
	insert into internacion(codHospital, dniPaciente, fechaInicioInternacion, cantDiasInternacion, telefonoInternacionPaciente)
	values(codHospital, dniPaciente, fechaInternacion, cantDiasInternacion, telefonoInternacion);

	insert into atencioninternacion values(dniPaciente, fechaInternacion, doctorAtencion);

	insert into insumointernacion values(dniPaciente, fechaInternacion, insumoAtencion);

	COMMIT;
END

call agregar_internacion(1002342, 100, '2009-02-23 12:20:31', 3, '4243-4255', 'Dr. Maidana', 'algodón');

select * from internacion where dniPaciente = 1002342;
select * from insumointernacion where dniPaciente = 1002342;
select * from atencioninternacion where dniPaciente = 1002342;
select * from internacionesporpaciente where dniPaciente = 1002342;


