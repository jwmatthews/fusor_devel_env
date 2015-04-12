
# Requires nested virtualization to be enabled
#  http://kashyapc.com/2012/01/14/nested-virtualization-with-kvm-intel/
#  https://github.com/torvalds/linux/blob/master/Documentation/virtual/kvm/nested-vmx.txt

DATE=`date +"%s"`
NAME="rhev_hypervisor_vm_${DATE}"
DISK_SIZE="10"
MEMORY="3072"
CPUS="1"
FUSOR_NETWORK="sat61_fusor_net"
NESTED_VIRT_KERNEL_CONFIG_FILE="/sys/module/kvm_intel/parameters/nested"



echo "Verifying expected network:"
virsh net-info ${FUSOR_NETWORK}
if [ "$?" != 0 ]; then
  echo "Unable to find network: ${FUSOR_NETWORK}"
  echo "Perhaps you want to run as 'sudo'?"
  echo "Please update and continue."
  exit 1
fi

if [ ! -f ${NESTED_VIRT_KERNEL_CONFIG_FILE} ]; then
  echo "Unable to find: ${NESTED_VIRT_KERNEL_CONFIG_FILE}"
  exit
fi

NESTED_VIRT_CONFIG_VALUE=`cat /sys/module/kvm_intel/parameters/nested`
if [ "${NESTED_VIRT_CONFIG_VALUE}" != "Y" ]; then
  echo "Please enable nested virtualization and re-run"
  echo "Perhaps try to enable nested virt with the command"
  echo "  echo  'options kvm-intel nested=1' >> /etc/modprobe.d/kvm-intel.conf"
  echo "  reboot"
  echo ""
  exit
fi


##
# We attempted to use
#   --cpu=model
# Using --cpu=model gave us an error of:
#   ERROR    unsupported configuration: host doesn't support invariant TSC
#
# To workaround this we are attempting to:
# - determine the CPU Model of the host by parsing "virsh capabilities"
# - specify the cpu model explicitly
# - disable -invtsc  (invtsc is causing the invariant TSC error)
# - enable  +vmx
#
CPU_MODEL=`python get_virsh_cpu_model.py`
CPU_FLAGS="${CPU_MODEL},+vmx"
if [ "${CPU_MODEL}" == "Haswell" ]; then
  CPU_FLAGS="${CPU_FLAGS},-invtsc"
fi
echo "Will create a nested virtualization guest using a CPU of: ${CPU_FLAGS}"

virt-install \
 -n ${NAME} \
 --description "VM for testing PXE boot" \
 --os-type=Linux \
 --os-variant=rhel6 \
 --ram=${MEMORY} \
 --vcpus=${CPUS} \
 --disk path=/var/lib/libvirt/images/${NAME}.img,bus=virtio,size=${DISK_SIZE} \
 --graphics vnc \
 --pxe \
 --network network=${FUSOR_NETWORK} \
 --cpu ${CPU_FLAGS}
