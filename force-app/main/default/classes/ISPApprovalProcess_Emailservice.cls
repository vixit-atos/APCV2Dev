global class ISPApprovalProcess_Emailservice implements Messaging.InboundEmailHandler 
{
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope) 
    {
                                                               
       Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
       String TextBody = email.plainTextBody.normalizeSpace();
       system.debug('----TextBody : '+TextBody);
       String [] bodyString = TextBody.split('\n',0);
       String response;
      // String comment;
       //String subToCompare = '';
       String fromEmail = email.fromAddress;
       system.debug('fromEmail :  '+fromEmail);
       String action;
       List<Approval.ProcessWorkitemRequest> allReq = new List<Approval.ProcessWorkitemRequest>();
       try
        {   
           if(!bodyString.isEmpty())
           {
               List<User> userList = [SELECT Id FROM USER WHERE Email =: fromEmail];
               System.debug('userList  : '+userList);
               if(!userList.isEmpty())
               {
               List<ProcessInstanceWorkitem> workitemList = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.Status = 'Pending' AND ActorId =:userList[0].Id];
               response = bodyString[0];
               response= response.replaceAll( '\\s+', '');
               if(response.tolowerCase() == 'yes')
                   action = 'Approve';
               else if(response.tolowerCase() == 'no')
                   action = 'Reject';
               //if(bodyString.size()>1)
                 //  comment = bodyString[1];
                   
               if(!String.isBlank(action) && !workitemList.isEmpty())
               {
                    
                    for(ProcessInstanceWorkitem  workItemObj: workitemList)
                    {
                        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
                       // if(!String.isBlank(comment))
                       //     req2.setComments(comment);
                       // else
                            req2.setComments('Batch email approval/rejection');
                        req2.setAction(action);
                        //req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                
                        // Use the ID from the newly created item to specify the item to be worked
                        req2.setWorkitemId(workItemObj.Id);
                
                        // Add the request for approval
                        allReq.add(req2);
                     }
                    if(!allReq.isEmpty()) 
                    {
                       system.debug('----- allReq : '+allReq);
                       Approval.ProcessResult[] result2 =  Approval.process(allReq);
                       
                    }
               }    
                   
               }
               
                   
           }
        }
       catch(Exception e)
        {   
           system.debug('Inbound email Exception : '+ e);
        }
        return result;
    }
}