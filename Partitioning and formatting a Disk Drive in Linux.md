

## For SDA

```
lsblk

sudo fdisk /dev/sdb
```
- d and 2 times enter button

```
sudo mkfs -t ext4 /dev/sdb2
sudo mount /dev/sdb2 /home/my_drive
```

## For SDB

```
lsblk

sudo fdisk /dev/sda
```
- d and 2 times enter button

```
sudo mkfs -t ext4 /dev/sda2
sudo mount /dev/sda2 /home/my_drive

```

