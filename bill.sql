--DESAFIO: Desafío - Entendiendo cómo se comportan nuestros clientes

-- 1.- Cargar  respaldo bd.
--Apagar AC, para trabajar directo desde el terminal:
-- bill=# \set AUTOCOMMIT OFF
-- bill=# \echo :AUTOCOMMIT
-- OFF

--LUEGO...

--CREATE DATABASE bill;
-- Y transferir datos de unidad2 a bill db.
--psql -U jlopez bill < unidad2.sql

-- 2.- El cliente usuario01 realiza compra:
-- Producto: producto9
-- Cantidad: 5
-- Fecha: Fecha del sistema


--Tabla producto 1: Revisar.
SELECT * FROM producto;
 id | descripcion | stock | precio 
----+-------------+-------+--------
  3 | producto3   |     9 |   9449
  4 | producto4   |     8 |    194
  5 | producto5   |    10 |   3764
  6 | producto6   |     6 |   8655
  7 | producto7   |     4 |   2875
 10 | producto10  |     1 |   3001
 11 | producto11  |     9 |   7993
 12 | producto12  |     3 |   8504
 13 | producto13  |    10 |   2415
 14 | producto14  |     5 |   3824
 15 | producto15  |    10 |   7358
 16 | producto16  |     7 |   3631
 17 | producto17  |     3 |   4467
 18 | producto18  |     2 |   9383
 19 | producto19  |     6 |   1140
 20 | producto20  |     4 |    102
  9 | producto9   |     8 |   4219
  1 | producto1   |     6 |   9107
  2 | producto2   |     5 |   1760
  8 | producto8   |     0 |   8923

-- Ejecuta transacción 1era:
BEGIN; 
  INSERT INTO compra (cliente_id,fecha) 
  VALUES(1, now()); 
  INSERT INTO detalle_compra(producto_id, compra_id, cantidad) 
  VALUES(9,32,5); 

--Tabla productos 2: Post transaccion 1.
SELECT * FROM producto;

 id | descripcion | stock | precio 
----+-------------+-------+--------
  3 | producto3   |     9 |   9449
  4 | producto4   |     8 |    194
  5 | producto5   |    10 |   3764
  6 | producto6   |     6 |   8655
  7 | producto7   |     4 |   2875
 10 | producto10  |     1 |   3001
 11 | producto11  |     9 |   7993
 12 | producto12  |     3 |   8504
 13 | producto13  |    10 |   2415
 14 | producto14  |     5 |   3824
 15 | producto15  |    10 |   7358
 16 | producto16  |     7 |   3631
 17 | producto17  |     3 |   4467
 18 | producto18  |     2 |   9383
 19 | producto19  |     6 |   1140
 20 | producto20  |     4 |    102
  1 | producto1   |     6 |   9107
  2 | producto2   |     5 |   1760
  8 | producto8   |     0 |   8923
  9 | producto9   |     3 |   4219


-- 3.- El cliente usuario02 realiza compra:
-- Productos: producto1, producto 2, producto 8.
-- Cantidad: 3 de cada uno.
-- Fecha: fecha del sistema.

-- Ejecuta transacción 2da:
-- +Savepoint, realizar ROLLBACK en ausencia de stock.

BEGIN; 
  INSERT INTO compra (cliente_id, id, fecha) 
  VALUES(1, 33, now()); 
  INSERT INTO detalle_compra(producto_id, compra_id, cantidad) 
  VALUES(1,33,3); 
  UPDATE producto SET stock = stock - 3 WHERE id = 1;
  SAVEPOINT checkpoint; 


--Tabla productos 2: Post transaccion 2.
SELECT * FROM producto;

 id | descripcion | stock | precio 
----+-------------+-------+--------
  3 | producto3   |     9 |   9449
  4 | producto4   |     8 |    194
  5 | producto5   |    10 |   3764
  6 | producto6   |     6 |   8655
  7 | producto7   |     4 |   2875
 10 | producto10  |     1 |   3001
 11 | producto11  |     9 |   7993
 12 | producto12  |     3 |   8504
 13 | producto13  |    10 |   2415
 14 | producto14  |     5 |   3824
 15 | producto15  |    10 |   7358
 16 | producto16  |     7 |   3631
 17 | producto17  |     3 |   4467
 18 | producto18  |     2 |   9383
 19 | producto19  |     6 |   1140
 20 | producto20  |     4 |    102
  2 | producto2   |     5 |   1760
  8 | producto8   |     0 |   8923
  9 | producto9   |     3 |   4219
  1 | producto1   |     3 |   9107

--> Se genera -3  stock en el producto 1.


-- Ejecuta transacción 3era:
 BEGIN; 
  INSERT INTO compra (cliente_id, id, fecha) 
  VALUES(2, 43, now()); 

  INSERT INTO detalle_compra(producto_id, compra_id, cantidad)
  VALUES(2,43,3); 
  UPDATE producto SET stock = stock - 3 WHERE id = 2;

--Tabla productos 3: Post transaccion 3era.
SELECT * FROM producto;

 id | descripcion | stock | precio 
----+-------------+-------+--------
  3 | producto3   |     9 |   9449
  4 | producto4   |     8 |    194
  5 | producto5   |    10 |   3764
  6 | producto6   |     6 |   8655
  7 | producto7   |     4 |   2875
 10 | producto10  |     1 |   3001
 11 | producto11  |     9 |   7993
 12 | producto12  |     3 |   8504
 13 | producto13  |    10 |   2415
 14 | producto14  |     5 |   3824
 15 | producto15  |    10 |   7358
 16 | producto16  |     7 |   3631
 17 | producto17  |     3 |   4467
 18 | producto18  |     2 |   9383
 19 | producto19  |     6 |   1140
 20 | producto20  |     4 |    102
  1 | producto1   |     6 |   9107
  8 | producto8   |     0 |   8923
  9 | producto9   |     3 |   4219
  2 | producto2   |     2 |   1760


---- Ejecuta transacción 3era (producto 8):

 BEGIN; 
  INSERT INTO compra (cliente_id, id, fecha) 
  VALUES(8, 44, now()); 

  INSERT INTO detalle_compra(producto_id, compra_id, cantidad)
  VALUES(8,44,3); 
  UPDATE producto SET stock = stock - 3 WHERE id = 8;

--Tabla productos 4: Post transaccion 3.
SELECT * FROM producto;

--ERROR:  new row for relation "producto" violates check constraint "stock_valido" DETAIL:  Failing row contains (8, producto8, -3, 8923).

--ROLLBACK.
