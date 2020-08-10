/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* One or two sentence summary of this class.
*
* class is used to Redirect Phone,Email fields for STC users when creating a new contact from roles 
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Hareesh goud nellykonda   
* @modifiedBy          
* @version        1.0
* @created        04-05-2017
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
* Chris
* 07/30/2018
*                 Added null check for PCS to bypass Trigger
* Bindu Joseph
* 07/18/2019      Added Before delete check for SMR Contacts. If the QA dept role/or any roles exists
*                 Show error message to user.
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public class ContactTriggerHandler  extends TriggerHandler  {
    public ContactTriggerHandler (){}
    protected override void afterInsert() {
        RedirectSTCEmailphonevalues();
    }
    protected override void beforeDelete() {
        ValidateSMRContactRoles();
    }
    
    
    private void RedirectSTCEmailphonevalues() {
        Id profileId=userinfo.getProfileId();
        String profileName;
        if(profileId != null){
            profileName=[Select Id,Name from Profile where Id=:profileId].Name;
            
            system.debug('ProfileName'+profileName);
            List<Contact> lstcontact=new List<Contact>();
            List<Contact> lstcontacttoupdate=new List<Contact>();
            Set<ID> setcontactids=new Set<ID> ();
            
            for(Contact ObjContact: (List<Contact>)Trigger.new){
                
                setcontactids.add(ObjContact.id);
            }
            system.debug('setcontactids123'+setcontactids);
            lstcontact=[select id,name,phone,STC_Cleveland_Phone__c,lastname,Email,MobilePhone  from COntact where id in:setcontactids];
            system.debug('lstcontacts123'+lstcontact);
            for(Contact ObjContact :lstcontact){
                Contact objtoupdate=new Contact();
                objtoupdate.id=ObjContact.id;
                objtoupdate.LastName=ObjContact.LastName;
                if(profileName=='DTNA - STC Cleveland'){
                    objtoupdate.STC_Cleveland_Phone__c=ObjContact.phone;
                    objtoupdate.STC_Cleveland_Email__c=ObjContact.email;
                    objtoupdate.STC_Cleveland_Mobile__c=ObjContact.MobilePhone;
                    objtoupdate.Phone='';
                    objtoupdate.Email='';
                }else   if(profileName=='DTNA - STC Charlotte'){
                    objtoupdate.STC_Charlotte_Phone__c=ObjContact.phone;
                    objtoupdate.STC_Charlotte_Email__c=ObjContact.email;
                    objtoupdate.STC_Charlotte_Mobile__c=ObjContact.MobilePhone;
                    objtoupdate.Phone='';
                    objtoupdate.Email='';
                }else   if(profileName=='DTNA - STC Kansas City'){
                    objtoupdate.STC_Kansas_City_Phone__c=ObjContact.phone;
                    objtoupdate.STC_Kansas_City_Email__c=ObjContact.email;
                    objtoupdate.STC_Kansas_City_Mobile__c=ObjContact.MobilePhone;
                    objtoupdate.Phone='';
                    objtoupdate.Email='';
                }else   if(profileName=='DTNA - STC Louisville'){
                    objtoupdate.STC_Louisville_Phone__c=ObjContact.phone;
                    objtoupdate.STC_Louisville_Email__c=ObjContact.email;
                    objtoupdate.STC_Louisville_Mobile__c=ObjContact.MobilePhone;
                    objtoupdate.Phone='';
                    objtoupdate.Email='';
                }else   if(profileName=='DTNA - STC New England'){
                    system.debug('i am inside DTNA - STC New England');
                    
                    objtoupdate.STC_New_England_Phone__c=ObjContact.phone;
                    objtoupdate.STC_New_England_Email__c=ObjContact.email;
                    objtoupdate.STC_New_England_Mobile__c=ObjContact.MobilePhone;
                    objtoupdate.Phone='';
                    objtoupdate.Email='';
                }else    if(profileName=='DTNA - STC Tampa'){
                    objtoupdate.STC_Tampa_Phone__c=ObjContact.phone;
                    objtoupdate.STC_Tampa_Email__c=ObjContact.email;
                    objtoupdate.STC_Tampa_Mobile__c=ObjContact.MobilePhone;
                    objtoupdate.Phone='';
                    objtoupdate.Email='';
                }else     if(profileName=='DTNA - STC Toronto'){
                    objtoupdate.STC_Toronto_Phone__c=ObjContact.phone;
                    objtoupdate.STC_Toronto_Email__c=ObjContact.email;
                    objtoupdate.STC_Toronto_Mobile__c=ObjContact.MobilePhone;
                    objtoupdate.Phone='';
                    objtoupdate.Email='';
                }  
                lstcontacttoupdate.add(objtoupdate);
            }
            if(!lstcontacttoupdate.isEmpty()){
            upsert lstcontacttoupdate;
            }
        }
    }
    
    //Check for any related Roles of SMR Contact before delete
    private void ValidateSMRContactRoles(){
    	try
        {	Id profileId=userinfo.getProfileId();
            string username=userinfo.getName();
            String userTitle;
        	Boolean isQaRole = false;

            if(profileId != null){
                //getting the record types for SMR contacts
				Map<String, Schema.RecordTypeInfo> recordTypes = Schema.SObjectType.Contact.getRecordTypeInfosByName();

                Id dtnaContType = recordTypes.get('DTNA Contact').getRecordTypeId();
                Id SuplContType = recordTypes.get('Supplier Contact').getRecordTypeId();
                
                
                 for(Contact ObjContact: (List<Contact>)Trigger.old){
               		 //If the Record Type is 'DTNA Contact' or 'Supplier Contact' then check if contact has any Related Roles before deleting
               		 if(ObjContact.RecordTypeId==dtnaContType || ObjContact.RecordTypeId==SuplContType)
                     { 
                         System.debug('SMR Contacts!!'+ dtnaContType +'-----' + SuplContType);
                         //getting the user title to find if the user is "PPAP Admin"
               			 userTitle=[Select Title from User where ProfileId=:profileId and Name=:username LIMIT 1].Title;
                         //getting the related Roles of contact
                         	List<Role__C> relatedRoles=[SELECT Id,Department__C FROM ROLE__C WHERE Contact__C=:ObjContact.id];
                            System.debug('size'+ relatedRoles.size());
                            if(relatedRoles.size() >0)
                            {
                                //check if Contact is a QA contact
                                for(Role__C role :relatedRoles){
                                    if(role.Department__c=='QUALITY ASSURANCE VENDOR CONTA'){
                                        isQaRole=true;
                                    }
                                }
                                //If contact is QA contact then dont allow delete at all (only PPAP admin can do that)
                                //else let user delete roles manually before delting the contact
                                if(isQaRole && userTitle!='PPAP Admin')
                                {   ObjContact.addError('Cannot delete Contact associated with QA Department role. Please contact DTNA PPAP Administrator.');}
                                else
                                {    
                                	ObjContact.addError('This contact cannot be deleted until the roles assigned to it are removed and reassigned.Please click on the Related tab to remove roles and assign to another contact.Once this is complete then this contact can be deleted.');
                                }
                            }
                     }
              	}
            }
         }
        catch(Exception e)
        {
            System.debug('ERROR:' + e);
        }
    }
}