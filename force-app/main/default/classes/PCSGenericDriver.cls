/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Purpose:
* This class is to be used after a Generic Sandbox refresh to allow a more realistic sandbox.
* Calls the PCSConfigUpdate class to update configurations
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Chris  
* @modifiedBy     Chris     
* @version        1.0
* @created        7-10-2018
* ──────────────────────────────────────────────────────────────────────────────────────────────────
**/

global class PCSGenericDriver implements SandboxPostCopy {
    global void runApexClass(SandboxContext context) {
        String driverType = 'Generic'; //Holds the driver type to search for in the custom metadata
        PCSSettings__mdt driverSettings; //Holds the selected setting
        
        for (PCSSettings__mdt setting : [SELECT MasterLabel, errorEmail__c, RCUValue__c FROM PCSSettings__mdt]) {
            if(setting.MasterLabel == driverType){
                driverSettings = setting;
            }
        }
        if(driverSettings != NULL){
            PCSConfigUpdate config = new PCSConfigUpdate(driverSettings.RCUValue__c, driverSettings.errorEmail__c);
        }        
    }
}