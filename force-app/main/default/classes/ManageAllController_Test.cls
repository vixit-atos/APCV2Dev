@isTest
    public class ManageAllController_Test {
    
        @testSetup static void ManageAllController_Test(){
            Integer pageLimit = 25;
            User blankUser = new User();
            User testApprover = createUser(blankUser, 'DTNA - WST Sales', 'WST - General Manager');
            User testUser = createUser(testApprover, 'DTNA - WST Sales', 'WST - Region 7 - DSM');       
            Concession__c testConcession;
            List<Concession__c> concessionList = new List<Concession__c>();
            Account acct;
            Approval.ProcessResult result;
            
            system.runAs(testUser){
                acct = createAccount();
                for(Integer i = 1; i< pageLimit; i++){
                    testConcession = createConcession(acct, i);
                    concessionList.add(testConcession);
                    Approval.ProcessSubmitRequest psr = new Approval.ProcessSubmitRequest();
                    psr.setObjectId(testConcession.Id);
                    psr.submitterID = userInfo.getUserId();
                    system.debug('Manager ' + testApprover);
                    system.debug('---Concession---' + testConcession);
                    system.debug('---Process Request---' + psr);
                    result = Approval.process(psr);
                }   
            }
        }
        
        public static User createUser(User manager, String profileName, String roleName){
            String testingName = 'T3ster' + roleName;
            List<Profile> profile = new List<Profile>();
            List<UserRole> userRole = new List<UserRole>();
            String email;
            User newTestUser = new User();
            newTestUser.LastName = testingName;
            newTestUser.Alias = testingName.substring(4,8);
            newTestUser.CommunityNickname = testingName;
            newTestUser.LocaleSidKey = 'en_US';
            newTestUser.TimeZoneSidKey = 'America/Los_Angeles';
            newTestUser.LanguageLocaleKey = 'en_US';
            newTestUser.EmailEncodingKey = 'UTF-8';
            email = newTestUser.LastName + '@daimler.com.poc3';
            newTestUser.Email = email.replaceAll( '\\s+', '');
            newTestUser.UserName = newTestUser.Email;
            profile = [select ID from profile where Name =: profileName LIMIT 1];
            userRole = [select Id from userrole where name =: roleName Limit 1];
            newTestUser.ProfileId = profile[0].id;
            newTestUser.UserRoleId = userrole[0].id;
            if(manager != null){
                newTestUser.ManagerId = manager.id;
            }
            insert newTestUser;
            return newTestUser;
        } 
        
        public static Account createAccount(){
            Account acct = new Account();
            acct.name = 'T3stAccount';
            insert acct;
            return acct;
        }
        
        public static Concession__c createConcession(Account acct, Integer uniqueIdentifier){
            Concession__c conc = new Concession__C();
            list<recordType> recordType = [select ID from recordtype where sObjectType = 'concession__c' AND Name = 'WST Mainframe Concession' limit 1];
            conc.RecordTypeID = recordType[0].id;
            conc.name = 'XZY' + uniqueIdentifier;
            conc.CONC_STATUS_CD__c = 'APC';
            conc.Dealer_Code__c = '41CZ';
            conc.PROD_FAM_CD__c = 'W';
            conc.Customer__c = acct.id;
            conc.CITY__c = 'BARRIE';
            insert conc;
            return conc;
        }
        
        static void approveRejectTestMethod(String approveOrReject, String Comment){
            String testRoleName = 'WST - General Manager';
            List<User> UserList;
            List<ID> idList;
            List<ProcessInstanceStep> listOfApprovalSteps;
            User testApprover;
            Integer startingSize;
            Integer endingSize;      
            string url;
            PageReference pref;
            testApprover = getTestApprover(testRolename);
            
                //Get the Items loaded via going to the pageload
                system.runAs(testApprover){
                    ManageAllController approveController = new ManageAllController();
                    List<ManageAllController.item_wrapper> approvalList;
                    List<ManageAllController.item_wrapper> selectedList;
                    
                    approvalList = approveController.items_to_approve_pageList;
                    approvalList.get(0).selected = true;
                    
                    pref = approveController.goToMassApproveReject();
                    
                    system.assertEquals(pref.getUrl(), '/apex/MassApprovalApproveReject');
                    selectedList = approveController.selectedApprovals;
                    approveController.inputtedComment = Comment;
                    
                    if(approveOrReject == 'Approve'){
                        url = approveController.massApprove();
                        system.assertEquals(url, 'https://'+ System.URL.getSalesforceBaseUrl().getHost()+'/home/home.jsp');
                    
                        for(integer i = 0; i < selectedList.size(); i++){
                            listOfApprovalSteps = [select ID, ActorID, Comments, StepStatus from ProcessInstanceStep where actorID =: userInfo.getuserId() AND StepStatus = 'Approved'];
                            system.assertEquals(selectedList.size(), listOfApprovalSteps.size()); //Check if the number matches
                            
                            for(ProcessInstanceStep pis : listOfApprovalSteps){
                                system.assertEquals(pis.Comments, Comment);
                            }
                        }
                    }else{
                        url = approveController.massReject();
                        system.assertEquals(url, 'https://'+ System.URL.getSalesforceBaseUrl().getHost()+'/home/home.jsp');
                    
                        for(integer i = 0; i < selectedList.size(); i++){
                            listOfApprovalSteps = [select ID, ActorID, Comments, StepStatus from ProcessInstanceStep where actorID =: userInfo.getuserId() AND StepStatus = 'Rejected'];
                            system.assertEquals(selectedList.size(), listOfApprovalSteps.size()); //Check if the number matches
                            for(ProcessInstanceStep pis : listOfApprovalSteps){
                                system.assertEquals(pis.Comments, Comment);
                            }
                        } 
                    }
                }
        }
        public static void reassignToTestUser(ID testerID){
            List<ProcessInstanceWorkItem> piwiList = new List<ProcessInstanceWorkItem>();
                For(ProcessinstanceWorkItem piwi : [Select ID, ActorID From ProcessInstanceWorkItem]){
            		ProcessInstanceWorkItem updatedPiwi = new ProcessInstanceWorkItem();
           			updatedPiwi.Id = piwi.id;
            		updatedPiwi.actorId = testerID;
            		piwiList.add(updatedpiwi);
        		}
			update piwiList;
        }
        public Static User getTestApprover(String roleName){
            List<UserRole> roleIds = [Select ID, Name from UserRole where Name =: roleName Limit 1];
            ID roleIDForTest = roleIds[0].id;
            List<User> UserList = [Select ID, LastName, profileId FROM User Where UserRoleID =: roleIDForTest Limit 1];
            List<Profile> profileList = [select ID, name from Profile where name = 'System Administrator' LIMIT 1];
            List<User> sysAdminList = [Select ID from User where ProfileID =: profileList[0].id and isActive = true];
            system.runas(sysAdminList[0]){
            	reassignToTestUser(UserList[0].id);
            }
            return UserList[0];
        }

        public static User createUserForReassignment(){
            String testingName = 'T4ster';
            List<Profile> profile = new List<Profile>();
            List<UserRole> userRole = new List<UserRole>();
            String email;
            User newTestUser = new User();
            newTestUser.LastName = testingName;
            newTestUser.Alias = testingName;
            newTestUser.CommunityNickname = testingName;
            newTestUser.LocaleSidKey = 'en_US';
            newTestUser.TimeZoneSidKey = 'America/Los_Angeles';
            newTestUser.LanguageLocaleKey = 'en_US';
            newTestUser.EmailEncodingKey = 'UTF-8';
            email = newTestUser.LastName + '@daimler.com.poc3';
            newTestUser.Email = email.replaceAll( '\\s+', '');
            newTestUser.UserName = newTestUser.Email;
            profile = [select ID from profile where Name = 'DTNA - WST Sales' LIMIT 1];
            userRole = [select Id from userrole where name = 'WST - General Manager' Limit 1];
            newTestUser.ProfileId = profile[0].id;
            newTestUser.UserRoleId = userrole[0].id;
            insert newTestUser;
            return newTestUser;
        } 
        static testMethod void manualPaginationTest(){
            //Currently runs tests to not break, rest is math
            Test.startTest();
            User testApprover = getTestApprover('WST - General Manager');
            system.runas(testApprover){
                ManageAllController approveController = new ManageAllController();
                approveController.FirstPage();
                approveController.next();
                approveController.previous();
                approveController.LastPage();
                approveController.getnxt();
                approveController.getprev();
            }
            Test.StopTest();
        }
        
        static testMethod void cancelTest(){
            //Redirect shall return to ManageAllController page\
            Test.StartTest();
            ManageAllController approveController = new ManageAllController();
            system.assertEquals('https://'+ System.URL.getSalesforceBaseUrl().getHost()+'/apex/ManageAllApprovals', approveController.goBack());
            Test.StopTest();
        }
        static testMethod void MassReassignTest(){
            Test.StartTest();
            List<User> UserList;
            List<ID> idList;
            List<ProcessInstanceStep> listOfApprovalSteps;
            User testApprover = getTestApprover('WST - General Manager');
            User testReassignApprover;
            Integer startingSize;
            Integer endingSize;      
            string url;
            PageReference pref;
            
            createUserForReassignment();    
            testReassignApprover = [select id, lastname, profileid from user where lastname = 'T4ster'];
            system.runAs(testApprover){
                ManageAllController approveController = new ManageAllController();
                List<ManageAllController.item_wrapper> approvalList = approveController.items_to_approve_pageList;
                approvalList.get(0).selected = true;
                
                pref = approveController.goToMassReassign();    
                
                system.assertEquals(pref.getUrl(), '/apex/MassApprovalReassign');
                List<ManageAllController.item_wrapper> selectedList = approveController.selectedApprovals;
                approveController.searchUserThroughConcession.ownerID = testReassignApprover.id;
                url = approveController.massReassign();
                system.assertEquals(url, 'https://'+ System.URL.getSalesforceBaseUrl().getHost()+'/home/home.jsp');
                
                for(integer i = 0; i < selectedList.size(); i++){
                    listOfApprovalSteps = [select ID, ActorID, Comments, StepStatus from ProcessInstanceStep where actorID =: testReassignApprover.id];
                    system.debug(listofApprovalsteps);
                    system.assertEquals(listOfApprovalSteps.size(), selectedList.size()); 
                }
            }
            Test.StopTest();
        }
        
        static testMethod void MassCommentedApprovals(){
            Test.startTest();
                approveRejectTestMethod('Approve', 'Test');
            Test.stopTest();
        }
        
        static testMethod void MassNonCommentedApprovals(){
            Test.startTest();
                approveRejectTestMethod('Approve', null);
            Test.stopTest();
        }
        static testMethod void MassCommentedRejections(){
            Test.startTest();
                approveRejectTestMethod('Reject', 'Test');
            Test.stopTest();
        }
        static testMethod void MassNonCommentedRejections(){
            Test.startTest();
                approveRejectTestMethod('Reject', null);
            Test.stopTest();
        }
        
}