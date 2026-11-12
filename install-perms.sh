#!/bin/bash

#
# Set file permissions
#
# set file ownership for ckan files
chown ckan:ckan -R ${APP_ROOT}/ckan
if [[ $? -eq 0 ]]; then
    printf "${Green}${INDENT}${INDENT}Set ckan ownership to ckan:ckan: OK${NC}${EOL}"
else
    printf "${Red}${INDENT}${INDENT}Set ckan ownership to ckan:ckan: FAIL${NC}${EOL}"
fi

# set file ownership for ckan static files
chown ckan:ckan -R ${APP_ROOT}/ckan/static_files
if [[ $? -eq 0 ]]; then
    printf "${Green}${INDENT}${INDENT}Set ckan/static_files ownership to ckan:ckan: OK${NC}${EOL}"
else
    printf "${Red}${INDENT}${INDENT}Set ckan/static_files ownership to ckan:ckan: FAIL${NC}${EOL}"
fi

# initialize databases
ckan -c ${APP_ROOT}/ckan/ckan.ini db init

# initialize validation tables
ckan -c ${APP_ROOT}/ckan/ckan.ini validation init-db

# set database permissions
ckan -c ${APP_ROOT}/ckan/ckan.ini datastore set-permissions | psql -U homestead --set ON_ERROR_STOP=1

# END
# Set file permissions
# END
