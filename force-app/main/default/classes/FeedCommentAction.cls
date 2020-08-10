/**
* @File Name          : FeedCommentAction.cls
* @Description        :
* @Author             : VIXIT BHARDWAJ - ATOS SYNTEL INC
* @Group              :
* @Last Modified By   : VIXIT BHARDWAJ - ATOS SYNTEL INC
* @Last Modified On   : 5/12/2020, 8:21:41 PM
* @Modification Log   :
* Ver       Date            Author                  Modification
* 1.0    5/12/2020   VIXIT BHARDWAJ - ATOS SYNTEL INC     Initial Version
**/
public with sharing class FeedCommentAction{
    static final String USER_POWER_PARTNER = 'PowerPartner';
    static final String STATUS_NEW = 'New';
    static final String STATUS_IN_PROGRESS = 'In Progress';
    static final String STATUS_ASSIGNED = 'Assigned';
    static final String STATUS_DEALER_RESPONSE = 'Dealer Response';
    static final String STATUS_REOPENED = 'Reopened';
    static final String STATUS_RESOLVED = 'Resolved';
    /**
* @description
* @author VIXIT BHARDWAJ - ATOS SYNTEL INC | 5/12/2020
* @param List<FeedComment> lstFeedCommentObj
* @return void
**/
    public void updateStatus(List<FeedComment> lstFeedCommentObj){
        // FeedItem ID to find the visibility of Comment
        Set<Id> feeditemids = new Set<Id>(); 
        // List of FeedItembased on their visibility
        list<FeedItem> feeditem_visible = new list<FeedItem>();
        Set<Id> feeditemids_visible = new Set<Id>();
        //Parent Case ID
        Set<Id> parentCaseId = new Set<Id>();
        //User ID's List
        List<Id> userListId = new List<Id>();
        //List of Cases to be updated
        List<Case> lstCasesToBeUpdated = new List<Case>();
        List<Case> lstCasesToCallFlow  = new List<Case>();
        for (FeedComment myFeedCommentObject : lstFeedCommentObj){
            userListId.add(myFeedCommentObject.InsertedById);
            parentCaseId.add(myFeedCommentObject.ParentId);
            feeditemids.add(myFeedCommentObject.FeedItemId);
        }
        // Parent ID is specific to Case 
        String myIdPrefix = String.valueOf(parentCaseId).substring(1,4);
        if ( myIdPrefix.equals('500') ) {
            
            //Record Type ID List
            List<Id> recordTypeListId = new List<Id>();
            final Id CASE_APC_CORE_RECORDTYPEID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('APC Core').getRecordTypeId();
            recordTypeListId.add(CASE_APC_CORE_RECORDTYPEID);
            final Id CASE_APC_CREDIT_RECORDTYPEID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('APC Credit').getRecordTypeId();
            recordTypeListId.add(CASE_APC_CREDIT_RECORDTYPEID);
            final Id CASE_APC_INVOICE_RECORDTYPEID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('APC Invoice').getRecordTypeId();
            recordTypeListId.add(CASE_APC_INVOICE_RECORDTYPEID);
            final Id CASE_APC_ORDER_RECORDTYPEID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('APC Order').getRecordTypeId();
            recordTypeListId.add(CASE_APC_ORDER_RECORDTYPEID);
            final Id CASE_APC_RETURN_RECORDTYPEID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('APC Return').getRecordTypeId();
            recordTypeListId.add(CASE_APC_RETURN_RECORDTYPEID);
            final Id CASE_APC_TBB_RECORDTYPEID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('APC TBB').getRecordTypeId();
            recordTypeListId.add(CASE_APC_TBB_RECORDTYPEID);
            
            Map<Id, Case> caseMap = new Map<Id, Case>();
            Map<Id, User> userMap = new Map<Id, User>();
            Map<String, Object> inputs = new Map<String, Object>();
            // Making sure the APC specific cases only
            if (!recordTypeListId.isEmpty()){
                caseMap = new Map<Id, Case>([SELECT ID, Status, LastModifiedDate
                                             from Case
                                             where id IN :parentCaseId and RecordTypeID IN :recordTypeListId]);
            }
            //Making sure to update by Community Users
            if (!userListId.isEmpty()){
                userMap = new Map<Id, User>([SELECT ID, UserType
                                             FROM User
                                             where Id IN :userListId]);
            }
            if(!feeditemids.isEmpty()){
                feeditem_visible = [select id, visibility from feeditem where Id in :feeditemids and visibility = 'AllUsers' ];
                feeditemids_visible = new map<ID, feeditem>(feeditem_visible).keySet();
            }
            
            for (FeedComment myFeedCommentObject : lstFeedCommentObj){
                if (userMap.get(myFeedCommentObject.InsertedById).userType == USER_POWER_PARTNER){
                    for (Case myCaseObject : caseMap.values()){
                        if (myFeedCommentObject.ParentId.getSObjectType() == Case.SObjectType){
                            if (myCaseObject.Status == STATUS_NEW || myCaseObject.Status == STATUS_IN_PROGRESS || myCaseObject.Status == STATUS_ASSIGNED){
                                lstCasesToBeUpdated.add(new Case(Id = myFeedCommentObject.ParentId, Status = STATUS_DEALER_RESPONSE));
                            } else if (myCaseObject.Status == STATUS_RESOLVED){
                                lstCasesToBeUpdated.add(new Case(Id = myFeedCommentObject.ParentId, Status = STATUS_REOPENED));
                            }
                        }
                    }
                }
                else{ //For Internal Daimler Users Comments will initiate the Email Flow
                    // Check if the FeedComment is visible to all User
                    if(feeditemids_visible.contains(myFeedCommentObject.FeedItemId) ){
                        
                        for (Case myCaseObject : caseMap.values()){
                            if (myFeedCommentObject.ParentId.getSObjectType() == Case.SObjectType){                               
                                inputs.put('caseId', myFeedCommentObject.ParentId);                                
                            }
                        }                                           
                    }                    
                }
            }
            // Flow is called out side of the loop 
            if(!inputs.isEmpty()){
                Flow.Interview.APC_Case_Email_Notification_Dealer_Respond_V1_Content_Note myflow = new  Flow.Interview.APC_Case_Email_Notification_Dealer_Respond_V1_Content_Note(inputs);
                try{
                    myflow.start();
                }catch(exception ex){
                    System.debug(ex.getMessage());
                    APC_MasterController.CustomAPIExceptionData data = new APC_MasterController.CustomAPIExceptionData('Email error','There was error while sending email to Additional Recipient- please contact your Admin', 5);
                    throw new AuraHandledException(JSON.serialize(data));
                }
            }   
            if (!lstCasesToBeUpdated.isEmpty()){
                try{
                    update lstCasesToBeUpdated;
                } catch (DmlException e){
                    System.debug('The following exception has occurred: ' + e.getMessage());
                }
            }
        }
    }
}