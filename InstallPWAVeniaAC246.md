Visual Studio Code Default Markdown Preview Shortcut
```
CTRL+K V
```
<br>
<br>

# Install PWA Venia

This file contains the steps to create a Vanilla Adobe Commerce 2.4.6 with PWA Venia

This file shows the links to the official documentation.
Then the file includes information on GitHub Magento's repository to make the PWA work, so keep reading until the end

# About Venia PWA

https://developer.adobe.com/commerce/pwa-studio/guides/

---

# Official Tutorial—That works for Magento BackEnd but doesn't work for PWA JS project

https://developer.adobe.com/commerce/pwa-studio/tutorials/setup-storefront/


## Install backend modules

You need to have a working installation of Vanilla Adobe Commerce version 2.4.6

https://developer.adobe.com/commerce/pwa-studio/metapackages/open-source/


```bash
# To much reading to only need to run the following line an upload composer.json changes XD
# + composer.lock
# On backend installation or docker, run:
composer require magento/pwa
composer require magento/pwa-commerce
composer require magento/module-upward-connector:^2.0 --with-all-dependencies
# And also do an upgrade 
php bin/magento setup:upgrade
# For last do a reindex
php bin/magento indexer:reindex
```


# Magento GitHub

In this tutorial, the used version for Adobe Commerce 2.4.6 is pwa-studio v13.0.0

https://github.com/magento/pwa-studio/tree/v13.0.0


## Install PWA Dependencies

### Install this ONLY the first time

```bash
# Install curl
sudo apt install curl

# The following command use the 'master' branch, one reference use the branch v0.33.0
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

# The master branch will output this:
export NVM_DIR="$HOME/.nvm" 
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion 
# Execute the commands if the output doesn't have it
 
# Install nvm version 16 or 15
nvm install 16
nvm use 16

# Install yarn
npm install --global yarn

# One reference indicates to install node, but maybe my Ubuntu has node installation by default
Install node 
https://computingforgeeks.com/how-to-install-nodejs-on-ubuntu-debian-linux-mint/ 
VERSION 16
```



### Install this every time you create a new PWA-Studio

In the target folder, download your pwa-studio project version 13.0.0 (for Adobe Commerce 2.4.6)

https://github.com/magento/pwa-studio

Checkout to version v13.0.0

```bash
git fetch origin v13.0.0:v13.0.0
git checkout v13.0.0
```

To install all files needed, run:

```bash
yarn install
```

In packages/venia-concept/.env file, change the value:
- MAGENTO_BACKEND_URL
For example:
- MAGENTO_BACKEND_URL=https://mag246.local/

Now execute the commands:
```bash
yarn install

# The output, will show you the URL to view the PWA Venia project online
yarn watch:venia
# If you want to change the URL, check this link:
# https://developer.adobe.com/commerce/pwa-studio/tutorials/setup-storefront/#add-a-custom-hostname-and-ssl-cert
```

### Braintree's configuration for a complete test

For a complete test you can configure Braintree

https://magento.stackexchange.com/questions/330774/there-was-an-error-loading-payments-please-refresh-or-try-again-later-pwa-venia

Create a sandbox Braintree account

https://www.braintreepayments.com/sandbox

And login to your account

https://sandbox.braintreegateway.com/

---

For Magento Admin, you will need:
- Merchant ID
- Public Key
- Private Key

You can get this information from your sandbox braintree account
Gear > API > API Keys > Private Key > View

---

For PWA installation, you will need:
- CHECKOUT_BRAINTREE_TOKEN

You can get this information from your sandbox braintree account 
Gear > API > Tokenization Keys > Generate New Tokenization Key

In packages/venia-concept/.env file, change the value:
- CHECKOUT_BRAINTREE_TOKEN

For example:
CHECKOUT_BRAINTREE_TOKEN=sandbox_abc123def456_098765qwerty

---

Stop PWA using CTRL + C and run:
```bash
yarn install

# The output, will show you the URL to view the PWA Venia project online
yarn watch:venia
```


For test cards use:

https://support.checkfront.com/hc/en-us/articles/115004847353-Setting-up-Braintree-Direct-as-your-Checkfront-payment-provider
```text
Visa: 4111 1111 1111 1111
Mastercard: 5555 5555 5555 4444
Amex: 3714 496353 9843
You can use any CVC code.

Use a valid month and a day within the next 180 years for expiry dates.

Amounts between $0.01 - $1999.99 simulate a successful authorization.
```
