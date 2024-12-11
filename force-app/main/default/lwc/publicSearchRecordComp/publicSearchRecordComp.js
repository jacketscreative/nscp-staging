import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import NSCPLogo from "@salesforce/resourceUrl/NSCP_Logo";

export default class PublicSearchRecordComp extends LightningElement {
    NSCPLogoUrl = NSCPLogo;
    currentPageReference;
    @track record = {}
    @wire(CurrentPageReference) getStateParameters(currentPageReference) {
        this.currentPageReference = currentPageReference;
        new Promise(
            (resolve, reject) => {
            setTimeout(() => {
                if(this.currentPageReference){
                    this.record = JSON.parse(this.currentPageReference.state.record);
                    resolve();
                }
            }, 0);
            })                
            .catch((error) => {
                console.error(JSON.stringify(error));
            })
            .finally(() => {
                // disable a spinner if applicable
            }); 
    }

    get fullName(){
        return this.record.firstName+' '+this.record.lastName;
    }

    printRecord(event){
        console.log('hello');
        let lwcContent;
        if(this.record.IsPharmacies){           
            lwcContent = this.template.querySelectorAll(".phcyRecord");
        }else if(this.record.IsPharmacists){
            lwcContent = this.template.querySelectorAll(".phistRecord");
        }
        let imageHeader = this.template.querySelectorAll(".headerImage");
        // const printWindow = window.open('', 'print');
        // printWindow.document.body.innerHTML = imageHeader[0].innerHTML+lwcContent[0].innerHTML;
        // printWindow.print();
        // printWindow.close();
        window.print();
        console.log(lwcContent[0].innerHTML);
    }
}