public  class MainframeTranMapping {
      
    public   Map<String, object>  mainframeResponse(List<String> mainframeResponseData,String transName,String function,String sobjectType) 
    {
        Integer i;
        String fieldName;
        Map<String, object> mainframeTranMap = new Map<String, object>();
        Map<decimal, MF_Field_Mapping__mdt> sfFieldMetaData = new Map<decimal, MF_Field_Mapping__mdt>(); 
        DescribeSObjectResult objSchema = Schema.getGlobalDescribe().get(sobjectType).getDescribe().getSObjectType().getDescribe();
        
        for(MF_Field_Mapping__mdt objCS : [Select Sequence__c,Function__c,Transaction_Name__c,LabelName__c,ObjectAPIName__c 
                                                  From MF_Field_Mapping__mdt where Transaction_Name__c = :transName and Function__c = :function
                                                  order by sequence__C]) 
        {
          sfFieldMetaData.put((Integer)objCS.Sequence__c, objCS);
        }       
 
           for (i = 0; i < mainframeResponseData.size(); i++) { 
          	    if(sfFieldMetaData.get(i) != null && (!mainframeResponseData[i].isWhitespace())) {
                fieldName = (sfFieldMetaData.get(i).LabelName__c);         
                Schema.DisplayType dataType = objSchema.fields.getMap().get(fieldName).getDescribe().getType();                       

 
                    if ((dataType == Schema.DisplayType.string) || (dataType == Schema.DisplayType.picklist) ){
                        mainframeTranMap.put(fieldName,mainframeResponseData[i]);}
                         else if ((dataType == Schema.DisplayType.double) || (dataType == Schema.DisplayType.currency) 
                             || (dataType == Schema.DisplayType.percent)){
                            mainframeTranMap.put(fieldName,Double.valueOf(mainframeResponseData[i].normalizeSpace()));
                        }
                         else if (dataType == Schema.DisplayType.date){
                            mainframeTranMap.put(fieldName,dateConverion(mainframeResponseData[i].normalizeSpace()));
                        }			 
            	} 
          	}
        system.debug('The name value pair format from the reusable class:::' +mainframeTranMap);
        return mainframeTranMap;		 
    
	}  
    
  public  Date dateConverion(String strDate)
    {
        return(Date.parse(strDate.Left(2) + '/' + strDate.substring(2, 4) + '/' + strDate.right(2)) );
    } 
   

}