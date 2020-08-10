/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Purpose:
* This class is the controller for QuoteActivityConc Page and QuoteActivityConc Mobile Page 
* 
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Anto  
* @modifiedBy     Anto     
* @version        1.0
* @created        10-06-2016
* @modified       04-30-2018
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes 1.3
* modifiedBy      Anto      
* 04-20-2018      Set the Default Filter as a configurable value from custom label
*
* @changes 1.4
* modifiedBy      Anto      
* 04-30-2018      Added Manual Archival Logic
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes 1.5
* modifiedBy      Jayasurya
* 05-08-2018      Added Method to handle salesforce Limit of 1000 UI records 
*                 Added method for the Export Selected Button to export selected columns as Excel sheet
*                 Added method for the Export All Button to export All columns as Excel sheet
──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes 1.6
* modifiedBy      Rahul Aggarwal
* 05-08-2018      Added new field "Stage_Activity_Date__c" in SOQL in Line# [234,290,415]
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes 1.7
* modifiedBy      Deepakraj
* 04-25-2019      Added new method "openPageMobile" 
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes 1.8
* modifiedBy      Deepakraj
* 05-10-2019      Modified logic to display the latest deal comments and export same in Excel
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public with sharing class DTNA_Quote_Activity_List
{ // Public boolean checked{get;set;}
 public List<ConcWrapper> lstConcessions {get;set;} //Core Data Object with All the Concession and Supporting Data
 public List<Filter> lstFilters {get;set;} // USed for maintaining the filter information in the page
 public Integer QApageNumber {get;set;} // used in the page to navigate to the page
 public Boolean displayFilter {get;set;} // Flag to control the display of the filter section
 public Boolean displayFilterHeader {get;set;} // Flag to hide the filter list header when the list is empty
 public Boolean displayExcelCols {get;set;} // Flag to control the display of the Excel form section
 public List<String> devlog{get;set;} // Generate and maintain a log for development support and maintenance
 public Integer intDelFilter{get;set;} // fetch the filter record that is being deleted
 public Integer intFilterAutoNumber=0; // Auto number for keeping track of the Filter record number
 public Map <String,String> fieldTypeOutput = new Map<String,String>(); // Used to map the field type for each field selected in a filter record
 public String strQuery=''; // The Query String
 public static String strUserId = UserInfo.getUserId(); //logged in uset
 public String ProfileName{get;set;} // Logged in Profile
 public Integer QA_Def_Req_Min=4; 
 public boolean Selectlistflag{get;set;} //Used to display the Select list After clicking the Excel Button
 public Boolean displayExcelHeader {get;set;} // Used in vf page to Display the header 
 //public List<sObject> lstObjs {get;set;}
 public List<sObject> ExcelRecs{get;set;} // Used to query all the records to generate Excel based on filter criteria
 public map<integer,List<sobject>> OversizeDatamap{get;set;}// = map<String,List<sobject>>();
 public set<integer> OversizeDatamapkeys{get;set;}
 
 String FilterCond; // Used internally for calculating the Filter Condition
 String parsedValue; // USed internally for storing the result of the parsed filter criteria
 
 //History of Comments and Forecast
 public  List<Quote_Activity_Comment_History__c> QA_Comment_His {get; set;}
 public  Quote_Activity_Comment_History__c obj_QAComment {get; set;}
 public  List<Concession_Forecast__c> QA_Concession_Forecast {get; set;}
 public Concession_Forecast__c obj_QAForecast {get; set;}
 //History of Comments and Forecast
 
 public class QAFilterException extends Exception{} 
 
 //Export Selected SelectionList Values retireved from custom metadata
 public Map<String,String> LablesMap
 {
     get
     {
         Map<String,String> LablesMap = new Map<String,String>();
         QuoteActivity_Map__mdt[] QuoteMappings = [SELECT MasterLabel, LabelName__c,FieldAPIName__c,QualifiedApiName  FROM QuoteActivity_Map__mdt ORDER BY QualifiedApiName  ASC];
         for (QuoteActivity_Map__mdt qaot : QuoteMappings ) 
         {
             LablesMap.put(qaot.LabelName__c,qaot.MasterLabel);            
         }
         return LablesMap;
     }
     set;
 }
 //End of GenerateExcel SelectionList
// public Map<String,String> LablesMapFilterDis = new Map<String,String>();
 //method used to get the selected values from the lables map generated from the Custom Metadata
 public List<SelectOption> getItems() 
 {
     List<SelectOption> options = new List<SelectOption>();
     System.debug(LablesMap);
     System.debug('The LablesMap.keyset():::' + LablesMap.keyset());
     for(String s: LablesMap.keyset())
          options.add(new SelectOption(s,LablesMap.get(s)));
     System.debug ('The value of option is:::' + options);
     return options;
     
 }
 
 public list<String> SelectedValues{Get;set;} // 
 public list<String> ExcelTableData{get;set;} // USed to dispaly Selected fields header on generated Excel page  
 public list<String> ExcelTableHeaders{get;set;} //  USed to dispaly Selected fields data on generated Excel page
 
 //  public List<string> ExcelTableHeaders{get;set;} //Dispaly header values on Excel sheet
 //  public List<string> ExcelTableData{get;set;} // Dispaly data  on Excel sheet
 
 //GenerateExcel button 
 
 public void GenerateColSelectedExcel(){
     ExcelTableData= new List<String>(); 
     ExcelTableHeaders = new List<String>(); 
     for(String str: SelectedValues){
         System.debug(LablesMap.get(str));
         System.debug(str);
         //ExcelTableHeaders.add(str);
        // ExcelTableData.add(LablesMapFilterDis.get(str));
          ExcelTableHeaders.add(LablesMap.get(str));
          ExcelTableData.add(str);
         System.debug(str);
         //  Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=QuoteActivity.pdf');
     }

     // return null;
 }
 
 //End of Export Selected button 
 
 public class ConcWrapper // Class to define the concession record
 {
     
     public Boolean checked{ get; set; }
     public  Concession__c sObjConc { get; set; }
     public String str_DealComment { get; set; }
     public String str_DOAComment1 { get; set; }
     public String str_DOAComment2 { get; set; }
     
     public Date DtQuoted 
     { 
         get
         {  
             return sObjConc.Date_Quoted__c;
         }
         set
         {
             DTQuoted = value;
             sObjConc.Date_Quoted__c = value;
         }
     }
     public Date AproximateDate
     { 
         get
         {  
             return sObjConc.Approximate_Close_Date__c;
         }
         set
         {
             AproximateDate = value;
             sObjConc.Approximate_Close_Date__c = value;
         }
     }
     
     public ConcWrapper()
     {
         sObjConc = new Concession__c();
         checked = false;
     }
     
     public ConcWrapper(Concession__c conc)
     {
     
         sObjConc = conc;
      //Deepak Change for retaining last updated comment
         str_DealComment = sObjConc.Miscellaneous_Comments__c;
         str_DOAComment1 = sObjConc.DOA_Comment_1__c;
         str_DOAComment2 = sObjConc.DOA_Comment_2__c;
         if(Test.isRunningTest())
         {
             str_DealComment = 'str_Dealtest';
             str_DOAComment1 = 'str_DOA1test';
             str_DOAComment2 = 'str_DOA2test';
             sobjConc.Q1__C = 10;
             sobjConc.Q2__C = 20;
             sobjConc.Q3__C = 30;
             sobjConc.Q4__C = 40;
         } 
         checked = false;
     }
 }
 
 // public  DTNA_Quote_Activity_List(ApexPages.StandardSetController controller){}
 public DTNA_Quote_Activity_List () 
 {
  ExcelRecs= new List<sObject>();
  SelectedValues = new list<String>();
   ExcelTableHeaders= new list<String>();
   ExcelTableData= new list<String>();
  QApageNumber = 1;
  lstFilters = new List<Filter>();
  displayFilter=False;
  displayExcelCols=False;
  devlog = new List<String>();
  Map <String, Schema.SObjectField> fieldMap = Schema.SObjectType.Concession__c.fields.getMap();
  system.debug('the value of field map is ::: '  + fieldMap);
  String strFieldType = '';
  
     
  ProfileName = [Select Profile.Name from User where Id = :strUserId].Profile.Name;
  if(ProfileName.Left(10) == 'DTNA - FTL')
  {
      QA_Def_Req_Min= Integer.valueOf(Label.QA_FTL_Default_Requested_Minimum);
  }
  else
  {
      QA_Def_Req_Min= Integer.valueOf(Label.QA_Default_Requested_Minimum);
  }
  for(Schema.SObjectField sfield : fieldMap.Values())
  {
      schema.describefieldresult dfield = sfield.getDescribe();
      
      strFieldType = String.valueOf(dfield.getType());
      fieldTypeOutput.put(dfield.getname(),strFieldType);

  }
   //  lstFilters.add(new Filter(intFilterAutoNumber++,'Stage__c',' <> ','Cancelled,Void','String'));
   //  lstFilters.add(new Filter(intFilterAutoNumber++,'CONC_STATUS_CD__c',' = ','RPC,RPR,PNR,PNC,EXP,APC,APR'));
   //  lstFilters.add(new Filter(intFilterAutoNumber++,'RQST_MIN_UNITS__c',' > ','0'));
   //  lstFilters.add(new Filter(intFilterAutoNumber++,'Archived',' = ','N'));
  
    
  List<Filter__c>  lstFilterC = [select Id,Name,Filter_Field_Name__c, Operator__c, Value__c, OwnerId from Filter__c where OwnerId = :strUserId];
  if(lstFilterC.size()>0)
  {
      lstFilters.clear();
      for(Filter__c varFiltC:lstFilterC)
      {
          lstFilters.add(new Filter(intFilterAutoNumber++,varFiltC.Filter_Field_Name__c,' ' + varFiltC.Operator__c + ' ',varFiltC.Value__c));
      }
  }
  else
  {
      lstFilters.add(new Filter(intFilterAutoNumber++,'RQST_MIN_UNITS__c',' > ',String.valueOf(QA_Def_Req_Min)));
  }
  
  system.debug('The value of lstFilters :::' + lstFilters);
  
  strQuery = 'Select Id,Name,LEAD_CONC_NO__c,Conc_Repls__c,DIST_MGR_NAME__c,Owner.Name,Region_Desc__c,SLS_DIST_CD__c,Stage__c,CUST_NAME_50__c,'
      + 'Customer_Fleet_Size__c,CONCMCDB_ENGINE__c,Dealer_Code__c,Account__r.Name,Class__c,VEH_BASE_MDL_NO__c,Engine_Mfr__c,CONC_STATUS_CD__c,EXPR_DATE__c,TOT_MIN__c ,RQST_MIN_UNITS__c,'
      + 'APPR_MIN_UNITS__c,Order_Count__c,Q1__c,Q2__c,Q3__c,Q4__c,Q5__c,DEAL_QUOTE_COUNT__c,Target__c,Probability__c,CONT_PRSN_NAME_42__c,'
      + 'APPR_CONC_PCT__c,RQST_CONC_PCT__c,APPR_NET_CNTRB__c,CMPTR_CD__c,Account__r.BillingCity,CITY__c,Date_Quoted__c,Approximate_Close_Date__c,'
      + 'Miscellaneous_Comments__c,PROD_FAM_CD__c,CONCMCDB_MARKET_SEG__c,Create_Date__c,Lost_to_OEM__c,Lost_Reason_Code__c,Per_Unit_Margin__c,Competition_QA__c, '
      + 'APV__c,TXNCOUN_INDC__c,DOA_Comment_1__c,DOA_Comment_2__c,Manual_Archival__c,Auto_Archived__c,Stage_Activity_Date__c,MDEG_Flag__c FROM Concession__c where Manual_Archival__c <> TRUE and'
      + '(NOT Name like \'M%\') and (NOT Name like \'R%\') and (NOT Name like \'Z%\') and CONC_STATUS_CD__c in (\'RPC\',\'RPR\',\'PNR\',\'PNC\',\'EXP\',\'APC\',\'APR\') '
      + 'and Stage__c <> \'Void\' and  Stage__c <> \'Cancelled\' and  (Closed_Status_Date__c > LAST_N_WEEKS:1 OR Closed_Status_Date__c = null) and SLS_DIST_CD__c <> null and ';
  FilterCond = '';
  try
  {
      CalcQueryString();
  }
  catch(Exception e)
  {
      devlog.add(e+e.getStackTraceString());
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getMessage()));
      FilterCond = '';
  }
  if(FilterCond != '')
      FilterCond=FilterCond.left(FilterCond.length()-4);
  else
      strQuery = strQuery.left(strQuery.length()-4);
  
  strQuery = strQuery + FilterCond;
  devlog.add(strQuery);
  
  displayFilterHeader=True;
  Selectlistflag = False;
  displayExcelHeader =False;
  /* strQuery = 'Select Id,Name,LEAD_CONC_NO__c,Conc_Repls__c,DIST_MGR_NAME__c,Owner.Name,Region_Desc__c,SLS_DIST_CD__c,Stage__c,CUST_NAME_50__c,'
+ 'Customer_Fleet_Size__c,Dealer_Code__c,Account__r.Name,Class__c,VEH_BASE_MDL_NO__c,Engine_Mfr__c,CONC_STATUS_CD__c,EXPR_DATE__c,RQST_MIN_UNITS__c,'
+ 'APPR_MIN_UNITS__c,Order_Count__c,Q1__c,Q2__c,Q3__c,Q4__c,Q5__c,DEAL_QUOTE_COUNT__c,Target__c,Probability__c,CONT_PRSN_NAME_42__c,'
+ 'APPR_CONC_PCT__c,RQST_CONC_PCT__c,APPR_NET_CNTRB__c,CMPTR_CD__c,Account__r.BillingCity,CITY__c,Date_Quoted__c,Approximate_Close_Date__c,'
+ 'Miscellaneous_Comments__c,PROD_FAM_CD__c,CONCMCDB_MARKET_SEG__c,Create_Date__c,Lost_to_OEM__c,Lost_Reason_Code__c,Per_Unit_Margin__c,'
+ 'APV__c,TXNCOUN_INDC__c,MDEG_Flag__c FROM Concession__c where Stage__c <> \'Void\' and Stage__c <> \'Cancelled\' and '
+ 'CONC_STATUS_CD__c in (\'RPC\',\'RPR\',\'PNR\',\'PNC\',\'EXP\',\'APC\',\'APR\')  and '
+ 'RQST_MIN_UNITS__c > 4 and (Closed_Status_Date__c > LAST_N_WEEKS:1 OR Closed_Status_Date__c = null)';*/
 }
 
 // instantiate the StandardSetController from a query locator
 public ApexPages.StandardSetController con
 {
     get
     {
         if(con == null)
         {   
             try
             {
                 con = new ApexPages.StandardSetController(Database.getQueryLocator(strQuery +  ' Order By CUST_NAME_50__c,Create_Date__c desc  limit 9999'));
                 system.debug('**********'+ con);
                 // ExcelRecs= (List<sobject>) Database.Query(strQuery +  ' Order By CUST_NAME_50__c,Create_Date__c desc limit 9999');
                 System.debug('**********'+ ExcelRecs);
             }
             catch(Exception e)
             { 
                 strQuery = 'Select Id,Name,LEAD_CONC_NO__c,Conc_Repls__c,DIST_MGR_NAME__c,Owner.Name,Region_Desc__c,SLS_DIST_CD__c,Stage__c,CUST_NAME_50__c,'
                     + 'Customer_Fleet_Size__c,CONCMCDB_ENGINE__c,Dealer_Code__c,Account__r.Name,Class__c,VEH_BASE_MDL_NO__c,Engine_Mfr__c,CONC_STATUS_CD__c,EXPR_DATE__c,TOT_MIN__c ,RQST_MIN_UNITS__c,'
                     + 'APPR_MIN_UNITS__c,Order_Count__c,Q1__c,Q2__c,Q3__c,Q4__c,Q5__c,DEAL_QUOTE_COUNT__c,Target__c,Probability__c,CONT_PRSN_NAME_42__c,'
                     + 'APPR_CONC_PCT__c,RQST_CONC_PCT__c,APPR_NET_CNTRB__c,CMPTR_CD__c,Account__r.BillingCity,CITY__c,Date_Quoted__c,Approximate_Close_Date__c,Competition_QA__c,'
                     + 'Miscellaneous_Comments__c,PROD_FAM_CD__c,CONCMCDB_MARKET_SEG__c,Create_Date__c,Lost_to_OEM__c,Lost_Reason_Code__c,Per_Unit_Margin__c,'
                     + 'APV__c,TXNCOUN_INDC__c,DOA_Comment_1__c,DOA_Comment_2__c,Manual_Archival__c,Auto_Archived__c,Stage_Activity_Date__c,MDEG_Flag__c FROM Concession__c where  Manual_Archival__c <> TRUE and'
                     + '(NOT Name like \'M%\') and (NOT Name like \'R%\') and (NOT Name like \'Z%\') '
                     + ' and CONC_STATUS_CD__c in (\'RPC\',\'RPR\',\'PNR\',\'PNC\',\'EXP\',\'APC\',\'APR\') '
                     + ' and  (Closed_Status_Date__c > LAST_N_WEEKS:1 OR Closed_Status_Date__c = null) '
                     + ' and Stage__c <> \'Void\' and  Stage__c <> \'Cancelled\'  and SLS_DIST_CD__c <> null ';
                 con = new ApexPages.StandardSetController(Database.getQueryLocator(strQuery +  ' Order By CUST_NAME_50__c,Create_Date__c desc limit 9999')); 
                 // ExcelRecs=  (List<sobject>) Database.Query(strQuery +  ' Order By CUST_NAME_50__c,Create_Date__c desc limit 9999');
                 devlog.add(e+e.getStackTraceString());
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getMessage()));
             }
             // sets the number of records in each page set
             //con.setPageSize(25);
         }
         system.debug('System query:::  ' + strQuery);
         return con;
     }
     set;
 }
 
 // returns a list of wrapper objects for the sObjects in the current page set
 public List<ConcWrapper> getConcessions() 
 {
     lstConcessions = new List<ConcWrapper>();
     //lstObjs = new list<Sobject>();
     for (Concession__c sObjConc : (List<Concession__c>)con.getRecords()){
         lstConcessions.add(new ConcWrapper(sObjConc));
         //  lstObjs.add(sObjConc);
         //  integer.add(sObjConc.id);
     }
     return lstConcessions;
 }
 
 //  public map<integer,List<sobject>> OversizeDatamap2{get;set;}// = map<String,List<sobject>>();
 //  public set<integer> OversizeDatamapkeys2{get;set;}
 
 //@Export All button. 
/*  public PageReference Export(){

ExcelTableData= new List<String>(); 
ExcelTableHeaders = new List<String>();

Oversizehandler();
ExcelTableData.addall(LablesMap.keyset());
ExcelTableHeaders= LablesMap.values();
System.debug('ExcelRecs'+ExcelRecs);
PageReference pgref = Page.QuoteActivityConc_Excel;
pgref .setRedirect(false);
return pgref ;

}*/
 public void ExcelCancel(){
     displayExcelCols=False;
 }
 public void Oversizehandler(){
     OversizeDatamap= new map<integer,List<sobject>>();
     OversizeDatamapkeys= new set<integer>();
     
     ExcelRecs=  (List<sobject>) Database.Query(strQuery +  ' Order By CUST_NAME_50__c,Create_Date__c desc limit 9999');
     List<sobject> res= new list<sobject>();
     integer i=0;
     for(sobject so:ExcelRecs){
         
         if(res.size()<1000)
             res.add(so);
         else{
             OversizeDatamap.put(i,res);
             res= new list<sobject>{so};
                 i++;
         }
         if(res.size()<1000)
             OversizeDatamap.put(i,res);  
         //  System.debug('list'+OversizeDatamap);
         //                 System.debug('Kes'+OversizeDatamap.keyset());
         //System.debug('values'+OversizeDatamap.values().size());
         OversizeDatamapkeys = OversizeDatamap.keyset();
         
     }
 }
 
 
 // @Export Selected.
 public PageReference ColSelectedExcel()
 { 
     
     if(SelectedValues.size() == 0){
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please Select Atleast 1 column'));
         return null;
     }
     Oversizehandler();
     GenerateColSelectedExcel();
     lstConcessions = new List<ConcWrapper>();
     //  return Page.DTNAQuoteActivity_PDF;
     
     PageReference Pref= Page.QuoteActivityConc_Excel;
     Pref.setRedirect(False);
     //  Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=QuoteActivity.pdf');
     
     return Pref;
     
 }
 public PageReference Query() 
 {
     concQuery(' Manual_Archival__c <> TRUE and CONC_STATUS_CD__c in (\'RPC\',\'RPR\',\'PNR\',\'PNC\',\'EXP\',\'APC\',\'APR\')  and Stage__c <> \'Void\' and  Stage__c <> \'Cancelled\' and  (Closed_Status_Date__c > LAST_N_WEEKS:1 OR Closed_Status_Date__c = null) ');
     return null;
 }
 
 public void QueryAll() 
 {
     concQuery(' ( Manual_Archival__c = TRUE or CONC_STATUS_CD__c not in (\'RPC\',\'RPR\',\'PNR\',\'PNC\',\'EXP\',\'APC\',\'APR\') or Stage__c = \'Void\' or Stage__c = \'Cancelled\' or Closed_Status_Date__c <= LAST_N_WEEKS:1 )');
     //return null;
 }
 
 public void RCUInquiryRequest(){}
 
 public void concQuery(String strQueryArg)
 {
     try
     {
         if(lstFilters.size()>0)
         {
             strQuery = 'Select Id,Name,LEAD_CONC_NO__c,Conc_Repls__c,DIST_MGR_NAME__c,Owner.Name,Region_Desc__c,SLS_DIST_CD__c,Stage__c,CUST_NAME_50__c,'
                 + 'Customer_Fleet_Size__c,Dealer_Code__c,CONCMCDB_ENGINE__c,Account__r.Name,Class__c,VEH_BASE_MDL_NO__c,Engine_Mfr__c,CONC_STATUS_CD__c,EXPR_DATE__c,TOT_MIN__c ,RQST_MIN_UNITS__c,'
                 + 'APPR_MIN_UNITS__c,Order_Count__c,Q1__c,Q2__c,Q3__c,Q4__c,Q5__c,DEAL_QUOTE_COUNT__c,Target__c,Probability__c,CONT_PRSN_NAME_42__c,'
                 + 'APPR_CONC_PCT__c,RQST_CONC_PCT__c,APPR_NET_CNTRB__c,CMPTR_CD__c,Account__r.BillingCity,CITY__c,Date_Quoted__c,Approximate_Close_Date__c,Competition_QA__c,'
                 + 'Miscellaneous_Comments__c,PROD_FAM_CD__c,CONCMCDB_MARKET_SEG__c,Create_Date__c,Lost_to_OEM__c,Lost_Reason_Code__c,Per_Unit_Margin__c,'
                 + 'APV__c,TXNCOUN_INDC__c,DOA_Comment_1__c,DOA_Comment_2__c,Manual_Archival__c,Auto_Archived__c,Stage_Activity_Date__c,MDEG_Flag__c  FROM Concession__c  where '
                 + '(NOT Name like \'M%\') and (NOT Name like \'R%\') and (NOT Name like \'Z%\') and SLS_DIST_CD__c <> null and ';
             FilterCond = '';
             CalcQueryString();
             if(strQueryArg == '')
                 FilterCond=FilterCond.left(FilterCond.length()-4);
             else
                 FilterCond = FilterCond + strQueryArg;
             devlog.add(strQueryArg);
             
             strQuery = strQuery + FilterCond;
             con = new ApexPages.StandardSetController(Database.getQueryLocator(strQuery + ' Order By CUST_NAME_50__c,Create_Date__c desc limit 9999'));
             system.debug('**********'+ con.getRecords().size());
             //ExcelRecs= (List<sobject>) Database.Query(strQuery +  ' Order By CUST_NAME_50__c,Create_Date__c desc limit 9999');
             System.debug('ExcelRecs'+ExcelRecs);
             displayFilter=False;
             Selectlistflag = False;
             displayExcelHeader =False;
             QApageNumber = 1;
         }
     }
     catch(Exception e)
     {
         devlog.add(e+e.getStackTraceString());
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getMessage()));
     }
 }
 
 public void CalcQueryString()
 {
     for(Filter varFilt:lstFilters)
     {
         parsedValue = String.escapeSingleQuotes(varFilt.Value);
     
         system.debug('The value of Parsed filter::: ' + parsedValue);
         
         if(fieldTypeOutput.get(varFilt.FieldName) == 'STRING' || fieldTypeOutput.get(varFilt.FieldName) == 'PICKLIST')
         {
             if(varFilt.Operator == ' like ')
             {
                 FilterCond += ' ' + varFilt.FieldName + ' ' + varFilt.Operator + ' \'%' + parsedValue + '%\' and ';
             }
             else if(varFilt.Operator == ' = ' || varFilt.Operator == ' <> ')
             {
                 if(parsedValue.contains(','))
                 {
                     parsedValue =  '(\'' + parsedValue.replace(',','\',\'') + '\')';
                     if(varFilt.Operator == ' = ')
                         FilterCond += ' ' + varFilt.FieldName + ' in ' + parsedValue + ' and ';
                     else
                         FilterCond += ' (not ' + varFilt.FieldName + ' in ' + parsedValue + ') and ';
                 }
                 else
                 {
                     FilterCond += ' ' + varFilt.FieldName + ' ' + varFilt.Operator + ' \'' + parsedValue + '\' and ';
                 }
             }
             else
             {
                 FilterCond = '';
                 throw new QAFilterException('Invalid Operator for the selected field');
             }
         }
         else if(fieldTypeOutput.get(varFilt.FieldName) == 'CURRENCY' || fieldTypeOutput.get(varFilt.FieldName) == 'DOUBLE' || fieldTypeOutput.get(varFilt.FieldName) == 'PERCENT' )
         {
             if(varFilt.Operator != ' like ')
             {
                 FilterCond += ' ' + varFilt.FieldName + ' ' + varFilt.Operator + ' ' + Integer.valueOf(varFilt.Value) + ' and ';
             }
             else
             {
                 throw new QAFilterException('Invalid Operator for the selected field');
             }
         }
         else if(fieldTypeOutput.get(varFilt.FieldName) == 'DATE' || fieldTypeOutput.get(varFilt.FieldName) == 'DATETIME')
         {
             if(varFilt.Operator != ' like ')
             {
                 String[] temp = varFilt.Value.split('/');
                 if(temp[0].length() == 1)
                     temp[0] = '0' + temp[0];
                 if(temp[1].length() == 1)
                     temp[1] = '0' + temp[1];
                 String temp1 = temp[2] + '-' + temp[0] + '-' + temp[1];
                 
                 FilterCond += ' ' + varFilt.FieldName + ' ' + varFilt.Operator + ' ' + temp1 + ' and ';
             }
             else
             {
                 throw new QAFilterException('Invalid Operator for the selected field');
             }
         }
         else if(fieldTypeOutput.get(varFilt.FieldName) == 'BOOLEAN')
         {
             if(varFilt.Operator == ' = ' || varFilt.Operator == ' <> ')
             {
                 FilterCond += ' ' + varFilt.FieldName + ' ' + varFilt.Operator + ' \'' + varFilt.Value + '\' and ';
             }
             else
             {
                 throw new QAFilterException('Invalid Operator for the selected field');
             }
         }
         else
         {
             throw new QAFilterException('Invalid Operator for the selected field');
         }
     }
     
     devlog.add(FilterCond);
 }
 
 public PageReference Filter()
 {
     displayFilter=!displayFilter;
     
     displayExcelCols=False;
     return null;
 }
 
 // @Excel Column Selection
 public PageReference ExcelSelectionListDisplay()
 { 
     displayFilter=false;
     displayExcelCols=true;Selectlistflag=true;
     return null;
 }
 
 
 public void NewFilter() 
 {
     Filter varfilter = new Filter(intFilterAutoNumber++);
     lstFilters.add(varfilter);
     displayFilterHeader=True;
     
 }
 
 public void SetDefaultFilter() 
 {
     Query();
     List<Filter__c>  lstFilterC = [select Id from Filter__c where OwnerId = :strUserId];
     
     for(Filter__c FilterDelete:lstFilterC)
         delete FilterDelete;
     
     Filter__c FilterCreate;
     List<Filter__c> lstFilterCreate = new List<Filter__c>();
     
     for(Filter varfilter:lstFilters)
     {
         FilterCreate = new Filter__c();
         FilterCreate.Filter_Field_Name__c = varfilter.FieldName;
         FilterCreate.Operator__c = varfilter.Operator;
         FilterCreate.Value__c = varfilter.Value;
         lstFilterCreate.add(FilterCreate);
     }
     
     insert lstFilterCreate;
     displayFilterHeader=False;
 }
 
 public PageReference FilterClear() 
 {
     lstFilters.clear();
     displayFilterHeader=False;
     return null;
 }
 
 public PageReference FilterRemove() 
 {
     Integer j = 0;
     devlog.add( 'Attr:' + intDelFilter);
     
     while (j < lstFilters.size())
     {
         if(lstFilters.get(j).Id == intDelFilter)
         {
             lstFilters.remove(j);
             devlog.add('removed' + j);
         }
         j++;
         devlog.add(String.valueof(j));
     }
     if(lstFilters.size() == 0)
         displayFilterHeader=False;
     return null;
 }
 
 public void Save() 
 {
     try
     {    
         //Retrieving Comments and Quaterly Forecast
         QA_Comment_His = new List<Quote_Activity_Comment_History__c>();
         QA_Concession_Forecast = new List<Concession_Forecast__c>();
         
         for(ConcWrapper ObjCW :lstConcessions)
         {
             if (ObjCW.str_DealComment != ObjCW.sObjConc.Miscellaneous_Comments__c)  //Deepak Change for retaining last updated comment
             {
             
                if(ObjCW.str_DealComment <> null && ObjCW.str_DealComment <> '')
                {
                 ObjCW.sObjConc.Miscellaneous_Comments__c = getStrDTNow() + '\r\n' + ObjCW.str_DealComment;
                 obj_QAComment = new Quote_Activity_Comment_History__c();
                 obj_QAComment.ConcessionId__c=ObjCW.sObjConc.id;
                 obj_QAComment.Concession_Number__c=ObjCW.sObjConc.Name;
                 obj_QAComment.Comment__c=ObjCW.str_DealComment;
                 obj_QAComment.RecordTypeId=Schema.SObjectType.Quote_Activity_Comment_History__c.getRecordTypeInfosByName().get('Deal Comments').getRecordTypeId();
                 QA_Comment_His.add(obj_QAComment);
                 System.debug('The value of ObjCW.str_DealComment::: ' + ObjCW.str_DealComment);
                 ObjCW.str_DealComment = '';            
                }
             }
             if (ObjCW.str_DOAComment1 != ObjCW.sObjConc.DOA_Comment_1__c)  //Deepak Change for retaining last updated comment
             {
                 if(ObjCW.str_DOAComment1 <> null && ObjCW.str_DOAComment1 <> '')
                 {
                 ObjCW.sObjConc.DOA_Comment_1__c = getStrDTNow() + '\r\n' + ObjCW.str_DOAComment1;
                 obj_QAComment = new Quote_Activity_Comment_History__c();
                 obj_QAComment.ConcessionId__c=ObjCW.sObjConc.id;
                 obj_QAComment.Concession_Number__c=ObjCW.sObjConc.Name;
                 obj_QAComment.Comment__c=ObjCW.str_DOAComment1;
                 obj_QAComment.RecordTypeId=Schema.SObjectType.Quote_Activity_Comment_History__c.getRecordTypeInfosByName().get('DOA Comment 1').getRecordTypeId();
                 QA_Comment_His.add(obj_QAComment);
                 ObjCW.str_DOAComment1 = '';
                 }
             }
             if (ObjCW.str_DOAComment2 != ObjCW.sObjConc.DOA_Comment_2__c)  //Deepak Change for retaining last updated comment
             {
                 if(ObjCW.str_DOAComment2 <> null && ObjCW.str_DOAComment2 <> '')
                 {  
                 ObjCW.sObjConc.DOA_Comment_2__c = getStrDTNow() + '\r\n' + ObjCW.str_DOAComment2;
                 obj_QAComment = new Quote_Activity_Comment_History__c();
                 obj_QAComment.ConcessionId__c=ObjCW.sObjConc.id;
                 obj_QAComment.Concession_Number__c=ObjCW.sObjConc.Name;
                 obj_QAComment.Comment__c=ObjCW.str_DOAComment2;
                 obj_QAComment.RecordTypeId=Schema.SObjectType.Quote_Activity_Comment_History__c.getRecordTypeInfosByName().get('DOA Comment 2').getRecordTypeId();
                 QA_Comment_His.add(obj_QAComment);
                 ObjCW.str_DOAComment2 = '';
                 }
             }
         }
         
         for (Concession__c sObjConc : (List<Concession__c>)con.getRecords())
         {   
             if(sObjConc.Q1__C <> null)
             {
                 obj_QAForecast = new Concession_Forecast__c();
                 obj_QAForecast.Quarter_Identifier__c = sObjConc.Name + '-' + QuaterlyForecast(0);
                 obj_QAForecast.Concession__c = sObjConc.id;
                 obj_QAForecast.Quantity__c = sObjConc.Q1__C;
                 obj_QAForecast.Quarter_Name__c = QuaterlyForecast(0);
                 QA_Concession_Forecast.add(obj_QAForecast);
             }
             
             if(sObjConc.Q2__C <> null)
             {
                 obj_QAForecast = new Concession_Forecast__c();
                 obj_QAForecast.Quarter_Identifier__c = sObjConc.Name + '-' + QuaterlyForecast(1);
                 obj_QAForecast.Concession__c = sObjConc.id;
                 obj_QAForecast.Quantity__c = sObjConc.Q2__C;
                 obj_QAForecast.Quarter_Name__c = QuaterlyForecast(1);
                 QA_Concession_Forecast.add(obj_QAForecast);
             }
             
             if(sObjConc.Q3__C <> null)
             {
                 obj_QAForecast = new Concession_Forecast__c();
                 obj_QAForecast.Quarter_Identifier__c = sObjConc.Name + '-' + QuaterlyForecast(2);
                 obj_QAForecast.Concession__c = sObjConc.id;
                 obj_QAForecast.Quantity__c = sObjConc.Q3__C;
                 obj_QAForecast.Quarter_Name__c = QuaterlyForecast(2);
                 QA_Concession_Forecast.add(obj_QAForecast);
             }
             
             if(sObjConc.Q4__C <> null)
             {
                 obj_QAForecast = new Concession_Forecast__c();
                 obj_QAForecast.Quarter_Identifier__c = sObjConc.Name + '-' + QuaterlyForecast(3);
                 obj_QAForecast.Concession__c = sObjConc.id;
                 obj_QAForecast.Quantity__c = sObjConc.Q4__C;
                 obj_QAForecast.Quarter_Name__c = QuaterlyForecast(3);
                 QA_Concession_Forecast.add(obj_QAForecast);
             }
             
             if(sObjConc.Q5__C <> null)
             {
                 obj_QAForecast = new Concession_Forecast__c();
                 obj_QAForecast.Quarter_Identifier__c = sObjConc.Name + '-' + QuaterlyForecast(4);
                 obj_QAForecast.Concession__c = sObjConc.id;
                 obj_QAForecast.Quantity__c = sObjConc.Q5__C;
                 obj_QAForecast.Quarter_Name__c = QuaterlyForecast(4);
                 QA_Concession_Forecast.add(obj_QAForecast);
             }
             
         }
         insert QA_Comment_His;
         upsert QA_Concession_Forecast Quarter_Identifier__c;
         
         //Storing History of comments and Quaterly Forecast
         
         QApageNumber = con.getPageNumber();
         con.save();
         con.setpageNumber(QApageNumber);
     }
     catch(Exception e)
     {
         devlog.add(e+e.getStackTraceString());
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getMessage()));
     }
     //return null;
 }
 
 String QuaterlyForecast(Integer QuarterCount)
 {
     Date QuaterDay = Date.today().addMonths(QuarterCount * 3);
     return('Q' + String.valueOf(Math.abs(Math.ceil(Decimal.valueOf(QuaterDay.month()) / 3))) + '-' + String.valueOf(QuaterDay.year()).substring(2, 4));
 }
 
 public PageReference doCancel()
 {
     return con.cancel();
 }
 
 public PageReference changeStageName() 
 {
     return null;
 }
 
 // indicates whether there are more records after the current page set.
 public String hasNext 
 {
     get 
     {
         if(!con.getHasNext())
             return 'disabled';
         else
             return 'true';
     }
     set;
 }
 
 // indicates whether there are more records before the current page set.
 public String hasPrevious 
 {
     get 
     {
         if(!con.getHasPrevious())
             return 'disabled';
         else
             return 'true';
     }
     set;
 }
 
 // returns the page number of the current page set
 public Integer pageNumber 
 {
     get 
     {
         QApageNumber = con.getPageNumber();
         return con.getPageNumber();
     }
     set;
 }
 
 // returns the first page of records
 public void first() 
 {
     try
     {
         con.first();
         QApageNumber = con.getPageNumber();
     }
     catch(Exception e)
     {
         devlog.add(e+e.getStackTraceString());
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getMessage()));
     }
 }
 
 // returns the last page of records
 public void last() 
 {
     try
     {
         con.last();
         QApageNumber = con.getPageNumber();
     }
     catch(Exception e)
     {
         devlog.add(e+e.getStackTraceString());
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getMessage()));
     }
 }
 
 public decimal getQALastPageNumber() 
 {   
     decimal temp= (decimal)con.getResultSize()/20;
     return(temp.round(System.RoundingMode.CEILING));
 }
 
 // returns the previous page of records
 public void previous()
 {
     try
     {
         con.previous();
         QApageNumber = con.getPageNumber();
     }
     catch(Exception e)
     {
         devlog.add(e+e.getStackTraceString());
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getMessage()));
     }
 }
 
 // returns the next page of records
 public void next()
 {
     try
     {
     system.debug('conc get data:::'+ con.getRecords().size());
     system.debug('the con.getPageNumber()  :::' +con.getPageNumber());
     system.debug('the value of conc:::  ' + con);
      con.next();
      system.debug('afeter con.next;');
         QApageNumber = con.getPageNumber();
     }
     catch(Exception e)
     {
      
        devlog.add(e+e.getStackTraceString());
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getMessage()));
         
     }
 }
 
 
 public void GotoPage() 
 {
     try
     {
         con.setpageNumber(QApageNumber);
         QApageNumber = con.getPageNumber();
     }
     catch(Exception e)
     {
         devlog.add(e+e.getStackTraceString());
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,e.getMessage()));
     }
 }
 
 // returns the PageReference of the original page, if known, or the home page.
 public void cancel()
 {
     con.cancel();
 }
 
 public pageReference openPage()
 {
     pageReference pg = new pageReference('/apex/QuoteActivityConc');
     pg.setRedirect(true);
     return pg;
 }
 //Deepak Change start
  public pageReference openPageMobile()
 {
     pageReference pg = new pageReference('/apex/QuoteActivityConcMobile');
     pg.setRedirect(true);
     return pg;
 }
  //Deepak Change end
 
 public String getStrDTNow()  
 {    
     DateTime DTNow = DateTime.now();
     String StrDTNow = DTNow.format('MM/dd/yyyy HH:mm:ss ', UserInfo.getTimeZone().toString());
     string fullStrTimeZone = UserInfo.getTimeZone().getDisplayName();
     string[] strTZ = fullStrTimeZone.split(' ');
     
     return UserInfo.getName() + ' ' + StrDTNow + ' ' + strTZ[0].Left(1) + strTZ[1].Left(1) + strTZ[2].Left(1);
 }
 
 
}