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
