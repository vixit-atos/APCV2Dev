/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Purpose:
* This class is used as an controller for the vf page -RegionReviewNoteCreation- which is used to
* Maintain Region Review Notes
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Chris
* @modifiedBy          
* @version        1.0
* @created        
* @modified       09-04-2018
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @modifiedBy     Chris    
* @version        1.1
* @created        
* @modified       04-03-2019
* Added Updates to both Saved Products and Saved Big Sales Wins
* __________________________________________________________________________________________________
*/
public class RegionReviewNoteCreationController {
    public List<Product_Up_Or_Down__c> productUpOrDown {get;set;}//List of Products with up and down for the region review note
    public List<Big_Sales_Win__c> bigSalesWins{get;set;}//List of Big Sales Wins for the Region review note
    public List<Product_Up_Or_Down__c> savedUpOrDown {get;set;}//List of previously saved Up/Downs
    public List<Big_Sales_Win__c> savedBigSales{get;set;}//List of previously saved Big Sales Wins
    public Region_Report__c newRecord {get;set;}//Placeholder for the new record if initializing
    protected ApexPages.StandardController controller;//Used as a base for the extension controller
    public ID recordID{get;set;}//Current Record from the Controller
    
    public RegionReviewNoteCreationController(ApexPages.StandardController controller){
        this.newRecord = new Region_Report__c();
        this.controller = controller;
        this.recordID = controller.getRecord().id;
        this.productUpOrDown = new List<Product_Up_Or_Down__c>();
        this.savedUpOrDown = new List<Product_Up_Or_Down__c>();
        this.bigSalesWins = new List<Big_Sales_Win__c>();
        this.savedBigSales = new List<Big_Sales_Win__c>();

        if(recordID != null){
            savedUpOrDown = [SELECT Name, Up_Or_Down__c, Percentage__c, Note__c, Delete__c FROM Product_Up_Or_Down__c WHERE Region_Review_Note__c =: recordID];
            savedBigSales = [SELECT Name, Customer__c, Dealer_Name__c, Amount__c, Note__c, Delete__c FROM Big_Sales_Win__c WHERE Region_Review_Note__c =: recordID];
        }  
        
        if(savedUpOrDown.size() == 0){ productUpOrDown.add(new Product_Up_Or_Down__c()); }
        if(savedBigSales.size() == 0){ bigSalesWins.add(new Big_Sales_Win__c()); }
    }
    
    public PageReference save(){
        List<ID> deleteIDList = new List<ID>();//List to gather IDs to delete
        PageReference newRecordPage = controller.save();//Redirect for after the save
        for (Integer i =  bigSalesWins.size() - 1; i >= 0 ; --i) {
            if ((bigSalesWins.get(i).name == null && bigSalesWins.get(i).Customer__c == null && bigSalesWins.get(i).Dealer_Name__c == null && bigSalesWins.get(i).Amount__c == null && bigSalesWins.get(i).Note__c == null) ) {
                bigSalesWins.remove(i); 
            }
        }
        for (Integer i =  productUpOrDown.size() - 1; i >= 0 ; --i) {
            if ((productUpOrDown.get(i).name == '' && productUpOrDown.get(i).Up_Or_Down__c == null) ) {
                system.debug('productUpOrDown getting removed');
                productUpOrDown.remove(i); 
            }
        }
        if (productUpOrDown.size() > 0 ){
            for (Product_Up_Or_Down__c PUD: productUpOrDown){
                PUD.Region_Review_Note__c = controller.getRecord().id;
            }
            insert productUpOrDown;
        }
        if (bigSalesWins.size() > 0){
            for (Big_Sales_Win__c bsw: bigSalesWins){
                bsw.Region_Review_Note__c = controller.getRecord().id;
            }
            insert bigSalesWins;
        }
        if(savedBigSales.size() > 0){
            for(Big_Sales_Win__c bsw : savedBigSales){
                if(bsw.delete__c == true){
                    deleteIDList.add(bsw.id);
                }
            }
            update savedBigSales;
        }
        if(savedUpOrDown.size() > 0){
            for(Product_Up_Or_Down__c pud : savedUpOrDown){
                if(pud.delete__c == true){
                    deleteIDList.add(pud.id);
                }
            }
            update savedUpOrDown;
        }
        if(deleteIDList.size() > 0){
            Database.delete(deleteIDList, false);
        }
        return newRecordPage;
    }
    
    public PageReference saveAndNew(){
        save();
        PageReference newpage = new PageReference('/apex/RegionReviewNoteCreation');//Redirects to a new Note Creation
        newpage.setRedirect(true);
        return newpage;
    }
    
    public PageReference cancel(){  return new PageReference('/a0L/o');}//Returns to the Region Review Note page
    
    public void NewTopObjective(){  productUpOrDown.add(new Product_Up_Or_Down__c());}
    
    public void NewBigSale(){   bigSalesWins.add(new Big_Sales_Win__c());}
    
    
    
    /*Save for lightning Component?
    @AuraEnabled
    public static Id createRegionReviewNote(Region_Report__c regionObj){        
        upsert regionObj;
        System.debug(regionObj);
        return regionObj.id;
    }
    
    @AuraEnabled
    public static List<String> getReviewMonthOptions(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Region_Report__c.Review_Month__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
        return options;
    }
    
    @AuraEnabled
    public static List<String> getReviewYearOptions(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Region_Report__c.Review_Year__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
        return options;
    }
    
    
    @AuraEnabled
    public static void test(String regionObj){        
        //upsert regionObj;
        System.debug(regionObj);
        //return regionObj.id;
    }
    
    @AuraEnabled
    public static void save(Region_Report__c insertRegionReviewNote, String reviewMonth, String reviewYear){
     
        /*System.debug('Review Month: ' + reviewMonth);
        System.debug('Review Year: ' + reviewYear);
        insertRegionReviewNote.Review_Month__c = reviewMonth;
          insertRegionReviewNote.Review_Year__c = reviewYear;
           System.debug('RegionReviewNote: ' + insertRegionReviewNote);
      //  insert  insertRegionReviewNote;
       //  System.debug('id: ' + insertRegionReviewNote.id);
        //upsert updatedDVS;
        }
    */
    
}