public with sharing class QQ_Approval_Controller 
{   
    @AuraEnabled
    public static QQ_Master__c updateMaster(Id masterid, Decimal price, string databook)
    {
        QQ_Master__c obj = [SELECT Id,
                            Name,
                            Price__c
                            FROM QQ_Master__c
                            WHERE id =: masterid];
        
        obj.Price__c = price;
        obj.Name = databook;
        UPDATE obj;
        return obj;
    }
    
    @AuraEnabled
    public static wrapperQQ getQuotedata(Id QQId)
    {
        ASP_QQ__c qqobj = [SELECT Id,
                           Name,
                           Createddate,
                           Status__c,
                           FMV_Date__c,
                           A85_Code__c,
                           Quote_Type__c,
                           Customer_Name__r.Name,
                           Concession__c,
                           TWS_Deal_No__c,
                           TC_Date__c,
                           Sales_outlet__c,
                           Expiration_Date__c,
                           Request_Type__c,
                           Revision_Status__c,
                           From_Date__c,
                           Till_Date__c,
                           Total_Units__c,
                           Multi_Year_Deal__c
                           FROM ASP_QQ__c
                           WHERE Id= :QQId];
        
        List <ASP_QQ_Line_Item__c> qqitemlst = [SELECT Id,
                                                Option_1__c,
                                                Coverage_Type_1__c,
                                                Deductible_1__c,
                                                Engine_Component_1__c,
                                                Standalone_Package_1__c,
                                                Truck_Coverage_Package_1__c,
                                                Eye_Test_Adjustment__c,
                                                Second_Price_Point__c,
                                                Engine_Component__c,
                                                toLabel(Coverage__c),
                                                Price__c,
                                                Cost__c,
                                                Margin__c,
                                                Truck_Coverage_Package__c,
                                                Standalone_Coverage__c,
                                                Option__c,
                                                Coverage_Type__c,
                                                Usage__c,
                                                Model__c,
                                                Group__c,
                                                Duration_final__c,
                                                Databook_code__c,
                                                Miles__c,
                                                Months__c,
                                                Level__c
                                                FROM ASP_QQ_Line_Item__c
                                                WHERE ASP_QQ__c = :QQId];
        
        List <Note> qqnoteslst = [SELECT Id,
                                  Body,
                                  CreatedDate,
                                  CreatedBy.name
                                  FROM Note
                                  WHERE ParentId = :QQId ORDER BY createddate DESC];
        
        List<GroupMember> userGrouplist = [SELECT groupId
                                           FROM GroupMember
                                           WHERE userOrGroupId = :UserInfo.getUserID()];
        
        String grouphasaccess;
        Set<Id> groupIdlst = new Set<Id>();
        for(GroupMember grp : userGrouplist)
        {
            groupIdlst.add(grp.groupId); 
        }
        // system.debug(groupIdlst);
        
        List<ASP_QQ__Share> qqshare = [SELECT Accesslevel
                                       FROM ASP_QQ__Share
                                       WHERE ParentId = :QQId  AND UserOrGroupId IN :groupIdlst];
        
        //system.debug(qqshare);
        
        wrapperQQ qqrecord = new wrapperQQ(); 
        qqrecord.quoteobj = qqobj;
        qqrecord.quoteitemlst = qqitemlst;        
        qqrecord.notelst = qqnoteslst;
        if(qqshare.size() > 0)
        {
            grouphasaccess = qqshare[0].Accesslevel;
        }
        if(grouphasaccess == 'Edit' || grouphasaccess == 'All')
        {
            qqrecord.userhaseditaccess = true;
        }
        else
        {
            qqrecord.userhaseditaccess = false; 
        }
        
        return qqrecord;
        
    }
    
    @AuraEnabled
    public static ASP_QQ__c customApproval(ASP_QQ__c quoteobj, List <ASP_QQ_Line_Item__c> quoteitemlst, List <Note> noteslist)
    {        
        update quoteobj;
        
        quoteobj = [SELECT Name FROM ASP_QQ__c WHERE Id = :quoteobj.Id];
        
        if(quoteitemlst.size() > 0){
            List <ASP_QQ_Line_Item__c> newquoteitemlst = new List <ASP_QQ_Line_Item__c> ();
            for(ASP_QQ_Line_Item__c qqitem : quoteitemlst)
            {
                if(qqitem.Id == null)
                {    
                    qqitem.ASP_QQ__c = quoteobj.Id;   
                }
                newquoteitemlst.add(qqitem); 
            }
            upsert newquoteitemlst;
            
            //----------------------  MASTER COVERAGE UPDATE | DATE: 26/10/2018  ---------------------------------
            QQ_MasterCoverage MC = new QQ_MasterCoverage();
            MC.createRecord(newquoteitemlst);
        }
        
        if(noteslist.size() > 0){
            List <Note> notesarray = new List <Note> ();
            
            for(Note noteobj : noteslist ){
                
                if(noteobj.Id == null)
                {    
                    noteobj.Title = 'Quick Quotes';
                    noteobj.ParentId = quoteobj.Id;
                }
                notesarray.add(noteobj);
            }
            upsert notesarray;
        } 
        return quoteobj;   
    }
    
    //--------------------------- NEW METHOD ADDED----------------------------
    @AuraEnabled
    public static string createMaster(ASP_QQ_Line_Item__c lineItem)
    {
        system.debug('#### Line Item: ' + lineItem);
        ASP_QQ_Line_Item__c item = [SELECT Id,
                                    Name,
                                    ASP_QQ__r.Name,
                                    ASP_QQ__r.Status__c,
                                    ASP_QQ__r.Stage__c,
                                    ASP_QQ__r.Quote_Type__c,
                                    ASP_QQ__r.FMV_Date__c,
                                    ASP_QQ__r.Coverage__c,
                                    Price__c,
                                    Cost__c,
                                    Months__c,
                                    Miles__c,
                                    Group__c,
                                    Coverage_Type_1__c,
                                    Deductible_1__c,
                                    Duration_Final__c,
                                    Engine_Component_1__c,
                                    Level__c,
                                    Option_1__c,
                                    Truck_Coverage_Package_1__c,
                                    Standalone_Package_1__c,
                                    Pricing_Type__c,
                                    Usage__c
                                    FROM ASP_QQ_Line_Item__c
                                    WHERE ID = :lineItem.Id];
        
        string recordID = '';
        try
        {
            if(string.valueOf(item.ASP_QQ__r.Status__c).toUpperCase() == 'APPROVED' &&
               string.valueOf(item.ASP_QQ__r.Stage__c).toUpperCase() == 'COMPLETE' &&
               string.valueOf(item.ASP_QQ__r.Quote_Type__c).toUpperCase() == 'CUSTOM')
            {   
                QQ_Master__c QQM = new QQ_Master__c();
                QQM.Price__c = item.Price__c;
                QQM.Cost__c = item.Cost__c;
                QQM.Months__c = item.Months__c;
                QQM.Miles__c = item.Miles__c;
                QQM.Group__c = item.Group__c;
                QQM.FMV_Date__c = item.ASP_QQ__r.FMV_Date__c;
                QQM.Duration__c = item.Duration_Final__c;
                QQM.Pricing_Types__c = item.Pricing_Type__c;                
                QQM.Name = 'Needs Setup';
                QQM.Publication_Status__c = 'Unpublished';
                QQM.Active__c = true;
                
                If(string.valueOf(item.ASP_QQ__r.Coverage__c).toUpperCase() == 'DETROIT COVERAGE')
                {
                    Id DC_recordTypeId = Schema.SObjectType.QQ_Master__c.getRecordTypeInfosByName().get('Detroit Coverage').getRecordTypeId();
                    QQM.Option__c = item.Option_1__c;
                    QQM.Engine_Component__c = item.Engine_Component_1__c;
                    QQM.Deductible__c = item.Deductible_1__c;
                    QQM.Coverage_Type__c = item.Coverage_Type_1__c;
                    QQM.RecordTypeId = DC_recordTypeId;
                }
                
                If(string.valueOf(item.ASP_QQ__r.Coverage__c).toUpperCase() == 'TRUCK CHASSIS')
                {
                    Id TC_recordTypeId = Schema.SObjectType.QQ_Master__c.getRecordTypeInfosByName().get('Truck Chassis').getRecordTypeId();
                    QQM.Level__c = item.Level__c;
                    QQM.Usage__c = item.Usage__c;
                    QQM.Package__c = item.Truck_Coverage_Package_1__c;
                    QQM.Standalone__c = item.Standalone_Package_1__c;
                    QQM.RecordTypeId = TC_recordTypeId;
                }
                
                INSERT QQM;
                recordID = 'SUCCESS: ' + QQM.Id;
            }
        }
        catch(Exception exp)
        {
            recordID = 'ERROR: ' + exp.getMessage();
            system.debug('Line: ' + exp.getLineNumber() + ', Error: ' + exp.getMessage());
        }
        return recordID;
    }
    
    @AuraEnabled
    public static List<QQ_Master__c> getPillar(Id quoteid)
    {
        ASP_QQ_Line_Item__c quoteitemobj =  [SELECT ID, 
                                             Months__c, 
                                             Miles__c, 
                                             Coverage_Type_1__c, 
                                             Option_1__c, 
                                             Deductible_1__c, 
                                             Engine_Component_1__c, 
                                             Standalone_Package_1__c, 
                                             Truck_Coverage_Package_1__c, 
                                             Coverage__c, 
                                             Usage__c, 
                                             Engine_Component__c, 
                                             Truck_Coverage_Package__c, 
                                             Standalone_Coverage__c, 
                                             Option__c, 
                                             Coverage_Type__c, 
                                             Model__c, 
                                             Group__c, 
                                             Level__c, 
                                             Duration_Final__c
                                             FROM ASP_QQ_Line_Item__c
                                             WHERE ASP_QQ__c = :quoteid];
        
        list<QQ_Master__c> lstMaster = new List<QQ_Master__c>();        
        if(quoteitemobj.Coverage__c == 'DETROIT COVERAGE')
        {
            Id recordTypeId = Schema.SObjectType.QQ_Master__c.getRecordTypeInfosByName().get('Detroit Coverage').getRecordTypeId();
            lstMaster = [SELECT Id, 
                         Name, 
                         RecordType.Name, 
                         Active__c, 
                         Cost__c, 
                         Deductible__c, 
                         Duration__c, 
                         Package__c, 
                         FMV_Date__c, 
                         Group__c, 
                         Kms__c, 
                         Level__c, 
                         Miles__c, 
                         Months__c, 
                         Price_Per_Mile__c, 
                         Price_Per_Month__c, 
                         Price__c, 
                         Pricing_Types__c, 
                         Publication_Status__c, 
                         Usage__c, 
                         Coverage_Type__c, 
                         Engine_Component__c, 
                         Option__c, 
                         Standalone__c
                         FROM QQ_Master__c
                         WHERE RecordTypeId = :recordTypeId AND
                         Publication_Status__c = 'Published' AND
                         //Coverage_Type__c = :quoteitemobj.Coverage__c AND
                         Usage__c = :quoteitemobj.Usage__c AND
                         Engine_Component__c = :quoteitemobj.Engine_Component_1__c AND
                         Option__c = :quoteitemobj.Option_1__c  AND
                         Active__c = true
                         ORDER BY Months__c, Miles__c];
        }
        if(quoteitemobj.Coverage__c == 'TRUCK CHASSIS')
        {
            Id recordTypeId = Schema.SObjectType.QQ_Master__c.getRecordTypeInfosByName().get('Truck Chassis').getRecordTypeId();
            if(quoteitemobj.Truck_Coverage_Package_1__c != null)
            {
                lstMaster = [SELECT Id, 
                             Name, 
                             RecordType.Name, 
                             Active__c, 
                             Cost__c, 
                             Deductible__c, 
                             Duration__c, 
                             Package__c, 
                             FMV_Date__c, 
                             Group__c, 
                             Kms__c, 
                             Level__c, 
                             Miles__c, 
                             Months__c, 
                             Price_Per_Mile__c, 
                             Price_Per_Month__c, 
                             Price__c, 
                             Pricing_Types__c, 
                             Publication_Status__c, 
                             Usage__c, 
                             Coverage_Type__c, 
                             Engine_Component__c, 
                             Option__c, 
                             Standalone__c
                             FROM QQ_Master__c
                             WHERE RecordTypeId = :recordTypeId AND
                             Publication_Status__c = 'Published' AND
                             //Coverage_Type__c = :quoteitemobj.Coverage__c AND
                             Group__c = :quoteitemobj.Group__c AND
                             Package__c = :quoteitemobj.Truck_Coverage_Package_1__c AND
                             Level__c = :quoteitemobj.Level__c AND
                             Active__c =true
                             ORDER BY Months__c, Miles__c];
            }
            else
            {
                lstMaster = [SELECT Id, 
                             Name, 
                             RecordType.Name, 
                             Active__c, 
                             Cost__c, 
                             Deductible__c, 
                             Duration__c, 
                             Package__c, 
                             FMV_Date__c, 
                             Group__c, 
                             Kms__c, 
                             Level__c, 
                             Miles__c, 
                             Months__c, 
                             Price_Per_Mile__c, 
                             Price_Per_Month__c, 
                             Price__c, 
                             Pricing_Types__c, 
                             Publication_Status__c, 
                             Usage__c, 
                             Coverage_Type__c, 
                             Engine_Component__c, 
                             Option__c, 
                             Standalone__c
                             FROM QQ_Master__c
                             WHERE RecordTypeId = :recordTypeId AND
                             Publication_Status__c = 'Published' AND
                             //Coverage_Type__c = :quoteitemobj.Coverage__c AND
                             Group__c = :quoteitemobj.Group__c AND
                             Standalone__c = :quoteitemobj.Standalone_Package_1__c AND
                             Level__c = :quoteitemobj.Level__c AND
                             Active__c =true
                             ORDER BY Months__c, Miles__c];
            }
        }
        
        return lstMaster;
    }
    
    @AuraEnabled
    public static List<QQ_Master__c> getstandardPrice(Id quoteid)
    {
        ASP_QQ_Line_Item__c quoteitemobj =  [SELECT ID, 
                                             Months__c, 
                                             Miles__c, 
                                             Coverage_Type_1__c, 
                                             Option_1__c, 
                                             Deductible_1__c, 
                                             Engine_Component_1__c, 
                                             Standalone_Package_1__c, 
                                             Truck_Coverage_Package_1__c, 
                                             Coverage__c, 
                                             Usage__c, 
                                             Engine_Component__c, 
                                             Truck_Coverage_Package__c, 
                                             Standalone_Coverage__c, 
                                             Option__c, 
                                             Coverage_Type__c, 
                                             Model__c, 
                                             Group__c, 
                                             Level__c, 
                                             Duration_Final__c
                                             FROM ASP_QQ_Line_Item__c
                                             WHERE ASP_QQ__c = :quoteid];
        
        list<QQ_Master__c> lstMaster = new List<QQ_Master__c>();        
        if(quoteitemobj.Coverage__c == 'DETROIT COVERAGE')
        {
            Id recordTypeId = Schema.SObjectType.QQ_Master__c.getRecordTypeInfosByName().get('Detroit Coverage').getRecordTypeId();
            lstMaster = [SELECT Id, 
                         Name, 
                         RecordType.Name, 
                         Active__c, 
                         Cost__c, 
                         Deductible__c, 
                         Duration__c, 
                         Package__c, 
                         FMV_Date__c, 
                         Group__c, 
                         Kms__c, 
                         Level__c, 
                         Miles__c, 
                         Months__c, 
                         Price_Per_Mile__c, 
                         Price_Per_Month__c, 
                         Price__c, 
                         Pricing_Types__c, 
                         Publication_Status__c, 
                         Usage__c, 
                         Coverage_Type__c, 
                         Engine_Component__c, 
                         Option__c, 
                         Standalone__c
                         FROM QQ_Master__c
                         WHERE RecordTypeId = :recordTypeId AND
                         //Publication_Status__c = 'Published' AND
                         //Coverage_Type__c = :quoteitemobj.Coverage__c AND
                         Usage__c = :quoteitemobj.Usage__c AND
                         Engine_Component__c = :quoteitemobj.Engine_Component_1__c AND
                         Option__c = :quoteitemobj.Option_1__c  AND
                         Miles__c = :quoteitemobj.Miles__c AND
                         Months__c = :quoteitemobj.Months__c AND
                         Active__c = true];
        }
        if(quoteitemobj.Coverage__c == 'TRUCK CHASSIS')
        {
            Id recordTypeId = Schema.SObjectType.QQ_Master__c.getRecordTypeInfosByName().get('Truck Chassis').getRecordTypeId();
            if(quoteitemobj.Truck_Coverage_Package_1__c != null)
            {
                lstMaster = [SELECT Id, 
                             Name, 
                             RecordType.Name, 
                             Active__c, 
                             Cost__c, 
                             Deductible__c, 
                             Duration__c, 
                             Package__c, 
                             FMV_Date__c, 
                             Group__c, 
                             Kms__c, 
                             Level__c, 
                             Miles__c, 
                             Months__c, 
                             Price_Per_Mile__c, 
                             Price_Per_Month__c, 
                             Price__c, 
                             Pricing_Types__c, 
                             Publication_Status__c, 
                             Usage__c, 
                             Coverage_Type__c, 
                             Engine_Component__c, 
                             Option__c, 
                             Standalone__c
                             FROM QQ_Master__c
                             WHERE RecordTypeId = :recordTypeId AND
                             //Publication_Status__c = 'Published' AND
                             //Coverage_Type__c = :quoteitemobj.Coverage__c AND
                             Group__c = :quoteitemobj.Group__c AND
                             Package__c = :quoteitemobj.Truck_Coverage_Package_1__c AND
                             Level__c = :quoteitemobj.Level__c AND
                             Months__c = :quoteitemobj.Months__c AND
                             Miles__c = :quoteitemobj.Miles__c AND
                             Active__c = true];
            }
            else
            {
                lstMaster = [SELECT Id, 
                             Name, 
                             RecordType.Name, 
                             Active__c, 
                             Cost__c, 
                             Deductible__c, 
                             Duration__c, 
                             Package__c, 
                             FMV_Date__c, 
                             Group__c, 
                             Kms__c, 
                             Level__c, 
                             Miles__c, 
                             Months__c, 
                             Price_Per_Mile__c, 
                             Price_Per_Month__c, 
                             Price__c, 
                             Pricing_Types__c, 
                             Publication_Status__c, 
                             Usage__c, 
                             Coverage_Type__c, 
                             Engine_Component__c, 
                             Option__c, 
                             Standalone__c
                             FROM QQ_Master__c
                             WHERE RecordTypeId = :recordTypeId AND
                             //Publication_Status__c = 'Published' AND
                             //Coverage_Type__c = :quoteitemobj.Coverage__c AND
                             Group__c = :quoteitemobj.Group__c AND
                             Standalone__c = :quoteitemobj.Standalone_Package_1__c AND
                             Level__c = :quoteitemobj.Level__c AND
                             Months__c = :quoteitemobj.Months__c AND
                             Miles__c = :quoteitemobj.Miles__c AND
                             Active__c = true];
            }
        }
        
        return lstMaster;
    }
    
    @AuraEnabled
    public static List<ASP_QQ_Line_Item__c> getQQPricehistory(Id quoteid)
    {        
        ASP_QQ_Line_Item__c quoteitemobj = [SELECT Id,
                                            Usage__c,
                                            Group__c,
                                            Option__c,
                                            Option_1__c,
                                            Model__c,
                                            Level__c,
                                            Months__c,
                                            Miles__c,
                                            Pricing_type__c,
                                            Quote_Type__c,
                                            Coverage__c,
                                            Truck_Coverage_Package_1__c,
                                            Standalone_Package_1__c,
                                            Engine_Component_1__c,
                                            Coverage_Type_1__c,
                                            ASP_QQ__r.FMV_Date__c,
                                            ASP_QQ__r.Status__c,
                                            ASP_QQ__r.Quote_Type__c
                                            FROM ASP_QQ_Line_Item__c  
                                            WHERE ASP_QQ__c = :quoteid];
        
        List<ASP_QQ_Line_Item__c> qqitemhistory = new List<ASP_QQ_Line_Item__c>();
        Decimal min_month = quoteitemobj.Months__c - 12;
        Decimal max_month = quoteitemobj.Months__c + 12;
        Decimal min_mile = quoteitemobj.Miles__c - Math.pow(10, 5);
        Decimal max_mile = quoteitemobj.Miles__c +  Math.pow(10, 5);
        
        if(quoteitemobj.Coverage__c == 'DETROIT COVERAGE')
        {            
            qqitemhistory = [SELECT ASP_QQ__c, 
                             Lower_Pillar__c, 
                             Upper_Pillar__c, 
                             Lower_Pillar_Months__c, 
                             Lower_Pillar_Miles__c, 
                             Lower_Pillar_Price__c, 
                             Upper_Pillar_Months__c, 
                             Upper_Pillar_Price__c, 
                             Upper_Pillar_Miles__c, 
                             Format(Createddate), 
                             Duration_Final__c, 
                             Accelerated_Mileage_Factor__c, 
                             Risk_Factor_Value__c, 
                             Eye_Test_Adjustment__c, 
                             Price__c, Cost__c, 
                             Second_Price_Point__c 
                             FROM ASP_QQ_Line_Item__c
                             WHERE Usage__c = :quoteitemobj.Usage__c AND
                             Engine_Component_1__c = :quoteitemobj.Engine_Component_1__c AND
                             Coverage_Type_1__c = :quoteitemobj.Coverage_Type_1__c AND 
                             Option_1__c = :quoteitemobj.Option_1__c AND
                             ASP_QQ__r.FMV_Date__c = :quoteitemobj.ASP_QQ__r.FMV_Date__c AND
                             ASP_QQ__r.Status__c = 'Approved' AND
                             Pricing_type__c IN ('Custom', '2PP') AND
                             ((Months__c > = :min_month AND Months__c <= :max_month) OR (Miles__c >= :min_mile AND Miles__c <= :max_mile)) 
                             ORDER BY  Months__c, Miles__c ASC Limit 10];
        }
        if(quoteitemobj.Coverage__c == 'TRUCK CHASSIS')
        {
            if(quoteitemobj.Truck_Coverage_Package_1__c != null)
            {
                qqitemhistory =[SELECT Name, 
                                Lower_Pillar__c, 
                                Upper_Pillar__c, 
                                Lower_Pillar_Months__c, 
                                Lower_Pillar_Miles__c, 
                                Lower_Pillar_Price__c, 
                                Upper_Pillar_Months__c, 
                                Upper_Pillar_Price__c, 
                                Upper_Pillar_Miles__c, 
                                Duration_Final__c, 
                                Accelerated_Mileage_Factor__c, 
                                Risk_Factor_Value__c, 
                                Eye_Test_Adjustment__c, 
                                Price__c, 
                                Cost__c, 
                                Second_Price_Point__c 
                                FROM ASP_QQ_Line_Item__c
                                WHERE ASP_QQ__r.FMV_Date__c = :quoteitemobj.ASP_QQ__r.FMV_Date__c AND
                                Group__c = :quoteitemobj.Group__c AND
                                Truck_Coverage_Package_1__c = :quoteitemobj.Truck_Coverage_Package_1__c AND
                                Level__c = :quoteitemobj.Level__c AND
                                ASP_QQ__r.Status__c = 'Approved' AND
                                Pricing_type__c IN ('Custom', '2PP') AND
                                ((Months__c > = :min_month AND Months__c <= :max_month) OR (Miles__c >= :min_mile AND Miles__c <= :max_mile))  
                                ORDER BY Months__c, Miles__c ASC Limit 10];
            }
            else
            {
                qqitemhistory=[SELECT Name, 
                               Lower_Pillar__c, 
                               Upper_Pillar__c, 
                               Months__c, 
                               Lower_Pillar_Months__c, 
                               Upper_Pillar_Months__c, 
                               Lower_Pillar_Price__c, 
                               Lower_Pillar_Miles__c, 
                               Upper_Pillar_Price__c, 
                               Upper_Pillar_Miles__c, 
                               Duration_Final__c, 
                               Accelerated_Mileage_Factor__c, 
                               Risk_Factor_Value__c, 
                               Eye_Test_Adjustment__c, 
                               Price__c, Cost__c, 
                               Second_Price_Point__c 
                               FROM ASP_QQ_Line_Item__c 
                               WHERE ASP_QQ__r.FMV_Date__c = :quoteitemobj.ASP_QQ__r.FMV_Date__c AND
                               Group__c = :quoteitemobj.Group__c AND
                               Standalone_Package_1__c = :quoteitemobj.Standalone_Package_1__c AND
                               ASP_QQ__r.Status__c = 'Approved' AND
                               Pricing_type__c IN ('Custom', '2PP') AND
                               ((Months__c > = :min_month AND Months__c <= :max_month) OR (Miles__c >= :min_mile AND Miles__c <= :max_mile)) 
                               ORDER BY Months__c, Miles__c ASC Limit 10];
            }
        }  
        
        return qqitemhistory;
    }
    
    public class wrapperQQ 
    {
        @AuraEnabled Public ASP_QQ__c quoteobj;
        @AuraEnabled Public List <ASP_QQ_Line_Item__c> quoteitemlst;
        @AuraEnabled Public List <Note> notelst;
        @AuraEnabled Public boolean userhaseditaccess;  
    }
}