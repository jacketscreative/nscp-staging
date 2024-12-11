public without sharing class terrabbit_declarationController {
    
    @AuraEnabled(cacheable = false)
    public Static Map <String,DeclarationWrapper> getApplicationTemplate(String caseId) {
        //   User u = [ SELECT Id FROM User WHERE id =  '005Hp00000iQ6C5IAK' LIMIT 1 ];
        
        //   System.runAs(u){
        Set <Id> DecQuesTemplateId = new Set <id>();
        Map<Id, Id> DecQuestionAndTemplateMap = new Map <Id, Id>();
        List <DeclarationWrapper> decRecords = new List<DeclarationWrapper>();
        Boolean caseDisabled = false;
        Boolean externalUser = false;
        
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        
        if (profileName == 'NSCP Registrant'){
            externalUser = true;
        }
        
        
        List <Declaration_Question__c> lsDecQuestions = [SELECT Id, Declaration_Question_Template_Id__c FROM Declaration_Question__c WHERE Application__c =: caseId AND Declaration__c = null ];
        system.debug('###lsDecQuestions '+lsDecQuestions);
        
        
        for (Declaration_Question__c decQuestion : lsDecQuestions){
            DecQuesTemplateId.add(decQuestion.Declaration_Question_Template_Id__c);
            
        }
        
        List <Declaration_Questions_Template__c> lsDecQuesTemplate = [ SELECT Declaration_Template__c FROM Declaration_Questions_Template__c WHERE Id IN: DecQuesTemplateId ]; 
        system.debug('###lsDecQuesTemplate '+lsDecQuesTemplate);
        
        for (Declaration_Question__c decQuestion : lsDecQuestions){
            for (Declaration_Questions_Template__c decQuesTemplate : lsDecQuesTemplate){
                
                if(decQuestion.Declaration_Question_Template_Id__c == decQuesTemplate.id){
                    //   if(DecQuestionAndTemplateMap.containsKey(decQuestion.Id)){
                    DecQuestionAndTemplateMap.put(decQuestion.Id, decQuesTemplate.Declaration_Template__c);
                    //   }
                }
            }
            
        }
        
        
        List <Declaration__c> lsDeclaration = [SELECT Id, Declaration_Template_Id__c FROM Declaration__c WHERE Application__c =: caseId ];
        system.debug('###lsDeclaration'+lsDeclaration);
        
        for (Declaration_Question__c decQuestion : lsDecQuestions){
            for (Declaration__c declaration : lsDeclaration){
                system.debug('###DecQuestionAndTemplateMap'+DecQuestionAndTemplateMap);
                if(declaration.Declaration_Template_Id__c == DecQuestionAndTemplateMap.get(decQuestion.id)){
                    system.debug('entered this');
                    decQuestion.Declaration__c = declaration.id;
                }
            }
            
        }
        
        update lsDecQuestions;
        
        // }
        
        
        Map <String,DeclarationWrapper> declarationTempMap = new Map <String,DeclarationWrapper>();
        List <Declaration_Question__c> lsDecTemp = [SELECT id, Description__c, Name, Status__c,Declaration__r.Name,Declaration__r.Description__c,Order__c, Declaration_Question_Response__c, Application__r.status, Application__r.Pending_Status__c FROM Declaration_Question__c WHERE Application__c =: caseId and Hidden__c = false and Declaration__r.Hidden__c = false Order by Order__c ASC];
        for(Declaration__c varDec : [SELECT id,Name,Order__c,Description__c from Declaration__c where Application__c =:caseId and Hidden__c = false order by Order__c ASC]){
            if(!declarationTempMap.keyset().contains(varDec.Name)){
                declarationTempMap.put(varDec.Name, new DeclarationWrapper(varDec.Description__c));    
            }
        }
        for ( Declaration_Question__c decTemp : lsDecTemp ){
            
            if(decTemp.Application__r.status != 'New' && decTemp.Application__r.Pending_Status__c != 'Registrant'){
                system.debug('###case disable to true');
                caseDisabled = true;
            }
            
            if(!declarationTempMap.keyset().contains(decTemp.Declaration__r.Name)){
                declarationTempMap.put(decTemp.Declaration__r.Name,  new DeclarationWrapper(decTemp.Declaration__r.Description__c));    
            }
            system.debug('--->decTemp '+decTemp);
            system.debug('--->decTempDeclaration__r.Name '+decTemp.Declaration__r.Name);
            system.debug('--->decTemp '+decTemp);
            
            if(declarationTempMap.keyset().contains(decTemp.Declaration__r.Name) && decTemp.Status__c == 'Submitted'){
                declarationTempMap.get(decTemp.Declaration__r.Name).decRecordWrapperInstance.add(new DecRecordWrapper(decTemp, true, caseDisabled, externalUser));
            }
            
            else if(declarationTempMap.keyset().contains(decTemp.Declaration__r.Name)){
                declarationTempMap.get(decTemp.Declaration__r.Name).decRecordWrapperInstance.add(new DecRecordWrapper(decTemp, false, caseDisabled, externalUser));
            }
        }
        
        system.debug(declarationTempMap);
        return declarationTempMap;
    }
    
    
    
    @AuraEnabled(cacheable = false)
    public static String updateAnswers( String DecQuestionId, String DecQuestionResponse) {
        
        List <Declaration_Question__c> lsDeclaration = [SELECT Declaration_Question_Response__c FROM Declaration_Question__c WHERE Id =: DecQuestionId ];
        
        for (Declaration_Question__c declaration : lsDeclaration){
            declaration.Declaration_Question_Response__c = DecQuestionResponse;
        }
        update lsDeclaration;
        
        // List<DecAnswers> decAns = (List<DecAnswers>) JSON.deserialize(Answers, List<DecAnswers>.class);
        // system.debug(decAns);
        return null;
        
    }
    /*
@AuraEnabled
public static String updateDecQuestions( String caseId ) {

Set <Id> DecQuesTemplateId = new Set <id>();
Map<Id, Id> DecQuestionAndTemplateMap = new Map <Id, Id>();

List <Declaration_Question__c> lsDecQuestions = [SELECT Id, Declaration_Question_Template_Id__c FROM Declaration_Question__c WHERE Application__c =: caseId AND Declaration__c = null ];

for (Declaration_Question__c decQuestion : lsDecQuestions){
DecQuesTemplateId.add(decQuestion.Declaration_Question_Template_Id__c);

}

List <Declaration_Questions_Template__c> lsDecQuesTemplate = [ SELECT Declaration_Template__c FROM Declaration_Questions_Template__c WHERE Id IN: DecQuesTemplateId ]; 

for (Declaration_Question__c decQuestion : lsDecQuestions){
for (Declaration_Questions_Template__c decQuesTemplate : lsDecQuesTemplate){

if(decQuestion.Declaration_Question_Template_Id__c == decQuesTemplate.id){
//   if(DecQuestionAndTemplateMap.containsKey(decQuestion.Id)){
DecQuestionAndTemplateMap.put(decQuestion.Id, decQuesTemplate.Declaration_Template__c);
//   }
}
}

} 


List <Declaration__c> lsDeclaration = [SELECT Id, Declaration_Template_Id__c FROM Declaration__c WHERE Application__c =: caseId ];

for (Declaration_Question__c decQuestion : lsDecQuestions){
for (Declaration__c declaration : lsDeclaration){
if(declaration.Declaration_Template_Id__c == DecQuestionAndTemplateMap.get(decQuestion.id)){
decQuestion.Declaration__c = declaration.id;
}
}

}

update lsDecQuestions;

// List<DecAnswers> decAns = (List<DecAnswers>) JSON.deserialize(Answers, List<DecAnswers>.class);
// system.debug(decAns);
return null;

} */
    
    public class DecAnswers{
        
        @AuraEnabled
        public string value;
        @AuraEnabled
        public string key;
        
        public DecAnswers(String Des, String Ans){
            
            this.key = Des;
            this.value = Ans;
        }
    }
    
    public class DeclarationWrapper{
        @AuraEnabled
        public String decDescription{ get; set; }
        @AuraEnabled
        public List<DecRecordWrapper> decRecordWrapperInstance{ get; set;}
        public DeclarationWrapper(String Description){
            this.decDescription = Description;
            this.decRecordWrapperInstance = new List<DecRecordWrapper>();
        }
    }
    public class DecRecordWrapper {
        @AuraEnabled
        public Id Id { get; set; }
        
        @AuraEnabled
        public String Description { get; set; }
        
        @AuraEnabled
        public String decQuestionName { get; set; }
        
        @AuraEnabled
        public String declarationName { get; set; }
        
        @AuraEnabled
        public String decQuestionResponse { get; set; }
        
        @AuraEnabled
        public Boolean decDisabled { get; set; }
        
        @AuraEnabled
        public Boolean caseDisabled { get; set; }
        
        @AuraEnabled
        public Boolean externalUser { get; set; }
        
        
        public DecRecordWrapper(Declaration_Question__c declaration, Boolean isDecDisabled, Boolean isCaseDisable, Boolean isExternalUser) {
            this.Id = declaration.Id;
            system.debug('---->declaration'+declaration);
            system.debug('---->declaration.Description__c.stripHtmlTags()'+declaration.Description__c.stripHtmlTags());
            this.Description = declaration.Description__c.stripHtmlTags();
            this.decQuestionName = declaration.Name;
            this.declarationName=declaration.Declaration__r.Name;
            this.decQuestionResponse = declaration.Declaration_Question_Response__c;
            this.decDisabled = isDecDisabled;
            this.caseDisabled = isCaseDisable;
            this.externalUser = isExternalUser;
        }
    }
}