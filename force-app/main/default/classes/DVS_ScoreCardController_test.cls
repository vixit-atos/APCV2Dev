@isTest
public class DVS_ScoreCardController_test {
    public static testMethod void testDVSScoreCard(){
        DVS_Scouting__c testRec = new DVS_Scouting__c(Name= 'Test 1',
                                                     Business_Model__c = 'High (3): Strong team dynamic; holistic view of the market; new vision of industry with clear plan to achieve vision.' , 
                                                     DTNA_Revenue_Potential__c = 'Medium (2): DTNA may have some revenue contribution through partnership.' , 
                                                     Executive_Engagement__c ='Low (1): Executives are over whelmed and lack delegates;high turn over in the company.', 
                                                     Financial_Framework__c = 'Medium (2): Revenue model is sustainable,but needs DTNA to fund projects.', 
                                                     Global__c ='Medium (2): Company has ability to scale up to international operations.', 
                                                     Significant_Impact__c ='Low (1): Product/technology cannot be leveraged for revenue or process improvement.', 
                                                     Strategic_Alignment__c ='High (3): Aligns well with CASE topics,DTNA/DVS objectives,or strategic roadmap.',
                                                    
                                                     Team_Dynamic__c ='Medium (2): Team is small, but is able to prioritize and problem solve.',
                                                     Technology__c = 'High (3): Technology is innovative,creates added value above what is currently offered to target market.');
        insert testRec;
        Test.startTest();
        DVS_Scouting__c testRec2 = DVS_ScoreCardController.getScoreCard(testRec.ID);
        System.assertEquals(testRec.id, testRec2.id);
        
        testRec2.Business_Model_Justification__c = 'Testing';
        DVS_ScoreCardController.saveScoreCard(testRec2);
        
        DVS_Scouting__c testRec3 = [SELECT Id, Business_Model_Justification__c FROM DVS_Scouting__c where id =: testRec.id limit 1];
        System.assertEquals(testRec3.Business_Model_Justification__c, 'Testing');
        Test.stopTest();
    }
}