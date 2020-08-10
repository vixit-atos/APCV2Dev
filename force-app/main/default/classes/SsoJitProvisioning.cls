global class SsoJitProvisioning implements Auth.SamlJitHandler {
    
/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* One or two sentence summary of this class.
*
* When a user tries to sign in, this class checks if the user exists and if there is a matching contact and account and creates what doesn't exist.
* Note that if a matching contact exists, it assumes there is a matching account and if the user exists, it assumes there is a matching contact. 
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Doren Proctor
* @modifiedBy          
* @version        1.0
* @created        10-08-2018
* @modified       MM-DD-YYYY
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* modifiedBy            
* MM-DD-YYYY      Explanation of the change.  Multiple lines can be used to explain the change, but
*                 each line should be indented till left aligned with the previous description text.
*
* modifiedBy           
* MM-DD-YYYY      Each change to this file should be documented by incrementing the version number,
*                 and adding a new entry to this @changes list. Note that there is a single blank
*                 line between each @changes entry.
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘

Things that are currently being generated automatically:
  -new account name = lName+'\'s Account'
  -alias = 1st character of fName + 1st 4 of lName
  -community nickname = fName + lName. Since this value must be unique, a number 
    is added if there are duplicates. This requires its own SOQL call.

psuedoCode() {
    if (existingUser)
        return;
    if (existingContact)
        contact.Id = existingContact.id;
    else
        if (existingAccount)
            accountid = existingAccount.id;
        else
            create newAccount;
            accountid = newAccount.id;
        create contact with accountid;
        contact.Id = newAccount.id;
    create user with contact.Id;
*/
    public class JitException extends Exception{ //allows custom code for exceptions
        public JitException(String s, String dtnaId) {
            this('User with FedID '+dtnaId+': '+s); //throw normal exception
            String message = 'User with FedID '+dtnaId+': '+s;
            System.debug('In JitException: '+message);
        }
    }

    
    private User createUserHelper(Map<String, String> mapAttrib, String dtnaId)  {
        // These values should be passed in attributes (the a variable):
        // UserID FirstName LastName Email UserApplicationRoles UserPrimaryOrgCode 
        // Visibilities Telephone Location State Country

        // Custom Metadata to avoid hardcoding in class. Defaults: 
        // Default_Timezone__c ->   America/Los_Angeles
        // Profile__c ->       Partner Community User
        // RecordType__c ->     Dealership_Contact
        // EmailKey__c ->       ISO-8859-1
        // LanguageKey__c ->     en_US
        // Account_Record_Type__c-> Dealership
        List<SSO_Jit_Provisioning__mdt> mdt = [SELECT Profile__c,RecordType__c,LanguageKey__c,
                                         EmailKey__c,Default_Timezone__c,Account_Record_Type__c,Label 
                                         FROM SSO_Jit_Provisioning__mdt WHERE Label='Default'];
        if (mdt.size() != 1)
            throw new JitException('SSO_Jit_Provisioning__mdt was not found',dtnaId);
        SSO_Jit_Provisioning__mdt lstMdtDefault = mdt[0];
        
        List<External_Role_Permission_Set_Assignment__mdt> permissionByRole = [SELECT Permission_Set__c,Role__c
                                                                        FROM External_Role_Permission_Set_Assignment__mdt];
        
        System.debug('Custom metadata object: '+lstMdtDefault);
        System.debug('dtnaId: '+dtnaId);
        System.debug('attributes: '+ mapAttrib);
        
        
        if (mapAttrib == null)
            throw new JitException('Did not send any attributes', dtnaId);
        
        //The following variables are obtained from the attributes map and are used to create new records
        String lName = mapAttrib.containsKey('LastName') && mapAttrib.get('LastName')!='' ? mapAttrib.get('LastName') : null;
        String fName = mapAttrib.containsKey('FirstName') && mapAttrib.get('FirstName')!='' ? mapAttrib.get('FirstName') : null;
        String emailId = mapAttrib.containsKey('Email') && mapAttrib.get('Email')!='' ? mapAttrib.get('Email') : null;
        String phone = mapAttrib.containsKey('Telephone') && mapAttrib.get('Telephone')!='' ? mapAttrib.get('Telephone') : null;
        String city = mapAttrib.containsKey('Location') && mapAttrib.get('Location')!='' ? mapAttrib.get('Location') : null;
        String state = mapAttrib.containsKey('State') && mapAttrib.get('State')!='' ? mapAttrib.get('State') : null;
        String country = mapAttrib.containsKey('Country') && mapAttrib.get('Country')!='' ? mapAttrib.get('Country') : null;
        String timezone = getTimezone(state);
        String upoc = mapAttrib.containsKey('UserPrimaryOrgCode') && mapAttrib.get('UserPrimaryOrgCode')!='' ? mapAttrib.get('UserPrimaryOrgCode') : null;
        String userApplicationRoles = mapAttrib.containsKey('UserApplicationRoles') && mapAttrib.get('UserApplicationRoles')!='' ? mapAttrib.get('UserApplicationRoles') : null;
        String dealerCode = upoc!=null ? upoc.substringAfter('cn=').substringBefore(',') : null;
        String ou = upoc!=null ? upoc.substringAfter('ou=').substringBefore(',') : null;
        
        System.debug('lName: '+lName+', emailId: '+emailId+', dealerCode: '+dealerCode+
                     ', ou: '+ou+', fName: '+fName+', phone: '+phone+', city: '+city+
                     ', state: '+state+', country: '+country+', timezone: '+timezone+',UserPrimaryOrgCode: '+upoc);
        System.debug('userApplicationRoles: '+userApplicationRoles);
        if (emailId==null || dealerCode==null) 
            throw new JitException('Did not send required info. '+emailId+', dealerCode: '+dealerCode+', dtnaId', dtnaId);
        
        /*if (ou == 'corporate') 
            throw new JitException('Not doing anything because ou is corporate', dtnaId);
        */
        
		List<User> users = [SELECT firstname,lastname,federationidentifier,isActive FROM User WHERE FederationIdentifier =: dtnaId]; 
        if (users.size() == 1)  //should only happen if the user exists but hasn't signed in using SSO before or something like that
            throw new JitException('Somehow found an existing user inside createUser()', dtnaId);

        //gets or creates a contact. If it has to create a contact, it calls getAccount
        Contact contact = getContact(dtnaId, dealerCode, fName, lName, emailId, city, state, country, phone, lstMdtDefault);
        
        if (lName == null)  { //if no last name, use contact's last name
            if (contact.LastName != null) {
                lName = contact.LastName;
                System.debug('No last name provided. Trying to use contact\'s last name: '+lName);
            } else
                throw new JitException('Tried to create a user without providing a last name', dtnaId);
        }
        System.debug('Creating user');
        String username = emailId + '.dtna.'+dtnaId;
        String alias = fName!=null ? fName.substring(0,1) : null; //1st character of fName + 1st 4 of lName unless fName is null; then just 1st 4 of lName
        alias = alias!=null ? alias + lName.substring(0, Math.min(lName.length(), 4)) : lName.substring(0, Math.min(lName.length(), 4));
        List<Profile> profs = [SELECT Id FROM profile WHERE name=:lstMdtDefault.Profile__c];
        Id profileId;
        if (profs.size() == 1)
            profileId = profs[0].Id;
        else {
            System.debug('Profile '+lstMdtDefault.Profile__c+' not found. Using DEALER-PARTNER-COMMUNITY-LOGIN');
            profileId = [SELECT Id FROM Profile WHERE name ='DEALER-PARTNER-COMMUNITY-LOGIN'].Id;
        }
        if (timezone == null) timezone = lstMdtDefault.Default_Timezone__c; //default to LA timezone
        System.debug('alias: '+alias+', profileId: '+profileId+', timezone: '+timezone);
        User newUser = new User(ContactId=contact.Id, FederationIdentifier=dtnaId, 
                                FirstName=fName, LastName=lName, Email=emailId,
                                Username=username, Alias=alias, TimeZoneSidKey=timezone, 
                                Phone=phone, LocaleSidKey=lstMdtDefault.LanguageKey__c, 
                                EmailEncodingKey=lstMdtDefault.EmailKey__c, ProfileId=profileId, 
                                LanguageLocaleKey=lstMdtDefault.LanguageKey__c);
        try { insert newUser; }
        catch(Exception e) {
            if (e.getMessage().contains('portal user already exists for contact')) {
                System.debug('Portal user already exists for contact. Creating new one');
                Account acc = getAccount(dtnaId, dealerCode, city, state, country, lstMdtDefault);
                Contact newCont = new Contact(AccountId=acc.Id, FirstName=fName, LastName=lName, Email=emailId,
                                    MailingCity=city, MailingState=state, MailingCountry=country,
                                    Phone=phone);
                try { insert newCont; }
                catch(Exception ex) { throw new JitException('Failed to insert contact: '+ex, dtnaId); }
                newUser.ContactId = newCont.Id;
                try { insert newUser; }
                catch(Exception ex) { throw new JitException('Failed to insert user: '+ex, dtnaId); }
            } else
                throw new JitException('Failed to insert user: '+e, dtnaId);
        }

        insertPermissions(newUser, userApplicationRoles, dtnaId);
        return newUser;
    }

    
    private Contact getContact(String dtnaId, String dealerCode, String fName, String lName, String emailId, 
                                    String city, String state, String country, String phone, SSO_Jit_Provisioning__mdt lstMdtDefault) {
        List<Contact> contacts = [SELECT LastModifiedDate,FirstName,LastName FROM Contact WHERE email =: emailId 
                                    AND (Account.Dealer_Code__c =:dealerCode  OR Account.PrimaryOutletCd__c =:dealerCode)];
        Contact contact;
        if (contacts.size() > 1) {
            Contact c = getLatestContact(contacts);
            contact = c;
        }
        else if(contacts.size() == 1)  { //contact exists
            System.debug('Contact already exists');
            contact = contacts[0];
        } 
        else { //contact does not exist
            System.debug('No contact with matching email and dealercode');
            Account acc = getAccount(dtnaId, dealerCode, city, state, country, lstMdtDefault);
            //Didn't find a contact with matching email, type, and dealercode earlier.
            //Try to find a contact that just matches email
            contacts = [SELECT LastModifiedDate,FirstName,LastName FROM Contact WHERE email =: emailId];
            if(contacts.size() > 0) {
                Contact c;
                if (contacts.size() == 1)  { //found one contact
                    System.debug('Found matching contact that is not tied to expected dealer account');
                    c = contacts[0];
                }
                else  { //found multiple contacts
                    c = getLatestContact(contacts);
                }
                c.AccountId = acc.Id;

                try { update c; }
                catch(Exception e) { throw new JitException('Failed to update account for existing contact: '+e, dtnaId); }
                Role__c role = new Role__c(Account__c=acc.Id, Contact__c=c.Id);
                try { insert role; }
                catch(Exception e) { throw new JitException('Failed to insert new role: '+e, dtnaId); }
                System.debug('Added expected account to contact and inserted new role');
                System.debug('role: '+role);
                contact = c;
            }
            else {
                if (lName == null) 
                    throw new JitException('Tried to create a contact without providing a last name', dtnaId);
                System.debug('Creating contact');
                Contact newCont = new Contact(AccountId=acc.Id, FirstName=fName, LastName=lName, 
                                            Email=emailId, MailingCity=city, MailingState=state, 
                                            MailingCountry=country, Phone=phone);
                try { insert newCont; }
                catch(Exception e) { throw new JitException('Failed to insert contact: '+e, dtnaId); }
                contact = newCont;
            }
        }
        return contact;
    }
    
    private Account getAccount(String dtnaId, String dealerCode, String city, String state, 
                                    String country, SSO_Jit_Provisioning__mdt lstMdtDefault) {
        List<Account> accounts = [SELECT IsPartner,Id FROM Account WHERE Dealer_Code__c=:dealerCode];
        String recordType = lstMdtDefault.Account_Record_Type__c;
        Account account;
        if (accounts.size() > 1)
            throw new JitException('Found multiple accounts with a matching dealercode', dtnaId);
        else if (accounts.size() == 1)  { //account exists 
            System.debug('Account already exists');
            account = accounts[0];
        } else  { //account does not exist -> create account
            System.debug('No account with matching dealercode. Creating account');
            List<RecordType> recs = [SELECT Id FROM Recordtype WHERE name =: recordType];
            Id accountType;
            if (recs.size() == 1)
                accountType = recs[0].Id;
            else {
                System.debug('Account type '+recordType+' not found. Using Dealership');
                accountType = [SELECT Id FROM Recordtype WHERE name ='Dealership'].Id;
            }
            Account newAcc = new Account(Dealer_Code__c=dealerCode, Name=dealerCode+' Account',
                                        BillingCity=city, BillingState=state, BillingCountry=country,
                                        RecordTypeId=accountType);
            
            try { insert newAcc; }
            catch(Exception e) { throw new JitException('Failed to insert account: '+e, dtnaId); }    
            account = newAcc;
        }
        return account;
    }

    private Contact getLatestContact(List<Contact> contacts) {
        System.debug('Found multiple matching contacts');
        DateTime dt = DateTime.newInstance(1900,1,1,1,1,1); //Jan 1, 1900
        Contact newestContact;
        for (Contact c : contacts) {
            if (c.LastModifiedDate > dt)  {
                System.debug('new latest date '+c.LastModifiedDate);
                dt = c.LastModifiedDate;
                newestContact = c;
            }
        }
        System.debug('Using most recently modified contact: '+newestContact.FirstName+' '+newestContact.LastName);
    	return newestContact;
    }
    
    private String getTimezone(String s)  {
        // Note that FL, IN, KY, TX, and TN are all being assigned to Central Standard Time 
        // even though they have multiple time zones
        if (s == null) return null; //can't get timezone without the state
        String timezone = null;
        if (s=='CA' || s=='NV' || s=='OR' || s=='WA') {
            timezone = 'America/Los_Angeles'; //Pacific Standard Time;
        } else if (s=='AZ' || s=='CO' || s=='ID' || s=='MT' || s=='NM' || s=='UT' || s=='WY') {
            timezone = 'America/Denver'; //Mountain Standard Time
        } else if (s=='AL' || s=='AR' || s=='IL' || s=='IA' || s=='KS' || s=='LA' || s=='MN' || s=='MS' || s=='MO' || s=='NE' || s=='ND' || s=='OK' || s=='SD' || s=='WI' || s=='FL' || s=='IN' || s=='KY' || s=='TX' || s=='TN') {
            timezone = 'America/Chicago'; //Central Standard Time
        } else if (s=='CT' || s=='DE' || s=='GA' || s=='ME' || s=='MD' || s=='MA' || s=='MI' || s=='NH' || s=='NJ' || s=='NY' || s=='NC' || s=='OH' || s=='PA' || s=='RI' || s=='SC' || s=='VT' || s=='VA' || s=='WV' ) {
            timezone = 'America/New_York'; //Eastern Standard Time
        } else if (s=='AK') {
            timezone = 'America/Anchorage'; //Alaskan Standard Time
        } else if (s=='HI') {
            timezone = 'Pacific/Honolulu'; //Hawaiian Standard Time
        }
        return timezone;
    }
    
    private static void insertPermissions(User user, String userApplicationRoles, String dtnaId) {
        List<Set<Id>> roles = parseStringForRoles(user, userApplicationRoles);
        Set<Id> psToInsert = roles[0];
        Set<Id> psToRemove = roles[1];
        List<PermissionSetAssignment> existingPsas = [SELECT PermissionSetId,AssigneeId FROM PermissionSetAssignment 
                                               WHERE AssigneeId=:user.Id AND (PermissionSetId IN :psToInsert OR PermissionSetId IN :psToRemove)];
        System.debug('existingPsas '+existingPsas);
        Map<Id,Id> psToPsa = new Map<Id,Id>();
        for (PermissionSetAssignment psa : existingPsas)
            psToPsa.put(psa.PermissionSetId,psa.Id);

        Set<Id> psasToDelete = new Set<Id>();
        for (Id ps : psToRemove) {
            Id psa = psToPsa.get(ps);
            if (psa != null)
                psasToDelete.add(psa);
        }

        psToInsert.removeall(psToPsa.keySet());

        if (psToInsert.size()>0 || psasToDelete.size()>0)
            futurePermissions(user.Id,psToInsert,psasToDelete,dtnaId);
        System.debug('Going to give permission sets: '+psToInsert);
        System.debug('Going to remove permission sets: '+psasToDelete);
    }
    
    @future
    public static void futurePermissions(Id userId, Set<Id> psToInsert, Set<Id> psasToDelete,
                    String dtnaId) { //taking ids because @future methods can't take sObjects
        System.debug('Future Permissions');
        List<PermissionSetAssignment> toInsert = new List<PermissionSetAssignment>();
        for (Id psId : psToInsert) {
            PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId=psId, AssigneeId=userId);
            toInsert.add(psa);
        }
        List<PermissionSetAssignment> toDelete = [SELECT PermissionSetId,AssigneeId FROM PermissionSetAssignment
                                                WHERE Id IN :psasToDelete];
        if (toInsert.size()>0) {
            System.debug('Giving user PermissionSetAssignments: '+toInsert);
            try { insert toInsert; }
            catch(Exception e) { throw new JitException('Failed to insert PermissionSetAssignment: '+e, dtnaId); }
        }
        if (toDelete.size()>0) {
            System.debug('Removing PermissionSetAssignments: '+toDelete);
            try { delete toDelete; }
            catch(Exception e) { throw new JitException('Failed to delete PermissionSetAssignment: '+e, dtnaId); }
        }
    }
        
    public static List<Set<Id>> parseStringForRoles(User user, String userApplicationRoles) {
        List<External_Role_Permission_Set_Assignment__mdt> permissionByRole = 
            [SELECT Permission_Set__c,Role__c FROM External_Role_Permission_Set_Assignment__mdt];
        if (user==null || userApplicationRoles==null || permissionByRole==null)
            return null;
            
        List<String> permNames = new List<String>();
        Map<String,Id> psMap = new Map<String,Id>();
        Set<Id> shouldHave = new Set<Id>();
        Set<Id> shouldNotHave = new Set<Id>();
        
        for (External_Role_Permission_Set_Assignment__mdt x : permissionByRole) 
            permNames.add(x.Permission_Set__c);

        List<PermissionSet> ps = [SELECT Id,Name FROM PermissionSet WHERE name IN :permNames];
        for (PermissionSet p : ps)
            psMap.put(p.Name,p.Id);
        System.debug('psMap '+psMap);
        for (External_Role_Permission_Set_Assignment__mdt x : permissionByRole) {
            Id psId = psMap.get(x.Permission_Set__c);
            if (psId == null) {
                System.debug('Failed to find permission set '+x.Permission_set__c+'. Not adding.');
                continue;
            }
            if (userApplicationRoles.contains(x.Role__c))  {
                shouldHave.add(psId);
            } else {
                shouldNotHave.add(psId);
            }
        }
        return new List<Set<Id>> {shouldHave,shouldNotHave};
    }
    
    
    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion)  {
        System.debug('updateUser was called for fedId '+federationIdentifier);
        System.debug('attributes: '+ attributes);
        List<User> users = [SELECT isActive,IsPortalEnabled FROM User WHERE Id=:userId];
        if (users.size() != 1)
            throw new JitException('User was not found',federationIdentifier);
        User user = users[0];

        //This section should allow you to reactivate disabled portal users by removing the fedId and creating a new user
        //May be able to check if isPortalUser instead but it may not work properly
        if (!user.IsActive) 
        { //reactivate if not active
            System.debug('Activating previously deactivated user');
            try
            {
                System.debug('IsPortalEnabled '+user.IsPortalEnabled);
                user.isActive = true;
                try { update user; }
                catch(Exception e) { throw new JitException('Expected exception. Ignore: '+e, federationIdentifier); }
            }
            catch(Exception e)
            {
                System.debug('e '+e);
                System.debug('Is a portal user');
                user.FederationIdentifier = '';
                
                try { update user; }
                catch(Exception ex) { throw new JitException('Failed to activate user: '+ex, federationIdentifier); }
                System.debug('Removed FedId of inactive portal user. Creating a new one');
                createUser(samlSsoProviderId,communityId,portalId,federationIdentifier,attributes,assertion);
            }
        }
        if (user.IsActive)
        {
            String userApplicationRoles = attributes.containsKey('UserApplicationRoles') && attributes.get('UserApplicationRoles')!='' ? attributes.get('UserApplicationRoles') : null;
            insertPermissions(user, userApplicationRoles, federationIdentifier);
        }
    }

    global User createUser(Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion)  {
        System.debug('--------------- createUser() was called');
        //System.debug('(These aren\'t being used so far) samlSsoProviderId: '+samlSsoProviderId+', communityId: '+communityId+', portalId: '+portalId+', assertion: '+assertion);
        try  {
            User u = createUserHelper(attributes, federationIdentifier); //returns null if anything went wrong
            System.debug('createUserHelper returned: '+u);
            if (u!=null)
                System.debug('Successfully to create user with FedId '+federationIdentifier);
            else
                System.debug('Failed to create user with FedId '+federationIdentifier);
            return u;
        } 
        catch(Exception e)  {
            System.debug('The following exception occurred: '+e.getMessage());
            System.debug('Failed to create user with FedId '+federationIdentifier);
            return null;
        }
    }
}