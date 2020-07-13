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
