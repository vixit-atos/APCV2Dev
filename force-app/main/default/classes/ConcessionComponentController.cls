public  class ConcessionComponentController
{

    public Id accountId {get;set;}
    public Id userId {get;set;}
    public List<Concession__c > getExpiredConcessions()
    {
        List<Concession__c > ConcessionsList;
        ConcessionsList = [select name,Id,CONC_STATUS_CD__c,CUST_NAME_50__c,APPR_MIN_UNITS__c,CONCMCDB_MARKET_SEG__c,EXPR_DATE__c,Account__c from Concession__c where CONC_STATUS_CD__c = 'Concession has Expired' and EXPR_DATE__c = LAST_MONTH and Account__C = :accountId and OwnerId = :userId];
        return ConcessionsList;
    }
    public List<Concession__c > getConcessionsForExpiry()
    {
        List<Concession__c > ConcessionsList;
        ConcessionsList = [select name,Id,CUST_NAME_50__c,APPR_MIN_UNITS__c,CONCMCDB_MARKET_SEG__c,EXPR_DATE__c,Account__c from Concession__c where CONC_STATUS_CD__c Like 'Pending%' and EXPR_DATE__c = NEXT_N_DAYS:7 and EXPR_DATE__c <> NEXT_N_DAYS:6 and Account__C = :accountId  and OwnerId = :userId];
        return ConcessionsList;
    }
}