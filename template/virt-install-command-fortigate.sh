# Use official built qcow2 to install the Fortigate vm
sudo virt-install \
  --check path_in_use=off \
  --name=fortigate \
  --description='FortiGate VM' \
  --ram=2048 \
  --vcpus=1 \
  --disk path=/var/lib/libvirt/images/fortios.qcow2,format=qcow2,size=10 \
  --graphics vnc,port=5903 \
  --import

