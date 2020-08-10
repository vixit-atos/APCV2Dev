public class DVS_ScoreCardController {
	/*ApexPages.standardController stdController= null; 
    public DVS_ScoreCardController(ApexPages.StandardController controller) {
        stdController=controller;
    }*/
   
	private static DVS_Scouting__c currentDVS;
    
    @AuraEnabled
	public static DVS_Scouting__c getScoreCard(ID currendRecID) {
    	currentDVS =  [SELECT Business_Model_Score__c, Business_Model_Justification__c,
                                	Team_Dynamic_Score__c, Team_Dynamic_Justification__c,  
                                   	Financial_Framework_Score__c, Financial_Framework_Justification__c,
                                 	DTNA_Revenue_Potential_Score__c, DTNA_Revenue_Potential_Justification__c,  
                              		Technology_Score__c, Technology_Justification__c,
                          			Global_Score__c, Global_Justification__c,
              			   			Strategic_Alignment_Score__c, Strategic_Alignment_Justification__c,
                           			Significant_Impact_Score__c, Significant_Impact_Justification__c,
                           			Executive_Engagement_Score__c, Executive_Engagement_Justification__c, 
                                   	Recommendation__c FROM DVS_Scouting__c where id=: currendRecID limit 1];
 
       /* List <DVS_Evaluation> result = new List <DVS_Evaluation>();
  		result.add( new DVS_Evaluation('Business Model', currentDVS.Business_Model_Assessment__c, currentDVS.Business_Model_Score__c, '15%', currentDVS.Business_Model_Justification__c));
        result.add(new DVS_Evaluation('Team Dynamic', currentDVS.Team_Dynamic_Assessment__c, currentDVS.Team_Dynamic_Score__c, '10%', currentDVS.Team_Dynamic_Justification__c));
        result.add(new DVS_Evaluation('Financial Framework', currentDVS.Financial_Framework_Assessment__c, currentDVS.Financial_Framework_Score__c, '10%', currentDVS.Financial_Framework_Justification__c));
        result.add(new DVS_Evaluation('DTNA Revenue Potential', currentDVS.DTNA_Revenue_Potential_Assessment__c, currentDVS.DTNA_Revenue_Potential_Score__c, '10%', currentDVS.DTNA_Revenue_Potential_Justification__c));
        result.add(new DVS_Evaluation('Technology', currentDVS.Technology_Assessment__c, currentDVS.Technology_Score__c, '10%', currentDVS.Technology_Justification__c));
        result.add(new DVS_Evaluation('Global', currentDVS.Global_Assessment__c, currentDVS.Global_Score__c, '10%', currentDVS.Global_Justification__c));
        result.add(new DVS_Evaluation('Strategic Alignment', currentDVS.Strategic_Alignment_Assessment__c, currentDVS.Strategic_Alignment_Score__c, '10%', currentDVS.Strategic_Alignment_Justification__c));
        result.add(new DVS_Evaluation('Significant Impact', currentDVS.Significant_Impact_Assessment__c, currentDVS.Significant_Impact_Score__c, '15%', currentDVS.Significant_Impact_Justification__c));
        result.add(new DVS_Evaluation('Executive Engagement', currentDVS.Executive_Engagement_Assessment__c, currentDVS.Executive_Engagement_Score__c, '10%', currentDVS.Executive_Engagement_Justification__c));*/
        System.debug(currendRecID);
        return currentDVS;
	}
    
    @AuraEnabled
    public static void saveScoreCard(DVS_Scouting__c updatedDVS){
        System.debug('saveScoreCard: ' + updatedDVS);
        update updatedDVS;
    }
    
}