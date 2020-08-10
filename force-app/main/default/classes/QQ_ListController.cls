public with sharing class QQ_ListController
{
    @AuraEnabled
    public static String getUserName() 
    {
        return userinfo.getName();
    }
    
    @AuraEnabled
    public static List<wrapperQQ> getQuoteRecords(String stagefilter, String statusfilter, String domain, String source)
    {
        String qqQuery='';
        String stageval ='\'%' + String.escapeSingleQuotes(stagefilter.trim()) + '%\'';
        String statusval ='\'%' + String.escapeSingleQuotes(statusfilter.trim()) + '%\'';
        String domainval ='\'%' + String.escapeSingleQuotes(domain.trim()) + '%\'';
        String sourceval ='\'%' + String.escapeSingleQuotes(source.trim()) + '%\'';
        Boolean archiveval = false;
        
        if(source == 'External')
        {
            qqQuery = 'SELECT Name,Quote_Type__c, Coverage__c,Status__c, Customer_Name__r.Name, Duration_Final__c, A85_Code__c, FORMAT(Expiration_Date__c), ';
            qqQuery += 'Product_Make__c, LastModifiedBy.Username, LastModifiedBy.Name, LastModifiedBy.FirstName, LastModifiedBy.LastName, CreatedDate ';
            qqQuery += 'FROM ASP_QQ__c ';
            qqQuery += 'WHERE Archived__c = false AND Domain__c LIKE ' + domainval + ' AND Source__c LIKE ' + sourceval + ' ORDER BY LastModifiedDate DESC LIMIT 1500';
        }
        else
        {            
            if(stagefilter == 'Complete')
            {
                qqQuery = 'SELECT Name, Quote_Type__c, Coverage__c, Status__c, Stage__c, Customer_Name__r.Name, ';
                qqQuery += 'Duration_Final__c, A85_Code__c, FORMAT(Expiration_Date__c), Product_Make__c, LastModifiedBy.Name, CreatedDate, ';
                qqQuery += '(SELECT ID, Name, Engine_Component_1__c, Usage__c, Coverage_Type_1__c, Option_1__c, Group__c, ';
                qqQuery += 'Truck_Coverage_Package_1__c, Standalone_Package_1__c, Level__c FROM ASP_QQ_Line_Items__r) ';
                qqQuery += 'FROM ASP_QQ__c ';
                qqQuery += 'WHERE Archived__c = false AND Stage__c LIKE ' + stageval + ' AND Domain__c LIKE ' + domainval + ' AND Source__c LIKE ' + sourceval+ ' ORDER BY LastModifiedDate DESC LIMIT 1500';
            }
            else
            {
                qqQuery = 'SELECT Name, Quote_Type__c, Coverage__c, Status__c, Stage__c, Customer_Name__r.Name, ';
                qqQuery += 'Duration_Final__c, A85_Code__c, FORMAT(Expiration_Date__c), Product_Make__c, LastModifiedBy.Name, ';
                qqQuery += 'LastModifiedBy.Username, LastModifiedBy.FirstName, LastModifiedBy.LastName, CreatedDate, ';
                qqQuery += '(SELECT ID, Name, Engine_Component_1__c, Usage__c, Coverage_Type_1__c, Option_1__c, Group__c, ';
                qqQuery += 'Truck_Coverage_Package_1__c, Standalone_Package_1__c, Level__c FROM ASP_QQ_Line_Items__r) ';
                qqQuery += 'FROM ASP_QQ__c ';
                qqQuery += 'WHERE Archived__c = false AND Stage__c LIKE ' + stageval + ' AND Domain__c LIKE ' + domainval + ' AND Source__c LIKE ' + sourceval+ ' AND Status__c LIKE ' + statusval + ' ORDER BY LastModifiedDate DESC LIMIT 1500';
            }
        }
        
        List<ASP_QQ__c> quotesList =  Database.query(qqQuery);        
        List <wrapperQQ> WrapperQQList = new List<wrapperQQ>();
        wrapperQQ qqrecord;
        for(ASP_QQ__c qq : quotesList )
        {
            qqrecord = new wrapperQQ(); 
            qqrecord.Id = qq.Id;
            qqrecord.Name = qq.Name;
            qqrecord.Createddate = qq.CreatedDate.date().format();
            qqrecord.Modifieddate = qq.LastModifiedBy.Name;
            qqrecord.A85_Code = qq.A85_Code__c;
            qqrecord.ExpirationDate = qq.Expiration_Date__c;
            qqrecord.CustomerName = qq.Customer_Name__r.Name; 
            qqrecord.Status = qq.Status__c;
            qqrecord.ProductMake = qq.Product_Make__c;
            qqrecord.QuoteType = qq.Quote_Type__c;
            qqrecord.Coverage = qq.Coverage__c;
            qqrecord.DurationFinal = qq.Duration_Final__c;
            for(ASP_QQ_Line_Item__c LineItem : qq.ASP_QQ_Line_Items__r)
            {
                string EngComp = (string.isNotBlank(LineItem.Engine_Component_1__c))? string.valueOf(LineItem.Engine_Component_1__c + ', ') : '';
                string AppDesc = (string.isNotBlank(LineItem.Usage__c))? string.valueOf(LineItem.Usage__c + ', ') : '';
                string CvgType = (string.isNotBlank(LineItem.Coverage_Type_1__c))? string.valueOf(LineItem.Coverage_Type_1__c + ', ') : '';
                string Option = (string.isNotBlank(LineItem.Option_1__c))? string.valueOf(LineItem.Option_1__c) : '';
                
                string Grp = (string.isNotBlank(LineItem.Group__c))? string.valueOf(LineItem.Group__c + ', ') : '';
                string CvgPkg = (string.isNotBlank(LineItem.Truck_Coverage_Package_1__c))? string.valueOf(LineItem.Truck_Coverage_Package_1__c + ', ') : '';
                string Stndln = (string.isNotBlank(LineItem.Standalone_Package_1__c))? string.valueOf(LineItem.Standalone_Package_1__c + ', ') : '';
                string VocDesc = (string.isNotBlank(LineItem.Level__c))? string.valueOf(LineItem.Level__c) : '';
                
                if(qqrecord.Coverage == 'DETROIT COVERAGE')
                    qqrecord.CoverageDetails = EngComp + AppDesc + CvgType + Option;
                else
                    qqrecord.CoverageDetails = Grp + CvgPkg + Stndln + VocDesc;
            }
            WrapperQQList.add(qqrecord);
        } 
        return WrapperQQList ;
    }
    
    @AuraEnabled
    public static void archiveRecords(List <Id> QQIdlist)
    {
        List <ASP_QQ__c> QQlist = [Select Id from ASP_QQ__C where Id IN :QQIdlist];
        for(ASP_QQ__c qq : QQlist)
        {
            qq.Archived__c = true;
        }        
        update QQlist;
    } 
    
    @AuraEnabled
    public static Date getExpDate()
    {
        Date EXP_Date = [SELECT Expiration_Date__c
                         FROM Administrative_Tool__c
                         WHERE Expiration_Date__c != null AND
                         RecordType.Name = 'EC Expiration Date' LIMIT 1].Expiration_Date__c;
        
        return EXP_Date;
    }
    
    @AuraEnabled
    public static Date getFMVDate()
    {
        Date FMV_Date = [SELECT FMV_Date__c
                         FROM Administrative_Tool__c
                         WHERE FMV_Date__c != null AND
                         RecordType.Name = 'FMV Date' LIMIT 1].FMV_Date__c;
        
        return FMV_Date;
    }
    
    @AuraEnabled
    public static List<wrapperExtendedCoverage> getQQ_Master(String recordType, string UI_Type)
    {
        //system.debug('Record Type: ' + recordType + ', UI Type: ' + UI_Type);
        List<QQ_Master__c> lstQQ_Master = new List<QQ_Master__c>();
        
        if(UI_Type.toUpperCase().contains('EXTERNAL'))
        {            
            lstQQ_Master = [SELECT Id,
                            Name,
                            RecordTypeId,
                            Standalone__c,
                            Usage__c,
                            Package__c,
                            Group__c,
                            Months__c,
                            Miles__c,
                            FMV_Date__c,
                            Engine_Component__c,
                            Pricing_Types__c,
                            Cost__c,
                            Price__c,
                            Publication_Status__c,
                            Kms__c,
                            Duration__c,
                            Price_Per_Mile__c,
                            Price_Per_Month__c,
                            Active__c,
                            Deductible__c,
                            Level__c,
                            Coverage_Type__c,
                            Option__c
                            FROM QQ_Master__c
                            WHERE RecordType.Name = :recordType AND
                            Active__c = true AND
                            Publication_Status__c = 'PUBLISHED'];
        }
        if(UI_Type.toUpperCase().contains('INTERNAL'))
        {
            lstQQ_Master = [SELECT Id,
                            Name,
                            RecordTypeId,
                            Standalone__c,
                            Usage__c,
                            Package__c,
                            Group__c,
                            Months__c,
                            Miles__c,
                            FMV_Date__c,
                            Engine_Component__c,
                            Pricing_Types__c,
                            Cost__c,
                            Price__c,
                            Publication_Status__c,
                            Kms__c,
                            Duration__c,
                            Price_Per_Mile__c,
                            Price_Per_Month__c,
                            Active__c,
                            Deductible__c,
                            Level__c,
                            Coverage_Type__c,
                            Option__c
                            FROM QQ_Master__c
                            WHERE RecordType.Name = :recordType AND
                            Active__c = true];
        }
        
        wrapperExtendedCoverage extCVG;
        List<wrapperExtendedCoverage> lstExtCvg = new List<wrapperExtendedCoverage>(); 
        for(QQ_Master__c QQM : lstQQ_Master)
        {
            extCVG = new wrapperExtendedCoverage();
            
            extCVG.Id = QQM.Id;
            extCVG.Name = QQM.Name;            
            extCVG.Usage = QQM.Usage__c;
            extCVG.EngineComponent = QQM.Engine_Component__c;
            extCVG.CoverageType = QQM.Coverage_Type__c;
            extCVG.Option = QQM.Option__c;
            extCVG.Deductible = String.valueOf(QQM.Deductible__c);            
            extCVG.Level = QQM.level__c;
            extCVG.Groups = QQM.Group__c;
            extCVG.TruckCoveragePackage = QQM.Package__c;
            extCVG.StandalonePackage = QQM.Standalone__c;
            extCVG.Months = String.valueOf(QQM.Months__c);
            extCVG.Miles = String.valueOf(QQM.Miles__c);
            extCVG.Price = String.valueOf(QQM.Price__c);            
            extCVG.Duration = QQM.Duration__c;
            
            lstExtCvg.add(extCVG);
        }
        
        return lstExtCvg; 
    }
     
    @AuraEnabled
    public static List <wrapperExtendedCoverage> getMasterLineitems(String coverage)
    {
        String qqQuery = '';
        String coverageval = '\'%' + String.escapeSingleQuotes(coverage.trim()) + '%\'';
        String publishval = 'PUBLISHED';
        
        qqQuery = 'SELECT Id, Name, RecordTypeId, Active__c, Duration__c, Package__c, Standalone__c, Engine_Component__c, Group__c, Level__c, Miles__c, Months__c, ';
        qqQuery += 'Price__c, Publication_Status__c, Usage__c, Coverage_Type__c, Option__c, Deductible__c ';
        qqQuery += 'FROM QQ_Master__c ';
        qqQuery += 'WHERE RecordType.Name LIKE ' + coverageval + 'AND Publication_Status__c = \'' + publishval + '\' AND Active__c = True Order By Name ASC';

        List<QQ_Master__c> excvrglist = Database.query(qqQuery);
        List <wrapperExtendedCoverage> wrpexcvrglist = new List<wrapperExtendedCoverage>(); 
        
        //system.debug('excvrglist: ' + excvrglist.size());
        for(QQ_Master__c qqmaster : excvrglist)
        {
            wrapperExtendedCoverage excvrg = new wrapperExtendedCoverage();
            excvrg.Id = qqmaster.Id;
            excvrg.Usage = qqmaster.Usage__c;
            excvrg.Groups = qqmaster.Group__c;
            excvrg.TruckCoveragePackage = qqmaster.Package__c;
            excvrg.StandalonePackage = qqmaster.Standalone__c;
            excvrg.EngineComponent = qqmaster.Engine_Component__c;
            excvrg.CoverageType = qqmaster.Coverage_Type__c;
            excvrg.Option = qqmaster.Option__c;
            excvrg.Deductible = String.valueOf(qqmaster.Deductible__c);
            excvrg.Duration = qqmaster.Duration__c;
            excvrg.Name = qqmaster.Name;
            excvrg.Price = String.valueOf(qqmaster.Price__c);
            excvrg.Level = qqmaster.level__c;
            excvrg.Months = String.valueOf(qqmaster.Months__c);
            excvrg.Miles = String.valueOf(qqmaster.Miles__c);
            wrpexcvrglist.add(excvrg);
        }
        return wrpexcvrglist;  
    }
        
    @AuraEnabled
    public static ASP_QQ__c updateQuote(ASP_QQ__c quoteObj, string QuoteNum, string formType)
    {
        //system.debug('quoteObj: ' + quoteObj);
        ID QuoteID = [SELECT ID FROM ASP_QQ__c WHERE Name = :QuoteNum].ID;
        
        ASP_QQ__c QQ = new ASP_QQ__c();
        QQ.ID = QuoteID;
        if(formType.toUpperCase() == 'ORDER')
        {
            QQ.From_Date__c = quoteObj.From_Date__c;
            QQ.Till_Date__c = quoteObj.Till_Date__c;
            QQ.Total_Units__c = quoteObj.Total_Units__c;
            QQ.Multi_Year_Deal__c = quoteObj.Multi_Year_Deal__c;
            QQ.FMV_Date__c = quoteObj.FMV_Date__c;
            QQ.Expiration_Date__c = quoteObj.Expiration_Date__c;
        }
        if(formType.toUpperCase() == 'GENERAL')
        {
            QQ.Customer_Name__c = quoteObj.Customer_Name__c;
            QQ.Concession__c = quoteObj.Concession__c;
            QQ.TWS_Deal_No__c = quoteObj.TWS_Deal_No__c;
            QQ.Sales_Outlet__c = quoteObj.Sales_Outlet__c;
            QQ.Request_Type__c = quoteObj.Request_Type__c;
            QQ.Revision_Status__c = quoteObj.Revision_Status__c;
            QQ.TC_Date__c = quoteObj.TC_Date__c;
        }
        UPDATE QQ;
        
        return QQ;
    }
    
    @AuraEnabled
    public static ASP_QQ__c submitquote(ASP_QQ__c quoteobj, List<ASP_QQ_Line_Item__c> quoteitemlst, List <Note> noteslist, string QuoteNum, boolean editCoverage)
    {
        //system.debug('quoteobj: ' + quoteobj);
        //system.debug('quoteitemlst: ' + quoteitemlst);
        //system.debug('QuoteNum: ' + QuoteNum);
        //system.debug('editCoverage: ' + editCoverage);
        
        if(!editCoverage)
        {
            insert quoteobj;                
                        
            if(quoteitemlst.size() > 0)
            {
                List <ASP_QQ_Line_Item__c> newquoteitemlst = new List <ASP_QQ_Line_Item__c> ();
                for(ASP_QQ_Line_Item__c qqitem : quoteitemlst)
                {
                    qqitem.ASP_QQ__c = quoteobj.Id; 
                    newquoteitemlst.add(qqitem); 
                }
                insert newquoteitemlst;
            }            
            if(noteslist.size() > 0)
            {
                List <Note> notesarray = new List <Note> ();
                for(note noteobj : noteslist )
                {
                    noteobj.Title = 'Quick Quotes';
                    noteobj.ParentId = quoteobj.Id;
                    notesarray.add(noteobj);
                }
                insert notesarray;
            } 
        }
        else
        {
            //system.debug('Quick Quote Name: ' + QuoteNum);
            String A85_Code = '';
            List<ASP_QQ_Line_Item__c> lstLineItem = [SELECT ID
                                                     FROM ASP_QQ_Line_Item__c 
                                                     WHERE ASP_QQ__r.Name = :QuoteNum];
            ID LineItem_ID;
            for(ASP_QQ_Line_Item__c li:lstLineItem)
            {
                LineItem_ID = li.ID;
            }
            
            List<ASP_QQ_Line_Item__c> lstItems = new List<ASP_QQ_Line_Item__c>();
            ID QuoteID = [SELECT ID FROM ASP_QQ__c WHERE Name = :QuoteNum].ID;
            if(string.isNotBlank(string.valueOf(LineItem_ID)))
            {
                ASP_QQ_Line_Item__c Item;
                for(ASP_QQ_Line_Item__c LI:quoteitemlst)
                {
                    Item = new ASP_QQ_Line_Item__c();
                    Item.ID = LineItem_ID;
                    Item.Coverage__c = LI.Coverage__c;
                    Item.Group__c = LI.Group__c;
                    Item.Model__c = LI.Model__c;
                    Item.Chassis_Model__c = LI.Chassis_Model__c;
                    Item.Miles__c = LI.Miles__c;
                    Item.Truck_Coverage_Package_1__c = LI.Truck_Coverage_Package_1__c;
                    Item.Standalone_Package_1__c = LI.Standalone_Package_1__c;
                    Item.Level__c = LI.Level__c;
                    Item.Custom__c = LI.Custom__c;
                    Item.Option_1__c = LI.Option_1__c;
                    Item.Engine_Component_1__c = LI.Engine_Component_1__c;
                    Item.Usage__c = LI.Usage__c;
                    Item.Databook_Code__c = LI.Databook_Code__c;
                    Item.Months__c = LI.Months__c;
                    Item.Duration_Final__c = LI.Duration_Final__c;
                    Item.Coverage_Type_1__c = LI.Coverage_Type_1__c;
                    Item.Price__c = LI.Price__c;
                    Item.Master_Coverage__c = LI.Master_Coverage__c;
                    A85_Code = LI.A85_Code__c;
                    Item.A85_Code__c = LI.A85_Code__c;
                    Item.Deductible_1__c = LI.Deductible_1__c;
                    lstItems.add(Item);
                }
                Database.update(lstItems, true);
            }
            else
            {
                if(quoteitemlst.size() > 0)
                {
                    for(ASP_QQ_Line_Item__c qqitem : quoteitemlst)
                    {
                        qqitem.ASP_QQ__c = QuoteID; 
                        lstItems.add(qqitem); 
                    }
                    INSERT lstItems;
                } 
            }
            
            ASP_QQ__c QQ = new ASP_QQ__c();
            QQ.ID = QuoteID;
            QQ.A85_Code__c = A85_Code;
            QQ.From_Date__c = quoteobj.From_Date__c;
            QQ.Till_Date__c = quoteobj.Till_Date__c;
            QQ.Total_Units__c = quoteobj.Total_Units__c;
            QQ.Multi_Year_Deal__c = quoteobj.Multi_Year_Deal__c;
            QQ.FMV_Date__c = quoteobj.FMV_Date__c;
            QQ.Expiration_Date__c = quoteobj.Expiration_Date__c;
            QQ.TWS_Deal_No__c = quoteobj.TWS_Deal_No__c;
            QQ.Sales_Outlet__c = quoteobj.Sales_Outlet__c;
            QQ.Request_Type__c = quoteobj.Request_Type__c;
            QQ.TC_Date__c = quoteobj.TC_Date__c;
            QQ.Duration_Final__c = quoteobj.Duration_Final__c;
            QQ.Revision_Status__c = quoteobj.Revision_Status__c;
            QQ.Concession__c = quoteobj.Concession__c;
            QQ.Quote_Type__c = quoteobj.Quote_Type__c;
            QQ.Customer_Name__c = quoteobj.Customer_Name__c;
            QQ.Coverage__c = quoteobj.Coverage__c;
            QQ.Stage__c = 'Pending';
            QQ.Status__c = 'Pending for Validation';
            QQ.Source__c = 'Internal';
            UPDATE QQ;
            
            if(noteslist.size() > 0)
            {
                List<Note> notesarray = new List <Note>();                    
                for(note noteobj : noteslist )
                {
                    noteobj.Title = 'Quick Quotes';
                    noteobj.ParentId = QuoteID;
                    notesarray.add(noteobj);
                }
                INSERT notesarray;
            }
            system.debug('Record updated successfully.');
        }
        return quoteobj;
    }
    
    @AuraEnabled
    public static ASP_QQ__c external_ew_submitquote(ASP_QQ__c quoteobj, List <ASP_QQ_Line_Item__c> quoteitemlst)
    {
        insert quoteobj;
        quoteobj = [SELECT Name FROM ASP_QQ__c WHERE Id = :quoteobj.Id];
        
        if(quoteitemlst.size() > 0)
        {
            List <ASP_QQ_Line_Item__c> newquoteitemlst = new List <ASP_QQ_Line_Item__c> ();
            for(ASP_QQ_Line_Item__c qqitem : quoteitemlst)
            {
                qqitem.ASP_QQ__c = quoteobj.Id;                 
                newquoteitemlst.add(qqitem); 
            }
            insert newquoteitemlst;
        }
        
        return quoteobj;
    }
    
    @AuraEnabled
    public static string getGroup(string engineModel)
    {
        string modelGroup = [SELECT ID,
                             Group__c,
                             Model__c
                             FROM Administrative_Tool__c 
                             WHERE RecordType.Name = 'Create New Model Relationship' AND
                             Model__c = :engineModel LIMIT 1].Group__c;
        
        return modelGroup;
    }
    
    @AuraEnabled
    public static list<KeyValue> getModel(string A85_Code)
    {
        String QueryString = 'SELECT Model__c FROM Administrative_Tool__c WHERE A85_Code__c INCLUDES(\'' + A85_Code +'\') AND Active__c = true GROUP BY Model__c ORDER BY Model__c ASC';
        List<AggregateResult> groupedResults = Database.Query(QueryString);
        
        list<KeyValue> lstKV = new list<KeyValue>();
        KeyValue KV;
        for(AggregateResult result : groupedResults)
        {
            KV = new KeyValue();
            KV.value = string.valueOf(result.get('Model__c'));
            KV.label = string.valueOf(result.get('Model__c'));
            lstKV.add(KV);
        }
        return lstKV;
    }
    
    @AuraEnabled
    public static list<KeyValue> getDuration(string recType, string appDesc, string engComp, string cvgType, string option, decimal ddtValue, string model, string groups, string packages, string standalone)
    {
        //system.debug('Record type: ' + recType);
        list<QQ_Master__c> lstExtCvg = new list<QQ_Master__c>();
        if(rectype.toUpperCase().contains('DETROIT'))
        {
            //system.debug(appDesc + ', ' + engComp + ', ' + cvgType + ', ' + option);
            lstExtCvg = [SELECT ID,
                         Name,
                         Duration__c
                         FROM QQ_Master__c
                         WHERE RecordType.Name = 'Detroit Coverage' AND
                         Usage__c = :appDesc AND
                         Engine_Component__c = :engComp AND
                         Coverage_Type__c = :cvgType AND
                         Option__c = :option AND
                         //Deductible__c = :ddtValue AND
                         Active__c = true
                         ORDER BY Duration__c ASC];
        }
        if(rectype.toUpperCase().contains('TRUCK'))
        {
            //system.debug(model + ', ' + groups + ', ' + packages + ', ' + standalone);
            if(string.isNotBlank(packages))
            {
                lstExtCvg = [SELECT ID,
                             Name,
                             Duration__c
                             FROM QQ_Master__c
                             WHERE RecordType.Name = 'Truck Chassis' AND
                             Group__c = :groups AND
                             Package__c = :packages AND
                             Active__c = true
                             ORDER BY Duration__c ASC];
            }
            if(string.isNotBlank(standalone))
            {
                lstExtCvg = [SELECT ID,
                             Name,
                             Duration__c
                             FROM QQ_Master__c
                             WHERE RecordType.Name = 'Truck Chassis' AND
                             Group__c = :groups AND
                             Standalone__c = :standalone AND
                             Active__c = true
                             ORDER BY Duration__c ASC];
            }
        }
        
        list<KeyValue> lstKV = new list<KeyValue>();
        KeyValue KV;
        for(QQ_Master__c extCvg : lstExtCvg)
        {
            KV = new KeyValue();
            KV.value = extCvg.ID;
            KV.label = extCvg.Duration__c;
            lstKV.add(KV);
        }
        return lstKV;
    }
    
    @AuraEnabled
    public static QQ_Master__c getDuration_Details(string recordID)
    {
        //system.debug('Record ID: ' + recordID);
        QQ_Master__c extCvg = [SELECT ID,
                               Name,
                               Cost__c,
                               Price__c,
                               Months__c,
                               Miles__c,
                               Duration__c
                               FROM QQ_Master__c
                               WHERE ID = :recordID];
        
        return extCvg;
    }
        
    @AuraEnabled
    public static list<KeyValue> getItem(string category)
    {
        //system.debug('Category: ' + category);
        list<Administrative_Tool__c> lstItems = [SELECT ID,
                                                 Name,
                                                 Value__c,
                                                 Sort_Order__c
                                                 FROM Administrative_Tool__c
                                                 WHERE Field_Name__c = :category AND
                                                 RecordType.Name = 'Add New Admin Panel Value' AND
                                                 Active__c = true
                                                 ORDER BY Name ASC];
        
        list<KeyValue> lstKV = new list<KeyValue>();
        KeyValue KV;
        for(Administrative_Tool__c AT : lstItems)
        {
            KV = new KeyValue();
            KV.value = AT.Value__c;
            KV.label = AT.Value__c;
            lstKV.add(KV);
        }
        return lstKV;
    }
    
    public class KeyValue 
    {
        @AuraEnabled 
        public string value {get; set;}
        @AuraEnabled 
        public string label {get; set;}
    }
    
    public class wrapperQQ
    {
        @AuraEnabled Public String Id;
        @AuraEnabled Public String Name;
        @AuraEnabled Public String CreatedDate;
        @AuraEnabled Public String Modifieddate;
        @AuraEnabled Public String A85_Code;
        @AuraEnabled Public Date ExpirationDate;        
        @AuraEnabled Public String CustomerName;
        @AuraEnabled Public String Status;
        @AuraEnabled Public String ProductMake;
        @AuraEnabled Public String QuoteType;
        @AuraEnabled Public String Coverage;
        @AuraEnabled Public String DurationFinal;
        @AuraEnabled Public String CoverageDetails ;
    }
    
    public class wrapperExtendedCoverage 
    {
        @AuraEnabled Public String Id;
        @AuraEnabled Public String Usage;
        @AuraEnabled Public String Groups;
        @AuraEnabled Public String TruckCoveragePackage; 
        @AuraEnabled Public String StandalonePackage; 
        @AuraEnabled Public String EngineComponent;
        @AuraEnabled Public String CoverageType;  
        @AuraEnabled Public String Option;  
        @AuraEnabled Public String Deductible;
        @AuraEnabled Public String Duration;
        @AuraEnabled Public String Name; 
        @AuraEnabled Public String Price; 
        @AuraEnabled Public String Level; 
        @AuraEnabled Public String Months; 
        @AuraEnabled Public String Miles;        
    }
}