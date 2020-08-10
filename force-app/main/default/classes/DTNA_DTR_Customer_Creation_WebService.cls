global class DTNA_DTR_Customer_Creation_WebService
        {
                       
            webService static string DTNA_DTR_Customer_Creation(string jsonstring)
            { 
                //variable and object initialization
                Map<String, Object> results =(Map<String, Object>)JSON.deserializeUntyped(jsonstring); 
                List<Object> lstContacts = (List<Object>)results.get('Contact');           
                Object[] aryContact = (Object[]) results.get('Contact');
                integer count=0;
                string [] arrAccountResponse;                
                String [] arrContactResponse;
                String [] arrPrivateActivityResponse;
                String ContactResponse='';
                String PrivateActivityResponse='';
                String JSONResponse='';
                String ContactJSONResponse='';
                String ContactJSONResponse1='';
                String ContactJSONResponse2='';
                String finalContactJSONResponse='';
                String PrivateActivityJSONResponse='';
                String PrivateActivityJSONResponse1='';
                String PrivateActivityJSONResponse2='';
                String finalPrivateActivityJSONResponse='';
                String AccountJSONResponse='';
                String strDTRRelatedRecord='';
                strDTRRelatedRecord='DTR'+ '_'+string.valueof(datetime.now());
                strDTRRelatedRecord=strDTRRelatedRecord.replace('-', '');
                strDTRRelatedRecord=strDTRRelatedRecord.replace(':', '');
                strDTRRelatedRecord=strDTRRelatedRecord.replace(' ', '');
                System.debug('DTRRelatedRecord' + strDTRRelatedRecord);
                //Start Log Integration logic
                DTNA_IntegrationLogging.IntegrationLoggingReqInsert('DTR Data Insertion', 'DTR Insight', 'Insert', strDTRRelatedRecord, jsonstring , 'Requested');
                String soqlQuery = 'SELECT BusinessFunction__c, ExternalSystem__c, Method__c, Status__c, RequestMessage__c, Response_Message__c FROM IntegrationLog__c WHERE RelatedRecord__c=\'' + strDTRRelatedRecord + '\'';
                System.debug('soqlQuery' + soqlQuery);
                IntegrationLog__c IntegrationLogToUpdate = database.query(soqlQuery);               
                //End Log Integration logic
                //Start Get the Account Response and Based on Successful Account Creation/Updation, Create Contacts and Tasks.
                arrAccountResponse=parseAccountJsonString(jsonstring).split('~');
                if (arrAccountResponse.size()>1)
                {
                    if (arrAccountResponse[1]!='')
                    {
                        AccountJSONResponse='{'+
                                            '\'Account\':[' +
                                            '{' +
                                             ''+ arrAccountResponse[0]+arrAccountResponse[1]+'' +
                                             '}]';
                       
                        ContactResponse=parseContactJsonString(jsonstring,arrAccountResponse[1],arrAccountResponse[2]);//Get the Contact Response
                        PrivateActivityResponse=parsePrivateActivityJsonString(jsonstring,arrAccountResponse[1]);//Get the Tasks Response
                        If(ContactResponse!='')
                        {
                          arrContactResponse=ContactResponse.split('~');
                            if (arrContactResponse.size()>0)
                            {                    
                                ContactJSONResponse1=',\'Contacts\':[';
                                for(integer i=0;i<=arrContactResponse.size()-1;i++)
                                {
                                    ContactJSONResponse='{' +
                                        ''+ arrContactResponse[i]+'' +
                                        '}';                                    
                                    finalContactJSONResponse=ContactJSONResponse;
                                }
                                if (PrivateActivityResponse!='' && PrivateActivityResponse !=null)
                                {
                                ContactJSONResponse2='],';
                                }
                                else
                                {
                                    ContactJSONResponse2=']}';  
                                }
                                ContactJSONResponse=ContactJSONResponse1+finalContactJSONResponse+ContactJSONResponse2;                                
                            }
                        }
                        else
                        {
                            ContactJSONResponse='';
                        }
                        If(PrivateActivityResponse!='')
                        {
                         arrPrivateActivityResponse=PrivateActivityResponse.split('~');
                            if (arrPrivateActivityResponse.size()>0)
                            {
                                PrivateActivityJSONResponse1='\'PrivateActivity\':[';
                                for(integer i=0;i<=arrPrivateActivityResponse.size()-1;i++)
                                {
                                    PrivateActivityJSONResponse='{' +
                                                         ''+ arrPrivateActivityResponse[i]+'' +
                                                         '}';
                                   
                                        finalPrivateActivityJSONResponse=PrivateActivityJSONResponse;                                   
                                }
                                PrivateActivityJSONResponse2=']}';
                                PrivateActivityJSONResponse=PrivateActivityJSONResponse1+finalPrivateActivityJSONResponse+PrivateActivityJSONResponse2;                            
                            }
                        }
                        else
                        {
                            PrivateActivityJSONResponse='';
                        }
                        if (ContactJSONResponse=='' && PrivateActivityJSONResponse=='')
                        {
                            AccountJSONResponse=AccountJSONResponse +'}';
                            DTNA_IntegrationLogging.IntegrationLoggingRespUpdate(strDTRRelatedRecord, AccountJSONResponse, 'Processed');
                            IntegrationLogToUpdate = database.query(soqlQuery);
                            return AccountJSONResponse;
                        }
                        else
                        {
                          DTNA_IntegrationLogging.IntegrationLoggingRespUpdate(strDTRRelatedRecord, AccountJSONResponse + ContactJSONResponse + PrivateActivityJSONResponse, 'Processed');
                          IntegrationLogToUpdate = database.query(soqlQuery);
                          return AccountJSONResponse +ContactJSONResponse+PrivateActivityJSONResponse;                      
                        }
                    }                    
                }
                else
                {
                    JSONResponse='{'+
                                            '\'Account\':[' +
                                            '{' +
                                             ''+ arrAccountResponse[0]+'' +
                                             '}]'+
                                        '}';
                   DTNA_IntegrationLogging.IntegrationLoggingRespUpdate(strDTRRelatedRecord, JSONResponse, 'Processed');
                   IntegrationLogToUpdate = database.query(soqlQuery);
                   return JSONResponse;  
                }
                //End Get the Account Response and Based on Successful Account Creation/Updation, Create Contacts and Tasks.
                return JSONResponse;                
            }
            //Get User Id Based on DTNAConnectId
            Public static string GetUserId(string jsonstring)
            {
               string strDTNAConnectId='';
               string strUserId='';
                Map<String, Object> results =(Map<String, Object>)JSON.deserializeUntyped(jsonstring);                            
                List<Object> lstPvtActivities = (List<Object>)results.get('PrivateActivity'); 
                integer Successrowcount=0;
                string response='';
                Object[] aryPrivateActivity = (Object[]) results.get('PrivateActivity');             
                ////System.debug('PP:' + aryPrivateActivity);
                if(aryPrivateActivity!=null)
                {
                	for (Object PrivateActivities : lstPvtActivities) 
                    {
                        // now get attributes for this PrivateActivityobj.
                    	Map<String, Object> PrivateActivityAttributes = (Map<String, Object>)PrivateActivities;
                        for (String attributeName : PrivateActivityAttributes.keyset()) 
                         {
                             try
                             {                        
    
                            if (attributeName=='DTNAConnectId')
                                {                                                               
                                    strDTNAConnectId=(String)PrivateActivityAttributes.get(attributeName);
                                    strUserId = [select Id from User where FederationIdentifier = :strDTNAConnectId][0].Id;
                                    //PrivateActivityobj.owner__c=strUserId;
                                }
                             }
                             Catch(Exception ex)
                             {
                                 strUserId='';
                             }
                         }
                    }					
                }
                return strUserId;
            }
            
            //Get the User Profile Name based on DTNAConnectId
            Public static string GetUserProfile(string jsonstring)
            {
               string strDTNAConnectId='';
               string strUserProfile='';
                Map<String, Object> results =(Map<String, Object>)JSON.deserializeUntyped(jsonstring);                            
                List<Object> lstPvtActivities = (List<Object>)results.get('PrivateActivity'); 
                integer Successrowcount=0;
                string response='';
                Object[] aryPrivateActivity = (Object[]) results.get('PrivateActivity');             
                ////System.debug('PP:' + aryPrivateActivity);
                if(aryPrivateActivity!=null)
                {
                	for (Object PrivateActivities : lstPvtActivities) 
                    {
                        // now get attributes for this PrivateActivityobj.
                    	Map<String, Object> PrivateActivityAttributes = (Map<String, Object>)PrivateActivities;
                        for (String attributeName : PrivateActivityAttributes.keyset()) 
                         {
                             try
                             {                        
    
                            if (attributeName=='DTNAConnectId')
                                {                                                               
                                    strDTNAConnectId=(String)PrivateActivityAttributes.get(attributeName);
                                    //strUserProfile = [select profile.name from User where FederationIdentifier = :strDTNAConnectId][0].Id;
                                    List<User> ListUserProfile=[select profile.name from User where FederationIdentifier = :strDTNAConnectId];
                                    system.debug('ListUserProfile' + ListUserProfile.size());
                                    if(ListUserProfile!=null && ListUserProfile.size()>0)
                                    {
                                        strUserProfile=ListUserProfile[0].profile.name;
                                    }
                                    else
                                    {
                                        strUserProfile='';
                                    }
                                    System.debug('strUserProfileCall:' + strUserProfile);
                                }
                             }
                             Catch(Exception ex)
                             {
                                 strUserProfile='';
                             }
                         }
                    }					
                }
                return strUserProfile;
            }
            //Generate the Account OwnerShip Based on UserId and AccountId
            Public Static string getAccountPrivateOwnershipId(string UserId,string strInsightCompanyID)
            {   
                
                string AccountId='';
                string PrivateOwnershipId=''; 
                string AllPrivateOwnershipId='';
                string [] arrAllPrivateOwnershipId;
                //string [] arrAllPrivateOwnershipId1;
                Boolean isPrivateOwnershipAvail=false;
                Boolean isPrivateOwnershipNull=false;
                string strPrivateOwnershipList1='';
                System.debug('strInsightCompanyID:' + strInsightCompanyID);
                //finalQuery='select Private_Ownership_List1__C,Private_Ownership_List2__C,Private_Ownership_List3__C,Private_Ownership_List4__C,Private_Ownership_List5__C from Account where Mainframe_ID__c =\'' + strInsightCompanyID + '\'';            
                List<Account> lstAccount=[select Id,Private_Ownership_List1__C,Private_Ownership_List2__C,Private_Ownership_List3__C,Private_Ownership_List4__C,Private_Ownership_List5__C from Account where Mainframe_ID__c =:strInsightCompanyID];
                //Account[] accts = [SELECT Id, Name FROM Account LIMIT 1];                     
                 System.debug('TSTS122:' + lstAccount.size());
                 if(lstAccount!=null && lstAccount.size()>0)
                    {  
                        System.debug('kk:' + lstAccount.size());
                        if(lstAccount[0].Private_Ownership_List1__C!=null && lstAccount[0].Private_Ownership_List1__C!='')
                        {
                            isPrivateOwnershipNull=false;
                        }
                        else
                        {
                            isPrivateOwnershipNull=true;
                        }
                        
                        if (!isPrivateOwnershipNull)
                        { 
                            if (lstAccount[0].Private_Ownership_List1__C!=null && lstAccount[0].Private_Ownership_List1__C!='')
                            {
                            	AllPrivateOwnershipId=lstAccount[0].Private_Ownership_List1__C;
                            }
                            if (lstAccount[0].Private_Ownership_List2__C!=null && lstAccount[0].Private_Ownership_List2__C!='')
                            {
                                AllPrivateOwnershipId=AllPrivateOwnershipId+ lstAccount[0].Private_Ownership_List2__C;
                            }
                            if (lstAccount[0].Private_Ownership_List3__C!=null && lstAccount[0].Private_Ownership_List3__C!='')
                            {
                                AllPrivateOwnershipId=AllPrivateOwnershipId+ lstAccount[0].Private_Ownership_List3__C;
                            }
                            if (lstAccount[0].Private_Ownership_List4__C!=null && lstAccount[0].Private_Ownership_List4__C!='')
                            {
                                AllPrivateOwnershipId=AllPrivateOwnershipId+ lstAccount[0].Private_Ownership_List4__C;
                            }
                            if (lstAccount[0].Private_Ownership_List5__C!=null && lstAccount[0].Private_Ownership_List5__C!='')
                            {
                                AllPrivateOwnershipId=AllPrivateOwnershipId+ lstAccount[0].Private_Ownership_List5__C;
                            }
                            System.debug('UserIdSales: '+ UserId.left(15));
                            arrAllPrivateOwnershipId=AllPrivateOwnershipId.split(',');
                            for (Integer J=0;j<=(arrAllPrivateOwnershipId.size())-1;j++)
                            {
                                if (UserId.left(15)==arrAllPrivateOwnershipId[j].left(15))
                                {
                                    isPrivateOwnershipAvail=true;
                                    break;
                                }
                            }
                        }
                        else
                        {
                            //System.debug('My ID WOWW : '+ UserId.left(15));
                            PrivateOwnershipId=UserId.left(15) + ',';
                            return PrivateOwnershipId;
                        }
                        
                                                
                        System.debug('AllPrivateOwnershipId:'+AllPrivateOwnershipId);
                        ////System.debug('My ID Field'+ListAccount[0].Private_Ownership_List1__C);
                        if (!isPrivateOwnershipAvail)
                        {                          
                                PrivateOwnershipId=AllPrivateOwnershipId + UserId.left(15)+ ',' ;
                                return PrivateOwnershipId;                           
                        }
                        else
                        {
                            PrivateOwnershipId=AllPrivateOwnershipId;
                            return PrivateOwnershipId;
                        }
                    }
                    
                else
                {
                    System.debug('TSTS1:' + lstAccount.size());
                    PrivateOwnershipId=UserId.left(15) + ',';
                    return PrivateOwnershipId;
                }
                //}
                
                return PrivateOwnershipId;
            }
            //Generate the Contact OwnerShip Based on UserId and AccountId and ContactId
            Public Static string getContactPrivateOwnershipId(string UserId,string strInsightContactID,string strAccountId)
            {
                string ContactId='';
                string PrivateOwnershipId=''; 
                string AllPrivateOwnershipId='';
                string [] arrAllPrivateOwnershipId;
                //string [] arrAllPrivateOwnershipId1;
                Boolean isPrivateOwnershipAvail=false;
                Boolean isPrivateOwnershipNull=false;                
                List<Contact> ListContact=[select Id,Name,Private_Ownership_List1__C,Private_Ownership_List2__C,Private_Ownership_List3__C,Private_Ownership_List4__C,Private_Ownership_List5__C from Contact where Accountid=:strAccountId and Mainframe_ID__c=:strInsightContactID];
                System.debug('ListContact : '+ListContact.size());
                if(ListContact!=null && ListContact.size()>0)
                    {
                         //use your Field:ListProduct[0].Description here
                        System.debug('My ID Field : '+UserId.left(15));
                        //PrivateOwnershipId=UserId.left(15) + ',';
                        if(ListContact[0].Private_Ownership_List1__C!=null && ListContact[0].Private_Ownership_List1__C!='')
                        {
                            isPrivateOwnershipNull=false;
                        }
                        else
                        {
                           isPrivateOwnershipNull=true; 
                        }
                        
                        if (!isPrivateOwnershipNull)
                        {
                            ////System.debug('My ID WOW : '+ UserId.left(15));
                            //AllPrivateOwnershipId=ListContact[0].Private_Ownership_List1__C + ',' + ListContact[0].Private_Ownership_List2__C + ',' + ListAccount[0].Private_Ownership_List3__C + ',' + ListAccount[0].Private_Ownership_List4__C + ',' + ListAccount[0].Private_Ownership_List5__C;
                            if (ListContact[0].Private_Ownership_List1__C!=null && ListContact[0].Private_Ownership_List1__C!='')
                            {
                            	AllPrivateOwnershipId=ListContact[0].Private_Ownership_List1__C;
                            }
                            if (ListContact[0].Private_Ownership_List2__C!=null && ListContact[0].Private_Ownership_List2__C!='')
                            {
                                AllPrivateOwnershipId=AllPrivateOwnershipId+ ListContact[0].Private_Ownership_List2__C;
                            }
                            if (ListContact[0].Private_Ownership_List3__C!=null && ListContact[0].Private_Ownership_List3__C!='')
                            {
                                AllPrivateOwnershipId=AllPrivateOwnershipId+ ListContact[0].Private_Ownership_List3__C;
                            }
                            if (ListContact[0].Private_Ownership_List4__C!=null && ListContact[0].Private_Ownership_List4__C!='')
                            {
                                AllPrivateOwnershipId=AllPrivateOwnershipId+ ListContact[0].Private_Ownership_List4__C;
                            }
                            if (ListContact[0].Private_Ownership_List5__C!=null && ListContact[0].Private_Ownership_List5__C!='')
                            {
                                AllPrivateOwnershipId=AllPrivateOwnershipId+ ListContact[0].Private_Ownership_List5__C;
                            }
                            System.debug('ContactprivateOwnership : '+ AllPrivateOwnershipId);
                            arrAllPrivateOwnershipId=AllPrivateOwnershipId.split(',');
                            for (Integer J=0;j<=(arrAllPrivateOwnershipId.size())-1;j++)
                            {
                                if (UserId.left(15)==arrAllPrivateOwnershipId[j].left(15))
                                {
                                    isPrivateOwnershipAvail=true;
                                    break;
                                }
                            }
                        }
                        else
                        {
                            PrivateOwnershipId=UserId.left(15) + ',';
                            return PrivateOwnershipId;
                        }
                        if (!isPrivateOwnershipAvail)
                        {                          
                                PrivateOwnershipId=AllPrivateOwnershipId + UserId.left(15)+ ',' ;
                                return PrivateOwnershipId;                           
                        }
                        else
                        {
                            PrivateOwnershipId=AllPrivateOwnershipId;
                            return PrivateOwnershipId;
                        }
                }
                else
                {
                    PrivateOwnershipId=UserId.left(15) + ',';
                    return PrivateOwnershipId;
                }
                return PrivateOwnershipId;
            }
            //Generate Account Response
            public static string parseAccountJsonString(string jsonstring)
                  {
                        string response='';
                        Map<String, Object> results =(Map<String, Object>)JSON.deserializeUntyped(jsonstring);                        
                        List<Object> lstAccounts = (List<Object>)results.get('Account');           
                        Object[] aryAccount = (Object[]) results.get('Account');
                        for (Object Account : lstAccounts) 
                        {
                         // now get attributes for this Account.
                         Map<String, Object> AccountAttributes = (Map<String, Object>)Account;
                         // now loop through our Account attributes.            
                        Account acctobj=new Account();
                        List<Account> lstAccount=new List<Account>();
                         string ShippingStreet;
                         string ShippingStreet1;
                         string ShippingStreet2;
                         string strInsightCompanyID='';
                         string strUserId='';
                         string strPrivateOwnerShipId='';
                         string [] arrAllPrivateOwnershipId;
                         string strPrivateOwnerShipId1='';
                         string strPrivateOwnerShipId2='';
                         string strPrivateOwnerShipId3='';
                         string strPrivateOwnerShipId4='';
                         string strPrivateOwnerShipId5='';
                         try
                          {
                         for (String attributeName : AccountAttributes.keyset()) 
                         {
                            if (attributeName=='CompanyName'){
                                acctobj.Name=(String)AccountAttributes.get(attributeName);}  
                            if (attributeName=='InsightCompanyID')
                            {
                                acctobj.Mainframe_ID__c=(String)AccountAttributes.get(attributeName);
                                strInsightCompanyID=(String)AccountAttributes.get(attributeName);
                            }  
                            if (attributeName=='Phone1')
                            {
                                acctobj.Phone=(String)AccountAttributes.get(attributeName);
                            } 
                            if (attributeName=='Fax')
                            {
                                acctobj.Fax=(String)AccountAttributes.get(attributeName);
                            }
                            if (attributeName=='Address1')
                            {
                                ShippingStreet1=(String)AccountAttributes.get(attributeName);
                            } 
                            if (attributeName=='Address2')
                            {
                                ShippingStreet2=(String)AccountAttributes.get(attributeName);
                            }
                            acctobj.ShippingStreet=ShippingStreet1+ShippingStreet2;
                             
                            if (attributeName=='City')
                            {
                                acctobj.ShippingCity=(String)AccountAttributes.get(attributeName);
                            } 
                            if (attributeName=='State')
                            {
                                acctobj.ShippingState=(String)AccountAttributes.get(attributeName);
                            }
                            if (attributeName=='Country')
                            {
                                acctobj.ShippingCountry=(String)AccountAttributes.get(attributeName);
                            }
                            if (attributeName=='ZIP')
                            {
                                acctobj.ShippingPostalCode=(String)AccountAttributes.get(attributeName);
                            }
                            if (attributeName=='County')
                            {
                                acctobj.County__c=(String)AccountAttributes.get(attributeName);
                            }
                            if (attributeName=='FleetSize')
                            {
                                acctobj.Fleet_Size__c=(String)AccountAttributes.get(attributeName);
                            }
                            if (attributeName=='URL')
                            {
                                acctobj.Website=(String)AccountAttributes.get(attributeName);
                            }
                            if (attributeName=='Description')
                            {
                                acctobj.Description=(String)AccountAttributes.get(attributeName);
                            }
                            if (attributeName=='Source')
                            {
                                acctobj.Source__c=(String)AccountAttributes.get(attributeName);
                            }
                            Id AccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect/Customer').getRecordTypeId();
                            acctobj.RecordTypeId=AccountRecordType; 
                            
                         }
                        }
                        Catch(Exception ex)
                        {
                           response= 'StatusCode: 101,Status: Failure, Message : Account cannot be created:' + ex;
                           return response;     
                        }
                            if (strInsightCompanyID!=null && strInsightCompanyID!='')
                            {
                                
                                strUserId=GetUserId(jsonstring);
                                System.debug('strUserId:'+strUserId);
                                strPrivateOwnerShipId=getAccountPrivateOwnershipId(strUserId,strInsightCompanyID);                                
                                
                                System.debug('strPrivateOwnerShipId:'+strPrivateOwnerShipId);
                                arrAllPrivateOwnershipId=strPrivateOwnerShipId.split(',');
                                //System.debug('arrAllPrivateOwnershipId:'+arrAllPrivateOwnershipId.size());
                                for(integer k=0;k<=(arrAllPrivateOwnershipId.size())-1;k++)
                                {  
                                   if (k<=14)
                                   {
                                    if (strPrivateOwnerShipId1=='')
                                    {
                                    	strPrivateOwnerShipId1=arrAllPrivateOwnershipId[k]+',';
                                        System.debug('strPrivateOwnerShipId11:'+strPrivateOwnerShipId1);
                                    }
                                    else
                                    {
                                        strPrivateOwnerShipId1=strPrivateOwnerShipId1 + arrAllPrivateOwnershipId[k]+',';
                                        System.debug('strPrivateOwnerShipId12:'+strPrivateOwnerShipId1);
                                    }
                                   }
                                   if (k>14 && k<=29)
                                    {
                                        if (strPrivateOwnerShipId2=='')
                                        {
                                            strPrivateOwnerShipId2=arrAllPrivateOwnershipId[k]+',';
                                            System.debug('strPrivateOwnerShipId21:'+strPrivateOwnerShipId2);
                                        }
                                        else
                                        {
                                            strPrivateOwnerShipId2=strPrivateOwnerShipId2 + arrAllPrivateOwnershipId[k]+',';
                                            System.debug('strPrivateOwnerShipId22:'+strPrivateOwnerShipId2);
                                        }
                                        
                                    }
                                    if (k>29 && k<=44)
                                    {
                                        if (strPrivateOwnerShipId3=='')
                                        {
                                            strPrivateOwnerShipId3=arrAllPrivateOwnershipId[k]+',';
                                            //System.debug('strPrivateOwnerShipId21:'+strPrivateOwnerShipId3);
                                        }
                                        else
                                        {
                                            strPrivateOwnerShipId3=strPrivateOwnerShipId3 + arrAllPrivateOwnershipId[k]+',';
                                            //System.debug('strPrivateOwnerShipId22:'+strPrivateOwnerShipId3);
                                        }
                                        
                                    }
                                    if (k>44 && k<=59)
                                    {
                                        if (strPrivateOwnerShipId4=='')
                                        {
                                            strPrivateOwnerShipId4=arrAllPrivateOwnershipId[k]+',';
                                            //System.debug('strPrivateOwnerShipId21:'+strPrivateOwnerShipId4);
                                        }
                                        else
                                        {
                                            strPrivateOwnerShipId4=strPrivateOwnerShipId4 + arrAllPrivateOwnershipId[k]+',';
                                            //System.debug('strPrivateOwnerShipId22:'+strPrivateOwnerShipId4);
                                        }
                                        
                                    }
                                    if (k>59 && k<=74)
                                    {
                                        if (strPrivateOwnerShipId5=='')
                                        {
                                            strPrivateOwnerShipId5=arrAllPrivateOwnershipId[k]+',';
                                            //System.debug('strPrivateOwnerShipId21:'+strPrivateOwnerShipId5);
                                        }
                                        else
                                        {
                                            strPrivateOwnerShipId5=strPrivateOwnerShipId5 + arrAllPrivateOwnershipId[k]+',';
                                            //System.debug('strPrivateOwnerShipId22:'+strPrivateOwnerShipId5);
                                        }                                        
                                    }                                   
                                    
                                }                               
                                acctobj.Private_Ownership_List1__c=strPrivateOwnerShipId1;
                                acctobj.Private_Ownership_List2__c=strPrivateOwnerShipId2;
                                acctobj.Private_Ownership_List3__c=strPrivateOwnerShipId3;
                                acctobj.Private_Ownership_List4__c=strPrivateOwnerShipId4;
                                acctobj.Private_Ownership_List5__c=strPrivateOwnerShipId5;
                                lstAccount.add(acctobj);                            	
                                if(lstAccount!=null && lstAccount.size()>0)
                                 {
                                 System.debug('strPrivateOwnerShipId14:'+lstAccount.size());
                                 try
                                     {
                                        List<Account> ListExistAccount=[select Id from Account where Mainframe_ID__c = :strInsightCompanyID];
                                        System.debug('strPrivateOwnerShipId15:'+ListExistAccount.size());
                                        if(ListExistAccount!=null && ListExistAccount.size()>0)
                                        {
                                            upsert lstAccount Mainframe_ID__c;
                                            response='StatusCode: 102,Status: Success, Message : Account Updated Successfully:'+'~'+ acctobj.Id +'~'+strInsightCompanyID;
                                            System.debug('strPrivateOwnerShipId16:'+response);
                                        }
                                        else
                                        {
                                            upsert lstAccount Mainframe_ID__c;
                                            response='StatusCode: 102,Status: Success, Message : Account Created Successfully:'+'~'+ acctobj.Id +'~'+strInsightCompanyID;
                                            System.debug('strPrivateOwnerShipId17:'+response);
                                        }                                      
                                       return response;
                                     }
                                 Catch(Exception ex)
                                  {
                                   response= 'StatusCode: 101,Status: Failure, Message : Account cannot be created:' + ex;
                                   return response;
                                  }
                                  
                                 }                                 
                            }
                            else
                            {
                                response= 'StatusCode: 100,Status: Failure, Message : Missing Required Parameter InsightCompanyID for Account';
                                return response;
                            }
                        } 
                      return response;                      
                  }
            //Generate Contact Response
            public static string parseContactJsonString(string jsonstring,string AccountId,string strInsightCompanyID)
            {
                Map<String, Object> results =(Map<String, Object>)JSON.deserializeUntyped(jsonstring);
                integer Successrowcount=0;
                string response='';
                List<Object> lstContacts = (List<Object>)results.get('Contacts');           
                Object[] aryContact = (Object[]) results.get('Contacts');
                if (aryContact!=null)
                {
                for (Object Contacts : lstContacts) 
                {
                    // now get attributes for this Contact.
                    Map<String, Object> ContactAttributes = (Map<String, Object>)Contacts;
                    // now loop through our Contact attributes.
                    Contact contobj=new Contact();
                    List<Contact> lstContact=new List<Contact>();                    
                    string Title='';
                    string strInsightContactID='';
                    Boolean IsInsightContactID=false;
                    Boolean IsTitleMatched=false;
                    string TitleRole='';
                    string TitleOtherRole='';
                    string strUserId='';
                    string strPrivateOwnerShipId='';
                    string [] arrAllPrivateOwnershipId;
                    string strPrivateOwnerShipId1='';
                    string strPrivateOwnerShipId2='';
                    string strPrivateOwnerShipId3='';
                    string strPrivateOwnerShipId4='';
                    string strPrivateOwnerShipId5='';
                    string strUserProfile='';
                    string RegionContactRole='';
                    string RegionContactEmail='';
                    string RegionContactPhone='';
                    string RegionContactMobile='';
                    for (String attributeName : ContactAttributes.keyset()) 
                     {
                         try
                         {
                             if (attributeName=='FirstName')
                             {
                                contobj.FirstName=(String)ContactAttributes.get(attributeName);
                             }  
                            if (attributeName=='LastName')
                            {
                                contobj.LastName=(String)ContactAttributes.get(attributeName);
                            }  
                            if (attributeName=='ContactPhone1')
                            {
                                //contobj.Phone=(String)ContactAttributes.get(attributeName);
                                RegionContactPhone=(String)ContactAttributes.get(attributeName);
                            } 
                            if (attributeName=='ContactPhone2')
                            {
                                //contobj.OtherPhone=(String)ContactAttributes.get(attributeName);
                                RegionContactMobile=(String)ContactAttributes.get(attributeName);
                            }
                            if (attributeName=='Source')
                            {
                                contobj.Source__c=(String)ContactAttributes.get(attributeName);
                            }
                            if (attributeName=='Title')
                            {
                                Title=(String)ContactAttributes.get(attributeName);                                
                                Schema.DescribeFieldResult fieldResult = Role__c.Role__c.getDescribe();              
                                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();                
                                for( Schema.PicklistEntry f : ple)
                                   {
                                      TitleRole='Other';
                                      TitleOtherRole=Title;
                                      if (f.getValue()==Title)
                                      {
                                          TitleRole=Title;
                                          TitleOtherRole='';
                                          break;
                                      }                                      
                                   } 
                            }                            
                             
                            if (attributeName=='ContactEmail')
                            {
                                //contobj.Email=(String)ContactAttributes.get(attributeName);
                                RegionContactEmail=(String)ContactAttributes.get(attributeName);
                            } 
                            if (attributeName=='ContactFax')
                            {
                                contobj.Fax=(String)ContactAttributes.get(attributeName);
                            }
                            if (attributeName=='ContactRole')
                            { 
                                RegionContactRole=(String)ContactAttributes.get(attributeName);                              
                            }
                            if (attributeName=='Department')
                            {
                                contobj.Department=(String)ContactAttributes.get(attributeName);
                            }
                            contobj.AccountId=AccountId; 
                            
                            if (attributeName=='InsightContactID')
                            {
                                if ((String)ContactAttributes.get(attributeName)!=null && (String)ContactAttributes.get(attributeName)!='')
                                {
                                    IsInsightContactID=false;
                                    contobj.Mainframe_ID__c=(String)ContactAttributes.get(attributeName);
                                    strInsightContactID=(String)ContactAttributes.get(attributeName);
                                }
                                else
                                {
                                    IsInsightContactID=true;
                                }   
                                   
                            }
                            
                         }
                         Catch(Exception ex)
                          {                              
                                  response= 'StatusCode: 201,Status: Failure, Message : Parameters values not passed correctly, '+ ex ;
                                  return response;                              
                          }
                     }
                    
                            
                        if (!IsInsightContactID)
                          {
                                strUserId=GetUserId(jsonstring);
                                strPrivateOwnerShipId=getContactPrivateOwnershipId(strUserId,strInsightContactID,AccountId);
                                
                                System.debug('strContactPrivateOwnerShipId:'+strPrivateOwnerShipId);
                                arrAllPrivateOwnershipId=strPrivateOwnerShipId.split(',');
                                //System.debug('arrAllPrivateOwnershipId:'+arrAllPrivateOwnershipId.size());
                                for(integer k=0;k<=(arrAllPrivateOwnershipId.size())-1;k++)
                                {  
                                   if (k<=14)
                                   {
                                    if (strPrivateOwnerShipId1=='')
                                    {
                                    	strPrivateOwnerShipId1=arrAllPrivateOwnershipId[k]+',';
                                        //System.debug('strPrivateOwnerShipId11:'+strPrivateOwnerShipId1);
                                    }
                                    else
                                    {
                                        strPrivateOwnerShipId1=strPrivateOwnerShipId1 + arrAllPrivateOwnershipId[k]+',';
                                        //System.debug('strPrivateOwnerShipId12:'+strPrivateOwnerShipId1);
                                    }
                                   }
                                   if (k>14 && k<=29)
                                    {
                                        if (strPrivateOwnerShipId2=='')
                                        {
                                            strPrivateOwnerShipId2=arrAllPrivateOwnershipId[k]+',';
                                            //System.debug('strPrivateOwnerShipId21:'+strPrivateOwnerShipId2);
                                        }
                                        else
                                        {
                                            strPrivateOwnerShipId2=strPrivateOwnerShipId2 + arrAllPrivateOwnershipId[k]+',';
                                            //System.debug('strPrivateOwnerShipId22:'+strPrivateOwnerShipId2);
                                        }
                                        
                                    }
                                    if (k>29 && k<=44)
                                    {
                                        if (strPrivateOwnerShipId3=='')
                                        {
                                            strPrivateOwnerShipId3=arrAllPrivateOwnershipId[k]+',';
                                            //System.debug('strPrivateOwnerShipId21:'+strPrivateOwnerShipId3);
                                        }
                                        else
                                        {
                                            strPrivateOwnerShipId3=strPrivateOwnerShipId3 + arrAllPrivateOwnershipId[k]+',';
                                            //System.debug('strPrivateOwnerShipId22:'+strPrivateOwnerShipId3);
                                        }
                                        
                                    }
                                    if (k>44 && k<=59)
                                    {
                                        if (strPrivateOwnerShipId4=='')
                                        {
                                            strPrivateOwnerShipId4=arrAllPrivateOwnershipId[k]+',';
                                            //System.debug('strPrivateOwnerShipId21:'+strPrivateOwnerShipId4);
                                        }
                                        else
                                        {
                                            strPrivateOwnerShipId4=strPrivateOwnerShipId4 + arrAllPrivateOwnershipId[k]+',';
                                            //System.debug('strPrivateOwnerShipId22:'+strPrivateOwnerShipId4);
                                        }
                                        
                                    }
                                    if (k>59 && k<=74)
                                    {
                                        if (strPrivateOwnerShipId5=='')
                                        {
                                            strPrivateOwnerShipId5=arrAllPrivateOwnershipId[k]+',';
                                            //System.debug('strPrivateOwnerShipId21:'+strPrivateOwnerShipId5);
                                        }
                                        else
                                        {
                                            strPrivateOwnerShipId5=strPrivateOwnerShipId5 + arrAllPrivateOwnershipId[k]+',';
                                            //System.debug('strPrivateOwnerShipId22:'+strPrivateOwnerShipId5);
                                        }                                        
                                    }                                   
                                    
                                }
                                //System.debug('strPrivateOwnerShipId13:'+strPrivateOwnerShipId1);
                                contobj.Private_Ownership_List1__c=strPrivateOwnerShipId1;
                                contobj.Private_Ownership_List2__c=strPrivateOwnerShipId2;
                                contobj.Private_Ownership_List3__c=strPrivateOwnerShipId3;
                                contobj.Private_Ownership_List4__c=strPrivateOwnerShipId4;
                                contobj.Private_Ownership_List5__c=strPrivateOwnerShipId5;
                              
                                strUserProfile=GetUserProfile(jsonstring);
                                System.debug('strUserProfile:' + strUserProfile);
                                System.debug('RegionContactRole:'+ RegionContactRole);
                                if(strUserProfile=='DTNA - STC Toronto')
                                {
                                   contobj.STC_Toronto_Decision_Process__c=RegionContactRole;
                                   contobj.STC_Toronto_Email__c=RegionContactEmail;
                                   contobj.STC_Toronto_Phone__c=RegionContactPhone;
                                   contobj.STC_Toronto_Mobile__c=RegionContactMobile;                                       
                                }
                                if(strUserProfile=='DTNA - STC Charlotte')
                                {
                                   contobj.Decision_Process__c=RegionContactRole; 
                                   contobj.STC_Charlotte_Email__c=RegionContactEmail;
                                   contobj.STC_Charlotte_Phone__c=RegionContactPhone;
                                   contobj.STC_Charlotte_Mobile__c=RegionContactMobile; 
                                }
                                if(strUserProfile=='DTNA - STC Tampa')
                                {
                                   contobj.STC_Tampa_Decision_Process__c=RegionContactRole;
                                   contobj.STC_Tampa_Email__c=RegionContactEmail;
                                   contobj.STC_Tampa_Phone__c=RegionContactPhone;
                                   contobj.STC_Tampa_Mobile__c=RegionContactMobile; 
                                }
                                if(strUserProfile=='DTNA - STC New England')
                                {
                                   contobj.STC_New_England_Decision_Process__c=RegionContactRole;
                                   contobj.STC_New_England_Email__c=RegionContactEmail;
                                   contobj.STC_New_England_Phone__c=RegionContactPhone;
                                   contobj.STC_New_England_Mobile__c=RegionContactMobile; 
                                }
                                if(strUserProfile=='DTNA - STC Louisville')
                                {
                                   contobj.STC_Louisville_Decision_Process__c=RegionContactRole; 
                                   contobj.STC_Louisville_Email__c=RegionContactEmail;
                                   contobj.STC_Louisville_Phone__c=RegionContactPhone;
                                   contobj.STC_Louisville_Mobile__c=RegionContactMobile; 
                                }
                                if(strUserProfile=='DTNA - STC Cleveland')
                                {
                                   contobj.STC_Cleveland_Decision_Process__c=RegionContactRole;
                                   contobj.STC_Cleveland_Email__c=RegionContactEmail;
                                   contobj.STC_Cleveland_Phone__c=RegionContactPhone;
                                   contobj.STC_Cleveland_Mobile__c=RegionContactMobile; 
                                }
                                if(strUserProfile=='DTNA - STC Kansas City')
                                {
                                   contobj.STC_Kansas_City_Decision_Process__c=RegionContactRole; 
                                   contobj.STC_Kansas_City_Email__c=RegionContactEmail;
                                   contobj.STC_Kansas_City_Phone__c=RegionContactPhone;
                                   contobj.STC_Kansas_City_Mobile__c=RegionContactMobile; 
                                }
    
                            lstContact.add(contobj);   
                            if(lstContact!=null && lstContact.size()>0)
                                 {                                 
                                 try
                                     {
                                      List<Contact> ListExistContact=[select Id from Contact where Mainframe_ID__c = :strInsightContactID];
                                      if(ListExistContact!=null && ListExistContact.size()>0)
                                      {   
                                      upsert lstContact Mainframe_ID__c;
                                      response='StatusCode: 202,Status: Success, Message : Contact Updated Successfully for InsightContactID '+strInsightContactID +': '+ contobj.Id; 
                                      }
                                      else
                                      {
                                       upsert lstContact Mainframe_ID__c;
                                       response='StatusCode: 202,Status: Success, Message : Contact Created Successfully for InsightContactID '+strInsightContactID +': '+ contobj.Id; 
                                      }                                      
                                        Id STCRoleRecordType = Schema.SObjectType.Role__c.getRecordTypeInfosByName().get('STC Role').getRecordTypeId();
                                        List<Role__c> lstContactRole=new List<Role__c>();
                                        Role__c contRoleobj=new Role__c();
                                        contRoleobj.Account__c=AccountId;
                                        contRoleobj.Contact__c=contobj.Id;           
                                        contRoleobj.ExternalID__c=strInsightCompanyID+strInsightContactID;
                                        contRoleobj.Role__c=TitleRole;
                                        contRoleobj.Other_Role__c=TitleOtherRole; 
                                        contRoleobj.RecordTypeId=STCRoleRecordType;
                                        lstContactRole.add(contRoleobj);
                                        List<Role__c> ListExistContactRole=[select Id from Role__c where ExternalID__c = :strInsightCompanyID+strInsightContactID];                                           
                                        upsert lstContactRole ExternalID__c; 
                                     }
                                 Catch(Exception ex)
                                  {
                                     response= 'StatusCode: 201,Status: Failure, Message : Contact cannot be Created or Updated: for InsightContactID : '+strInsightContactID +', '+ ex ;
       
                                  }                
                             }  
                        }
                       else
                       {
                            response='StatusCode: 200,Status: Failure, Message : Missing Required Parameter InsightContactID for Contact : '+strInsightContactID;
                       } 
                    } 
                }
                else
                {
                    response='';
                }
               return response;
            }
            //Generate PrivateActivity/Task Response
            public static string parsePrivateActivityJsonString(string jsonstring,string AccountId)
            {
                Map<String, Object> results =(Map<String, Object>)JSON.deserializeUntyped(jsonstring);                            
                List<Object> lstPvtActivities = (List<Object>)results.get('PrivateActivity'); 
                integer Successrowcount=0;
                string response='';
                Object[] aryPrivateActivity = (Object[]) results.get('PrivateActivity'); 
                if(aryPrivateActivity!=null)
                {
                for (Object PrivateActivities : lstPvtActivities) 
                {
                    // now get attributes for this PrivateActivityobj.
                    Map<String, Object> PrivateActivityAttributes = (Map<String, Object>)PrivateActivities;
                    // now loop through our PrivateActivityobj attributes.                    
                    List<Private_Activity__c> lstPvtActivity=new List<Private_Activity__c>(); 
                    Private_Activity__c PrivateActivityobj=new Private_Activity__c(); 
                    String strActDescription; 
                    Date strActDueDate;
                    String strActStage;
                    String strActPriority; 
                    string strDTNAConnectId;
                    Boolean IsActDescription=false;
                    String strUserId='';
                    
                     for (String attributeName : PrivateActivityAttributes.keyset()) 
                     {
                         try
                         {                        
                             PrivateActivityobj.Account__c=AccountId;
                             PrivateActivityobj.Account_Open_Activity_RL__C=AccountId;    

                             if (attributeName=='Act_Stage')
                             {
                                PrivateActivityobj.Status__c=(String)PrivateActivityAttributes.get(attributeName);
                                strActStage=(String)PrivateActivityAttributes.get(attributeName);
                             }  
                            if (attributeName=='Act_DueDate')
                            {                                
                                Date myDate = Date.valueOf((String)PrivateActivityAttributes.get(attributeName));
                                PrivateActivityobj.Due_Date__c=myDate;
                                strActDueDate=myDate;
                            }  
                            
                            if (attributeName=='Act_Description')
                            {
                                if ((String)PrivateActivityAttributes.get(attributeName)!=null && (String)PrivateActivityAttributes.get(attributeName)!='')
                                {
                                    IsActDescription=false;
                                    PrivateActivityobj.Name='PGA-' +((String)PrivateActivityAttributes.get(attributeName)).Left(75);                               
                                    strActDescription='PGA-' +((String)PrivateActivityAttributes.get(attributeName)).Left(75);
                                }
                                else
                                {
                                    IsActDescription=true;
                                }
                            } 
                            if (attributeName=='DTNAConnectId')
                            {                                                               
                                strDTNAConnectId=(String)PrivateActivityAttributes.get(attributeName);
                                strUserId = [select Id from User where FederationIdentifier = :strDTNAConnectId][0].Id;
                                PrivateActivityobj.owner__c=strUserId;
                            }                         
                            
                            if (attributeName=='Act_Priority')
                             {                                
                                strActPriority=(String)PrivateActivityAttributes.get(attributeName);
                             }  
                         }
                         Catch(Exception ex)
                          {                             
                            response='StatusCode: 301,Status: Failure, Message : Activities/Tasks cannot be created for DTNAConnectId: '+strDTNAConnectId +', '+ ex;
                            return response; 
                          }
                     }
                          if (!IsActDescription)
                          {
                            lstPvtActivity.add(PrivateActivityobj); 
                            
                            //System.debug('PrivateActivity========> ' + lstPvtActivity);
                            if(lstPvtActivity!=null && lstPvtActivity.size()>0)
                                 {
                                        try
                                        {
                                        insert lstPvtActivity;  
                                        }
                                        Catch(Exception ex)
                                         {
                                            response='StatusCode: 301,Status: Failure, Message : Private Activity cannot be created for DTNAConnectId: '+strDTNAConnectId +', ' + ex;
                                            return response;
                                         }
                                        List<Task> lstTask =new List<Task>();
                                        Task Taskobj=new Task();    
                                        Taskobj.WhatId=PrivateActivityobj.Id;
                                        Taskobj.Description=strActDescription; 
                                        Taskobj.Subject=strActDescription; 
                                        Taskobj.ActivityDate=strActDueDate;
                                        Taskobj.Status=strActStage;                                         
                                        Taskobj.Priority=strActPriority; 
                                        lstTask.add(Taskobj);
                                       try
                                        {
                                        insert lstTask;  
                                        }
                                       Catch(Exception ex)
                                         {
                                          response='StatusCode: 301,Status: Failure, Message : Tasks cannot be created for DTNAConnectId: '+strDTNAConnectId +', ' + ex;
                                          return response;
                                         }
                                        PrivateActivityobj.Activity_ID__c=Taskobj.Id;
                                        try
                                        {
                                          update lstPvtActivity;
                                          response='StatusCode: 302,Status: Success, Message : Tasks Created Successfully for DTNAConnectId '+strDTNAConnectId +': '+ Taskobj.Id;
                                        }
                                        Catch(Exception ex)
                                         {
                                          response='StatusCode: 301,Status: Failure, Message : Tasks cannot be created for DTNAConnectId: '+strDTNAConnectId +', ' + ex;
                                          return response;
                                         }
                               }
                
                            } 
                            else
                            {
                                response='StatusCode: 300,Status: Failure, Message : Missing Required Parameter Act_Description for Activities/Tasks for DTNAConnectId: '+strDTNAConnectId;
                            }                    
                     }
                }
                else
                {
                    response='';
                }
                return response;
            }
            
        }