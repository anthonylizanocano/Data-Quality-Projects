/* EJERCICIO 1: LIMPIEZA Y VALIDACIÓN DE CALIDAD DE DATOS
Escenario: Se recibe una tabla 'Postulantes_Raw' con datos inconsistentes del sistema de registro.
Objetivo: Limpiar duplicados, normalizar textos y validar montos.
*/

-- 1. Crear tabla de resultados limpios
CREATE TABLE Postulantes_Calidad AS
SELECT 
    DISTINCT -- Dimensión de Calidad: Unicidad (Elimina duplicados)
    UPPER(Nombre) AS Nombre_Normalizado, -- Normalización: Todo a mayúsculas
    DNI,
    -- Dimensión de Calidad: Completitud (Maneja valores nulos en el correo)
    COALESCE(Email, 'SIN_CORREO@dominio.com') AS Email_Validado,
    -- Dimensión de Calidad: Consistencia (Asegura que la edad sea lógica)
    CASE 
        WHEN Edad < 0 THEN Edad * -1 
        WHEN Edad IS NULL THEN 18 -- Valor por defecto razonable
        ELSE Edad 
    END AS Edad_Corregida,
    -- Formateo de fecha para consistencia técnica
    CAST(FechaRegistro AS DATE) AS Fecha_Estandarizada
FROM Postulantes_Raw
WHERE DNI IS NOT NULL; -- Regla de negocio: No se aceptan registros sin identidad

-- 2. Identificación de registros erróneos (Data Profiling)
-- Creamos una vista para que el equipo de sistemas revise los errores de origen
CREATE VIEW Alertas_de_Calidad AS
SELECT * FROM Postulantes_Raw
WHERE MontoIngresos < 0 OR Email NOT LIKE '%@%';
