## Firewall de una LAN con salida a internet con DMZ

Imaginemos que tenemos una red, pero ahora hacemos las cosas bien y colocamos ese servidor IIS en una DMZ:

En este tipo de firewall hay que permitir:
- Acceso de la red local a internet.
- Acceso público al puerto tcp/80 y tcp/443 del servidor de la DMZ
- Acceso del servidor de la DMZ a una BBDD de la LAN
- Obviamente bloquear el resto de acceso de la DMZ hacia la LAN.
¿Qué tipo de reglas son las que hay que usar para filtrar el tráfico entre la DMZ y la LAN? Solo pueden ser las FORWARD, ya que estamos filtrando entre distintas redes, no son paquetes destinados al propio firewall.

