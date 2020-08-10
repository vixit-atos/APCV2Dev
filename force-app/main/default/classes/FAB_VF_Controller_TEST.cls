@isTest public class FAB_VF_Controller_TEST {
    @testSetup static void setup(){
        test.StartTest();
        List<Note> nList = new List<Note>();
        RecordType rt = [Select ID, name from recordtype where sobjectType = 'Opportunity' and Name = 'Customer Focused Request'];
        Opportunity opp = new Opportunity();
        opp.Name = 'test';
        opp.StageName = 'new';
        opp.closedate = Date.today()+1;
        opp.RecordTypeId = rt.id;
        insert opp;

        List<Product2> plist = new List<product2>();
        
        Product2 prod = new Product2();
        prod.Name = '108SD';
        prod.Family = 'Freightliner';
        prod.isActive = true;
        plist.add(prod);
        
        Product2 prod2 = new Product2();
        prod2.Name = 'New Cascadia';
        prod2.Family = 'Freightliner';
        prod2.isActive = true;
        plist.add(prod2);
        
        Product2 prod3 = new Product2();
        prod3.Name = 'Classic Cascadia';
        prod3.Family = 'Freightliner';
        prod3.isActive = true;
        plist.add(prod3);
        
        Product2 prod4 = new Product2();
        prod4.Name = '4700';
        prod4.Family = 'Western Star';
        prod4.isActive = true;
        plist.add(prod4);
        insert plist;
        
        Pricebook2 pb = new Pricebook2();
        pb.isActive = true;
        pb.Name = 'No';
        insert pb;
        
        Id pbs = test.getStandardPricebookId();
        
        List<pricebookentry> pbeList = new List<Pricebookentry>();

        for(Product2 p : plist){
            PricebookEntry pbe = new PricebookEntry();
            pbe.Product2Id = p.Id;
            pbe.Pricebook2Id = pbs;
            pbe.UnitPrice = 1337;
            pbe.UseStandardPrice = false;
            pbe.isActive = true;
            pbeList.add(pbe);
        }
        insert pbeList;

        List<pricebookentry> pbeList2 = new List<Pricebookentry>();
        for(Product2 p : plist){
            PricebookEntry pbe = new PricebookEntry();
            pbe.Product2Id = p.Id;
            pbe.Pricebook2Id = pb.id;
            pbe.UnitPrice = 1337;
            pbe.UseStandardPrice = false;
            pbe.isActive = true;
            pbeList2.add(pbe);
        }
        insert pbeList2;

        List<opportunityLineItem> oliList = new List<opportunityLineItem>();
        for(pricebookentry pbe : pbeList2){
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.OpportunityId = opp.id;
            oli.quantity = 1337;
            oli.totalPrice = 1337;
            oli.PricebookEntryId = pbe.Id;
            oliList.add(oli);
        }
        insert oliList;
        
        Milestone__c m = new Milestone__c();
        m.Name = 'Changeover';
        m.Opportunity__c = opp.id;
        m.Deadline__c = Date.Today();
        insert m;
        
        Note n = new Note();
        n.Title = 'Test';
        n.Body = '1';
        n.parentId = opp.id;
        nList.add(n);
        
        Note n2 = new Note();
        n2.Title = 'Test2';
        n2.Body = '2';
        n2.ParentId = opp.Id;
        nList.add(n2);
        insert nList;
        test.stopTest();
        
        List<ContentVersion> cvList = new List<ContentVersion>();
        
        ContentVersion v = new ContentVersion();//Used to create a ContentVersion for the uploaded file blob
        Blob imageblob = Blob.valueOf('1');
        v.versionData = imageblob;
        v.title = 'testFAB.png';
        v.pathOnClient = 'testFAB.png';
        v.description = 'FAB';
        cvList.add(v);
        
        ContentVersion v2 = new ContentVersion();//Used to create a ContentVersion for the uploaded file blob
        Blob imageblob2 = Blob.valueOf('2');
        v2.versionData = imageblob2;
        v2.title = 'test2FAB.png';
        v2.pathOnClient = 'test2FAB.png';
        v2.description = 'FAB';
        cvList.add(v2);
        insert cvList;

        List<contentVersion> vList = [select id, contentdocumentId from ContentVersion];
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        for(ContentVersion cv : vList){
            ContentDocumentLink cdl = New ContentDocumentLink();//Used to link the ContentVersion(v) to the Opportunity
            cdl.LinkedEntityId = opp.Id;
            cdl.ContentDocumentId = cv.ContentDocumentId;
            cdl.sharetype = 'v';
            cdlList.add(cdl);
        }
        insert cdlList;
        
        ContentNote cn = new ContentNote();
        cn.Title='Test';
        cn.content = Blob.valueOf('1');
        insert cn;
        
        contentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = opp.Id;
        cdl.ContentDocumentId = cn.Id;
        cdl.shareType='v';
        insert cdl;

    }
    
    static testMethod void testConstructor(){
        test.StartTest();
        Opportunity opp = [Select ID From opportunity LIMIT 1];
        ContentWorkspace cw = [select id, name from contentworkspace where Name = 'Model Images' LIMIT 1];
        list<ContentDocumentLink>cd = [select contentdocumentId from contentdocumentlink where linkedEntityId = :cw.id];
        
        ContentVersion v = new ContentVersion();//Used to create a ContentVersion for the uploaded file blob
        Blob imageblob = Blob.valueOf('108SD');
        v.versionData = imageblob;
        v.title = '108SD';
        v.pathOnClient = '108SD';
        insert v;
        
        v = [select id, contentdocumentId from contentVersion where title = '108SD' limit 1];
        contentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = cw.Id;
        cdl.ContentDocumentId = v.ContentDocumentId;
        cdl.shareType='I';
        insert cdl;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        FAB_VF_Controller fvc = new FAB_VF_Controller(sc);
        test.StopTest();
    }
    
    static testMethod void testTheSOP(){
        Test.startTest();
        Opportunity opp = [Select ID From opportunity LIMIT 1];
        String d = FAB_VF_Controller.fetchTheAURASOP(Opp.id);
        System.AssertEquals(d, Date.Today().format());
        Test.stopTest();
    }
    
    static testMethod void testImages(){
        test.startTest();
        Opportunity opp = [Select ID From Opportunity LIMIT 1];
        Id image = FAB_VF_Controller.fetchImage(opp.Id);
        System.AssertNotEquals(image, null);
        test.stopTest();
    }
    
    static testMethod void testGetAllImages(){
        test.StartTest();
        Opportunity opp = [Select ID From opportunity LIMIT 1];
        List<String> image = FAB_VF_Controller.fetchImages(opp.Id);
        system.assertNotEquals(0, image.size());
    }
    
    static testMethod void testCreateNote(){
        test.StartTest();
        Opportunity opp = [Select ID From opportunity LIMIT 1];
        FAB_VF_Controller.createContentNote(opp.Id, 'Test3', '2');
    }
    static testMethod void testUpdateNote(){
        test.StartTest();
        Opportunity opp = [Select ID From opportunity LIMIT 1];
        FAB_VF_Controller.createContentNote(opp.Id, 'Test', 'saaa dude');
    }
    
    static testMethod void testFoundNote(){
        test.StartTest();
        Opportunity opp = [Select ID From opportunity LIMIT 1];
        Note n = new Note();
        n.Title = 'What is it?';
        n.Body = '1';
        n.parentId = opp.id;
        insert n;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        FAB_VF_Controller fvc = new FAB_VF_Controller(sc);
        test.stopTest();
    }
}