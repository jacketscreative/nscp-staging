@IsTest
public class InvoiceFeeLineItemServiceTest {
    
    @IsTest
    public static void testGenerateAndSendInvoice() {
        // Set up test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Case testCase = new Case(AccountId = testAccount.Id, Subject = 'Test Case');
        insert testCase;
        
        List<Fee_Line_Item_Template__c> feeItems = new List<Fee_Line_Item_Template__c>{
            new Fee_Line_Item_Template__c(Name = 'Service Fee', Amount__c = 100),
            new Fee_Line_Item_Template__c(Name = 'Late Fee', Amount__c = 50)
        };
        insert feeItems;
        
        // Prepare the request object
        InvoiceRequest request = new InvoiceRequest();
        request.customerName = 'John Doe';
        request.street = '123 Main St';
        request.city = 'Anytown';
        request.state = 'CA';
        request.postalCode = '12345';
        request.invoiceNumber = 'INV-123';
        request.paymentMethod = 'Credit Card';
        request.date2 = '2024-10-01';
        request.feeItems = feeItems;
        request.fees = new List<String>{'100', '50'};
        request.recipientEmail = 'john.doe@example.com';
        request.subject = 'Invoice for Services';
        request.body = 'Dear Customer, here is your invoice.';
        request.ownerName = 'Owner Name';
        request.paymentLink = 'https://payment.example.com';
        request.orgName = 'Example Org';
        request.caseId = testCase.Id;
        request.renewalYear = '2024';
        
        List<InvoiceRequest> requests = new List<InvoiceRequest>{request};
        
        Test.startTest();
        
        // Call the method under test
        InvoiceFeeLineItemService.generateAndSendInvoice(requests);
        
        Test.stopTest();
        
        // Assert that a ContentVersion record was created with the correct parent ID
        ContentVersion cv = [SELECT Id, Title, FirstPublishLocationId FROM ContentVersion WHERE FirstPublishLocationId = :testCase.Id LIMIT 1];
        System.assertNotEquals(null, cv, 'ContentVersion should be created');
        System.assertEquals('Invoice.pdf', cv.Title, 'ContentVersion title should be "Invoice.pdf"');
        System.assertEquals(testCase.Id, cv.FirstPublishLocationId, 'FirstPublishLocationId should match the Case ID');
        
        // Optionally check that the PDF blob was generated (it would not be null in production)
        Blob pdfBlob = new InvoiceEmailAttachment().generatePDF(request.customerName, request.street, request.city, request.state, request.postalCode, request.invoiceNumber, request.paymentMethod, request.date2, request.feeItems, request.fees);
        System.assertNotEquals(null, pdfBlob, 'Generated PDF blob should not be null');
        System.assert(pdfBlob.size() > 0, 'Generated PDF blob should have content');
    }
    
    @IsTest
    static void testGenerateAndSendInvoiceWithEmptyFees() {
        // Set up a request object with an empty fees list
        InvoiceRequest request = new InvoiceRequest();
        request.customerName = 'Jane Doe';
        request.street = '456 Main St';
        request.city = 'Othercity';
        request.state = 'TX';
        request.postalCode = '67890';
        request.invoiceNumber = 'INV-456';
        request.paymentMethod = 'Check';
        request.date2 = '2024-11-01';
        request.feeItems = new List<Fee_Line_Item_Template__c>();
        request.fees = new List<String>();  // Empty fees list
        request.recipientEmail = 'jane.doe@example.com';
        request.subject = 'Another Invoice';
        request.body = 'Dear Jane, here is another invoice.';
        request.ownerName = 'Owner Name';
        request.paymentLink = 'https://another-payment.example.com';
        request.orgName = 'Another Org';
        
        Case testCase = new Case(Subject = 'Another Test Case');
        insert testCase;
        
        request.caseId = testCase.Id;
        
        List<InvoiceRequest> requests = new List<InvoiceRequest>{request};
        
        Test.startTest();
        
        // Call the method under test with empty fees
        InvoiceFeeLineItemService.generateAndSendInvoice(requests);
        
        Test.stopTest();
        
        // Assert ContentVersion creation for case
        ContentVersion cv = [SELECT Id, Title, FirstPublishLocationId FROM ContentVersion WHERE FirstPublishLocationId = :testCase.Id LIMIT 1];
        System.assertNotEquals(null, cv, 'ContentVersion should be created for case');
        System.assertEquals('Invoice.pdf', cv.Title, 'ContentVersion title should be "Invoice.pdf" for empty fees list');
        System.assertEquals(testCase.Id, cv.FirstPublishLocationId, 'FirstPublishLocationId should match the Case ID');
    }
}