# Project Title

Book Catalog App + Account validation additional fields like VAT based on Billing, Shipping Country

## Src  
* Shor description  of major classes and components

``` 
Book Catalog:

Book__c - major object for Book Catalog app. Contains book and translations (simiplified model) 
          instead using a few objects Catalog is repesented by Record Types
          object contains lookup to same entity for translation purposes

BookCatalogController.cls - main controler for Book Catalog (BC)

BookTriggerHandler.cls - handler for BC trigger - invokes validator

BookValidator.cls - cointains validation business logic for BC


Fields validation - VAT:

AccountTriggerHandler.cls - trigger handler responsible for business logic

CountriesConfigurationLoader.cls - repsonible for loading configuration for countries from static resource

Countries_Configuration.resource - cotains VAT confirugration per country

Shared between apps:

TriggerHandler.cls - trigger pattern (simplified version)
``` 
### Installing

Pre deployment steps

[Enable translation] (https://help.salesforce.com/articleView?id=customize_wbench.htm&type=5)

[Enable search](https://help.salesforce.com/articleView?id=search_enhanced_lookup_enable.htm&type=5)

Deploy on ORG using Migration Tool or Workbench as preferred

## Test Data

Please invoke in Dev Console attached script

``` 
sample data.apex 
```

### Unit Tests Results

```
test results/Test Results - AccountTriggerHandlerTest.html
test results/Test Results - BooktTriggerHandlerTest.html
test results/Test Results - TriggerHandler_Test.html
```
## Authors

* **Lukasz Koziol** 
* **Daniel Dyl**




