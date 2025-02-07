Despliegue de VPN SITE TO SITE desde Terraform Cloud:
1.- Terraform: Azure Provider y FortiOS Provider para el despliegue de los recursos de la nube de Azure y la configuración del Fortigate On Premise. Utilizamos Terraform Cloud para manejar el STATE del script de Terraform.
2.- Azure VPN Gateway, Azure Connection, Azure PIP y Azure Local Network Gateway: Recursos basicos para el despligue VPN de el extremo nativo en la nube.
3.- Fortinet/Fortios: Dispositivo Firewall Fortigate con usuario REST API para la conexion y configuración. El token generado desde el mismo dispositivo es almacenado de forma segura en un Azure Key Vault y se hace un llamado al secreto desde el script de Terraform. La configuración incluye Phase 1 y Phase 2 IPSEC, enrutamiento y politicas seguridad para el trafico. El equipo debe contar como requisito minimo una conexión a internet.
4.- Hacer el deploy con Terraform y validar la conectividad de End-to-End.

![Azure VPN - FGT drawio](https://github.com/user-attachments/assets/46eee0ef-3923-488b-bbb2-b9ce8571648e)
