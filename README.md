# moodle-backup
Script de realização de backup do Moodle

Para o funcionamento correto do Script é necessário configurar o arquivo "config_mysql.cnf" com as informações necessários para realizar a conexão com o base de dados MySQL (MariaDB).

Também é necessário parametrizar o arquivo com as informações de caminho de pastas e nome de arquivos de destino das informações.

Para acesso fácil aos logs do script, todas as entradas no arquivo /var/logs/messages possuem a tag "[BKPMDL]" para melhor filtragem das informações.
Exemplo:
> cat /var/log/messages | grep "BKPMDL"

# About
Script de Backup do Moodle para agendamento no Crontab (linux)

[![GitHub license](https://img.shields.io/apm/l/vim-mode.svg)](LICENSE)

## Credits

### Author
[Marcelo Valvassori Bittencourt (bitts)](https://github.com/bitts)

### Resultado
```
[root@moodle:~]# ls -lah /backup/
total 78G
drwxrwxrwx   3 root root   4 Jul 18 00:27 .
dr-xr-xr-x. 18 root root 266 Mai 13 10:46 ..
drwxr-xr-x   2 root root  11 Jul 17 22:01 bkp
-rw-r--r--   1 root root 78G Jul 18 01:30 bkp_completo_moodle[2020-07-17].tar.gz
[root@moodle:~]# ls -lah /backup/bkp
total 312G
drwxr-xr-x 2 root root   11 Jul 17 22:01 .
drwxrwxrwx 3 root root    4 Jul 18 00:27 ..
-rw-r--r-- 1 root root  76G Jul 15 02:47 moodledata[2020-07-14].tar.gz
-rw-r--r-- 1 root root  77G Jul 16 00:51 moodledata[2020-07-15].tar.gz
-rw-r--r-- 1 root root  77G Jul 17 00:53 moodledata[2020-07-16].tar.gz
-rw-r--r-- 1 root root  77G Jul 18 00:26 moodledata[2020-07-17].tar.gz
-rw-r--r-- 1 root root 4,8G Jul 13 22:01 moodle-database[2020-07-13].sql
-rw-r--r-- 1 root root 4,8G Jul 14 22:01 moodle-database[2020-07-14].sql
-rw-r--r-- 1 root root 4,8G Jul 15 22:01 moodle-database[2020-07-15].sql
-rw-r--r-- 1 root root 4,8G Jul 16 22:01 moodle-database[2020-07-16].sql
-rw-r--r-- 1 root root 4,9G Jul 17 22:01 moodle-database[2020-07-17].sql
```
