/**
 * @File Name          : greeting.js
 * @Description        : 
 * @Author             : VIXIT BHARDWAJ - ATOS SYNTEL INC
 * @Group              : 
 * @Last Modified By   : VIXIT BHARDWAJ - ATOS SYNTEL INC
 * @Last Modified On   : 4/6/2020, 10:59:25 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    4/6/2020   VIXIT BHARDWAJ - ATOS SYNTEL INC     Initial Version
**/
import { LightningElement,api } from 'lwc';

export default class Greeting extends LightningElement {
    @api localGreeting = "Hello World";
}