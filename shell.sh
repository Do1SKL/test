sudo mkdir /home/dks384/shell-aprs

sudo cat > /lib/systemd/system/aprsb1.service <<- "EOF"
[Unit]
Description=APRS BEACOM1
After=syslog.target network.target

[Service]
User=root
Type=simple
Restart=always
RestartSec=3
StandardOutput=null
ExecStartPre=/bin/sh -c 'until ping -c1 noip.com; do sleep 1; done;'
ExecStart=/home/dks384/shell-aprs/bcom1.sh

[Install]
WantedBy=multi-user.target

EOF
#
sudo cat > /home/dks384/shell-aprs/bcom1.sh <<- "EOF"
#!/bin/bash
###### shellbeacon 1.0 A simple SHELL APRS Auto Beacon by WA1GOV
###### Works with Linux & Windows/Cygwin with netcat package installed
######
## Change the following variables to select your call, password, locaton etc.

callsign="DKSNOD" # Change this to your callsign-ssid
password="45680" # See http://apps.magicbug.co.uk/passcode/
position="!5428.90N/00905.14En" # See position report below
serverHost="cbaprs.dyndns.org" # See http://www.aprs2.net/APRServe2.txt
comment="CB-APRS BEACON 27.235 Mhz, Packet Radio Node by DKSNOD"
"

serverPort=14580 # Definable Filter Port
delay=1800 # default 30 minutes
address="${callsign}>APHP01,TCPIP:"

# POSITION REPORT: The first character determines the position report format
#          !4151.29N/07100.40W-
# A ! indicates that there is no APRS messaging capability
#
# The last character determines the icon to be used
#          !4151.29N/07100.40W-
# A dash will display a house icon
# Find your Lat/Long from your mailing address at the link below
# http://stevemorse.org/jcal/latlon.php
# Enter your callsign-ssid on https://aprs.fi/ to check your location

login="user $callsign pass $password vers ShellBeacon emqTE1 1.0"
packet="${address}${position}${comment}"
echo "$packet" # prints the packet being sent
echo "${#comment}" # prints the length of the comment part of the packet

while true
do
#### use here-document to feed packets into netcat
	nc -C $serverHost $serverPort -q 10 <<-END
	$login
	$packet
	END
	if [ "$1" = "1" ]
	then 
	    exit
	fi
	sleep $delay
done
EOF
#
cp /lib/systemd/system/aprsb1.service /lib/systemd/system/aprsb2.service
cp /lib/systemd/system/aprsb1.service /lib/systemd/system/aprsb3.service
cp /lib/systemd/system/aprsb1.service /lib/systemd/system/aprsb4.service

cp /opt/shell-aprs/bcom1.sh /home/dks384/shell-aprs/bcom2.sh
cp /opt/shell-aprs/bcom1.sh /home/dks384/shell-aprs/bcom3.sh
cp /opt/shell-aprs/bcom1.sh /home/dks384/shell-aprs/bcom4.sh

sudo sed -i "s/BEACOM1/BEACOM2/g"  /lib/systemd/system/aprsb2.service
sudo sed -i "s/BEACOM1/BEACOM3/g"  /lib/systemd/system/aprsb3.service
sudo sed -i "s/BEACOM1/BEACOM4/g"  /lib/systemd/system/aprsb4.service

sudo sed -i "s/bcom1/bcom2/g"  /lib/systemd/system/aprsb2.service
sudo sed -i "s/bcom1/bcom3/g"  /lib/systemd/system/aprsb3.service
sudo sed -i "s/bcom1/bcom4/g"  /lib/systemd/system/aprsb4.service

sudo sed -i "s/APRS BEACON emq-TE1/APRS BEACON-1 emq-TE1/g"   /opt/shell-aprs/bcom1.sh
sudo sed -i "s/APRS BEACON emq-TE1/APRS BEACON-2 emq-TE1/g"   /opt/shell-aprs/bcom2.sh
sudo sed -i "s/APRS BEACON emq-TE1/APRS BEACON-3 emq-TE1/g"   /opt/shell-aprs/bcom3.sh
sudo sed -i "s/APRS BEACON emq-TE1/APRS BEACON-4 emq-TE1/g"   /opt/shell-aprs/bcom4.sh

systemctl daemon-reload
sudo chmod +x /home/dks384/shell-aprs/*

