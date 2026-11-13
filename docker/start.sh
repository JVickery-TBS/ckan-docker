#!/usr/bin/env bash

set -e

env=${DOCKER_ENV:-production}
role=${CONTAINER_ROLE:-app}
ckanRole=${CKAN_ROLE:-ckan}

Cyan='\033[0;36m'
Yellow='\033[1;33m'
Red='\033[0;31m'
Green='\033[0;32m'
NC='\033[0;0m'
EOL='\n'
BOLD='\033[1m'
HAIR='\033[0m'

printf "${Cyan}The Environment is ${BOLD}$env${HAIR}${NC}${EOL}"

printf "${Yellow}Removing XDebug${NC}${EOL}"
rm -rf /usr/local/etc/php/conf.d/{docker-php-ext-xdebug.ini,xdebug.ini}

printf "${Cyan}The role is ${BOLD}$role${HAIR}${NC}${EOL}"

if [[ "$role" = "ckan" ]]; then
#
# CKAN
#

    printf "${Cyan}The CKAN role is ${BOLD}$ckanRole${HAIR}${NC}${EOL}"

    # link ckan supervisord config
    ln -sf /etc/supervisor/conf.d-available/ckan.conf /etc/supervisor/conf.d/ckan.conf

    # create directory for python venv
    mkdir -p ${APP_ROOT}/ckan

    # create directory for ckan static files
    mkdir -p ${APP_ROOT}/ckan/static_files

    # create directories for uwsgi outputs
    mkdir -p /dev
    chown -R ckan:ckan /dev

    if [[ -d "/srv/app/ckan/src/ckan" ]]; then
        mkdir -p /srv/app/ckan/src/ckan/build;
        if [[ $? -eq 0 ]]; then
            printf "${Green}Created /srv/app/ckan/src/ckan/build${NC}${EOL}";
        else
            printf "${Red}FAILED to create /srv/app/ckan/src/ckan/build (directory may already exist)${NC}${EOL}";
        fi;
    fi;

    # copy the ckan configs
    printf "${Green}Copying the ckan configuration file to the virtual environment${NC}${EOL}"
    cp ${APP_ROOT}/ckan.ini ${APP_ROOT}/ckan/ckan.ini
    cp ${APP_ROOT}/ckan.ini ${APP_ROOT}/ckan/_vassals/ckan.ini
    cp ${APP_ROOT}/ckan_test.ini ${APP_ROOT}/ckan/test.ini

    # copy the wsgi.py files
    printf "${Green}Copying the ckan wsgi configuration file to the virtual environment${NC}${EOL}"
    cp ${APP_ROOT}/docker/config/ckan/wsgi/ckan.py ${APP_ROOT}/ckan/wsgi.py
    chown ckan:ckan ${APP_ROOT}/ckan/wsgi.py
    cp ${APP_ROOT}/docker/config/ckan/wsgi/activate_this.py ${APP_ROOT}/ckan/bin/activate_this.py
    chown ckan:ckan ${APP_ROOT}/ckan/bin/activate_this.py

    # create storage paths
    printf "${Green}Generating storage directory${NC}${EOL}"
    mkdir -p ${APP_ROOT}/ckan/storage
    chown -R ckan:ckan ${APP_ROOT}/ckan/storage

    # create cache paths
    printf "${Green}Generating cache directory${NC}${EOL}"
    mkdir -p ${APP_ROOT}/ckan/tmp
    chown -R ckan:ckan ${APP_ROOT}/ckan/tmp

    # copy licenses file
    cp ${APP_ROOT}/licenses.json ${APP_ROOT}/ckan/licenses.json

    # start supervisord service
    printf "${Green}Executing supervisord${NC}${EOL}"
    supervisord -c /etc/supervisor/supervisord.conf

# END
# CKAN
# END
elif [[ "$role" = "scheduler" ]]; then

    # link scheduler supervisord config
    ln -sf /etc/supervisor/conf.d-available/scheduler.conf /etc/supervisor/conf.d/scheduler.conf

    # start supervisord service
    printf "${Green}Executing supervisord${NC}${EOL}"
    supervisord -c /etc/supervisor/supervisord.conf

elif [[ "$role" = "queue" ]]; then

    # link queue supervisord config
    ln -sf /etc/supervisor/conf.d-available/queue.conf /etc/supervisor/conf.d/queue.conf

    # start supervisord service
    printf "${Green}Executing supervisord${NC}${EOL}"
    supervisord -c /etc/supervisor/supervisord.conf

else

    printf "${Red}Could not match the container role \"${BOLD}$role${HAIR}\"${NC}${EOL}"
    exit 1

fi
