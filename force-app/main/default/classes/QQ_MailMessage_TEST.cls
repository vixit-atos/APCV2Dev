@isTest
public class QQ_MailMessage_TEST 
{
    @isTest
    public static void runTest()
    {
        string recordID = '00004114';
        string recordStatus = 'Pending for Validation';
        string queueName = 'QQ Cost Queue';
        
        QQ_MailMessage.qqsendEmail(recordID, queueName, recordStatus);
    }
}