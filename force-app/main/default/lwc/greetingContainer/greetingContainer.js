/**
 * @File Name          : greetingContainer.js
 * @Description        : 
 * @Author             : VIXIT BHARDWAJ - ATOS SYNTEL INC
 * @Group              : 
 * @Last Modified By   : VIXIT BHARDWAJ - ATOS SYNTEL INC
 * @Last Modified On   : 4/10/2020, 1:36:13 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    4/6/2020   VIXIT BHARDWAJ - ATOS SYNTEL INC     Initial Version
**/
import { LightningElement } from 'lwc';

export default class GreetingContainer extends LightningElement {
    
    GreetingContainer(){
        
        let var2 = this.template.querySelector('c-greeting');
        var2.localGreeting = "My customized greeting";
    }
   // let var1 = document.querySelector("c-greeting");

}