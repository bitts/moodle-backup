#!/bin/bash

# ----------------------------------------------
# Moodle Backup Create by 2º Ten Bittencourt
# Version: 1.0v
# Created: 01/07/2020
# Upgrade: 07/07/2020
# Logs do sistema gravados em  /var/logs/message
# ----------------------------------------------

datainicial=`date +%s`

logger "[BKPMDL] Inicio do backup do moodle."

#Para uso interno de controle do script
ID=$(date +"%Y-%m-%d")
MYSQL_DUMP=$(which mysqldump)

#### Inicio das variáveis do sistema ####

#pasta onde esta o sistema moodle
export MDL_FOLDER='/var/www/html/'

#pasta local onde iram ficar os arquivos de backup realizados diariamente do mysql e da moodledata / backup diário
export BKP_FOLDER_TMP='/backup/bkp/'

#Nome do arquivo onde será colocado o conteudo do backup do banco mysql, arquivo gerado será no formato .sql
export BKP_SQL_FILE=moodle-database

#nome do arquivo da compactação tar.gz onde ficara a pasta moodledata
export BKP_MDL_DATA_FILE=moodledata

#Pasta onde ficara o último backup completo / preferencialmente uma pasta montada para backups / colocar caminhos completos
export BKP_FOLDER_OFC=/backup/

#arquivo de configuração com os dados do MySQL
export MYSQL_FILE=/var/www/html/config_mysql.cnf

#arquivo onde ficara logs de erro do mysql caso ocorram
export MYSQL_LOGS_ERROR=database.err

#logs do tar.gz
export BKP_LOG_TARGZ=/backup/bkp/log_targz[${ID}].log

#Mantar os último N arquivos
export TOTAL_FILES=6
#### Fim das váriaveis do sistema ####

#verifica se pasta temporaria de criação dos arquivos de backup existe
[ ! -d "$BKP_FOLDER_TMP" ] && mkdir -p ${BKP_FOLDER_TMP} || logger "[BKPMDL] Pasta ${BKP_FOLDER_TMP} já existe."

logger "Inicio do Backup - Moodle Database"
${MYSQL_DUMP} --defaults-extra-file=${MYSQL_FILE} --log-error=${MYSQL_LOGS_ERROR} --skip-lock-tables --all-databases > ${BKP_FOLDER_TMP}${BKP_SQL_FILE}[${ID}].sql > ${BKP_LOG_TARGZ}
if [ $? -eq 0 ]
then
        logger "[BKPMDL] Backup da Base de Dados do Moodle realizado com sucesso."
else
        logger "[BKPMDL] MySQLDump encontrou um problema em sua execução, verifique-o o arquivo database.err para maiores informações."
fi


#compactando a moodledata de excluindo pastas de acordo com documentação encontrada na internet
logger "[BKPMDL] Inicio do Backup do moodledata"
tar -czf ${BKP_FOLDER_TMP}${BKP_MDL_DATA_FILE}[${ID}].tar.gz --exclude='${MDL_FOLDER}moodledata/cache' --exclude='${MDL_FOLDER}moodledata/localcache' --exclude='${MDL_FOLDER}moodledata/sessions' --exclude='${MDL_FOLDER}moodledata/temp' --exclude='${MDL_FOLDER}moodledata/trashdir' ${MDL_FOLDER}/moodledata > ${BKP_LOG_TARGZ}
if [ $? -eq 0 ]
then
        logger "[BKPMDL] Arquivos da pasta ${MDL_FOLDER}/moodledata compactados com sucesso na pasta temporaria ${BKP_FOLDER_TMP}."
else
        logger "[BKPMDL] Não foi possível compactar arquivos da pasta ${MDL_FOLDER}/moodledata na pasta temporaria ${BKP_FOLDER_TMP}. Script interrompido."
        exit 1;
fi

#verifica se a pasta do ultimo backup completo existe
if [ -d ${BKP_FOLDER_OFC} ]; then
        [ "$(ls -A ${BKP_FOLDER_OFC})" ] && rm -Rf ${BKP_FOLDER_OFC}bkp_completo_moodle*.tar.gz || logger "[BKPMDL] Pasta ${BKP_FOLDER_OFC} esta vazia."
else
        logger "[BKPMDL] Pasta ${BKP_FOLDER_OFC} não encontrada."
        mkdir -p ${BKP_FOLDER_OFC}
fi

#verifica se possui espaço em disco
FREE=$(df --output=avail -h "$BKP_FOLDER_OFC" | sed '1d;s/[^0-9]//g')
if [ $FREE -lt 50 ]
then
    	logger "[BKPMDL] Existe menos de 50Gb de espaço disponível para Backup na pasta."
fi

#backup da moodledata e do backup do mysql / backup completo
tar -czf "${BKP_FOLDER_OFC}bkp_completo_moodle[${ID}].tar.gz" ${BKP_FOLDER_TMP}*${ID}* > ${BKP_LOG_TARGZ} > ${BKP_LOG_TARGZ}
if [ $? -eq 0 ]
then
        logger "[BKPMDL] Backup completo executado com sucesso."
else
        logger "[BKPMDL] Não foi possível realizar o backup completo. Script interrompido e será finalizado."
        exit 1;
fi

#remover arquivos temporarios com mais de uma semana
find ${BKP_FOLDER_TMP}* -mtime +${TOTAL_FILES} -exec rm {} \;
if [ $? -eq 0 ]
then
        logger "[BKPMDL] Remoção de arquivos temporarios antigos executado com sucesso."
else
        logger "[BKPMDL] Não foi possível remover os arquivos temporários."
fi

logger "[BKPMDL] Fim do Backup do Moodle."

#calculo de execução do script
datafinal=`date +%s`
soma=`expr $datafinal - $datainicial`
resultado=`expr 10800 + $soma`
tempo=`date -d @$resultado +%H:%M:%S`
logger "[BKPMDL] Tempo de execução do script: $tempo ."

