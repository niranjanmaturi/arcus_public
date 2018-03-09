UPDATE mysql.user SET ssl_type = 'any' WHERE ssl_type = '';
FLUSH PRIVILEGES;
