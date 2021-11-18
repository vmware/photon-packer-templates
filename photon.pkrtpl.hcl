{
   "arch": "x86_64",
   "hostname":"photon-${os_packagelist}",
   "password":{
      "crypted":false,
      "text":"${ssh_password}"
   },
   "disk":"/dev/sda",
   "partitions":[
      {
         "mountpoint":"/",
         "size":0,
         "filesystem":"ext4"
      },
      {
         "mountpoint":"/boot",
         "size":128,
         "filesystem":"ext4"
      },
      {
         "mountpoint":"/root",
         "size":128,
         "filesystem":"ext4"
      },
      {
         "size":128,
         "filesystem":"swap"
      }
   ],
   "bootmode":"bios",
   "network":{
      "type":"dhcp"
   },
   "linux_flavor":"linux",
   "packagelist_file":"packages_${os_packagelist}.json",
   "postinstall":[
      "#!/bin/sh",
      "chage -I -1 -m 0 -M 99999 -E -1 ${ssh_username}",
      "sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config",
      "sed -i 's/.*MaxAuthTries.*/MaxAuthTries 10/g' /etc/ssh/sshd_config",
      "systemctl restart sshd.service"
   ]
}