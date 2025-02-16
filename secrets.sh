echo -n "webserverSecretKey: "
python3 -c 'import secrets; print(secrets.token_hex(16))'
