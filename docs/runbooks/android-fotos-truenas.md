# Configurar un celular Android para copiar fotos al NAS Jarvis

Validado con un celular el 28 de noviembre de 2026. Repetí este procedimiento para cada Android nuevo. La programación automática y la confianza del certificado quedan por verificar.

## 1. Conectar el celular

1. Conectate al Wi-Fi definitivo del Omada, usando la contraseña de casa. El EAP620 HD opera en Standalone y está conectado al puerto LAN 5 del ER605, VLAN 1 sin etiqueta, PVID 1. El ER605 da DHCP en 192.168.10.100–199.
2. Verificá que el celular tenga su propia IP 192.168.10.x. La .102 que apareció en DHCP pertenecía al AP. Abrí http://192.168.10.101/ para comprobar acceso a TrueNAS.
3. Si aparece «Error de configuración de IP», revisá que la red del teléfono use DHCP y probá olvidar y reconectar la red. Si ocurre en varios equipos, revisá el cable y el puerto del AP y comprobá las concesiones en el ER605.

## 2. Preparar la cuenta SMB en TrueNAS

1. En **Credentials → Users**, verificá o creá una cuenta con **SMB Access**. Para los nuevos teléfonos, usá una cuenta y una subcarpeta identificables por dispositivo. En la ACL, otorgá permiso de escritura en su destino y comprobá que puede atravesar la ruta hasta él.
2. El recurso del piloto es **FotosPiloto**. Usá una subcarpeta por teléfono para evitar colisiones de nombres. La cuenta galeria_lectura es para PiGallery2 y conserva acceso de lectura al contenido que se mostrará en la galería.
3. Guardá la contraseña de la cuenta SMB en tu gestor de contraseñas. FolderSync usa esa cuenta, distinta de la cuenta de la galería.

## 3. Configurar FolderSync

1. Instalá FolderSync en Android. En **Acerca de → Permisos**, revisá el acceso al almacenamiento. Si aparece «No se ha encontrado el permiso para acceder a los archivos» con cero archivos comprobados, habilitá **Administrar todos los archivos** para FolderSync y volvé a seleccionar la carpeta local. Este permiso da acceso amplio al almacenamiento. [Permisos de FolderSync](https://foldersync.io/docs/help/permissions/)
2. En **Cuentas → Agregar cuenta → SMB**, ingresá servidor **192.168.10.101**, puerto **445**, recurso **FotosPiloto**, usuario SMB de carga y su contraseña. Dejá **Dominio NTLM** vacío. Preferí SMB3. El nombre del par mostrado durante el piloto decía SMB2 y por sí solo no identifica el protocolo negociado. Ejecutá **Prueba** y guardá.
3. Creá en Android una carpeta **PruebaNAS** y copiá dentro un JPEG descartable. En **Pares de carpetas**, poné la carpeta local a la izquierda y el destino SMB del teléfono a la derecha. Elegí **Hacia la carpeta derecha**. Si tu interfaz dice **Hacia carpeta remota**, elegí esa opción cuando SMB sea el destino.
4. Dejá desactivadas **Sincronizar eliminaciones** y **Mover archivos a la carpeta de destino**. La primera opción controla si se propagan los borrados. La segunda elimina el origen tras copiarlo. Para conservar el control, borrá del teléfono manualmente después de verificar el archivo. [Ajustes del par](https://foldersync.io/docs/help/v2/folderpairsettings/)

## 4. Validar la copia y la conservación

1. Tocá **Sincronizar**. En Windows, abrí `\\192.168.10.101\FotosPiloto`, entrá a la subcarpeta del teléfono y abrí el JPEG. La prueba de conexión SMB por sí sola no comprueba escritura.
2. Borrá del celular únicamente el JPEG descartable y sincronizá otra vez. Confirmá que el JPEG del NAS siga ahí. Solo entonces cambiá el origen a **DCIM/Camera** si querés copiar la cámara completa.
3. Si la edición instalada permite programar, limitá la ejecución al SSID del Omada y desactivá datos móviles para ese par. Probá el disparo con el teléfono bloqueado y verificá el registro. Si la app no ejecuta en segundo plano, revisá permisos para identificar el Wi-Fi y restricciones de batería. [Programación de FolderSync](https://foldersync.io/docs/help/v2/scheduling/)
4. Si vas a liberar espacio en el celular, verificá primero la copia. Para fotos importantes, mantené un respaldo aparte del único disco de TrueNAS.

## 5. Abrir PiGallery2 en el celular

1. Abrí **https://fotos.jarvis.local** en Chrome desde el Wi-Fi del Omada. PiGallery2 se usa en el navegador. La subida SMB por IP funciona independientemente del certificado del sitio.
2. Si aparece ERR_NAME_NOT_RESOLVED, probá TrueNAS por IP, comprobá el registro de AdGuard y revisá DNS privado de Android y DNS seguro de Chrome. En el piloto, desactivar temporalmente DNS privado en Automático coincidió con que la galería empezó a abrir. AdGuard devolvió 192.168.10.24 al consultarlo directamente desde Windows. El ER605 anunciaba AdGuard y 8.8.8.8. La causa definitiva y la prueba con DNS privado reactivado quedaron pendientes.
3. Si Chrome muestra un aviso de certificado, obtené de la PC de confianza el certificado público **jarvis-root-2026-validada.crt** de Jarvis Root CA 2026. Verificá su origen y transferí únicamente el .crt. En Android buscá **Instalar un certificado → Certificado de CA**. Volvé a abrir el sitio y usá una cuenta de galería sin rol administrador una vez que Chrome valide HTTPS.
4. En el piloto se vio la pantalla de inicio de sesión y se comprobó que el certificado presentado tenía el nombre fotos.jarvis.local y el emisor Jarvis Root CA 2026. Sigue pendiente instalar y comprobar la CA en Android.

## Registro de la prueba inicial

El AP se configuró en Standalone. Android mostró inicialmente un error de IP. El ER605 tenía DHCP habilitado, VLAN 1 sin aislamiento y el puerto 5 con PVID 1. Más tarde el teléfono abrió TrueNAS por IP. PhotoSync solicitó un complemento de pago para SMB y se eligió FolderSync. Se observó un error de permiso de almacenamiento antes de que el usuario confirmara que las fotos llegaron al NAS y dejaron de estar en el celular. Quedan por comprobar el ajuste que provocó el borrado local, la persistencia tras otra sincronización y la programación automática. Repetir la validación con los otros dos teléfonos.
