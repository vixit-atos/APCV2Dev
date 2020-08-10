/**
* @File Name          : APC_OrderController.apxc
* @Description        : Contains methods for all components in APC application
* @Author             : Chandrika
* @Last Modified On   : 08-Oct-2019

**/

public class APC_OrderController {
    @AuraEnabled
    public static List<Case> getAllCases(){
        return [SELECT AccountId,CaseNumber,ClosedDate,IsClosed,Origin,Priority,Status,Subject,Type FROM Case order by CaseNumber desc limit 20] ; 
        
    }
    @AuraEnabled
    public static void updatecase(List<Case> cs ){
        update cs;
    }
    
}