#!/system/bin/sh

if [[ $PATH != *busybox:* ]]; then
  if [ -d /sbin/.magisk/busybox ]; then
    PATH=/sbin/.magisk/busybox:$PATH
  elif [ -d /sbin/.core/busybox ]; then
    PATH=/sbin/.core/busybox:$PATH
  elif which busybox > /dev/null; then
    mkdir -p -m 700 /dev/.busybox
    busybox install -s /dev/.busybox
    PATH=/dev/.busybox:$PATH
  else
    echo "(!) Install busybox binary first"
    exit 3
  fi
fi

if [ $(id -u) -ne 0 ]; then
  echo "(!) $0 must run as root (su)"
  exit 4
fi

id=acc
set -e
[ -f $PWD/${0##*/} ] || cd ${0%/*}
[ -d $id/${id}-init.sh ] && exit 0
rm -rf ${id}-*/
tar -xf ${id}*gz
export installDir0="$1"
sh ${id}-*/install-current.sh
rm -rf ${id}-*/
exit 0
