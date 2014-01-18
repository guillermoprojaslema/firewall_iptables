## Firewall de una LAN con salida a internet con DMZ

Imaginemos que tenemos una red, pero ahora hacemos las cosas bien y colocamos ese servidor IIS en una DMZ:

En este tipo de firewall hay que permitir:
- Acceso de la red local a internet.
- Acceso público al puerto tcp/80 y tcp/443 del servidor de la DMZ
- Acceso del servidor de la DMZ a una BBDD de la LAN
- Obviamente bloquear el resto de acceso de la DMZ hacia la LAN.
¿Qué tipo de reglas son las que hay que usar para filtrar el tráfico entre la DMZ y la LAN? Solo pueden ser las FORWARD, ya que estamos filtrando entre distintas redes, no son paquetes destinados al propio firewall.


## Configuración de IP ##

Los siguientes pasos muestran la configuración por defecto que tienen que tener todas las maquinas involucradas en la DMZ.

---------Configuración de Maquina Firewall-----------------

- Firewall tiene 3 adaptadores  
	* eth0 (Internet Automatico No Tocar)
	* eth1 (LAN 192.168.10.1) MASCARA(24) y Puerta Enlace  (192.168.10.2).
	* eth2 (SERVER  192.168.3.1) Mascara(24) Puerta Enlace(192.168.3.2).
- Como la dns se usan en todas la maquinas, se extrae del firewall, con los siguientes comandos (cat /etc/resolv.conf).


--------Configuración de Maquina LAN------------------------

- La LAN tiene 1 Adaptador eth0 y se configura con los siguientes datos: 
	* IP: 192.168.10.2, MASCARA: 24, Puerta Enlace: 192.168.10.1
- DNS sera la misma que se coloco en el firewall.


--------Configuración de Maquina SERVER----------------------

- La LAN tiene 1 Adaptador eth0 y se configura con los siguientes datos: 
	* IP: 192.168.3.2, MASCARA: 24, Puerta Enlace: 192.168.3.1 
- DNS sera la misma que se coloco en el firewall.



