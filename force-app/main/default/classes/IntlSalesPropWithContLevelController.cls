public class IntlSalesPropWithContLevelController{
  public List<ContributionCalculation__c> CCList{get; set;}
  public IntlSalesPropWithContLevelController() {

CCList = [SELECT Id, 
                 Name, 
                 Std_Net_Contrib_Truck__c,
                 Std_Net_Contrib_Truck_Per__c, 
                 Opportunity__r.EmailLinkToTWS__c,
                 Opportunity__r.Name, 
                 Opportunity__r.Id FROM ContributionCalculation__c                
          WHERE  
              Opportunity__r.DealSubmitDate__c = TODAY
          AND
                Opportunity__r.RecordType.Name = 'International Sales Proposal' ];      
  }
 
}