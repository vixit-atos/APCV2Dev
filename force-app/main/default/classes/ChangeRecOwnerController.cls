public class ChangeRecOwnerController {
    private final Map<String, Schema.SObjectType> AllObjectType = Schema.getGlobalDescribe();
    @TestVisible private Map<String, List<String>> ObjectsAndFieldsForChange {get; set;}
    public Map<String, List<String>> ObjectsAndFieldsForDisplay {get; set;}
    
    @TestVisible private Set<SObject> records;
    @TestVisible private Map<ID, ID> userMap;
    @TestVisible private Set<ID> changeToUser;
    @TestVisible private List<Sobject> recordToUpdate;
    
   // private Set<String> queryCheck;
    
    public final String standardToPartner = 'Standard User To Partner User';
    public final String partnerToStandard = 'Partner User To Standard User';
    //Selected Object List from drop down list
    public List<String> SelectedObjects{get;set;}
    //Selected Option from drop down list
    public String selectedChangeOption{get;set;}
    public List<User_Mapping__c> userMapDisplay {get; set;}  
    public List<SelectOption> ObjectList{get;set;}
    public List<SelectOption> changeOwnerOption{
        get{
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption(standardToPartner,standardToPartner));
            options.add(new SelectOption(partnerToStandard,partnerToStandard ));
            return options;
        }
        set;
    }

    public ChangeRecOwnerController()
    {
        selectedChangeOption = standardToPartner;
        SelectedObjects = new List<String>();
        changeToUser = new Set<ID>();
        userMap = new Map<ID, ID>();
        records = new Set<sObject>();
        userMapDisplay = [Select NAME, NewUserID__c, OldUserID__c From User_Mapping__c ORDER BY NAME];
        ObjectsAndFieldsForChange = new Map<String, List<String>>(setupDataToChange());
        ObjectsAndFieldsForDisplay= new Map<String, List<String>>(convertApiName(ObjectsAndFieldsForChange));
        recordToUpdate = new List<Sobject>();
      //  queryCheck = new Set<String>();
        SetObjectList();  
    }
    
    //Add data(Required objects & fields) to map
    private Map<String, List<String>> setupDataToChange(){
        Map<String, List<String>> ObjectFieldToChange = new Map<String, List<String>>();
        //Add the required field of opportunity
        List<String> opportunityField =new List<String>();
        opportunityField.add('OWNERID');
        opportunityField.add('DistrictManager__c');
        opportunityField.add('NAD_U__c');
        opportunityField.add('NAEU__c');
        opportunityField.add('RGM_U__c');
        for(Integer i = 1; i < 21; i++){
           String temp = 'Approver_'+ i + '__c';
           opportunityField.add(temp);
        }
        opportunityField.sort();
        ObjectFieldToChange.put('opportunity', opportunityField);
        
        //Add the required field of Approver
        List<String> ApproverField = new List<String>();
        ApproverField.add('TWS_APPROVER__C');
        ApproverField.add('ACTUAL_APPROVER__C');
        ApproverField.sort();
        ObjectFieldToChange.put('tws_approver__c', ApproverField);
  
        //Add the required field of Approver Configuration
        List<String> ACField = new List<String>();
        ACField.add('APPROVER__C');
        ACField.add('OPPYOWNER__C');
        ACField.sort();
        ObjectFieldToChange.put('approver_configuration__c', ACField);
        
        //Add the required field of Task
        List<String> TaskField = new List<String>();
        TaskField.add('OWNERID');
        ObjectFieldToChange.put('task', TaskField);
        
        //Add the required field of Private Activity
        List<String> PAField = new List<String>();
        PAField.add('Owner__c');
        PAField.add('OWNERID');
        PAField.sort();
        ObjectFieldToChange.put('private_activity__c', PAField);
        
        //Add the required field of Private Note
        List<String> PANoteField = new List<String>();
        PANoteField.add('OwnerID');
        PANoteField.sort();
        ObjectFieldToChange.put('private_note__c', PANoteField);
        
        //Add the required field of Sales Contract
        List<String> SCField = new List<String>();
        for(Integer i = 1; i < 21; i++){
           String temp = 'Approver_'+ i + '__c';
           SCField.add(temp);
        }
        SCField.sort();
        ObjectFieldToChange.put('sales_contract__c', SCField);
        
        //Add the required field of Sales Contract Approver
        List<String> SCApproverField = new List<String>();
        SCApproverField.add('Actual_Approver__c');
        SCApproverField.add('Contract_Approver__c');
        SCApproverField.sort();
        ObjectFieldToChange.put('sales_contract_approver__c', SCApproverField);  
        return ObjectFieldToChange;        
    }
    
    public void updateOptionListForSpecialCase(){   
        if (SelectedObjects.contains('task')){
            for (SelectOption option : ObjectList){
                if (option.getValue() != 'task')
                    option.setDisabled(true);
            }
        }
        if (SelectedObjects.isEmpty()){
            for (SelectOption option : ObjectList){
                option.setDisabled(false);
            }
        }
        if (!SelectedObjects.isEmpty() && !SelectedObjects.contains('task')){
             for (SelectOption option : ObjectList){
                if (option.getValue() =='task')
                    option.setDisabled(true);
            } 
        }
    }
    
    public void SetObjectList(){
        Map<String, String> switchedMap = new Map<String, String>();                //Switched Key and Value of Schema.getGlobalDescribe() 
        List<Schema.SObjectType> objectLabel = Schema.getGlobalDescribe().Values(); //Object Label Name
        List<SelectOption> options = new List<SelectOption>();                      //Dropdown List Options
        //Switch key and value of all object type
        for (String key :AllObjectType.keySet()){
        //System.debug('key:' + key);
            if (ObjectsAndFieldsForChange.containsKey(key)){
                switchedMap.put(AllObjectType.get(key).getDescribe().getLabel(), key);
            }
        }
        //Sort the list of object label
        List<String> sortedObject = new List<String>(switchedMap.keySet()); 
        sortedObject.sort();
        //Add options to dropdown list
        for (String str:sortedObject){ 
            options.add(new SelectOption(switchedMap.get(str), str));
        }
        ObjectList = new List<SelectOption>(options);
    }
        
    public void changeRecOwner(){  
        if (selectedChangeOption.equals(standardToPartner)){
            for(User_Mapping__c objCS : [Select NewUserID__c, OldUserID__c From User_Mapping__c]){
                userMap.put(objCS.OldUserID__c, objCS.NewUserID__c);
            }
        }
        else{
            for(User_Mapping__c objCS : [Select NewUserID__c, OldUserID__c From User_Mapping__c]){
                userMap.put(objCS.NewUserID__c, objCS.OldUserID__c);
            }
        }
       // System.debug('User Map size: ' + userMap.size());
        for (String selectedObject : selectedObjects){
            System.debug('Field name: ' + selectedObject);
            updateSObjectData(selectedObject);
            //testFunction(selectedObject);
            //system.debug('recordToUpdate size: ' + recordToUpdate.size() + ' Object:' + selectedObject);
            records.clear();
            
        }
        update recordToUpdate;
        init();
    }
    
    public void init(){
        userMap.clear();
        SelectedObjects.clear();
        recordToUpdate.clear();
        selectedChangeOption = standardToPartner;
        changeToUser.clear();
       // queryCheck.clear();
        SetObjectList();
    }

    public void updateSObjectData(String selectedObject){
        List<ID> usersToChange = new List<ID>(userMap.keySet());
        List<String> objectFields = new List<String>(ObjectsAndFieldsForChange.get(selectedObject));
      /*  System.debug('usersToChange size: ' + usersToChange.size() + ' objectFields size: ' +  objectFields.size() + 
                   ' ObjectsAndFieldsForChange size: ' + ObjectsAndFieldsForChange.size());*/
        String getField = '', condField = '', conFieldCheck = '';
        for (Integer i = 0; i < objectFields.size(); i++){
            getField += objectFields.get(i);
            condField += objectFields.get(i) + ' IN :usersToChange ';
            conFieldCheck += objectFields.get(i) + ' IN :changeToUser ';
            if (i < objectFields.size() - 1){
                getField += ', ';
                condField += 'OR ';
                conFieldCheck += 'OR ';
            }
        }
      //  String querytemp = 'SELECT ' + getField + ' from ' + selectedObject + ' WHERE ' + conFieldCheck;
      //  queryCheck.add(querytemp);
        String query = 'SELECT ' + getField + ' from ' + selectedObject + ' WHERE '+ condField;
        //System.debug(query);
        records.addALL(Database.query(query));
        //records = Database.query(query);
        //      
        List<Sobject> sObjectToUpdate = new List<SObject>();        
        List<String> fieldName = new List<String>(ObjectsAndFieldsForChange.get(selectedObject));
        for (sObject obj: records){            
                for (String tempfield : fieldName){
                    //System.debug('Field Name: ' + tempfield + ' old user: ' + obj.get(tempfield));
                    ID userID = userMap.get((ID)obj.get(tempfield));
                    if (obj.get(tempfield) != null && userID != null){
                        changeToUser.add(userID);
                        obj.put(tempfield, userID);
                    }
                }
        }
        //system.debug('hhihi records size: ' + records.size() + ' Object: ' + selectedObject);
        recordToUpdate.addALL(records);
    }

    //Convert Api Name to Label
    public Map<String, List<String>> convertApiName(Map<String, List<String>> ObjectsAndFieldsForChange){
        Map<String, List<String>> ObjAndFields = new Map<String, List<String>>(); 
        for (String key: ObjectsAndFieldsForChange.keySet()){
            List<String> tempFieldName = new List<String>();
            Map <String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(key).getDescribe().fields.getMap();
            for (String fieldName: ObjectsAndFieldsForChange.get(key)){
                tempFieldName.add(fieldMap.get(fieldName).getDescribe().getLabel());
            }
            ObjAndFields.put(Schema.getGlobalDescribe().get(key).getDescribe().getLabel(),tempFieldName);
         }
        return ObjAndFields; 
    }
}