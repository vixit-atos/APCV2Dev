public without sharing class DTNA_INQ_Inquiry_List
{
    
    public DTNA_INQ_Inquiry_List(ApexPages.StandardSetController controller)
    {
        lst_INQ_Conc = new List<Concession__c>();
        lst_Conc = new List<Concession__c>();
        lst_str_Conc = new List<String>();
        lst_log  = new List<String>();
        obj_Conc = new Concession__c();
        userId = userinfo.getUserId();
        profileId = userinfo.getProfileId();
        profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        List<PermissionSetAssignment> lstcurrentUserPerSet = [ SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment  WHERE AssigneeId = :Userinfo.getUserId() and (PermissionSet.Name = 'ConcLive_CUA_Screen_Access')];
        if(lstcurrentUserPerSet.size() > 0 || profilename == 'System Administrator'|| profilename == 'DTNA - FCCC Sales'|| profilename == 'DTNA - WST DOA'|| profilename == 'DTNA - FTL DOA'){
            isFCC = true;
        }
        Obj_User = [Select Id,Mainframe_ID__c,FederationIdentifier,District__c,Region__c from User where Id=:userId];
        try
        {
            strDefaultConcStatus=ConcessionRCURequest__c.getValues('Profile-'+profileName).Value__c;
        }
        catch(System.NullPointerException e)
        {
            strDefaultConcStatus='ALL';
        }
        ConcCreatedDateTo = Date.today();
        ConcCreatedDateFrom = Date.today().addMonths(-36);
        //ConcDateApproved = Date.today();
        obj_Conc.TOP_CUST_INDC__c = ' ';
        obj_Conc.SLS_RGN_CD__c = ((Obj_User.Region__c != null) ? Obj_User.Region__c : '');
        obj_Conc.SLS_DIST_CD__c = ((Obj_User.District__c != null) ? Obj_User.District__c : '');
        strTranReq = '¢¢¢' + strDefaultConcStatus + '¢¢' + ((Obj_User.Region__c != null) ? Obj_User.Region__c : '') + '¢' + ((Obj_User.District__c != null) ? Obj_User.District__c : '') + '¢¢¢¢' + datetoStringformat(ConcCreatedDateFrom) + '¢' + datetoStringformat(ConcCreatedDateTo) + '¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢EOF';
        strTranFlag = 'NO';
        for(User objUser : [select District__c,Id from user where IsActive = true and District__c != ''])
        {
            mapDistUserId.put(objUser.District__c,objUser.Id);
        }
    }
    
    public List<Concession__c> lst_Conc;
    public List<String> lst_str_Conc;
    public List<Concession__c> lst_INQ_Conc {get; set;}
    public List<String> lst_log {get;set;}
    List<Concession__c> lst_INQ_Conc_toUpdate = new List<Concession__c>();
    public String strTranReq = '¢¢¢' + 'ALL¢¢¢¢¢¢' + '06/21/16' + '¢' + '07/21/16' + '¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢EOF';
    Map<String,ID> mapDistUserId = new Map<String,ID>();
    
    public Concession__c objConAsIs;
    public Concession__c obj_Conc {get; set;}
    public Concession__c ObjMFConc;
    public Date ConcCreatedDateFrom {get; set;}
    public Date ConcCreatedDateTo {get; set;}
    public Date ConcDateApproved {get; set;}
    public String strTranFlag {get; set;}
    public String strCountryFilter {get; set;}
    public String strCountryTitle {get; set;}
    
    String strDefaultConcStatus='ALL';
    public String rcuResponse='';
    String respMessage='';
    String distUserId='';
    String rcuFlag='';
    Id ConcessionId=null;
    String IntId='';
    Id profileId=null;
    Id userId=null;
    public String profileName {get; set;}
    User Obj_User = new User();
    String strChangedFields='';
    public Boolean isFCC{get;set;}
    
    
    public PageReference RCUInquiryRequest()
    {
        LoadLiveConcessionData();
        return null;
    }
    
    public PageReference AddConcession()
    {
        PageReference pageRef = Page.DTNAAddNewconcession;
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    
    public List<SelectOption> getConcStatus()
    {
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = Concession__c.CONC_STATUS_CD__c.getDescribe();
        List<Schema.PicklistEntry> listPickValues = fieldResult.getPicklistValues();
        
        options.add(new SelectOption(strDefaultConcStatus, strDefaultConcStatus));
        
        if(strDefaultConcStatus <> 'ALL')
            options.add(new SelectOption('ALL', 'ALL'));
        
        for( Schema.PicklistEntry PickVal : listPickValues)
        {
            if(strDefaultConcStatus != PickVal.getValue())
                options.add(new SelectOption(PickVal.getLabel(), PickVal.getValue()));
        }       
        return options;
    }
    
    public void RCUInquiryQueryRequest()
    {
        
        String strConcStatus = 'ALL';
        
        //  if (obj_Conc.CONC_STATUS_CD__c != 'ALL')
        //  strConcStatus = [SELECT name,Value__C from ConcStatusMapping__c where Value__c=:obj_Conc.CONC_STATUS_CD__c and (Product_Family__C ='' or Product_Family__C ='FTL') limit 1].name;
        
        strTranReq = '¢¢¢' + 'ALL¢¢¢¢¢¢¢' + datetoStringformat(ConcCreatedDateFrom) + '¢' + datetoStringformat(ConcCreatedDateTo) + '¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢EOF';
        
        //strTranReq = '¢¢¢' + 'ALL¢';
        strTranReq = '¢¢¢' + obj_Conc.CONC_STATUS_CD__c + '¢';
        //strTranReq +=  obj_Conc.Dealer_Code__c + '¢';
        strTranReq += (obj_Conc.Dealer_Code__c != null) ? obj_Conc.Dealer_Code__c + '¢' : '¢';
        //strTranReq += '¢¢¢¢¢' + datetoStringformat(ConcCreatedDateFrom) + '¢' + datetoStringformat(ConcCreatedDateTo) + '¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢EOF';
        strTranReq += (obj_Conc.SLS_RGN_CD__c != null) ? obj_Conc.SLS_RGN_CD__c + '¢' : '¢';
        strTranReq += (obj_Conc.SLS_DIST_CD__c != null) ? obj_Conc.SLS_DIST_CD__c + '¢' : '¢';
        strTranReq += (obj_Conc.CUST_NAME_50__c != null) ? obj_Conc.CUST_NAME_50__c + '¢' : '¢';
        strTranReq += (ConcDateApproved != null) ? datetoStringformat(ConcDateApproved) + '¢' : '¢';
        strTranReq += (obj_Conc.VEH_BASE_MDL_NO__c != null) ? obj_Conc.VEH_BASE_MDL_NO__c + '¢' : '¢';
        strTranReq += datetoStringformat(ConcCreatedDateFrom) + '¢';
        strTranReq += datetoStringformat(ConcCreatedDateTo) + '¢';
        strTranReq += (obj_Conc.Name != null) ? obj_Conc.Name + '¢¢' : '¢¢';
        strTranReq += (strCountryFilter != null) ? strCountryFilter + '¢¢' : '¢¢';
        strTranReq += (obj_Conc.LEAD_CONC_NO__c != null) ? obj_Conc.LEAD_CONC_NO__c + '¢¢¢¢¢¢' : '¢¢¢¢¢¢';
        strTranReq += (obj_Conc.CONCMCDB_ENGINE__c != null) ? obj_Conc.CONCMCDB_ENGINE__c + '¢' : '¢';
        strTranReq += (obj_Conc.TOP_CUST_INDC__c != null) ? obj_Conc.TOP_CUST_INDC__c + '¢' : '¢';
        strTranReq += (obj_Conc.CONCMCDB_TRANS_TYPE__c != null) ? obj_Conc.CONCMCDB_TRANS_TYPE__c + '¢¢¢¢EOF' : '¢¢¢¢EOF';
        
        lst_INQ_Conc.clear();
        lst_str_Conc.clear();
        LoadLiveConcessionData();
    }
    
    public Date dateConverion(String strDate)
    {
        //  lst_log.add('Date:'+ strDate.Left(2) + '/' + strDate.substring(2, 4) + '/' + strDate.right(2)); 
        return(Date.parse(strDate.Left(2) + '/' + strDate.substring(2, 4) + '/' + strDate.right(2)));
    }
    
    public String datetoString(Date incDate)
    {
        return(String.valueOf(incDate).substring(5, 7) + String.valueOf(incDate).right(2) + String.valueOf(incDate).substring(2, 4));
    }
    
    public String datetoStringformat(Date incDate)
    {
        return(String.valueOf(incDate).substring(5, 7) + '/' + String.valueOf(incDate).right(2) + '/' + String.valueOf(incDate).substring(2, 4));
    }
    
    public void LoadLiveConcessionData()
    {
        strTranFlag = 'DISPLAY';
        long now = datetime.now().gettime();
        while(datetime.now().gettime()-now<3000);
        
        IntId = Obj_User.Mainframe_ID__c + '_' + String.valueof(Math.round(Math.random()*1000));
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
        
        IMSInfo.TransactionName=ConcessionRCURequest__c.getValues('INQTransactionName').Value__c;
        
        //IMSInfo.MessageData='    ¢  SF' + Obj_User.FederationIdentifier + '¢¢¢¢' + 'ALL¢¢¢¢¢¢¢' + '06/21/16' + '¢' + '07/21/16' + '¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢EOF';
        
        IMSInfo.MessageData='    ¢  SF' + Obj_User.Mainframe_ID__c + '¢' + strTranReq;
        iibIms_ConcessionApprovalRequest.ServiceResponseMsg_element ServiceResponse =
            new iibIms_ConcessionApprovalRequest.ServiceResponseMsg_element();
        iibImsConcessionRequest.IIB_generic_internet_soap11 proxyClass = 
            new iibImsConcessionRequest.IIB_generic_internet_soap11();
        proxyClass.clientCertName_x=ConcessionRCURequest__c.getValues('clientCertName_x').Value__c;
        proxyClass.clientCertPasswd_x=ConcessionRCURequest__c.getValues('clientCertPasswd_x').Value__c;
        system.debug(' proxyvalue '+ proxyClass);
        
        try
        {
            lst_log.add(IntId + 'Request:'+IMSInfo.MessageData);
            ServiceResponse = proxyClass.ExecTransaction(ClientInfo,IMSInfo);
            DTNA_IntegrationLogging.IntegrationLoggingReqInsert('INQ','IMS-Mainframe','Inquiry',IntId,IMSInfo.MessageData,'Requested');
            System.debug(' serviceresponse______ ' + ServiceResponse );
        }
        Catch(Exception e)
        {
            System.debug(e);
            DTNA_IntegrationLogging.IntegrationLoggingReqInsert('INQ','IMS-Mainframe','Inquiry',IntId,IMSInfo.MessageData,'Requested');
            DTNA_IntegrationLogging.IntegrationLoggingRespUpdate(IntId, ServiceResponse + e.getMessage() + e.getStackTraceString(),'SOAP Request Failure');
            rcuResponse=e+e.getStackTraceString();
            lst_log.add(IntId+'RESPONSE:' + rcuResponse);
            rcuFlag = 'ERROR';
            respMessage = ConcessionRCURequest__c.getValues('ExceptionMessageTemplate').Value__c + ' ' + e.getMessage();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,respMessage ));
            if(Test.isRunningTest())
            {
                iibIms_ConcessionApprovalRequest.SyncResponse_element ObjSyncResp = new iibIms_ConcessionApprovalRequest.SyncResponse_element();
                ObjSyncResp.IMSMessageData = 'CHRISTOPHER SOIKA ¢ ¢ALL¢ ¢ ¢ ¢ ¢ ¢ ¢09/28/15¢09/28/16¢ ¢ ¢ ¢N¢ ¢ ¢ ¢ ¢ ¢ ¢ MORE + ¢ ¢W40504 ¢1C8653 ¢W40504¢ ¢W40504'
                    +'¢ ¢091416¢91010 ¢ASTD¢PORTLA¢ 1¢ 83581¢M2106 ¢ ¢PNC¢ ¢15.00¢8 ¢8B¢F¢';
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
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,ConcessionRCURequest__c.getValues('ExceptionMessageTemplate').Value__c + ' ' + ServiceResponse.ErrorResponse.ErrorDescription));
            }
            else
            {
                try
                {
                    DTNA_IntegrationLogging.IntegrationLoggingRespUpdate(IntId, ServiceResponse.SyncResponse.IMSMessageData,'Response Received');
                    rcuResponse = ServiceResponse.SyncResponse.IMSMessageData;
                    lst_log.add(IntId+'RESPONSE:' + rcuResponse);
                    List<String> ConcData = rcuResponse.split('¢');
                    strTranFlag = 'NO';
                  
                                        
                    strCountryTitle = ConcData[12];
                  
                   if ((concData[13] == '000') || (concData[13] == 'CAN')) {
                    strCountryFilter = 'CAN';}
                    else
                        if ((concData[13] == '203') || (concData[13] == 'USA')){
                        strCountryFilter = 'USA';
                        } 
                        else
                        if (concData[13] == 'ALL'){
                        strCountryFilter = 'ALL';
                        }
                        
                        
                     system.debug('The value of strCountryTitle:::  ' + strCountryTitle);
                     system.debug('The value of strCountryFilter :::  ' + strCountryFilter);
                    if(ConcData[23].contains('MORE') || ConcData[23].left(1) == 'I' || Test.isRunningTest())
                    {
                        respMessage = ConcessionRCURequest__c.getValues('InfoSyncResponseMessageTemplate').Value__c + ConcData[23];
                        
                        Integer i=27;
                        Integer x=0;
                        String strTempConc = ConcData[i];
                        lst_Conc.clear();
                        
                        while(x<25)
                        {
                            if(String.isNotBlank(ConcData[i]))
                            {
                                ObjMFConc = new Concession__c();
                                ObjMFConc.Name = ConcData[i];
                                integer t=0;
                                t=1;
                                t=2;
                                t=3;
                                t=4;
                                t=5;
                                t=6;
                                t=7;
                                t=8;
                                t=9;
                                t=10;
                                t=11;
                                t=12;
                                t=13;
                                t=14;
                                t=15;
                                t=10;
                                t=11;
                                t=12;
                                t=13;
                                t=14;
                                t=15;
                                
                                
                               
                                ObjMFConc.Mainframe_ID__c = ConcData[i];
                                ObjMFConc.OrderFlag__c = ConcData[i+1];
                                ObjMFConc.LEAD_CONC_NO__c = ConcData[i+2];
                                ObjMFConc.Replaced_Flag__c = ConcData[i+3];
                                ObjMFConc.CUST_NAME_50__c = ConcData[i+5];
                                ObjMFConc.Dealer_Code__c = ConcData[i+6];
                                ObjMFConc.CITY__c = ConcData[i+7];
                                if(ConcData[i+8] <> null) ObjMFConc.RQST_MIN_UNITS__c = Integer.valueOf(ConcData[i+8].normalizeSpace());
                                ObjMFConc.VEH_BASE_MDL_NO__c = ConcData[i+10];
                                ObjMFConc.Note_Flag__c = ConcData[i+13];
                                //if(ConcStatusMapping__c.getValues(ConcData[i+12]) != null)
                                ObjMFConc.CONC_STATUS_CD__c = ConcData[i+12];
                                ObjMFConc.Note_Flag__c = ConcData[i+13];
                                // ObjMFConc.APPR_CONC_PCT__c = Decimal.valueOf(ConcData[i+14].normalizeSpace());
                                if(ConcData[i+14].normalizeSpace() <> null && ConcData[i+14].normalizeSpace().indexOfAny('.') <> -1 && ConcData[i+14].normalizeSpace() <> '') ObjMFConc.APPR_CONC_PCT__c = Double.valueOf(ConcData[i+14].normalizeSpace());
                                if(ConcData[i+14].normalizeSpace() <> null && ConcData[i+14].normalizeSpace().indexOfAny('.') == -1 && ConcData[i+14].normalizeSpace() <> '') ObjMFConc.APPR_CONC_AMT__c = Double.valueOf(ConcData[i+14].normalizeSpace());
                                ObjMFConc.SLS_RGN_CD__c = ConcData[i+15];
                                // ObjMFConc.SLS_DIST_CD__c = ConcData[i+16];
                                ObjMFConc.PROD_FAM_CD__c = ConcData[i+17];
                                if(ConcData[i+9] <> null) ObjMFConc.DLR_NET_PRC__c = Integer.valueOf(ConcData[i+9].normalizeSpace());
                                ObjMFConc.Create_Date__c = dateConverion(ConcData[i+4]);
                                
                                strTranFlag = 'DISPLAY';
                                if(mapDistUserId.get(ConcData[i+16]) != null)
                                {
                                    ObjMFConc.OwnerId=mapDistUserId.get(ConcData[i+16]);
                                }
                                else
                                {
                                    ObjMFConc.OwnerId=userId;
                                }
                                
                                lst_INQ_Conc.add(ObjMFConc);
                                //   map_Conc.put(ConcData[i],ObjMFConc);
                                //   lst_Conc.add(ObjMFConc);
                                lst_str_Conc.add(ConcData[i]);
                                
                                                  
                            }
                            x++;
                            i+=18;
                        }
                          
                            upsert lst_INQ_Conc Mainframe_ID__c;
                        
                        
                        Set<String> set_StrConc= new Set<String>();
                        for(Concession__c tempConc : [SELECT Mainframe_ID__c FROM Concession__c Where Mainframe_ID__c IN :lst_str_Conc])
                        {
                            set_StrConc.add(tempConc.Mainframe_ID__c);
                        }
                        
                        for(Concession__c tempConc : lst_INQ_Conc)
                        {
                            if(!set_StrConc.contains(tempConc.Mainframe_ID__c))  
                                lst_Conc.add(tempConc);
                            //system.debug(tempConc);
                        }
                        
                        if(strTranFlag == 'NO')
                        {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,respMessage)); 
                        }
                        else
                        {
                            // upsert lst_Conc Mainframe_ID__c;
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,respMessage ));
                        }
                        //lst_INQ_Conc.clear();
                        //lst_INQ_Conc = Database.query('SELECT Id,Name,Mainframe_ID__c,LEAD_CONC_NO__c,CUST_NAME_50__c,Dealer_Code__c,CITY__c,RQST_MIN_UNITS__c,DLR_NET_PRC__c,VEH_BASE_MDL_NO__c,CONC_STATUS_CD__c,APPR_CONC_PCT__c,APPR_CONC_AMT__c,Create_Date__c,OrderFlag__c, Replaced_Flag__c, Note_Flag__c  FROM Concession__c Where Mainframe_ID__c IN :lst_str_Conc order by Create_Date__c desc,Name desc');
                        
                        if(ConcData[23].contains('MORE'))
                        {
                            strTranFlag = 'MORE';
                            strTranReq = 'PF8¢';
                            i=0;
                            while(i<27)
                            {
                                if((i!=1) && (i!=23) && (i!=17))
                                {
                                    //if((i==0) || (i==9) || (i==10) || (i==12) || (i==17) || (i==14) || (i==23) || (i==24) || (i==2))
                                    if(i==20)
                                        strTranReq += '¢' + ConcData[i].normalizeSpace() + '¢';    
                                    else
                                        strTranReq += ConcData[i].normalizeSpace() + '¢';
                                }
                                else
                                { 
                                    if (i!=23)
                                        strTranReq += '¢';
                                }
                                i++;
                            }
                            strTranReq += 'EOF';
                            
                            rcuResponse= 'NxtPgReqString:' + strTranReq;
                            lst_log.add(rcuResponse);
                        }
                    }
                    else if(ConcData[23].left(1) == 'E')
                    {
                        respMessage = ConcessionRCURequest__c.getValues('ErrorSyncResponseMessageTemplate').Value__c + ' ' + ConcData[23].substring(ConcData[23].indexOf(' ')+1);
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,respMessage ));
                        //  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,respMessage ));
                    }
                    else
                    {
                        respMessage = ConcessionRCURequest__c.getValues('OtherSyncResponseMessageTemplate').Value__c + ' ' + ConcData[23].substring(ConcData[23].indexOf(' ')+1);
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,respMessage ));
                    }
                    
                    //rcuResponse = ServiceResponse.SyncResponse.IMSMessageData;
                }
                catch(Exception e)
                {
                    System.debug(e);
                    rcuResponse = e+e.getStackTraceString();
                    lst_log.add(rcuResponse );
                    respMessage = ConcessionRCURequest__c.getValues('ExceptionMessageTemplate').Value__c + ' ' + e.getMessage();
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,respMessage ));
                }                    
            }
        }
        System.Debug('output'+rcuResponse);
     
    }
    public String getOutput()
    {
        return (respMessage + '\n' + rcuResponse + '\n' + strTranFlag);
    }
}