
# Partition, format, and mount ebs volume

> Prerequisites: you already need to create and attached an EBS volume to your EC2 instance, here’s a step-by-step guide to partition, format, and mount it, so it becomes usable.

1. Mounting a fresh volume
2. Mounting a volume which was created from backup snapshot.

## Mounting a fresh volume
⸻

🔍 Step 1: Identify the new volume

Run:
```sh
lsblk
```
You’ll see something like:
```
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0  10G  0 disk
└─xvda1 202:1    0  10G  0 part /
xvdf    202:80   0  20G  0 disk  <-- This is the new volume (likely)
```
Let’s assume the new volume is /dev/xvdf (adjust as needed).

⸻

🧱 Step 2: Partition the volume (if needed)

Use fdisk to create a new partition:
```sh
sudo fdisk /dev/xvdf
```
Then follow the prompts:
1. Press n → New partition
2. Press p → Primary
3. Press 1 → Partition number
4. Press Enter → Accept default for first sector
5. Press Enter → Accept default for last sector (use full disk)
6. Press w → Write changes and exit

Now run lsblk again, and you’ll see something like:
```
xvdf    202:80   0  20G  0 disk
└─xvdf1 202:81   0  20G  0 part
```


⸻

🗂️ Step 3: Format the partition with a file system

Format with ext4 (most common):
```sh
sudo mkfs.ext4 /dev/xvdf1
```


⸻

📁 Step 4: Mount the volume

Create a mount point and mount it:
```sh
sudo mkdir /mnt/mydata
sudo mount /dev/xvdf1 /mnt/mydata
```
Now the volume is usable at /mnt/mydata.

⸻

🔄 Step 5: Make it mount automatically on reboot

Edit /etc/fstab:
```sh
sudo nano /etc/fstab
```
Add this line at the end:
```
/dev/xvdf1  /mnt/mydata  ext4  defaults,nofail  0  2
```
Use nofail to prevent boot issues if the volume is not available.

⸻

✅ Done! You can now use the volume at /mnt/mydata.

⸻⸻


## Mounting a volume which was created from backup snapshot.

> When you create a volume from a snapshot in AWS, it often already contains a partition table and a filesystem (like ext4 or xfs), especially if the snapshot was taken from a previously used volume.

So, you don’t need to partition or format it again—you just need to identify the partition and mount it.

⸻

✅ Steps to Mount a Restored EBS Volume (From Snapshot)

🔍 1. Identify the device

Run:
```sh
lsblk
```
Example output:
```
NAME    MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
xvda    202:0    0  10G  0 disk /
xvdf    202:80   0  20G  0 disk 
└─xvdf1 202:81   0  20G  0 part  <-- Likely the partition from the snapshot
```
If /dev/xvdf1 exists, it’s probably ready to mount.

⸻

🗂️ 2. Mount the partition

Create a mount point (if needed):
```sh
sudo mkdir /mnt/restore
```
Mount the partition:
```sh
sudo mount /dev/xvdf1 /mnt/restore
```
Now check:
```sh
df -h /mnt/restore
```

🔄 3: Make it mount automatically on reboot

Edit /etc/fstab:
```sh
sudo nano /etc/fstab
```
Add this line at the end:
```
/dev/xvdf1  /mnt/restore  ext4  defaults,nofail  0  2
```
Use nofail to prevent boot issues if the volume is not available.

⸻

✅ Done! You can now use the volume at /mnt/restore.

⸻

❗ If there’s no partition (just the disk)

Sometimes snapshots are made from single-partition volumes (i.e., no partition table). Then you mount the whole device:

sudo mount /dev/xvdf /mnt/restore

If that works and ls /mnt/restore shows content — you’re good.

