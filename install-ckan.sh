#!/bin/bash

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
# update certifi
# install forked ckan core
pip install -e 'git+https://github.com/JVickery-TBS/ckan.git#egg=ckan' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckan/master/requirements.txt' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckan/master/dev-requirements.txt'
# install xloader
pip install -e 'git+https://github.com/ckan/ckanext-xloader.git#egg=ckanext-xloader' -r 'https://raw.githubusercontent.com/ckan/ckanext-xloader/master/requirements.txt' -r 'https://raw.githubusercontent.com/ckan/ckanext-xloader/master/dev-requirements.txt'
# install scheming
pip install -e 'git+https://github.com/ckan/ckanext-scheming.git#egg=ckanext-scheming' -r 'https://raw.githubusercontent.com/ckan/ckanext-scheming/master/test-requirements.txt'
# install forked fluent
pip install -e 'git+https://github.com/JVickery-TBS/ckanext-fluent.git#egg=ckanext-fluent' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckanext-fluent/master/dev-requirements.txt' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckanext-fluent/master/requirements.txt'
# install forked dcat
pip install -e 'git+https://github.com/JVickery-TBS/ckanext-dcat.git#egg=ckanext-dcat' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckanext-dcat/master/dev-requirements.txt' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckanext-dcat/master/requirements.txt'
# install dev extension
pip install -e 'git+https://github.com/JVickery-TBS/ckanext-development.git#egg=ckanext-development' -r 'https://github.com/JVickery-TBS/ckanext-development/edit/master/requirements.txt' -r 'https://github.com/JVickery-TBS/ckanext-development/edit/master/dev-requirements.txt'
# install flask admin
pip install Flask-Admin
# install flask login
pip install Flask-Login
# install flask sql alchemy
pip install Flask-SQLAlchemy
# install toolbar
pip install flask_debugtoolbar
# install request with security modules
pip install requests[security]==2.26.0
# install responses
pip install responses
# install uwsgi
pip install uwsgi
# install paster
pip install paster

# pytests stuffs
pip install beautifulsoup4==4.10.0
pip install factory-boy==3.2.1
pip install freezegun==1.2.1
pip install pytest==7.1.1
pip install pytest-cov==3.0.0
pip install pytest-factoryboy==2.1.0
pip install pytest-freezegun==0.4.2
pip install pytest-rerunfailures==10.2
pip install pytest-split==0.7.0

# correct wekzeug
pip install werkzeug==2.1.2
# correct flask
pip install flask==2.1.3

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
