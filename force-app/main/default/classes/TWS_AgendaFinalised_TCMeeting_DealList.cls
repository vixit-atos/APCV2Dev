public class TWS_AgendaFinalised_TCMeeting_DealList
{
  public Id TCMeetingId {get;set;}
  public List<Deal_Meeting_Association__c> getTheWeeksTCMDeals()
  {
      List<Deal_Meeting_Association__c> TCMDeal;
      TCMDeal = [select Id,
                TC_Meeting__r.Name,
                TWS_TC_Deal__r.Name,
                TWS_TC_Deal__r.StageName,
                TWS_TC_Deal__r.RecordType.DeveloperName,
                TWS_TC_Deal__r.Description__c,
                Link_to_Related_Oppty_Record__c
                from Deal_Meeting_Association__c
                where TC_Meeting__c = :TCMeetingId];
      return TCMDeal;
  }
}