/**
 * @File Name          : communityExample.js
 * @Description        : 
 * @Author             : VIXIT BHARDWAJ - ATOS SYNTEL INC
 * @Group              : 
 * @Last Modified By   : VIXIT BHARDWAJ - ATOS SYNTEL INC
 * @Last Modified On   : 4/10/2020, 5:05:36 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    4/10/2020   VIXIT BHARDWAJ - ATOS SYNTEL INC     Initial Version
 **/
import {
    LightningElement,
    track,
    api
} from 'lwc';
import {
    createRecord
} from 'lightning/uiRecordApi';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';
import CASE_OBJECT from '@salesforce/schema/Case';
import SUBJECT_FIELD from '@salesforce/schema/Case.Subject';
import DESC_FIELD from '@salesforce/schema/Case.Description';
import STATUS_FIELD from '@salesforce/schema/Case.Status';
import ORIGIN_FIELD from '@salesforce/schema/Case.Origin';

export default class CommunityExample extends LightningElement {

    @api title;
    @api buttonlabel1;

    @track subject = '';
    @track desc = '123234345345';

    handleChange(event) {
        if (event.target.label === 'Case Subject') {
            this.subject = event.target.value;
        }
        if (event.target.label === 'Case Description') {
            this.desc = event.target.value;
        }
    }
    submitCase() {
        const fields = {};
        fields[SUBJECT_FIELD.fieldApiName] = this.subject;
        fields[DESC_FIELD.fieldApiName] = this.desc;
        fields[STATUS_FIELD.fieldApiName] = 'New';
        fields[ORIGIN_FIELD.fieldApiName] = 'Web';

        const recordInput = {
            apiName: CASE_OBJECT.objectApiName,
            fields
        };
        createRecord(recordInput)
            .then(result => {
                this.message = result;
                this.error = undefined;
                if(this.message !== undefined) {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Case created',
                            variant: 'success',
                        }),
                    );
                }
                
                console.log(JSON.stringify(result));
                console.log("result", this.message);
            })
            .catch(error => {
                this.message = undefined;
                this.error = error;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error',
                    }),
                );
                console.log("error", JSON.stringify(this.error));
            });




    }
}