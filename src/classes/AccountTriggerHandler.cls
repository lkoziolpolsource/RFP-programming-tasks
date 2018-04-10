public class AccountTriggerHandler extends TriggerHandler {

    private List<Account> newAccountsList;
    private List<CountriesConfigurationLoader.CountryWrapper> countriesConfiguration;

    public AccountTriggerHandler() {
        //Initialize list of new records
        this.newAccountsList = (List<Account>) Trigger.new;

        //Load countries configuration from static resource
        CountriesConfigurationLoader configurationLoader = new CountriesConfigurationLoader();
        this.countriesConfiguration = configurationLoader.getConfiguration();
    }

    public override void beforeUpdate() {
        populateRegion(newAccountsList);
        validateCountryCodes(newAccountsList);
        validateVatNumber(newAccountsList);
    }

    public override void beforeInsert() {
        populateRegion(newAccountsList);
        validateCountryCodes(newAccountsList);
        validateVatNumber(newAccountsList);
    }

    private void validateCountryCodes(List<Account> accountsList) {
        for (Account acc : accountsList) {
            //Validate billing country
            if (String.isBlank(acc.BillingCountry) || !isCountryCodeAllowed(acc.BillingCountry)) {
                acc.BillingCountry.addError(Label.Invalid_Country);
            }
            //Validate shipping country
            if (String.isBlank(acc.ShippingCountry) || !isCountryCodeAllowed(acc.ShippingCountry)) {
                acc.ShippingCountry.addError(Label.Invalid_Country);
            }
        }
    }

    private void validateVatNumber(List<Account> accountsList) {
        for (Account acc : accountsList) {
            if (acc.Region__c == 'Europe' && isVatNumberRequired(acc.BillingCountry) && String.isBlank(acc.Vat_Number__c)) {
                acc.Vat_Number__c.addError(Label.VAT_Number_Required);
            }
        }
    }

    private void populateRegion(List<Account> accountsList) {
        for (Account acc : accountsList) {
            String billingCountryRegion = getCountryRegion(acc.BillingCountry);
            if (String.isNotBlank(acc.BillingCountry) && billingCountryRegion != null) {
                acc.Region__c = billingCountryRegion;
            }
        }
    }

    private String getCountryRegion(String countryCode) {
        String region;
        if (String.isNotBlank(countryCode) && countriesConfiguration != null) {
            for (CountriesConfigurationLoader.CountryWrapper country : countriesConfiguration) {
                if (countryCode == country.isoCode) {
                    region = country.region;
                    break;
                }
            }
        }
        return region;
    }

    private Boolean isCountryCodeAllowed(String countryCode) {
        Boolean isCountryCodeAllowed = false;
        if (String.isNotBlank(countryCode) && countriesConfiguration != null) {
            for (CountriesConfigurationLoader.CountryWrapper country : countriesConfiguration) {
                if (countryCode == country.isoCode) {
                    isCountryCodeAllowed = true;
                    break;
                }
            }
        }
        return isCountryCodeAllowed;
    }

    private Boolean isVatNumberRequired(String countryCode) {
        Boolean isVatNumberRequired = false;
        if (String.isNotBlank(countryCode) && countriesConfiguration != null) {
            for (CountriesConfigurationLoader.CountryWrapper country : countriesConfiguration) {
                if (countryCode == country.isoCode) {
                    isVatNumberRequired = country.isVatNumberRequired;
                    break;
                }
            }
        }
        return isVatNumberRequired;
    }
}