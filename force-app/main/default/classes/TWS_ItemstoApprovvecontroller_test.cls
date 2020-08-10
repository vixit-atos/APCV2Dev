@isTest
public class TWS_ItemstoApprovvecontroller_test {
    static testMethod void testMyApprovals() {
        TWS_ItemstoApprovvecontroller.runningInTestMode = true;
        try{
            TWS_ItemstoApprovvecontroller Iteamsappcontroller = new TWS_ItemstoApprovvecontroller();
        }catch(Exception e){
            system.debug('e'+e );
        }
    } 
    
    static testMethod void ItemstoApprovve() {
        
        Test.startTest(); //switch to testing context
        
        Profile p = [SELECT Id FROM Profile WHERE Name='TWS/TC - Super User']; 
        
        
        User umgr = new User(Alias = 'mstandt', Email='manafer@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='manafer@testorg.com');
        
        insert umgr ;
        system.debug('user manager'+umgr );
        
        User u = new User(Alias = 'Hareesh', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduseffr@testorg.com', managerid=umgr.id );
        insert u;
        List<User> lstUser=new List<User>();
        //lstUser.add(u);
        //insert lstUser;
        system.debug('user iiiiiiiiii'+u);
        system.debug('umgr.id iiiiiiiiii'+u.managerid);
        Account ac = new Account();
        ac.name  = 'DummyAccount';
        // you may need to populate additional required fields on the account object for your org
        insert ac; 
        
        RecordType Rd = [select id,name from recordtype where sobjecttype='Opportunity' AND name = 'TWS-Direct TC'];
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.Account=ac;
        opp.Amount = 100;
        opp.CloseDate = Date.today();
        opp.Probability = 10;
        opp.StageName = 'Ready for TCM';
        opp.RecordtypeId=Rd.id;
        // insert the new opp
        insert opp;
        // change the probability of the opp so the trigger submits it for approval
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Opp';
        opp1.Amount = 100;
        opp1.CloseDate = Date.today();
        opp1.Probability = 10;
        opp1.StageName = 'Ready for TCM';
        opp1.TC_Meeting_Notes__c='opp1TC_Meeting_Notes__c';
        
        opp1.RecordtypeId=Rd.id;
        opp.Account=ac;
        
        // insert the new opp
        insert opp1;
        
        List<Opportunity > lstOpy=new List<Opportunity>();
        lstOpy.add(opp1);
        lstOpy.add(opp);
        
        // ensure that the opp was submitted for approval
        // ProcessInstanceWorkItem processInstances = [select Id,CreatedDate from ProcessInstanceWorkItem  limit 1];
        system.debug('123123'+opp1.Id);
        Opportunity objoppy= [SELECT Id, CreatedDate FROM Opportunity  WHERE Id = :opp1.Id];
        system.debug('123123objoppy'+objoppy.Id);
        System.runAs(u) {
            if([select count() from ProcessInstance where targetobjectid=:objoppy.id] < 1) {
                Approval.ProcessSubmitRequest testReq = new Approval.ProcessSubmitRequest();
                testReq.setObjectId(objoppy.Id);
                testReq.setComments('Submitting request for approval.');
                system.debug('123123'+u.managerid);
                system.debug('123123'+u.LastName);
            }
            
            // testReq.setNextApproverIds(lstUser);
            // Approval.ProcessResult reqResult = Approval.process(testReq);
            
            // ProcessInstanceWorkitem workItem = [Select Id,actorid FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = : objoppy.Id AND ActorId = :userinfo.getuserid()];
            // ProcessInstance pi = [SELECT id,TargetObjectId, CreatedDate FROM ProcessInstance WHERE TargetObjectId = :opp1.Id];
            // ID Processwi= reqResult.getNewWorkitemIds()[0];
            //        system.debug('123123 pi '+Processwi);
            ApexPages.StandardController sc = new ApexPages.StandardController(opp1);
            TWS_ItemstoApprovvecontroller testAccPlan = new TWS_ItemstoApprovvecontroller(sc);
            TWS_ItemstoApprovvecontroller Iteamsappcontroller = new TWS_ItemstoApprovvecontroller();
            Iteamsappcontroller.Objectopportunity=opp1;
            Iteamsappcontroller.lstopportunityapprove=lstOpy;
            /* Iteamsappcontroller.testing1='test';
Iteamsappcontroller.testing2='test';
Iteamsappcontroller.testing3='test';
Iteamsappcontroller.testing4='test'; */
            Concession__c objcon=new Concession__c();
            objcon.name='Contest';
            objcon.CONC_STATUS_CD__c='PNC';
            insert objcon;
            Concession__c objcon1=new Concession__c();
            objcon1.name='Contest1';
            objcon1.CONC_STATUS_CD__c='PNC';
            insert objcon1;
            List<Concession__c> lstConcession=new List<Concession__c>();
            lstConcession.add(objcon);
            lstConcession.add(objcon1);
            TWS_ItemstoApprovvecontroller.ApproveRejectnavigation();
            TWS_ItemstoApprovvecontroller.REASSIGNnavigation();
            TWS_ItemstoApprovvecontroller.Manageall();
            Date dateTimeValue = system.today();
            TWS_ItemstoApprovvecontroller.item_wrapper  wraper=new TWS_ItemstoApprovvecontroller.item_wrapper(opp.id,opp.name,'opportunity','12/11/2016 12:32 AM',opp1.TC_Meeting_Notes__c,opp.id,objcon1.CONC_STATUS_CD__c,'','',0.1);
            Test.stopTest(); //switch to testing context
        }
    } 
}