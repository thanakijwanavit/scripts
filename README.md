# scripts
## scripts for convinience made by nic:


## scripts included as follows

### mount_windows_on_linuxvm.sh 
-this is used to mount file from windows master to ubuntu18 virtual machine
-the permission is set for user as 1000 and group 1000
-must run with sudo permission

#### Example Usage
```
sudo bash mount_windows_on_linuxvm.sh
```

### unlock_linux_screen.sh

exports display to the default display (0) and break the login session and the screen server

### putincommandlist.sh

makes a symlink to the program you called in the default bin

#### Usage:
```
putincommandlist.sh <script> <symlink>
```

#### Example Usage:

```
putimcommandlist.sh unlock_linux_screen.sh unlock

```
