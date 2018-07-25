## Add Swap File on Ubuntu

```
fallocate -l 1G /swap.img
chmod 600 /swap.img
mkswap /swap.img


swapon /swap.img
```

## Check Information

```
swapon -s

free -h
```

https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-14-04
