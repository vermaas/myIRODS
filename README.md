# myIRODS
A Vagrant/Ansible setup that creates an ALTA iRODS client in a Virtual Machine.

Extra dependencies:
The default VM size is 40 GB, which is just too small to download a MS.
Vagrant can enlarge this, to 100 GB in this case, but it needs plugin installed from the commandline first:

     > vagrant plugin install vagrant-disksize

Create VM's
-

     > vagrant up

Login
- 
     > vagrant ssh irods-vm

or

     > ssh vagrant@192.16.13.13 (password vagrant)

Initialize
-
     > source ~/alta-client/.env/bin/activate   
     > iinit (you need the irods password for the user datawriter for this).

Get Data
-

     > iget /altaZone/home/apertif_main/early_results/m51/cont/WSRTA180223003_B000_IMAGE.jpg

<p align="center">
  <img src="https://github.com/vermaas/myIRODS/blob/master/repository/my_data/WSRTA180223003_B000_IMAGE.jpg"/>
</p>
