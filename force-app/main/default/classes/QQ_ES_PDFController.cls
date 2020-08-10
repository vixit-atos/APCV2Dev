public class QQ_ES_PDFController
{
    public static string recordID{get; set;}    
    public string ExpirationDate{get; set;}
    public string EffectiveDate{get; set;}
    public string DateQuoted{get; set;}
    public string Customer{get; set;}
    
    public boolean DC_Flag{get; set;}
    public boolean TC_Flag{get; set;}
    public boolean FC_Flag{get; set;}
    
    public string PolicyID_1{get; set;}
    public string PolicyID_2{get; set;}
    public string PolicyID_3{get; set;}
    public string Policy1_size{get; set;}
    public string Policy2_size{get; set;}
    public string Policy3_size{get; set;}
    public string Disclaimer{get; set;}
    
    //------ DETROIT COVERAGE ------
    public class DetroitCoverage
    {
        public string DC_Coverage{get; set;}
        public string DC_Application{get; set;}
        public string DC_Product{get; set;}
        public string DC_Component{get; set;}
        public string DC_Term{get; set;}
        public string DC_Deductible{get; set;}
        public string DC_NetPrice{get; set;}
        public string DC_DBCode{get; set;}
    }
    
    //------ TRUCK CHASSIS ------
    public class TruckChassis
    {
        public string TC_Group{get; set;}
        public string TC_Model{get; set;}
        public string TC_Level{get; set;}
        public string TC_Standalone{get; set;}
        public string TC_Package{get; set;}
        public string TC_Term{get; set;}
        public string TC_NetPrice{get; set;}
        public string TC_DBCode{get; set;}
    }
    
    //------ FCCC/TBB ------
    public class FccTbb
    {
        public string FC_Group{get; set;}
        public string FC_Model{get; set;}
        public string FC_Standalone{get; set;}
        public string FC_Term{get; set;}
        public string FC_NetPrice{get; set;}
        public string FC_DBCode{get; set;}
    }
    
    //------ POLICY MANUAL ------
    public class Policy
    {
        public string fileName{get; set;}
        public string fileID{get; set;}
        public string fileSize{get; set;}
    }
    
    public List<DetroitCoverage> DC_List{get; set;}
    public List<TruckChassis> TC_List{get; set;}
    public List<FccTbb> FCC_List{get; set;}
    
    public QQ_ES_PDFController()
    {
        try
        {
            DC_Flag = false;
            TC_Flag = false;
            FC_Flag = false;
            PolicyID_1 = '';
            PolicyID_2 = '';
            PolicyID_3 = '';
            QQ_Util util = new QQ_Util();
            
            string UI_Type = '';
            if(!Test.isRunningTest())
            {
                recordID = (ApexPages.currentPage().getParameters().get('recordID') != 'undefined')?ApexPages.currentPage().getParameters().get('recordID') : '';
                UI_Type = (ApexPages.currentPage().getParameters().get('UI_Type') != 'undefined')?ApexPages.currentPage().getParameters().get('UI_Type') : '';
            }
            
            ASP_QQ__c quote = new ASP_QQ__c();
            if(recordID.length() >= 15)
            {
                quote = [SELECT  ID,
                           Name,
                           Expiration_Date__c,
                           From_Date__c,
                           Customer_Name__r.Name,
                           FMV_Date__c,
                           Mgmt_Approved_On__c,
                           CreatedDate
                           FROM ASP_QQ__c
                           WHERE ID = :recordID];
            }
            else
            {
                quote = [SELECT  ID,
                           Name,
                           Expiration_Date__c,
                           From_Date__c,
                           Customer_Name__r.Name,
                           FMV_Date__c,
                           Mgmt_Approved_On__c,
                           CreatedDate
                           FROM ASP_QQ__c
                           WHERE Name = :recordID];     
            }
            
            Disclaimer = getDisclaimer(UI_Type, quote);
            
            List<Policy> lstPolicyInfo = new List<Policy>();
            lstPolicyInfo = getPolicyInfo();
            integer i = 0;
            for(Policy policyInfo : lstPolicyInfo)
            {
                if(policyInfo.FileName == 'Policy Manual-1.jpg')
                {
                    PolicyID_1 = policyInfo.fileID;
                    Policy1_size = policyInfo.fileSize;
                }
                if(policyInfo.FileName == 'Policy Manual-2.jpg')
                {
                    PolicyID_2 = policyInfo.fileID;
                    Policy2_size = policyInfo.fileSize;
                }
                if(policyInfo.FileName == 'Policy Manual-3.jpg')
                {
                    PolicyID_3 = policyInfo.fileID;
                    Policy3_size = policyInfo.fileSize;
                }
            }
            
            
            recordID = quote.Name;
            Date expDate = quote.Expiration_Date__c;
            string sMonth = (string.isNotBlank(string.valueOf(quote.Expiration_Date__c)))?util.getMonth(expDate) : '';
            string sDate = (string.isNotBlank(string.valueOf(quote.Expiration_Date__c)))?string.valueOf(expDate.Day()) : '';
            string sYear = (string.isNotBlank(string.valueOf(quote.Expiration_Date__c)))?string.valueOf(expDate.Year()) : '';
            ExpirationDate =  sMonth + ' ' + sDate + ', ' + sYear;
            ExpirationDate = (ExpirationDate.trim() != ',')?ExpirationDate : '';
            
            DateTime createdDate = quote.CreatedDate;
            sMonth = (string.isNotBlank(string.valueOf(quote.CreatedDate)))?util.getMonth(Date.newInstance(createdDate.year(), createdDate.month(), createdDate.day())) : '';
            sDate = (string.isNotBlank(string.valueOf(quote.CreatedDate)))?string.valueOf(createdDate.day()) : '';
            sYear = (string.isNotBlank(string.valueOf(quote.CreatedDate)))?string.valueOf(CreatedDate.Year()) : '';
            DateQuoted = sMonth + ' ' + sDate + ', ' + sYear;
            DateQuoted = (DateQuoted.trim() != ',')?DateQuoted : '';
            
            Date fmvDate = quote.FMV_Date__c;
            sMonth = (string.isNotBlank(string.valueOf(quote.FMV_Date__c)))?util.getMonth(fmvDate) : '';
            sDate = (string.isNotBlank(string.valueOf(quote.FMV_Date__c)))?string.valueOf(fmvDate.Day()) : '';
            sYear = (string.isNotBlank(string.valueOf(quote.FMV_Date__c)))?string.valueOf(fmvDate.Year()) : '';
            EffectiveDate = sMonth.toUpperCase() + ' ' + sDate + ', ' + sYear;
            EffectiveDate = (EffectiveDate.trim() != ',')?EffectiveDate : '';
            
            Customer = (string.isNotBlank(string.valueOf(quote.Customer_Name__r.Name)))?string.valueOf(quote.Customer_Name__r.Name) : '';
            
            
            List<ASP_QQ_Line_Item__c> QQ_DC_Line_Items = [SELECT ID,
                                                          Name,
                                                          Coverage_Type_1__c,
                                                          Usage__c,
                                                          Option_1__c,
                                                          Engine_Component_1__c,
                                                          Custom__c,
                                                          Duration_Final__c,
                                                          Deductible_1__c,
                                                          Price__c,
                                                          Databook_Code__c
                                                          FROM ASP_QQ_Line_Item__c
                                                          WHERE Coverage__c = 'Detroit Coverage' AND ASP_QQ__r.Name = :recordID];
            
            DetroitCoverage DC;
            List<DetroitCoverage> lstDC = new List<DetroitCoverage>();
            for(ASP_QQ_Line_Item__c QQ:QQ_DC_Line_Items)
            {
                DC_Flag = true;
                DC = new DetroitCoverage();
                DC.DC_Coverage = (string.isNotBlank(string.valueOf(QQ.Coverage_Type_1__c)))?string.valueOf(QQ.Coverage_Type_1__c) : '';
                DC.DC_Application = (string.isNotBlank(string.valueOf(QQ.Usage__c)))?string.valueOf(QQ.Usage__c) : '';
                DC.DC_Product = (string.isNotBlank(string.valueOf(QQ.Option_1__c)))?string.valueOf(QQ.Option_1__c) : '';
                DC.DC_Component = (string.isNotBlank(string.valueOf(QQ.Engine_Component_1__c)))?string.valueOf(QQ.Engine_Component_1__c) : '';
                DC.DC_Term = (string.isNotBlank(string.valueOf(QQ.Duration_Final__c)))?string.valueOf(QQ.Duration_Final__c) : '';            
                DC.DC_Deductible = (string.isNotBlank(string.valueOf(QQ.Deductible_1__c)))?string.valueOf(QQ.Deductible_1__c) : '';
                DC.DC_NetPrice = (string.isNotBlank(string.valueOf(QQ.Price__c)))?util.formatPrice(Double.valueOf(QQ.Price__c), 'PRICE'):'$ 0.00 USD';
                DC.DC_DBCode = (string.isNotBlank(string.valueOf(QQ.Databook_Code__c)))?string.valueOf(QQ.Databook_Code__c) : '';
                lstDC.add(DC);
            }
            DC_List = lstDC;
            
            List<ASP_QQ_Line_Item__c> QQ_TC_Line_Items = [SELECT ID,
                                                          Name,
                                                          Group__c,
                                                          //Model__c,
                                                          Chassis_Model__c,
                                                          Level__c,
                                                          Standalone_Package_1__c,
                                                          Truck_Coverage_Package_1__c,
                                                          Custom__c,
                                                          Duration_Final__c,
                                                          Price__c,
                                                          Databook_Code__c
                                                          FROM ASP_QQ_Line_Item__c
                                                          WHERE Coverage__c = 'Truck Chassis' AND ASP_QQ__r.Name = :recordID];
            
            TruckChassis TC;
            List<TruckChassis> lstTC = new List<TruckChassis>();
            for(ASP_QQ_Line_Item__c QQ:QQ_TC_Line_Items)
            {
                TC_Flag = true;
                TC = new TruckChassis();
                TC.TC_Group = (string.isNotBlank(string.valueOf(QQ.Group__c)))?string.valueOf(QQ.Group__c) : '';
                TC.TC_Model = (string.isNotBlank(string.valueOf(QQ.Chassis_Model__c)))?string.valueOf(QQ.Chassis_Model__c) : '';
                TC.TC_Level = (string.isNotBlank(string.valueOf(QQ.Level__c)))?string.valueOf(QQ.Level__c) : '';
                TC.TC_Standalone = (string.isNotBlank(string.valueOf(QQ.Standalone_Package_1__c)))?string.valueOf(QQ.Standalone_Package_1__c) : '';
                TC.TC_Package = (string.isNotBlank(string.valueOf(QQ.Truck_Coverage_Package_1__c)))?string.valueOf(QQ.Truck_Coverage_Package_1__c) : '';
                TC.TC_Term =  (string.isNotBlank(string.valueOf(QQ.Duration_Final__c)))?string.valueOf(QQ.Duration_Final__c) : '';
                TC.TC_NetPrice = (string.isNotBlank(string.valueOf(QQ.Price__c)))?util.formatPrice(Double.valueOf(QQ.Price__c), 'PRICE'):'$ 0.00 USD';
                TC.TC_DBCode = (string.isNotBlank(string.valueOf(QQ.Databook_Code__c)))?string.valueOf(QQ.Databook_Code__c) : '';
                lstTC.add(TC);
            }
            TC_List = lstTC;
            
            List<ASP_QQ_Line_Item__c> QQ_FCCC_Line_Items = [SELECT ID,
                                                            Name,
                                                            Group__c,
                                                            //Model__c,
                                                            Chassis_Model__c,
                                                            Standalone_Package_1__c,
                                                            Custom__c,
                                                            Duration_Final__c,
                                                            Price__c,
                                                            Databook_Code__c
                                                            FROM ASP_QQ_Line_Item__c
                                                            WHERE( Coverage__c = 'FCCC'OR Coverage__c = 'FCCC-TBB')AND ASP_QQ__r.Name = :recordID];
            
            FccTbb FCC;
            List<FccTbb> lstFCC = new List<FccTbb>();
            for(ASP_QQ_Line_Item__c QQ:QQ_FCCC_Line_Items)
            {
                FC_Flag = true;
                FCC = new FccTbb();
                FCC.FC_Group = (string.isNotBlank(string.valueOf(QQ.Group__c)))?string.valueOf(QQ.Group__c) : '';
                FCC.FC_Model = (string.isNotBlank(string.valueOf(QQ.Chassis_Model__c)))?string.valueOf(QQ.Chassis_Model__c) : '';
                FCC.FC_Standalone = (string.isNotBlank(string.valueOf(QQ.Standalone_Package_1__c)))?string.valueOf(QQ.Standalone_Package_1__c) : '';
                FCC.FC_Term = (string.isNotBlank(string.valueOf(QQ.Duration_Final__c)))?string.valueOf(QQ.Duration_Final__c) : '';
                FCC.FC_NetPrice = (string.isNotBlank(string.valueOf(QQ.Price__c)))?util.formatPrice(Double.valueOf(QQ.Price__c), 'PRICE'):'$ 0.00 USD';
                FCC.FC_DBCode = (string.isNotBlank(string.valueOf(QQ.Databook_Code__c)))?string.valueOf(QQ.Databook_Code__c) : '';
                lstFCC.add(FCC);
            }
            FCC_List = lstFCC;
            
            if(DC_Flag == false && TC_Flag == false && FC_Flag == false)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There is nothing to display, please check quote number.'));
        }
        catch(Exception exp)
        {
            system.debug('Line No: ' + exp.getLineNumber() + ' Error: ' + exp.getMessage());
        }
    }
    
    public string getDisclaimer(string UI_Type, ASP_QQ__c quote)
    {     
        string Disclaimer = 'Disclaimer is not available for this quote. Please contact your administrator.';
        try
        {
            if(UI_Type.toUpperCase() == 'EXTERNAL')
            {
                DateTime CD = quote.CreatedDate;
                Date Created_Date = Date.newInstance(CD.year(), CD.month(), CD.day());
                
                Disclaimer = [SELECT ID,
                              Quote_Type__c,
                              Disclaimers__c,
                              Active__c
                              FROM Administrative_Tool__c
                              WHERE Quote_Type__c = 'Extended Coverage' AND
                              RecordType.Name = 'PDF Disclaimer Management' AND
                              Disclaimer_From_Date__c <= :Created_Date AND
                              Disclaimer_To_Date__c >= :Created_Date
                              //AND Active__c = true 
                              ORDER BY LastModifiedDate DESC LIMIT 1].Disclaimers__c;
            }
            if(UI_Type.toUpperCase() == 'INTERNAL')
            {                
                DateTime MAD = quote.Mgmt_Approved_On__c;
                Date Mgmt_Approved_Date = Date.newInstance(MAD.year(), MAD.month(), MAD.day());
                
                Disclaimer = [SELECT ID,
                              Quote_Type__c,
                              Disclaimers__c,
                              Active__c
                              FROM Administrative_Tool__c
                              WHERE Quote_Type__c = 'Extended Coverage' AND
                              RecordType.Name = 'PDF Disclaimer Management' AND
                              Disclaimer_From_Date__c <= :Mgmt_Approved_Date AND
                              Disclaimer_To_Date__c >= :Mgmt_Approved_Date
                              //AND Active__c = true 
                              ORDER BY LastModifiedDate DESC LIMIT 1].Disclaimers__c;
            }
        }
        catch(Exception exp)
        {
            system.debug('Line: ' + exp.getLineNumber() + ', Error: ' + exp.getMessage());
        }
        return Disclaimer;
    }
    
    public List<Policy> getPolicyInfo()
    {
        List<Policy> lstPolicyInfo = new List<Policy>();
        
        try
        {
            Attachment lstAttach1 = [SELECT ID,
                                     Name,
                                     parentId,
                                     Body,
                                     ContentType,
                                     Description,
                                     CreatedDate
                                     FROM Attachment 
                                     WHERE Description LIKE '%Extended Coverage%' AND
                                     Name = 'Policy Manual-1.jpg'
                                     ORDER BY CreatedDate DESC LIMIT 1];
            
            Policy policyInfo1 = new Policy();
            policyInfo1.fileID = lstAttach1.ID;
            policyInfo1.FileName = lstAttach1.Name;
            string Desc_1 = lstAttach1.Description;
            string[] Desc_Array1 = Desc_1.split('-');
            policyInfo1.fileSize = Desc_Array1[0];
            lstPolicyInfo.add(policyInfo1);
        }
        catch(Exception exp)
        {
            system.debug('Line: ' + exp.getLineNumber() + ', Error: ' + exp.getMessage());
        }
        
        try
        {
            Attachment lstAttach2 = [SELECT ID,
                                     Name,
                                     parentId,
                                     Body,
                                     ContentType,
                                     Description,
                                     CreatedDate
                                     FROM Attachment 
                                     WHERE Description LIKE '%Extended Coverage%' AND
                                     Name = 'Policy Manual-2.jpg'
                                     ORDER BY CreatedDate DESC LIMIT 1];
            
            Policy policyInfo2 = new Policy();
            policyInfo2.fileID = lstAttach2.ID;
            policyInfo2.FileName = lstAttach2.Name;
            string Desc_2 = lstAttach2.Description;
            string[] Desc_Array2 = Desc_2.split('-');
            policyInfo2.fileSize = Desc_Array2[0];
            lstPolicyInfo.add(policyInfo2);
        }
        catch(Exception exp)
        {
            system.debug('Line: ' + exp.getLineNumber() + ', Error: ' + exp.getMessage());
        }
        
        try
        { 
            Attachment lstAttach3 = [SELECT ID,
                                     Name,
                                     parentId,
                                     Body,
                                     ContentType,
                                     Description,
                                     CreatedDate
                                     FROM Attachment 
                                     WHERE Description LIKE '%Extended Coverage%' AND
                                     Name = 'Policy Manual-3.jpg'
                                     ORDER BY CreatedDate DESC LIMIT 1];
            
            Policy policyInfo3 = new Policy();
            policyInfo3.fileID = lstAttach3.ID;
            policyInfo3.FileName = lstAttach3.Name;
            string Desc_3 = lstAttach3.Description;
            string[] Desc_Array3 = Desc_3.split('-');
            policyInfo3.fileSize = Desc_Array3[0];
            lstPolicyInfo.add(policyInfo3);
        }
        catch(Exception exp)
        {
            system.debug('Line: ' + exp.getLineNumber() + ', Error: ' + exp.getMessage());
        }
        
        return lstPolicyInfo;
    }
}