# -- coding: utf-8 --

# -- CKAN 2.10 --

import os
from ckan.config.middleware import make_app
from ckan.cli import CKANConfigLoader
from logging.config import fileConfig as loggingFileConfig

if os.environ.get('CKAN_INI'):
    config_path = os.environ['CKAN_INI']
else:
    config_path = os.path.join(
        os.path.dirname(os.path.abspath(__file__)), u'registry.ini')

if not os.path.exists(config_path):
    raise RuntimeError('CKAN config file not found: {}'.format(config_path))

loggingFileConfig(config_path)
config = CKANConfigLoader(config_path).get_config()

application = make_app(config)

# -- CKAN 2.9 --

# import os
# from ckan.config.middleware import make_app
# from ckan.cli import CKANConfigLoader
# from logging.config import fileConfig as loggingFileConfig
# config_filepath = os.path.join(
#     os.path.dirname(os.path.abspath(__file__)), 'registry.ini')
# abspath = os.path.join(os.path.dirname(os.path.abspath(__file__)))
# loggingFileConfig(config_filepath)
# config = CKANConfigLoader(config_filepath).get_config()
# application = make_app(config)

# -- CKAN 2.8 --

# import os
# activate_this = os.path.join('/srv/app/ckan/registry/bin/activate_this.py')
# execfile(activate_this, dict(__file__=activate_this))

# from paste.deploy import loadapp
# config_filepath = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'registry.ini')
# from paste.script.util.logging_config import fileConfig
# fileConfig(config_filepath)
# application = loadapp('config:%s' % config_filepath)