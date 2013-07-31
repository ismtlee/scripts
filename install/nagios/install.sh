#!/bin/sh
case $2 in
   server)
		 echo "server"
		#source server.sh
    ;;
   client)
		 echo "client"
		#source client.sh
    ;;
   *)
    echo 'Pls specify the role, server|client'
    ;;
esac
	


