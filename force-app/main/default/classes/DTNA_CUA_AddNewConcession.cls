public with sharing class DTNA_CUA_AddNewConcession {
    
    public Concession__c obj_Conc{get;set;}
    public Boolean isFCC {get;set;}
    public Concession__c objConAsIs;
    String rcuResponse='';
    String respMessage='';
    String rcuFlag='';
    String Str_ConcessionNumer='';
    String IntId='';
    String profileName='';
    User Obj_User = new User();
    Id userId=null;
    Id profileId=null;
    public DTNA_CUA_AddNewConcession(ApexPages.StandardController stdController) {
        
        this.obj_Conc= (Concession__c)stdController.getRecord();
        objConAsIs = new Concession__c();
        //UserRegionCode = 'RG';
        //ConcessionId = ApexPages.currentPage().getParameters().get('id');
        userId = userinfo.getUserId();
        profileId = userinfo.getProfileId();
        profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        List<PermissionSetAssignment> lstcurrentUserPerSet = [ SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment  WHERE AssigneeId = :Userinfo.getUserId() and (PermissionSet.Name = 'ConcLive_CUA_Screen_Access')];
        if(lstcurrentUserPerSet.size() > 0 || profilename == 'System Administrator'|| profilename == 'DTNA - FCCC Sales'|| profilename == 'DTNA - WST DOA'|| profilename == 'DTNA - FTL DOA'){
            isFCC = true;
        }
        Obj_User = [Select Id,Mainframe_ID__c,FederationIdentifier,District__c from User where Id=:userId];
        
    }
    public pagereference save(){
        
        RCURequest('A');
        system.debug('#####before insert'+obj_conc);
        insert obj_Conc;
        system.debug('#####after insert'+obj_conc);
        //Pagereference p =  new Pagereference('/apex/DTNAConcessionLive?id='+obj_Conc.Id);    
        PageReference p = (UserInfo.getUiTheme() == 'Theme4t') ? Page.DTNAConcessionLiveMobile : Page.DTNAConcessionLive;
        p.getParameters().put('id',obj_Conc.Id);
        p.setRedirect(true);
        return p;
        
    }
    
    public void RCURequest(String ReqType)
    {
        rcuResponse+='RCURequest::' + ReqType;
        IntId = Str_ConcessionNumer + '_' + String.valueof(Math.round(Math.random()*1000));
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
        IMSInfo.TransactionName='CSCNCUA';
        rcuResponse+='$'+obj_Conc.LEAD_CONC_NO__c;
        rcuResponse+='$'+objConAsIs.LEAD_CONC_NO__c;
        Integer CurrentDealerNetPrice=Integer.valueof(obj_Conc.DLR_NET_PRC__c);
        Integer DealerProfit =Integer.valueof(obj_Conc.EST_DLR_PROF__c);
        //RequiredFields for Adding Concessions  
        IMSInfo.MessageData='    ¢  XX' + ReqType +'¢' + Obj_User.Mainframe_ID__c + '¢'+ Str_ConcessionNumer +'¢¢¢';
        IMSInfo.MessageData += obj_Conc.Dealer_Code__c + '¢';
        IMSInfo.MessageData += obj_Conc.CONT_PRSN_NAME_42__c + '¢';
        IMSInfo.MessageData += obj_Conc.CUST_NAME_50__c + '¢¢¢¢¢¢¢';
        IMSInfo.MessageData += obj_Conc.VEH_MDL_NO__c + '¢';
        IMSInfo.MessageData += obj_Conc.VEH_BASE_MDL_NO__c + '¢';
        IMSInfo.MessageData += obj_Conc.CMPTR_CD__c  + '¢¢¢¢';
        IMSInfo.MessageData += obj_Conc.RQST_MIN_UNITS__c + '¢';
        IMSInfo.MessageData += obj_Conc.RQST_MAX_UNITS__c + '¢';
        IMSInfo.MessageData += CurrentDealerNetPrice + '¢' ;
        IMSInfo.MessageData += obj_Conc.CURR_FREIGHT__c + '¢';
        IMSInfo.MessageData += DealerProfit + '¢';
        IMSInfo.MessageData += obj_Conc.TOT_MIN__c + '¢';     
        IMSInfo.MessageData += obj_Conc.TOT_MAX__c + '¢¢¢'; 
        IMSInfo.MessageData += obj_Conc.RQST_CONC_PCT__c + '¢¢¢¢'; 
        IMSInfo.MessageData += formatToMMDDYY(obj_conc.DATE_DELV_RQST__c) + '¢';
        IMSInfo.MessageData += formatToMMDDYY(obj_conc.DATE_LATEST_ACCEPT__c) + '¢';
        IMSInfo.MessageData += obj_Conc.REQ_PRICELVL__c + '¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢EOF'; 
        
        rcuResponse+=IMSInfo.MessageData;
        
        
        iibIms_ConcessionApprovalRequest.ServiceResponseMsg_element ServiceResponse = new iibIms_ConcessionApprovalRequest.ServiceResponseMsg_element();
        iibImsConcessionRequest.IIB_generic_internet_soap11 proxyClass = new iibImsConcessionRequest.IIB_generic_internet_soap11();
        proxyClass.clientCertName_x=ConcessionRCURequest__c.getValues('clientCertName_x').Value__c;
        proxyClass.clientCertPasswd_x=ConcessionRCURequest__c.getValues('clientCertPasswd_x').Value__c;
        system.debug(' proxyvalue '+ proxyClass);
        
        try
        {
            ServiceResponse = proxyClass.ExecTransaction(ClientInfo,IMSInfo);
            DTNA_IntegrationLogging.IntegrationLoggingReqInsert( IMSInfo.TransactionName,'IMS-Mainframe',(ReqType == ' ') ? 'Approval' : ReqType,IntId, IMSInfo.TransactionName+IMSInfo.MessageData,'Requested');
            System.debug(' serviceresponse______ ' + ServiceResponse );
            obj_Conc.Approval_Comments__c='';
        }
        Catch(Exception e)
        {
            System.debug(e);
            DTNA_IntegrationLogging.IntegrationLoggingReqInsert( IMSInfo.TransactionName,'IMS-Mainframe',(ReqType == 'R') ? 'Rejection' : (ReqType == ' ') ? 'Approval' : 'Update',IntId,IMSInfo.MessageData,'Requested');
            DTNA_IntegrationLogging.IntegrationLoggingRespUpdate(IntId, ServiceResponse + e.getMessage() + e.getStackTraceString(),'SOAP Request Failure');
            rcuResponse=rcuResponse+e+e.getStackTraceString();
            rcuFlag = 'ERROR';
            respMessage = ConcessionRCURequest__c.getValues('ExceptionMessageTemplate').Value__c + ' ' + e.getMessage();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,respMessage ));
        }
        System.debug(ServiceResponse);
        
        if(ServiceResponse!= null)
        {
            if(ServiceResponse.ErrorResponse != null)
            {
                DTNA_IntegrationLogging.IntegrationLoggingRespUpdate(IntId, ServiceResponse.ErrorResponse.ErrorDescription,'Responded with ERROR');
                rcuResponse += (ConcessionRCURequest__c.getValues('ErrorResponseMessageTemplate').Value__c + ServiceResponse.ErrorResponse.ErrorDescription);
            }
            else
            {
                try
                {
                    if(!Test.isRunningTest())
                    {
                        DTNA_IntegrationLogging.IntegrationLoggingRespUpdate(IntId, ServiceResponse.SyncResponse.IMSMessageData,'Response Received');
                    }
                    else
                    {
                        iibIms_ConcessionApprovalRequest.SyncResponse_element ObjSyncResp = new iibIms_ConcessionApprovalRequest.SyncResponse_element();
                        ObjSyncResp.IMSMessageData = '2H7798¢JFTL238 ¢E¢E-570 DATA CHANGED, PRESS ENTER BEFORE SUBMIT OR CHK        ¢EOF';
                        ServiceResponse.SyncResponse = ObjSyncResp;
                    }
                    respMessage = ServiceResponse.SyncResponse.IMSMessageData;
                    rcuResponse += respMessage;
                    if(respMessage.split('¢')[3].left(1) == 'I')
                    {
                        respMessage = ConcessionRCURequest__c.getValues('InfoSyncResponseMessageTemplate').Value__c +respMessage.split('¢')[3].substring(respMessage.split('¢')[3].indexOf(' ')+1);
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,respMessage ));
                        
                        //   LoadLiveConcessionData();
                        
                    }
                    else if(respMessage.split('¢')[3].left(1) == 'E')
                    {
                        respMessage = ConcessionRCURequest__c.getValues('ErrorSyncResponseMessageTemplate').Value__c + ' ' + respMessage.split('¢')[3].substring(respMessage.split('¢')[3].indexOf(' ')+1);
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,respMessage ));
                        //    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,respMessage ));
                        
                    }
                    else
                    {
                        respMessage = ConcessionRCURequest__c.getValues('OtherSyncResponseMessageTemplate').Value__c + ' ' + respMessage.split('¢')[3].substring(respMessage.split('¢')[3].indexOf(' ')+1);
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,respMessage ));    
                    }
                    
                    //rcuResponse = ServiceResponse.SyncResponse.IMSMessageData;
                    system.debug('######response='+ServiceResponse.SyncResponse.IMSMessageData);
                    obj_Conc.Name = ServiceResponse.SyncResponse.IMSMessageData.split('¢')[0];
                    
                    
                    
                }
                catch(Exception e)
                {
                    System.debug(e);
                    rcuResponse+=rcuResponse+e+e.getStackTraceString();
                }
                //LoadLiveConcessionData();                  
            }
        }
    }
    //Formatting the date to mmddyy
    public string formatToMMDDYY(Date d){    
        string str='';
        if(d.month() < 10){
            str = '0'+d.month();
        }else{
            str = str + d.month();
        }
        if(d.day() < 10){
            str = str + '0'+d.day();
        }else{
            str = str + d.day();
        }
        str = str + math.mod(d.year(), 100);
        
        system.debug(str);
        return str;
    }
    
    //Calculating the approved concession percentage and Requested Concession Percentage 
    public void CalcOnChangedConcPct()
    {
        obj_Conc.RQST_CONC_PCT__c = obj_Conc.RQST_CONC_PCT__c.setscale(2);
        obj_Conc.RQST_CONC_AMT__c = (obj_Conc.RQST_CONC_PCT__c /100)*obj_Conc.DLR_NET_PRC__C;
        obj_Conc.RQST_CONC_AMT__c = obj_Conc.RQST_CONC_AMT__c.round();
        rcuResponse+= obj_Conc.RQST_CONC_AMT__c;
        CalcTranChanges();
    }
    public void CalcOnChangedConcAmt()
    {
        obj_Conc.RQST_CONC_AMT__c = obj_Conc.RQST_CONC_AMT__c.setscale(0,System.RoundingMode.HALF_UP);
        obj_Conc.RQST_CONC_PCT__c = (obj_Conc.RQST_CONC_AMT__c /obj_Conc.DLR_NET_PRC__C)*100;
        obj_Conc.RQST_CONC_PCT__c = obj_Conc.RQST_CONC_PCT__c.setscale(2);
        rcuResponse+= obj_Conc.RQST_CONC_PCT__c;
        CalcTranChanges();
    }
    
    //Calculate the Approved Concession Amount based on the Approved Percentage change
    public void CalcOnChangedAprConcPct()
    {
        obj_Conc.APPR_CONC_PCT__c = obj_Conc.APPR_CONC_PCT__c.setscale(2);
        obj_Conc.APPR_CONC_AMT__c = ((obj_Conc.APPR_CONC_PCT__c /100)*obj_Conc.DLR_NET_PRC__C).setscale(0,System.RoundingMode.HALF_UP);
        obj_Conc.APPR_CONC_AMT__c = obj_Conc.APPR_CONC_AMT__c.round();
        rcuResponse+= obj_Conc.APPR_CONC_AMT__c;
        CalcTranChanges();
    }
    
    //Calculate the Approved Concession Percentage based on the Approved Amount change    
    public void CalcOnChangedAprConcAmt()
    {
        obj_Conc.APPR_CONC_AMT__c = obj_Conc.APPR_CONC_AMT__c.round();
        obj_Conc.APPR_CONC_PCT__c = (obj_Conc.APPR_CONC_AMT__c /obj_Conc.DLR_NET_PRC__C)*100;
        obj_Conc.APPR_CONC_PCT__c = obj_Conc.APPR_CONC_PCT__c.setscale(2);
        rcuResponse+= obj_Conc.APPR_CONC_PCT__c;
        CalcTranChanges();
    }
    
    //Calculate the Transaction calcualted fields with the change in the 
    public void CalcTranChanges()
    {
        Decimal decConcAmtDiff = 0.0;
        if(obj_Conc.CURR_DN_COST__c != null) obj_Conc.CURR_DN_COST__c-=decConcAmtDiff;
        if(obj_Conc.CURR_SELL_PRC__c != null) obj_Conc.CURR_SELL_PRC__c-=decConcAmtDiff;
        if(obj_Conc.CURR_TOT_SELL_PRC__c != null) obj_Conc.CURR_TOT_SELL_PRC__c-=decConcAmtDiff;
        if(obj_Conc.APPR_NET_CNTRB__c != null) obj_Conc.APPR_NET_CNTRB__c-=decConcAmtDiff;
    }
    
    
}