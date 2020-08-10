public with sharing class  APC_FlowINClauseActionClass {
    @InvocableMethod(label='Get records with IN clause filter')
    public static FlowOutputParameters[] filterRecords(FlowInputParameters[] input){
        
        FlowOutputParameters[] result = new FlowOutputParameters[]{};    
            
            list<contentdocumentlink> cdls = [select id, contentdocumentId  from contentdocumentlink where LinkedEntityId =:input[0].CaseID ];
        
        Set<Id> contentdocumentId = new Set<Id>();
        for (contentdocumentlink cdl: cdls){
            contentdocumentId.add(cdl.contentdocumentId);
        }
        system.debug('contentdocumentId: ' + contentdocumentId);
        if(!contentdocumentId.isEmpty()){
            list<contentNote> cnlist = new list<contentNote>();
            try{
                cnlist = [select Title from contentnote where id in:contentdocumentId ];
                String[] emailaddress = new string[]{}; 
                    if(!cnlist.isEmpty()){
                        for(contentnote cn : cnlist){
                            emailaddress.add(cn.Title);
                        }
                        if(!emailaddress.isEmpty()){
                            FlowOutputParameters obj = new FlowOutputParameters();
                            obj.records = emailaddress;                            
                            result.add(obj);
                        }
                    }                   
            }catch(Exception e){
                //system.debug(e.getMessage());
                throw e;
            }           
        }
        
        
        system.debug('result: ' + result);
        system.debug('result.size(): ' + result.size());
        //system.debug('result.record[0].length: ' + result.record[0].length);
        return result.size() > 0 ? result : null;
    }
    
    /* Input parameters for the Apex action */
    public class FlowInputParameters{
        
        @InvocableVariable(label='CaseID' required = true)
        public string CaseID;
        
    }
    
    /* Output parameters of the Apex action */
    public class FlowOutputParameters{
        
        public FlowOutputParameters(){
            records = new string[]{};
                }
        
        @InvocableVariable(label='Email collection')
        public string[] records;
    }
}