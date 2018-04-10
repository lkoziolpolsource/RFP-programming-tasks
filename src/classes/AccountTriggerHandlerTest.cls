@IsTest
public class AccountTriggerHandlerTest {
    @IsTest
    public static void shouldPopulateRegionOnInsert() {
        //Prepare test data
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingCountry = 'US';
        acc.ShippingCountry = 'US';

        //Perform test
        Test.startTest();
        insert acc;
        Test.stopTest();

        //Verify
        acc = [SELECT Region__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Americas', acc.Region__c);
    }

    @IsTest
    public static void shouldPopulateRegionOnUpdate() {
        //Prepare test data
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingCountry = 'US';
        acc.ShippingCountry = 'US';
        insert acc;
        acc.BillingCountry = 'RW';

        //Perform test
        Test.startTest();
        update acc;
        Test.stopTest();

        //Verify
        acc = [SELECT Region__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Africa', acc.Region__c);
    }

    @IsTest
    public static void shouldThrowExceptionWhenInvalidBillingCountry() {
        //Prepare test data
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingCountry = 'Invalid country';
        acc.ShippingCountry = 'US';

        //Perform test
        String errorMessage = '';
        Test.startTest();
        try {
            insert acc;
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        Test.stopTest();

        //Verify
        System.assert(errorMessage.contains(Label.Invalid_Country));
    }

    @IsTest
    public static void shouldThrowExceptionWhenInvalidShippingCountry() {
        //Prepare test data
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingCountry = 'US';
        acc.ShippingCountry = 'Invalid country';

        //Perform test
        String errorMessage = '';
        Test.startTest();
        try {
            insert acc;
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        Test.stopTest();

        //Verify
        System.assert(errorMessage.contains(Label.Invalid_Country));
    }

    @IsTest
    public static void shouldThrowExceptionWhenMissingVatNumber() {
        //Prepare test data
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingCountry = 'BE';
        acc.ShippingCountry = 'BE';

        //Perform test
        String errorMessage = '';
        Test.startTest();
        try {
            insert acc;
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
        Test.stopTest();

        //Verify
        System.assert(errorMessage.contains(Label.VAT_Number_Required));
    }
}