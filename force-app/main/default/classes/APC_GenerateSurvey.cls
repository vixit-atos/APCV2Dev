public class APC_GenerateSurvey {
    @InvocableMethod
    public static void CreateSurveyInv(List < Id > CaseId) {
        
        Case c = new case();
        
        string CaId;
        string CaseNumber;
        string communityId;
        string SurveyId;
        string ContactEmail;
        string ContactId;
        string surveyInvd;
        String ContactName;
        if(!CaseId.isEmpty())
        {
            try{
                c = [select Id, CaseNumber, ContactId, Contact.Email, Contact.Name from Case where Id =: CaseId];
                
                CaId = c.Id;
                CaseNumber = c.CaseNumber;
                ContactEmail = c.Contact.Email;
                ContactId = c.ContactId;
                ContactName = c.Contact.Name;
                
                communityId = [select Id from Network where Name = 'DTNAPartner'].Id;
                SurveyId = [Select Id from Survey where Name = 'APC Survey'].Id;
                
                SurveyInvitation SInv = New SurveyInvitation();
                
                //SInv.APC_Survey_Recipient_Email__c = ContactEmail;
                Sinv.CommunityId = communityId;
                SInv.Name = CaseNumber;
                //SInv.OptionsCollectAnonymousResponse = true;
                SInv.OptionsAllowGuestUserResponse = true;
                SInv.SurveyId = SurveyId;
                //SInv.APC_Survey_Contact__c = ContactId;
                SInv.ParticipantId =  ContactId;
                
                insert SInv;
                SurveySubject SS = new SurveySubject();
                
                SS.SubjectId = CaId;
                //SS.SurveyId = SurveyId;
                SS.ParentId = SInv.Id;
                SS.Name = CaseNumber;
                
                insert SS;
                
                SurveyInvitation SInvCreated = [select id,InvitationLink from surveyinvitation where id =: SInv.Id];
                
                Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
                String[] sendingTo = new String[]{ContactEmail};
                semail.setToAddresses(sendingTo);   
     			String emailbody;
                emailbody ='<p>Hello ' + ContactName + ',</p>'
    			+ '<p>As part of our ongoing effort to provide better service, we would like your feedback. Please complete a short online survey:</p>'
			    + '<a href="'+SInvCreated.InvitationLink + '">APC Dealer Feedback</a>'
				+ '<p>Thank you for your response and participation!</p>'
				+ '<p>Regards,</p>'
				+ '<p>Daimler APC Admin</p>';
                semail.setSubject('Please complete the survey for APC Case: '+ CaseNumber);
                semail.setHtmlBody(emailbody);
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});   
                
            }
            Catch(exception ex){
                System.debug(ex.getMessage());
                APC_MasterController.CustomAPIExceptionData data = new APC_MasterController.CustomAPIExceptionData('Generate Survey Error','There was error while sending Survey to Recipient - please contact your Admin', 5);
                throw new AuraHandledException(JSON.serialize(data));
            }
            
        }
    }
}