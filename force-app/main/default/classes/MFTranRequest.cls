public with sharing class MFTranRequest 
{
    public List<String> MFListTranString { get; set; }

    public String MFTranName { get; set; }
    
    public String MFResponseTranString { get; set; }

    public String MFReqTranString {set;get;}  
    
    public MFTranRequest()
    {
    MFResponseTranString = '';
    MFTranName = 'CSCNRCU';
    MFReqTranString = '    ¢  SF ¢JFTL232¢W44961¢RPR¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢EOF';
    MFListTranString = new List<String>();
    }
    
    public PageReference MFTranSubmit()
    {
        iibIms_ConcessionApprovalRequest.ClientInfo_element ClientInfo =
        new iibIms_ConcessionApprovalRequest.ClientInfo_element ();

        iibIms_ConcessionApprovalRequest.Security_element SecurityInfo = 
            new iibIms_ConcessionApprovalRequest.Security_element();

        SecurityInfo.UserID = ConcessionRCURequest__c.getValues('SecurityInfoUserID').Value__c;
        SecurityInfo.Password = ConcessionRCURequest__c.getValues('SecurityInfoPassword').Value__c;

        iibIms_ConcessionApprovalRequest.IMSInfo_element IMSInfo =
            new iibIms_ConcessionApprovalRequest.IMSInfo_element();

        IMSInfo.Security = SecurityInfo;
        IMSInfo.TransactionName = MFTranName;
     //   IMSInfo.MessageData='    ¢  SF' + Obj_User.Mainframe_ID__c + '¢' + strTranReq;
        IMSInfo.MessageData = MFReqTranString;
        iibIms_ConcessionApprovalRequest.ServiceResponseMsg_element ServiceResponse =
            new iibIms_ConcessionApprovalRequest.ServiceResponseMsg_element();
        iibImsConcessionRequest.IIB_generic_internet_soap11 proxyClass = 
            new iibImsConcessionRequest.IIB_generic_internet_soap11();
        proxyClass.clientCertName_x=ConcessionRCURequest__c.getValues('clientCertName_x').Value__c;
        proxyClass.clientCertPasswd_x=ConcessionRCURequest__c.getValues('clientCertPasswd_x').Value__c;
        system.debug(' proxyvalue '+ proxyClass);
        
        try
        {
            MFListTranString.add('Request: ' + MFTranName + MFReqTranString);
            //MFListTranString.add('Response: ' + MFResponseTranString);
            ServiceResponse = proxyClass.ExecTransaction(ClientInfo,IMSInfo);
            
            if(ServiceResponse.ErrorResponse != null)
            {
                MFResponseTranString = (ConcessionRCURequest__c.getValues('ErrorResponseMessageTemplate').Value__c + ServiceResponse.ErrorResponse.ErrorDescription);
            }
            else
            {
                MFResponseTranString = ServiceResponse.SyncResponse.IMSMessageData;
            }
            
            System.debug(' serviceresponse______ ' + ServiceResponse );
        }
        Catch(Exception e)
        {
            System.debug(e);
            MFResponseTranString = e+e.getStackTraceString();
        }
        MFListTranString.add('Response: ' + MFResponseTranString);
        System.debug(ServiceResponse);
        return null;
    }
}