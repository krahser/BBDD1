DELIMITER $$

CREATE TRIGGER after_internacion_insert AFTER INSERT ON internacion
FOR EACH ROW BEGIN
  update internacionesporpaciente
  set cantidaInternaciones = cantidaInternaciones + 1,
      fechaultimaactualizacion = NOW(),
      usuario = CURRENT_USER()
  where dniPaciente = NEW.dniPaciente;
END
