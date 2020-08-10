/**
 * @File Name          : APC_CaseController.cls
 * @Description        : 
 * @Author             : VIXIT BHARDWAJ
 * @Group              : 
 * @Last Modified By   : VIXIT BHARDWAJ
 * @Last Modified On   : 6/30/2020, 4:37:51 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/17/2020   VIXIT BHARDWAJ     Initial Version
**/
public with sharing class APC_CaseController {
    
    @AuraEnabled (cacheable=true)
    public static List<Case> getAdvisedCases(String caseId){
        List<Case> lstCase = new List<Case>(); 
        //retrieve case subject of existing case
        Case caseObj = [SELECT Subject, Request_Type__c,Type_of_Request__c, RecordTypeId FROM Case c WHERE Id=:caseId];

        //since all the keywords need to searched so, need to put 'OR' condition between the keywords
       
        // List<String> strList = caseObj.Subject.split(' ');

        String strRequestType = caseObj.Request_Type__c;
//        String strRequestType = 'Core Inquiry';
        String strRecordTypeId = caseObj.RecordTypeId;
        String strTypeOfRequest = caseObj.Type_of_Request__c;

       // String strSearch = String.join(strList, '\' OR \'') + '*';
        
        //System.debug('strSearch=' + strSearch);
        //strSearch=Seeking' OR 'guidance' OR 'on' OR 'electrical' OR 'wiring' OR 'installation' OR 'for' OR 'GC5060*                                 

        //retrieve cases which are already closed, created recently and eliminating current case
        List<List<SObject>> searchList = [FIND :strRequestType IN ALL FIELDS 
                                         RETURNING Case(Id, CaseNumber, Request_Type__c, Type_of_Request__c 
                                         WHERE Id!=:caseId
                                         AND Status = 'Closed'
                                         //AND Type =:caseObj.Type
                                         AND RecordTypeID = :strRecordTypeId
                                         AND Type_of_Request__c=:strTypeOfRequest
                                         ORDER BY CreatedDate DESC
                                         LIMIT 20) 
                                        ];

        if(searchList.size()>0){
            return searchList[0];
        }
        return lstCase;
    }
}