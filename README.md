# myIRODS
A Vagrant/Ansible setup that creates an ALTA iRODS client in a Virtual Machine.

Extra dependencies:
The default VM size is 40 GB, which is just too small to download a MS.
Vagrant can enlarge this, to 100 GB in this case, but it needs plugin installed from the commandline first:

``> vagrant plugin install vagrant-disksize``

``> vagrant up``