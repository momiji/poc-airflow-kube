cat roles/$1.list | sed '/^#/d' | sed '/^\s*$/d' | while IFS=. read -r r a ; do
  echo "airflow roles add-perms '$1' -r '$r' -a '$a'"
done
