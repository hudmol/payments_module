ArchivesSpace Payments Module
=============================

Getting started
---------------

Unzip the latest release of the payments module plugin to your
ArchivesSpace plugins directory:

     $ cd /path/to/archivesspace/plugins
     $ unzip payments_module.zip -d payments_module

Enable the plugin by editing your ArchivesSpace configuration file
(`config/config.rb`):

     AppConfig[:plugins] = ['other_plugin', 'payments_module']

(Make sure you uncomment this line (i.e., remove the leading '#' if present))

See also:

  https://github.com/archivesspace/archivesspace/blob/master/plugins/README.md

You will need to shut down ArchivesSpace and migrate the database:

     $ cd /path/to/archivesspace
     $ scripts/setup-database.sh

This will create the tables required by the payments module, and will
optionally pre-populate the system from a file of fund codes.  To do
this, you will need to provide a TSV (tab-delimited) file of the form:

     fund_code_1 [tab] description_of_fund_code_1
     fund_code_2 [tab] description_of_fund_code_2
     fund_code_3 [tab] description_of_fund_code_3

The `setup-database` script will prompt you to enter the full path to
this file.

See also:

  https://github.com/archivesspace/archivesspace/blob/master/UPGRADING.md
