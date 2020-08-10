/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* One or two sentence summary of this class.
*
* class is used to related Account to Contact with Role roles 
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Anto Nirmal
* @modifiedBy          
* @version        1.1
* @created        02/08/2017
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

* Bindu Joseph
* 07/18/2019      Added Before delete check for SMR Role. If its QA dept role and user is not PPAP amdin
*                 Show error message to user.
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public class RoleTriggerHandler extends TriggerHandler
{
    List<Role__c> lstRole = new List<Role__c>();
    List<Contact> lstContact = new List<Contact>();
    Contact Obj_Contact = new Contact();
    Map<Id,Id> lstContactIds = new Map<Id,Id>();
    protected override void beforeDelete()
    {
      try
        {
            Id profileId=userinfo.getProfileId();
            string username=userinfo.getName();
            String userTitle;
            if(profileId != null){
                //getting the record type of SMR Role
                Id smrRecType = Schema.SObjectType.Role__C.getRecordTypeInfosByName().get('SMR Department  Title').getRecordTypeId();
                system.debug(  'smrRecType: '+smrRecType);
                               
                
               for (Role__c ObjRole : (List<Role__c>)Trigger.old)
                    {
                        //For SMR Role record type check If Role is QA  then dont allow delete  if user is not PPAP admin
                        if(ObjRole.RecordTypeId==smrRecType )
                           {
                                //getting the user title to find if "PPAP Admin"
                                userTitle=[Select Title from User where ProfileId=:profileId and Name=:username LIMIT 1].Title;
                                system.debug(  'Title: '+userTitle);
                               
                               If (ObjRole.Department__c=='QUALITY ASSURANCE VENDOR CONTA' && userTitle!='PPAP Admin')
                               {
                                   ObjRole.addError('Cannot delete QA Department role. Please contact DTNA PPAP Administrator.');
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
    
    protected override void beforeInsert()
    {
        try
        {
            for (Role__c ObjRole : (List<Role__c>)Trigger.new)
            {
                if(ObjRole.Account__c <> null && ObjRole.Contact__c <> null)
                {
                    System.debug('PreRoleObject:' + ObjRole);
                    lstContactIds.put(ObjRole.Contact__c,ObjRole.Account__c);

                    System.debug('ContactLists:' + lstContactIds);
                    System.debug('PostRoleObject:' + ObjRole);
                }
            }
            for(Contact Obj_Contact : [select Id, AccountId from Contact where Id in :lstContactIds.KeySet() and AccountId = null])
            {
                Obj_Contact.Id = Obj_Contact.Id;
                Obj_Contact.AccountId = lstContactIds.get(Obj_Contact.Id);
                lstContact.add(Obj_Contact);
            }
            if(lstContact.size() > 0)
            {
                System.debug('Contact Size:' + lstContact.size());
                update lstContact;
                System.debug('Updated Contacts');
            }
        }
        catch(Exception e)
        {
            System.debug('ERROR:' + e);
        }
    }
}