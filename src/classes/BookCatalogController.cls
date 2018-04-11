public with sharing class BookCatalogController {
    public Book__c book { get; set; }
    public string genre { get; set; }
    public string selectedBookId { get; set; }
    public Boolean isListVisible { get; set; }

    public BookCatalogController() {
        String bookId = ApexPages.currentPage().getParameters().get('id');
        if (String.isNotBlank(bookId)) {
            this.book = queryForBook(bookId);
        } else {
            this.book = new Book__c();
        }
        this.book.Translation__c = (String) Book__c.Translation__c.getDescribe().getDefaultValue();
        this.isListVisible = false;
    }

    public List<Book__c> getBooksList() {
        return [
            Select Id, Name, Master_Book__c, RecordTypeId, Author__c, ISBN__c, Publisher__c, Year__c,
                Translation__c, Description__c
            from Book__c
            WHERE RecordTypeId = :genre
            limit 1000
        ];
    }
    public list<SelectOption> getGenres() {
        list<SelectOption> options = new list<SelectOption>{
            new SelectOption('', '')
        };
        for (RecordType sRecordType : [SELECT Id, Name FROM RecordType WHERE sObjectType = 'Book__c']) {
            options.add(new SelectOption(sRecordType.Id, sRecordType.Name));
        }
        return options;
    }

    public void changeCategory() {
        this.isListVisible = true;
    }

    public PageReference newBook() {
        PageReference redirectToPage = Page.bookEdit;
        redirectToPage.setRedirect(true);
        return redirectToPage;
    }
    public PageReference goBack() {
        PageReference redirectToPage = Page.bookCatalog;
        redirectToPage.setRedirect(true);
        return redirectToPage;
    }

    public PageReference viewBooks() {
        PageReference redirectToPage = Page.booksList;
        redirectToPage.setRedirect(true);
        return redirectToPage;
    }

    public PageReference editBook() {
        PageReference redirectToPage;
        if (String.isNotBlank(book.Id)) {
            redirectToPage = Page.bookEdit;
            redirectToPage.getParameters().put('id', book.Id);
            redirectToPage.setRedirect(true);
        }
        return redirectToPage;
    }
    public PageReference editBookBasedOnId() {
        PageReference redirectToPage;
        if (String.isNotBlank(selectedBookId)) {
            redirectToPage = Page.bookEdit;
            redirectToPage.getParameters().put('id', selectedBookId);
            redirectToPage.setRedirect(true);
        }
        return redirectToPage;
    }

    public PageReference deleteBook() {
        PageReference redirectToPage;
        if (String.isNotBlank(book.Id)) {
            delete book;
            redirectToPage = Page.bookCatalog;
            redirectToPage.setRedirect(true);
        }
        return redirectToPage;
    }
    public PageReference deleteBookBasedOnId() {
        PageReference redirectToPage;
        if (String.isNotBlank(selectedBookId)) {
            delete new Book__c(Id = selectedBookId);
            redirectToPage = Page.bookCatalog;
            redirectToPage.setRedirect(true);
        }
        return redirectToPage;
    }

    public PageReference saveBook() {
        upsert book;
        PageReference redirectToPage = Page.bookDetails;
        redirectToPage.getParameters().put('id', book.Id);
        redirectToPage.setRedirect(true);
        return redirectToPage;
    }
    public PageReference showDetailPage() {
        PageReference redirectToPage;
        if (String.isNotBlank(book.Id)) {
            redirectToPage = Page.bookDetails;
            redirectToPage.getParameters().put('id', book.Id);
        }
        redirectToPage.setRedirect(true);
        return redirectToPage;
    }

    public PageReference showDetailPageBasedOnId() {
        PageReference redirectToPage;
        if (String.isNotBlank(selectedBookId)) {
            redirectToPage = Page.bookDetails;
            redirectToPage.getParameters().put('id', selectedBookId);
        }
        redirectToPage.setRedirect(true);
        return redirectToPage;
    }

    private Book__c queryForBook(Id bookId) {
        List<Book__c> booksList = [
            SELECT Id, Name, Master_Book__c, RecordTypeId,Author__c, ISBN__c, Publisher__c, Year__c,
                Translation__c, Description__c
            FROM Book__c
            WHERE Id = :bookId
        ];
        if (booksList.isEmpty()) {
            return null;
        }
        return booksList.get(0);
    }
}