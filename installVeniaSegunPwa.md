# Pasos para Instalar PWA - Adobe Commerce

Install YARN 
https://classic.yarnpkg.com/en/docs/install/#debian-stable 
 
 
Install node 
https://computingforgeeks.com/how-to-install-nodejs-on-ubuntu-debian-linux-mint/ 
  
VERSION 16
  
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash 
export NVM_DIR="$HOME/.nvm" 
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 
nvm install 16
nvm use 16
 
 
****clonar el proyecto y cambiarse a la rama necesaria***** 
Una vez clonado y en la rama: 
 
yarn install  
 
si termina correcto: 
 
yarn watch:venia (en caso de no funcionar consultar con PWA el proyecto porque multisites tiene customización en el comando ejemplo: corona es yarn watch:corona) 
 
 
 
(el siguiente paso es más necesario para los PWA, los de backend en la mayoría no es necesario) 
Si tiene custom domain, instalar lo siguiente en el path 
Packages/venia-concept 
Comando1: npx @magento/pwa-buildpack create-custom-origin . 
Comando2: yarn buildpack create-custom-origin packages/venia-concept
Yarn
Fast, reliable, and secure dependency management.


# En dónde se modifica o configura que apunte al backend de Adobe Commerce?

en el .env
BACKEND_URL= urllocal


normalmente el repo debe clonarlo con la url de stg 


#   Connect to an instance of Magento 2.3 by specifying its public domain name.
MAGENTO_BACKEND_URL=https://mcstaging.meltpizzas.com/
el .env aparece luego del yarn install



# Para instalar un sitio limpio:

https://github.com/magento/pwa-studio

GitHub - magento/pwa-studio: 🛠Development tools to build, optimize and deploy Progressive Web Applications for Magento 2.

🛠Development tools to build, optimize and deploy Progressive Web Applications for Magento 2. - magento/pwa-studio

lo podemos clonar desde aquí

en develop le damos a tags y seleccionamos la versión que queremos
y es igual clonamos, 
yarn install y 
yarn watch:venia

automaticamente se conecta al cloud de pruebas de magento 
 solo es cambiar en el .env la url y apuntarlo a su local


# Personalmente agregaría la extensión para Check Money

## Braintree
https://magento.stackexchange.com/questions/330774/there-was-an-error-loading-payments-please-refresh-or-try-again-later-pwa-venia

Como lo indica en el Stack Overflow, es más fácil create una cuenta en Braintree
https://www.braintreepayments.com/sandbox

Adicional en el archivo:
- packages/venia-concept/.env

Deberas cambiar tu CHECKOUT_BRAINTREE_TOKEN, el cual se forma por 3 conceptos clave:
- La palabra "sandbox"
- El Merchant ID
- La public Key

Por ejemplo, tomemos el token que trae la instalación de PWA
sandbox_8yrzsvtm_s2bg8fs563crhqzk
En la cuenta sandbox de esta persona, le apareció algo como:
- Merchant ID: 8yrzsvtm
- Public Key: s2bg8fs563crhqzk

## A mi NO me funcionó el CheckMoneyOrder
https://github.com/magento/pwa-studio/tree/develop/packages/extensions/venia-sample-payments-checkmo