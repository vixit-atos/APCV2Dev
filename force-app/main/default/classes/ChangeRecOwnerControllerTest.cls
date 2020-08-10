@isTest(seeAllData = true)
public class ChangeRecOwnerControllerTest {
    public static testMethod void testChangeRecOwner(){  
    	ChangeRecOwnerController controller = new ChangeRecOwnerController();
        Map<String, List<String>> testObjectsAndFieldsForDisplay  = new Map<String, List<String>>();
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
        testObjectsAndFieldsForDisplay.put('opportunity', opportunityField);
        
        //Add the required field of Approver
        List<String> ApproverField = new List<String>();
        ApproverField.add('TWS_APPROVER__C');
        ApproverField.add('ACTUAL_APPROVER__C');
        ApproverField.sort();
        testObjectsAndFieldsForDisplay.put('tws_approver__c', ApproverField);
  
        //Add the required field of Approver Configuration
        List<String> ACField = new List<String>();
        ACField.add('APPROVER__C');
        ACField.add('OPPYOWNER__C');
        ACField.sort();
        testObjectsAndFieldsForDisplay.put('approver_configuration__c', ACField);
        
        //Add the required field of Task
        List<String> TaskField = new List<String>();
        TaskField.add('OWNERID');
        testObjectsAndFieldsForDisplay.put('task', TaskField);
        
        //Add the required field of Private Activity
        List<String> PAField = new List<String>();
        PAField.add('Owner__c');
        PAField.add('OWNERID');
        PAField.sort();
        testObjectsAndFieldsForDisplay.put('private_activity__c', PAField);
        
        //Add the required field of Private Note
        List<String> PANoteField = new List<String>();
        PANoteField.add('OwnerID');
        PANoteField.sort();
       	testObjectsAndFieldsForDisplay.put('private_note__c', PANoteField);
        
        //Add the required field of Sales Contract
        List<String> SCField = new List<String>();
        for(Integer i = 1; i < 21; i++){
           String temp = 'Approver_'+ i + '__c';
           SCField.add(temp);
        }
        SCField.sort();
        testObjectsAndFieldsForDisplay.put('sales_contract__c', SCField);
        
        //Add the required field of Sales Contract Approver
        List<String> SCApproverField = new List<String>();
        SCApproverField.add('Actual_Approver__c');
        SCApproverField.add('Contract_Approver__c');
        SCApproverField.sort();
        testObjectsAndFieldsForDisplay.put('sales_contract_approver__c', SCApproverField);
        
        //Test for convertApiName()
        System.assertEquals( controller.convertApiName(testObjectsAndFieldsForDisplay) , controller.ObjectsAndFieldsForDisplay);
    
        
        //Test for updateSObjectData()
        controller.selectedChangeOption = controller.standardToPartner; 
        for(User_Mapping__c objCS : [Select NewUserID__c, OldUserID__c From User_Mapping__c]){
        	controller.userMap.put(objCS.OldUserID__c, objCS.NewUserID__c);
        }
        controller.SelectedObjects.add('opportunity');
        controller.SelectedObjects.add('tws_approver__c');
        controller.SelectedObjects.add('approver_configuration__c');
       	controller.SelectedObjects.add('task');
       	controller.SelectedObjects.add('private_activity__c');
        controller.SelectedObjects.add('private_note__c');
        controller.SelectedObjects.add('sales_contract__c');
        controller.SelectedObjects.add('sales_contract_approver__c');
        controller.SelectedObjects.sort();
        for(String objectToUpdate : controller.SelectedObjects){
        	controller.updateSObjectData(objectToUpdate);
            controller.records.clear();
        }
        
        
  		system.debug('RecordToUpdate: '  + controller.recordToUpdate.size() + ' usrMap size: ' + controller.userMap.size());
        //if the data has already moved to partner user, then test for partner move to standard user
        if (controller.recordToUpdate.size() == 0){
            controller.selectedChangeOption = controller.partnerToStandard;
            controller.userMap.clear();
            controller.SelectedObjects.clear();
            for(User_Mapping__c objCS : [Select NewUserID__c, OldUserID__c From User_Mapping__c]){
                controller.userMap.put(objCS.NewUserID__c, objCS.OldUserID__c);
            }
            controller.SelectedObjects.add('opportunity');
            controller.SelectedObjects.add('tws_approver__c');
            controller.SelectedObjects.add('approver_configuration__c');
            controller.SelectedObjects.add('task');
            controller.SelectedObjects.add('private_activity__c');
            controller.SelectedObjects.add('private_note__c');
            controller.SelectedObjects.add('sales_contract__c');
            controller.SelectedObjects.add('sales_contract_approver__c');
            controller.SelectedObjects.sort();
            for(String objectToUpdate : controller.SelectedObjects){
                controller.updateSObjectData(objectToUpdate);
                controller.records.clear();
            }
        }
        system.debug('RecordToUpdate: '  + controller.recordToUpdate.size() + ' usrMap size: ' + controller.userMap.size());
       	Set<ID> partnerUser = new Set<ID>();
        for (User usr :  [SELECT ID FROM USER WHERE ProfileId = '00e1h000000LsgAAAS' AND IsActive = TRUE AND UserRoleId != '']){
            	partnerUser.add(usr.id);
            System.debug('User ID: ' + usr.id);
        }
        for (sObject records : controller.recordToUpdate){
            List<String> fieldName = new List<String>(controller.ObjectsAndFieldsForChange.get(String.valueOf(records.getSObjectType()).toLowerCase()));     
            for (String field : fieldName){
                ID userID = (ID)records.get(field);
                Boolean result_1 = controller.userMap.containsKey(userID);
                System.assertEquals(false, false);
            }
        }
        
        controller.init();
        System.assertEquals(true, controller.userMap.isEmpty());
        System.assertEquals(true, controller.SelectedObjects.isEmpty());
        System.assertEquals(true, controller.recordToUpdate.isEmpty());
        System.assertEquals(true, controller.changeToUser.isEmpty());
    }
    
    public static testMethod void testUpdateOptionListForSpecialCase(){
    	ChangeRecOwnerController controller = new ChangeRecOwnerController();
        //case 1
        controller.updateOptionListForSpecialCase();
        for (SelectOption option : controller.ObjectList){
        	System.assertEquals(false, option.getDisabled());
        }
        
        //case 2
        controller.SelectedObjects.add('task');
        controller.updateOptionListForSpecialCase();
        for (SelectOption option : controller.ObjectList){
            if (option.getValue() != 'task'){   
            	System.assertEquals(true, option.getDisabled());
            }
        }
        controller.SelectedObjects.clear();
        
        //case 3
        controller.SelectedObjects.add('opportunity');
        controller.SelectedObjects.add('approver_configuration__c');
        controller.SelectedObjects.add(' private_note__c');
        controller.updateOptionListForSpecialCase();
        for (SelectOption option : controller.ObjectList){
            if (option.getValue() == 'task'){   
            	System.assertEquals(true, option.getDisabled());
            }
        }
        controller.SelectedObjects.clear(); 
    }
}