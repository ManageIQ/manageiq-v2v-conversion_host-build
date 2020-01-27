# Conversion VM

## Build steps

### Centos

1. Get Centos minimal installation image (no cloud one)

2. Create a VM locally with empty Volume and mounted installation image

3. Start it and modify boot options to use kickstart script (press Tab in boot menu and append text bellow - shortened link to this repo centos ks file)


```
ks=https://raw.githubusercontent.com/ManageIQ/manageiq-v2v-conversion_host/master/appliance/uci_image.ks
```

4. Wait until installation is done and VM reboots

5. Conversion VM is ready (default credentials: root / 123456), you can make a snapshot or upload its Volume to OpenStack


## Migration process

TODO

## Resources

https://github.com/ManageIQ/manageiq-v2v-conversion_host/

https://github.com/ManageIQ/manageiq-v2v-conversion_host-build/

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/installation_guide/sect-kickstart-syntax#sect-kickstart-commands
