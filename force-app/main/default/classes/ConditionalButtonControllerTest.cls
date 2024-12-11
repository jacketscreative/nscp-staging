@isTest
private class ConditionalButtonControllerTest {
    @testSetup
    static void setupTestData() {
        // Create a test record for ChargentOrder
        ChargentOrders__ChargentOrder__c order = new ChargentOrders__ChargentOrder__c(
            ChargentOrders__Bank_Name__c = 'Test bank'
        );
        insert order;
        
        // Create a test record for Fee
        Fee__c fee = new Fee__c(
            Name = 'Application for Pharmacy Certificate',
            Amount__c = 100,
            Total_With_HST__c = 113,
            Payment__c = order.id
            
        );
        insert fee;
    }

    @isTest
    static void myUnitTest() {
        ChargentOrders__ChargentOrder__c order = [SELECT Id FROM ChargentOrders__ChargentOrder__c LIMIT 1];
       
        ApexPages.StandardController stdController = new ApexPages.StandardController(order);
        ConditionalButtonController controller = new ConditionalButtonController(stdController);

        controller.getHasFee();
    }


}