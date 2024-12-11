@isTest
private class InvoiceEmailUtil2Test {

    @isTest
    static void myUnitTest() {
        // TO DO: implement unit test
        String recipient = 'test@test.com';
        String firstName = 'testFirst';
        String ownerName = 'testLast';
        String paymentLink = 'https://google.com';
        String orgName = 'NSCP';
        String subject = '[IGNORE] Test Subject'; 
        String fileName = 'Testfile.txt';
        Blob pdfBlob = Blob.valueOf('a');
        String renewalYear = '2025';
        InvoiceEmailUtil2.sendInvoiceEmail(recipient,firstName,ownerName,paymentLink,orgName,subject,fileName,pdfBlob,renewalYear);
    }
}