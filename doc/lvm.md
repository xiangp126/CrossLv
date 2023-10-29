### Extend a Logical Volume (LV) in Linux without losing data
Say if the client name is `client2`. Please follow these steps:

Highly recommend to back up the client2 domain before you start.

1. **Resize the Disk Image**:
   - On the host machine, shut down the client2 domain:
     ```bash
     $ sudo virsh shutdown client2
     ```

   - Find the disk image file:
     ```bash
     $ sudo virsh domblklist client2
     Target     Source
     ------------------------------------------------
     vda        /usr/local/vms/client2.qcow2
     ```
     Here, the disk image file is `/usr/local/vms/client2.qcow2`.

   - Resize the disk image by adding 10GB:
     ```bash
     $ sudo qemu-img resize /usr/local/vms/client2.qcow2 +10G
     ```

   - Start the client2 domain again:
     ```bash
     $ sudo virsh start client2
     ```

2. **Partition the New Space**:
   - Log in to the client2 domain:
     ```bash
     $ sudo virsh console client2
     ```
     or if you can ssh to the client2 directly, then:
     ```bash
     $ ssh corsair@client2
     ```

   - Use `sudo fdisk /dev/vda` to create a new partition:
     - Enter `p` to print the current partition table.
     - Enter `n` for a new partition.
     - Choose the default partition number (4).
     - Set the first sector to the default value.
     - Set the last sector to the default value to use the entire space.

   - Write the changes and exit by typing `w`.

3. **Create a Physical Volume (PV)**:
   - List the existing physical volumes:
     ```bash
     corsair@client2:~$ sudo pvdisplay
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
     Here, the existing physical volume is `/dev/vda3`.
   - Initialize the unused partition as a NEW physical volume for LVM:
     ```bash
     corsair@client2:~$ sudo pvcreate /dev/vda4
     ```

4. **Extend the Volume Group (VG)**:
   - List the existing volume groups:
     ```bash
     corsair@client2:~$ sudo vgdisplay
     --- Volume group ---
     VG Name               ubuntu-vg
     System ID
     Format                lvm2
     Metadata Areas        1
     Metadata Sequence No  2
     VG Access             read/write
     VG Status             resizable
     MAX LV                0
     Cur LV                1
     Open LV               1
     Max PV                0
     Cur PV                1
     Act PV                1
     VG Size               <8.25 GiB
     PE Size               4.00 MiB
     Total PE              2111
     Alloc PE / Size       2111 / <8.25 GiB
     Free  PE / Size       0 / 0
     VG UUID               1qyZo0-VJnc-qvEn-xIaH-3K4C-3fHU-LNB2Bo
     ```
     Here, the existing volume group is `ubuntu-vg`.
   - Add the new physical volume to the existing volume group "ubuntu-vg":
     ```bash
     corsair@client2:~$ sudo vgextend ubuntu-vg /dev/vda4
     ```

5. **Extend the Logical Volume (LV)**:
   - List the existing logical volumes:
     ```bash
     corsair@client2:~$ sudo lvdisplay
     --- Logical volume ---
     LV Path                /dev/ubuntu-vg/ubuntu-lv
     LV Name                ubuntu-lv
     VG Name                ubuntu-vg
     LV UUID                SwJfgg-7kTi-IKg9-tZjo-dflY-W2g4-44iHJM
     LV Write Access        read/write
     LV Creation host, time ubuntu-server, 2023-07-16 11:54:51 -0700
     LV Status              available
     # open                 1
     LV Size                <8.25 GiB
     Current LE             2111
     Segments               1
     Allocation             inherit
     Read ahead sectors     auto
     - currently set to     256
     Block device           253:0
     ```
     Here, the existing logical volume is `ubuntu-lv` and the path is `/dev/mapper/ubuntu--vg-ubuntu--lv`.
   - Extend the logical volume to use the newly added space (100%FREE):
     ```bash
     corsair@client2:~$ sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
     ```

6. **Resize the Filesystem**:
   - Resize the filesystem to use the new space.
     ```bash
     corsair@client2:~$ sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv

     resize2fs 1.45.5 (07-Jan-2020)
     Filesystem at /dev/mapper/ubuntu--vg-ubuntu--lv is mounted on /; on-line resizing required
     old_desc_blocks = 2, new_desc_blocks = 3
     The filesystem on /dev/mapper/ubuntu--vg-ubuntu--lv is now 4782080 (4k) blocks long.
     ```

7. **Verify the Expansion**:
   - Confirm that the new space is available by running `df -h`:
     ```bash
     corsair@client2:~$ df -h
     Filesystem                         Size  Used Avail Use% Mounted on
     udev                               941M     0  941M   0% /dev
     tmpfs                              198M  1.4M  196M   1% /run
     /dev/mapper/ubuntu--vg-ubuntu--lv   18G  6.9G   11G  41% /
     tmpfs                              986M     0  986M   0% /dev/shm
     tmpfs                              5.0M     0  5.0M   0% /run/lock
     tmpfs                              986M     0  986M   0% /sys/fs/cgroup
     /dev/loop0                          64M   64M     0 100% /snap/core20/2015
     /dev/vda2                          1.7G  209M  1.4G  13% /boot
     /dev/loop2                          41M   41M     0 100% /snap/snapd/20290
     /dev/loop1                          64M   64M     0 100% /snap/core20/1974
     /dev/loop4                          41M   41M     0 100% /snap/snapd/20092
     /dev/loop3                          92M   92M     0 100% /snap/lxd/24061
     tmpfs                              198M   36K  198M   1% /run/user/123
     tmpfs                              198M  4.0K  198M   1% /run/user/1000
     ```

Done!
