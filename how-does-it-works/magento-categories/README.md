# How does Magento categories works

## 1 When Magento 2 ask for a URL, it is translated

We need to go to rewrites at:  
Admin > Marketing > SEO & Search > URL Rewrites

You will find that the Controller is:  
catalog/category/view/id/{category_id}  [target path]


The category id can be found at:  
Admin > Catalog > Categories


I remember a case when the URL Rewrites for categories DOES NOT EXIST!  
But for this store is NOT the case

## Then in the code, we can navigate to controller

vendor/magento/module-catalog/Controller/Category/View.php

vendor/magento/module-catalog/Model/Layer/Resolver.php

**Many of the solution is on de di.xml**

vendor/magento/module-catalog/etc/di.xml

vendor/magento/module-catalog/Model/Category.php
\Magento\Catalog\Model\Category::getProductCollection


vendor/magento/module-catalog/Model/ResourceModel/Product/Collection.php

\Magento\Catalog\Model\ResourceModel\Product\Collection::addCategoryFilter

Here is the main POINT to check
\Magento\Catalog\Model\ResourceModel\Product\Collection::_applyProductLimitations


