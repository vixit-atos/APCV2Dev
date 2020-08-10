/**
 * @File Name          : lwcAdvisedCases.js
 * @Description        :
 * @Author             : VIXIT BHARDWAJ
 * @Group              :
 * @Last Modified By   : VIXIT BHARDWAJ
 * @Last Modified On   : 6/17/2020, 8:55:06 AM
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    6/17/2020   VIXIT BHARDWAJ     Initial Version
 **/
import { LightningElement, track, wire, api } from "lwc";
import getSuggestedCases from "@salesforce/apex/APC_CaseController.getAdvisedCases";

//define datatable columns with customized Case Number URL column
const columns = [
  {
    label: "Case Number",
    fieldName: "URLField",
    fixedWidth: 120,
    type: "url",
    typeAttributes: {
      label: {
        fieldName: "CaseNumber"
      },
      target: "_blank"
    },
    sortable: true
  },
  { label: "Request Type", fieldName: "Request_Type__c" },
  { label: "Action Requested", fieldName: "Type_of_Request__c" }
];
export default class LwcAdvisedCases extends LightningElement {
  @api recordId; //it will be passed from the screen
  @track records; //datatable records
  @track columns; //datatable columns

  //retrieve suggested cases based on case recordId
  @wire(getSuggestedCases, { caseId: "$recordId" })
  wiredCases({ error, data }) {
    if (data) {
      let URLField;
      //retrieve Id, create URL with Id and push it into the array
      this.records = data.map(item => {
        URLField = "/lightning/r/Case/" + item.Id + "/view";
        return { ...item, URLField };
      });
      this.columns = columns;
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.records = undefined;
    }
  }
}