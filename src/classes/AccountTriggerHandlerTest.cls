@IsTest
public class AccountTriggerHandlerTest {
    @IsTest
    public static void shouldPopulateRegionOnInsert(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingCountry = 'US';
        acc.ShippingCountry = 'US';

        Test.startTest();
        insert acc;
        Test.stopTest();
        acc = [SELECT Region__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Americas', acc.Region__c);
    }

    @IsTest
    public static void shouldPopulateRegionOnUpdate(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingCountry = 'US';
        acc.ShippingCountry = 'US';
        insert acc;
        acc.BillingCountry = 'RW';

        Test.startTest();
        update acc;
        Test.stopTest();

        acc = [SELECT Region__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals('Africa', acc.Region__c);
    }

    @IsTest
    public static void shouldThrowExceptionWhenInvalidBillingCountry(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingCountry = 'Invalid country';
        acc.ShippingCountry = 'US';

        String errorMessage = '';
        Test.startTest();
        try{
            insert acc;
        }catch (Exception e){
            errorMessage = e.getMessage();
        }
        Test.stopTest();

        System.assert(errorMessage.contains(Label.Invalid_Country));
    }

    @IsTest
    public static void shouldThrowExceptionWhenInvalidShippingCountry(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingCountry = 'US';
        acc.ShippingCountry = 'Invalid country';

        String errorMessage = '';

        Test.startTest();
        try{
            insert acc;
        }catch (Exception e){
            errorMessage = e.getMessage();
        }
        Test.stopTest();

        System.assert(errorMessage.contains(Label.Invalid_Country));
    }

    @IsTest
    public static void shouldThrowExceptionWhenMissingVatNumber(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.BillingCountry = 'BE';
        acc.ShippingCountry = 'BE';

        String errorMessage = '';
        Test.startTest();
        try{
            insert acc;
        }catch (Exception e){
            errorMessage = e.getMessage();
        }
        Test.stopTest();

        System.assert(errorMessage.contains(Label.VAT_Number_Required));
    }
}