@isTest
private class APC_AssignAgentTest {

    static testMethod void testCaseExt() { 
        Profile profile = [Select Id From Profile where Name = 'System Administrator' limit 1];
        User usr1= new User();
        usr1.ProfileID = profile.Id;
        usr1.Username ='Test@Testemail.com'+ System.currentTimeMillis(); 
        usr1.LastName ='TestLastname';
        usr1.Email ='Test@Testemail.com';
        usr1.Alias ='TestAlia';
        usr1.TimeZoneSidKey ='TestCommunityNickname';
        usr1.CommunityNickname ='TestCommunityNickname';
        usr1.TimeZoneSidKey ='America/Los_Angeles';
        usr1.LocaleSidKey ='en_US';
        usr1.EmailEncodingKey ='UTF-8';
        usr1.LanguageLocaleKey ='en_US';
        insert usr1;
        System.runas(usr1){ Group grp = new Group();
        grp.name = 'Test Group1';
        grp.Type = 'Regular'; 
        Insert grp; 
 
        //Create Group Member
        GroupMember grpMem1 = new GroupMember();
        grpMem1.UserOrGroupId = UserInfo.getUserId();
        grpMem1.GroupId = grp.Id;
        Insert grpMem1;
		// Create the Case Record.
        Case cas = new Case(Status ='New', Priority = 'Medium', Origin = 'Email', Agent_Assigned__c=usr1.id,ownerId = grp.Id); 
        insert cas;
        case casId=[select id,Agent_Assigned__c from case];  
		
		// Set the parameter id with the created case id.
        ApexPages.currentPage().getparameters().put('id', cas.Id);
		
		// Instantiate the Controller Class.
        APC_AgentAssignedControllers cec = new APC_AgentAssignedControllers();
		test.startTest();
        String caseid=cas.id;
        String agentid=cas.Agent_Assigned__c;
        system.debug('cas.id@@@'+caseid);
        system.debug('cas.Agent__c@@@'+agentid);                  
        APC_AgentAssignedControllers.fetchLookUpValues(caseid);
        test.stopTest();
       APC_AgentAssignedControllers.saveAgent(caseid,agentid);
       APC_AgentAssignedControllers.saveAgent('caseid',agentid);

		}
       
    }
}