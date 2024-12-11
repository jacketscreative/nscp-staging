import { LightningElement,track, api, wire } from 'lwc';
import getApplicationTemplate from '@salesforce/apex/terrabbit_declarationController.getApplicationTemplate';
import updateAnswers from '@salesforce/apex/terrabbit_declarationController.updateAnswers';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';


export default class Terrabbit_declaration extends NavigationMixin ( LightningElement ) {
    @api applicationTemplateId;
    @api caseId;
    @api recordId;
    @track mapOfValues=[];
    @track isCollapsed = false;
    @track showSave = false;

    selectedPicklistValue = '';
    //a01Dy000005of8HIAQ
   
    @wire(CurrentPageReference) pageRef;

    connectedCallback(){
        if (this.pageRef && this.caseId == null) {
            this.caseId = this.pageRef.attributes.recordId;
        }

      getApplicationTemplate({caseId:  this.caseId }).then(result => {

        if (result){ 
            console.log('entered result');
            var leadRecs = result;
            console.log(leadRecs);
            for (var key in leadRecs){
                console.log(leadRecs[key].decRecordWrapperInstance);
                this.mapOfValues.push({value: leadRecs[key].decRecordWrapperInstance, key:key,descriptionDec:leadRecs[key].decDescription});
                console.log(leadRecs[key].decDescription);
            }
            this.mapOfValues =  this.mapOfValues.map((outerItem) => ({
                ...outerItem,isCollapsed: true,
                value: outerItem.value.map((innerItem, index) => ({
                    ...innerItem,
                    displayNumber: index + 1,
                    
                }))
            }));
            console.log(JSON.stringify(this.mapOfValues));
        }

        else{
            cocnsole.log('error');
        }

      });
    }

    toggleCollapse(event) {

        const key = event.target.dataset.key;

    // Find the specific section in MapOfValues based on the key
   if (this.mapOfValues.find(item => item.key === key).isCollapsed==false){
        this.mapOfValues.find(item => item.key === key).isCollapsed=true;
    }
    else if (this.mapOfValues.find(item => item.key === key).isCollapsed==true){
    this.mapOfValues.find(item => item.key === key).isCollapsed=false;
    }

    this.mapOfValues = [...this.mapOfValues];
    console.log(this.mapOfValues.find(item => item.key === key).isCollapsed);
    }

    get pickListOptions() {
        return [
            { label: 'Yes', value: 'Yes' },
            { label: 'No', value: 'No' },
        ];
    }

    handlePicklistChange(event) {
        const key = event.target.dataset.id;
        const answer = event.detail.value;
  
        updateAnswers({DecQuestionId:key , DecQuestionResponse:answer }).then(result => {});
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