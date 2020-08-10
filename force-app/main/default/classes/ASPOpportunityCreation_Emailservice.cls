/**
    * ─────────────────────────────────────────────────────────────────────────────────────────────────┐
    * One or two sentence summary of this class.
    *
    * This class is used in email service to create an opportunity(salesquote) and ASP quote using the
    * the email body. 
    * 
    * ──────────────────────────────────────────────────────────────────────────────────────────────────
    * @author         Satish Kumar  
    * @modifiedBy          
    * @version        1.0
    * @created        3-22-2017
    * @modified       MM-DD-YYYY
    * ──────────────────────────────────────────────────────────────────────────────────────────────────
    * @changes
    * modifiedBy            
    * MM-DD-YYYY      Explanation of the change.  Multiple lines can be used to explain the change, but
    *                 each line should be indented till left aligned with the previous description text.
    *
    * modifiedBy           
    * MM-DD-YYYY      Each change to this file should be documented by incrementing the version number,
    *                 and adding a new entry to this @changes list. Note that there is a single blank
    *                 line between each @changes entry.
    * ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

global class ASPOpportunityCreation_Emailservice implements Messaging.InboundEmailHandler 
{
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope) 
    {
                                                               
       Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
       String TextBody = email.plainTextBody.normalizeSpace();
       
       String strASPRelatedRecord='';                                 //Stores the record with timestamp for error logging
       strASPRelatedRecord='ASP'+ '_'+string.valueof(datetime.now());
       strASPRelatedRecord=strASPRelatedRecord.replace('-', '');
       strASPRelatedRecord=strASPRelatedRecord.replace(':', '');
       strASPRelatedRecord=strASPRelatedRecord.replace(' ', '');
       System.debug('ASPRelatedRecord' + strASPRelatedRecord);
       
       try
        {   DTNA_IntegrationLogging.IntegrationLoggingReqInsert('ASP Email', 'ASP Email service', 'Opportunity creation', strASPRelatedRecord, TextBody , 'Requested');
           Map<String,String> EmailsMap = new Map<String,String>();     // use to store the deserialised values of the email body.
           EmailsMap.put('Quote Number',TextBody.substringBetween('Quote Number ','<'));
           EmailsMap.put('Customer Code',TextBody.substringBetween('Customer Code : ',' '));
           EmailsMap.put('Customer Name',TextBody.substringBetween('Customer Name : ','Requested'));
           EmailsMap.put('Requested By',TextBody.substringBetween('Requested By ','Requested'));
           EmailsMap.put('Requested Date',TextBody.substringBetween('Requested Date ','Coverage'));
           EmailsMap.put('Coverage Requested',TextBody.substringBetween('Coverage Requested : ','Terms In Months'));
           EmailsMap.put('Terms In Months',TextBody.substringBetween('Terms In Months ',' '));
           EmailsMap.put('Months Total Number of Units',TextBody.substringBetween('Months Total Number of Units ',' '));
           EmailsMap.put('Estimated fixed monthly charge',TextBody.substringBetween('Estimated fixed monthly charge : ',' '));
           EmailsMap.put('Estimated variable charge/Mile',TextBody.substringBetween('Estimated variable charge/Mile : ',' '));
           EmailsMap.put('Estimated hourly reefer charge',TextBody.substringBetween('Estimated hourly reefer charge : ',' '));
           EmailsMap.put('Comments',TextBody.substringBetween('Comments','Daimler Trucks Online Warranty'));
           // System.debug(EmailsMap);
           for(String s:EmailsMap.keyset())
               system.debug(s +'='+EmailsMap.get(s));
           String contname;                         // stores the name of the contact retrieved from requested by section of the email body.
           List<List<sObject>> searchCon;
           if(EmailsMap.get('Requested By')!=null)
               contname = EmailsMap.get('Requested By'); 
           String searchQuery;
           if(contname!=null&&contname!='')
               searchQuery = 'FIND \'' + contname + '\' IN ALL FIELDS RETURNING Contact (Id,Name ORDER BY LastModifiedDate DESC) limit 1';
           if(searchQuery!=null)           
               searchCon = search.query(searchQuery);
           System.debug(searchCon);
           Contact Contid;
           if(searchCon!=null)
               if(searchCon[0].size()>0)
                   Contid = (Contact)searchCon[0][0];
            
           /**@ Creating Opportunity Record @@ **/
           
           Date ReqDate;            // stores the requested date retrieved from email.
           if(EmailsMap.get('Requested Date')!=null)
               ReqDate = date.parse(String.valueOf(EmailsMap.get('Requested Date')).trim());     
           Opportunity Opp= new Opportunity() ;
           Opp.StageName='Quotation Request';
           if(EmailsMap.get('Customer Name')!=null)
               Opp.Name= EmailsMap.get('Customer Name');  
           if(ReqDate !=null)
               Opp.CloseDate= date.newinstance(ReqDate.year(),ReqDate.month(),ReqDate.day()).addDays(60);
           User owner= [select id, Username, Email from User where Email =:email.fromAddress LIMIT 1];
           Opp.Ownerid=owner.id; 
           system.debug('"""""""""""'+Opp.Owner);
           RecordType OppRT = [Select id from RecordType where DeveloperName='Sales_Quote'];
           Opp.RecordTypeId= OppRT.Id;
           if(EmailsMap.get('Customer Name')!=null)
               Opp.CUST_NAME_50__c= EmailsMap.get('Customer Name');
           if(EmailsMap.get('Months Total Number of Units')!=null)
               Opp.Total_of_Quoted_Trucks__c= decimal.valueOf(EmailsMap.get('Months Total Number of Units'));
           if(Contid!=null)
               Opp.Contact__c= Contid.Id;
           DataBase.Insert(Opp);  
           /**@ Creating Quote Record @@ **/ 
            
           Quote quot = new Quote();  
           if(EmailsMap.get('Coverage Requested')!=null)
               quot.Contract_Type__c = (EmailsMap.get('Coverage Requested').substring(0, 2));
           if(EmailsMap.get('Terms In Months')!=null)
               quot.Term__c = Decimal.valueOf(EmailsMap.get('Terms In Months'));
           if(EmailsMap.get('Estimated fixed monthly charge')!=null)
               quot.Monthly_Fixed__c = Decimal.valueOf(EmailsMap.get('Estimated fixed monthly charge'));
           if(EmailsMap.get('Estimated hourly reefer charge')!=null)
               quot.TK_Rate__c = Decimal.valueOf(EmailsMap.get('Estimated hourly reefer charge'));
           quot.Quote_Requested_Date__c= date.newinstance(ReqDate.year(),ReqDate.month(),ReqDate.day());
           if(EmailsMap.get('Estimated variable charge/Mile')!=null)
               quot.Mileage_Rate__c = Decimal.valueOf(EmailsMap.get('Estimated variable charge/Mile'));
           if(EmailsMap.get('Customer Name')!=null&&EmailsMap.get('Coverage Requested')!=null)
               quot.Name= EmailsMap.get('Customer Name')+' '+(EmailsMap.get('Coverage Requested').substring(0, 2));
           quot.OpportunityId=Opp.id;
           RecordType QuoRT = [Select id from RecordType where DeveloperName='ASP_Quote'];
           Opp.RecordTypeId= QuoRT.Id;
           if(EmailsMap.get('Quote Number')!=null)
               quot.Quote_Number__c = EmailsMap.get('Quote Number');
           quot.Quote_Created__c = 'Yes';
           Database.Insert(quot);
           DTNA_IntegrationLogging.IntegrationLoggingRespUpdate(strASPRelatedRecord, 'opportunity id='+ Opp.id +'Quote id=' + quot.id, 'Success');
           //  IntegrationLogToUpdate = database.query(soqlQuery);
           
           return result;
        }
       catch(Exception e)
        {   
            // creating an error log record using integration log object.
           //DTNA_IntegrationLogging.IntegrationLoggingReqInsert('Opportunity record Insertion', 'ASP Email service', 'Insert', strASPRelatedRecord, TextBody , 'Requested');
           DTNA_IntegrationLogging.IntegrationLoggingRespUpdate(strASPRelatedRecord, 'exception='+ e, 'Fail');
           // IntegrationLogToUpdate = database.query(soqlQuery);
           return result;
        }
    }
}