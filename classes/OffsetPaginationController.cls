public with sharing class OffsetPaginationController {
    public Integer pageSize                {get; set;}
    public Integer currentPageNumber       {get; set;}
    Integer recordCount;
    Integer offset;
    
    String queryString = 'SELECT Id, Name, Total_Inventory__c, Price__c, Description__c ' +
                         'FROM Merchandise__c ORDER BY Name ';
    
    public OffsetPaginationController() {
        currentPageNumber = 1;
        pageSize = 5;
        offset = 0;
        recordCount = [SELECT Count() FROM Merchandise__c];
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
    
    public List<Merchandise__c> getRecords() {
        System.debug(queryString + + ' LIMIT ' + pageSize + ' OFFSET ' + offset);
        return Database.query(queryString + ' LIMIT ' + pageSize + ' OFFSET ' + offset);
    }
    
    public void first() {
        offset = 0;
        currentPageNumber = 1;
    }
    
    public void next() {
        currentPageNumber++;
        offset += pageSize;
    }
    
    public void previous() {
        currentPageNumber--;
        offset -= pageSize;
    }
    
    public void last() {
        if (Math.Mod(recordCount, pageSize) == 0) {
            offset = pageSize * (pageCount - 1);
            currentPageNumber = recordCount / pageSize;
        }
        else {
            offset = pageSize * pageCount;
            currentPageNumber = recordCount / pageSize + 1;
        }
    }
    
    public void changePageSize() {
        currentPageNumber = currentPageNumber > pageCount ? pageCount : currentPageNumber;
        offset = pageSize * (currentPageNumber - 1);
    }
    
    public void changeCurrentPageNumber() {
        if (currentPageNumber <= 0) {
            currentPageNumber = 1;
        }
        
        if (currentPageNumber > pageCount) {
            currentPageNumber = pageCount;
        }
        
        offset = pageSize * (currentPageNumber - 1);
    }
    
    public Integer pageCount {
        get {
            return Math.mod(recordCount, pageSize) == 0 ? recordCount / pageSize : recordCount / pageSize + 1;
        }
    }
    
    public Boolean hasPrevious {
        get {
            return currentPageNumber > 1;
        }
    }
    
    public Boolean hasNext {
        get {
            return currentPageNumber < pageCount;
        }
    }
}