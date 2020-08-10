public class QQ_PM_PDFController
{
    public static string recordID{get; set;}    
    public string ExpirationDate{get; set;}
    public string EffectiveDate{get; set;}
    public string DateQuoted{get; set;}
    public string Customer{get; set;}
    
    public boolean PM_Flag{get; set;}
    public boolean TRANS_Flag{get; set;}
    public boolean ATS_Flag{get; set;}
    public boolean PM_AddOn{get; set;}
    
    //------ PACKAGE DETAILS ------
    public class PackageDetails
    {
        public string PD_QuoteNo{get; set;}
        public string PD_Package{get; set;}
        public string PD_EngineModel{get; set;}
        public string PD_DutyCycle{get; set;}
        public string PD_ServiceIntervals{get; set;}
        public string PD_AirFilter{get; set;}
        public string PD_TermDuration{get; set;}
        public string PD_NetPrice{get; set;}
        public string PD_Price{get; set;}
        public string PD_DbCode{get; set;}    
        public list<AddOns> AddOns_List{get; set;}
        public boolean PD_AddOns_Flag{get; set;}
        public list<OMS> OMS_List{get; set;}
        public boolean PD_OMS_Flag{get; set;}
    }
    public class AddOns
    { 
        public string AO_AddOns{get; set;}
        public string AO_Manufacturer{get; set;}
        public string AO_OfferMaster{get; set;}
        public string AO_Service{get; set;}
        public string AO_Price{get; set;}
        public string AO_DBCode{get; set;}
        public string AO_Service_Interval_Months{get; set;}
        public string AO_Service_Interval_Miles{get; set;}
    }
    //------ TRANSMISSION ------
    public class Transmission
    { 
        public string T_Manufacturer{get; set;}
        public string T_Model{get; set;}
        public string T_Service_Interval{get; set;}
        public string T_Duration{get; set;}
        public string T_TotalPrice{get; set;}
        public string T_DBCode{get; set;}
        public list<TSI> TSI_List{get; set;}
        public boolean T_TSI_Flag{get; set;}
    }
    //------ AFTER TREATMENT SERVICE ------
    public class ATS
    {
        public string ATS_EngineModel{get; set;}
        public string ATS_Service{get; set;}
        public string ATS_Duration{get; set;}
        public string ATS_TotalPrice{get; set;}
        public string ATS_DBCode{get; set;}
        public list<ATSI> ATSI_List{get; set;}
        public boolean ATS_ATSI_Flag{get; set;}
    }
    //------ PM SERVICE INCLUDED (OFFER MASTER SERVICE) ------
    public class OMS
    {
        public string OMS_ServiceType{get; set;}
        public string OMS_ServiceFrequency{get; set;}
        public string OMS_MonthsInterval{get; set;}
        public string OMS_MilesInterval{get; set;}
    }
    //------ TRANSMISSION SERVICE INCLUDED ------
    public class TSI
    {
        public string TSI_ServiceType{get; set;}
        public string TSI_ServiceFrequency{get; set;}
        public string TSI_MonthsInterval{get; set;}
        public string TSI_MilesInterval{get; set;}
    }
    //------ AFTER TREATMENT SERVICE INCLUDED ------
    public class ATSI
    {
        public string ATSI_ServiceType{get; set;}
        public string ATSI_ServiceFrequency{get; set;}
        public string ATSI_MonthsInterval{get; set;}
        public string ATSI_MilesInterval{get; set;}
    }
    
    public List<PackageDetails> PM_List{get; set;}
    public List<Transmission> TRANS_List{get; set;}
    public List<ATS> ATS_List{get; set;}
    
    public QQ_PM_PDFController()
    {
        try
        {
            PM_Flag = false;
            TRANS_Flag = false;
            ATS_Flag = false;
            PM_AddOn = false;
            QQ_Util util = new QQ_Util();
            
            if(!Test.isRunningTest())
                recordID = (ApexPages.currentPage().getParameters().get('recordID') != 'undefined')?ApexPages.currentPage().getParameters().get('recordID') : '';
            
            List<ASP_QQ__c> QQ_List = new List<ASP_QQ__c>();
            if(recordID.length() >= 15)
            {
                QQ_List = [SELECT  ID,
                           Name,
                           Expiration_Date__c,
                           From_Date__c,
                           Customer_Name__r.Name,
                           FMV_Date__c,
                           CreatedDate
                           FROM ASP_QQ__c
                           WHERE ID = :recordID];
            }
            else
            {
                QQ_List = [SELECT  ID,
                           Name,
                           Expiration_Date__c,
                           From_Date__c,
                           Customer_Name__r.Name,
                           FMV_Date__c,
                           CreatedDate
                           FROM ASP_QQ__c
                           WHERE Name = :recordID];     
            }
            
            for(ASP_QQ__c QQ:QQ_List)
            {
                recordID = QQ.Name;
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
            
            List<ASP_PM_Line_Items__c> PM_PackageDetails = [SELECT ID,
                                                            Name,
                                                            ASP_QQ__r.Name,
                                                            Package__c,
                                                            Engine_Model__c,
                                                            Duty_Cycle__c,
                                                            Service_Interval__c,
                                                            Air_Filter__c,
                                                            Duration__c,
                                                            Databook_Code__c,
                                                            DB_Code__c,
                                                            Add_Ons__c,
                                                            Manufacturer__c,
                                                            Service__c,
                                                            Price__c,
                                                            Total_Price__c,
                                                            Program__c,
                                                            Offer__c,
                                                            (
                                                                SELECT Add_On__c,
                                                                Databook_Code__c,
                                                                Manufacturer__c,
                                                                Offer_Master_Id__c,
                                                                Price__c,
                                                                Service_Name__c
                                                                FROM PM_Line_Item_AddOns__r
                                                            )
                                                            FROM ASP_PM_Line_Items__c
                                                            WHERE Program__c = 'PACKAGE' AND ASP_QQ__r.Name = :recordID];
            
            //--------------------------  LOGIC FOR OFFER MASTER SERVICE  ------------------
            OMS oms;
            List<OMS> lstOMS;
            map<string, List<OMS>> mOMS = new map<string, List<OMS>>();
            ASP_PM_Coverage_Master__c PMCM = new ASP_PM_Coverage_Master__c();
            ASP_PM_Coverage_Master__c PMCM_AddOns = new ASP_PM_Coverage_Master__c();
            
            for(ASP_PM_Line_Items__c PM:PM_PackageDetails)
            {
                lstOMS = new List<OMS>();
                PMCM = [SELECT ID
                        FROM ASP_PM_Coverage_Master__c
                        WHERE RecordType.Name = 'Package' AND
                        Package__c = :PM.Package__c AND 
                        Engine_Model__c = :PM.Engine_Model__c AND
                        Duty_Cycle__c = :PM.Duty_Cycle__c AND 
                        Name = :PM.Databook_Code__c AND 
                        Air_Filter_Type__c = :PM.Air_Filter__c LIMIT 1];
                
                PMCM_AddOns = [SELECT ID,
                               Months__c,
                               Miles__c,
                               Service_Int_Months__c,
                               Service_Int_Miles__c
                               FROM ASP_PM_Coverage_Master__c
                               WHERE RecordType.Name = 'Package' AND
                               Engine_Model__c = :PM.Engine_Model__c AND
                               Duty_Cycle__c = :PM.Duty_Cycle__c AND
                               Name = :PM.Databook_Code__c LIMIT 1];
                
                ID Offer_Master_ID = PMCM.ID;
                
                List<Offer_Master_Service__c> lstServices_Included = [SELECT Name,
                                                                      Service_Frequency__c,
                                                                      Service_Interval_Hours__c,
                                                                      Service_Interval_Miles__c,
                                                                      Service_Interval_Months__c,
                                                                      Service_Type__c 
                                                                      FROM Offer_Master_Service__c 
                                                                      WHERE Offer_Master__c = :Offer_Master_ID];
                
                for(Offer_Master_Service__c OMSrv:lstServices_Included)
                {
                    oms = new OMS();                    
                    oms.OMS_ServiceType = (string.isNotBlank(string.valueOf(OMSrv.Service_Type__c)))?string.valueOf(OMSrv.Service_Type__c) : '';
                    oms.OMS_ServiceFrequency = (string.isNotBlank(string.valueOf(OMSrv.Service_Frequency__c)))?string.valueOf(OMSrv.Service_Frequency__c) : '';
                    oms.OMS_MonthsInterval = (string.isNotBlank(string.valueOf(OMSrv.Service_Interval_Months__c)))?string.valueOf(OMSrv.Service_Interval_Months__c) : '';
                    oms.OMS_MilesInterval = (string.isNotBlank(string.valueOf(OMSrv.Service_Interval_Miles__c)))?util.formatPrice(Double.valueOf(OMSrv.Service_Interval_Miles__c), 'MILES') : '';
                    
                    lstOMS.add(oms);
                }
                mOMS.put(PM.Name, lstOMS);
            }
            //-------------------------------------  END  ------------------------------------
            
            PackageDetails PD;
            AddOns AddOn;
            List<OMS> lstOMService = new List<OMS>();
            List<PackageDetails> lstPM = new List<PackageDetails>();
            for(ASP_PM_Line_Items__c PM:PM_PackageDetails)
            {                
                PD = new PackageDetails();
                PD.PD_AddOns_Flag = false;
                PD.PD_OMS_Flag = false;
                
                PD.PD_QuoteNo = (string.isNotBlank(string.valueOf(PM.ASP_QQ__r.Name)))?string.valueOf(PM.ASP_QQ__r.Name) : '';
                PD.PD_Package = (string.isNotBlank(string.valueOf(PM.Package__c)))?string.valueOf(PM.Package__c) : '';
                PD.PD_EngineModel = (string.isNotBlank(string.valueOf(PM.Engine_Model__c)))?string.valueOf(PM.Engine_Model__c) : '';
                PD.PD_DutyCycle = (string.isNotBlank(string.valueOf(PM.Duty_Cycle__c)))?string.valueOf(PM.Duty_Cycle__c) : '';
                PD.PD_ServiceIntervals = (string.isNotBlank(string.valueOf(PM.Service_Interval__c)))?string.valueOf(PM.Service_Interval__c) : '';
                PD.PD_AirFilter = (string.isNotBlank(string.valueOf(PM.Air_Filter__c)))?string.valueOf(PM.Air_Filter__c) : '';
                PD.PD_TermDuration = (string.isNotBlank(string.valueOf(PM.Duration__c)))?string.valueOf(PM.Duration__c) : '';
                PD.PD_Price = (string.isNotBlank(string.valueOf(PM.Price__c)))?util.formatPrice(Double.valueOf(PM.Price__c), 'PRICE'):'$ 0.00 USD';
                PD.PD_NetPrice = (string.isNotBlank(string.valueOf(PM.Total_Price__c)))?util.formatPrice(Double.valueOf(PM.Total_Price__c), 'PRICE'):'$ 0.00 USD';
                PD.PD_DbCode = (string.isNotBlank(string.valueOf(PM.Databook_Code__c)))?string.valueOf(PM.Databook_Code__c) : '';
                //system.debug('####:ADD-ONS: ' + PM.PM_Line_Item_AddOns__r);
                PD.PD_AddOns_Flag = (string.valueOf(PM.PM_Line_Item_AddOns__r) != '()')?true : false;
                if(PD.PD_AddOns_Flag)
                { 
                    PM_AddOn = true;
                    List<AddOns> lstAddOn = new List<AddOns>();
                    for(PM_Line_Item_AddOn__c AO:PM.PM_Line_Item_AddOns__r)
                    {
                        AddOn = new AddOns();
                        AddOn.AO_AddOns = (string.isNotBlank(string.valueOf(AO.Add_On__c)))?string.valueOf(AO.Add_On__c) : '';
                        AddOn.AO_Manufacturer = (string.isNotBlank(string.valueOf(AO.Manufacturer__c)))?string.valueOf(AO.Manufacturer__c) : '';
                        AddOn.AO_OfferMaster = (string.isNotBlank(string.valueOf(AO.Offer_Master_Id__c)))?string.valueOf(AO.Offer_Master_Id__c) : '';
                        AddOn.AO_Service = (string.isNotBlank(string.valueOf(AO.Service_Name__c)))?string.valueOf(AO.Service_Name__c) : '';
                        AddOn.AO_DBCode = (string.isNotBlank(string.valueOf(AO.Databook_Code__c)))?string.valueOf(AO.Databook_Code__c) : '';
                        AddOn.AO_Price = (string.isNotBlank(string.valueOf(AO.Price__c)))?util.formatPrice(Double.valueOf(AO.Price__c), 'PRICE'):'$ 0.00 USD';
                        AddOn.AO_Service_Interval_Months = (string.isNotBlank(string.valueOf(PMCM_AddOns.Service_Int_Months__c)))?string.valueOf(PMCM_AddOns.Service_Int_Months__c) : '';
                        AddOn.AO_Service_Interval_Miles = (string.isNotBlank(string.valueOf(PMCM_AddOns.Service_Int_Miles__c)))?util.formatPrice(Double.valueOf(PMCM_AddOns.Service_Int_Miles__c), 'MILES') : '';
                        
                        lstAddOn.add(AddOn);
                    }
                    PD.AddOns_List = lstAddOn;
                }
                
                if(!mOMS.isEmpty())
                {
                    lstOMService = mOMS.get(PM.Name);
                    if(lstOMService != null)
                    {
                        PD.PD_OMS_Flag = true;
                        PD.OMS_List = lstOMService;
                    }
                }
                
                lstPM.add(PD);
            }
            PM_List = lstPM;
            system.debug('TOTAL PACKAGE: ' + PM_List.size());
            if(PM_List.size() > 0)
                PM_Flag = true;  
            
            List<ASP_PM_Line_Items__c> PM_Transmission = [SELECT ID,
                                                          Name,
                                                          ASP_QQ__r.Name,
                                                          Manufacturer__c,
                                                          Transmission_Model__c,
                                                          Service_Interval__c,
                                                          Duration__c,
                                                          Total_Price__c,
                                                          Databook_Code__c,
                                                          DB_Code__c,
                                                          Program__c
                                                          FROM ASP_PM_Line_Items__c
                                                          WHERE Program__c = 'TRANSMISSION' AND ASP_QQ__r.Name = :recordID];
            
            //--------------------------  LOGIC FOR TRANSMISSION SERVICE INCLUDED  ------------------
            TSI tsi;
            List<TSI> lstTSI;
            map<string, List<TSI>> mTSI = new map<string, List<TSI>>();
            
            for(ASP_PM_Line_Items__c PM:PM_Transmission)
            {
                lstTSI = new List<TSI>();
                ID Offer_Master_ID = [SELECT ID FROM ASP_PM_Coverage_Master__c
                                      WHERE RecordType.Name = 'Transmission' AND
                                      Manufacturer__c = :PM.Manufacturer__c AND
                                      Transmission_Model__c = :PM.Transmission_Model__c AND
                                      Duration__c = :PM.Duration__c].ID;
                
                List<Offer_Master_Service__c> lstServices_Included = [SELECT Name,
                                                                      Service_Frequency__c,
                                                                      Service_Interval_Hours__c,
                                                                      Service_Interval_Miles__c,
                                                                      Service_Interval_Months__c,
                                                                      Service_Type__c 
                                                                      FROM Offer_Master_Service__c 
                                                                      WHERE Offer_Master__c = :Offer_Master_ID];
                
                for(Offer_Master_Service__c TSrv:lstServices_Included)
                {
                    tsi = new tsi();                    
                    tsi.TSI_ServiceType = (string.isNotBlank(string.valueOf(TSrv.Service_Type__c)))?string.valueOf(TSrv.Service_Type__c) : '';
                    tsi.TSI_ServiceFrequency = (string.isNotBlank(string.valueOf(TSrv.Service_Frequency__c)))?string.valueOf(TSrv.Service_Frequency__c) : '';
                    tsi.TSI_MonthsInterval = (string.isNotBlank(string.valueOf(TSrv.Service_Interval_Months__c)))?string.valueOf(TSrv.Service_Interval_Months__c) : '';
                    tsi.TSI_MilesInterval = (string.isNotBlank(string.valueOf(TSrv.Service_Interval_Miles__c)))?util.formatPrice(Double.valueOf(TSrv.Service_Interval_Miles__c), 'MILES') : '';
                    
                    lstTSI.add(tsi);
                }
                mTSI.put(PM.Name, lstTSI);
            }
            //-------------------------------------  END  ------------------------------------
            
            Transmission TRANS;
            List<Transmission> lstTRANS = new List<Transmission>();
            List<TSI> lstTService = new List<TSI>();
            for(ASP_PM_Line_Items__c PM:PM_Transmission)
            {  
                TRANS = new Transmission();
                TRANS.T_Manufacturer = (string.isNotBlank(string.valueOf(PM.Manufacturer__c)))?string.valueOf(PM.Manufacturer__c) : '';
                TRANS.T_Model = (string.isNotBlank(string.valueOf(PM.Transmission_Model__c)))?string.valueOf(PM.Transmission_Model__c) : '';
                TRANS.T_Service_Interval = (string.isNotBlank(string.valueOf(PM.Service_Interval__c)))?string.valueOf(PM.Service_Interval__c) : '';
                TRANS.T_Duration = (string.isNotBlank(string.valueOf(PM.Duration__c)))?string.valueOf(PM.Duration__c) : '';
                TRANS.T_TotalPrice = (string.isNotBlank(string.valueOf(PM.Total_Price__c)))?util.formatPrice(Double.valueOf(PM.Total_Price__c), 'PRICE'):'$ 0.00 USD';
                TRANS.T_DBCode = (string.isNotBlank(string.valueOf(PM.Databook_Code__c)))?string.valueOf(PM.Databook_Code__c) : '';
                
                if(!mTSI.isEmpty())
                {
                    lstTService = mTSI.get(PM.Name);
                    if(lstTService != null)
                    {
                        TRANS.T_TSI_Flag = true;
                        TRANS.TSI_List = lstTService;
                    }
                }
                
                lstTRANS.add(TRANS);
            }
            TRANS_List = lstTRANS;
            system.debug('TOTAL TRANSMISSION: ' + TRANS_List.size());
            if(TRANS_List.size() > 0)
                TRANS_Flag = true;
            
            List<ASP_PM_Line_Items__c> PM_ATS= [SELECT ID,
                                                Name,
                                                ASP_QQ__r.Name,
                                                Engine_Model__c,
                                                ATS_Service__c,
                                                Duration__c,
                                                Total_Price__c,
                                                Databook_Code__c,
                                                DB_Code__c,
                                                Program__c
                                                FROM ASP_PM_Line_Items__c
                                                WHERE Program__c = 'ATS' AND ASP_QQ__r.Name = :recordID];
            
            ATS at;
            List<ATS> lstATS = new List<ATS>();
            for(ASP_PM_Line_Items__c PM:PM_ATS)
            { 
                at = new ATS();
                at.ATS_EngineModel = (string.isNotBlank(string.valueOf(PM.Engine_Model__c)))?string.valueOf(PM.Engine_Model__c) : '';
                at.ATS_Service = (string.isNotBlank(string.valueOf(PM.ATS_Service__c)))?string.valueOf(PM.ATS_Service__c) : '';
                at.ATS_Duration = (string.isNotBlank(string.valueOf(PM.Duration__c)))?string.valueOf(PM.Duration__c) : '';
                at.ATS_TotalPrice = (string.isNotBlank(string.valueOf(PM.Total_Price__c)))?util.formatPrice(Double.valueOf(PM.Total_Price__c), 'PRICE'):'$ 0.00 USD';
                at.ATS_DBCode = (string.isNotBlank(string.valueOf(PM.Databook_Code__c)))?string.valueOf(PM.Databook_Code__c) : '';
                
                lstATS.add(at);
            }
            ATS_List = lstATS;
            system.debug('TOTAL AFTERTREATMENT MAINTENANCE PROGRAM: ' + ATS_List.size());
            if(ATS_List.size() > 0)
                ATS_Flag = true;
            
            if(PM_Flag == false && TRANS_Flag == false && ATS_Flag == false)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There is nothing to display, please check quote number.'));
        }
        catch(Exception exp) {
            system.debug('Line No: ' + exp.getLineNumber() + ' Error: ' + exp.getMessage());
        }
    }
}