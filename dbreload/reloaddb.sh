DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PHP=/usr/bin/php5;
usuario="root";
clave="root";
dbname="ojs30";
host="localhost";
cd $DIR
echo "Borrando la base"
mysqladmin -f drop $dbname -u$usuario -p$clave -h$host
echo "Creando la base"
mysqladmin create $dbname -u$usuario -p$clave -h$host
echo "Cargando la base"
mysql -u$usuario -p$clave -h$host $dbname < ./db.sql
echo "Ejecutando extraqueries.sql"
mysql -u$usuario -p$clave -h$host $dbname < ./extraqueries.sql
echo "Ejecutando collation.py"
python ./collation.py $usuario $clave $dbname $host
echo "empieza la migracion!"
$PHP ../tools/upgrade.php upgrade
echo "Ejecutando postqueries.sql"
mysql -u$usuario -p$clave -h$host $dbname < ./postqueries.sql
echo "Ejecutando pdf.py"
python ./pdf.py $usuario $clave $dbname $host
echo "Arreglo para el buscador public"
$PHP ../tools/rebuildSearchIndex.php
echo "Fin de la migracion"

