--DataProject:
--LogicaConsultasSQL:

 -- 2. Muestra los nombres de las peliculas con clasificacion R
select f.title 
from film f 
where f.rating = 'R';

 --3. Nombres actores que tengas actor_id entre 30 y 40
select a.actor_id, 
concat (first_name, ' ', last_name) as actor
from actor a 
where a.actor_id between 30 and 40;

--4. Peliculas cuyo idioma es idioma original
select f.title 
from film f
where f.original_language_id = f.language_id ;

 -- 5.Ordena Peliculas por duracion asc
select f.title, f.length 
from film f
order by f.length  asc ;

-- 6.Nombre y apellido actores que tengan Allen en su apellido
select concat (first_name, ' ', last_name) as actor
from actor a 
where last_name = 'ALLEN';

-- 7.total peliculas en cada clasificacion 
select f.rating ,  count (f.film_id ) as cantidad
from film f 
group by f.rating  ;

 -- 8. titulos con clasificacion PG-13 o duracion mas de 3 horas
select f.title , f.rating , f.length   as duracion
from film f 
where f.rating = 'PG-13' or f.length > 180  ;

 --9. Variabilidad de coste de reemplazar las peliculas
select round (VARIANCE(replacement_cost), 2)  as Varianza_coste_reemplazo
from film f  ;

 -- 10. Mayor y menor duracion pelicula
select  MAX(f.length  ) as pelicula_mas_larga, 
        MIN(f.length ) as pelicula_mas_corta
from film f ;


-- Titulo y mayor duracion
select f.title , f.length 
from film f 
order by length desc 
limit 1;

-- Titulo y menor duracion
select f.title , f.length 
from film f 
order by length asc 
limit 1;

 -- 11. lo que costo el antepenultimo alquiler ordenado por dia
select p.amount as precio_alquiler
from payment p 
order by p.payment_date ASC
limit 1 offset 2;

 --12.  peliculas que no sean ni NC-17 ni G
select f.title, f.rating 
from film f 
where f.rating not in ('NC-17', 'G');

 -- 13. promedio de duracion peliculas en cada clasificacion, mas mostar clasificacion
select f.rating, round (AVG(f.length  ), 2)
from film f 
group by f.rating;

 -- 14. titulo peliculas con duracion mayor a 180 minutos
select f.title , f.length as duracion
from film f 
where f.length > 180
order by duracion ;

 --15. dinero que ha generado la empresa
select sum(p.amount ) as total_dinero_generado
from payment p;



 -- 16. 10 clientes con mayor valor de id
select c.customer_id , concat( c.first_name ,' ', c.last_name) as nombre_cliente
from customer c 
order by c.customer_id desc
limit 10;

 --17.  nombre y apellido actores de Egg Igby
select a.first_name as nombre, a.last_name as apellido
from actor a
join film_actor fa 
on a.actor_id = fa.actor_id
join film f
on f.film_id = fa.film_id 
where f.title = 'EGG IGBY'

 -- 18. nombres de las peliculas unicas
select distinct f.title 
from film f ;

 --19.  comedias con duracion mayor a 180 minutos
select f.title 
from film f 
where f.length > 180 and f.film_id in (
select film_id
from film_category
where category_id in (
select category_id
from category
where name  = 'Comedy'));


 -- 20. categorias con promedio de duracion >110 mas el nombre de la categoria
select name as categoria, ROUND (AVG (f.length), 2) as promedio_duracion
from category c
join film_category fc 
on c.category_id = fc.category_id
join film f 
on f.film_id = fc.film_id 
group by c.name
having ROUND (AVG (f.length), 2) > 110;
 

 -- 21. media de duracion de alquiler
select AVG(return_date - rental_date ) as promedio_alquiler
from rental;

 –- 22. nombre y apellido de los actores
select concat (a.first_name , ' ', a.last_name ) as nombre_actor
from actor a ;

 -- 23.numero de alquiler por dia ordenados por cantidad de alquileres desc
select  DATE(rental_date) as dia, count(r.rental_id ) as numeros_alquiler
from rental r 
group by DATE(r.rental_date) 
order by count (r.rental_id ) desc;

-- 24. peliculas con duracion superior a promedio
with duracion_promedia as (
select AVG (length  ) as promedio
from film
)


select f.title , f.length 
from film f 
where length > (select promedio from duracion_promedia) ;

-- 25. numero de alquileres por mes

select count (r.rental_id ) as numero_alquileres, date_trunc('month', r.rental_date ) as mes_año 
from rental r 
group by date_trunc('month', r.rental_date );

 -- 26.  promedio, desviacion estandar y varianza del total pagado
select ROUND (AVG (p.amount ), 2) as promedio,
ROUND (STDDEV (p.amount ), 2) as desviacion_estandar, 
ROUND (VARIANCE (p.amount ) ,2) as varianza
from payment p ;

 -- 27. peliculas que se alquilan por encima del precio medio
with precio_promedio as (
select AVG (rental_rate) as promedio_alquiler
from film f )

select title, f.rental_rate 
from film f 
where f.rental_rate > (select promedio_alquiler from precio_promedio);


-- 28. id de los actores que tienen mas de 40 peliculas
select fa.actor_id 
from film_actor fa 
group by actor_id 
having count(film_id) > 40;

 -- 29. obtener peliculas y, si estan disponibles, cantidad disponible

select f.title, count(i2.film_id ) as cantidad
from film f 
left join inventory i2 
on f.film_id = i2.film_id 
group by f.title ;


 -- 30. actores y numero de peliculas en las que han actuado

select concat (a.first_name, ' ', a.last_name ) as nombre_actor,
count (film_id) as numero_peliculas
from actor a 
left join film_actor fa
on a.actor_id = fa.actor_id 
group by a.actor_id ;

 -- 31. peliculas y nombre de los actores que han participado (incluso sin actores asociados)
select f.title as pelicula, concat (a.first_name, ' ', a.last_name ) as actor 
from film f 
left join film_actor fa 
on f.film_id = fa.film_id
left join actor a 
on fa.actor_id = a.actor_id;

 -- 32. peliculas y nombre de los actores que han participado (incluso si actores no tienen peli)
select  concat (a.first_name, ' ', a.last_name ) as actor, f.title as pelicula
from film f 
right join film_actor fa 
on f.film_id = fa.film_id
right join actor a 
on fa.actor_id = a.actor_id;

 -- 33. peliculas y registros de alquiler
select  f. title as pelicula, r.rental_id , r.rental_date as fecha_alquiler 
from rental r 
full join inventory i 
on r.inventory_id = i.inventory_id
full join film f
on i.film_id = f.film_id;



 -- 34. 5 clientes que mas dinero han gastado

select  concat (c.first_name , ' ', c.last_name  ) as cliente, 
sum (p.amount ) as total_gastado
from customer c 
join payment p 
on p.customer_id = c.customer_id 
group by concat (c.first_name  , ' ', c.last_name  )
order by total_gastado desc
limit 5;

 -- 35. actores cuyo primer nombre es Johnny

select concat (a.first_name , ' ', a.last_name )
from actor a 
where a.first_name = 'JOHNNY';

 -- 36. renombrar columna first name as nombre, last name as apellido
select a.first_name as Nombre, a.last_name as Apellido
from actor a;


 -- 37. id de actor mas alto 
select a.actor_id 
from actor a
order by a.actor_id desc
limit 1;

-- id de actor mas bajo

select a.actor_id 
from actor a
order by a.actor_id asc
limit 1;

 -- 38. cuantos actores hay en la tabla actor
select count(a.actor_id) as numero_actores
from actor a ;

 -- 39. todos los actores ordenador por apellido asc
select a.last_name ,  a.first_name 
from actor a 
order by a.last_name asc;

 -- 40. las primeras 5 peliculas de la tabla film
select f.title  as pelicula
from film f 
order by f.film_id 
limit 5;

 -- 41.los nombres de los actores mas repetidos
select a.first_name as nomre, count(a.actor_id ) as veces_repetido
from actor a 
group by a.first_name
order by veces_repetido desc ;

--Los nombres mas repetidos son Kenneth, Penelope y Julia (4 veces)

 -- 42. los alquileres y nombres de los clientes
select r.rental_id , r.rental_date as fecha , concat (c.first_name , ' ', c.last_name  ) as nombre_cliente
from rental r 
left join customer c 
on r.customer_id = c.customer_id;


 -- 43. nombres de los clientes y sus alquileres (si hay)
select concat (c.first_name  , ' ', c.last_name  ) as nombre_cliente, r.rental_id , r.rental_date as fecha 
from rental r 
right join customer c 
on r.customer_id = c.customer_id  ;

-- 44. cross join entre tablas film y category
select *
from film f 
cross join category c ;

/*La consulta no tiene sentido ya que no aporta ningun tipo de informacion. 
 Es mas, da datos erroneos acerca de la categoria de la pelicula
 al mezclar todas las peliculas con todas las categorias.  */

-- 45. Actores que han participado en categoría Action
   with categoria_pelicula as (
  select c.category_id 
  from category c 
  where name = 'Action'
),

  id_pelicula as (
   select fc. film_id
   from film_category fc 
   where fc.category_id IN (select category_id from categoria_pelicula)
)

select a.first_name as nombre , a.last_name as apellido
from actor a 
join film_actor fa 
on a.actor_id = fa.actor_id
where fa.film_id IN (select film_id from id_pelicula)
group by a.first_name, a.last_name;


 -- 46. actores que no han participado en las peliculas

select a.first_name, a.last_name 
from actor a 
full join film_actor fa 
on a.actor_id = fa.actor_id
where fa.film_id is null;

select a.first_name as nombre, a.last_name as apellido
from actor a 
where a.actor_id not in (
select fa.actor_id 
from film_actor fa
);
--en los dos casos la consulta no da resultados

 --47. actores y su numero de peliculas

select concat (a.first_name , ' ', a.last_name ) as nombre_actor, 
count (fa.film_id ) as numero_peliculas
from actor a 
left join film_actor fa 
on a.actor_id = fa.actor_id
group by a.actor_id ;

 -- 48 vista "actor_num_peliculas" con actores y su numero de peliculas
create or replace view actor_num_peliculas AS

select concat (a.first_name , ' ', a.last_name ) as nombre_actor, 
count (fa.film_id ) as numero_peliculas
from actor a 
left join film_actor fa 
on a.actor_id = fa.actor_id
group by nombre_actor;

 -- 49 numero total de alquileres por cada cliente
select concat (c.first_name  , ' ', c.last_name  ) as nombre_cliente, count(r.rental_id ) as alquileres
from customer c 
left join rental r 
on c.customer_id  = r.customer_id 
group by nombre_cliente ;

 -- 50. duracion total de peliculas de Action
select sum (length) as duracion_total
from film f 
left join film_category fc 
on f.film_id = fc.film_id
left join category ca
on fc.category_id = ca.category_id 
where name = 'Action';

 -- 51. tabla temporal que almacena todos los alquileres por cliente

create temporary table clientes_alquiler2 as 
select c.first_name, 
 c.last_name,
r.rental_id ,
r.rental_date,
r.return_date 
from customer c 
join rental r 
on c.customer_id = r.customer_id 
order by c.last_name;


select *
from clientes_alquiler2;


 -- 52. tabla temporal peliculas_alquiladas que almacena peliculas alquiladas al menos 10 veces

create temporary table peliculas_alquiladas as 
select f.title as pelicula, count (r.rental_id) as veces_alquilada
from film f
join inventory i
on f.film_id = i.film_id
join rental r
on i.inventory_id = r.inventory_id
group by f.title
having count (r.rental_id) >=10;

select *
from peliculas_alquiladas;


 -- 53. pelis alquiladas por Tammy Sanders no devueltas ordenadas alfabeticamente por titulo

select f.title as pelicula ,
c.first_name as nombre,
c.last_name as apellido,
r.rental_date as fecha_alquiler
from rental r 
left join customer c 
on r.customer_id = c.customer_id
left join inventory i 
on i.inventory_id = r.inventory_id 
left join film f 
on f.film_id = i.film_id 
where c.first_name = 'TAMMY' and c.last_name = 'SANDERS' and r.return_date is null
order by f.title asc;

 --54. nombres actores que han actuado en Sci-Fi alfabeticamente por apellido

select a.last_name as apellido,
a.first_name as nombre
from actor a 
left join film_actor fa 
on a.actor_id = fa.actor_id
left join film_category fc 
on fa.film_id = fc.film_id 
left join category ca
on ca.category_id = fc.category_id 
where ca.name = 'Sci-Fi'
group by a.last_name , a.first_name 
order by apellido;

 -- 55. nombre y apellido actores de pelis que se alquilaron despues de Spartacus Cheaper. abc por apellido

with primer_alquiler_Spartacus as (

select rental_date
from rental r 
where r.inventory_id  in(
select inventory_id
from inventory i
join film f
on f.film_id = i.film_id
where f.title = 'SPARTACUS CHEAPER')
order by r.rental_date 
limit 1
)

select a.last_name as apellido, 
a.first_name as nombre
from actor a 
join film_actor fa 
on a.actor_id =fa.actor_id 
join inventory i 
on fa.film_id = i.film_id 
join rental r 
on i.inventory_id = r.inventory_id 
where r.rental_date > (select rental_date from primer_alquiler_Spartacus)
group by apellido , nombre 
order by apellido;

 -- 56. nombre y apellido de actores que no han actuado en pelicula music
select distinct a.first_name as nombre, a.last_name as apellido
from actor a 
where a.actor_id not in (
select fa.actor_id
from film_actor fa
join film f
on f.film_id = fa.film_id
join film_category fc
on f.film_id = fc.film_id
join category c
on fc.category_id = c.category_id
where c.name = 'Music');

 --57. peliculas alquiladas por mas de 8 dias

select f.title , r.rental_date, r.return_date 
from film f 
join inventory i 
on f.film_id = i.film_id
join rental r
on r.inventory_id = i.inventory_id 
where r.return_date - r.rental_date > interval '8 days';

 -- 58. titulo peliculas de categoria de animacion
select f2.title as titulo
from film f2  
where f2.film_id in (
select fc.film_id
from film_category fc 
join category c
on fc.category_id = c.category_id
where c.name = 'Animation');

-- 59. titulo peliculas con la misma duracion que Dancing Fever abc por titulo

select f.title 
from film f 
where f.length = (
select f2.length 
from film f2 
where title = 'DANCING FEVER')
order by f.title ;

 --60. nombres de clientes que alquilaron 7 pelis distintas. abc por apellido

select c.last_name  as apellido, c.first_name  as nombre, 
count (distinct i.film_id ) as peliculas_distintas
from customer c 
join rental r 
on r.customer_id = c.customer_id 
join inventory i 
on r.inventory_id = i.inventory_id 
group by c.last_name  , c.first_name  
having count (distinct i.film_id ) > 7
order by c.last_name  ;



-- 61. cantidad total de peliculas alquiladas por categoria + nombre de categoria

select c.name as categoria,
count (r.rental_id ) as peliculas_alquiladas
from rental r 
join inventory i 
on r.inventory_id = i.inventory_id
join film f 
on i.film_id = f.film_id
join film_category fc 
on f.film_id = fc.film_id
join category c
on fc.category_id = c.category_id
group by c.name;


-- 62. numero de peliculas por categoria estrenadas en 2006

select c.name as categoria,
count  (f.film_id ) as numero_peliculas
from film f 
join film_category fc 
on f.film_id = fc.film_id
join category c 
on c.category_id = fc.category_id 
where f.release_year = 2006
group by c.name; 


 -- 63. todas las combinaciones de empleado y tienda

select concat (e."FirstName"  , ' ', e."LastName" ) as nombre_empleado, s2.store_id 
from "Employee" e 
cross join store s2 ;

 -- 64. Id de cliente, nombre, apellido y cantidad peliculas alquiladas

select c.customer_id  , c.first_name   as nombre, c.last_name   as apellido, 
count (r.rental_id ) as cantidad_peliculas
from customer c 
left join rental r 
on c.customer_id   = r.customer_id 
group by c.customer_id , c.first_name  , c.last_name 
order by c.customer_id  ;



