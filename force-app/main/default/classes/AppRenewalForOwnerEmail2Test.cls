@isTest
public class AppRenewalForOwnerEmail2Test {
    
    @isTest
    static void testSendEmail() {
        // Test data setup
        String recipient = 'testuser@example.com';
        String firstName = 'John';
        String fileName = 'TestDocument.pdf';
        Blob pdfBlob = Blob.valueOf('This is a test PDF content');

        // Create a sample email template
        EmailTemplate emailTemplate = new EmailTemplate(
            Name = 'SPharmacy Owner Form Email',
            Subject = 'Application Renewal For Owner',
            HtmlValue = '<html><body>Hello {!customerName},</body></html>',
            Body = 'Hello {!customerName},',
            TemplateType = 'custom',
            DeveloperName = 'Application_Renewal_Template',
            FolderId = UserInfo.getUserId()
        );
        insert emailTemplate;

        // Start test execution
        Test.startTest();

        // Call the method to send an email and ensure no exceptions occur
        try {
            AppRenewalForOwnerEmail2.sendEmail(recipient, firstName, fileName, pdfBlob);
            System.assert(true, 'Email send method completed without exception.');
        } catch (Exception e) {
            System.assert(false, 'Email send method threw an unexpected exception: ' + e.getMessage());
        }

        Test.stopTest();
    }
}