# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() {
kernel.string=Unique Kernel by shaikh lukman @ xda-developers
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=land
device.name2=Redmi 3s
device.name3=LAND
device.name4=
device.name5=
supported.sdk=27
} # end properties

# shell variables
block=/dev/block/mmcblk0p21;
is_slot_device=0;
ramdisk_compression=auto;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel file attributes
# set permissions for included ramdisk files
chmod -R 755 $ramdisk
chmod +x $ramdisk/sbin/spa


## AnyKernel install
dump_boot;

# begin ramdisk changes

# init.rc
backup_file init.rc;
grep "import /init.spectrum.rc" init.rc >/dev/null || sed -i '1,/.*import.*/s/.*import.*/import \/init.spectrum.rc\n&/' init.rc

# init.tuna.rc
backup_file init.tuna.rc;
insert_line init.tuna.rc "nodiratime barrier=0" after "mount_all /fstab.tuna" "\tmount ext4 /dev/block/platform/omap/omap_hsmmc.0/by-name/userdata /data remount nosuid nodev noatime nodiratime barrier=0";
append_file init.tuna.rc "dvbootscript" init.tuna;

# fstab.tuna
backup_file fstab.tuna;
patch_fstab fstab.tuna /system ext4 options "noatime,barrier=1" "noatime,nodiratime,barrier=0";
patch_fstab fstab.tuna /cache ext4 options "barrier=1" "barrier=0,nomblk_io_submit";
patch_fstab fstab.tuna /data ext4 options "data=ordered" "nomblk_io_submit,data=writeback";
append_file fstab.tuna "usbdisk" fstab;

# end ramdisk changes

write_boot;

## end install

# Add empty profile locations
if [ ! -d /data/media/Spectrum ]; then
  ui_print " "; ui_print "Creating /data/media/0/Spectrum...";
  mkdir /data/media/0/Spectrum; fi if [ ! -d /data/media/Spectrum/profiles ]; then
  mkdir /data/media/0/Spectrum/profiles; fi if [ ! -d /data/media/Spectrum/profiles/*.profile ]; then
  ui_print " "; ui_print "Creating empty profile files...";
  touch /data/media/0/Spectrum/profiles/balance.profile;
  touch /data/media/0/Spectrum/profiles/performance.profile;
  touch /data/media/0/Spectrum/profiles/battery.profile;
  touch /data/media/0/Spectrum/profiles/gaming.profile;
fi
