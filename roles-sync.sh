install -m 0755 -d tmp

echo "Exporting roles..."
./roles-export-all.sh > tmp/roles.csv

echo "Generating roles diff..."
(
while read -r role ; do
    cat tmp/roles.csv | sed -n "/^$role|/p" | cut -d '|' -f 2- | tr '|' '.' | sort > "tmp/role-$role.csv1"
    cat roles/$role.roles | sed '/^#/d' | sed '/^\s*$/d' | sort > "tmp/role-$role.csv2"
    while IFS=. read -r r n ; do
        echo "airflow roles del-perms '$role' -a '$n' -r '$r'"
    done < <( combine "tmp/role-$role.csv1" not "tmp/role-$role.csv2" )
    while IFS=. read -r r n ; do
        echo "airflow roles add-perms '$role' -a '$n' -r '$r'"
    done < <( combine "tmp/role-$role.csv2" not "tmp/role-$role.csv1" )
done < <( ls roles | sed 's/\.roles$//' )
) > tmp/roles.sh

echo "Applying roles diff..."
./exec.sh bash -c "
set -x
$( cat tmp/roles.sh )
"
