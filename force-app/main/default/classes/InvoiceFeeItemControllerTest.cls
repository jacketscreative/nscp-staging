@IsTest
public class InvoiceFeeItemControllerTest {
    
    @IsTest
    public static void testInvoiceFeeItemController() {
        // Create test Fee_Line_Item_Template__c records
        List<Fee_Line_Item_Template__c> testFeeItems = new List<Fee_Line_Item_Template__c>();
        testFeeItems.add(new Fee_Line_Item_Template__c(Name = 'Service Fee', Amount__c = 100, HST__c = 113));
        testFeeItems.add(new Fee_Line_Item_Template__c(Name = 'Consultation Fee', Amount__c = 200, HST__c = 226));
        insert testFeeItems;
        
        // Prepare parameters
        Test.startTest();
        
        // Convert test records to a semicolon-separated string for fee parameter
        String feeIds = testFeeItems[0].Id + ';' + testFeeItems[1].Id;
        
        // Serialize fee items to JSON
        String jsonFeeItems = JSON.serialize(testFeeItems);
        
        // Set parameters to simulate a page request
        ApexPages.currentPage().getParameters().put('fees', feeIds);
        ApexPages.currentPage().getParameters().put('feeItems', jsonFeeItems);
        
        // Instantiate the controller
        InvoiceFeeItemController controller = new InvoiceFeeItemController();
        
        // Assert that fee items were retrieved and mapped correctly
        System.assertEquals(2, controller.feeItemsList.size(), 'feeItemsList should contain 2 items');
        
        // Assert on specific field values in the retrieved list
        System.assertEquals('Service Fee', controller.feeItemsList[0].Name, 'First item should be "Service Fee"');
        System.assertEquals('Consultation Fee', controller.feeItemsList[1].Name, 'Second item should be "Consultation Fee"');
        
        // Verify that total and HST are calculated correctly
        System.assertEquals(339, controller.total, 'Total including HST should be 339');
        System.assertEquals(39, controller.HST, 'HST should be 39');
        
        // Verify today's date is set correctly
        Date today = Date.today();
        String expectedFormattedDate = String.format('{0}-{1}-{2}', new List<Object>{
            today.month().format().leftPad(2, '0'),
            today.day().format().leftPad(2, '0'),
            today.year()
        });
        System.assertEquals(expectedFormattedDate, controller.todaysDate, 'todaysDate should match the expected formatted date');
        
        Test.stopTest();
    }
    
    @IsTest
    public static void testFormatStringToList() {
        InvoiceFeeItemController controller = new InvoiceFeeItemController();
        
        // Test with a valid semicolon-separated string
        String testString = 'a;b;c';
        List<String> resultList = controller.formatStringToList(testString);
        System.assertEquals(3, resultList.size(), 'Result list should contain 3 elements');
        System.assertEquals('a', resultList[0], 'First element should be "a"');
        
        // Test with an empty string
        testString = '';
        resultList = controller.formatStringToList(testString);
        System.assertEquals(0, resultList.size(), 'Empty string should return an empty list');
        
        // Test with null string
        resultList = controller.formatStringToList(null);
        System.assertEquals(0, resultList.size(), 'Null string should return an empty list');
    }
}