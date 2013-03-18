public with sharing class PagingController {
    public Integer currentPageNumber                {get; set;}
    public Integer pageSize                         {get; set;}
    private transient List<Merchandise__c> accs     {get; set;}
    public List<AccountWrapper> wraps               {get; set;}
    public Integer recordCount                      {get; set;}
    
    public Integer pageCount {
        get {
            return Math.mod(recordCount, pageSize) == 0 ?
                     recordCount / pageSize : recordCount / pageSize + 1;
        }
        set;
    }
    
    public Boolean hasNext {
        get {
            return currentPageNumber != pageCount;
        }
        set;
    }
    
    public Boolean hasPrevious {
        get {
            return currentPageNumber != 1;
        }
        set;
    }
    
    // For record limits
    public List<SelectOption> getItems(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('5','5'));
        options.add(new SelectOption('10','10'));
        options.add(new SelectOption('20','20'));
        options.add(new SelectOption('50','50'));
        options.add(new SelectOption('100','100'));
        return options;
    }
    
    class AccountWrapper {
        public Merchandise__c acc                   {get; set;}
        public Boolean isSelected                   {get; set;}
        
        public AccountWrapper(Merchandise__c a, Boolean isSelected) {
            this.acc = a;
            this.isSelected = isSelected;
        }
    }
    
    public PagingController() {
        pageSize = 5;
        currentPageNumber = 1;
        populateAccountWrappers();
    }
    
    public void populateAccountWrappers() {
        accs = [SELECT Id, Name, Total_Inventory__c, Price__c, Description__c FROM Merchandise__c];        
        recordCount = accs.size();
        Integer startNumber = 0;
        Integer endNumber = 0;
        if (currentPageNumber == pageCount) {
            startNumber = (currentPageNumber - 1) * pageSize;
            endNumber = recordCount;
        }
        else {
            startNumber = (currentPageNumber - 1) * pageSize;
            endNumber = currentPageNumber * pageSize;
        }
        
        wraps = new List<AccountWrapper>();
        if (accs.size() > 0) {
            for (Integer i = startNumber; i < endNumber; i++) {
                wraps.add(new AccountWrapper(accs[i], false));
            }
        }
    }
    
    public void first() {
        currentPageNumber = 1;
        populateAccountWrappers();
    }
    
    public void next() {
        currentPageNumber++;
        populateAccountWrappers();
    }
    
    public void previous() {
        currentPageNumber--;
        populateAccountWrappers();
    }
    
    public void last() {
        currentPageNumber = pageCount;
        populateAccountWrappers();
    }
    
    public void changePageSize() {
        currentPageNumber = 1;
        populateAccountWrappers();
    }
    
    public void changeCurrentPageNumber() {
        if (currentPageNumber > pageCount) {
            currentPageNumber = 1;
        }
        
        populateAccountWrappers();
    }
}
/*
public with sharing class PagingController {
    public Integer currentPageNumber                {get; set;}
    public Integer pageSize                         {get; set;}
    public List<Merchandise__c> accs                       {get; set;}
    public List<AccountWrapper> wraps               {get; set;}
    
    public Integer recordCount {
        get {
            return accs.size();
        }
        set;
    }
    
    public Integer pageCount {
        get {
            return Math.mod(recordCount, pageSize) == 0 ?
                     recordCount / pageSize : recordCount / pageSize + 1;
        }
        set;
    }
    
    public Boolean hasNext {
        get {
            return currentPageNumber != pageCount;
        }
        set;
    }
    
    public Boolean hasPrevious {
        get {
            return currentPageNumber != 1;
        }
        set;
    }
    
    // For record limits
    public List<SelectOption> getItems(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('5','5'));
        options.add(new SelectOption('10','10'));
        options.add(new SelectOption('20','20'));
        options.add(new SelectOption('50','50'));
        options.add(new SelectOption('100','100'));
        return options;
    }
    
    class AccountWrapper {
        public Merchandise__c acc                          {get; set;}
        public Boolean isSelected                   {get; set;}
        
        public AccountWrapper(Merchandise__c a, Boolean isSelected) {
            this.acc = a;
            this.isSelected = isSelected;
        }
    }
    
    public PagingController() {
        accs = [SELECT Id, Name FROM Merchandise__c LIMIT 1000];
        pageSize = 5;
        currentPageNumber = 1;
        populateAccountWrappers();
    }
    
    public void populateAccountWrappers() {
        Integer startNumber = 0;
        Integer endNumber = 0;
        if (currentPageNumber == pageCount) {
            startNumber = (currentPageNumber - 1) * pageSize;
            endNumber = recordCount;
        }
        else {
            startNumber = (currentPageNumber - 1) * pageSize;
            endNumber = currentPageNumber * pageSize;
        }
        
        wraps = new List<AccountWrapper>();
        for (Integer i = startNumber; i < endNumber; i++) {
            wraps.add(new AccountWrapper(accs[i], false));
        }
    }
    
    public void first() {
        currentPageNumber = 1;
        populateAccountWrappers();
    }
    
    public void next() {
        currentPageNumber++;
        populateAccountWrappers();
    }
    
    public void previous() {
        currentPageNumber--;
        populateAccountWrappers();
    }
    
    public void last() {
        currentPageNumber = pageCount;
        populateAccountWrappers();
    }
    
    public void changePageSize() {
        currentPageNumber = 1;
        populateAccountWrappers();
    }
    
    public void changeCurrentPageNumber() {
        if (currentPageNumber > pageCount) {
            currentPageNumber = 1;
        }
        
        populateAccountWrappers();
    }
}
*/