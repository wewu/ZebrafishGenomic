# Be sure to restart your web server when you modify this file.

RAILS_GEM_VERSION = '2.0.2' 
require File.join(File.dirname(__FILE__), 'boot')

ENV['LD_LIBRARY_PATH'] ||= '/opt/oracle/instantclient_10_2'
ENV['ORACLE_HOME'] ||= '/opt/oracle/instantclient_10_2'
ENV['LD_LIBRARY_PATH_64'] ||= '/opt/oracle/instantclient_10_2'
ENV['LD_LIBRARY_PATH_32'] ||= '/opt/oracle/instantclient_10_2'

Rails::Initializer.run do |config|
  config.action_controller.session = { :session_key => "_zebrafish_session", :secret  => "7267b4cf8d2e3d969efe00d0508e57170bd61e466617a3ddf97aa0ae44a5" }
end

Inflector.inflections do |inflect|
  inflect.plural /^(biodatabase)$/i, '\1s'
  inflect.singular /^(biodatabase)s/i, '\1'
end

require "will_paginate"

# Include your application configuration below
GEL_MSTR_URI = '/images/master_gel.jpg'
GEL_3D_URI = '/images/3d_small.jpg'
GEL_5D_URI = '/images/5d_small.jpg'
GEL_WIDTH = 2800
GEL_HEIGHT = 2200
