
#!/bin/bash
#
# Configuration files are located in the template directories.
#
# Usage example:
# ./cloudmonkey.sh http://o.auroraobjects.eu/{bucket}/{template}.qcow2 templates/{template}/cloudmonkey.conf
#

url=$1
configfile=$2

exitwitherror() {
  echo -e "\n$1\n"
  exit 1
}

[[ -z "${configfile}" ]] && {
  exitwitherror "Usage: $0 <url> <configfile>"
}

[[ ! -f "${configfile}" ]] && {
  exitwitherror "Config file does not exist"
}

. ${configfile}

echo "Adding ${name} template"
added=$(cloudmonkey register template name="${name}" displaytext="${displaytext}" isextractable=${extractable} isfeatured=${featured} ispublic=${public} passwordenabled=${passwordenabled} ostypeid=${ostypeid} format=${format} hypervisor=${hypervisor} zoneid=${zoneid} url=${url} | awk '/^id =/ {print $3}')

echo "Adding tags to template"
tags=$(cloudmonkey create tags resourcetype=template resourceids=$added tags[0].key=oscategory tags[0].value=$oscategory tags[1].key=osversion tags[1].value=$osversion | awk '/^id =/ {print $3}')

echo "Template has been added with id ${added}"
