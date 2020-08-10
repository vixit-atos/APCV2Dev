@isTest public class FileManagementController_Test{
    @TestSetup static void FileManagementControllerSetup(){
        String aoraName = 'ZYGD';
        List<Account> acctList = new List<Account>();
        List<Private_Note__c> pnList = new List<Private_note__c>();
        List<Account> aoraAcctList = new List<Account>();
        List<ContentVersion> cvInsertList = new List<ContentVersion>();
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        List<Folder__c> folderInsertList = new List<Folder__c>();
        List<ID> cvIDs = new List<ID>();
        
        Account aoraAcct = new Account(
            Dealer_Code__c = aoraName,
            Name = 'AORA Test'
        );
        acctList.add(aoraAcct);
        
        Account nonacct = new Account(
            Dealer_Code__c = '',
            Name = 'Test');
        acctList.add(nonacct);
        insert acctList;
        
        acctList = [SELECT ID FROM Account WHERE Name LIKE '%AORA%' LIMIT 1];
        ID aoraAccountID = acctList[0].id;
        
        Contact cont = new Contact(
            LastName = 'T3st',
            Phone = '0000000000'
        );
        insert cont;
        
        Private_Note__c AoraPN = new Private_note__c(
            Body__c = aoraName,
            Name = 'AORA Report May2018-22C7',
            Account_RL__c = aoraAccountID
        );
        pnList.add(Aorapn);
        
        Private_Note__c nonAORAPN = new Private_Note__c(
            Body__c = 'Test',
            Name = 'Test',
            Account_RL__c = aoraAccountID
        );
        pnList.add(nonAORAPN);
        insert pnList;
        
        Folder__c aoraFolder = new Folder__c(
            Name = 'Aora Report Mar2018',
            Type__c = 'AORA'
        );
        folderInsertList.add(aoraFolder);
       
        /*Example of folder for Contact
        Folder__c contactFolder = new Folder__c();
        contactFolder.Name = 'Files For Contacts';
        contactFolder.Type__c = 'Contact';  
        folderInsertList.add(contactFolder);
        */
        /*Example of another folder for objects without private notes
        Folder__c objectFolder = new Folder__c();
        objectFolder.Name = 'Files For Objects';
        objectFolder.Type__c = 'Object';
        folderInsertList.add(ObjectFolder);
        */
        
        insert folderInsertList;
    }
    static testmethod void testMigrateFileToAccountAORA(){
        test.startTest();
        List<ContentVersion> cvInsertList = new List<ContentVersion>();
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        List<ID> cvIDs = new List<ID>();
        List<Folder__c> folder = [SELECT ID FROM Folder__c];
        String aoraName = 'ZYGD';
        ContentVersion aoraCV = new ContentVersion(
            Title = aoraName,
            PathOnClient = 'ZYGD.pdf',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        cvInsertList.add(aoraCV);
        ContentVersion aoraCVFail = new ContentVersion(
            Title = '1234',
            PathOnClient = '1234.pdf',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        cvInsertList.add(aoraCVFail);
        insert cvInsertList;
        List<ContentVersion> cvList = [SELECT ID, ContentDocumentID, Title FROM ContentVersion WHERE FileType ='PDF' AND Title LIKE '____'];
        for(ContentVersion cv : cvList){
            cvIDs.add(cv.ContentDocumentID);
        }
        for(ContentVersion cv : cvList){
            ContentDocumentLink cdl = new ContentDocumentLink(
                LinkedEntityID = folder[0].id,
                ContentDocumentID = cv.ContentDocumentID,
                ShareType = 'V'
            );
            cdlList.add(cdl);
        }
        insert cdlList;
        List<Folder__c> folderIDFromList = [Select ID from Folder__c WHERE Name LIKE '%AORA%'];
        ApexPages.StandardController sc = new ApexPages.StandardController(folderIDFromList[0]);
        FileManagementController fmc = new FilemanagementController(sc);
        List<Private_Note__c> pnList = [Select ID, Name from Private_Note__c];
        cvList = [Select ID, Title, ContentDocumentID From contentVersion];
        
        List<ID> cvdlist = new List<Id>();
        for(ContentVersion cv1 : cvlist){
            cvdlist.add(cv1.ContentDocumentID);
        }
        cdlList =[Select ContentDocumentID, linkedEntityID from contentdocumentLink where ContentDocumentID =: cvdlist];
        fmc.migrate();
        test.stopTest();
        fmc.getProgress();
        List<ContentDocumentLink> cdlAfterList = [Select ContentDocumentID, linkedEntityID from contentdocumentLink where ContentDocumentID =: cvdlist];
        List<Private_note__c> pnAfterList = [Select ID, Name From private_note__c];       
        system.assertNotEquals(pnList.size(), pnAfterList.size());
        system.assertNotEquals(cdlList.size(), cdlAfterList.size());   
        //system.assertEquals('Completed', fmc.jobInfo.Status);
        
    }
    static testmethod void testAORAPurge(){
        test.startTest();
        List<ContentVersion> cvInsertList = new List<ContentVersion>();
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        List<ID> cvIDs = new List<ID>();
        List<Folder__c> folder = [SELECT ID FROM Folder__c];
        String aoraName = 'ZYGD';
        ContentVersion aoraCV = new ContentVersion(
            Title = aoraName,
            PathOnClient = 'ZYGD.pdf',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        cvInsertList.add(aoraCV);
        ContentVersion aoraCVFail = new ContentVersion(
            Title = '1234',
            PathOnClient = '1234.pdf',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        cvInsertList.add(aoraCVFail);
        insert cvInsertList;
        List<ContentVersion> cvList = [SELECT ID, ContentDocumentID, Title FROM ContentVersion WHERE FileType ='PDF' AND Title LIKE '____'];
        for(ContentVersion cv : cvList){
            cvIDs.add(cv.ContentDocumentID);
        }
        for(ContentVersion cv : cvList){
            ContentDocumentLink cdl = new ContentDocumentLink(
                LinkedEntityID = folder[0].id,
                ContentDocumentID = cv.ContentDocumentID,
                ShareType = 'V'
            );
            cdlList.add(cdl);
        }
        insert cdlList;
        List<Folder__c> folderIDFromList = [Select ID from Folder__c WHERE Name LIKE '%AORA%'];
        ApexPages.StandardController sc = new ApexPages.StandardController(folderIDFromList[0]);
        FileManagementController fmc = new FileManagementController(sc);
        List<Private_Note__c> pnList = [Select ID, Name from Private_Note__c];
        cvList = [Select ID, Title, ContentDocumentID From contentVersion];
        
        List<ID> cvdlist = new List<Id>();
        for(ContentVersion cv1 : cvlist){
            cvdlist.add(cv1.ContentDocumentID);
        }
        cdlList =[Select ContentDocumentID, linkedEntityID from contentdocumentLink where ContentDocumentID =: cvdlist];
        fmc.purgeAORA();
        test.stopTest();
        List<ContentDocumentLink> cdlAfterList = [Select ContentDocumentID, linkedEntityID from contentdocumentLink where ContentDocumentID =: cvdlist];
        List<Private_note__c> pnAfterList = [Select ID, Name From private_note__c];
        system.assertNotEquals(pnList.size(), pnAfterList.size());
        system.assertNotEquals(cdlList.size(), cdlAfterList.size());     
        
    }
    static testmethod void testMigrateNoFiles(){
        test.startTest();
        List<Folder__c> folderIDFromList = [Select ID from Folder__c WHERE Name LIKE '%AORA%'];
        ApexPages.StandardController sc = new ApexPages.StandardController(folderIDFromList[0]);
        FileManagementController fmc = new FileManagementController(sc);
        fmc.migrate();
        test.stopTest();
    }
    static testmethod void testPoll(){
        test.startTest();
        List<Folder__c> folderIDFromList = [Select ID from Folder__c WHERE Name LIKE '%AORA%'];
        ApexPages.StandardController sc = new ApexPages.StandardController(folderIDFromList[0]);
        FileManagementController fmc = new FileManagementController(sc);
        fmc.getProgress();
        test.stopTest();
    }
    /*
    static testmethod void testMigrateFileToContact(){}
    static testmethod void testMigratefileToAccountNonAora(){}
    static testmethod void testMigrateFileToNoPrivateNote(){}
    */
}