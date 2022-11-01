#!/bin/bash

# initiate python3 venv
python3 -m venv ${APP_ROOT}/ckan/registry
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
pip install -e 'git+https://git@github.com/JVickery-TBS/ckan.git#egg=ckan' -r 'https://raw.githubusercontent.com/JVickery-TBS/ckan/master/requirements.txt'
# install xloader
pip install -e 'git+https://git@github.com/ckan/ckanext-xloader.git#egg=ckanext-xloader' -r 'https://raw.githubusercontent.com/ckan/ckanext-xloader/master/requirements.txt' -r 'https://raw.githubusercontent.com/ckan/ckanext-xloader/master/dev-requirements.txt'
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

# database stuffs
ckan db init
ckan datastore set-permissions | psql -U homestead --set ON_ERROR_STOP=1

# create sysadmin user
ckan sysadmin add admin_local password=12345678 email=temp+admin@tbs-sct.gc.ca

# create normal user
ckan user add user_local password=12345678 email=temp+user@tbs-sct.gc.ca

# deactivate venv
deactivate
# copy who.ini
cp ${APP_ROOT}/ckan/${CKAN_ROLE}/src/ckan/who.ini ${APP_ROOT}/ckan/${CKAN_ROLE}/who.ini
# copy local ini file
cp ${APP_ROOT}/${CKAN_ROLE}.ini ${APP_ROOT}/ckan/${CKAN_ROLE}/${CKAN_ROLE}.ini
# download license file
cp ${APP_ROOT}/licenses.json ${APP_ROOT}/ckan/${CKAN_ROLE}/licenses.json
# set ownership
chown ckan:ckan -R ${APP_ROOT}/ckan