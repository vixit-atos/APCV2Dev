/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Purpose:
* This class is the controller for DTNAConcessionLive Page. This is used to send request and receive
* IMS transactions(CSCNRCU,CSCNCUA and CSCNRCU).
* 
* If any new field is added in mainframe side,please make sure to add the same in below custom metadata
* MF_Field_Mapping__mdt
──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes 1.1
* modifiedBy      Deepakraj Muniraj      
* 05-22-2019      Added new transaction request for CSCNCUA. 
*                 Created new MF_Field_Mapping__mdt custom meta data for mapping the mainframe response
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/

public with sharing class DTNA_RCU_Inquiry_Request
{
    //variable and object initialization
    public Concession__c obj_Conc {get; set;}    
    public Concession__c objConAsIs;
    public List<Comment__c> list_Comment {get; set;}
    //Deepakraj change start - To protect below fields from updates for CSCNRCU transactions
    String rcu_Req_PRCP_INDC = '';
    String rcu_apr_PRCP_INDC = '';
    String rcu_mkt_seg = '';
    String rcu_mkt_desc = '';
    String rcu_prod_seg = '';
    String rcu_prod_desc = '';
    //Deepakraj change end
    
    String rcuResponse='';
    String respMessage='';
    String rcuFlag='';
    String Str_ConcessionNumer='';
    Id ConcessionId=null; 
    String IntId='';
    Id profileId=null;
    Id userId=null;
    String profileName='';
    String mainframeId='';
 //   String groupcode='';
    User Obj_User = new User();
    String strChangedFields='';
    Integer iLoop=0;
    public List<Comment__c> list_Comment_Copy = new List<Comment__c>();
    //public Concession__c ObjectConcession {get; set;}
    ApexPages.standardController stdController= null;
    public Boolean isSubmitForApproval {get;set;}
    public Boolean isApprovalrecall {get;set;}
    public String strApprComments1 {get;set;}
    public String strApprComments2 {get;set;}
    public String strApprComments3 {get;set;}
    public String strApprComments4 {get;set;}
    public String strApprComments5 {get;set;}
    public String strApprCommConc = '';
    public String strOrderSerials {get;set;}
    public String ProcessComment {get;set;}
    public String CommentAction='';
    public List<Concession__C> lstConc = new List<Concession__C>();
    public Boolean isCUA {get;set;} //CUA function is enabled
    public String screen {get;set;} //Setting default screen
    public Boolean isRCUandCUA {get;set;} //RCU & CUA function is enabled
    public Boolean isEditable {get;set;} //Fields are editable
    public string groupcode {get;set;}
    
    //public String UserRegionCode {get;set;}
    
    //controller constructor
    public DTNA_RCU_Inquiry_Request(ApexPages.StandardController controller) 
    {
        if(ApexPages.currentPage().getParameters().get('id') <> null)
            obj_Conc = [SELECT Id,Name,Approval_Comments__c, LEAD_CONC_NO__c,Dealer_Code__C,CONC_STATUS_CD__c,CONT_PRSN_NAME_42__c,DIST_MGR_NAME__c,CUST_NAME_50__c,BUS_TYPE__c,CUST_ADDR1__c,TRUCKS_IN_BUS__c,
                        CUST_ACCT_NO__c,GLDR_INDC__c,CUST_ADDR2__c,City__c,ST_CD__c,VEH_MDL_NO__c,VEH_BASE_MDL_NO__c,CMPTR_CD__c,PRC_METH_TYPE_cd__c,TOP_CUST_INDC__c,DCTRADE_INDC__c,RV_INDC__c,
                        CTRADE_INDC__c,TXNWRKS_INDC__c,TXNCOUN_INDC__c,REQ_PRCP_INDC__c,RQST_MIN_UNITS__c,RQST_MAX_UNITS__c,PREV_DLR_NET__c,DLR_NET_PRC__C,TOT_MIN__c,TOT_MAX__c,PREV_CONC_AMT__c,CURR_CONC_AMT__c,
                        APPR_MIN_UNITS__c,APPR_MAX_UNITS__c,PREV_ADDL_CONC__c,CURR_ADDL_CONC__c,RQST_CONC_PCT__c,REQ_FLAG1__c,RQST_CONC_AMT__c,REQ_FLAG2__c,APPR_CONC_PCT__c,APR_FLAG1__c,APPR_CONC_AMT__c,APR_FLAG2__c,
                        PREV_DN_COST__c,PREV_FREIGHT__c,CURR_FREIGHT__c,APPR_INITS__c,DATE_APPR__C,PREV_MISC_ADD_ONS__c,CURR_MISC_ADD_ONS__c,DATE_DELV_RQST__c,DATE_LATEST_ACCEPT__c,
                        PREV_CST_N_CRDS__c,CURR_CST_N_CRDS__c,REQ_PRICELVL__c,PREV_DLR_PROFIT__c,EST_DLR_PROF__C,ACCTTYPE__c,REQ_PRICELVL_DESC__c,PREV_SELL_PRC__c,APR_PRICELVL__c,
                        APR_PRCP_INDC__c,APR_PRICELVL_DESC__c,EXPR_DATE__c,DATE_TSO_RECV__c,DATE_TSO_RECV_TO__c,CONCMCDB_MARKET_SEG__c,MKTDESC__c,SEGTYPE__c,SEGDESC__c,PREV_TOT_SELL_PRC__c,
                        GDLNPCT__c,CONC_DISCR_PCT_TOT__c,ESC_STAT__c,ESC_ACTL__c,COMMENT_SEL__c,WS_GROSS_CONT__c,Concession_Amount__C,CONCPRCL_APPR_RCA__c,WS_ADDL_CONC__c,WS_RESERVE__c,WS_EXTRAS__c,WS_CONT_AMT__c,
                        WS_VEND_AMT__c,WS_OPT_MRGN__c,RMS_RECALC__c,RMS_START__c,PROD_FAM_CD__c, TRIG_PCT__c,DELT_PCT__c,CURR_DN_COST__c,CURR_SELL_PRC__c,CURR_TOT_SELL_PRC__c,APPR_NET_CNTRB__c,
                        Escalator_Percentage__c,Escalator_Model_Year__c,Model_Year__c,In_Approval_Process__c,Escalator_DB_Code__c,Escalator_Amount__c,WS_Only__c,Deal_Comments__c FROM Concession__C WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        
        if(ApexPages.currentPage().getParameters().get('Concname') <> null)
        {
            lstConc =[SELECT Id,Name,Approval_Comments__c, LEAD_CONC_NO__c,Dealer_Code__C,CONC_STATUS_CD__c,CONT_PRSN_NAME_42__c,DIST_MGR_NAME__c,CUST_NAME_50__c,BUS_TYPE__c,CUST_ADDR1__c,TRUCKS_IN_BUS__c,
                      CUST_ACCT_NO__c,GLDR_INDC__c,CUST_ADDR2__c,City__c,ST_CD__c,VEH_MDL_NO__c,VEH_BASE_MDL_NO__c,CMPTR_CD__c,PRC_METH_TYPE_cd__c,TOP_CUST_INDC__c,DCTRADE_INDC__c,RV_INDC__c,
                      CTRADE_INDC__c,TXNWRKS_INDC__c,TXNCOUN_INDC__c,REQ_PRCP_INDC__c,RQST_MIN_UNITS__c,RQST_MAX_UNITS__c,PREV_DLR_NET__c,DLR_NET_PRC__C,TOT_MIN__c,TOT_MAX__c,PREV_CONC_AMT__c,CURR_CONC_AMT__c,
                      APPR_MIN_UNITS__c,APPR_MAX_UNITS__c,PREV_ADDL_CONC__c,CURR_ADDL_CONC__c,RQST_CONC_PCT__c,REQ_FLAG1__c,RQST_CONC_AMT__c,REQ_FLAG2__c,APPR_CONC_PCT__c,APR_FLAG1__c,APPR_CONC_AMT__c,APR_FLAG2__c,
                      PREV_DN_COST__c,PREV_FREIGHT__c,CURR_FREIGHT__c,APPR_INITS__c,DATE_APPR__C,PREV_MISC_ADD_ONS__c,CURR_MISC_ADD_ONS__c,DATE_DELV_RQST__c,DATE_LATEST_ACCEPT__c,
                      PREV_CST_N_CRDS__c,CURR_CST_N_CRDS__c,REQ_PRICELVL__c,PREV_DLR_PROFIT__c,EST_DLR_PROF__C,ACCTTYPE__c,REQ_PRICELVL_DESC__c,PREV_SELL_PRC__c,APR_PRICELVL__c,
                      APR_PRCP_INDC__c,APR_PRICELVL_DESC__c,EXPR_DATE__c,DATE_TSO_RECV__c,DATE_TSO_RECV_TO__c,CONCMCDB_MARKET_SEG__c,MKTDESC__c,SEGTYPE__c,SEGDESC__c,PREV_TOT_SELL_PRC__c,
                      GDLNPCT__c,CONC_DISCR_PCT_TOT__c,ESC_STAT__c,ESC_ACTL__c,COMMENT_SEL__c,WS_GROSS_CONT__c,Concession_Amount__C,CONCPRCL_APPR_RCA__c,WS_ADDL_CONC__c,WS_RESERVE__c,WS_EXTRAS__c,WS_CONT_AMT__c,
                      WS_VEND_AMT__c,WS_OPT_MRGN__c,RMS_RECALC__c,RMS_START__c,PROD_FAM_CD__c, TRIG_PCT__c,DELT_PCT__c,CURR_DN_COST__c,CURR_SELL_PRC__c,CURR_TOT_SELL_PRC__c,APPR_NET_CNTRB__c,
                      Escalator_Percentage__c,Escalator_Model_Year__c,Model_Year__c,In_Approval_Process__c,Escalator_DB_Code__c,Escalator_Amount__c,WS_Only__c,Deal_Comments__c FROM Concession__C WHERE Name = :ApexPages.currentPage().getParameters().get('Concname') LIMIT 1];
            if(lstConc.size() == 1)
            {
                obj_Conc = lstConc[0];
            }
            else
            {
                obj_Conc = new Concession__c(Name=ApexPages.currentPage().getParameters().get('Concname'));
                //insert obj_Conc;
            }
        }
         
        Str_ConcessionNumer = obj_Conc.Name;
        list_Comment = new List<Comment__c>();
        objConAsIs = new Concession__c();
        //UserRegionCode = 'RG';
        //ConcessionId = ApexPages.currentPage().getParameters().get('id');
        userId = userinfo.getUserId();
        profileId = userinfo.getProfileId();
        User usr = [select id, UserRole.Name, Profile.name, UserRole.ParentRoleId,Mainframe_ID__c from User where id=:userId];
        
        List<UserRole> usrRoleLst = [Select Id, Name from UserRole];
        Map<String, Id> usrRoleMap = new Map<String, Id>();
        for(UserRole ur: usrRoleLst){
            
            usrRoleMap.put(ur.Name, ur.Id);
        }
        profileName = usr.Profile.name;
        mainframeId = usr.Mainframe_ID__c;
//Added for production test validation  
          if(Test.isRunningTest())
          {
             groupcode = 'RG'; 
          }
        else{    
        	UserMainframeID__c mdLst = [select PQ_GRP_CD__c,PROD_FAM_CD__c,PQ_FUNCT_CD__c,CTRY_CD__c  from UserMainframeID__c  where name= :mainframeId]; 
            groupcode = mdlst.PQ_GRP_CD__c;
        }

        if (groupcode == 'CN') {
                screen = 'CSCNCUA';
                isRCUandCUA = true; 
        }
        else
        if (groupcode == 'RG') {
            if(Str_ConcessionNumer.left(1) == 'R') {
                screen = 'CSCNRRU';
                isRCUandCUA = true; 
            }
            else {
                screen = 'CSCNRCU';
                isRCUandCUA = true; 
        }
        }
        
       List<PermissionSetAssignment> lstcurrentUserPerSet = [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment  WHERE AssigneeId = :Userinfo.getUserId() and (PermissionSet.Name = 'ConcLive_CUA_Screen_Access')];
        
        if(lstcurrentUserPerSet.size() > 0 ){
            isCUA = false; isRCUandCUA = true;
            screen = 'CSCNCUA';
        }
        
        if(profileName == 'System Administrator' || profileName== '  DTNA - FTL DOA' || profileName == 'DTNA - WST DOA' || profileName == 'DTNA - FCCC Sales' || lstcurrentUserPerSet.size() > 0 ){
            isEditable = true;
        }
        
        Obj_User = [Select Id,Mainframe_ID__c,FederationIdentifier,District__c from User where Id=:userId];

        stdController=controller;
 
        isSubmitForApproval = true;   

        
        isApprovalrecall = obj_Conc.In_Approval_Process__c;
        isSubmitForApproval = (obj_Conc.In_Approval_Process__c) ? false : true;
        
        // exp approval end
        if(ApexPages.currentPage().getParameters().get('selScreen') <> null){
            screen = ApexPages.currentPage().getParameters().get('selScreen');
        }
        
        
        if(ApexPages.currentPage().getParameters().get('MessageSuccessful') <> null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,ApexPages.currentPage().getParameters().get('MessageSuccessful')));
        }
        
    }
    
    
    //Invokes on Page Load
    public PageReference RCUInquiryRequest()
    {
        
        LoadLiveConcessionData();  
        
        
        return null;
    }
    
    //Convert the date format btw mainframe and salesforce
    public Date dateConverion(String strDate)
    {
        return(Date.parse(strDate.Left(2) + '/' + strDate.substring(2, 4) + '/' + strDate.right(2)) );
    }
    
    //Convert the date format btw salesforce and mainframe
    public String datetoString(Date incDate)
    {
        return(String.valueOf(incDate).substring(5, 7) + String.valueOf(incDate).right(2) + String.valueOf(incDate).substring(2, 4));
    }
    
    //Calculate the Requested Concession Amount based on the Requested Percentage change
    public void CalcOnChangedConcPct()
    {
        obj_Conc.RQST_CONC_PCT__c = obj_Conc.RQST_CONC_PCT__c.setscale(2);
        obj_Conc.RQST_CONC_AMT__c = (obj_Conc.RQST_CONC_PCT__c /100)*obj_Conc.DLR_NET_PRC__C;
        obj_Conc.RQST_CONC_AMT__c = obj_Conc.RQST_CONC_AMT__c.round();
        rcuResponse+= obj_Conc.RQST_CONC_AMT__c;
        CalcTranChanges();
    }
    
    //Calculate the Requested Concession Percentage based on the Requested Amount change    
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
        Decimal decConcAmtDiff = obj_Conc.RQST_CONC_AMT__c - objConAsIs.RQST_CONC_AMT__c;
        if(obj_Conc.CURR_DN_COST__c != null) obj_Conc.CURR_DN_COST__c-=decConcAmtDiff;
        if(obj_Conc.CURR_SELL_PRC__c != null) obj_Conc.CURR_SELL_PRC__c-=decConcAmtDiff;
        if(obj_Conc.CURR_TOT_SELL_PRC__c != null) obj_Conc.CURR_TOT_SELL_PRC__c-=decConcAmtDiff;
        if(obj_Conc.APPR_NET_CNTRB__c != null) obj_Conc.APPR_NET_CNTRB__c-=decConcAmtDiff;
    }
    
    public Pagereference RCUApprovalRequest()
    {
        
        if(isCUA == true || (isRCUandCUA && Screen == 'CSCNCUA'  )) {
            return RCURequest('S');
        }
        else{
            return RCURequest(' ');
        }
    }
    
    public Pagereference RCURejectionRequest()
    {
        return RCURequest('R');
    }
    
    public Pagereference RCUUpdateRequest()
        
    {
        if(isCUA == true || (isRCUandCUA && Screen == 'CSCNCUA'  )) {
            return RCURequest('U');
            
        }
        else{
            return RCURequest('C');
        }
    }
    public Pagereference RCUVoidRequest()
    {
        return RCURequest('V');
    }
    public Pagereference CUACopyRequest()
    {
        return RCURequest('P');
    }
    
    public Pagereference RCUCancelRequest()     
    {
        if(isCUA == true || (isRCUandCUA && Screen == 'CSCNCUA'  )){
            return RCURequest('C');
        }
        else{
            return RCURequest('X');
        }
    }
    
    public void CUADealEditRequest()
    {
        
        RCURequest('E');
        
    }
    
    
    public Pagereference RCUReplaceRequest()
    {
        if(isCUA == true || (isRCUandCUA && Screen == 'CSCNCUA'  )){
            return RCURequest('R');
        }
        else{
            return RCURequest('Z');
        }
    }
    
    
    public PageReference returnPage()
    {
        PageReference p = Page.DTNAConcessionInquiryMobile;
        p.setRedirect(true);
        return p;
    }
    
    public pagereference RCURequest(String ReqType)
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
        
        if(isCUA == true || (isRCUandCUA && Screen == 'CSCNCUA')) {
            IMSInfo.TransactionName='CSCNCUA';        }
        else if(Str_ConcessionNumer.left(1) == 'R')
            IMSInfo.TransactionName='CSCNRRU';  
        else
            IMSInfo.TransactionName=ConcessionRCURequest__c.getValues('TransactionName').Value__c;
        
        rcuResponse+='$'+obj_Conc.LEAD_CONC_NO__c;
        rcuResponse+='$'+objConAsIs.LEAD_CONC_NO__c;
        
        strApprCommConc += (strApprComments1 != null && strApprComments1 != '') ? strApprComments1.rightPad(40) : '';
        strApprCommConc += (strApprComments2 != null && strApprComments2 != '') ? strApprComments2.rightPad(40) : '';
        strApprCommConc += (strApprComments3 != null && strApprComments3 != '') ? strApprComments3.rightPad(40) : '';
        strApprCommConc += (strApprComments4 != null && strApprComments4 != '') ? strApprComments4.rightPad(40) : '';
        strApprCommConc += (strApprComments5 != null && strApprComments5 != '') ? strApprComments5.rightPad(40) : '';
        strApprComments1 = '';
        strApprComments2 = '';
        strApprComments3 = '';
        strApprComments4 = '';
        strApprComments5 = '';
        
        
        if(ReqType == 'V' && (isCUA == true || (isRCUandCUA && Screen == 'CSCNCUA'  ))){
            IMSInfo.MessageData='    ¢  XX' + ReqType +'¢' + Obj_User.Mainframe_ID__c + '¢' + Str_ConcessionNumer +'¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢';
            IMSInfo.MessageData += obj_Conc.PRC_METH_TYPE_CD__c + '¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢EOF'; 
        }
        else if(isCUA == true || (isRCUandCUA && Screen == 'CSCNCUA'  )){
            IMSInfo.MessageData='    ¢  XX' + ReqType +'¢' + Obj_User.Mainframe_ID__c + '¢' + Str_ConcessionNumer +'¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢';
            IMSInfo.MessageData += obj_Conc.PRC_METH_TYPE_CD__c + '¢¢¢¢¢¢¢¢¢¢¢¢';
            IMSInfo.MessageData += (objConAsIs.APPR_CONC_PCT__c != obj_Conc.APPR_CONC_PCT__c) ? obj_Conc.APPR_CONC_PCT__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.APPR_CONC_AMT__c != obj_Conc.APPR_CONC_AMT__c) ? obj_Conc.APPR_CONC_AMT__c + '¢¢¢¢¢¢¢¢¢¢¢' : '¢¢¢¢¢¢¢¢¢¢¢'; 
            IMSInfo.MessageData += obj_Conc.APPR_INITS__c +'¢¢¢¢¢¢¢¢¢¢¢¢';
            IMSInfo.MessageData += obj_Conc.TOP_CUST_INDC__c +'¢';
            IMSInfo.MessageData += obj_Conc.DCTRADE_INDC__c +'¢';
            IMSInfo.MessageData += obj_Conc.RV_INDC__c +'¢¢¢¢¢¢¢¢¢¢¢¢';
            IMSInfo.MessageData += obj_Conc.CTRADE_INDC__c + '¢';
            IMSInfo.MessageData += obj_Conc.TXNWRKS_INDC__c + '¢';
            IMSInfo.MessageData += obj_Conc.TXNCOUN_INDC__c + '¢¢EOF';   
            
            
        }
        else
        {
            IMSInfo.MessageData='    ¢  XX' + ReqType +'¢' + Obj_User.Mainframe_ID__c + '¢' + Str_ConcessionNumer + '¢' + obj_Conc.CONC_STATUS_CD__c + '¢';  
            
            //  }
            //IMSInfo.MessageData += (objConAsIs.Approval_Comments__c!= obj_Conc.Approval_Comments__c) ? obj_Conc.Approval_Comments__c + '¢' : '¢'; 
            IMSInfo.MessageData += strApprCommConc + '¢';
            IMSInfo.MessageData += (objConAsIs.LEAD_CONC_NO__c != obj_Conc.LEAD_CONC_NO__c || ReqType == 'Z') ? obj_Conc.LEAD_CONC_NO__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.Dealer_Code__C != obj_Conc.Dealer_Code__C || ReqType == 'Z') ? obj_Conc.Dealer_Code__C + '¢' : '¢';
            //IMSInfo.MessageData += obj_Conc.LEAD_CONC_NO__c + '¢';
            //IMSInfo.MessageData += obj_Conc.Dealer_Code__C + '¢';
            IMSInfo.MessageData += (objConAsIs.CONT_PRSN_NAME_42__c != obj_Conc.CONT_PRSN_NAME_42__c) ? obj_Conc.CONT_PRSN_NAME_42__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.CUST_NAME_50__c != obj_Conc.CUST_NAME_50__c) ? obj_Conc.CUST_NAME_50__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.CUST_ADDR1__c != obj_Conc.CUST_ADDR1__c) ? obj_Conc.CUST_ADDR1__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.CUST_ADDR2__c != obj_Conc.CUST_ADDR2__c) ? obj_Conc.CUST_ADDR2__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.CUST_ACCT_NO__c != obj_Conc.CUST_ACCT_NO__c) ? obj_Conc.CUST_ACCT_NO__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.GLDR_INDC__c != obj_Conc.GLDR_INDC__c) ? obj_Conc.GLDR_INDC__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.City__c != obj_Conc.City__c) ? obj_Conc.City__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.ST_CD__c != obj_Conc.ST_CD__c) ? obj_Conc.ST_CD__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.CMPTR_CD__c != obj_Conc.CMPTR_CD__c) ? obj_Conc.CMPTR_CD__c + '¢¢¢' : '¢¢¢';
            IMSInfo.MessageData += (objConAsIs.RQST_MIN_UNITS__c != obj_Conc.RQST_MIN_UNITS__c) ? obj_Conc.RQST_MIN_UNITS__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.RQST_MAX_UNITS__c != obj_Conc.RQST_MAX_UNITS__c) ? obj_Conc.RQST_MAX_UNITS__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.TOT_MIN__c != obj_Conc.TOT_MIN__c) ? obj_Conc.TOT_MIN__c + '¢' : '¢';
           IMSInfo.MessageData += (objConAsIs.TOT_MAX__c != obj_Conc.TOT_MAX__c) ? obj_Conc.TOT_MAX__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.APPR_MIN_UNITS__c != obj_Conc.APPR_MIN_UNITS__c) ? obj_Conc.APPR_MIN_UNITS__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.APPR_MAX_UNITS__c != obj_Conc.APPR_MAX_UNITS__c) ? obj_Conc.APPR_MAX_UNITS__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.RQST_CONC_PCT__c != obj_Conc.RQST_CONC_PCT__c) ? obj_Conc.RQST_CONC_PCT__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.RQST_CONC_AMT__c != obj_Conc.RQST_CONC_AMT__c) ? obj_Conc.RQST_CONC_AMT__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.APPR_CONC_PCT__c != obj_Conc.APPR_CONC_PCT__c) ? obj_Conc.APPR_CONC_PCT__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.APPR_CONC_AMT__c != obj_Conc.APPR_CONC_AMT__c) ? obj_Conc.APPR_CONC_AMT__c + '¢' : '¢'; 
            IMSInfo.MessageData += (objConAsIs.DATE_DELV_RQST__c != obj_Conc.DATE_DELV_RQST__c) ? datetoString(obj_Conc.DATE_DELV_RQST__c) + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.DATE_LATEST_ACCEPT__c != obj_Conc.DATE_LATEST_ACCEPT__c) ? datetoString(obj_Conc.DATE_LATEST_ACCEPT__c) + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.REQ_PRICELVL__c != obj_Conc.REQ_PRICELVL__c || ReqType == 'Z') ? obj_Conc.REQ_PRICELVL__c + '¢' : '¢';
            //IMSInfo.MessageData += obj_Conc.REQ_PRICELVL__c + '¢';
            IMSInfo.MessageData += (objConAsIs.REQ_PRCP_INDC__c != obj_Conc.REQ_PRCP_INDC__c) ? obj_Conc.REQ_PRCP_INDC__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.APR_PRICELVL__c != obj_Conc.APR_PRICELVL__c) ? obj_Conc.APR_PRICELVL__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.APR_PRCP_INDC__c != obj_Conc.APR_PRCP_INDC__c) ? obj_Conc.APR_PRCP_INDC__c + '¢' : '¢';
            IMSInfo.MessageData += (objConAsIs.ACCTTYPE__c != obj_Conc.ACCTTYPE__c) ? obj_Conc.ACCTTYPE__c + '¢¢¢' : '¢¢¢';
            
            IMSInfo.MessageData += (strApprCommConc != '') ? 'IN¢EOF' : '¢EOF';
            strApprCommConc = '';
        }
        rcuResponse+=IMSInfo.MessageData;
        //   ¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢EOF
        
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
                        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,respMessage ));
                        if(obj_Conc.PROD_FAM_CD__c =='W' && ReqType == '')
                            obj_Conc.CONC_STATUS_CD__c = 'PNC';
                        else if(ReqType == '')
                            obj_Conc.CONC_STATUS_CD__c = 'APC';
                        else if(ReqType == 'R')
                            obj_Conc.CONC_STATUS_CD__c = 'RPC';
                        else if(ReqType == 'V')
                            obj_Conc.CONC_STATUS_CD__c = 'VOD';
                        else if(ReqType == 'X')
                            obj_Conc.CONC_STATUS_CD__c = 'CAN';
                        else if(ReqType == 'Z')
                            obj_Conc.CONC_STATUS_CD__c = 'RPL'; 
                        else if (ReqType == 'C')
                            obj_Conc.CONC_STATUS_CD__c = 'CAN';
                        else if (ReqType == 'S')
                            obj_Conc.CONC_STATUS_CD__c = 'APC';
                        
                        //   LoadLiveConcessionData();
                        
                    }
                    else if(respMessage.split('¢')[3].left(1) == 'E')
                    {
                        respMessage = ConcessionRCURequest__c.getValues('ErrorSyncResponseMessageTemplate').Value__c + ' ' + respMessage.split('¢')[3].substring(respMessage.split('¢')[3].indexOf(' ')+1);
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,respMessage ));
                        //    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,respMessage ));
                        return null;
                    }
                    else
                    {
                        respMessage = ConcessionRCURequest__c.getValues('OtherSyncResponseMessageTemplate').Value__c + ' ' + respMessage.split('¢')[3].substring(respMessage.split('¢')[3].indexOf(' ')+1);
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,respMessage ));   
                        return null;
                    }
                    
                    //rcuResponse = ServiceResponse.SyncResponse.IMSMessageData;
                    system.debug('######respMessage = '+ServiceResponse.SyncResponse.IMSMessageData);
                    system.debug('##P#='+ReqType);
                    PageReference p = (UserInfo.getUiTheme() == 'Theme4t') ? Page.DTNAConcessionLiveMobile : Page.DTNAConcessionLive;
                    //Copy button Function
                    if(ReqType == 'P') {
                        Concession__c copyConc = obj_Conc.clone(false, false, false, false);
                        copyConc.Name = ServiceResponse.SyncResponse.IMSMessageData.split('¢')[0];
                        copyConc.LEAD_CONC_NO__c = ServiceResponse.SyncResponse.IMSMessageData.split('¢')[0];
                        copyConc.APR_CONC_PCT__c = null;
                        copyConc.APPR_CONC_AMT__c = null;
                        copyConc.APPR_INITS__c = null;
                        copyConc.DATE_APPR__c = null;
                        copyConc.APPR_MIN_UNITS__c = null;
                        copyConc.APPR_MAX_UNITS__c = null;
                        insert copyConc;
                        string msg =  ServiceResponse.SyncResponse.IMSMessageData.split('¢')[3].substring(ServiceResponse.SyncResponse.IMSMessageData.split('¢')[3].indexOf(' ')+1);
                        system.debug('######COPYConcession='+copyConc);
                        //Pagereference p =  new Pagereference('/apex/DTNAConcessionLive?id='+copyConc.Id+'&MessageSuccessful='+msg);
                        // p.getParameters().put('ConcName',Str_ConcessionNumer);
                        p.getParameters().put('Id',copyConc.Id);
                        p.getParameters().put('MessageSuccessful',msg);
                        p.setRedirect(true);
                        return p;
                    }
                    //Replace button Function 
                    else if(ReqType == 'R') { 
                        string replaceStr = ServiceResponse.SyncResponse.IMSMessageData.split('¢')[3].replaceAll( '\\s+', '');
                        if(replaceStr != null){
                            obj_Conc.Name = replaceStr.right(6);
                            obj_Conc.LEAD_CONC_NO__c = replaceStr.right(6);
                            obj_Conc.CONC_STATUS_CD__c = 'PNC';
                            obj_Conc.DATE_APPR__c = null;
                            update obj_Conc;
                            string msg =  ServiceResponse.SyncResponse.IMSMessageData.split('¢')[3].substring(ServiceResponse.SyncResponse.IMSMessageData.split('¢')[3].indexOf(' ')+1);
                            //Pagereference p = new Pagereference('/apex/DTNAConcessionLive?id='+obj_Conc.Id+'&MessageSuccessful='+msg);
                            //p.getParameters().put('ConcName',Str_ConcessionNumer);
                            p.getParameters().put('Id',obj_Conc.Id);
                            p.getParameters().put('MessageSuccessful',msg);
                            p.setRedirect(true);
                            return p;
                            
                        }
                    }
                    
                    else 
                    {
                        string msg =  ServiceResponse.SyncResponse.IMSMessageData.split('¢')[3].substring(ServiceResponse.SyncResponse.IMSMessageData.split('¢')[3].indexOf(' ')+1);
                        if(ReqType == 'S')
                            obj_Conc.CONC_STATUS_CD__c = 'APC';
                        else if(ReqType == 'C')
                            obj_Conc.CONC_STATUS_CD__c = 'CAN';
                        //Pagereference p = new Pagereference('/apex/DTNAConcessionLive?id='+obj_Conc.Id+'&MessageSuccessful='+msg);
                        //p.setRedirect(true);
                        // return p;
                        //p.getParameters().put('ConcName',Str_ConcessionNumer);
                        p.getParameters().put('Id',obj_Conc.Id);
                        p.getParameters().put('MessageSuccessful',msg);
                        p.setRedirect(true);
                        return p;
                    }
                    
                    
                }
                catch(Exception e)
                {
                    System.debug(e);
                    rcuResponse+=rcuResponse+e+e.getStackTraceString();
                }
                //LoadLiveConcessionData(); 
                
                
            }
        } 
        return null;
    }
    
    public pagereference ReloadRCUPage()
    {
        //PageReference ConcPage = new PageReference('/apex/DTNAConcessionLive');
        PageReference ConcPage = Page.DTNAConcessionLive;       
        //ConcPage.getParameters().put('ConcName',Str_ConcessionNumer);
        ConcPage.getParameters().put('Id',Concessionid);
        ConcPage.setRedirect(true);
        return ConcPage;
    }
    
    public pagereference ReloadMobileRCUPage()
    {
        //PageReference ConcPage = new PageReference('/apex/DTNAConcessionLive');
        PageReference ConcPage = Page.DTNAConcessionLiveMobile;
        ConcPage.getParameters().put('Id',Concessionid);
        //ConcPage.getParameters().put('ConcName',Str_ConcessionNumer);
        ConcPage.setRedirect(true);
        return ConcPage;
    }
    
    public void ReloadConcLivePage()
    {
        LoadLiveConcessionData();
    }
    
    public void LoadLiveConcessionData()
    {
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

    
 /*       if(isCUA == true || (isRCUandCUA && Screen == 'CSCNCUA'))
         {
            IMSInfo.TransactionName='CSCNCUA';     
            IMSInfo.MessageData='    ¢  SF ¢' + Obj_User.Mainframe_ID__c + '¢' + Str_ConcessionNumer + '¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢Y¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢EOF';
                }
        else
        
        if(Str_ConcessionNumer.left(1) == 'R'){
            IMSInfo.TransactionName='CSCNRRU'; 
            IMSInfo.MessageData='    ¢  SF ¢' + Obj_User.Mainframe_ID__c + '¢' + Str_ConcessionNumer + '¢RPR¢' + '' + '¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢EOF';}         
        else
       
        if (Screen == 'CSCNRCU')
        {
            System.debug('The logic comes to rcu screen');
            IMSInfo.TransactionName='CSCNRCU';
            IMSInfo.MessageData='    ¢  SF ¢' + Obj_User.Mainframe_ID__c + '¢' + Str_ConcessionNumer + '¢RPR¢' + '' + '¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢EOF';} 
        else
        {
           IMSInfo.TransactionName=ConcessionRCURequest__c.getValues('TransactionName').Value__c;
            IMSInfo.MessageData='    ¢  SF ¢' + Obj_User.Mainframe_ID__c + '¢' + Str_ConcessionNumer + '¢RPR¢' + '' + '¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢EOF';} */
         

         if (Screen == 'CSCNCUA')
         {
             System.debug('The logic enters 1');
            IMSInfo.TransactionName='CSCNCUA';     
            IMSInfo.MessageData='    ¢  SF ¢' + Obj_User.Mainframe_ID__c + '¢' + Str_ConcessionNumer + '¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢Y¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢EOF';
                }
        else
        
        if(Str_ConcessionNumer.left(1) == 'R' && Screen == 'CSCNRRU'){
            System.debug('The logic enters 2');
            IMSInfo.TransactionName='CSCNRRU'; 
            IMSInfo.MessageData='    ¢  SF ¢' + Obj_User.Mainframe_ID__c + '¢' + Str_ConcessionNumer + '¢RPR¢' + '' + '¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢EOF';}         
        else
       
        if (Screen == 'CSCNRCU')
        {
            System.debug('The logic enters 3');
            System.debug('The logic comes to rcu screen');
            IMSInfo.TransactionName='CSCNRCU';
            IMSInfo.MessageData='    ¢  SF ¢' + Obj_User.Mainframe_ID__c + '¢' + Str_ConcessionNumer + '¢RPR¢' + '' + '¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢EOF';} 
        else
        {
            System.debug('The logic enters 4');
           IMSInfo.TransactionName=ConcessionRCURequest__c.getValues('TransactionName').Value__c;
            IMSInfo.MessageData='    ¢  SF ¢' + Obj_User.Mainframe_ID__c + '¢' + Str_ConcessionNumer + '¢RPR¢' + '' + '¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢EOF';} 
            

        iibIms_ConcessionApprovalRequest.ServiceResponseMsg_element ServiceResponse =
            new iibIms_ConcessionApprovalRequest.ServiceResponseMsg_element();
        iibImsConcessionRequest.IIB_generic_internet_soap11 proxyClass = 
            new iibImsConcessionRequest.IIB_generic_internet_soap11();
        proxyClass.clientCertName_x=ConcessionRCURequest__c.getValues('clientCertName_x').Value__c;
        proxyClass.clientCertPasswd_x=ConcessionRCURequest__c.getValues('clientCertPasswd_x').Value__c;
        system.debug(' proxyvalue '+ proxyClass);
        
        try
        {
            ServiceResponse = proxyClass.ExecTransaction(ClientInfo,IMSInfo);
            DTNA_IntegrationLogging.IntegrationLoggingReqInsert(IMSInfo.TransactionName,'IMS-Mainframe','Inquiry',IntId,IMSInfo.TransactionName+IMSInfo.MessageData,'Requested');
            System.debug(' serviceresponse______ ' + ServiceResponse );
        }
        Catch(Exception e)
        {
            System.debug(e);
            DTNA_IntegrationLogging.IntegrationLoggingReqInsert(IMSInfo.TransactionName,'IMS-Mainframe','Inquiry',IntId,IMSInfo.TransactionName+IMSInfo.MessageData,'Requested');
            DTNA_IntegrationLogging.IntegrationLoggingRespUpdate(IntId, ServiceResponse + e.getMessage() + e.getStackTraceString(),'SOAP Request Failure');
            rcuResponse=rcuResponse+e+e.getStackTraceString();
            rcuFlag = 'ERROR';
            respMessage = ConcessionRCURequest__c.getValues('ExceptionMessageTemplate').Value__c + ' ' + e.getMessage();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,respMessage ));
            if(Test.isRunningTest())
            {
                iibIms_ConcessionApprovalRequest.SyncResponse_element ObjSyncResp = new iibIms_ConcessionApprovalRequest.SyncResponse_element();
                ObjSyncResp.IMSMessageData = 'T12345¢JFTL026 ¢I-611 CONCESSION IS EXPIRED ¢ ¢T12345¢2H6316¢JRFD¢TRUCK COUNTRY OF WISCONSIN¢2H6316¢042516¢EXP¢DE FOREST,'
                    +'WI ¢PATTON ¢ ¢CENTRAL ¢25¢ ¢ ¢ ¢ ¢DYLAN GLINDINNING ¢ ¢ ¢ ¢ ¢FRANK STRANZL ¢HULL TRANSPORT LOGISTICS ¢Something¢ ¢352 INDUSTRIAL CIRCL¢3¢W63982¢N¢Something'
                    +'¢ ¢ ¢ ¢STOUGHTON ¢WI¢ ¢PX125064S T¢CA125SLP ¢INT¢PET¢ ¢ 15¢Y¢N¢N¢N¢N¢N¢N¢2H2430¢ 15¢ 30¢ 187637¢ 189289¢ 15¢ 15¢ 74492¢ 75810¢ 15¢ 30¢45¢456¢39.50¢*¢ 74769¢*'
                    +'¢40.05¢*¢ 75810¢*¢ 113145¢ 113479¢ 2000¢ 2000¢RP1¢042516¢43534¢34543¢030116¢093016¢123¢123¢ ¢14C¢Y¢ 3500¢ 5000¢CASCADIA PRL-14C (EFF:10/5/15) ¢ 118645¢ 120479¢14C¢'
                    +'Y¢CASCADIA PRL-14C (EFF:10/5/15) ¢062416¢062416¢062416¢somehting¢yes¢NN¢ST¢SLEEPER TANDEM¢ 132852¢ 120479¢ 35.35¢ 4.70¢something¢ 0¢ ¢ 189289¢ ¢ 0.00¢ 104126¢ 75810¢'
                    +'123¢1¢1¢1¢1¢1¢1¢APR¢ 28316¢ 400¢ RQSTD DELV:¢ ¢LATEST DELV:¢ ¢ ¢PCT¢30¢ ¢ ¢6 ¢040317¢02.00¢75.00¢|001¢MY17 EATON FULLER IS BUILT IN PRICING ¢E¢CN¢PATTON | ¢MUST HAVE: '
                    +'¢E¢SP¢PATTON |AF3¢AF3-2CR TRACTOR ONLY WITH NO BODY UPFIT ¢E¢SP¢PATTON |A84¢A84-1GF GENERAL FREIGHT BUSINESS SEGME¢E¢SP¢PATTON |A85¢A85-005 '
                    +' LINEHAUL/LONG HAUL SERVICE ¢E¢SP¢PATTON |PMR¢PMR-998 NO ESCALATOR ¢E¢SP¢PATTON |PMT¢PMT-998 NO 2013 ENGINE ESCALATOR ¢E¢SP¢PATTON |PMU¢PMU-017 2016 '
                    +' OBD/2010 EPA/CARB/GHG17 ESC¢E¢SP¢PATTON |P63¢P63-998 NONE ¢E¢SP¢PATTON |R1X¢R1X-001 2 YEAR SERVICE CONTRACT INCLUDED¢E¢SP¢PATTON |WAI¢WAI-18A EW3: '
                    +' DD15 HWY. $0 DEDUCTIBLE. 4 ¢E¢SP¢PATTON |001¢001-233 CASCADIA 125 INCH SLEEPERCAB ¢E¢SP¢PATTON |002¢002-002 SET BACK AXLE - TRACTOR ¢E¢SP¢PATTON '
                    +' |066¢066-030 CASCADIA EVOLUTION (NO PREDICTIV¢E¢SP¢PATTON |093¢093-2B3 MICHELIN XZA3+ 275/80R22.5 14 ¢E¢SP¢PATTON |094¢094-0M1 MICHELIN XDA ENERGY '
                    +' 275/80R22.¢E¢SP¢PATTON |101¢101-2YK DETROIT DD15 14.8L 455 HP @ 16¢E¢SP¢PATTON |342¢342-419 EATON FULLER FRO-16210C TRANSM¢E¢SP¢PATTON |400¢400-1G3'
                    +' STEERTEK NXT - WT 12,500# FF1 ¢E¢SP¢PATTON |420¢420-1GR DETROIT DA-RT-40.0-4 HT 40,000¢E¢SP¢PATTON |682¢682-077 72 INCH RAISED ROOF SLEEPERCAB¢E¢SP'
                    +' ¢PATTON |829¢829-1AF 125 INCH BBC ALUMINUM CONVENTI¢E¢SP¢PATTON |99C¢99C-017 2016 ONBOARD DIAGNOSTICS/2010 EP¢E¢SP¢PATTON |001¢YEAR OVER YEAR PRICE '
                    +' WALK ¢I¢CN¢PATTON |002¢PREV SN GT8754 ¢I¢CN¢PATTON |003¢PREV CONC 2G7577 ¢I¢CN¢PATTON |004¢PREV INVOICE $113,895.00 ¢I¢CN¢PATTON |005¢SPEC CHARGES '
                    +' ($1,594.03) ¢I¢CN¢PATTON |006¢REVENUE ENHANCEMENT $100.00 ¢I¢CN¢PATTON |007¢MY17 WITH EATON TRANS $2,050.00 ¢I¢CN¢PATTON |008¢SPD OVERRIDE $64.55 '
                    +'¢I¢CN¢PATTON |009¢+/- VOLUME $0.00 ¢I¢CN¢PATTON |010¢NEW PRICE $114,515.52 ¢I¢CN¢PATTON |011¢NEW CONCESSION 39.50% ¢I¢CN¢PATTON |012¢REPLACD 2H6316 '
                    +'TO INCREASE TO 40.05% TO ¢I¢CN¢PATTON |013¢REDUCE MY17 BY $1050 APPROVED BY KL ¢I¢CN¢PATTON |001¢PREV CONC REQ# 2H2430 ¢I¢DL¢PATTON | ¢ ¢ ¢ ¢ | ¢ ¢ '
                    +'¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ ¢EOF';
                ServiceResponse.SyncResponse = ObjSyncResp;
            }
        }
        System.debug(ServiceResponse);
        
        if((ServiceResponse!= null && rcuFlag != 'ERROR') || Test.isRunningTest())
        {
            if(ServiceResponse.ErrorResponse != null)
            {
                DTNA_IntegrationLogging.IntegrationLoggingRespUpdate(IntId, ServiceResponse.ErrorResponse.ErrorDescription,'Responded with ERROR');
                rcuResponse = (ConcessionRCURequest__c.getValues('ErrorResponseMessageTemplate').Value__c + ServiceResponse.ErrorResponse.ErrorDescription);
            }
            else
            {
                try
                {
                    DTNA_IntegrationLogging.IntegrationLoggingRespUpdate(IntId, ServiceResponse.SyncResponse.IMSMessageData,'Response Received');
                    rcuResponse = ServiceResponse.SyncResponse.IMSMessageData;
                    if(rcuResponse.split('¢')[2].left(1) == 'I')
                    {
                        respMessage = ConcessionRCURequest__c.getValues('InfoSyncResponseMessageTemplate').Value__c +rcuResponse.split('¢')[2].substring(rcuResponse.split('¢')[2].indexOf(' ')+1);
                        
                        List<String> rcuRecordSplit = rcuResponse.split('\\|');
                        List<String> ConcData = rcuRecordSplit[0].split('¢');
                        System.debug('ConcData'+ConcData);
     //Deepakraj change start - format the mainframe response using Metadata (MF_Field_Mapping__mdt) based on the screen (RCU) selected.               
                    //    if (Screen == 'CSCNRCU'   || profileName== 'DTNA - FTL SALES') {
                            if (Screen == 'CSCNRCU'   || Screen == 'CSCNRRU') {
                           SYSTEM.debug('tHE LOGIC ENTER RCU MAPPING');
                           MainframeTranMapping  mainframeRequestData = new MainframeTranMapping ();
                                system.debug('The mainfram response string:::' +ConcData);
                                Map<String, object> mainframeResponseMap = mainframeRequestData.mainframeResponse(ConcData,'CSCNRCU','Inq','concession__C');
                           
                           for (String fieldName : mainframeResponseMap.keySet()){
                           obj_Conc.put(fieldName,mainframeResponseMap.get(fieldName));
                           }

                            if(!ConcData[88].isWhitespace())
                               rcu_Req_PRCP_INDC  = ConcData[88];
                           
                            if(!ConcData[95].isWhitespace())
                               rcu_apr_PRCP_INDC  = ConcData[95];

                            if(!ConcData[100].isWhitespace())
                               rcu_mkt_seg = ConcData[100];

                            if(!ConcData[101].isWhitespace())
                               rcu_mkt_desc = ConcData[101];
                         
                            if(!ConcData[103].isWhitespace())
                                rcu_prod_seg = ConcData[103];
                           
                            if(!ConcData[104].isWhitespace())
                               rcu_prod_desc = concData[104];
                                
                                
                           system.debug('the value of con 132' + ConcData[132]);
                            if(!ConcData[133].isWhitespace() && (!ConcData[132].isWhitespace()))
                            {
                            if(ConcData[132].contains('AMT'))
                            {
                                obj_Conc.Escalator_Percentage__c = null;
                                obj_Conc.Escalator_Amount__c = Decimal.valueOf(ConcData[133].normalizeSpace());
                            }
                            else if(ConcData[132].contains('PCT'))
                            {
                                obj_Conc.Escalator_Percentage__c = Decimal.valueOf(ConcData[133].normalizeSpace());
                                obj_Conc.Escalator_Amount__c = null;
                            }
                            else
                            {
                                obj_Conc.Escalator_Percentage__c = null;
                                obj_Conc.Escalator_Amount__c = null;
                            }
                        }
                        
                    }
//Deepakraj change start - format the mainframe response using Metadata (MF_Field_Mapping__mdt) based on the screen (CUA) selected.                        
             //       else if(screen == 'CSCNCUA' || ((Str_ConcessionNumer.left(1) == 'R') && (profileName== '  DTNA - FTL DOA'))) {
                        
                        else if(screen == 'CSCNCUA') {
                        SYSTEM.debug('tHE LOGIC ENTER RRU MAPPING');
                       
                         MainframeTranMapping  mainframeRequestData = new MainframeTranMapping ();
                         Map<String, object> mainframeResponseMap = mainframeRequestData.mainframeResponse(ConcData,'CSCNCUA','Inq','concession__C');
                         
                         for (String fieldName : mainframeResponseMap.keySet()){                             
                               obj_Conc.put(fieldName,mainframeResponseMap.get(fieldName));
                         }     

                         if(!ConcData[121].isWhitespace() && (!ConcData[120].isWhitespace()))
                        {
                            if(ConcData[120].contains('AMT'))
                            {
                                obj_Conc.Escalator_Percentage__c = null;
                                obj_Conc.Escalator_Amount__c = Decimal.valueOf(ConcData[121].normalizeSpace());
                            }
                            else if(ConcData[120].contains('PCT'))
                            {
                                obj_Conc.Escalator_Percentage__c = Decimal.valueOf(ConcData[121].normalizeSpace());
                                obj_Conc.Escalator_Amount__c = null;
                            }
                            else
                            {
                                obj_Conc.Escalator_Percentage__c = null;
                                obj_Conc.Escalator_Amount__c = null;
                            }
                        } 
                     } 
                        
                        
                        //objConAsIs = obj_Conc;
                        objConAsIs.LEAD_CONC_NO__c = obj_Conc.LEAD_CONC_NO__c;
                        objConAsIs.Dealer_Code__C  = obj_Conc.Dealer_Code__C;
                        objConAsIs.CONT_PRSN_NAME_42__c  = obj_Conc.CONT_PRSN_NAME_42__c;
                        objConAsIs.CUST_NAME_50__c = obj_Conc.CUST_NAME_50__c;
                        objConAsIs.CUST_ADDR1__c = obj_Conc.CUST_ADDR1__c;
                        objConAsIs.CUST_ADDR2__c = obj_Conc.CUST_ADDR2__c;
                        objConAsIs.CUST_ACCT_NO__c = obj_Conc.CUST_ACCT_NO__c;
                        objConAsIs.GLDR_INDC__c  = obj_Conc.GLDR_INDC__c;
                        objConAsIs.City__c = obj_Conc.City__c;
                        objConAsIs.ST_CD__c  = obj_Conc.ST_CD__c;
                        objConAsIs.CMPTR_CD__c  = obj_Conc.CMPTR_CD__c;
                        objConAsIs.RQST_MIN_UNITS__c = obj_Conc.RQST_MIN_UNITS__c;
                        objConAsIs.RQST_MAX_UNITS__c = obj_Conc.RQST_MAX_UNITS__c;
                        objConAsIs.TOT_MIN__c  = obj_Conc.TOT_MIN__c;
                        objConAsIs.TOT_MAX__c  = obj_Conc.TOT_MAX__c;
                        objConAsIs.APPR_MIN_UNITS__c  = obj_Conc.APPR_MIN_UNITS__c;
                        objConAsIs.APPR_MAX_UNITS__c  = obj_Conc.APPR_MAX_UNITS__c;
                        objConAsIs.RQST_CONC_PCT__c = obj_Conc.RQST_CONC_PCT__c;
                        objConAsIs.RQST_CONC_AMT__c = obj_Conc.RQST_CONC_AMT__c;
                        objConAsIs.DATE_DELV_RQST__c = obj_Conc.DATE_DELV_RQST__c;
                        objConAsIs.DATE_LATEST_ACCEPT__c = obj_Conc.DATE_LATEST_ACCEPT__c;
                        objConAsIs.REQ_PRICELVL__c = obj_Conc.REQ_PRICELVL__c;
                        objConAsIs.REQ_PRCP_INDC__c  = obj_Conc.REQ_PRCP_INDC__c;
                        objConAsIs.APR_PRICELVL__c = obj_Conc.APR_PRICELVL__c;
                        objConAsIs.APR_PRCP_INDC__c  = obj_Conc.APR_PRCP_INDC__c;
                        objConAsIs.ACCTTYPE__c = obj_Conc.ACCTTYPE__c;
                        objConAsIs.Approval_Comments__c = obj_Conc.Approval_Comments__c ;
                        if(lstConc.size() == 0 && obj_Conc.Id == null)
                            insert obj_Conc;
                        ConcessionId = obj_Conc.Id;
                        if(!Approval.isLocked(obj_Conc.Id) && !Test.isRunningTest())
                         
                        {
                            update(obj_Conc);
                            
    //Deepakraj change start - to protect the below fields from update.                       
                            if(screen == 'CSCNRCU') {
                     
                                    obj_Conc.REQ_PRCP_INDC__c  =  rcu_Req_PRCP_INDC;
                                    obj_conc.APR_PRCP_INDC__c = rcu_apr_PRCP_INDC;
                                    obj_conc.CONCMCDB_MARKET_SEG__c = rcu_mkt_seg;
                                    obj_Conc.MKTDESC__c = rcu_mkt_desc;
                                    obj_Conc.SEGTYPE__c = rcu_prod_seg;
                                    obj_Conc.SEGDESC__c = rcu_prod_desc;
                                    }  
    //Deepakraj change end                              
                        }
                        else
                        {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,ConcessionRCURequest__c.getValues('InfoRecordLockedMessage').Value__c ));
                        }
                        
                        Integer i=-1;
                        Comment__c ObjComment = new Comment__c();
                        list_Comment.clear();
                        for(String strComment :rcuRecordSplit)
                        {
                            if(i!=-1)
                            {
                                List<String> ComtData = strComment.split('¢');
                                if(!ComtData[0].isWhitespace() || !ComtData[1].isWhitespace())
                                {
                                    ObjComment = new Comment__c();
                                    ObjComment.Sequence__c = ComtData[0];
                                    ObjComment.Notes__c = ComtData[1];
                                    if(ComtData[2] == 'E')
                                    {
                                        ObjComment.SLS_VIEW_C__c = 'EX';
                                    }
                                    else if(ComtData[2] == 'I')
                                    {
                                        ObjComment.SLS_VIEW_C__c = 'IN';
                                    }
                                    else
                                    {
                                        ObjComment.SLS_VIEW_C__c = ComtData[2];
                                    }
                                    ObjComment.SLS_GRP_CD__c = ComtData[3];
                                    ObjComment.Update_By__c = ComtData[4];
                                    ObjComment.ExternalID__c = Str_ConcessionNumer + '-' + ComtData[3]+ '-' + ComtData[2] + ComtData[0];
                                    ObjComment.Concession__c = ApexPages.currentPage().getParameters().get('id');
                                    list_Comment.add(ObjComment);
                                }
                            }
                            i++;
                        }
                     //   upsert list_Comment ExternalID__c;
                        rcuResponse = rcuResponse + '\n' + i ; 
                        // if(ApexPages.currentPage().getParameters().get('MessageSuccessfull') == null){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,respMessage ));
                        // }
                        
                    }
                    else if(rcuResponse.split('¢')[2].left(1) == 'E')
                    {
                        respMessage = ConcessionRCURequest__c.getValues('ErrorSyncResponseMessageTemplate').Value__c + ' ' + rcuResponse.split('¢')[2].substring(rcuResponse.split('¢')[2].indexOf(' ')+1);
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,respMessage ));
                        // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,respMessage ));
                        
                    }
                    else
                    {
                        respMessage = ConcessionRCURequest__c.getValues('OtherSyncResponseMessageTemplate').Value__c + ' ' + rcuResponse.split('¢')[2].substring(rcuResponse.split('¢')[2].indexOf(' ')+1);
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,respMessage ));    
                    }
                    
                    //rcuResponse = ServiceResponse.SyncResponse.IMSMessageData;
                }
                catch(Exception e)
                {
                    System.debug(e);
                    rcuResponse+=rcuResponse+e+e.getStackTraceString();
                    respMessage = ConcessionRCURequest__c.getValues('ExceptionMessageTemplate').Value__c + ' ' + e.getMessage();
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,respMessage ));
                }                    
            }
        }
        System.Debug('output'+rcuResponse);
    }
    public String getOutput()
    {
        return (respMessage + '<br>' + rcuResponse);
    }
    // exp approval HN
    public List<Schema.FieldSetMember> getFields() {
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        if(profileName=='DTNA - WST Sales'){
            
            return SObjectType.Concession__c.FieldSets.Exception_Approval.getFields();
        }else   if(profileName=='DTNA - FTL Sales'){
            return SObjectType.Concession__c.FieldSets.Exception_Approval_FTL.getFields();
        }else{
            return SObjectType.Concession__c.FieldSets.Exception_Approval.getFields();
        }
    }
    private Concession__c  getConcessionList(String Concessionid) {
        
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id,name,Deal_Comments__c,WS_Only__c  FROM Concession__c  where id= :Concessionid ';
        return Database.query(query);
    }
    
    public void saveRecord()
    {
        if(obj_Conc!=null)
        {
            system.debug('ObjectConcession model year'+obj_Conc.Model_Year__c);
            try
            {
                update obj_Conc;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Saved successfully!'));
            }
            catch(Exception e)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
            }
        }
    }
    
    public PageReference Submitforapproval() 
    {
        saveRecord();
        system.debug('i am inside submit approval');
        try
        {       
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();  
            req1.setComments('Submitted for Approval');
            req1.setObjectId(obj_Conc.Id);
            Approval.ProcessResult result = Approval.process(req1); 
            if(result.isSuccess())
            {
                isSubmitForApproval = false;
                isApprovalrecall=true;
                obj_Conc.In_Approval_Process__c=true;
                saveRecord();
                return null;
            }
        }
        Catch(Exception e)
        {
            system.debug('i am inside exception'+e.getCause());  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
        }   
        return null;
    }
    
    public PageReference Recallapprovalrequest() 
    {               
        saveRecord();                
        List<ProcessInstanceWorkitem> piwi = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: obj_Conc.Id];
        system.debug('i aminside Recallapprovalrequest');
        try
        {
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setAction('Removed');
            req.setcomments('Recalled');
            if(!piwi.isEmpty())
            {
                system.debug('i aminside if 741');
                req.setWorkitemId(piwi.get(0).Id);
            }
            Approval.ProcessResult result=  Approval.process(req,false);
            system.debug('12345'+result.isSuccess());  
            if(result.isSuccess())
            {
                isSubmitForApproval = True;
                isApprovalrecall=false;
                obj_Conc.In_Approval_Process__c=false;
                saveRecord();
                return null;
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'record already recalled or you do not have privileges to recall'));
            }
        }
        Catch(Exception e)
        {
            system.debug('i am inside exception'+e.getCause());  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
        }
        return null;
    }
    
    
    public PageReference NewComment()
    {
        Comment__c ObjComment = new Comment__c();
        ObjComment.Concession__c = obj_Conc.Id;
        ObjComment.SLS_VIEW_C__c = 'IN';
        list_Comment_Copy.addAll(list_Comment);
        list_Comment.clear();
        list_Comment.add(ObjComment);
        list_Comment.addAll(list_Comment_Copy);
        return null;
    }
    
    public void SaveComment()
    {
        Comment__c ObjComment = new Comment__c();
        iLoop=0;
        try
        {
            if((list_Comment[0].ExternalID__c == null || list_Comment[0].ExternalID__c == '') && (ProcessComment == null || ProcessComment == ''))
            {
                SubmitCommentUpdate(list_Comment[0].Notes__c + '¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢' + list_Comment[0].SLS_VIEW_C__c + '¢EOF'); 
                list_Comment[0].SLS_GRP_CD__c = 'RG';
                insert list_Comment[0];
            }
            else
            {
                while(iLoop < list_Comment.size())
                {
                    if(list_Comment[iLoop].ExternalID__c == ProcessComment)
                    {
                        ObjComment = list_Comment[iLoop];    
                        SubmitCommentUpdate(ObjComment.Notes__c + '¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢U¢' + ObjComment.Sequence__c + '¢' + ObjComment.SLS_VIEW_C__c + '¢EOF'); 
                        update ObjComment;
                    }
                    iLoop++;
                }
            }
        }
        catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage() ));
            System.debug(e);
        }
    }
    
    public void DeleteComment()
    {
        Comment__c ObjComment = new Comment__c();
        iLoop=0;
        while(iLoop < list_Comment.size())
        {
            if(list_Comment[iLoop].ExternalID__c == ProcessComment)
            {
                ObjComment = list_Comment[iLoop];
                SubmitCommentUpdate(ObjComment.Notes__c + '¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢¢D¢' + ObjComment.Sequence__c + '¢' + ObjComment.SLS_VIEW_C__c + '¢EOF'); 
                Delete ObjComment;
                list_Comment.remove(iLoop);
            }
            iLoop++;
        }
    }
    
    public void SubmitCommentUpdate(String ActParam)
    {
        rcuResponse+='RCURequest::U-Comment';
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
        if(Str_ConcessionNumer.left(1) == 'R')
            IMSInfo.TransactionName='CSCNRRU';
        else
            IMSInfo.TransactionName=ConcessionRCURequest__c.getValues('TransactionName').Value__c;
        
        IMSInfo.MessageData='    ¢  XXC¢' + Obj_User.Mainframe_ID__c + '¢' + Str_ConcessionNumer + '¢' + obj_Conc.CONC_STATUS_CD__c + '¢';
        IMSInfo.MessageData += ActParam;
        
        iibIms_ConcessionApprovalRequest.ServiceResponseMsg_element ServiceResponse =
            new iibIms_ConcessionApprovalRequest.ServiceResponseMsg_element();
        iibImsConcessionRequest.IIB_generic_internet_soap11 proxyClass = 
            new iibImsConcessionRequest.IIB_generic_internet_soap11();
        proxyClass.clientCertName_x=ConcessionRCURequest__c.getValues('clientCertName_x').Value__c;
        proxyClass.clientCertPasswd_x=ConcessionRCURequest__c.getValues('clientCertPasswd_x').Value__c;
        
        rcuResponse+=IMSInfo.MessageData;
        
        try
        {
            ServiceResponse = proxyClass.ExecTransaction(ClientInfo,IMSInfo);
            DTNA_IntegrationLogging.IntegrationLoggingReqInsert( IMSInfo.TransactionName,'IMS-Mainframe','UpdateNote',IntId, IMSInfo.TransactionName+IMSInfo.MessageData,'Requested');
            System.debug(' serviceresponse______ ' + ServiceResponse );
        }
        Catch(Exception e)
        {
            System.debug(e);
            DTNA_IntegrationLogging.IntegrationLoggingReqInsert( IMSInfo.TransactionName,'IMS-Mainframe','UpdateNote',IntId,IMSInfo.MessageData,'Requested');
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
                }
                catch(Exception e)
                {
                    System.debug(e);
                    rcuResponse+=rcuResponse+e+e.getStackTraceString();
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage() ));
                }
                //LoadLiveConcessionData();                  
            }
        }
    }
}