/* ACTIVIDAD: DOMINIO DE JOINS EN SQL SERVER
   BASE DE DATOS: PUBS
*/

USE pubs;
GO

-------------------------------------------------------------------------------
-- 1. INNER JOINS (8 Consultas de Integridad y Coincidencia) [cite: 9]
-------------------------------------------------------------------------------

-- 1. Identificar qué libros pertenecen a cada editorial para gestión de inventario.
SELECT P.pub_name AS Editorial, T.title AS Titulo_Libro
FROM publishers P
INNER JOIN titles T ON P.pub_id = T.pub_id;

-- 2. Listar autores y sus respectivos títulos para el catálogo de la biblioteca.
SELECT A.au_fname + ' ' + A.au_lname AS Autor, T.title AS Titulo
FROM authors A
INNER JOIN titleauthor TA ON A.au_id = TA.au_id
INNER JOIN titles T ON TA.title_id = T.title_id;

-- 3. Consultar las ventas detalladas por tienda para análisis de ingresos.
SELECT S.stor_name AS Tienda, T.title AS Libro_Vendido, SA.qty AS Cantidad
FROM stores S
INNER JOIN sales SA ON S.stor_id = SA.stor_id
INNER JOIN titles T ON SA.title_id = T.title_id;

-- 4. Listar empleados y la descripción de sus cargos para el módulo de RRHH.
SELECT E.fname + ' ' + E.lname AS Empleado, J.job_desc AS Cargo
FROM employee E
INNER JOIN jobs J ON E.job_id = J.job_id;

-- 5. CORREGIDA: Títulos y sus rangos de regalías (Análisis de costos)
-- Se cambió 'roaltyper' por 'roysched' que es el nombre correcto en Pubs.
-------------------------------------------------------------------------------
SELECT T.title AS Titulo, R.lorange, R.hirange, R.royalty
FROM titles T
INNER JOIN roysched R ON T.title_id = R.title_id;

-- 6. Relacionar tiendas con sus respectivas facturas/órdenes de compra.
SELECT ST.stor_name, SA.ord_num, SA.ord_date
FROM stores ST
INNER JOIN sales SA ON ST.stor_id = SA.stor_id;

-- 7. CORREGIDA: Autores y Editoriales en la misma ciudad
-- Se asegura el uso de alias para evitar ambigüedad en la columna 'city'.
-------------------------------------------------------------------------------
SELECT A.au_fname + ' ' + A.au_lname AS Autor, A.city AS Ciudad_Autor, P.pub_name AS Editorial
FROM authors A
INNER JOIN publishers P ON A.city = P.city;

-- 8. Ver el nivel de cargo (job_lvl) alcanzado por cada empleado.
SELECT E.fname + ' ' + E.lname AS Empleado, J.job_desc, E.job_lvl
FROM employee E
INNER JOIN jobs J ON E.job_id = J.job_id
WHERE E.job_lvl > 100; -- Solo empleados con nivel de responsabilidad alto

-------------------------------------------------------------------------------
-- 2. LEFT JOIN (1 Consulta) [cite: 10]
-------------------------------------------------------------------------------

-- 9. Identificar autores "pasivos" (registrados pero que no han publicado libros).
-- Sentido de negocio: Campaña de fidelización para nuevos autores.
SELECT A.au_fname + ' ' + A.au_lname AS Autor, TA.title_id
FROM authors A
LEFT JOIN titleauthor TA ON A.au_id = TA.au_id
WHERE TA.title_id IS NULL;

-------------------------------------------------------------------------------
-- 3. RIGHT JOIN (1 Consulta) [cite: 11]
-------------------------------------------------------------------------------

-- 10. Identificar editoriales que no tienen personal administrativo asignado.
-- Sentido de negocio: Auditoría de nómina y sucursales sin empleados.
SELECT E.fname AS Nombre_Empleado, P.pub_name AS Editorial
FROM employee E
RIGHT JOIN publishers P ON E.pub_id = P.pub_id
WHERE E.emp_id IS NULL; 