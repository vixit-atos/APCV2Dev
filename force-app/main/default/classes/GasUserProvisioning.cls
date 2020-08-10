/*
Author: Noctis Caelum
Created Date: 07/06/2019

Functionality: 
1. User Provisioning for GAS SSO

Change History : 
SL No.  |   Date    	 |   ModifiedBy      |   Ticket Number    |   Modified Reason  
1		8/22/2019		Satish Kumar								Development for adding the Permission Set
2		8/22/2019		Anto										Review Corrections
3       8/26/2019		Satish Kumar								Development to store all the fields received from the attributes
3       8/27/2019		Satish Kumar								Development to create Unique User name assign respective L2 manager, and skip update if record is manually updated.

*/

global class GasUserProvisioning implements Auth.SamlJitHandler{
    String email, federationId, lastName, firstName, phone, localeSidKey, emailEncodingKey, languageLocaleKey, city, state, country;
    static final String requestName = 'Gas User Provisioning';
    User gasUser;
    private Logger gasLogger;
    List<SSO_JIT_Provisioning__mdt> gasMetadata = [SELECT Id, Default_Timezone__c, EmailKey__c, LanguageKey__c, Login_Profile__c,User_Name_Suffix__c FROM SSO_JIT_Provisioning__mdt
                                                   WHERE Label = 'GAS' LIMIT 1];
    // Retrieving permission sets from the meta data
    List<External_Role_Permission_Set_Assignment__mdt> permissionByRole = [SELECT Permission_Set__c,Role__c
                                                                           FROM External_Role_Permission_Set_Assignment__mdt];
    static final String userApplicationRoles = 'DTNA_GAS_CX_EMP';   // Role to Identify the list of permission sets
    private class SsoException extends Exception {} //allows us to throw custom exception
    String JoinedString;
    String AttributeValue;
    
    
    global User createUser(Id samlGasProviderId, Id communityId, Id portalId, String federationId, Map<String, String> attributes, String assertion) {    
        try{
            If (attributes != null){
                //Throw exception for external users
                if (attributes.get('dcxOrganizationalStatus')=='external person' ) throw new SsoException('External Users are not allowed');
                //Throw exception for non DTNA users
                //if (attributes.get('dcxOrganizationalStatus')!='164'  ) throw new SsoException('Not Part of DTNA');
                
                gasUser = new User();
                Profile userProfile = [SELECT Id 
                                       FROM Profile 
                                       WHERE Name =: gasMetadata[0].Login_Profile__c 
                                       LIMIT 1];
                gasUser = setUserFields(gasUser, userProfile.Id, attributes, federationId, gasMetadata[0]);
                insert gasUser;
                //Adding permission sets
                Map<Id,Id> idMap = parseStringForRoles(gasUser, userApplicationRoles, permissionByRole);
                if (idMap != null)
                    insertSets(idMap); //@future method to avoid mixed DML error
                
                // Logging the Attributes value received
                for(String Attributekey : attributes.keyset()){
                    AttributeValue= attributes.get(Attributekey);
                    JoinedString += Attributekey + '=' + AttributeValue + ',' ;
                }
            }    
            Logger.insertLog(requestName, federationId,'','','',1,'','',joinedString, true);
            System.debug('String attributes='+joinedString);
        }
        catch(Exception e){
            Logger.insertLog(requestName, federationId, e, 'Error with GAS Create User', true); 
        }
        
        return gasUser;
    }
    
    global void updateUser(Id userId, Id samlGasProviderId, Id communityId, Id portalId, String federationId, Map<String, String> attributes, String assertion)  {
        try{
            
            gasUser = [Select Id, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey, Email, FederationIdentifier, LastName, FirstName, TimeZoneSidKey,Manual_Update__c 
                       FROM User 
                       WHERE Id =: userId];
            If (gasUser.Manual_Update__c != true){
                
                gasUser = setUserFields(gasUser, null, attributes, federationId, gasMetadata[0]);
                update gasUser;
            }
            // Logging the Attributes value received
            for(String Attributekey : attributes.keyset()){
                AttributeValue = attributes.get(Attributekey);
                JoinedString += Attributekey + '=' + AttributeValue + ',' ;   
            }
            Logger.insertLog(requestName, federationId,'','','',1,'','',JoinedString, true);
            System.debug('String attributes='+JoinedString);
        }catch(Exception e){
            Logger.insertLog(requestName, federationId, e, 'Error with GAS Update User', true);
        }
    }
    
    /*
* If creating a user, sets the other variables according to the Gas Metadata
* Sets attributes according to the attributes from Gas
* Returns the user
*/    
    static User setUserFields(User currentUser, Id profileId, Map<String, String> attributes, String federationId, SSO_JIT_Provisioning__mdt gasMetadata){
        
        currentUser.Email = attributes.get('mail');
        if(currentUser.Id == null){
            currentUser.LocaleSidKey = 'en_US';
            currentUser.EmailEncodingKey = 'ISO-8859-1';
            currentUser.ProfileId = profileId;
            currentUser.LanguageLocaleKey = gasMetadata.LanguageKey__c;
            currentUser.FederationIdentifier = attributes.get('uid');
            currentUser.UserName = currentUser.Email + '.dtna.'+ gasMetadata.User_Name_Suffix__c + '.' + currentUser.FederationIdentifier;
            
        }
        currentUser.Organizational_Status__c = attributes.get('dcxOrganizationalStatus');
        currentUser.DTNA_Department__c = attributes.get('dcxDepartmentAbbr');
        currentUser.UUID__c = attributes.get('dcxUUID');
        currentUser.Plant1__c = attributes.get('dcxPlant1');
        currentUser.UniqueID__c = attributes.get('dcxUniqueID');
        currentUser.Supervisor__c = attributes.get('dcxSupervisor');
        currentUser.Organizational_Unit__c = attributes.get('ou');
        currentUser.Location__c = attributes.get('l');
        currentUser.isActive = true;
        // Adding Manager based on attribute value Supervisor.
        if (attributes.get('dcxSupervisor')!= null){
            List<User> SupevisorUser = new List<User>();
            SupevisorUser = [Select Id,FederationIdentifier FROM User WHERE FederationIdentifier = :attributes.get('dcxSupervisor') Limit 1];
            if (SupevisorUser.size() > 0) 
                currentUser.ManagerId=SupevisorUser[0].id;
        }
        // Reason for Additional query - Will get very complicated in case of multiple Superviors and  Level 2 managers.   
        
        List<User> L2Managerlist = [Select Id,DTNA_Department__c,Level_2__c FROM User WHERE Level_2__c = true];
        //Identifying and assigning L2 manager based on department.
        for ( User L2Manager: L2Managerlist){
            if (attributes.get('dcxDepartmentAbbr')!= null && L2Manager.DTNA_Department__c != null){
                if((attributes.get('dcxDepartmentAbbr').contains(L2Manager.DTNA_Department__c) )){
                    currentUser.L2_Manager__c=L2Manager.id;
                    Break;
                } 
            }
        }
        setAttributes(currentUser, attributes, gasMetadata.Default_Timezone__c);
        return currentUser;
    }
    
    /*
* Sets fields by the GAS Attributes given
* If a field is different, overrides the field with the GAS Information
* returns the user
*/ 
    static User setAttributes(User currentUser, Map<String, String> attributes, String defaultTimezone){
        //currentUser.isActive = true;
        Boolean userNameChange = false;
        Boolean nameChange = false;
        if(currentUser.LastName != attributes.get('sn')){
            currentUser.LastName = attributes.get('sn');
            nameChange = true;
        }
        if(currentUser.FirstName != attributes.get('givenName')){
            currentUser.FirstName = attributes.get('givenName');
            nameChange = true;
        }
        List<String> stateSplit = attributes.get('dcxPostalAddress').split(attributes.get('l'));
        String abbreviatedState = stateSplit[1];
        abbreviatedState = abbreviatedState.substring(2, 4);
        String timeZone = getTimeZone(abbreviatedState, defaultTimezone);
        
        if(currentUser.TimeZoneSidKey != getTimeZone(abbreviatedState, defaultTimezone)){
            currentUser.TimeZoneSidKey = timeZone;
        }
        if(nameChange == true){
            currentUser.Alias = (currentUser.FirstName != null ? currentUser.FirstName.substring(0,1) : '') + currentUser.LastName.substring(0, Math.min(currentUser.LastName.length(), 4));
        }
        return currentUser;
    }
    
    /*
* Set permission sets based on the Role defined in the meta data External_Role_Permission_Set_Assignment__mdt and Application roles hard coded on the top.
*/ 
    @future
    public static void insertSets(Map<Id, Id> idMap) { //taking ids because @future methods can't take sObjects
        List<PermissionSetAssignment> toInsert = new List<PermissionSetAssignment>();
        for (Id key : idMap.keySet()) {
            Id value = idMap.get(key);
            PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId=key, AssigneeId=value);
            toInsert.add(psa);
            System.debug('Inserting '+psa);
        }
        List<Database.SaveResult> srList = Database.insert(toInsert, false);      
        for (Database.SaveResult sr : srList) 
        {
            if (sr.getErrors().size() > 0)
                throw new SsoException('Failed to add permission set: '+sr.getErrors()[0].getMessage());
        }
    }
    /*
* Set permission sets based on the Role defined in the meta data External_Role_Permission_Set_Assignment__mdt and Application roles hard coded on the top.
*/   
    public static Map<Id,Id> parseStringForRoles(User user, String userApplicationRoles, List<External_Role_Permission_Set_Assignment__mdt> permissionByRole) {
        if (user==null || userApplicationRoles==null || permissionByRole==null)
            return null;
        
        List<String> permNames = new List<String>();
        Map<String,Id> psMap = new Map<String,Id>();
        Map<Id,Id> returnMap = new Map<Id,Id>();
        for (External_Role_Permission_Set_Assignment__mdt x : permissionByRole) 
            permNames.add(x.Permission_Set__c);
        List<PermissionSet> ps = [SELECT Id,Name FROM PermissionSet WHERE name IN :permNames];
        for (PermissionSet p : ps)
            psMap.put(p.Name,p.Id);
        System.debug('psMap '+psMap);
        for (External_Role_Permission_Set_Assignment__mdt x : permissionByRole) 
        {
            if (UserApplicationRoles.contains(x.Role__c)) 
            {
                Id psId = psMap.get(x.Permission_Set__c);
                if (psId == null) {
                    System.debug('Failed to find permission set '+x.Permission_set__c+'. Not adding.');
                    continue;
                }
                PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId=psId, AssigneeId=user.Id);
                returnMap.put(psId, user.Id);
                System.debug('Added permission set '+x.Permission_set__c);
            }
        }
        return returnMap;
    }
    
    /*
* getTimezone uses the User's state to set their timezone
* State is a 2 character field that represents the states
* Returns the timezone in Salesforce's specific terms
* FL, IN, KY, TX, and TN are all being assigned to Central Standard Time even though they have multiple time zones
*/
    static String getTimezone(String state, String defaultTimezone){
        if (state == null) return null; 
        String timezone = null;
        switch on state{
            when 'AK'{//Alaskan Standard Time
                timezone = 'America/Anchorage'; 
            }
            when 'HI'{//Hawaiian Standard Time    
                timezone = 'Pacific/Honolulu';          
            }
            when 'CA', 'NV', 'OR', 'WA'{//Pacific Standard Time;
                timezone = 'America/Los_Angeles'; 
            }
            when 'AZ', 'CO', 'ID', 'MT', 'NM', 'UT', 'WY'{//Mountain Standard Time
                timezone = 'America/Denver'; 
            }
            when 'CT', 'DE', 'GA', 'ME', 'MD', 'MA', 'MI', 'NH', 'NJ', 'NY', 'NC', 'OH', 'PA', 'RI', 'SC', 'VT', 'VA', 'WV'{//Eastern Standard Time
                timezone = 'America/New_York'; 
            }
            when 'AL', 'AR', 'IL', 'IA', 'KS', 'LA', 'MN', 'MS', 'MO', 'NE', 'ND', 'OK', 'SD', 'WI', 'FL', 'IN', 'KY', 'TX', 'TN'{//Central Standard Time
                timezone = 'America/Chicago'; 
            }
            when else{
                timezone = defaultTimezone;
            }
        }
        return timezone;
    }
}