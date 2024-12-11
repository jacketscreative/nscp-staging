public with sharing class terrabbit_uploadDocumentController {
    @AuraEnabled(cacheable = true)
    public Static List <DocRecordWrapper> getApplicationTemplate(String caseId) {
        Boolean caseDisabled = false;
        Boolean hasFiles = false;
        Boolean externalUser = false;
        List <Document__c> lsDocTemp = [SELECT id, Name, Description__c, Application__r.status, Application__r.Pending_Status__c, Document_Status__c FROM Document__c WHERE Application__c =: caseId ];
        List <DocRecordWrapper> docRecords = new List<DocRecordWrapper>();
        //List <Case> lsCase = [ SELECT Id FROM Case WHERE  ];
        Map <id, List <ContentDocumentLink>> cdMap = new Map <Id, List <ContentDocumentLink>>();
        List <id> lsIds = new List <id>();

        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;

        if (profileName == 'NSCP Registrant'){
            externalUser = true;
        }

        for (Document__c doc : lsDocTemp){

            lsIds.add(doc.id);

        }

        List <ContentDocumentLink> lsFile = [SELECT id, ContentDocument.Title, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: lsIds ORDER BY ContentDocument.CreatedDate Desc ];


        for (ContentDocumentLink cdl : lsFile){
            if(!cdMap.containsKey(cdl.LinkedEntityId)){
                cdMap.put(cdl.LinkedEntityId, new List <ContentDocumentLink>());
            }

            if(cdMap.containsKey(cdl.LinkedEntityId)){
                cdMap.get(cdl.LinkedEntityId).add(cdl);
            }
            
           
        }
        System.debug('###cdMap'+cdMap);
        
        for (Document__c doc : lsDocTemp){

            if(doc.Application__r.status != 'New' && doc.Application__r.Pending_Status__c != 'Registrant'){
                caseDisabled = true;
            }

            if(cdMap.containsKey(doc.id)){

                Integer numberOfRecs = cdMap.get(doc.id).size()-1;
                system.debug('entered this');
                if (doc.Document_Status__c == 'Submitted'){
                    if (numberOfRecs > 0){
                    docRecords.add(new DocRecordWrapper(doc, true, caseDisabled, externalUser, true, cdMap.get(doc.id).get(0).ContentDocument.Title+' + '+numberOfRecs+' more ' ));
                    }
                    else{
                        docRecords.add(new DocRecordWrapper(doc, true, caseDisabled, externalUser, true, cdMap.get(doc.id).get(0).ContentDocument.Title));    
                    }
                }
                else{
                    if (numberOfRecs > 0){
                    docRecords.add(new DocRecordWrapper(doc, false, caseDisabled, externalUser, true, cdMap.get(doc.id).get(0).ContentDocument.Title+' + '+numberOfRecs+' more ' ));
                    }
                    else{
                    docRecords.add(new DocRecordWrapper(doc, false, caseDisabled, true, externalUser, cdMap.get(doc.id).get(0).ContentDocument.Title ));
  
                    }
                }
                
            }
            else{
            if (doc.Document_Status__c == 'Submitted'){
                docRecords.add(new DocRecordWrapper(doc, true, caseDisabled, externalUser, false, null));
            }
            else{
                docRecords.add(new DocRecordWrapper(doc, false, caseDisabled, externalUser, false, null));
            }
        }
        }
        
        system.debug(lsDocTemp);
        system.debug(docRecords);
        return docRecords;
    }

    @AuraEnabled(cacheable = false)
    public Static String  getLatestFile(String documentId) {
        List <ContentDocumentLink> lsFile = [SELECT id, ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId =: documentId ORDER BY ContentDocument.CreatedDate Desc ];
        
        if (lsFile.size()>1){
       // system.debug(lsFile.size()+' '+lsFile.get(0).ContentDocument.Title);
            Integer numberOfRecs = lsFile.size()-1;
            return lsFile.get(0).ContentDocument.Title+' + '+numberOfRecs+' more ';
        }
        else{
            return lsFile.get(0).ContentDocument.Title;
        }
    }

    // Wrapper class to structure the data for Lightning web component
    public class DocRecordWrapper {
        @AuraEnabled
        public Id Id { get; set; }

        @AuraEnabled
        public String Name { get; set; }

        @AuraEnabled
        public String Description { get; set; }

        @AuraEnabled
        public Boolean docDisabled { get; set; }

        @AuraEnabled
        public Boolean caseDisabled { get; set; }

        @AuraEnabled
        public Boolean externalUser { get; set; }

        @AuraEnabled
        public Boolean hasFiles { get; set; }

        @AuraEnabled
        public String FileName { get; set; }

        public DocRecordWrapper(Document__c document, Boolean docDisabled, Boolean caseDisabled, Boolean externalUser, Boolean hasFiles, String FileName ) {
            this.Id = document.Id;
            this.Name = document.Name;
            this.Description = document.Description__c;
            this.docDisabled = docDisabled;
            this.caseDisabled = caseDisabled;
            this.hasFiles = hasFiles;
            this.FileName = FileName;
            this.externalUser = externalUser;
        }
    }
}