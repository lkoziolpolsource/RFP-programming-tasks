/**
 * Created by PS 04/10/2018.
 */
public class BookValidator {

    public static Set<Id> recordIds;

    static {
       recordIds = new Map<Id, RecordType>([SELECT Id, Name FROM RecordType WHERE SobjectType='Book__c']).keySet();
    }

    public class ValidationResult{
        public List<String> errorMessages {get;set;}
        public Boolean success {get;set;}


        public ValidationResult(Boolean success, List<String> errorMessages){
            this.success = success;
            this.errorMessages = !success ? errorMessages: new List<String>();

        }
    }


    public static ValidationResult validateBook(Book__c book) {

        List<String> errors = new List<String>();

        if (book != null) {
            validateISBNLength(book.ISBN__c, errors);
            validateTitle(book.Name, errors);
            validateAuthor(book.Author__c, errors);
            validatePublisher(book.Publisher__c, errors);
            validateYear(book.Year__c, errors);
            validateParentForTransalation(book, errors);
        }else{
            errors.add('No book record to validate');
        }

        return new ValidationResult(errors.size()== 0, errors);
    }

    public static Boolean validateISBNLength(String isbn, List<String> messages){
        Boolean result = true;

        result = String.isNotEmpty(isbn) && String.valueOf(isbn).length() ==10;

        if(!result) {
            messages.add('ISBN should contain 10 digits');
        }
        return result;
    }

    public static Boolean validateAuthor(String author, List<String> messages){
        Boolean result = true;

        if(String.isEmpty(author)) {
            result = false;
            messages.add('Please add author to book');
        }
        return result;
    }

    public static Boolean validateTitle(String title, List<String> messages){
        Boolean result = true;

        if(String.isEmpty(title)) {
            result = false;
            messages.add('Please add book title');
        }
        return result;
    }

    public static Boolean validatePublisher(String publisher, List<String> messages){
        Boolean result = true;

        if(String.isEmpty(publisher)) {
            result = false;
            messages.add('Please add book publisher');
        }
        return result;
    }

    public static Boolean validateYear(Date publishDate, List<String> messages){
        Boolean result = true;

        if(publishDate ==null || publishDate>date.today()) {
            result = false;
            messages.add('Please add publish date in past');
        }
        return result;
    }

    public static Boolean validateParentForTransalation(Book__c book, List<String> messages) {
        Boolean result = true;

        if (String.isEmpty(book.Translation__c)) {
            result = false;
            messages.add('Please add book language');
        }
        else{
            if (!'en_US'.equalsIgnoreCase(book.Translation__c) && book.Master_Book__c == null){
                result = false;
                messages.add('Please add master book record');
            }
        }
        return result;
    }
}