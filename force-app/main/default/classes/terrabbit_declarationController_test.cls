@isTest
public class terrabbit_declarationController_test {
    
    
    @isTest
    static void testGetApplicationTemplate() {
        
        Case c = new Case();
        c.Subject='test case';
        c.Status='Submitted';
        c.Pending_Status__c='NSCP';
        insert c ;
        
        Declaration_Questions_Template__c dqt =new Declaration_Questions_Template__c();
        dqt.name = 'test';
        insert dqt ;
        
        Declaration_Question__c dq = new Declaration_Question__c() ;
        dq.Application__c=c.Id ;
        dq.Description__c='test';
        dq.Declaration_Question_Template_Id__c = dqt.id;
        dq.Declaration__c =null;
        insert dq;
        
        Declaration_Template__c decTemp = new Declaration_Template__c() ;
        decTemp.Name ='test template' ;
        insert decTemp;
        
        Declaration__c dec = new Declaration__c();
        dec.Name='test';
        dec.Application__c=c.Id ;
        dec.Declaration_Template_Id__c = decTemp.Id;
        insert dec ;
        
        
        Declaration_Question__c dq1 = new Declaration_Question__c() ;
        dq1.Application__c=c.Id ;
        dq1.Declaration_Question_Template_Id__c = dqt.id;
        dq1.Declaration__c =dec.id;
        dq1.Description__c='test';
        dq1.Name='test dq';
        dq1.Status__c='Submitted';
        dq1.Declaration_Question_Response__c='test';
        
        
        insert dq1;
        
        
        
        ////////
        
        Declaration_Question__c decQuestion = new Declaration_Question__c(
            Name = 'Test Question',
            Description__c = 'Test Description',
            Declaration_Question_Response__c = 'Test Response'
            // Add more fields as needed
        );
        
        // Create test data dependencies (e.g., related Declaration__c record)
        Declaration__c dec2 = new Declaration__c(
            Name = 'Test Declaration'
            // Add required fields
        );
        dec2.Description__c='tewwtaga';
        insert dec2;
        
        decQuestion.Declaration__c = dec2.Id;
        decQuestion.Application__c = c.id;
        insert decQuestion;
        
        // Create boolean variables for testing flags
        Boolean isDecDisabled = true;
        Boolean isCaseDisable = false;
        Boolean isExternalUser = true;
        
        // Instantiate DecRecordWrapper
        /*terrabbit_declarationController.DecRecordWrapper wrapper = new terrabbit_declarationController.DecRecordWrapper(
            decQuestion,
            isDecDisabled,
            isCaseDisable,
            isExternalUser
        );*/
        
        // Call the getApplicationTemplate method
        //  Map<String, List<terrabbit_declarationController.DecRecordWrapper>> result = 
        //  terrabbit_declarationController.getApplicationTemplate(String.valueof(c.Id));
        Test.startTest();
        Map<String, terrabbit_declarationController.DeclarationWrapper> result = terrabbit_declarationController.getApplicationTemplate(String.valueOf(c.Id));
        Test.stopTest();
        
        
        
    }
    
    @isTest
    static void testUpdateAnswers() {
        
        
        Case c = new Case();
        c.Subject='test case';
        c.Status='New';
        c.Pending_Status__c='NSCP';
        insert c ;
        
        Declaration_Questions_Template__c dqt =new Declaration_Questions_Template__c();
        dqt.name = 'test';
        insert dqt ;
        
        Declaration_Template__c decTemp = new Declaration_Template__c() ;
        decTemp.Name ='test template' ;
        
        Declaration__c dec = new Declaration__c();
        dec.Name='test';
        dec.Application__c=c.Id ;
        dec.Declaration_Template_Id__c = decTemp.Id;
        dec.Description__c='tesign';
        insert dec ;
        
        Declaration_Question__c dq = new Declaration_Question__c() ;
        dq.Application__c=c.Id ;
        dq.Declaration_Question_Template_Id__c = dqt.id;
        dq.Declaration__c =dec.id;
        dq.Description__c='test';
        dq.Name='test dq';
        dq.Status__c='Submitted';
        dq.Declaration_Question_Response__c='test';
        insert dq;
        // Call the updateAnswers method
        String result = terrabbit_declarationController.updateAnswers(dq.Id, 'New Response');
        
        // Perform assertions
        
        // Verify that the response was updated
        //  Declaration_Question__c updatedQuestion = [SELECT Declaration_Question_Response__c FROM Declaration_Question__c WHERE Id = :dq.Id];
        //  System.assertEquals('New Response', updatedQuestion.Declaration_Question_Response__c, 'Response should be updated to "New Response"');
    }
    
    @isTest
    static void testDecRecordWrapper() {
        // Create a test Declaration_Question__c record
        Declaration_Question__c decQuestion = new Declaration_Question__c(
            Name = 'Test Question',
            Description__c = 'Test Description',
            Declaration_Question_Response__c = 'Test Response'
            // Add more fields as needed
        );
        
        // Create test data dependencies (e.g., related Declaration__c record)
        Declaration__c dec = new Declaration__c(
            Name = 'Test Declaration'
            // Add required fields
        );
        dec.Description__c='tewwtaga';
        insert dec;
        
        decQuestion.Declaration__c = dec.Id;
        insert decQuestion;
        
        // Create boolean variables for testing flags
        Boolean isDecDisabled = true;
        Boolean isCaseDisable = false;
        Boolean isExternalUser = true;
        
        // Instantiate DecRecordWrapper
        terrabbit_declarationController.DecRecordWrapper wrapper = new terrabbit_declarationController.DecRecordWrapper(
            decQuestion,
            isDecDisabled,
            isCaseDisable,
            isExternalUser
        );
        
        // Perform assertions
        System.assertEquals(decQuestion.Id, wrapper.Id);
        System.assertEquals('Test Description', wrapper.Description);
        System.assertEquals('Test Question', wrapper.decQuestionName);
        //System.assertEquals('Test Declaration', wrapper.declarationName);
        System.assertEquals('Test Response', wrapper.decQuestionResponse);
        System.assertEquals(true, wrapper.decDisabled);
        System.assertEquals(false, wrapper.caseDisabled);
        System.assertEquals(true, wrapper.externalUser);
    }
    
}