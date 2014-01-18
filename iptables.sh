#!/bin/sh
## SCRIPT de IPTABLES - ejemplo del manual de iptables
## Ejemplo de script para firewall entre red-local e internet con DMZ
##
## Pello Xabier Altadill Izura
## www.pello.info - pello@pello.info

echo -n Aplicando Reglas de Firewall...

## FLUSH de reglas
iptables -F
iptables -X
iptables -Z
iptables -t nat -F

## Establecemos politica por defecto
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT

# Ahora hacemos enmascaramiento de la red local y de la DMZ
# para que puedan salir haca fuera
# y activamos el BIT DE FORWARDING (imprescindible!!!!!)
iptables -t nat -A POSTROUTING 	-o eth0 -j MASQUERADE
iptables -A INPUT -s 192.168.10.0/24 -i eth1 -j ACCEPT
iptables -A INPUT -s 192.168.3.0/24 -i eth2 -j ACCEPT

# Con esto permitimos hacer forward de paquetes en el firewall, o sea
# que otras máquinas puedan salir a traves del firewall.
echo "1" > /proc/sys/net/ipv4/ip_forward

## Empezamos a filtrar
## Nota: eth0 es el interfaz conectado al router y eth1 a la LAN
# Todo lo que venga por el exterior y vaya al puerto 80 lo redirigimos
# a una maquina interna
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to 192.168.3.2:80

# Los accesos de un ip determinada HTTPS se redirigen e esa
# maquina
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j DNAT --to 192.168.3.2:443

# El localhost se deja (por ejemplo conexiones locales a mysql)
/sbin/iptables -A INPUT -i lo -j ACCEPT

# Al firewall tenemos acceso desde la red local
iptables -A INPUT -s 192.168.10.0/24 -i eth1 -j ACCEPT



## Permitimos el paso de la DMZ a una BBDD de la LAN:
iptables -A FORWARD -s 192.168.3.2 -d 192.168.10.5 -p tcp --dport 5432 -j ACCEPT

iptables -A FORWARD -s 192.168.10.5 -d 192.168.3.2 -p tcp --sport 5432 -j ACCEPT

## permitimos abrir el Terminal server de la DMZ desde la LAN
iptables -A FORWARD -s 192.168.10.0/24 -d 192.168.3.2 -p tcp --sport 1024:65535 --dport 3389 -j ACCEPT

# … hay que hacerlo en uno y otro sentido …
iptables -A FORWARD -s 192.168.3.2 -d 192.168.10.0/24 -p tcp --sport 3389 --dport 1024:65535 -j ACCEPT

# … por que luego:
# Cerramos el acceso de la DMZ a la LAN
iptables -A FORWARD -s 192.168.3.0/24 -d 192.168.10.0/24 -j DROP

## Cerramos el acceso de la DMZ al propio firewall
iptables -A INPUT -s 192.168.3.0/24 -i eth2 -j ACCEPT

## Y ahora cerramos los accesos indeseados del exterior:
# Nota: 0.0.0.0/0 significa: cualquier red

# Cerramos el rango de puerto bien conocido
#iptables -A INPUT -s 0.0.0.0/0 -p tcp -dport 1:1024 -j DROP
#iptables -A INPUT -s 0.0.0.0/0 -p udp -dport 1:1024 -j DROP

# Cerramos un puerto de gestión: webmin
#iptables -A INPUT -s 0.0.0.0/0 -p tcp -dport 10000 -j DROP

#Bloqueo de facebook en la DMZ
# d: fuende de destino -s: fuente de origen 
iptables -I FORWARD -d 192.168.3.0/24 - tcp -m string --string "facebook.com" --algo kmp -j DROP

echo " OK . Verifique que lo que se aplica con: iptables -L -n"

# Fin del script
