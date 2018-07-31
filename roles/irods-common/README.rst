$irods-common
=============

The $irods-common Ansible role provides functionality shared between other irods roles.
In general, this role is not assigned explicitly but through a dependency in an irods role.

Features
--------

- Defines expected/supported target OS type and version
- Verifies target OS and aborts th eplay if it does not match
- Installs general purpose packages
  - python-pip
  - pexpect (pip install)

Installation
------------

Install $project by running:

    install project

Configuration
-------------

The following variables are defined:

- IRODS_TARGET_OS_DISTRIBUTION: Ubuntu
- IRODS_TARGET_OS_VERSION: 14

