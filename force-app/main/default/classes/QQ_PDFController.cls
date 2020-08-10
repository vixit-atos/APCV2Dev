public class QQ_PDFController
{
    public static string recordID{get; set;}    
    public string ExpirationDate{get; set;}
    public string EffectiveDate{get; set;}
    public string DateQuoted{get; set;}
    public string Customer{get; set;}
    
    public boolean DC_Flag{get; set;}
    public boolean TC_Flag{get; set;}
    public boolean FC_Flag{get; set;}
    
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
    
    public List<DetroitCoverage> DC_List{get; set;}
    public List<TruckChassis> TC_List{get; set;}
    public List<FccTbb> FCC_List{get; set;}
        
    public QQ_PDFController()
    {
        try
        {
            DC_Flag = false;
            TC_Flag = false;
            FC_Flag = false;
            QQ_Util util = new QQ_Util();
            
            if(!Test.isRunningTest())
                recordID = (ApexPages.currentPage().getParameters().get('recordID') != 'undefined')?ApexPages.currentPage().getParameters().get('recordID') : '';
                        
            List<ASP_QQ__c> QQ_List = [SELECT  ID,
                                       Name,
                                       Expiration_Date__c,
                                       CreatedDate,
                                       From_Date__c,
                                       Customer_Name__r.Name,
                                       FMV_Date__c
                                       FROM ASP_QQ__c
                                       WHERE Name = :recordID];
            
            for(ASP_QQ__c QQ:QQ_List)
            {
                Date expDate = QQ.Expiration_Date__c;
                string sMonth = (string.isNotBlank(string.valueOf(QQ.Expiration_Date__c)))?util.getMonth(expDate) : '';
                string sDate = (string.isNotBlank(string.valueOf(QQ.Expiration_Date__c)))?string.valueOf(expDate.Day()) : '';
                string sYear = (string.isNotBlank(string.valueOf(QQ.Expiration_Date__c)))?string.valueOf(expDate.Year()) : '';
                ExpirationDate =  sMonth + ' ' + sDate + ', ' + sYear;
                ExpirationDate = (ExpirationDate.trim() != ',')?ExpirationDate : '';
                
                DateTime createdDate = QQ.CreatedDate;
                sMonth = (string.isNotBlank(string.valueOf(QQ.CreatedDate)))?util.getMonth(Date.newInstance(createdDate.year(), createdDate.month(), createdDate.day())) : '';
                sDate = (string.isNotBlank(string.valueOf(QQ.CreatedDate)))?string.valueOf(createdDate.day()) : '';
                sYear = (string.isNotBlank(string.valueOf(QQ.CreatedDate)))?string.valueOf(CreatedDate.Year()) : '';
                DateQuoted = sMonth + ' ' + sDate + ', ' + sYear;
                DateQuoted = (DateQuoted.trim() != ',')?DateQuoted : '';
                
                Date fmvDate = QQ.FMV_Date__c;
                sMonth = (string.isNotBlank(string.valueOf(QQ.FMV_Date__c)))?util.getMonth(fmvDate) : '';
                sDate = (string.isNotBlank(string.valueOf(QQ.FMV_Date__c)))?string.valueOf(fmvDate.Day()) : '';
                sYear = (string.isNotBlank(string.valueOf(QQ.FMV_Date__c)))?string.valueOf(fmvDate.Year()) : '';
                EffectiveDate = sMonth.toUpperCase() + ' ' + sDate + ', ' + sYear;
                EffectiveDate = (EffectiveDate.trim() != ',')?EffectiveDate : '';
                
                Customer = (string.isNotBlank(string.valueOf(QQ.Customer_Name__r.Name)))?string.valueOf(QQ.Customer_Name__r.Name) : '';
            }
            
            List<ASP_QQ_Line_Item__c> QQ_DC_Line_Items = [SELECT ID,
                                                          Name,
                                                          Coverage__c,
                                                          Usage__c,
                                                          Option__c,
                                                          Engine_Component__c,
                                                          Custom__c,
                                                          Duration_Final__c,
                                                          Deductible__c,
                                                          Price__c,
                                                          Databook_Code__c
                                                          FROM ASP_QQ_Line_Item__c
                                                          WHERE Coverage__c = 'Detroit Engine' AND ASP_QQ__r.Name = :recordID];
            
            DetroitCoverage DC;
            List<DetroitCoverage> lstDC = new List<DetroitCoverage>();
            for(ASP_QQ_Line_Item__c QQ:QQ_DC_Line_Items)
            {
                DC_Flag = true;
                DC = new DetroitCoverage();
                DC.DC_Coverage = (string.isNotBlank(string.valueOf(QQ.Coverage__c)))?string.valueOf(QQ.Coverage__c) : '';
                DC.DC_Application = (string.isNotBlank(string.valueOf(QQ.Usage__c)))?string.valueOf(QQ.Usage__c) : '';
                DC.DC_Product = (string.isNotBlank(string.valueOf(QQ.Option__c)))?string.valueOf(QQ.Option__c) : '';
                DC.DC_Component = (string.isNotBlank(string.valueOf(QQ.Engine_Component__c)))?string.valueOf(QQ.Engine_Component__c) : '';
                DC.DC_Term = (string.isNotBlank(string.valueOf(QQ.Duration_Final__c)))?string.valueOf(QQ.Duration_Final__c) : '';            
                DC.DC_Deductible = (string.isNotBlank(string.valueOf(QQ.Deductible__c)))?string.valueOf(QQ.Deductible__c) : '';
                DC.DC_NetPrice = (string.isNotBlank(string.valueOf(QQ.Price__c)))?util.formatPrice(Double.valueOf(QQ.Price__c)):'$ 0.00 USD';
                DC.DC_DBCode = (string.isNotBlank(string.valueOf(QQ.Databook_Code__c)))?string.valueOf(QQ.Databook_Code__c) : '';
                lstDC.add(DC);
            }
            DC_List = lstDC;
            
            List<ASP_QQ_Line_Item__c> QQ_TC_Line_Items = [SELECT ID,
                                                          Name,
                                                          Group__c,
                                                          Model__c,
                                                          Level__c,
                                                          Standalone_Coverage__c,
                                                          Truck_Coverage_Package__c,
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
                TC.TC_Model = (string.isNotBlank(string.valueOf(QQ.Model__c)))?string.valueOf(QQ.Model__c) : '';
                TC.TC_Level = (string.isNotBlank(string.valueOf(QQ.Level__c)))?string.valueOf(QQ.Level__c) : '';
                TC.TC_Standalone = (string.isNotBlank(string.valueOf(QQ.Standalone_Coverage__c)))?string.valueOf(QQ.Standalone_Coverage__c) : '';
                TC.TC_Package = (string.isNotBlank(string.valueOf(QQ.Truck_Coverage_Package__c)))?string.valueOf(QQ.Truck_Coverage_Package__c) : '';
                TC.TC_Term =  (string.isNotBlank(string.valueOf(QQ.Duration_Final__c)))?string.valueOf(QQ.Duration_Final__c) : '';
                TC.TC_NetPrice = (string.isNotBlank(string.valueOf(QQ.Price__c)))?util.formatPrice(Double.valueOf(QQ.Price__c)):'$ 0.00 USD';
                TC.TC_DBCode = (string.isNotBlank(string.valueOf(QQ.Databook_Code__c)))?string.valueOf(QQ.Databook_Code__c) : '';
                lstTC.add(TC);
            }
            TC_List = lstTC;
            
            List<ASP_QQ_Line_Item__c> QQ_FCCC_Line_Items = [SELECT ID,
                                                            Name,
                                                            Group__c,
                                                            Model__c,
                                                            Standalone_Coverage__c,
                                                            Custom__c,
                                                            Duration_Final__c,
                                                            Price__c,
                                                            Databook_Code__c
                                                            FROM ASP_QQ_Line_Item__c
                                                            WHERE Coverage__c = 'FCCC' AND ASP_QQ__r.Name = :recordID];
            
            FccTbb FCC;
            List<FccTbb> lstFCC = new List<FccTbb>();
            for(ASP_QQ_Line_Item__c QQ:QQ_FCCC_Line_Items)
            {
                FC_Flag = true;
                FCC = new FccTbb();
                FCC.FC_Group = (string.isNotBlank(string.valueOf(QQ.Group__c)))?string.valueOf(QQ.Group__c) : '';
                FCC.FC_Model = (string.isNotBlank(string.valueOf(QQ.Model__c)))?string.valueOf(QQ.Model__c) : '';
                FCC.FC_Standalone = (string.isNotBlank(string.valueOf(QQ.Standalone_Coverage__c)))?string.valueOf(QQ.Standalone_Coverage__c) : '';
                FCC.FC_Term = (string.isNotBlank(string.valueOf(QQ.Duration_Final__c)))?string.valueOf(QQ.Duration_Final__c) : '';
                FCC.FC_NetPrice = (string.isNotBlank(string.valueOf(QQ.Price__c)))?util.formatPrice(Double.valueOf(QQ.Price__c)):'$ 0.00 USD';
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
}