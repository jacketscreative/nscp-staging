@isTest
public class PharLicenRenewalAppEmailServiceTest {
    
    @isTest
    static void testGenerateAndSendRenewalForm() {
        // Create a test case to associate with the ContentVersion
        Case testCase = new Case(
            Subject = 'Test Case for Pharmacy License Renewal',
            Status = 'New'
        );
        insert testCase;

        // Create a Network record
        // Network network = new Network(
        //     Name = 'NSCP Registrant Portal'
        // );
        // insert network;

        // Prepare the test data for AppRenewalFormPdfAttachment
        AppRenwalForOwner request = new AppRenwalForOwner();
        request.renewalYear = '2024';
        request.nscpRegistrationNum = '12345';
        request.accountId = '001xxxxxxxxxxxx';  // Use a valid Account ID if available
        request.pharmacyStaff = new List<String>{'John Doe', 'Jane Doe'};
        request.pharManagerId = '005xxxxxxxxxxxx';  // Use a valid User ID if available
        request.pharOwnerId = '005xxxxxxxxxxxx';    // Use a valid User ID if available
        request.pharOwnerRepId = '005xxxxxxxxxxxx'; // Use a valid User ID if available
        request.providesMethadoneServ = 'true';
        request.useOtherPharForPckg = 'false';
        request.avgPriscriptionFilled = '75';
        request.totalOpenHour = '12';
        request.avgSchulPharHours = '5';
        request.avgSchulPharTechHours = '3';
        request.avgSchulDispensaryStaffHours = '4';
        request.pharOfferedServ = 'Breakfast';
        request.directors = new List<String>{'John Doe', 'Jane Doe'};
        request.recipientEmail = 'owner@example.com';
        request.firstName = 'Pharmacy Owner';
        request.caseId = testCase.Id;

        // Create a list of requests
        List<AppRenwalForOwner> requests = new List<AppRenwalForOwner>{ request };

        // Execute the method
        Test.startTest();
        PharLicenRenewalAppEmailService.generateAndSendRenewalForm(requests);
        Test.stopTest();

        // Verify that a ContentVersion record was created
        List<ContentVersion> contentVersions = [SELECT Id, Title, PathOnClient, VersionData FROM ContentVersion WHERE FirstPublishLocationId = :testCase.Id];
        System.assertEquals(1, contentVersions.size(), 'One ContentVersion record should have been created');
        System.assertEquals('ApplicationForm.pdf', contentVersions[0].Title, 'ContentVersion title should match');
        
    }
}