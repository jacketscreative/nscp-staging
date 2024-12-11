@isTest
public class generateCIHIReportControllerTest {

    // Create test data for CIHI__c
    private static void createTestData() {
        Registration__c reg = new Registration__c(
            Registration_Status__c = 'Active'
        );
        insert reg;
        // Create a test record for CIHI__c
        CIHI__c testRecord = new CIHI__c(
            Date_of_Initial_Registration__c = Date.today(),
            Concurrent_Reg_Province_Territory__c = 'Ontario;Quebec',
            Concurrent_Registration_Country__c = 'Albania;Algeria',
            Postal_Code_of_Residence__c = 'A1B 2C3',
            Year_of_Grad_Highest_of_Post_Basic_Edu__c = 2018,
            Primary_Employment_Annual_Earned_Hours__c = 1000,
            Secondary_Employment_Annual_Earned_Hours__c = 1200,
            Third_Employment_Annual_Earned_Hours__c = 1400,
            Renewal_Year__c = '2025',
            Registration__c = reg.Id
        );
        insert testRecord;
    }

    // Test method for generateCIHIReport
    @isTest
    static void testGenerateCIHIReport() {
        // Arrange: Create test data
        createTestData();

        // Act: Call the method with a renewal year
        Test.startTest();
        List<String> report = generateCIHIReportController.generateCIHIReport('2025');
        Test.stopTest();
        // Additional assertions can be added based on expected output
        // Example: Ensure that the first row starts with a specific pattern
        String firstRow = report[0];

        // Verify that the report contains the expected formatted data
        // You could extract specific values from the generated row and assert them
    }

    // Test for when there are no records
    @isTest
    static void testGenerateCIHIReport_NoRecords() {
        // Arrange: Create test data with no CIHI__c records
        delete [SELECT Id FROM CIHI__c];
        Test.startTest();
        List<String> report = generateCIHIReportController.generateCIHIReport('2025');
        Test.stopTest();
    }
}