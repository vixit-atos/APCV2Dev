/*
07/10/2015 Created by Anto Nirmal for updating the Concession Lookup up relationship field in order based on the Concession number
*/

trigger DTNA_Order_Concession_Update on Order (before update,after insert) 
{
    List<String> Lst_Str_OrderConcession = new List<String>();
    Map<String,String> map_OrderConcession = new Map<String,String>();

    for(Order Obj_Order: Trigger.new)
    {
            Lst_Str_OrderConcession.add(Obj_Order.CONC_NO__c);
    }

    if(!Lst_Str_OrderConcession.isEmpty())
    {
        for(Opportunity LeadMap: [Select Name,Id From Opportunity where Name in :Lst_Str_OrderConcession])
            map_OrderConcession.put(LeadMap.Name,LeadMap.Id);
        
        if (Trigger.isInsert)
        {
            System.debug('Insert');
            List<Order> lst_Order =  [select Id,Name,CONC_NO__c,ConcessionNumber__c from Order 
                                                 where Id IN :Trigger.new];
            for(Order Obj_Order: lst_Order)
            {
                Obj_Order.ConcessionNumber__c = map_OrderConcession.get(Obj_Order.CONC_NO__c);
            }
            update (lst_Order);
            System.debug('Lead' + Lst_Str_OrderConcession);
            System.debug('Map' + map_OrderConcession);
            System.debug('ListConcession' + lst_Order);
        }
        if (Trigger.isUpdate)
        {   
            System.debug('Update');
            for(Order Obj_Order: Trigger.new)
            {
                Obj_Order.ConcessionNumber__c = map_OrderConcession.get(Obj_Order.CONC_NO__c);
                System.debug(Obj_Order.ConcessionNumber__c);
            }
            System.debug('Lead' + Lst_Str_OrderConcession);
            System.debug('Map' + map_OrderConcession);
        }
    }
    
}