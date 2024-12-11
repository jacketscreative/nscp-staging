import { LightningElement,track, api, wire } from 'lwc';
import getApplicationTemplate from '@salesforce/apex/terrabbit_uploadDocumentController.getApplicationTemplate';
import getLatestFile from '@salesforce/apex/terrabbit_uploadDocumentController.getLatestFile';
import customCSSForFiles from '@salesforce/resourceUrl/customCSSForFiles';
import {loadStyle} from 'lightning/platformResourceLoader'; 
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import Description from '@salesforce/schema/Account.Description';

export default class Terrabbit_uploadDocuments extends NavigationMixin ( LightningElement ){
    @api caseId;
    @api applicationTemplateId;
    @track DocTemplates = [];

   // @wire(getApplicationTemplate, { caseId: this.caseId }) 
   //  DocTemplates;

  @wire(CurrentPageReference) pageRef;
    connectedCallback(){

        if (this.pageRef && this.caseId == null) {
            this.caseId = this.pageRef.attributes.recordId;
            console.log('Case ID:', this.caseId);
        }
        getApplicationTemplate({caseId:  this.caseId }).then(result => {

            if (result){
                this.DocTemplates=result.map(res => ({...res, hasUploads:false, uploadedFileName:null}));
                console.log('desc', this.DocTemplates);
            }
    
          });

    }

    renderedCallback() {
        Promise.all([
            loadStyle(this, customCSSForFiles)
        ]);        
    } 

     //Upload Method  
     handleUploadFinished(event) {
       alert ('File Uploaded');
       const recordId = event.target.dataset.id;
       const note = this.DocTemplates.find(item => item.Id === recordId);
       console.log(note.uploadedFileName);

       getLatestFile({documentId:recordId }).then(result => {

        if (result){
            note.hasUploads = true;
            note.uploadedFileName = result;
            console.log(note.uploadedFileName);
        }

      });
    }

    recordUrl(event) {
        const key = event.target.dataset.id;
        console.log(key);

        this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: event.target.dataset.id,
                        actionName: 'view'
                    },
                    
                  }); 
        } 
}