--1. Tras crear una nueva conexión y una nueva base de datos BD_Proyecto con su esquema, comenzamos a resolver consultas según la lista.


--2. Los nombres de todas las películas con una clasificación por edades de ‘R’.

SELECT f.title AS "NombrePelicula", f.rating AS "Clasificacion"
FROM film f 
WHERE f.rating ='R';


--3. Los nombres de los actores que tengan un “actor_id” entre 30 y 40.

SELECT CONCAT(a.first_name , ' ', a.last_name )  AS "NombresActores", a.actor_id 
FROM actor a 
WHERE a.actor_id BETWEEN 30 AND 40;


--4. Las películas cuyo idioma coincide con el idioma original.

SELECT f.film_id , f.title , f.language_id , f.original_language_id 
FROM film f 
WHERE f.language_id = f.original_language_id ; 

-- La consulta nos devuelve 0 filas. Comprobemos si esto significa que no hay ninguna coincidencia entre el idiomaID y el idiomaID original.

SELECT COUNT(*)
FROM film f ;

-- En total tenemos 1000 filas en la tabla "film".

SELECT COUNT(*)
FROM film f 
WHERE original_language_id IS NULL; 

/* Tenemos 1000 filas donde la columna "original_language_id" tiene valor NULL. 
Esto significa que todas las 1000 filas de la tabla no tienen valores en la columna "original_language_id".
Como no hay valores en la columna "original_language_id", no tenemos datos suficientes para determinar el idioma original de las películas. */


--5. Ordenación de las películas por duración de forma ascendente.

SELECT *
FROM film f 
ORDER BY f.length ASC;


--6. El nombre y apellido de los actores que tengan ‘Allen’ en su apellido.

SELECT CONCAT(a.first_name , ' ', a.last_name ) AS "Nombre_y_apellido"
FROM actor a 
WHERE a.last_name LIKE 'ALLEN';


--7. La cantidad total de películas en cada clasificación de la tabla “film” y la clasificación junto con el recuento.

SELECT f.rating AS "Clasificacion", COUNT(f.film_id ) AS "Cantidad_peliculas"
FROM film f 
GROUP BY f.rating;


--8. El título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas (180 min) en la tabla film.

SELECT f.title AS "Titulo", f.rating AS "Clasificasion" , f.length AS "Duracion"
FROM film f 
WHERE f.rating = 'PG-13' OR f.length  > 180;


--9. La variabilidad de lo que costaría reemplazar las películas.

SELECT 
	ROUND (variance(f.replacement_cost), 2) AS  "Varianza", 
	ROUND (stddev(f.replacement_cost ), 2) AS "Desviacion_estandar", 
	ROUND (AVG(f.replacement_cost ), 2) AS "Media",
	ROUND ((stddev_samp(f.replacement_cost))/(AVG(f.replacement_cost )) *100, 2) AS "Coeficiente_Variacion"
FROM film f ;

-- Interpretación: el Coeficiente de variación es 30.28 %, lo que indica una alta variabilidad entre los datos.


--10. La mayor y menor duración de una película.

SELECT MAX(f.length ) AS "Duracion_Max", MIN(f.length ) AS "Duracion_Min"
FROM film f ;


--11. Lo que costó el antepenúltimo alquiler ordenado por día.

SELECT r.rental_id, r.rental_date , p.amount 
FROM rental r 
INNER JOIN payment p ON r.rental_id = p.rental_id 
ORDER BY r.rental_date DESC 
LIMIT 1
OFFSET 2;


--12. El título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.

SELECT f.title AS "Titulo", f.rating AS "Clasificacion"
FROM film f 
WHERE f.rating <> 'NC-17' AND  f.rating <> 'G';


--13. El promedio de duración de las películas para cada clasificación de la tabla film y la clasificación junto con el promedio de duración.

SELECT 
	f.rating AS "Clasificacion", 
	ROUND (AVG(f.length ),2) AS "Promedio_Duracion"
FROM film f 
GROUP BY "Clasificacion" 


--14. El título de todas las películas que tengan una duración mayor a 180 minutos.

SELECT f.title AS "Titulo", f.length AS "Duracion"
FROM film f 
WHERE f.length > 180;


--15. El dinero que ha generado en total la empresa.

SELECT SUM(p.amount )
FROM payment p 


--16. Los 10 clientes con mayor valor de id.

SELECT c.customer_id , CONCAT(c.first_name ,' ', c.last_name ) AS "Clientes"
FROM customer c 
ORDER BY c.customer_id DESC 
LIMIT 10;


--17. El nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’

SELECT a.first_name  AS "Nombre_Actor",a.last_name AS "Apellido_Actor", f.title AS "Titulo_Pelicula"
FROM film_actor fa 
	INNER JOIN actor a ON fa.actor_id = a.actor_id 
	INNER JOIN film f ON fa.film_id = f.film_id
WHERE f.title LIKE 'EGG IGBY';

--18. Todos los nombres de las películas únicos.

SELECT DISTINCT f.title AS "Titulos_Únicos"
FROM film f;

--19. El título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.

SELECT f.title AS "Titulo", c."name" AS "Categoría", f.length AS "Duración"
FROM film f 
	INNER JOIN film_category fc  ON f.film_id = fc.film_id 
	INNER JOIN category c ON fc.category_id = c.category_id 
WHERE c."name" = 'Comedy' AND f.length > 180;


--20. Las categorías de películas que tienen un promedio de duración > 110 min y mostramos el nombre de la categoría junto con el promedio de duración.

WITH "PromedioDur" AS (
	SELECT c."name"  AS "Categoría", ROUND (AVG(f.length ),2) AS "Promedio_Duracion"
	FROM film f 
		JOIN film_category fc ON f.film_id = fc.film_id 
		JOIN category c ON fc.category_id =c.category_id 
	GROUP BY c.category_id )
SELECT "Categoría" , "Promedio_Duracion" 
FROM "PromedioDur" 
WHERE "Promedio_Duracion" > 110;


--21. La media de duración del alquiler de las películas.

SELECT ROUND (AVG(f.rental_duration ),2) AS "Media_Duración_Alquiler"
FROM film f;


--22. Creación de una columna con el nombre y apellidos de todos los actores y actrices.

SELECT CONCAT ( a.first_name, ' ' , a.last_name ) AS "Actores_y_Actrices"
FROM actor a ;


--23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.

SELECT 
	DATE (r.rental_date) AS "Fecha_alquiler", 
	COUNT(r.rental_id ) AS "Cantidad_Alquiler"
FROM rental r 
GROUP BY DATE (r.rental_date) 
ORDER BY "Cantidad_Alquiler" DESC;


--24. Las películas con una duración superior al promedio.

SELECT f.film_id , f.title AS "Titulo", f.length AS "Duración"
FROM film f 
WHERE f.length > (
	SELECT AVG (f.length) AS "Promedio_Duracion"
	FROM film f )
;


--25. El número de alquileres registrados por mes.

SELECT 
	EXTRACT (MONTH FROM r.rental_date) AS "Mes" ,
	EXTRACT (YEAR FROM r.rental_date) AS "Año" ,
	COUNT (r.rental_id ) AS "Numero_Alquileres"
FROM rental r 
GROUP BY "Mes", "Año"
ORDER BY "Año", "Mes";


--26. El promedio, la desviación estándar y varianza del total pagado.

SELECT 	ROUND (AVG(p.amount ),2) AS "Promedio", 
		ROUND (stddev(p.amount ),2) AS "Desviación_Estandar", 
		ROUND (variance(p.amount ),2) AS "Varianza"
FROM payment p ;


--27.  Las películas que se alquilan por encima del precio medio.

SELECT f.title AS "Titulo", p.amount AS "Precio_Alquiler>Medio"
FROM film f 
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
INNER JOIN payment p ON r.rental_id = p.rental_id
WHERE p.amount > (
	SELECT AVG (p.amount )
	FROM payment p )
;


--28. El id de los actores que hayan participado en más de 40 películas.

SELECT fa.actor_id AS "ID_Actor", COUNT (fa.film_id) AS "Número_Peliculas"
FROM film_actor fa 
GROUP BY fa.actor_id 
HAVING count (fa.film_id) > 40;


--29. Obtenemos todas las películas y, si están disponibles en el inventario, mostramos la cantidad disponible.

SELECT 
	f.film_id AS "ID_Pelicula", 
	f.title AS "Titulo" , 
	COUNT(i.inventory_id ) AS "Cantidad_Disponible"
FROM film f 
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY "ID_Pelicula" , "Titulo" 
ORDER BY "ID_Pelicula";


--30. Los actores y el número de películas en las que ha actuado

SELECT 
	CONCAT(a.first_name , ' ', a.last_name ) AS "Nombres_Actores", 
	COUNT(fa.film_id ) AS "Número_Peliculas"
FROM actor a 
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id 
GROUP BY "Nombres_Actores";


--31. Obtenemos todas las películas y mostramos los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.

SELECT 
	f.film_id AS "ID_Pelicula", 
	f.title AS "Titulo" , 
	CONCAT(a.first_name , ' ', a.last_name ) AS Nombre_Actor
FROM film f 
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
LEFT JOIN actor a ON fa.actor_id = a.actor_id
ORDER BY f.film_id ;

 
--32. Obtenemos todos los actores y mostramos las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.

SELECT 
	a.actor_id AS "ID_Actor" , 
	CONCAT(a.first_name , ' ', a.last_name ) AS Nombre_Actor, 
	f.title AS "Titulo" 
FROM actor a 
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN film f ON fa.film_id = f.film_id
ORDER BY a.actor_id;


--33. Todas las películas que tenemos y todos los registros de alquiler.

SELECT 	f.film_id AS "ID_Pelicula",
		f.title AS "Titulo" ,
		i.inventory_id AS "ID_Inventario",
		r.rental_id AS "ID_Alquiler" ,
		r.rental_date AS "Fecha_Alquiler"
FROM film f 
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
ORDER BY f.film_id;


--34. Los 5 clientes que más dinero se hayan gastado con nosotros.

SELECT 
	c.customer_id AS "ID_Cliente", 
	CONCAT(c.first_name ,' ',c.last_name ) AS "Cliente", 
	SUM(p.amount ) AS "Suma"
FROM customer c 
JOIN payment p ON c.customer_id = p.customer_id 
GROUP BY c.customer_id , "Cliente" 
ORDER BY "Suma" DESC 
LIMIT 5;


--35. Todos los actores cuyo primer nombre es 'Johnny'.

SELECT a.actor_id AS "ID_Actor", CONCAT(a.first_name ,' ', a.last_name ) AS "Nombre_Actor"
FROM actor a 
WHERE a.first_name LIKE '%JOHNNY%';


--36. Renombramos la columna “first_name” como Nombre y “last_name” como Apellido.

SELECT a.first_name AS "Nombre", a.last_name AS "Apellido"
FROM actor a;


--37. El ID del actor más bajo y más alto en la tabla actor.

SELECT MIN( a.actor_id)AS "ID_más_bajo" , MAX(a.actor_id ) AS "ID_más_alto"
FROM actor a ;


--38. Contamos cuántos actores hay en la tabla “actor”.

SELECT COUNT(*)
FROM actor a ;


--39. Todos los actores ordenados por apellido en orden ascendente.

SELECT a.first_name AS "Nombre" , a.last_name AS "Apellido"
FROM actor a 
ORDER BY a.last_name ASC;


--40. Las primeras 5 películas de la tabla “film”.

SELECT *
FROM film f 
LIMIT 5;


--41. Agrupamos los actores por su nombre y contamos cuántos actores tienen el mismo nombre.

SELECT a.first_name AS "Nombre_Actor", COUNT(*) AS "Cantidad_Nombres_Repetidos"
FROM actor a 
GROUP BY a.first_name 
ORDER BY "Cantidad_Nombres_Repetidos" DESC;

/* Los nombres más repetidos son Kenneth, Penelope y Julia. 
Cada uno de ellos se repite 4 veces.*/


--42. Todos los alquileres y los nombres de los clientes que los realizaron.

SELECT 
	r.rental_id AS "ID_Alquiler", 
	r.rental_date AS "Fecha_Alquiler" , 
	CONCAT(c.first_name , ' ', c.last_name ) AS "Nombre_Cliente"
FROM rental r 
JOIN customer c ON r.customer_id = c.customer_id;


--43. Todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.

SELECT 
	c.customer_id AS "ID_Cliente", 
	c.first_name AS "Nombre", 
	c.last_name AS "Apellido",
	r.rental_id AS "ID_Alquiler",
	r.rental_date AS "Fecha_Alquiler"
FROM customer c 
LEFT JOIN rental r ON c.customer_id = r.customer_id
ORDER BY c.customer_id, r.rental_date ;


--44. CROSS JOIN entre las tablas film y category:

SELECT *
FROM film f 
CROSS JOIN category c ;

/* Esta consulta no tiene valor. 
Dado que la base de datos solo asigna una categoría a cada película, no tiene sentido asignar cada película a todas las 16 categorías existentes. */



--45. Los actores que han participado en películas de la categoría 'Action'.


SELECT 
	DISTINCT a.actor_id ,
	CONCAT (a.first_name , ' ',a.last_name ) AS "Nombre_Actor",
	c."name" AS "Categoría"
FROM actor a 
JOIN film_actor fa ON a.actor_id = fa.actor_id 
JOIN film_category fc ON fa.film_id = fc.film_id 
JOIN category c  ON fc.category_id = c.category_id 
WHERE c."name" = 'Action'
ORDER BY actor_id ;


--46. Todos los actores que no han participado en películas.

WITH "ActorPelicula" AS (
	SELECT a.actor_id , CONCAT (a.first_name , ' ',a.last_name)AS "Nombre_Actor", fa.film_id 
	FROM actor a 
	LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
)
SELECT "Nombre_Actor", film_id 
FROM "ActorPelicula" 
WHERE film_id  IS NULL;

-- No se encontraron actores que cumplan con este criterio.


--47. El nombre de los actores y la cantidad de películas en las que han participado.

SELECT 
	a.actor_id AS "ID_Actor", 
	CONCAT( a.first_name , ' ', a.last_name )AS "Nombre_Actor",
	COUNT (fa.film_id ) AS "Cantidad_Peliculas" 
FROM actor a 
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id , "Nombre_Actor" 
ORDER BY "Cantidad_Peliculas"  ;


--48. Creamos una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.

CREATE VIEW "actor_num_peliculas" AS
	SELECT 
		a.actor_id AS "ID_Actor",
		CONCAT( a.first_name , ' ', a.last_name )AS "Nombre_Actor",
		COUNT (fa.film_id ) AS "Numero_Peliculas"
	FROM actor a 
	LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id 
	GROUP BY a.actor_id,"Nombre_Actor" 
	ORDER BY "Numero_Peliculas";


--49. El número total de alquileres realizados por cada cliente.

SELECT 
	r.customer_id AS "ID_Cliente", 
	CONCAT (c.first_name , ' ', c.last_name )AS "Nombre_Cliente",
	COUNT(r.rental_id ) AS "Número_Alquileres"
FROM rental r 
LEFT JOIN customer c ON r.customer_id = c.customer_id 
GROUP BY r.customer_id , "Nombre_Cliente" 
ORDER BY "ID_Cliente" ;
	

--50.  la duración total de las películas en la categoría 'Action'.

SELECT c."name" AS "Categoría", SUM (f.length) AS "Duración_Total_Peliculas"
FROM film f 
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id 
WHERE fc.category_id = 1
GROUP BY c."name";


--51. Creamos una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.

CREATE TEMP TABLE "cliente_rentas_temporal" AS
SELECT 
	c.customer_id AS "ID_Cliente", 
	CONCAT (c.first_name ,' ', c.last_name ) AS "Nombre_Cliente", 
	COUNT(r.rental_id ) AS "Total_Alquileres"
FROM customer c 
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY "ID_Cliente"  , "Nombre_Cliente" 
ORDER BY c.customer_id;


--52.  Creamos una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.

CREATE TEMP TABLE "peliculas_alquiladas" AS 
SELECT 
	f.film_id AS "ID_Pelicula" , 
	f.title AS "Titulo" , 
	COUNT (r.rental_id ) AS "Numero_Alquiler"
FROM film f 
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id , f.title 
HAVING COUNT (r.rental_id ) >= 10
ORDER BY "Numero_Alquiler" ;


--53. El título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. 
   -- Ordenamos los resultados alfabéticamente por título de película.

SELECT 
	f.title AS "Titulo", 
	CONCAT (c.first_name ,' ', c.last_name ) AS "Nombre_Cliente"
FROM  film f 
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id 
JOIN customer c ON r.customer_id = c.customer_id 
WHERE c.first_name = 'TAMMY' 
	AND c.last_name = 'SANDERS' 
	AND r.return_date IS NULL
ORDER BY f.title ASC;


--54. Los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. 
   -- Ordenamos los resultados alfabéticamente por apellido.

SELECT 
	DISTINCT a.first_name AS "Nombre_Actor", 
	a.last_name AS "Apellido_Actor",
	c."name" AS "Categoría"
FROM actor a 
JOIN film_actor fa ON a.actor_id = fa.actor_id 
JOIN film_category fc ON fa.film_id =fc.film_id 
JOIN category c ON fc.category_id = c.category_id
WHERE c.category_id = 14
ORDER BY a.last_name ;


--55. El nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. 
   -- Ordenamos los resultados alfabéticamente por apellido.

SELECT DISTINCT a.first_name AS "Nombre_Actor" , a.last_name AS "Apellido_Actor"
FROM actor a 
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN inventory i ON fa.film_id = i.film_id 
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.return_date >(
	SELECT r.rental_date 
	FROM film f 
	JOIN inventory i ON f.film_id = i.film_id 
	JOIN rental r ON i.inventory_id = r.inventory_id
	WHERE f.title = 'SPARTACUS CHEAPER'
	ORDER BY r.rental_date 
	LIMIT 1
)
ORDER BY a.last_name;


--56. El nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’

SELECT DISTINCT a.first_name AS "Nombre" , a.last_name "Apellido"
FROM actor a 
WHERE a.actor_id NOT IN (
	SELECT fa.actor_id 
	FROM film_actor fa
	JOIN film_category fc ON fa.film_id = fc.film_id 
	JOIN category c ON fc.category_id = c.category_id 
	WHERE c."name" = 'Music'
)
ORDER BY a.last_name;


--57.  El título de todas las películas que fueron alquiladas por más de 8 días.

SELECT DISTINCT f.title AS "Titulo"
FROM film f 
WHERE f.film_id IN ( 
	SELECT i.film_id 
	FROM inventory i
	JOIN rental r ON i.inventory_id = r.inventory_id 
	WHERE (return_date - rental_date ) > INTERVAL '8 days'
)
ORDER BY f.title ;


--58. El título de todas las películas que son de la misma categoría que ‘Animation’.

SELECT f.title AS "Pelicula_Categoría_Animación"
FROM film f 
JOIN film_category fc ON f.film_id = fc.film_id
WHERE fc.category_id = 2;


--59. Los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. 
   -- Ordenamos los resultados alfabéticamente por título de película.

SELECT f.title AS "Titulo", f.length AS "Duración"
FROM film f 
WHERE f.length = (
	SELECT f.length 
	FROM film f 
	WHERE f.title = 'DANCING FEVER'
)
ORDER BY f.title ;


--60. Los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordenamos los resultados alfabéticamente por apellido.

SELECT 
	c.first_name AS "Nombre_Cliente", 
	c.last_name AS "Apellido_Cliente", 
	COUNT( DISTINCT f.film_id ) AS "Número_Peliculas"
FROM customer c 
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id 
JOIN film f ON i.film_id = f.film_id 
GROUP BY "Nombre_Cliente" , "Apellido_Cliente" 
HAVING COUNT( DISTINCT f.film_id ) >=7
ORDER BY c.last_name ;


-- 61. La cantidad total de películas alquiladas por categoría. Mostramos el nombre de la categoría junto con el recuento de alquileres.

SELECT 
	c."name" AS "Categoría", 
	COUNT(r.rental_id ) AS "Número_Alquileres"
FROM rental r 
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id 
JOIN category c ON fc.category_id = c.category_id
GROUP BY c."name" 
ORDER BY "Número_Alquileres";


-- 62. El número de películas por categoría estrenadas en 2006.

SELECT 
	c."name"  AS "Categoría",
	COUNT(f.film_id  ) AS "Número_Peliculas_2006"
FROM film f 
JOIN film_category fc ON f.film_id = fc.film_id 
JOIN category c ON fc.category_id = c.category_id
WHERE f.release_year = 2006
GROUP BY c."name" 
ORDER BY "Número_Peliculas_2006" ;


--63. Todas las combinaciones posibles de trabajadores con las tiendas que tenemos.

SELECT 
	s.store_id AS "Tienda" ,
	s2.staff_id AS "ID_Trabajador" , 
	s2.first_name AS "Nombre_Trabajador" ,
	s2.last_name AS "Apellido_Trabajador"
FROM store s 
CROSS JOIN staff s2;


--64. La cantidad total de películas alquiladas por cada cliente y el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT 
	c.customer_id AS "ID_Cliente" , 
	c.first_name AS "Nombre_Cliente", 
	c.last_name AS "Apellido_Cliente",
	count (DISTINCT i.film_id  ) AS "Cantidad_Peliculas"
FROM customer c 
JOIN rental r ON c.customer_id = r.customer_id 
JOIN inventory i ON r.inventory_id = i.inventory_id 
GROUP BY c.customer_id , c.first_name , c.last_name 
ORDER BY c.customer_id ;

/* En esta consulta, el recuento de películas "Cantidad_Peliculas" incluye el número de películas alquiladas, pero no el número de alquileres. 
Es decir, si un cliente ha alquilado una película varias veces, esa película se incluye solo una vez.*/
