#!/bin/bash
# Inputs for DB2 configuration
HOSTNAME=$(uname -n)
read -e -p "TSM Servername in short form (example S-TSM511)> " SERVERNAME
read -e -p "TCPPort> " TCPPORT
read -e -p "Registred node names (separated by blanks 'WITHOUT' preceding hostname)> " NODENAME
for i in $NODENAME
do
NODE=$i
# Create opt files
cat > /var/opt/tsm/$NODE.opt << End-of-message
SErvername                ${SERVERNAME}_$NODE
  DATEFormat              1
  NUMBERFormat            1
  SUBDIR                  YES
  NFSTimeout              60
End-of-message

# Create conf files
cat > /var/opt/tsm/$NODE.conf << End-of-message
export MGMT="G_DU_Y07"
export MGMT_DUPL="G_DU_Y07"
export SESS_DISK=2
export SESS_TAPE=2
export KEEP_HIST_FILE=2570
End-of-message

# Update dsm.sys file
cat >> /var/opt/tsm/dsm.sys << End-of-message
SErvername                ${SERVERNAME}_$NODE
  NODEName                ${HOSTNAME}_$NODE
  TCPPort                 $TCPPORT
  TCPServeraddress        $SERVERNAME.sma.cmsalz.ibm.allianz
  PASSWORDaccess          generate
  PASSWORDdir             /var/opt/tsm/security/${HOSTNAME}_$i/
  ERRORLOGName            /var/opt/log/tsm/dsmerror${HOSTNAME}_$NODE.log
  ERRORLOGRET             10
  NRTABLEPath             /var/opt/tsm/nrtable/${HOSTNAME}_$NODE
 COMMmethod              TCPip
  RESOURceutilization     2
  MAKESPARSE              NO
  TCPBuffsize             32
  TCPWindowsize           63
  TCPNODELAY              YES
  COMMRESTARTInterval     15
  COMPRESSION             OFF
  TXNByte                 25600

End-of-message
mkdir -p /var/opt/tsm/security/${HOSTNAME}_$NODE
mkdir -p /var/opt/tsm/nrtable/${HOSTNAME}_$NODE
done
