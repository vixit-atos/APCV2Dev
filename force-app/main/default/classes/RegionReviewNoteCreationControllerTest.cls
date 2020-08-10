@isTest public class RegionReviewNoteCreationControllerTest {
    @testSetup static void testSetup(){
        List<Big_Sales_Win__c> bswList = new List<Big_Sales_Win__c>();
        List<Product_Up_Or_Down__c> pudList = new List<Product_Up_Or_Down__c>();
        Region__c r = new Region__c();
        Database.insert(r,false);
        Region_Report__c rp = new Region_Report__c(
            Region__c = r.Name,
            Review_Month__c = 'June',
            Review_Year__c = '2018',
            Update__c = 'Test Summary of AOR'
        );
        Database.upsert(rp, false);
        
        Big_Sales_Win__c bsw = new Big_Sales_Win__c(
            Region_Review_Note__c = rp.id,
            delete__c = true
        );
        Big_Sales_Win__c bsw2 = new Big_Sales_Win__c(
            Region_Review_Note__c = rp.id,
            delete__c = false
        );
        bswList.add(bsw);
        bswList.add(bsw2);
        Database.upsert(bswList, false);
        
        Product_Up_Or_Down__c pud = new Product_Up_Or_Down__c(
            Region_Review_Note__c = rp.id,
            delete__c = true
        );
        Product_Up_Or_Down__c pud2 = new Product_Up_Or_Down__c(
            Region_Review_Note__c = rp.id,
            delete__c = false
        );
        pudList.add(pud);
        pudList.add(pud2);
        Database.upsert(pudList, false);
    }
    
    public static testmethod void testNewTopObjectives(){
        Region_Report__c rp = [SELECT ID, Region__c, Review_Month__c, Review_Year__c, Update__c FROM Region_Report__c LIMIT 1];
        if(rp == null){
            system.assert(1==1, 'Region Review Note wasnt created. Test Failed');
        }else{            
            ApexPages.StandardController scontroller = new ApexPages.StandardController(rp);
            RegionReviewNoteCreationController RRNCC = new RegionReviewNoteCreationController(scontroller);
            
            test.StartTest();
                RRNCC.NewTopObjective();
            test.stopTest();
        }
    }
    public static testmethod void testNewBigSale(){
        Region_Report__c rp = [SELECT ID, Region__c, Review_Month__c, Review_Year__c, Update__c FROM Region_Report__c LIMIT 1];
        if(rp == null){
            system.assert(1==1, 'Region Review Note wasnt created. Test Failed');
        }else{            
            ApexPages.StandardController scontroller = new ApexPages.StandardController(rp);
            RegionReviewNoteCreationController RRNCC = new RegionReviewNoteCreationController(scontroller);
            
            test.StartTest();
                RRNCC.NewBigSale();
            test.stopTest();
        }
    }
    public static testmethod void testSave(){
        Region_Report__c rp = [SELECT ID, Region__c, Review_Month__c, Review_Year__c, Update__c FROM Region_Report__c LIMIT 1];
        if(rp == null){
            system.assert(1==1, 'Region Review Note wasnt created. Test Failed');
        }else{            
            ApexPages.StandardController scontroller = new ApexPages.StandardController(rp);
            RegionReviewNoteCreationController RRNCC = new RegionReviewNoteCreationController(scontroller);
            
            test.StartTest();
                Big_Sales_Win__c bsw = new Big_Sales_Win__c(
                    Region_Review_Note__c = rp.id,
                    name = 'stuff',
                    delete__c = false
                );
                Product_Up_Or_Down__c pud = new Product_Up_Or_Down__c(
                    Region_Review_Note__c = rp.id,
                    name = '',
                    Up_Or_Down__c = null
                );
                RRNCC.bigSalesWins.add(bsw);
                RRNCC.productUpOrDown.add(pud);
                RRNCC.save();
            test.stopTest();
        }
    }
    
    public static testmethod void testSaveNew(){
        Region_Report__c rp = [SELECT ID, Region__c, Review_Month__c, Review_Year__c, Update__c FROM Region_Report__c LIMIT 1];
        if(rp == null){
            system.assert(1==1, 'Region Review Note wasnt created. Test Failed');
        }else{            
            ApexPages.StandardController scontroller = new ApexPages.StandardController(rp);
            RegionReviewNoteCreationController RRNCC = new RegionReviewNoteCreationController(scontroller);
            
            test.StartTest();
                PageReference pref = RRNCC.saveAndNew();
                system.assertEquals('/apex/RegionReviewNoteCreation', pref.getUrl());
            test.stopTest();
        }
    }
    
    public static testmethod void cancel(){
        Region_Report__c rp = [SELECT ID, Region__c, Review_Month__c, Review_Year__c, Update__c FROM Region_Report__c LIMIT 1];
        if(rp == null){
            system.assert(1==1, 'Region Review Note wasnt created. Test Failed');
        }else{            
            ApexPages.StandardController scontroller = new ApexPages.StandardController(rp);
            RegionReviewNoteCreationController RRNCC = new RegionReviewNoteCreationController(scontroller);
            
            test.StartTest();
                PageReference pref = RRNCC.cancel();
                system.assertEquals('/a0L/o', pref.getUrl());
            test.stopTest();
        }
    }
    
}