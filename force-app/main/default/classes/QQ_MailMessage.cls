public with sharing class QQ_MailMessage 
{
    /*For rejected and approved quote - queueName will be userid.*/
    @AuraEnabled
    public static void qqsendEmail(string recordID, string queueName, string recordStatus)
    {
        system.debug('Record ID: ' + recordID);
        system.debug('Queue: ' + queueName);
        system.debug('Status: ' + recordStatus);
                
        string returnSTS = '';
        try
        {
            set<ID> userIDs = new set<ID>();
            
            if(recordStatus == 'Rejected' || recordStatus == 'Approved')
            {
                //---------------  ADDING CREATED BY USER INTO USER LIST  -------------------------
                Id createdBy = [SELECT Id, Name, CreatedById FROM ASP_QQ__c WHERE Name = :recordID].CreatedById;
                userIDs.add(createdBy);
            }
            
            //-----------------  ADDING USERS OF QUEUE USERS INTO USER LIST  ---------------------
            set<ID> groupIDs = new set<ID>();
            List<Group> groupList = [SELECT Id, Name FROM Group WHERE type = 'Queue' AND Name = :queueName];
            for(Group grp : groupList)
            {
                groupIDs.add(grp.Id);
            }
            List<GroupMember> groupMemberList = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId IN :groupIDs];
            for(GroupMember grpMember : groupMemberList)
            {
                userIDs.add(grpMember.UserOrGroupId);
            }
            //-------------------------------------------------------------------------------------
            
            //----------------  FETCHING EMAILS OF USERS  --------------------------------
            set<string> emailList = new set<string>();
            List<User> Users = [SELECT ID, Name, email FROM User WHERE Id IN :userIDs and IsActive=true];
            for(User usr:Users)
            {
                emailList.add(usr.email);
            }
            
            string subject = 'QUOTE: ' + recordID + ' ' + recordStatus;
            list<string> toAddresses = new list<string>();
            toAddresses.addAll(emailList);
            string emailBody = getTemplate(recordID, recordStatus);
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setSubject(subject);
            mail.setHtmlBody(emailBody);
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            System.debug('Email sent successfully');
            
        }
        catch(Exception exp)
        {
            returnSTS = 'OOPs! There is some technical error while sending email.';
            system.debug('Error! Line: ' + exp.getLineNumber() + ' - Message: ' + exp.getMessage());
        }
        //return returnSTS;
    }
    
    public static string getTemplate(string recordID, string recordStatus)
    {
        string fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/n/QUOTE_HISTORY';        
        string emailTemplate = '';
        emailTemplate += '<span style="color:#0B3861; font-family:Calibri, Arial; font-size:26px; font-weight:bold">' + 'QUOTE: ' + recordID + ' ' + recordStatus + '</span>';
        emailTemplate += '<br/><br/>';
        if(recordStatus != 'Rejected' && recordStatus != 'Approved')
        {
            emailTemplate += 'Below quote is pending for your action <br/><br/>';
        }
        emailTemplate += '<span style="color:#0B3861; font-family:Calibri, Arial; font-size:16px; font-weight:bold">Quote: </span>' + recordID + '<br/>';
        emailTemplate += '<span style="color:#0B3861; font-family:Calibri, Arial; font-size:16px; font-weight:bold">Action: </span>' + recordStatus + '<br/>';
        emailTemplate += '<br/><br/>';
        emailTemplate += '<a href=' + fullRecordURL + '>Click here to navigate to Internal Quick Quote</a>';
        emailTemplate += '<hr/>';
        emailTemplate += '<span style="color:#610B0B; font-family:Calibri, Arial; font-size:12px; font-weight:normal">Note: This is a system generated mail. Please do not reply on this mail</span>';
        
        return emailTemplate;
    }
}