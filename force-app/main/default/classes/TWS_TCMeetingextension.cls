public with sharing class TWS_TCMeetingextension
{
    
    public TWS_TCMeetingextension(ApexPages.StandardController controller)
    {
      
    }

   
    
    public PageReference DefaultTCMeetingName() { 
        
Map<String, String> passedParams = System.currentPageReference().getParameters(); //grab the parameters for the current page
        PageReference pageWhereWeEndUp = new PageReference('/a13/e'); //set the return page reference to the New Opportunity page
        
        pageWhereWeEndUp.getParameters().putAll(passedParams); //copy all of the mappings from passedParams map to pageWhereWeEndUp map (in case Salesforce sends something we don't know we need)
        
       String strDate = Date.today().format().escapeHtml4();
        strDate = strDate.replace('/','.');
       // strDate = strDate.Left(2) + '.' + strDate.Mid(2,2) + '.' + strDate.right(4);
    string defaultName='TC Meeting '+ strDate;
 
            
        pageWhereWeEndUp.getParameters().put('Name',defaultName); //
               
        //you may get invalid session errors while trying to automatically save via redirect so we need to remove any auto save keys from the map
        String dropSaveNew = pageWhereWeEndUp.getParameters().remove('save_new'); //remove the save_new key value pair
        String dropSave = pageWhereWeEndUp.getParameters().remove('save'); //remove the save key value pair
        
        pageWhereWeEndUp.getParameters().put('nooverride', '1'); //prevents looping after recordtype selection (if applicable)
        pageWhereWeEndUp.setRedirect(true); //indicate that the redirect should be performed on the client side
        return pageWhereWeEndUp; //send the person on their way
    }

}