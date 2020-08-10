public with sharing class TWS_PO_Reconciliation_Request
{

    public TWS_PO_Reconciliation_Request() 
    {
        lst_log  = new List<String>();
        Str_MainframeID = [Select Id,Mainframe_ID__c,FederationIdentifier,District__c from User where Id=:userinfo.getUserId()].Mainframe_ID__c;
    }

    public List<String> lst_log;
    List<Concession__c> lst_INQ_Conc_toUpdate = new List<Concession__c>();
    public String strTranReq = '¢¢¢' + 'ALL¢¢¢¢¢¢¢' + '06/21/16' + '¢' + '07/21/16' + '¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢EOF';
    
    String Str_MainframeID = '';
    String rcuResponse='';
    String respMessage='';
    String rcuFlag='';
    String IntId='';
    String strChangedFields='';
    String StrRequest = '';
    

    public List<String> PORCL_TSOSPLITNO_Request(String inpStrRequest)
    {
        StrRequest = inpStrRequest;
        LoadLiveData();
        return(lst_log);
    }
    
    public void LoadLiveData()
    {
        long now = datetime.now().gettime();
        while(datetime.now().gettime()-now<3000);
    
        IntId = Str_MainframeID + '_' + String.valueof(Math.round(Math.random()*1000));
        iibIms_ConcessionApprovalRequest.ClientInfo_element ClientInfo =
        new iibIms_ConcessionApprovalRequest.ClientInfo_element ();

        ClientInfo.UserID=ConcessionRCURequest__c.getValues('ClientInfoUserID').Value__c;

        iibIms_ConcessionApprovalRequest.Security_element SecurityInfo = 
            new iibIms_ConcessionApprovalRequest.Security_element();

        SecurityInfo.UserID = ConcessionRCURequest__c.getValues('SecurityInfoUserID').Value__c;
        SecurityInfo.Password = ConcessionRCURequest__c.getValues('SecurityInfoPassword').Value__c;

        iibIms_ConcessionApprovalRequest.IMSInfo_element IMSInfo =
            new iibIms_ConcessionApprovalRequest.IMSInfo_element();

        IMSInfo.Security = SecurityInfo;
    //    IMSInfo.TransactionName=ConcessionRCURequest__c.getValues('PORCLTranName').Value__c;
    //    IMSInfo.MessageData=' SALF¢AP12565¢' + StrRequest + '¢N¢T¢' + Str_MainframeID + '¢¢¢¢¢EOF';
    IMSInfo.TransactionName=ConcessionRCURequest__c.getValues('PORCLTranName').Value__c;
    IMSInfo.MessageData=' PMTS¢Q87007¢SDEWARE¢00000000¢2016-07-12¢2016-07-12¢011-858¢EOF';
        iibIms_ConcessionApprovalRequest.ServiceResponseMsg_element ServiceResponse =
            new iibIms_ConcessionApprovalRequest.ServiceResponseMsg_element();
        iibImsConcessionRequest.IIB_generic_internet_soap11 proxyClass =
            new iibImsConcessionRequest.IIB_generic_internet_soap11();
        proxyClass.clientCertName_x=ConcessionRCURequest__c.getValues('clientCertName_x').Value__c;
        proxyClass.clientCertPasswd_x=ConcessionRCURequest__c.getValues('clientCertPasswd_x').Value__c;

        try
        {
            lst_log.add(IntId + 'Request:'+IMSInfo.MessageData);
            ServiceResponse = proxyClass.ExecTransaction(ClientInfo,IMSInfo);
            DTNA_IntegrationLogging.IntegrationLoggingReqInsert('PORCL','IMS-Mainframe','Query',IntId,IMSInfo.MessageData,'Requested');
        }
        Catch(Exception e)
        {
            System.debug(e);
            DTNA_IntegrationLogging.IntegrationLoggingReqInsert('PORCL','IMS-Mainframe','Query',IntId,IMSInfo.MessageData,'Requested');
            DTNA_IntegrationLogging.IntegrationLoggingRespUpdate(IntId, ServiceResponse + e.getMessage() + e.getStackTraceString(),'SOAP Request Failure');
            rcuResponse=e+e.getStackTraceString();
            lst_log.add(IntId+'RESPONSE:' + rcuResponse);
            rcuFlag = 'ERROR';
            respMessage = ConcessionRCURequest__c.getValues('ExceptionMessageTemplate').Value__c + ' ' + e.getMessage();
            if(Test.isRunningTest())
            {
               iibIms_ConcessionApprovalRequest.SyncResponse_element ObjSyncResp = new iibIms_ConcessionApprovalRequest.SyncResponse_element();
               ObjSyncResp.IMSMessageData = '¢I¢PRICE MATRIX CALCULATION COMPLETED                          ¢HT4118¢  101,749.00¢   86,486.65¢   72,633.00¢'+
               '   61,738.05¢   24,420.00¢   37,318.05¢   29,116.00¢       54.00¢   13,393.36¢   15,722.64¢   53,040.69¢       43.00¢   37,813.36¢EOF';
               ServiceResponse.SyncResponse = ObjSyncResp;
            }
        }
        System.debug(ServiceResponse);
        
        if(ServiceResponse!= null && rcuFlag != 'ERROR')
        {
            if(ServiceResponse.ErrorResponse != null)
            {
                DTNA_IntegrationLogging.IntegrationLoggingRespUpdate(IntId, ServiceResponse.ErrorResponse.ErrorDescription,'Responded with ERROR');
                rcuResponse = (ConcessionRCURequest__c.getValues('ErrorResponseMessageTemplate').Value__c + ServiceResponse.ErrorResponse.ErrorDescription);
                lst_log.add(IntId+'RESPONSE:' + rcuResponse);
            }
            else
            {
                try
                {
                    DTNA_IntegrationLogging.IntegrationLoggingRespUpdate(IntId, ServiceResponse.SyncResponse.IMSMessageData,'Response Received');
                    rcuResponse = ServiceResponse.SyncResponse.IMSMessageData;
                    lst_log.add(IntId+'RESPONSE:' + rcuResponse);
                    List<String> ConcData = rcuResponse.split('¢');
                    system.debug(rcuResponse );

                    if(ConcData[1].left(1) == 'I' || Test.isRunningTest())
                    {
                       
                    }
                    else if(ConcData[1].left(1) == 'E')
                    {
                        respMessage = ConcessionRCURequest__c.getValues('ErrorSyncResponseMessageTemplate').Value__c + ' ' + ConcData[1].substring(ConcData[1].indexOf(' ')+1);
                    }
                    else
                    {
                        respMessage = ConcessionRCURequest__c.getValues('OtherSyncResponseMessageTemplate').Value__c + ' ' + ConcData[1].substring(ConcData[1].indexOf(' ')+1);
                    }
                 }
                 catch(Exception e)
                 {
                     System.debug(e);
                     rcuResponse = e+e.getStackTraceString();
                     lst_log.add(rcuResponse );
                     respMessage = ConcessionRCURequest__c.getValues('ExceptionMessageTemplate').Value__c + ' ' + e.getMessage();
                 }
            }
        }
        System.Debug('output'+rcuResponse);
    }
    public String getOutput()
    {
        return (respMessage + '\n' + rcuResponse + '\n');
    }
}