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
