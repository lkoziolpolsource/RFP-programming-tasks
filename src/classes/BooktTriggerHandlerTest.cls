/**
 * Created by PS on 2018/04/11
 */

@IsTest
private class BooktTriggerHandlerTest {


    @testSetup static void setupData() {
        Id recordId = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Book__c' ORDER BY DeveloperName LIMIT 1].Id;

        Book__c master = new Book__c(ISBN__c = '0132350882',
                Name = 'Clean Code: A Handbook of Agile Software',
                Author__c = 'Robert C. Martin',
                Publisher__c = 'Prentice Hall',
                Year__c = Date.today().addYears(-4),
                Translation__c = 'en_US',
                RecordTypeId = recordId

        );
        insert master;

        Book__c translation = new Book__c(ISBN__c = '1132350882',
                Name = 'Código limpio: un manual de software ágil',
                Author__c = 'Robert C. Martin',
                Publisher__c = 'Some Spaninsh Publisher',
                Year__c = Date.today().addYears(-4),
                Translation__c = 'es',
                Master_Book__c = master.Id,
                RecordTypeId = recordId
        );

        insert translation;

    }

    @isTest
    public static void updateMasterWithoutAllReqFields() {
        Book__c master = [SELECT Id, RecordTypeId, Name, Author__c,Description__c, ISBN__c, Publisher__c,
                        Master_Book__c, Translation__c,Year__c FROM Book__c
                        WHERE ISBN__c = '0132350882' AND Translation__c = 'en_US'];

        Test.startTest();
        master.ISBN__c = null;
        master.Author__c = null;
        master.Name = null;
        master.Publisher__c = null;
        try
        {
            update master;
        }
        catch (DmlException ex){
            System.assert(ex.getMessage().contains('ISBN should contain 10 digits'),'Book has been saved without all required fields !!!');
        }

        Test.stopTest();

    }

    @isTest
    public static void addNewTranslation() {

        Test.startTest();

        Book__c master = [SELECT Id FROM Book__c WHERE ISBN__c = '0132350882' AND Translation__c = 'en_US'];

        Book__c translation = new Book__c(ISBN__c = '4132350882',
                Name = 'Clean Code: Ein Handbuch für Agile Software',
                Author__c = 'Robert C. Martin',
                Publisher__c = 'Some German Publisher',
                Year__c = Date.today().addYears(-4),
                Translation__c = 'de',
                Master_Book__c = master.Id

        );
        insert translation;

        System.assert(translation.Id != null, 'Gemran translation has not been saved properly !!!');

        Test.stopTest();

    }

    @isTest
    public static void tryToAddTranslationWithoutMaster() {

       Test.startTest();

        Book__c orphantTranslation = new Book__c(ISBN__c = '4132350882',
                Name = 'Some orphant book',
                Author__c = 'Some author',
                Publisher__c = 'Some German Publisher',
                Year__c = Date.today().addYears(-4),
                Translation__c = 'de'

        );

        try {
            insert orphantTranslation;
        }
        catch (DmlException ex){
            System.assert(ex.getMessage().contains('Please add master book record'),'Transaltion without master book has been added !!!');
        }


        Test.stopTest();

    }

    @isTest
    public static void removeMaster() {

        Book__c master = [SELECT Id FROM Book__c WHERE ISBN__c = '0132350882' AND Translation__c = 'en_US'];

        Test.startTest();

        Integer cnt = [SELECT count() FROM Book__c WHERE Master_Book__c = :master.Id];

        System.assert(cnt > 0, 'Missing translations for master book');

        delete [SELECT Id FROM Book__c WHERE Id = :master.Id];

        cnt = [SELECT count() FROM Book__c WHERE Master_Book__c = :master.Id];

        System.assert(cnt == 0, 'Translations have not been removed with master !!!');

        Test.stopTest();

    }
}