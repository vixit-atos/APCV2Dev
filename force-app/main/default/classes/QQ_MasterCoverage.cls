public class QQ_MasterCoverage 
{
    public class Quotes
    {
        public decimal Price {get; set;}
        public decimal Cost {get; set;}
        public string Coverage {get; set;}
        public string CoverageType {get; set;}
        public string DatabookCode {get; set;}
        public string Deductible {get; set;}
        public string EngineComponent {get; set;}
        public string QGroup {get; set;}
        public string Option {get; set;}
        public string Usage {get; set;}
    }
    
    public void createRecord(List<ASP_QQ_Line_Item__c> newquoteitemlst)
    {
        try
        {
            Quotes QQ;
            ASP_QQ_Duration_Master__c MC;
            List<ASP_QQ_Duration_Master__c> MC_List = new List<ASP_QQ_Duration_Master__c>();
            
            for(ASP_QQ_Line_Item__c item : newquoteitemlst)
            {
                if(item.Custom__c == true)
                {
                    QQ = new Quotes();
                    QQ.Price = item.Price__c;
                    QQ.Cost = item.Cost__c;
                    QQ.Coverage = item.Coverage__c;
                    QQ.CoverageType = item.Coverage_Type__c;
                    QQ.DatabookCode = item.Databook_Code__c;
                    QQ.Deductible = item.Deductible__c;
                    QQ.EngineComponent = item.Engine_Component__c;
                    QQ.QGroup = item.Group__c;
                    QQ.Option = item.Option__c;
                    QQ.Usage = item.Usage__c;
                    
                    MC = new ASP_QQ_Duration_Master__c();
                    MC.Price__c = QQ.Price;
                    MC.Cost__c = QQ.Cost;
                    MC.Coverage__c = QQ.Coverage;
                    MC.Coverage_Type__c = QQ.CoverageType;
                    MC.Databook_Code__c = QQ.DatabookCode;
                    MC.Deductible__c = QQ.Deductible;
                    MC.Engine_Component__c = QQ.EngineComponent;
                    //MC.FMV_Date__c = Date.today();
                    MC.Group__c = QQ.QGroup;
                    MC.Option__c = QQ.Option;
                    MC.Usage__c = QQ.Usage;
                    MC.Active__c = true;
                    MC_List.add(MC);
                }
            }
            
            List<Database.SaveResult> results = Database.insert(MC_List, false);
            set<ID> successIDs = new set<ID>();
            for (Database.SaveResult result : results) 
            {
                if (!result.isSuccess())
                {
                    for (Database.Error err : result.getErrors())
                    {
                        System.debug('#### DML-ERROR:  [' + result.getId() + '] '+ err.getStatusCode() + ' ' + err.getMessage());
                    }
                }
                else
                {
                    successIDs.add(result.getId());
                    system.debug('Record ID: [' + result.getId() + '] created successfully...');
                }
            }
        }
        catch(Exception exp)
        {
            system.debug('Error! Line: ' + exp.getLineNumber() + ' - Message: ' + exp.getMessage());
        }
    }
}