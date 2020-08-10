@isTest
public class OpportunityTriggerHandler_Test {
    public Opportunity returnOpportunity1(){
        return new Opportunity(Name='TestOpportunityName', StageName = 'New',DTR_Requested_to_Quote_Residual__c = true, LEAD_CONC_NO__c = '555', 
                                CloseDate = Date.today() +1,NAD_U__c=userinfo.getUserId(), NAEU__c=userinfo.getUserId(), 
                               DistrictManager__c=userinfo.getUserId(), RGM_U__c=userinfo.getUserId());
    }
    public Opportunity returnFundOppy(){
        //Opportunity fundoppy = new Opportunity([select id from opportunity where recordTypeid = '012G0000000nCZV' limit 1]);     
        return new Opportunity(Name='TestOpportunityName', StageName = 'New', DTR_Requested_to_Quote_Residual__c = true, LEAD_CONC_NO__c = '555', 
                                CloseDate = Date.today() +1, NAD_U__c=userinfo.getUserId(), NAEU__c=userinfo.getUserId(), 
                               DistrictManager__c=userinfo.getUserId(), RGM_U__c=userinfo.getUserId());
     
    }
    
    static testMethod void Notification_Recipient() {
        map<id, RecordType> rtMap =new map<id, RecordType> ();  
        // Implement test code
        Account a = new Account (Name = 'a1');
        insert a;
        System.debug('1 insert');
        Account a2 = new Account (Name = 'a2');
        insert a2;
        System.debug('2 insert');
        //create opportunity
        User u;
        User NAEuser =[select id,name from  User where  SalesUserRole__c='NAE' Limit 1];
        User NADuser =[select id,name from user where  SalesUserRole__c='NAD' Limit 1];
        User RGMuser =[select id,name from user where  SalesUserRole__c='RGM' Limit 1];
        User DMuser =[select id,name from user where  SalesUserRole__c='DM' Limit 1];
        Id domesticRecordTypeId = TWSConstants.getOpportunityRecordTypeMap().get('TWS_TC_Deal');
        Id domesticRecordTypeId2 = TWSConstants.getOpportunityRecordTypeMap().get('TWS_TC_Deal');
        RecordType objrt=[  SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Opportunity' And id=: domesticRecordTypeId2 limit 1];
        system.debug(objrt);
        system.debug(domesticRecordTypeId2);    
        
        rtMap.put(domesticRecordTypeId2, objrt);
        system.debug( rtMap);
        Opportunity o = new Opportunity(Name = 'o1',DTR_Requested_to_Quote_Residual__c = true, VEH_MAKE__c = 'FTL', Account = a, 
                                        StageName = 'Initial Notification', CloseDate = Date.Today(), RecordTypeId = domesticRecordTypeId,
                                        NAD_U__c=NADuser.id,NAEU__c=NAEuser.id,RGM_U__c=RGMuser.id,DistrictManager__c=DMuser.id);
       
        insert o;
        System.debug('3 insert');
        Opportunity o2 = new Opportunity(Name = 'o1sss', Related_TC_Deal__c=null,DTR_Requested_to_Quote_Residual__c = true, 
                                         DTR_Requested_to_Quote_Trades__c = true, VEH_MAKE__c = 'FTL', Account = a2, 
                                         StageName = 'Initial Notification', CloseDate = Date.Today(), RecordTypeId = domesticRecordTypeId2,
                                         NAD_U__c=NADuser.id,NAEU__c=NAEuser.id,RGM_U__c=RGMuser.id,DistrictManager__c=DMuser.id);
     
        insert o2;
       System.debug('4 insert');
        system.debug( o2);
            
        List<Opportunity> lstoppy=new List<Opportunity>();
        lstoppy.add(o);
        lstoppy.add(o2);
       
        update lstoppy;
        System.debug('5 update');
       
        // Delete test code
        Account a3 = new Account (Name = 'a3');
        insert a3;
       
        System.debug('6 insert');
        Account a4 = new Account (Name = 'a4');
      
        insert a4;
        System.debug('7 insert');
     
        //create opportunity
        User NADuser2 =[select id,name from user where  SalesUserRole__c='NAD' and name='Steve Mignardi' Limit 1];
        User NAEuser1 =[select id,name from  User where  SalesUserRole__c='NAE' Limit 1];
        User NADuser1 =[select id,name from user where  SalesUserRole__c='NAD'  Limit 1];
        User RGMuser1 =[select id,name from user where  SalesUserRole__c='RGM' Limit 1];
        User DMuser1 =[select id,name from user where  SalesUserRole__c='DM' Limit 1];

        Id domesticRecordTypeId3 = TWSConstants.getOpportunityRecordTypeMap().get('TWS_TC_Deal');
        system.debug('domesticRecordTypeId313456'+domesticRecordTypeId3);
        Id domesticRecordTypeId4 = TWSConstants.getOpportunityRecordTypeMap().get('TWS_TC_Deal');
            
        Opportunity o3 = new Opportunity();
        o3.Name = 'o13';
        o3.VEH_MAKE__c = 'FTL';
        o3.DTR_Requested_to_Quote_Residual__c = true;    
        o3.Account = a; 
        o3.StageName = 'Initial Notification';
        o3.CloseDate = Date.Today();
        // o3.RecordTypeId = domesticRecordTypeId3;
        o3.DTR_Requested_to_Quote_Residual__c = true;

        insert o3;
       //  list<RecordType> OpprtMap = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Opportunity'];
        System.debug('8 insert');
        o3.NAD_U__c=NADuser1.id;
        o3.NAEU__c=NAEuser1.id;
        o3.RGM_U__c=RGMuser1.id;
        o3.DistrictManager__c=DMuser1.id;
        o3.DTR_Requested_to_Quote_Residual__c = false;
   //     o3.recordtypeid = OpprtMap[3].id;
        update o3;
        System.debug('9 update');
        Opportunity o4 = new Opportunity(Name = 'o1sss', VEH_MAKE__c = 'FTL', Account = a2, StageName = 'Initial Notification', CloseDate = Date.Today(), RecordTypeId = domesticRecordTypeId4,NAD_U__c=NADuser1.id,NAEU__c=NAEuser1.id,RGM_U__c=RGMuser1.id,DistrictManager__c=DMuser1.id);
        insert o4;
       // Opportunity o5 = new Opportunity(Name = 'o12sss', VEH_MAKE__c = 'FTL', Account = a5, StageName = 'Initial Notification', CloseDate = Date.Today(), RecordTypeId = domesticRecordTypeId4,NAD_U__c=NADuser1.id,NAEU__c=NAEuser1.id,RGM_U__c=RGMuser1.id,DistrictManager__c=DMuser1.id);
       // insert o5;
       
       //  o4= new opportunity(id=o4.id);
       // o5.RecordTypeid = OpprtMap[0].id;
      //  update o5;
        System.debug('10 insert');
        delete o4;
                    
        List<Opportunity> lstoppy2=new List<Opportunity>();
        lstoppy2.add(o3);
        lstoppy2.add(o4);
        Set<ID> oppid=new Set<ID>();
        // delete  lstoppy2;
        TWS_Approver__c objTWS_Approver=new TWS_Approver__c();
        objTWS_Approver.TWS_Approver__c=NAEuser1.id;
        RT_Approval_Process_Map__c RTAppr = new RT_Approval_Process_Map__c(Name='TWS_TC_Deal',Picklist_Value__c='TWS');
        insert RTAppr;
        Opportunity o10 = new Opportunity(Name = 'o10',Related_TC_Deal__c=null,DTR_Requested_to_Quote_Residual__c = true,DTR_Requested_to_Quote_Trades__c = true, VEH_MAKE__c = 'FTL', Account = a2, StageName = 'Initial Notification', CloseDate = Date.Today(), RecordTypeId = domesticRecordTypeId2,NAD_U__c=NADuser.id,NAEU__c=NAEuser.id,RGM_U__c=RGMuser.id,DistrictManager__c=DMuser.id);
        insert o10;
        o10.Related_TC_Deal__c= o.id;
        update o10;
            
        OpportunityTriggerHandler objoppyth=new OpportunityTriggerHandler();
        objoppyth.rtMap.put(domesticRecordTypeId2, objrt);
            
        objoppyth.prepopulateApprovers(o2);
        
       
      //objoppyth.prepopulateApproversDTRRequested();
            
                    //objoppyth.UpdateRGMNAD();
            //TestUtilities tu = TestUtilities.generateNotification_Recipients();
            
        
            
        }
    static testMethod void Updating_Approver() {
            
             Account a5 = new Account (Name = 'a5');
              insert a5;
           list<RecordType> OpprtMap = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Opportunity'];  
      //  RT_Approval_Process_Map__c RTP   
        Opportunity o5 = new Opportunity(Name = 'o12sss', VEH_MAKE__c = 'FTL', Account = a5, StageName = 'Initial Notification', CloseDate = Date.Today(), RecordTypeId = OpprtMap[0].id);
            
        insert o5;
       // list<RT_Approval_Process_Map__c> RT
       RT_Approval_Process_Map__c RTApp = new RT_Approval_Process_Map__c(name=OpprtMap[1].DeveloperName,Picklist_Value__c='test');
        insert RTApp;
          RTApp = new RT_Approval_Process_Map__c(name=OpprtMap[0].DeveloperName,Picklist_Value__c='test');
        insert RTApp;
       o5= new opportunity(id=o5.id);
       o5.RecordTypeid = OpprtMap[1].id;
       update o5;
            
        }
    
     static testMethod void Updating_Approver1() {
            
             Account a5 = new Account (Name = 'a5');
              insert a5;
           list<RecordType> OpprtMap = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Opportunity'];  
           Opportunity o5 = new Opportunity(Name ='20180124_test_for_role' , StageName = 'Published' , CloseDate = Date.newInstance(2018, 1, 24));
       // testWithInsertHelper(userForcheck_1, userForTest_1, newOppToTest_1);
      insert o5;
            
       // insert o5;
       RT_Approval_Process_Map__c RTApp = new RT_Approval_Process_Map__c(name=OpprtMap[1].DeveloperName,Picklist_Value__c='test');
        insert RTApp;
       o5= new opportunity(id=o5.id);
       o5.RecordTypeid = OpprtMap[1].id;
       update o5;
            
        }
        static testMethod void Updating_Approver2() {
            
             Account a5 = new Account (Name = 'a5');
              insert a5;
           list<RecordType> OpprtMap = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Opportunity'];  
           Opportunity o5 = new Opportunity(Name ='20180124_test_for_role' , StageName = 'Published' , CloseDate = Date.newInstance(2018, 1, 24));
       // testWithInsertHelper(userForcheck_1, userForTest_1, newOppToTest_1);
      insert o5;
            
       // insert o5;
       RT_Approval_Process_Map__c RTApp = new RT_Approval_Process_Map__c(name=OpprtMap[1].DeveloperName,Picklist_Value__c='test' );
        insert RTApp;
       o5= new opportunity(id=o5.id);
       o5.RecordTypeid = OpprtMap[1].id;
       o5.DTR_Requested_to_Quote_Residual__c = true ;
       update o5;
             o5.DTR_Requested_to_Quote_Residual__c = false ;
            update o5;
            o5.DTR_Requested_to_Quote_Residual__c = true ;
       update o5;
            
        }

}