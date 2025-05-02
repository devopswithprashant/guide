
# Partition, format, and mount ebs volume

> Prerequisites: you already need to create and attached an EBS volume to your EC2 instance, here’s a step-by-step guide to partition, format, and mount it, so it becomes usable.

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
