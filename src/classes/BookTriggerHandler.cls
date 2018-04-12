public class BookTriggerHandler extends TriggerHandler {

    public BookTriggerHandler(){}

    public override void BeforeDelete(){
            Map<Id, Book__c> booksToRemove = (Map<Id, Book__c>) Trigger.oldMap;

            //remove all children related to master parent book
            try{
                delete [SELECT Id FROM Book__c WHERE Master_Book__c IN :booksToRemove.keySet() AND Is_Master__c != true];
            }catch (DmlException ex){
                booksToRemove.values().get(0).addError('Can\'t delete transalations related to the master book' +ex.getMessage());
            }


    }

    public override void beforeUpdate() {
        List<Book__c> books = (List<Book__c>) Trigger.new;
        for(Book__c book: books) {
            BookValidator.ValidationResult result = BookValidator.validateBook(book);
            if(!result.success){
                books.get(0).addError(result.errorMessages.get(0));
                return;
            }
        }

    }

    public override void beforeInsert() {
        List<Book__c> books = (List<Book__c>) Trigger.new;
        for(Book__c book: books) {
            BookValidator.ValidationResult result = BookValidator.validateBook(book);
            if(!result.success){
                books.get(0).addError(result.errorMessages.get(0));
                return;
            }
        }
    }

}