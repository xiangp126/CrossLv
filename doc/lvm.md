## Extend a Logical Volume (LV) in Linux without losing data

**Step 1: Preparations**

Before initiating the extension process, it's essential to create a backup of your important data to ensure its safety during the procedure.

Next, we need to check the existing disk and logical volume (LV) information on the client2 machine:

```bash
corsair@client2:~$ sudo fdisk -l
```

```plaintext
Disk /dev/vda: 10 GiB, 10737418240 bytes, 20971520 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 85B00221-7A8C-4F4F-8AA7-4DE59A3E4E8F

Device       Start      End  Sectors  Size Type
/dev/vda1     2048     4095     2048    1M BIOS boot
/dev/vda2     4096  3674111  3670016  1.8G Linux filesystem
/dev/vda3  3674112 20969471 17295360  8.3G Linux filesystem
```

```bash
corsair@client2:~$ sudo pvdisplay
```

```plaintext
--- Physical volume ---
PV Name               /dev/vda3
VG Name               ubuntu-vg
PV Size               <8.25 GiB / not usable 0
Allocatable           yes (but full)
PE Size               4.00 MiB
Total PE              2111
Free PE               0
Allocated PE          2111
PV UUID               YPBQil-o0Dn-JZ7a-BGTe-nvih-NaMJ-3mEWE0
```

This command reveals the Physical Volume (PV) information associated with `/dev/mapper/ubuntu--vg-ubuntu--lv`. It's important to note that this LV is currently linked to `/dev/vda3`.

**Step 2: Shutdown the Virtual Machine**

On the host machine, we must ensure that the virtual machine (client2) is powered off. To achieve this, use the following command:

```bash
sudo virsh shutdown client2
```

This command initiates the shutdown process for the virtual machine, ensuring a safe environment for further operations.

**Step 3: Resize the Virtual Disk**

1. On the host machine, we'll resize the virtual disk (client2.qcow2) by adding 10GB to it. Execute the following command:

```bash
sudo qemu-img resize /usr/local/vms/client2.qcow2 +10G
```

This command increases the size of the virtual disk by 10GB, providing additional space for the logical volume extension.

**Step 4: Start the Virtual Machine**

1. Start the virtual machine (client2) on the host machine with the following command:

```bash
sudo virsh start client2
```

This command reboots the virtual machine, making the added disk space available for use.

**Step 5: Check the Disk Information on the Virtual Machine (client2)**

Now that the virtual machine is up and running, let's verify the disk information within the client2 environment:

```bash
sudo fdisk -l
```

This command provides comprehensive information about the existing partitions, including the newly added space from the resized virtual disk.

```plaintext
Disk /dev/vda: 20 GiB, 21474836480 bytes, 41943040 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 85B00221-7A8C-4F4F-8AA7-4DE59A3E4E8F

Device        Start      End  Sectors  Size Type
/dev/vda1      2048     4095     2048    1M BIOS boot
/dev/vda2      4096  3674111  3670016  1.8G Linux filesystem
/dev/vda3   3674112 20969471 17295360  8.3G Linux filesystem
/dev/vda4  20969472 41943006 20973535   10G Linux filesystem
```

```bash
sudo vgdisplay
```

Take note of your VG name (e.g., "ubuntu-vg") for future reference.

```plaintext
corsair@client2:~$ sudo vgdisplay
```

```plaintext
--- Volume group ---
VG Name               ubuntu-vg
...
```

```bash
sudo pvcreate /dev/vda4
```

This step initializes the newly added partition as a PV for Logical Volume Manager (LVM).

```bash
sudo pvdisplay
```

This command provides detailed information about the created PV and ensures it's correctly associated with /dev/vda4.

```plaintext
--- Physical volume ---
PV Name               /dev/vda4
VG Name               ubuntu-vg
PV Size               10 GiB / not usable 0
Allocatable           yes (but full)
PE Size               4.00 MiB
Total PE              2559
Free PE               2559
Allocated PE          0
PV UUID               [...]
```

**Step 6: Extend the Volume Group (VG)**

1. To extend the VG, add the newly created physical volume to it:

```bash
sudo vgextend ubuntu-vg /dev/vda4
```

Replace "ubuntu-vg" with your specific VG name obtained in the previous step.

```plaintext
Volume group "ubuntu-vg" successfully extended
```

**Step 7: Identify the Logical Volume (LV) Name**

1. Identify the name of your logical volume (LV) using:

```bash
sudo lvdisplay
```

In this instance, it is "ubuntu-vg/ubuntu-lv."

```plaintext
corsair@client2:~$ sudo lvdisplay
```

```plaintext
--- Logical volume ---
LV Path                /dev/ubuntu-vg/ubuntu-lv
...
```

**Step 8: Extend the Logical Volume (LV)**

1. Extend the LV to make use of all available free space with the following command:

```bash
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
```

Ensure to replace "/dev/ubuntu-vg/ubuntu-lv" with your specific LV name obtained in the previous step.

```plaintext
corsair@client2:~$ sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
```

```plaintext
Size of logical volume ubuntu-vg/ubuntu-lv changed from <8.25 GiB (2111 extents) to 18.24 GiB (4670 extents).
Logical volume ubuntu-vg/ubuntu-lv successfully resized.
```

**Step 9: Resize the Filesystem**

1. Resize

 the filesystem to use the new space. For example, if it's an ext4 filesystem, use:

```bash
sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
```

This command resizes the filesystem to make use of the added space.

**Step 10: Verify the Expansion**

1. Confirm that the new space is available by running:

```bash
df -h
```

This command shows the updated filesystem size and usage.

After completing these steps, your logical volume `/dev/mapper/ubuntu--vg-ubuntu--lv` should have been extended to include the previously unused space from `/dev/vda4`.
You can then make use of this additional space for your system.