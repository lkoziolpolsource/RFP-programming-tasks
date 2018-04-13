//clean data on Org
delete [SELECT Id From Book__c];

//first book set
Book__c book1Master = new Book__c(ISBN__c = '0132350882',
        Name = 'Clean Code: A Handbook of Agile Software',
        Author__c = 'Robert C. Martin',
        Publisher__c = 'Prentice Hall',
        Year__c = Date.today().addYears(-4),
        Translation__c= 'en_US'

);

insert book1Master;


Book__c book1Translation = new Book__c(ISBN__c = '1132350882',
        Name = 'Código limpio: un manual de software ágil',
        Author__c = 'Robert C. Martin',
        Publisher__c = 'Some Spaninsh Publisher',
        Year__c = Date.today().addYears(-4),
        Translation__c= 'es',
        Master_Book__c = book1Master.Id

);
insert book1Translation;

//second book set
Id recordType = [SELECT Id FROM RecordType WHERE DeveloperName='Drama'].Id;

Book__c book2Master = new Book__c(ISBN__c = '0158350989',
        Name = 'Hamlet',
        Author__c = ' William Shakespearer',
        Publisher__c = 'Cambridge University Press',
        Year__c = Date.today().addYears(-10),
        Translation__c= 'en_US',
        RecordTypeId = recordType

);

insert book2Master;



Book__c book2Translation = new Book__c(ISBN__c = '1158350989',
        Name = ' Hamlet (Spanish translation)',
        Author__c = ' William Shakespeare',
        Publisher__c = 'Cambridge University Press Spanish Publisher',
        Year__c = Date.today().addYears(-10),
        Translation__c= 'es',
        Master_Book__c = book2Master.Id,
        RecordTypeId = recordType

);
insert book2Translation;