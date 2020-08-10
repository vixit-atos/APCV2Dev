@isTest
public class TWS_AgendaFinalised_TCMeeting_Deal_Test 
{
    static testMethod void AgendaFinalisedDealListRequest()
    {
        Test.startTest(); //switch to testing context
        TWS_AgendaFinalised_TCMeeting_DealList ObjectTEst = New TWS_AgendaFinalised_TCMeeting_DealList();
        system.debug(ObjectTEst.getTheWeeksTCMDeals());
        Test.stopTest();
    }
}