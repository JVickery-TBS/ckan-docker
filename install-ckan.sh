#!/bin/bash

doInstall='false'

read -r -p $'\n\n\033[0;31m    Are you sure you want delete the\033[1m existing CKAN environment\033[0m\033[0;31m and install a fresh copy? [y/N]:\033[0;0m    ' response

    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then

        doInstall='true'

    else

        doInstall='false'

    fi

if [[ $doInstall == "true" ]]; then

  # nuke existing install
  rm -rf ${APP_ROOT}/ckan/registry/*
  rm -rf ${APP_ROOT}/ckan/registry/.??*

  # initiate python3 venv
  python3 -m venv ${APP_ROOT}/ckan/registry
  # copy the config file
  cp ${APP_ROOT}/registry.ini ${APP_ROOT}/ckan/registry/registry.ini
  cp ${APP_ROOT}/registry_test.ini ${APP_ROOT}/ckan/registry/test.ini
  # set ownership
  chown ckan:ckan -R ${APP_ROOT}/ckan
  # activate venv
  . ${APP_ROOT}/ckan/registry/bin/activate
  # install setuptools
  pip install setuptools==44.1.0
  # update pip
  pip install --upgrade pip
  # install wheel
  pip install wheel
  # install forked ckan core
  pip install -e 'git+https://github.com/JVickery-TBS/ckan.git#egg=ckan' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckan/master/requirements.txt' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckan/master/dev-requirements.txt'
  # install forked xloader
  pip install -e 'git+https://github.com/JVickery-TBS/ckanext-xloader.git#egg=ckanext-xloader' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckanext-xloader/master/requirements.txt' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckanext-xloader/master/dev-requirements.txt'
  # install scheming
  pip install -e 'git+https://github.com/JVickery-TBS/ckanext-scheming.git#egg=ckanext-scheming' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckanext-scheming/master/test-requirements.txt'
  # install forked fluent
  pip install -e 'git+https://github.com/JVickery-TBS/ckanext-fluent.git#egg=ckanext-fluent' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckanext-fluent/master/dev-requirements.txt' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckanext-fluent/master/requirements.txt'
  # install forked dcat
  pip install -e 'git+https://github.com/JVickery-TBS/ckanext-dcat.git#egg=ckanext-dcat' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckanext-dcat/master/dev-requirements.txt' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckanext-dcat/master/requirements.txt'
  # install forked cloudstorage
  pip install -e 'git+https://github.com/JVickery-TBS/ckanext-cloudstorage.git#egg=ckanext-cloudstorage' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckanext-cloudstorage/master/requirements.txt'
  # install forked validation
  pip install -e 'git+https://github.com/JVickery-TBS/ckanext-validation.git#egg=ckanext-validation' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckanext-validation/master/requirements.txt' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckanext-validation/master/dev-requirements.txt'
  # install forked ckanapi
  pip install -e 'git+https://github.com/JVickery-TBS/ckanapi.git#egg=ckanapi' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckanapi/master/requirements.txt'
  # install forked security
  pip install -e 'git+https://github.com/JVickery-TBS/ckanext-security.git#egg=ckanext-security' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckanext-security/master/requirements.txt'
  # install dev extension
  pip install -e 'git+https://github.com/JVickery-TBS/ckanext-development.git#egg=ckanext-development' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckanext-development/master/requirements.txt' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckanext-development/master/dev-requirements.txt'
  # install dev theme extension
  pip install -e 'git+https://github.com/JVickery-TBS/ckanext-dev-theme.git#egg=ckanext-dev-theme' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckanext-dev-theme/master/requirements.txt' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckanext-dev-theme/master/dev-requirements.txt'
  # install gc notify extension
  pip install -e 'git+https://github.com/open-data/ckanext-gcnotify.git@develop#egg=ckanext-gcnotify' -r 'https://raw.githubusercontent.com/open-data/ckanext-gcnotify/develop/requirements.txt'

  # re-install ckan requirements
  pip install --force-reinstall -r 'https://raw.githubusercontent.com/JVickery-TBS/ckan/master/requirements.txt' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckan/master/dev-requirements.txt'
  # run ckan setup
  cd ${APP_ROOT}/ckan/registry/src/ckan
  python setup.py develop
  cd ${APP_ROOT}

  # re-run ckan setup.py
  cd ${APP_ROOT}/ckan/registry/src/ckan
  python setup.py develop
  cd ${APP_ROOT}

  # copy the config file
  cp ${APP_ROOT}/registry.ini ${APP_ROOT}/ckan/registry/registry.ini
  cp ${APP_ROOT}/registry_test.ini ${APP_ROOT}/ckan/registry/test.ini

  # make build directory
  mkdir -p /srv/app/ckan/registry/src/ckan/build

  # set ownership
  chown ckan:ckan -R ${APP_ROOT}/ckan

  # database stuffs
  ckan -c ${APP_ROOT}/ckan/registry/registry.ini db init
  ckan -c ${APP_ROOT}/ckan/registry/registry.ini datastore set-permissions | psql -U homestead --set ON_ERROR_STOP=1
  ckan -c ${APP_ROOT}/ckan/registry/test.ini db init
  ckan -c ${APP_ROOT}/ckan/registry/test.ini datastore set-permissions | psql -U homestead --set ON_ERROR_STOP=1

  # create sysadmin user
  ckan -c ${APP_ROOT}/ckan/registry/registry.ini user add admin_local password=12345678 email=temp+admin@tbs-sct.gc.ca
  ckan -c ${APP_ROOT}/ckan/registry/registry.ini sysadmin add admin_local

  # create normal user
  ckan -c ${APP_ROOT}/ckan/registry/registry.ini user add user_local password=12345678 email=temp+user@tbs-sct.gc.ca

  # deactivate venv
  deactivate
  # copy who.ini
  cp ${APP_ROOT}/ckan/registry/src/ckan/who.ini ${APP_ROOT}/ckan/registry/who.ini
  # copy local ini file
  cp ${APP_ROOT}/registry.ini ${APP_ROOT}/ckan/registry/registry.ini
  cp ${APP_ROOT}/registry_test.ini ${APP_ROOT}/ckan/registry/test.ini
  # download license file
  cp ${APP_ROOT}/licenses.json ${APP_ROOT}/ckan/registry/licenses.json
  # set ownership
  chown ckan:ckan -R ${APP_ROOT}/ckan

fi
