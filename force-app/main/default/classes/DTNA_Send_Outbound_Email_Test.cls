@isTest
public class DTNA_Send_Outbound_Email_Test
{
    static testMethod void DTNA_Send_Outbound_Email_Test()
    {
      List<Outbound_Email__c> LstOutEmail = new List<Outbound_Email__c>();
      Outbound_Email__c outmail = new Outbound_Email__c(name='test01');
      LstOutEmail.add(outmail);
      DTNA_Send_Outbound_Email.SendEmail(LstOutEmail);
    }
}