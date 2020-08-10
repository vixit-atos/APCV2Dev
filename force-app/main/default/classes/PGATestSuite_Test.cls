@isTest
public class PGATestSuite_Test {
    //Must Run Async
    @testSetup static void pgaTestSetup(){
        
        List<String> roleNames = getRoleNames();
        List<String> profileNames = getRoleNames();
        List<ID> roleIds = getRoleIDs();
        List<ID> profileIds = getProfileIDs();
        List<ID> testUserIds;

        User adminUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        List<User> testUsersList = new List<User>{};
        String typeOfObject = 'User';
        List<SObject> insertionList;
        
        System.runAs(adminUser){
            Contact contact = mandatoryPGAContact();
            insert contact;
            testUsersList = userFactory(profileIds, profileNames, roleIDs, roleNames);
            testInsertSObject((List<SObject>) testUsersList, typeOfObject);
            createTaskGroupClosureSettings();
            addUserGroups(testUsersList);
        }
    }
    
    //System Building Methods
    static void addUserGroups(List<User> testUsersList){
        List<User> modifiedTestUsersList = new List<User>{};
        List<String> groupNameList = getGroupList();
        List<ID> groupIDList = new List<ID>{};
        List<Group> groupList = [Select ID, DeveloperName from Group WHERE DeveloperName in :groupNameList];
        List<GroupMember> gmList = new List<GroupMember>();
        String groupName;
        ID groupID;
        String userName;
        
        for(Integer u = 0; u<testUsersList.size(); u++){
            userName = testUsersList[u].LastName;
            if(userName.contains('VIP')){
            }else{
               modifiedTestUsersList.add(testUsersList[u]);
            }
        }
        
        for(Integer i = 0; i<groupNameList.size(); i++){
            for(Integer j = 0; j<groupList.size(); j++){
                if(groupList[j].DeveloperName == groupnameList[i]){
                    groupIDList.add(groupList[j].ID);
                }
            }
        }
        
        for(Integer i = 0; i < modifiedTestUsersList.size(); i++){
            GroupMember gm = new GroupMember();
            gm.GroupID = groupIDList[i];
            gm.UserOrGroupId = modifiedTestUsersList[i].id;
            gmList.add(gm);
        }
        insert gmList;
    }
    
    static void createTaskGroupClosureSettings(){
        List<Task_Group_Closure_Types_List__c> customSettings = new List<Task_Group_Closure_Types_List__c>();
        
        Task_Group_Closure_Types_List__c ispSettings = new Task_Group_Closure_Types_List__c();
        ispSettings.Name = 'Controlling Group Review - ISP';
        //ispSettings.StageUpdate__c = 'Controlling Review';
        customSettings.add(ispSettings);
        
        Task_Group_Closure_Types_List__c ASPReviewSettings = new Task_Group_Closure_Types_List__c();
        ASPReviewSettings.Name = 'ASP Group Review - TWS';
        //ASPReviewSettings.StageUpdate__c = 'Controlling Review';
        customSettings.add(ASPReviewSettings);
        
        Task_Group_Closure_Types_List__c ASPQuoteSettings = new Task_Group_Closure_Types_List__c();
        ASPQuoteSettings.Name = 'ASP Group Quote - TWS';
        ASPQuoteSettings.StageUpdate__c = 'Controlling Review';
        customSettings.add(ASPQuoteSettings);
        
        Task_Group_Closure_Types_List__c TWSSettings = new Task_Group_Closure_Types_List__c();
        TWSSettings.Name = 'Controlling Group Review - TWS';
        TWSSettings.StageUpdate__c = 'Controlling Review';
        customSettings.add(TWSSettings);
        
        Task_Group_Closure_Types_List__c DTRSettings = new Task_Group_Closure_Types_List__c();
        DTRSettings.Name = 'DTR Group Review - TWS';
        //DTRSettings.StageUpdate__c = 'Controlling Review';
        customSettings.add(DTRSettings);
        
        insert customSettings;
    }
    static Contact mandatoryPGAContact(){
        Contact mandatoryContact = new Contact();
        mandatoryContact.FirstName = 'Test';
        mandatoryContact.LastName = 'Test';
        String email = 'test@gmtestail.com';
        mandatoryContact.Email = email.replaceAll( '\\s+', '');
        mandatoryContact.Phone = '0000000000';
        return mandatoryContact;
    }
    static List<User> userFactory(List<ID> profileIds, List<String> profileNames, List<String> roleIds, List<String> roleNames){
        List<User> userList = new List<User>{};
        List<SObject> insertList = new List<SObject>{};
        String typeOfObject = 'User';
        String email;
        SObject insertObject;
        
        if(profileIDs.size() > 0){
            for(Integer i = 0; i < profileIds.size(); i++){
                String testingName = 'T3ster' + (i+2);
                User newTestUser = new User();
                newTestUser.LastName = 'T3ster' + profileNames[i] +i;
                newTestUser.Alias = testingName;
                newTestUser.CommunityNickname = testingName;
                newTestUser.LocaleSidKey = 'en_US';
                newTestUser.TimeZoneSidKey = 'America/Los_Angeles';
                newTestUser.ProfileID = profileIds[i];
                newTestUser.LanguageLocaleKey = 'en_US';
                newTestUser.EmailEncodingKey = 'UTF-8';
                newTestUser.UserRoleId = roleIds[i];
                email = newTestUser.LastName + '@daimler.com.poc3';
                newTestUser.Email = email.replaceAll( '\\s+', '');
                newTestUser.UserName = newTestUser.Email;
                userList.add(newTestUser);
            }
        }
        return userList;
    }
    static List<ID> testInsertSObject(List<SObject> objectList, String typeOfObject){
        List<ID> resultsIdList = new List<ID>();
        Task t = new task();
        List<Profile> profileNames = [Select Name From Profile Where ID =:userInfo.getProfileID()];
		String STCName;
        String UserProfileName;
        Contact cont = new Contact();
        System.Debug('Attempting to Insert ' + typeOfObject + 'list.');
        if(typeOfObject == 'Task'){
            System.Debug('Converting SObjects into Tasks');
            objectList = (List<Task>) objectList;
        }
        Database.SaveResult[] resultsList = Database.insert(objectList, false);
        if(profileNames[0].Name == 'DTNA - STC Cleveland'){
            if(typeOfObject == 'Task'){
                for(SObject s : objectList){
                    t = (Task) s;
                    if(t.Contact__c != null){
                        cont = [SELECT ID From Contact Where ID =:t.Contact__c];
                        STCName = UserProfilename.substringAfterLast('STC').normalizeSpace();
                        for(Schema.FieldSetMember f : SObjectType.Contact.FieldSets.STC_Contact_Info.getFields()){ 
                            if(f.getFieldPath().replaceAll('_',' ').normalizeSpace().contains(STCName)){
                                if(f.getFieldPath().containsignoreCase('phone')){
                                    if(t.Phone__c != String.valueOf(cont.get(f.getFieldPath())!=null?cont.get(f.getFieldPath()):'')){
                                        system.debug('Test Unsuccessful. STC Member Phone didnt move to special field.');
                                        system.assertEquals(t.Phone__c, String.valueOf(cont.get(f.getFieldPath())!=null?cont.get(f.getFieldPath()):''));
                                    }
                                }
                                if(f.getFieldPath().containsignoreCase('email')){
                                    if(t.Email__c != String.valueOf(cont.get(f.getFieldPath())!=null?cont.get(f.getFieldPath()):'')){
                                        system.debug('Test Unsuccessful. STC Member Email didnt move to special field.');
                                        system.assertEquals(t.Email__C, String.valueOf(cont.get(f.getFieldPath())!=null?cont.get(f.getFieldPath()):''));
                                    }
                                }
                            }
                    	}
                	}
            	}
        	}
        }
        for (Database.SaveResult result : resultsList) {
            if (result.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted ' + typeOfObject + '. ' + typeOfObject + ' ID: ' + result.getId());
                
            }else {
            // Operation failed, so get all errors                
            for(Database.Error err : result.getErrors()) {
                System.debug('The following error has occurred.');                    
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('Task fields that affected this error: ' + err.getFields());
            }}
        }
        
        for(Integer i = 0; i < resultsList.size(); i++){
            resultsIdList.add(resultsList[i].id);
        }
        return resultsIdList;
    }
    
    /* Use For new groups to hand test
    static testMethod void manualCodeTest(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - STC Cleveland';
        String roleName = 'STC Cleveland Manager';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    */
    
    //TestMethod Broken Down Methods
    static void performPGATest(String objectForPGA, String typeOfPGA, String profileName, String roleName){
        List<Private_Activity__c> pgaList = new List<Private_Activity__c>();
        List<Private_Note__c> noteList = new List<Private_Note__c>();
        List<Integer> testResults = new List<Integer>();
        Map<Id,Id> grRoleMap = new Map<Id,Id>();
        Map<Id,Id> gmRoleMap = new Map<Id,Id>();
        Map<Id, String> userRoleMap = new Map<Id, String>{};
        Map<Id, String> userProfileMap = new Map<Id, String>{};
        List<User> testUsersList;
        User testUser = new User();
        ID testUserProfileID = getUserProfileID(profileName);
        ID testUserRoleID = getUserRoleID(roleName);
        ID ownerRoleID;

        gmRoleMap = getGroupMemberMap();
        grRoleMap = getGroupRoleMap();
        userRoleMap = getUserRoleNameMap();
        userProfileMap = getUserProfileNameMap();
        testUsersList = getTestUsers();
        
        for(User tu : testUsersList){
            if(tu.ProfileID == testUserProfileID){
                if(testUserRoleID == null){
                    system.debug('Empty Role. Assigning To User Now.');
                    testUser = tu;
                }else{
                    if(testUserRoleID == tu.userRoleID){
                        system.debug('User profile and role match');
                        testUser = tu;
                    }
                }
                if(testUser == null){
                    system.debug('No User Found');
                }
            }
        }
        ownerRoleId = testUser.userRoleId;

        system.debug('The user is ' + testUser.LastName);
        system.debug('User Group ID: ' + grRoleMap.get(testUser.userRoleID));
        if(objectForPGA == 'Account'){
            pgaList = createAccountPGAs(testUser, ownerRoleID, typeOfPGA, userProfileMap);
        } else if(objectForPGA == 'Contact'){
            pgaList = createContactPGAs(testUser, ownerRoleID, typeOfPGA, userProfileMap);
        } else if(objectForPGA == 'Opportunity'){
            pgaList = createOpportunityPGAs(testUser, ownerRoleID, typeOfPGA, userProfileMap);
        } else if(objectForPGA == 'Concession'){
            pgaList = createConcessionPGAs(testUser, ownerRoleID, typeOfPGA, userProfileMap);
        }
                
        if(pgaList.size() >0){
            
            pgaPenetrationTest(testUsersList, pgaList, grRoleMap, gmRoleMap, userRoleMap, ownerRoleID);
            deleteCheck(testUsersList, pgaList, grRoleMap, gmRoleMap, typeOfPGA);
        }else{
            noteList = [SELECT ID FROM Private_Note__c];
            if(noteList.size() >0){
                pnPenetrationTest(testUsersList, noteList, grRoleMap, gmRoleMap, userRoleMap, ownerRoleID);
            }else{
                system.debug('Test Unsuccessful. Private Activity was unable to be created');
                system.assertNotEquals(pgaList.size(), 0);
            }
        }
    }
    static void pgaPenetrationTest(List<User> testUsersList, List<Private_Activity__c> pgaList, Map<ID,ID>grRoleMap, Map <ID,ID>gmRoleMap, Map<ID,String> userRoleNameMap, ID ownerRoleID){
        ID userGroupID;
        ID ownerGroupID;
        //Boolean groupCheck;
        Boolean roleCheck;
        Integer MAX_ROLE_DEPTH = 10;
        Map<ID,ID> userRoleMap = getUserRoleMap();
        ID userStartingRole;
        List<ID> userParentRoleList = new List<ID>{};
        List<ID> ownerParentRoleList = new List<ID>{};  
            
        for(User u: testUsersList){
            System.runAs(u){
                userStartingRole = u.UserRoleID;
                ownerGroupID = grRoleMap.get(ownerRoleID);
                
                userParentRoleList = getParentRoleList(userStartingRole, userRoleMap, userRoleNameMap);
                ownerParentRoleList = getParentRoleList(ownerRoleID, userRoleMap, userRoleNameMap);
                
                if(grRoleMap.get(u.UserRoleID) != null){
                   userGroupID = grRoleMap.get(u.UserRoleID);
                }else{
                    system.debug('Failed to get a user group');
                }                
                for(Private_Activity__c pa: pgaList){
                    try{
                        updatePrivateActivity(pa);
                        if(userGroupID != ownerGroupID){
                            roleCheck = checkRoles(userParentRoleList, ownerParentRoleList);
                            if(roleCheck == true){
                                System.Debug('Test Successful. Private activity was modified by a user of the same group.');
                            }else{
                                roleCheck = checkOwnerParents(userStartingRole, ownerRoleID, userRoleMap);
                                if(roleCheck == true){
                                    System.debug('Test Successful. Private Activity was modified by a parent group');
                                }
                                System.Debug('Test Unsuccessful. Private Activity was modified by a user outside of the group');
                                System.AssertEquals(userGroupID, ownerGroupID);
                            }
                        }else{
                            System.Debug('Test Successful. Private Activity was modified by a user of the same exact group.');
                        }
                    }catch(Exception ex){
                        if(grRoleMap.get(u.UserRoleID) == grRoleMap.get(ownerRoleID)){
                            System.debug('Test Unsuccessful. Private Activity was not modified by a user of the same group.');
                            System.assertNotEquals(grRoleMap.get(u.UserRoleID), grRoleMap.get(ownerRoleID));
                        }else{
                            System.debug('Test Successful. Private Activity was not modified by a user of a different group.');
                        }
                    }
                }
            }
        }
    }
    static boolean checkOwnerParents(ID userRoleID, ID ownerRoleID, Map<ID,ID> userRoleMap){
        //Checks all the way
        Integer MAX_DEPTH = 10;
        
        ID currentID = ownerRoleID;
        for(Integer i = 0; i < MAX_DEPTH; i++){
            currentID = userRoleMap.get(currentID);
            if(currentID == null){
                i = 11;
            }else if(currentID == userRoleID){
                return true;
            }
        }
        return false;
    }
    static void pnPenetrationTest(List<User> testUsersList, List<Private_Note__c> pnList, Map<ID,ID>grRoleMap, Map <ID,ID>gmRoleMap, Map<ID,String> userRoleNameMap, ID ownerRoleID){
        ID userGroupID;
        ID ownerGroupID;
        //Boolean groupCheck;
        Boolean roleCheck;
        Integer MAX_ROLE_DEPTH = 10;
        Map<ID,ID> userRoleMap = getUserRoleMap();
        ID userStartingRole;
        List<ID> userParentRoleList = new List<ID>{};
        List<ID> ownerParentRoleList = new List<ID>{};  
            
        for(User u: testUsersList){
            System.runAs(u){
                userStartingRole = u.UserRoleID;
                ownerGroupID = grRoleMap.get(ownerRoleID);
                
                userParentRoleList = getParentRoleList(userStartingRole, userRoleMap, userRoleNameMap);
                ownerParentRoleList = getParentRoleList(ownerRoleID, userRoleMap, userRoleNameMap);
                
                if(grRoleMap.get(u.UserRoleID) != null){
                   userGroupID = grRoleMap.get(u.UserRoleID);
                }else{
                   system.debug('Failed to get a user group');
                }                
                for(Private_Note__c pn: pnList){
                    try{
                        updatePrivateNote(pn);
                        if(userGroupID != ownerGroupID){
                            roleCheck = checkRoles(userParentRoleList, ownerParentRoleList);
                            if(roleCheck == true){
                                System.Debug('Test Successful. Private Note was modified by a user of the same group.');
                            }else{
                                roleCheck = checkOwnerParents(userStartingRole, ownerRoleID, userRoleMap);
                                if(roleCheck == true){
                                    System.debug('Test Successful. Private Activity was modified by a parent group');
                                }
                                System.Debug('Test Unsuccessful. Private Note was modified by a user outside of the group');
                                System.AssertEquals(userGroupID, ownerGroupID);
                            }
                        }else{
                            System.Debug('Test Successful. Private Note was modified by a user of the same exact group.');
                        }
                    }catch(Exception ex){
                        if(grRoleMap.get(u.UserRoleID) == grRoleMap.get(ownerRoleID)){
                            System.debug('Test Unsuccessful. Private Note was not modified by a user of the same group.');
                            System.assertNotEquals(grRoleMap.get(u.UserRoleID), grRoleMap.get(ownerRoleID));
                        }else{
                            System.debug('Test Successful. Private Note was not modified by a user of a different group.');
                        }
                    }
                }
            }
        }
    }
    static void updatePrivateActivity(Private_Activity__c pa){
        Private_Activity__c pga = new Private_Activity__c();
        pga.id = pa.id;
        pga.Name = pa.Name;
        pga.Name = UserInfo.getLastName() + 'was-here';
        update pga;
    }
    static void updatePrivateNote(Private_Note__c pn){
        Private_Note__c note = new Private_Note__c();
        note.id = pn.id;
        note.Name = UserInfo.getLastName() + 'was-here';
        update note;
    }
    static void deleteCheck(List<User> testUsersList, List<Private_Activity__c> pgaList, Map<ID,ID>grRoleMap, Map <ID,ID>gmRoleMap, String typeOfPGA){
        Task t = new Task();
        Event e = new Event();
        String activityID;
        ID ownerID;
        User currentUser;
        
        for(Private_Activity__c pa : pgaList){
            ownerID = pa.OwnerID;
            
            For(User u : testUsersList){
                if(u.id == ownerID){
                    currentUser = u;
                }
            }
            
            system.runAs(currentUser){
                activityID = pa.Activity_ID__c;
                delete pa;
                try{
                    if(typeOfPGA == 'Task'){
                        t = [Select ID, Subject from Task Where ID =:activityID LIMIT 1];
                        t.Subject = 'Did I Delete it?';
                        update t;
                        System.Debug('Test Unsuccessful. Task was not deleted along with PGA.');
                        System.assertEquals(1, 0);
                    } else if(typeOfPGA == 'Event'){
                        e = [Select ID, Subject from Event Where ID =:activityID LIMIT 1];
                        e.Subject = 'Did I Delete it?';
                        update e;
                        System.Debug('Test Unsuccessful. Task was not deleted along with PGA.');
                        System.assertEquals(1, 0);
                    } else if(typeOfPGA == 'Email'){
                        t = [Select ID, Subject from Task Where ID =:activityID LIMIT 1];
                        t.Subject = 'Did I Delete it?';
                        update t;
                        System.Debug('Test Unsuccessful. Email task was not deleted along with PGA.');
                        System.assertEquals(1, 0);
                    }
                }catch(Exception ex){
                    System.debug('Test Successful. Task could not be found');
                }
            }
        }
    }
    static boolean checkRoles(List<ID> userParentRoleList, List<ID> ownerParentRoleList){
        for(Integer i = 0; i<userParentRoleList.size(); i++){
            for(Integer j = 0; j<ownerParentRoleList.size(); j++){
                if(userParentRoleList[i] == ownerParentRoleList[j]){
                    return true;
                }
            }
        }
        return false;
    }
    
    //Getters
    static ID getUserProfileID(String profileName){
        List<Profile> userProfile;
        ID userprofileID;
        try{
            userProfile = [SELECT ID From Profile where Name =: profileName LIMIT 1];
        }catch(exception ex){
            system.debug('Malformed Test Method. Please check settings match role and profile lists');
            system.assertEquals(0, 1);
        }
        userProfileID = userProfile[0].id;
        return userProfileID;
    }
    static ID getUserRoleID(String roleName){
        List<UserRole> userRole;
        ID userRoleID = null;
        if(roleName != null){
            userRole = [SELECT ID From UserRole where Name =: roleName LIMIT 1];
            userRoleID = userRole[0].id;
        }
        return userRoleID;
    }
    static List<ID> getProfileIds(){
        List<ID> profileIds = new List<ID>();
        List<String> profileNames = getProfileNames();
        Map<String, ID> serverProfileIdNamePairings = new Map<String, ID>{};
        for(Profile p: [Select ID, Name From Profile Where Name in :profileNames]){
            serverProfileIdNamePairings.put(p.name, p.id); 
        }
        for(Integer i = 0; i < profileNames.size(); i++){
            profileIds.add(serverProfileIdNamePairings.get(profileNames[i]));
        }
        return profileIds;
    }
    static List<String> getProfileNames(){
        List<String> profileNames = new List<String>{
            //1:1 w/RoleNames, duplicates supported, loop with this
            'DTNA - VIP Support',
            'DTNA - ASP',
            'DTNA - Call Centers',
            'DTNA - DND',
            'DTNA - DTR',
            'DTNA - DTR UTM',
            'DTNA - Parts',
            'DTNA - Parts',
            'DTNA - FTL DOA',
            'DTNA - Field Service',
            'DTNA - FTL Sales',
            'DTNA - Parts',
            'DTNA - Parts',
            'DTNA - Uptime Pro',
            'DTNA - Parts',
            'DTNA - WST DOA',
            'DTNA - Field Service',
            'DTNA - WST Sales',
            'DTNA - STC Cleveland'
        };
        return profileNames;
    }
    static List<ID> getRoleIDs(){
        List<ID> roleIDs = new List<ID>();
        List<String> roleNames = getRoleNames();
            
        Map<String, ID> serverRoleIdNamePairings = new Map<String, ID>{};
        for(UserRole r: [Select ID, Name FROM UserRole Where Name in :roleNames]){
            serverRoleIdNamePairings.put(r.name, r.Id);
        } 
        for(Integer i = 0; i < roleNames.size(); i++){
            roleIds.add(serverRoleIdNamePairings.get(roleNames[i]));
        }
        return roleIDs;
    }
    static List<String> getRoleNames(){
        List<String> roleNames = new List<String>{
            'VIP Support', 
            'Field Rep',   
            'Call Centers Admin', 
            'DND Admin', 
            'DTR Admin', 
            'UTM',
            'East Region Director', 
            'Fleet Director',
            'FTL DOA Admin',
            'FTL Regional Service Director',
            'FTL Admin',
            'Parts Marketing Director',
            'Specialty Parts Director',
            'Uptime Pro Admin',
            'West Region Director',
            'WST DOA Rep',
            'WST Regional Service Director',
            'WST Admin',
            'STC Cleveland Manager'
        };
        return roleNames;
    }
    static List<String> getGroupList(){
        List<String> grouplist = new List<String>{
            'ASP_Group',
            'Call_Centers_Group',
            'DND_Group',
            'DTR_Group',
            'DTR_Group',
            'Eastern_Parts_Group',
            'Parts_Group',
            'FTL_DOA_Group',
            'Field_Service_Group',
            'FTL_Group',
            'Parts_Marketing',
            'Specialty_Parts_Group',
            'UptimePro_Group',
            'Western_Parts_Group',
            'DOA_Group',
            'WST_Field_Service_Group',
            'WST_Group',
            'STC_Cleveland'
        };
        
        return groupList;
    }
    static ID getContactsAccount(List<Account> accountList){
        String accountName;
        ID accountContact;
        
        for(Integer i = 0; i < accountList.Size(); i++){
            accountName = accountList[i].Name;
            if(accountName.endsWith('Con')){
                accountContact = accountList[i].ID;
            }
        }
        return accountContact;
    }
    static ID getAccountRecordTypeID(String typeOfAccount){
        return Schema.SObjectType.Account.getRecordTypeInfosByName().get(typeOfAccount).getRecordTypeId(); 
    }
    static ID getContactsOpportunity(List<opportunity> opportunityList){
        String opportunityName;
        ID opportunityContact;
        
        for(Integer i = 0; i < opportunityList.Size(); i++){
            opportunityName = opportunityList[i].Name;
            if(opportunityName.endsWith('Con')){
                opportunityContact = opportunityList[i].ID;
            }
        }
        return opportunityContact;
    }
    static ID getContactsConcession(List<Concession__c> concessionList){
        String concessionName;
        ID concessionContact;
        
        for(Integer i = 0; i < concessionList.Size(); i++){
            concessionName = concessionList[i].Name;
            if(concessionName.endsWith('Con')){
                concessionContact = concessionList[i].ID;
            }
        }
        return concessionContact;
    }
    static ID getContactType(String contactType){
        return Schema.SObjectType.Contact.getRecordTypeInfosByName().get(contactType).getRecordTypeId(); 
    }
    static ID getOpportunityType(String opportunityType){
        return Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(opportunityType).getRecordTypeId(); 
    }
    static ID getConcessionRecordType(String concessionType){
        return Schema.SObjectType.Concession__c.getRecordTypeInfosByName().get(concessionType).getRecordTypeId(); 
    }
    static List<ID> getIDFromObjectList(List<SObject> objectList){
        List<ID> capturedIDs = new List<ID>();
        String contactPrefix = '003';
        ID objectID;
        for(Integer i = 0; i < objectList.Size(); i++){
            objectID = objectList[i].ID;
            capturedIDs.add(objectList[i].id);
        }
        
        return capturedIDs;
    }
    static Map<Id,Id> getGroupMemberMap(){
        Map<Id,Id> gmRoleMap = new Map<Id,Id>();
        for(Groupmember gm : [SELECT GroupID, UserOrGroupId FROM GroupMember]){
            gmRoleMap.put(gm.UserOrGroupID, gm.GroupId);
        }
        return gmRoleMap;
    }
    static Map<Id,Id> getgroupRoleMap(){
        Map<Id,Id> grRoleMap = new Map<Id,Id>{};
        for(Group gr : [SELECT ID, DeveloperName, RelatedID FROM Group]){
            grRoleMap.put(gr.RelatedId,gr.id);
        }
        return grRoleMap;
    }
    static List<User> getTestUsers(){
        return [SELECT ID, LastName, ProfileID, UserRoleId FROM User WHERE LastName like 'T3%'];
    }
    static Map<Id,Id> getUserRoleMap(){
        Map<Id,Id> userRoleMap = new Map<Id,Id>{};
        For(UserRole ur : [Select ID, ParentRoleID FROM UserRole]){
            userRoleMap.put(ur.Id, ur.ParentRoleID);    
        }
        return userRoleMap;
    }
    static List<ID> getParentRoleList(ID startingRole, Map<Id,Id> roleMap, Map<ID,String> userRoleNameMap){
        Integer MAX_ROLE_DEPTH = 10;
        ID currentRoleID = startingRole;
        String roleName;
        List<String> userRoleNameList = getTopGroupRoleList();
        List<ID> parentRoleList = new List<ID>{};
        parentRoleList.add(currentRoleID);
        for(Integer i = 0; i < MAX_ROLE_DEPTH; i++){
            currentRoleID = roleMap.get(currentRoleID);
            roleName = userRoleNameMap.get(currentRoleID);
            for(String s : userRoleNameList){
                if(s == roleName){
                    i = 11;
                }
            }
            parentRoleList.add(currentRoleID);
        }
        return parentRoleList;
    }
    static Map<ID,String> getUserRoleNameMap(){
        Map<ID,String> userRoleMap = new Map<ID,String>{};
        For(UserRole ur: [Select ID, Name From UserRole]){
                userRoleMap.put(ur.id, ur.Name);
        }
        return userRoleMap;
    }
    static Map<ID,String> getUserProfileNameMap(){
        Map<ID,String> userProfileMap = new Map<ID,String>{};
        For(Profile pr: [Select ID, Name From Profile]){
                userProfileMap.put(pr.id, pr.Name);
        }
        return userProfileMap;
    }
    static List<String> getTopGroupRoleList(){
        List<String> roleNames = new List<String>{
            'VIP Support', 
            'Field Rep',   
            'Call Centers Admin', 
            'DND Admin', 
            'DTR Admin', 
            'East Region Director', 
            'Fleet Director',
            'FTL DOA Admin',
            'FTL Regional Service Director',
            'FTL Admin',
            'Parts Marketing Director',
            'Specialty Parts Director',
            'Uptime Pro Admin',
            'West_Region_Director',
            'WST DOA Rep',
            'WST Regional Service Director',
            'WST Admin'
        };
        return roleNames;
    }
    
    //Creation Methods
    static List<ID> createAccountsForUser(String userName, String typeOfAccount){
        String typeOfObject = 'Account';
        ID recordTypeForCreation = getAccountRecordTypeID(typeOfAccount);
        List<Account> accountList = accountTestFactory(userName, recordTypeForCreation);
        return testInsertSObject(accountList, typeOfObject);
    }  
    static List<ID> createOpportunitiesForUser(String userName, ID accountID, Map<ID, String> userProfileMap){
        List<Opportunity> opportunityList;
        if(accountID != null){
            opportunityList = opportunityTestFactory(userName, accountID, userProfileMap);
        }
        String typeOfObject = 'Opportunity';
        if(opportunityList != null && opportunityList.size() > 0){
            return testInsertSObject(opportunityList, typeOfObject);
        }else{
            system.debug('Could not create opportunity. Passing back empty List');
            List<ID> gibberishIDList = new List<ID>();
            return gibberishIDList;
        }
    }
    static List<ID> createConcessionPGA(String userName, Account acctID){
        List<Concession__c> concessionList = concessionFactory(userName, acctID.ID);
        String typeOfObject = 'Concession';
        return testInsertSObject(concessionList, typeOfObject);
    }
    static List<Private_Activity__c> createAccountPGAs(User testUser, ID ownerRoleID, String typeOfPGA, Map<ID, String> userProfileMap){
        List<Private_Activity__c> pgaList = new List<Private_Activity__c>();
        List<Account> accountList = new List<Account>();
        List<Contact> contactList = new List<Contact>();
        List<Concession__c> concessionList = new List<Concession__c>();
        List<ID> idList = new List<ID>{};
        String typeOfObject = '';
        String accountName = '';
        String accountType = 'Dealership';
        ID accountContact;
        
        System.runAs(testUser){
            List<SObject> insertList = new List<SObject>();
            List<ID> returnedIdList = new List<ID>();
            String userName = UserInfo.getLastName();
            
            returnedIdList = (createAccountsForUser(userName, accountType));

            accountContact = getContactsAccount(accountList);   
            contactList = contactTestFactory(userName, accountContact, userProfileMap);
            typeOfObject = 'Contact';
            testInsertSObject(contactList, typeOfObject);  

            for(Integer ob = 0; ob < returnedIdList.size(); ob++){
                pgaCreator(typeOfPGA, returnedIDList[ob], contactList);
            }
            

            pgaList = [SELECT ID, Name, OwnerID, Activity_ID__c FROM Private_Activity__c];
        }
        return pgaList;
    }
    static List<Private_Activity__c> createContactPGAs(User testUser, ID ownerRoleID, String typeOfPGA, Map<ID, String> userProfileMap){
        List<Private_Activity__c> pgaList = new List<Private_Activity__c>();
        List<Account> accountList = new List<Account>();
        List<Contact> contactList = new List<Contact>();
        List<Concession__c> concessionList = new List<Concession__c>();
        List<ID> idList = new List<ID>{};
        String typeOfObject = '';
        String accountName = '';
        ID accountContact;
        
        System.runAs(testUser){
            List<SObject> insertList = new List<SObject>();
            List<ID> returnedIdList = new List<ID>();
            String userName = UserInfo.getLastName();
            
            //Make into a method later
            accountContact = getContactsAccount(accountList);   
            contactList = contactTestFactory(userName, accountContact, userProfileMap);
            typeOfObject = 'Contact';
            testInsertSObject(contactList, typeOfObject);  
            
            for(Contact c:contactList){
                returnedIdList.add(c.id);
            }
            
            for(Integer ob = 0; ob < returnedIdList.size(); ob++){
                pgaCreator(typeOfPGA, returnedIDList[ob], contactList);
            }
            
            pgaList = [SELECT ID, Name, OwnerID, Activity_ID__c FROM Private_Activity__c];
        }
        return pgaList;
    }
    static List<Private_Activity__c> createOpportunityPGAs(User testUser, ID ownerRoleID, String typeOfPGA, Map<ID, String> userProfileMap){
        List<Private_Activity__c> pgaList = new List<Private_Activity__c>();
        List<Account> accountList = new List<Account>();
        List<Contact> contactList = new List<Contact>();
        List<Concession__c> concessionList = new List<Concession__c>();
        List<ID> idList = new List<ID>{};
        String typeOfObject = '';
        String accountName = '';
        String accountType = 'Dealership';
        ID accountContact;
        
        System.runAs(testUser){
            List<SObject> insertList = new List<SObject>();
            List<ID> returnedIdList = new List<ID>();
            String userName = UserInfo.getLastName();
            returnedIdList = (createAccountsForUser(userName, accountType));
            accountContact = getContactsAccount(accountList);   
            contactList = contactTestFactory(userName, accountContact, userProfileMap);
            typeOfObject = 'Contact';
            testInsertSObject(contactList, typeOfObject); 
            
            Account acctID = [SELECT ID, Name from Account LIMIT 1];
            returnedIdList = (createOpportunitiesForUser(userName, acctID.ID, userProfileMap));

            for(Integer ob = 0; ob < returnedIdList.size(); ob++){
                pgaCreator(typeOfPGA, returnedIDList[ob], contactList);
            }

            pgaList = [SELECT ID, Name, OwnerID, Activity_ID__c FROM Private_Activity__c];
        }
        return pgaList;
    }
    static List<Private_Activity__c> createConcessionPGAs(User testUser, ID ownerRoleID, string typeOfPGA, Map<ID, String> userProfileMap){
        List<Private_Activity__c> pgaList = new List<Private_Activity__c>();
        List<Account> accountList = new List<Account>();
        List<Contact> contactList = new List<Contact>();
        List<Concession__c> concessionList = new List<Concession__c>();
        List<ID> idList = new List<ID>{};
        String typeOfObject = '';
        String accountName = '';
        String accountType = 'Dealership';
        ID accountContact;
        
        System.runAs(testUser){
            List<SObject> insertList = new List<SObject>();
            List<ID> returnedIdList = new List<ID>();
            String userName = UserInfo.getLastName();
            
            returnedIdList = (createAccountsForUser(userName, accountType));

            accountContact = getContactsAccount(accountList);   
            contactList = contactTestFactory(userName, accountContact, userProfileMap);
            typeOfObject = 'Contact';
            testInsertSObject(contactList, typeOfObject); 
            
            Account acctID = [SELECT ID, Name from Account LIMIT 1];
            returnedIDlist = createConcessionPGA(userName, acctID);

            for(Integer ob = 0; ob < returnedIdList.size(); ob++){
                pgaCreator(typeOfPGA, returnedIDList[ob], contactList);
            }
            
            pgaList = [SELECT ID, Name, OwnerID, Activity_ID__c FROM Private_Activity__c];
        }
        return pgaList;
    }
    
    static List<ID> pgaCreator(String typeOfPGA, ID objectID, List<Contact> contactList){
        List<ID> idList = new List<ID>{};
        List<Private_Activity__c> pgaList = new List<Private_Activity__c>{};
        if(typeOfPGA == 'Task'){
            idList.addall(pgaTestSetupTaskCreation(objectID, contactList));
        } else if(typeOfPGA == 'Event'){
            idList.addall(createEvent(objectID, contactList));
        } else if(typeOfPGA == 'Email'){
            idList.addall(createEmail(objectID, contactList));
        } else if(typeOfPGA == 'Note'){
            idList.addall(createNote(objectID, contactList));
        }
        return idlist;
    }
    static List<ID> pgaTestSetupTaskCreation(ID associatedObject, List<Contact> contactList){
        String typeOfObject;
        List<Task> taskList = new List<Task>();
        List<ID> idList = new List<ID>();
        if(associatedObject != null){
            taskList = taskTestFactory(associatedObject, contactList); 
        }
        typeOfObject = 'Task';

        if(taskList.size() >0){
            testInsertSObject(taskList, typeOfObject);
            idList.addall(getIDFromObjectList(taskList));
        }
        return idList;
    }
    static List<ID> createEvent(ID associatedObject, List<Contact> contactList){
        String typeOfObject;
        List<Event> eventList = new List<Event>();
        List<ID> idList = new List<ID>();

        eventList = eventFactory(associatedObject, contactList);    
        typeOfObject = 'Event';
        testInsertSObject(eventList, typeOfObject);
        idList.addall(getIDFromObjectList(eventList));
        
        return idList;
    }
    static List<ID> createEmail(ID associatedObject, List<Contact> contactList){
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        List<ID> idList = new List<ID>();
        List<Task> emails;
        ID contactIdToEmail = contactList[0].id;
        emailList = emailFactory(associatedObject, contactIdToEmail);
        Messaging.sendEmail(emailList);
        emails = [SELECT ID From Task];
        idList.addall(getIDFromObjectList(emails));
        return idList;
    }
    static List<ID> createNote(ID associatedObject, List<Contact> contactList){
        List<Private_Note__c> notesList = new List<Private_Note__c>();
        List<ID> idList = new List<ID>();
        String objectIDString = associatedObject;
        String typeOfObject = 'Note';
        Private_Note__c testNote = new Private_Note__c();
        testNote.Name = 'Test Note';
        testNote.Body__c = 'Test Body';
        testNote.contact__c = contactList[0].id;
        if(objectIDString.substring(0,3) != '003'){
          testNote.Account__c = associatedObject;  
        }
        notesList.add(testNote);
        testInsertSObject(notesList, typeOfObject);
        idList.addall(getIDFromObjectList(notesList));
        return idList;
    }
    
    //'Factorys'
    static List<Account> accountTestFactory(String uniqueIdentifier, ID recordTypeID){
        List<Account> accountList = new List<Account>();
        String accountName = 'TEST_ACCOUNT' + uniqueIdentifier;
        System.Debug('Creating Accounts for User');
        
        Account testAccount = new Account();
        testAccount.Name = accountName;
        testAccount.RecordtypeID = recordTypeID;
        accountList.add(testAccount);
        
        Account testAccountContact = new Account();
        testAccountContact.Name = accountName + 'Con';
        testAccountContact.RecordtypeID = recordTypeID;
        accountList.add(testAccountContact);
        
        return accountList;
    }      
    static List<Contact> contactTestFactory(String uniqueIdentifier, ID accountForContact, Map<ID, String> userProfileMap){
        List<Contact> contactsList = new List<Contact>{};
        String contactType;
        String userProfileName;
        Contact contact = new Contact();
        Contact contactAcct = new Contact();
        
        contact.FirstName = 'Test';
        contact.LastName = 'Test' + uniqueIdentifier;
        String email = 'test' + uniqueIdentifier + '@gmtestail.com';
        contact.Email = email.replaceAll( '\\s+', '');
        contact.Phone = '0000000000';

        if(string.isNotEmpty(accountForContact)){
            contactAcct.FirstName = 'Test';
            contactAcct.LastName = 'Test' + uniqueIdentifier;
            email = 'test' + uniqueIdentifier + '@gmtestail.com';
            contactAcct.Email = email.replaceAll( '\\s+', '');
            contactAcct.Phone = '0000000000';
            contactAcct.AccountID = accountForContact;
        }
		
        userProfileName = userProfileMap.get(userinfo.getProfileId());
        if(userProfileName == 'DTNA - DTR' || userProfileName == 'DTNA - DTR UTM' || userProfileName.contains('STC')){
            contactType = 'Dealership Contact';
            contact.RecordTypeID = getContactType(contactType);
            contactAcct.recordTypeID = contact.RecordTypeID;
        }
        
        contactsList.add(contact);
        if(contactAcct.LastName != null){
        	contactsList.add(contactAcct);
        }
        return contactsList;
    }
    static List<Opportunity> opportunityTestFactory(String uniqueIdentifier, ID accountID, Map<ID, String> userProfileMap){
        List<Opportunity> opportunityList = new List<Opportunity>();
        String opportunityName = 'TEST_opportunity' + uniqueIdentifier;
        String recordTypeID;
		String opportunityType;
        String userProfileName = userProfileMap.get(UserInfo.getProfileID());
		opportunity testopportunity = new Opportunity();
        
        if(userProfileName == 'DTNA - DTR' || userProfileName.contains('STC')){
            opportunityType = 'DTR Opp';
            testOpportunity.Stagename = 'Quote';
            
        }else if(userProfileName == 'DTNA - DTR UTM'){
            opportunityType = 'DTNA - DTR UTM';
            testOpportunity.stageName = 'Bailing Trucks';
            
        }else if(uniqueIdentifier.contains('ISP')){
            opportunityType = 'International Sales Proposal';
            testOpportunity.ISP_PROBABILITY_OF_SUCCESS__C = '25%';
            
        }else if(uniqueIdentifier.contains('TWS')){
            opportunityType = 'Sales Quote';
            testOpportunity.Deal_Type__c = 'TC Deal';
            testOpportunity.Make__c = 'FCCC';
            testOpportunity.PriceProtect__c = 'Yes';   
            
        }else if(uniqueIdentifier.contains('Field')){
            opportunityType = 'Sales Quote';
            testOpportunity.stageName = 'Initial Contact';
        }else{
            System.debug('User does not have access to Opportunities, passing back an empty list.');
            return opportunityList;
        }
        testopportunity.RecordtypeID = getOpportunityType(opportunityType);
        System.Debug('Creating opportunities for User');
        
        testopportunity.Name = opportunityName;
        testOpportunity.accountID = accountID;
        testOpportunity.closeDate = Date.Today()+1;
        opportunityList.add(testopportunity);
        
        return opportunityList;
    }  
    static List<Concession__c> concessionFactory(String uniqueIdentifier, ID acctID){
        List<Concession__c> concessionList = new List<Concession__c>();
        String concessionName = 'TEST_Concession' + uniqueIdentifier;
        String typeOfConcession;

        System.Debug('Creating Concession for User');
        if(uniqueIdentifier.contains('FTL')){
            typeOfConcession = 'FTL Mainframe Concession';
        }else if(uniqueIdentifier.contains('WST')){
            typeOfConcession = 'WST Mainframe Concession';
        }else{
            System.debug('User is not of the groups allowed to create Concessions. None will be made');
            return concessionList;
        }
        
        Concession__c testConcession = new Concession__c();
        testConcession.Name = concessionName + typeOfConcession;
        testConcession.RecordTypeID = getConcessionRecordType(typeOfConcession);
        concessionList.add(testConcession);
        
        for(Integer i = 0; i < concessionList.size(); i++){
            System.debug('Concession: ' + concessionList[i].Name + ' has been created');
        }
        
        return concessionList;
    }
    
    static List<Task> taskTestFactory(ID objectID, List<Contact> contactList){
        string objectIDString = objectID;
        List<Task> createdTasks = new List<Task>{};
            
        if(objectID != null){
            Task createdTask = new Task();
            createdTask.Subject = 'TEST';
            createdTask.Status = 'Not Started';
            createdTask.Priority = 'Normal';
            createdTask.Type = 'ASP Group Quote - TWS';
            createdTask.TaskSubtype = 'Task';
            createdTask.OwnerId = userInfo.getUserId();
            if(objectIDString.substring(0,3) != '003'){
                createdTask.whatID = objectID;
            }else{
                createdTask.whoID = objectID;
            }
            createdTasks.add(createdTask);
        }
        return createdTasks;
    }
    static List<Event> eventFactory(ID objectID, List<Contact> contactList){
        String typeOfObject = 'Event';
        string objectIDString = objectID;
        List<Event> createdEvents = new List<Event>();
        Event event = new Event();
        event.Subject = 'TEST';
        event.DurationInMinutes = 400;
        event.ActivityDateTime = Date.today()+1;
        if(objectIDString.substring(0,3) != '003'){
            event.whatID = objectID;
        }else{
            event.whoID = objectID;
        }
        createdEvents.add(event);
        return createdEvents;
    }
    
    static List<Messaging.SingleEmailMessage> emailFactory(ID objectID, ID toContactID){
        
        String testString = 'Test';
        String objectIDString = objectID;
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        if(userInfo.getName().contains('STC')){
           EmailMessage newEmail = new EmailMessage();
        	newEmail.FromName = userInfo.getName();
        	newEmail.TextBody = 'Test';
        	if(objectIDString.substring(0,3) != '003'){
        		newEmail.RelatedToId = objectID;
        	}else{
            	newEmail.Toids.add(objectID);
        	}
            newEmail.Subject = 'Test';
            List<EmailMessage> emaillist2 = new List<EmailMessage>();
            emailList2.add(newEmail);
            testInsertSObject(emailList2, 'Email');
        }else{
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId(toContactID);
            system.debug('Account ID: ' + objectID);
            if(objectIDString.substring(0,3) != '003'){
               email.setWhatId(objectID); 
            }
            email.setSaveAsActivity(true);
            email.setSubject(testString);
            email.setPlainTextBody(testString); 
            emailList.add(email);
            }
        return emailList;  
    }
	
    //TestMethods
    //Account
    static testMethod void accountTaskForUserGroupCallCenter(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - Call Centers';
		String roleName = 'Call Centers Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountTasksForUserGroupDND(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - DND';
		String roleName = 'DND Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountTasksForUserGroupDTRAdmin(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - DTR';
        String roleName = 'DTR Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountTasksForUserGroupEastParts(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - Parts';
        String roleName = 'East Region Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountTasksForUserGroupASP(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - ASP';
        String roleName = 'Field Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountTasksForUserGroupFleet(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - Parts';
        String roleName = 'Fleet Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountTasksForUserGroupFTLAdmin(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - FTL Sales';
        String roleName = 'FTL Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountTasksForUserGroupFTLDOA(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - FTL DOA';
        String roleName = 'FTL DOA Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountTasksForUserGroupFTLRegional(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - Field Service';
        String roleName = 'FTL Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountTasksForUserGroupPartsMarketing(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - Parts';
        String roleName = 'Parts Marketing Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountTasksForUserGroupSpecialParts(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - Parts';
        String roleName = 'Specialty Parts Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountTasksForUserGroupUptimePro(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - Uptime Pro';
        String roleName = 'Uptime Pro Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountTasksForUserGroupUTM(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - DTR UTM';
        String roleName = 'UTM';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountTasksForUserGroupVIP(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - VIP Support';
        String roleName = 'VIP Support';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountTasksForUserGroupWestRegion(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - Parts';
        String roleName = 'West Region Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountTasksForUserGroupWSTAdmin(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - WST Sales';
        String roleName = 'WST Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountTasksForUserGroupWSTDOA(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - WST DOA';
        String roleName = 'WST DOA Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountTasksForUserGroupWSTRegion(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - Field Service';
        String roleName = 'WST Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEventForUserGroupCallCenter(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - Call Centers';
		String roleName = 'Call Centers Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEventForUserGroupDND(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - DND';
		String roleName = 'DND Admin';        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEventForUserGroupDTRAdmin(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - DTR';
        String roleName = 'DTR Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEventForUserGroupEastRegion(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - Parts';
        String roleName = 'East Region Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEventForUserGroupASP(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - ASP';
        String roleName = 'Field Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEventForUserGroupFleet(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - Parts';
        String roleName = 'Fleet Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEventForUserGroupFTLAdmin(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - FTL Sales';
        String roleName = 'FTL Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEventForUserGroupFTLDOA(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - FTL DOA';
        String roleName = 'FTL DOA Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEventForUserGroupFTLRegion(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - Field Service';
        String roleName = 'FTL Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEventForUserGroupPartsMarketing(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - Parts';
        String roleName = 'Parts Marketing Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEventForUserGroupSpecialParts(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - Parts';
        String roleName = 'Specialty Parts Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEventForUserGroupUptimePro(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - Uptime Pro';
        String roleName = 'Uptime Pro Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEventForUserGroupUTM(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - DTR UTM';
        String roleName = 'UTM';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEventForUserGroupVIP(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - VIP Support';
        String roleName = 'VIP Support';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEventForUserGroupWestRegion(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - Parts';
        String roleName = 'West Region Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEventForUserGroupWSTAdmin(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - WST Sales';
        String roleName = 'WST Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEventForUserGroupWSTDOA(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - WST DOA';
        String roleName = 'WST DOA Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEventForUserGroupWSTRegion(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - Field Service';
        String roleName = 'WST Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEmailForUserGroupCallCenter(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - Call Centers';
		String roleName = 'Call Centers Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEmailForUserGroupDND(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - DND';
		String roleName = 'DND Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEmailForUserGroupDTRAdmin(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - DTR';
        String roleName = 'DTR Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEmailForUserGroupEastRegion(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - Parts';
        String roleName = 'East Region Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEmailForUserGroupASP(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - ASP';
        String roleName = 'Field Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEmailForUserGroupFleet(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - Parts';
        String roleName = 'Fleet Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEmailForUserGroupFTLAdmin(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - FTL Sales';
        String roleName = 'FTL Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEmailForUserGroupFTLDOA(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - FTL DOA';
        String roleName = 'FTL DOA Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEmailForUserGroupFTLRegion(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - Field Service';
        String roleName = 'FTL Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEmailForUserGroupPartsMarketing(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - Parts';
        String roleName = 'Parts Marketing Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEmailForUserGroupSpecialParts(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - Parts';
        String roleName = 'Specialty Parts Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEmailForUserGroupUptimePro(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - Uptime Pro';
        String roleName = 'Uptime Pro Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEmailForUserGroupUTM(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - DTR UTM';
        String roleName = 'UTM';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEmailForUserGroupVIP(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - VIP Support';
        String roleName = 'VIP Support';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEmailForUserGroupWestRegion(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - Parts';
        String roleName = 'West Region Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEmailForUserGroupWSTAdmin(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - WST Sales';
        String roleName = 'WST Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEmailForUserGroupWSTDOA(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - WST DOA';
        String roleName = 'WST DOA Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEmailForUserGroupWSTRegion(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - Field Service';
        String roleName = 'WST Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void AccountNoteForUserGroupCallCenter(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - Call Centers';
		String roleName = 'Call Centers Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void AccountNoteForUserGroupDND(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - DND';
		String roleName = 'DND Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void AccountNoteForUserGroupDTRAdmin(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - DTR';
        String roleName = 'DTR Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void AccountNoteForUserGroupEastRegion(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - Parts';
        String roleName = 'East Region Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void AccountNoteForUserGroupASP(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - ASP';
        String roleName = 'Field Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void AccountNoteForUserGroupFleet(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - Parts';
        String roleName = 'Fleet Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void AccountNoteForUserGroupFTLAdmin(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - FTL Sales';
        String roleName = 'FTL Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void AccountNoteForUserGroupFTLDOA(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - FTL DOA';
        String roleName = 'FTL DOA Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void AccountNoteForUserGroupFTLRegion(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - Field Service';
        String roleName = 'FTL Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void AccountNoteForUserGroupPartsMarketing(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - Parts';
        String roleName = 'Parts Marketing Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void AccountNoteForUserGroupSpecialParts(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - Parts';
        String roleName = 'Specialty Parts Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void AccountNoteForUserGroupUptimePro(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - Uptime Pro';
        String roleName = 'Uptime Pro Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void AccountNoteForUserGroupUTM(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - DTR UTM';
        String roleName = 'UTM';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void AccountNoteForUserGroupVIP(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - VIP Support';
        String roleName = 'VIP Support';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void AccountNoteForUserGroupWestRegion(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - Parts';
        String roleName = 'West Region Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void AccountNoteForUserGroupWSTAdmin(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - WST Sales';
        String roleName = 'WST Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void AccountNoteForUserGroupWSTDOA(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - WST DOA';
        String roleName = 'WST DOA Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void AccountNoteForUserGroupWSTRegion(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - Field Service';
        String roleName = 'WST Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    
    //Contact
    static testMethod void contactTaskForUserGroupCallCenter(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - Call Centers';
		String roleName = 'Call Centers Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactTaskForUserGroupDND(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - DND';
		String roleName = 'DND Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactTaskForUserGroupDTRAdmin(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - DTR';
        String roleName = 'DTR Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactTaskForUserGroupEastRegion(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - Parts';
        String roleName = 'East Region Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactTaskForUserGroupASP(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - ASP';
        String roleName = 'Field Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactTaskForUserGroupFleet(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - Parts';
        String roleName = 'Fleet Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactTaskForUserGroupFTLAdmin(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - FTL Sales';
        String roleName = 'FTL Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactTaskForUserGroupFTLDOA(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - FTL DOA';
        String roleName = 'FTL DOA Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactTaskForUserGroupFTLRegion(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - Field Service';
        String roleName = 'FTL Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactTaskForUserGroupPartsMarketing(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - Parts';
        String roleName = 'Parts Marketing Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactTaskForUserGroupSpecialParts(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - Parts';
        String roleName = 'Specialty Parts Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactTaskForUserGroupUptimePro(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - Uptime Pro';
        String roleName = 'Uptime Pro Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactTaskForUserGroupUTM(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - DTR UTM';
        String roleName = 'UTM';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactTaskForUserGroupVIP(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - VIP Support';
        String roleName = 'VIP Support';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactTaskForUserGroupWestRegion(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - Parts';
        String roleName = 'West Region Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactTaskForUserGroupWSTAdmin(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - WST Sales';
        String roleName = 'WST Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactTaskForUserGroupWSTDOA(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - WST DOA';
        String roleName = 'WST DOA Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactTaskForUserGroupWSTRegion(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - Field Service';
        String roleName = 'WST Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEventForUserGroupCallCenter(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - Call Centers';
		String roleName = 'Call Centers Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEventForUserGroupDND(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - DND';
		String roleName = 'DND Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
	static testMethod void contactEventForUserGroupDTRAdmin(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - DTR';
        String roleName = 'DTR Admin';

		Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
	}

    static testMethod void contactEventForUserGroupEastRegion(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - Parts';
        String roleName = 'East Region Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEventForUserGroupASP(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - ASP';
        String roleName = 'Field Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEventForUserGroupFleet(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - Parts';
        String roleName = 'Fleet Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEventForUserGroupFTLAdmin(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - FTL Sales';
        String roleName = 'FTL Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEventForUserGroupFTLDOA(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - FTL DOA';
        String roleName = 'FTL DOA Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEventForUserGroupFTLRegion(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - Field Service';
        String roleName = 'FTL Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEventForUserGroupPartsMarketing(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - Parts';
        String roleName = 'Parts Marketing Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEventForUserGroupSpecialParts(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - Parts';
        String roleName = 'Specialty Parts Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEventForUserGroupUptimePro(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - Uptime Pro';
        String roleName = 'Uptime Pro Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEventForUserGroupUTM(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - DTR UTM';
        String roleName = 'UTM';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEventForUserGroupVIP(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - VIP Support';
        String roleName = 'VIP Support';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEventForUserGroupWestRegion(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - Parts';
        String roleName = 'West Region Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEventForUserGroupWSTAdmin(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - WST Sales';
        String roleName = 'WST Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEventForUserGroupWSTDOA(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - WST DOA';
        String roleName = 'WST DOA Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEventForUserGroupWSTRegion(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - Field Service';
        String roleName = 'WST Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEmailForUserGroupCallCenter(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - Call Centers';
		String roleName = 'Call Centers Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEmailForUserGroupDND(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - DND';
		String roleName = 'DND Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEmailForUserGroupDTRAdmin(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - DTR';
        String roleName = 'DTR Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEmailForUserGroupEastRegion(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - Parts';
        String roleName = 'East Region Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEmailForUserGroupASP(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - ASP';
        String roleName = 'Field Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEmailForUserGroupFleet(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - Parts';
        String roleName = 'Fleet Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEmailForUserGroupFTLAdmin(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - FTL Sales';
        String roleName = 'FTL Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEmailForUserGroupFTLDOA(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - FTL DOA';
        String roleName = 'FTL DOA Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEmailForUserGroupFTLRegion(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - Field Service';
        String roleName = 'FTL Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEmailForUserGroupPartsMarketing(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - Parts';
        String roleName = 'Parts Marketing Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEmailForUserGroupSpecialParts(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - Parts';
        String roleName = 'Specialty Parts Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEmailForUserGroupUptimePro(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - Uptime Pro';
        String roleName = 'Uptime Pro Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEmailForUserGroupUTM(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - DTR UTM';
        String roleName = 'UTM';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEmailForUserGroupVIP(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - VIP Support';
        String roleName = 'VIP Support';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEmailForUserGroupWestRegion(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - Parts';
        String roleName = 'West Region Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEmailForUserGroupWSTAdmin(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - WST Sales';
        String roleName = 'WST Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEmailForUserGroupWSTDOA(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - WST DOA';
        String roleName = 'WST DOA Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEmailForUserGroupWSTRegion(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - Field Service';
        String roleName = 'WST Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void ContactNoteForUserGroupCallCenter(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - Call Centers';
		String roleName = 'Call Centers Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void ContactNoteForUserGroupDND(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - DND';
		String roleName = 'DND Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void ContactNoteForUserGroupDTRAdmin(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - DTR';
        String roleName = 'DTR Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void ContactNoteForUserGroupEastRegion(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - Parts';
        String roleName = 'East Region Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void ContactNoteForUserGroupASP(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - ASP';
        String roleName = 'Field Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void ContactNoteForUserGroupFleet(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - Parts';
        String roleName = 'Fleet Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void ContactNoteForUserGroupFTLAdmin(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - FTL Sales';
        String roleName = 'FTL Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void ContactNoteForUserGroupFTLDOA(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - FTL DOA';
        String roleName = 'FTL DOA Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void ContactNoteForUserGroupFTLRegion(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - Field Service';
        String roleName = 'FTL Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void ContactNoteForUserGroupPartsMarketing(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - Parts';
        String roleName = 'Parts Marketing Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void ContactNoteForUserGroupSpecialParts(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - Parts';
        String roleName = 'Specialty Parts Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void ContactNoteForUserGroupUptimePro(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - Uptime Pro';
        String roleName = 'Uptime Pro Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void ContactNoteForUserGroupUTM(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - DTR UTM';
        String roleName = 'UTM';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void ContactNoteForUserGroupVIP(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - VIP Support';
        String roleName = 'VIP Support';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void ContactNoteForUserGroupWestRegion(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - Parts';
        String roleName = 'West Region Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void ContactNoteForUserGroupWSTAdmin(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - WST Sales';
        String roleName = 'WST Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void ContactNoteForUserGroupWSTDOA(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - WST DOA';
        String roleName = 'WST DOA Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void ContactNoteForUserGroupWSTRegion(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Note';
        String profileName = 'DTNA - Field Service';
        String roleName = 'WST Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    
    //Opportunity
    static testMethod void opportunityTaskForUserGroupDTRAdmin(){
        String objectForPGA = 'Opportunity';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - DTR';
        String roleName = 'DTR Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void opportunityTaskForUserGroupASP(){
        String objectForPGA = 'Opportunity';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - ASP';
        String roleName = 'Field Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void opportunityTaskForUserGroupUTM(){
        String objectForPGA = 'Opportunity';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - DTR UTM';
        String roleName = 'UTM';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void opportunityEventForUserGroupDTRAdmin(){
        String objectForPGA = 'Opportunity';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - DTR';
        String roleName = 'DTR Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void opportunityEventForUserGroupASP(){
        String objectForPGA = 'Opportunity';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - ASP';
        String roleName = 'Field Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void opportunityEventForUserGroupUTM(){
        String objectForPGA = 'Opportunity';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - DTR UTM';
        String roleName = 'UTM';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void opportunityEmailForUserGroupDTRAdmin(){
        String objectForPGA = 'Opportunity';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - DTR';
        String roleName = 'DTR Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void opportunityEmailForUserGroupASP(){
        String objectForPGA = 'Opportunity';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - ASP';
        String roleName = 'Field Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void opportunityEmailForUserGroupUTM(){
        String objectForPGA = 'Opportunity';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - DTR UTM';
        String roleName = 'UTM';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void concessionTaskForUserGroupFTLAdmin(){
        String objectForPGA = 'Concession';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - FTL Sales';
        String roleName = 'FTL Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void concessionTaskForUserGroupFTLDOA(){
        String objectForPGA = 'Concession';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - FTL DOA';
        String roleName = 'FTL DOA Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void concessionTaskForUserGroupFTLRegion(){
        String objectForPGA = 'Concession';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - Field Service';
        String roleName = 'FTL Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void concessionTaskForUserGroupWSTAdmin(){
        String objectForPGA = 'Concession';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - WST Sales';
        String roleName = 'WST Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void concessionTaskForUserGroupWSTDOA(){
        String objectForPGA = 'Concession';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - WST DOA';
        String roleName = 'WST DOA Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void concessionTaskForUserGroupWSTRegion(){
        String objectForPGA = 'Concession';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - Field Service';
        String roleName = 'WST Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void concessionEventForUserGroupFTLAdmin(){
        String objectForPGA = 'Concession';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - FTL Sales';
        String roleName = 'FTL Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void concessionEventForUserGroupFTLDOA(){
        String objectForPGA = 'Concession';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - FTL DOA';
        String roleName = 'FTL DOA Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void concessionEventForUserGroupFTLRegion(){
        String objectForPGA = 'Concession';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - Field Service';
        String roleName = 'FTL Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void concessionEventForUserGroupWSTAdmin(){
        String objectForPGA = 'Concession';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - WST Sales';
        String roleName = 'WST Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void concessionEventForUserGroupWSTDOA(){
        String objectForPGA = 'Concession';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - WST DOA';
        String roleName = 'WST DOA Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void concessionEventForUserGroupWSTRegion(){
        String objectForPGA = 'Concession';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - Field Service';
        String roleName = 'WST Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void concessionEmailForUserGroupFTLAdmin(){
        String objectForPGA = 'Concession';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - FTL Sales';
        String roleName = 'FTL Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void concessionEmailForUserGroupFTLDOA(){
        String objectForPGA = 'Concession';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - FTL DOA';
        String roleName = 'FTL DOA Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void concessionEmailForUserGroupFTLRegion(){
        String objectForPGA = 'Concession';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - Field Service';
        String roleName = 'FTL Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void concessionEmailForUserGroupWSTAdmin(){
        String objectForPGA = 'Concession';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - WST Sales';
        String roleName = 'WST Admin';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void concessionEmailForUserGroupWSTDOA(){
        String objectForPGA = 'Concession';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - WST DOA';
        String roleName = 'WST DOA Rep';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void concessionEmailForUserGroupWSTRegion(){
        String objectForPGA = 'Concession';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - Field Service';
        String roleName = 'WST Regional Service Director';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountTaskForUserGroupSTCCleveland(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - STC Cleveland';
        String roleName = 'STC Cleveland Manager';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEventForUserGroupSTCCleveland(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - STC Cleveland';
        String roleName = 'STC Cleveland Manager';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void accountEmailForUserGroupSTCCleveland(){
        String objectForPGA = 'Account';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - STC Cleveland';
        String roleName = 'STC Cleveland Manager';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactTaskForUserGroupSTCCleveland(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - STC Cleveland';
        String roleName = 'STC Cleveland Manager';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void contactEventForUserGroupSTCCleveland(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - STC Cleveland';
        String roleName = 'STC Cleveland Manager';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    /*-------------------
    static testMethod void contactEmailForUserGroupSTCCleveland(){
        String objectForPGA = 'Contact';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - STC Cleveland';
        String roleName = 'STC Cleveland Manager';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
------------------------*/
    
    static testMethod void opportunityTaskForUserGroupSTCCleveland(){
        String objectForPGA = 'Opportunity';
        String typeOfPGA = 'Task';
        String profileName = 'DTNA - STC Cleveland';
        String roleName = 'STC Cleveland Manager';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    static testMethod void opportunityEventForUserGroupSTCCleveland(){
        String objectForPGA = 'Opportunity';
        String typeOfPGA = 'Event';
        String profileName = 'DTNA - STC Cleveland';
        String roleName = 'STC Cleveland Manager';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
    
    static testMethod void opportunityEmailForUserGroupSTCCleveland(){
        String objectForPGA = 'Opportunity';
        String typeOfPGA = 'Email';
        String profileName = 'DTNA - STC Cleveland';
        String roleName = 'STC Cleveland Manager';
        
        Test.startTest();
            performPGATest(objectForPGA, typeOfPGA, profileName, roleName);
        Test.stopTest();
    }
}