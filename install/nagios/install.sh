#!/bin/sh
case $2 in
   server)
		 #echo "server"
	   /bin/sh monitor.sh
    ;;
   client)
		 echo "client"
		#source client.sh
    ;;
   *)
    echo 'Pls specify the role, server|client'
    ;;
esac
	


