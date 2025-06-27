# Clonar proyecto en tu laptop

# Tabla de contenido <a id="tableOfContents"></a>

- [Clonar proyecto en tu laptop](#clonar-proyecto-en-tu-laptop)
- [Tabla de contenido ](#tabla-de-contenido-)
  - [BitBucket ](#bitbucket-)
    - [Copiar la url que aparece en bitbucket ](#copiar-la-url-que-aparece-en-bitbucket-)
  - [Docker ](#docker-)
    - [Env.php ](#envphp-)
      - [Base de datos \& indexer ](#base-de-datos--indexer-)
      - [ElasticSearch / OpenSearch ](#elasticsearch--opensearch-)
      - [Composer ](#composer-)
  - [Base de datos  ](#base-de-datos--)
    - [Crear base de datos e importar  ](#crear-base-de-datos-e-importar--)
    - [Configuración de URLs de ambiente ](#configuración-de-urls-de-ambiente-)
    - [Configuración de cookie de ambiente ](#configuración-de-cookie-de-ambiente-)
  - [NGINX ](#nginx-)
  - [/etc/hosts ](#etchosts-)
  - [Docker (2da parte) ](#docker-2da-parte-)
    - [Aplicar los patches ](#aplicar-los-patches-)
    - [Magento Upgrade ](#magento-upgrade-)
    - [Administrador Magento ](#administrador-magento-)
  - [Comandos para trabajar en local ](#comandos-para-trabajar-en-local-)
    
---

---

---  

## BitBucket <a id="bitbucket"></a>
[Regresar a la tabla de contenido](#tableOfContents)

### Copiar la url que aparece en bitbucket <a id="source_url_bitbucket"></a>
[Regresar a la tabla de contenido](#tableOfContents)




*Figura 1. Clonar proyecto.*


Pegarlo en tu local




*Figura 2. Pegarlo en tu local*


Nota: Si la base de datos que te pasaron es de staging, se deberá cambiar a la rama de staging


```shell
cd <carpeta_proyecto>

git status 

git checkout staging 
```

---

---

---  
## Docker <a id="docker"></a>
[Regresar a la tabla de contenido](#tableOfContents)

Pasar los archivos env.php y docker-composer.yml de algún otro proyecto y editarlos de acuerdo al proyecto a tratar:


Para docker-composer.yml edita estos parámetros de acuerdo al proyecto a tratar:

* image: versión de php
* container_name: nombre que le quieras dar al contenedor
* ports: puerto que le corresponde



```php

 web:
    image: 'dockerimage'
    ports:
      - "8042:80"
    volumes:
      - ./:/var/www/html
      - ~/.composer:/home/magento2/.composer
    external_links:
      - elasticsearch7:elastic
      - mariadb:mariadb
        #- redis:redis
    container_name: nombredocker

```

---

### Env.php <a id="env_php"></a>
[Regresar a la tabla de contenido](#tableOfContents)

Para el archivo de env.php, edita las variables de:

---

#### Base de datos & indexer <a id="base_datos_indexer"></a>
[Regresar a la tabla de contenido](#tableOfContents)

*  ***"connection"*** ajustando el nombre con el que haya quedado el contenedor de mysql, el usuario de que generalmente es root, el nombre de la bd que se vaya a ocupar en mysql y el pass que generalmente es mysql.

```php

    'db' => [
        'connection' => [
            'default' => [
                'host' => '172.17.0.1',
                'username' => 'root',
                'dbname' => 'nombredb',
                'password' => 'mysql'
            ],
            'indexer' => [
                'host' => '172.17.0.1',
                'username' => 'root',
                'dbname' => 'nombredb',
                'password' => 'mysql'
```

*  ***"indexer"*** va la misma información que se mencionó arriba.

---

#### ElasticSearch / OpenSearch <a id="elastic_open_search"></a>
[Regresar a la tabla de contenido](#tableOfContents)


##### Magento < 2.4.8

*  ***'elasticsearch7_server_hostname' => 'elastic'*** verifica que se llame igual que el contenedor de elasticsearch que tienes en tu local.

````php
'system' => [
      'default' => [
          'catalog' => [
              'search' => [
                    'engine' => 'elasticsearch7',
                    'elasticsearch7_server_hostname' => 'elastic',
                    'elasticsearch7_server_port' => 9200
              ]
          ]
      ]
  ]
````

##### Magento >= 2.4.8

*  ***'opensearch_server_hostname' => '172.17.0.2'*** verifica que sea la IP del docker o del docker gateway, lo puedes hacer con:
> docker inspect opensearch


````php
'system' => [
      'default' => [
          'catalog' => [
              'search' => [
                  'engine' => 'opensearch',
                  'opensearch_server_hostname' => '172.17.0.2',
                  'opensearch_server_port' => 10200,
                  'opensearch_index_prefix' => 'el_vde_op_'
              ]
          ]
      ]
  ]
````


#### Tu archivo env.php deberá quedar como el siguiente:

```php

<?php
return [
    'cache' => [
        'frontend' => [
            'default' => [
                'id_prefix' => '4bd_'
            ],
            'page_cache' => [
                'id_prefix' => '4bd_'
            ]
        ]
    ],
    'MAGE_MODE' => 'developer',
    'cache_types' => [
        'compiled_config' => 1,
        'config' => 1,
        'layout' => 1,
        'block_html' => 1,
        'collections' => 1,
        'reflection' => 1,
        'db_ddl' => 1,
        'eav' => 1,
        'customer_notification' => 1,
        'config_integration' => 1,
        'config_integration_api' => 1,
        'full_page' => 1,
        'target_rule' => 1,
        'config_webservice' => 1,
        'translate' => 1,
        'vertex' => 1
    ],
    'backend' => [
        'frontName' => 'admin'
    ],
    'db' => [
        'connection' => [
            'default' => [
                'host' => 'mariadb',
                'username' => 'root',
                'dbname' => 'nombredb',
                'password' => 'mysql'
            ],
            'indexer' => [
                'host' => 'mariadb',
                'username' => 'root',
                'dbname' => 'nombredb',
                'password' => 'mysql'
            ]
        ]
    ],
    'queue' => [
        'consumers_wait_for_messages' => 0
    ],
    'crypt' => [
        'key' => 'abcdefghijkl'
    ],
    'resource' => [
        'default_setup' => [
            'connection' => 'default'
        ]
    ],
    'x-frame-options' => 'SAMEORIGIN',
    'session' => [
        'save' => 'files'
    ],
    'lock' => [
        'provider' => 'db',
        'config' => [
            'prefix' => null
        ]
    ],
    'downloadable_domains' => [
        'dominio.dev'
    ],
    'install' => [
        'date' => 'Thu, 26 Jun 2025 05:54:37 +0000'
    ],
    'system' => [
        'default' => [
            'catalog' => [
                'search' => [
                    'engine' => 'opensearch',
                    'opensearch_server_hostname' => '172.17.0.2',
                    'opensearch_server_port' => 10200,
                    'opensearch_index_prefix' => 'el_vde_op_'
                ]
            ]
        ]
    ]
];
```

Después levantar el contenedor con el comando:


```shell

docker-compose up -d 

```




*Figura 3. Iniciar el contenedor*


y con este otro comando se ve arriba el contenedor:


```shell
docker-compose ps
```

Entrar al contenedor con el usuario de magento2:

```shell
docker exec –ti –u magento2 <nombre_instancia> bash
```

---

#### Composer <a id="composer"></a>
[Regresar a la tabla de contenido](#tableOfContents)

y mandar el "composer install"





*Figura 4. Entrar al contenedor y mandar el composer install*

Mientras se ejecuta el composer install, continua con al instalación de BBDD.

---

---

---  
## Base de datos  <a id="base_de_datos"></a>
[Regresar a la tabla de contenido](#tableOfContents)

---

### Crear base de datos e importar  <a id="crear_importar_bbdd"></a>
[Regresar a la tabla de contenido](#tableOfContents)

Ve a donde descargaste el backup de la base de datos que te pasaron, y la descomprimes con el siguiente comando:
```shell

gunzip bk_nombre.sql.gz 

```




*Figura 5. Descomprimir base de datos*



Después entra a mysql con el comando:

```shell

mysql -u root -p -h 172.17.0.1 

```

para crear la base de datos del proyecto (recordando que en el archivo env.php ya se le había colocado el nombre de "nombredb")


```sql
create database nombredb;

```
y te posicionas en ella con el comando:


```sql

use database nombredb;

```



*Figura 6. Crear base de datos*


Se va a importar usando el comando:


```sql

source /ruta/donde/se/encuentre/el/archivo.sql

```




*Figura 7. Importando base de datos*

---

### Configuración de URLs de ambiente <a id="config_urls"></a>
[Regresar a la tabla de contenido](#tableOfContents)

Cuando esté lista, buscar las url en esta tabla: core_config_data , con este query:


```sql

select * from core_config_data where path like 'web%base%'; 

```


el resultado en este caso muestra unas url como: http://tiendaoficial.mx/ por lo que se van a modificar añadiendo la palabra ".local" con ayuda de este comando siguiente:


```sql

update core_config_data set value='http://dominio.dev/' where config_id in (22,25,3346,3355);

```

quedando como muestra la imagen siguiente:





*Figura 8. Configurando nuevas url*


### Configuración de cookie de ambiente <a id="cookie_ambiente"></a>
[Regresar a la tabla de contenido](#tableOfContents)

Para evitar conflictos en el loggeo del Administrador de Magento es necesario hacer este cambio

```sql
UPDATE core_config_data SET value = 'dominio.dev' WHERE path = 'web/cookie/cookie_domain';
```

---

---

---  

## NGINX <a id="nginx"></a>
[Regresar a la tabla de contenido](#tableOfContents)

Ahora, en los archivos del contenedor de ***"nginx"***, se va a editar el archivo "vhost" de acuerdo al nombre de las urls que se quedaron registradas en la base de datos y también se modificará el puerto


En este caso lo que se modifica de acuerdo al proyecto es:

* upstream: agregando el nombre que se colocó en la base de datos, y modificando el puerto
* server_name
* access_log
* error_log
* proxy_pass



```shell

upstream dominio.dev { server 172.17.0.1:8042; }
server {
  listen 80;
  server_name dominio.dev;
  access_log /var/log/nginx/dominio_access.log;
  error_log /var/log/nginx/tdominio_error.log;
  location / {
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header Host $http_host;
    proxy_set_header X-Nginx-Proxy true;
    proxy_pass http://dominio.dev;
    proxy_redirect off;
    proxy_connect_timeout 600;
    proxy_send_timeout 600;
    proxy_read_timeout 600;
    proxy_buffer_size 128k;
    proxy_buffers 4 256k;
    proxy_busy_buffers_size 256k;
  }
}


```


Y reinicias el contenedor de "nginx" para que tome los cambios:


```shell

docker compose down


docker compose up -d

```




*Figura 9. Reinicio de contenedor*

---

---

---  
## /etc/hosts <a id="etc_hosts"></a>
[Regresar a la tabla de contenido](#tableOfContents)
En el archivo /etc/host de tu máquina agregas la ip 127.0.0.1 seguido por el nombre que dejaste registrado en la base de datos anteriormente mencionado:




*Figura 10. Edición del archivo /etc/hosts*


---

---

---  
## Docker (2da parte) <a id="docker_p2"></a>
[Regresar a la tabla de contenido](#tableOfContents)

Regresando al ***contenedor del proyecto***, verifica que haya terminado el proceso del composer install, si todo está bien, continuas

---
### Aplicar los patches <a id="apply_patches"></a>
[Regresar a la tabla de contenido](#tableOfContents)

```shell
php vendor/bin/ece-patches apply

```


Puede que NO existan patches y solo aparezca:



---
### Magento Upgrade <a id="magento_upgrade"></a>
[Regresar a la tabla de contenido](#tableOfContents)

Haces el upgrade de magento:


```shell
bin/magento setup:upgrade 
```





*Figura 11. Upgrade de magento.*


Para este paso, ya debes de poder visualizar algo desde interfaz web entrando a la url que se dejó en el archivo vhost (dominio.dev/).





*Figura 15. Vista web de las urls*

---
### Administrador Magento <a id="admin_magento"></a>
[Regresar a la tabla de contenido](#tableOfContents)

Para crear tu usuario de Admin, puedes utilizar el comando:

```bash
php bin/magento admin:user:create --admin-user=MyUserToLogin --admin-password=MyPasswordToLogin --admin-email=mymail@domain.com --admin-firstname=Veronica	 --admin-lastname=Costelo
```

Ingresa al admin con la URL dominio.dev/admin

Para mejorar la velocidad de respuesta en ambientes locales se deberá cambiar el "Caching Application" a *Built-in Cache*
Store > Configuration > Advanced > System > Full Page Cache


También puedes hacer este cambio utilizando el siguiente query

```sql
UPDATE core_config_data SET value='1' WHERE path = 'system/full_page_cache/caching_application';
```

---

---

---

## Comandos para trabajar en local <a id="local_commands"></a>
[Regresar a la tabla de contenido](#tableOfContents)

Primero será necesario que coloques tu ambiente en modo developer, desde el docker en /var/www/html, ejecuta:

```shell
php bin/magento deploy:mode:set developer
```

Los siguientes comandos te permitirán trabajar día con día
```shell
# Primero eliminar todos los archivos antiguos
rm -rf ./generated/* ./var/view_preprocessed/* ./var/cache/* ./var/page_cache/* ./var/session/* ./pub/static/*/*
#php bin/magento deploy:mode:show         # Solo por si tienes dudas sobre el modo actual
php bin/magento setup:upgrade             # Necesario cuando agregas un nuevo módulo o cuando creas un nuevo archivo en Setup/
php bin/magento setup:di:compile          # Cuando haces un cambio en archivos di.xml o necesitas validar la dependencias de archivos
php bin/magento cache:flush               # Cada que necesites limpiar cache
php bin/magento dev:source-theme:deploy   # Cuando modifiques archivos CSS y JS bastará con un F5 para ver la nueva versión del archivo
git branch                                # Para que recuerdes ¿qué branch compilaste?
date                                      # Para que recuerdes ¿a qué hora fue la última compilación?
```