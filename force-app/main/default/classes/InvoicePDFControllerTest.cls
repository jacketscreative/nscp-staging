@isTest
private class InvoicePDFControllerTest {
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
        
        ChargentOrders__Transaction__c transactions = new ChargentOrders__Transaction__c(
            ChargentOrders__Gateway_Date__c = System.today(),
            ChargentOrders__Order__c = 'a0WJQ000000crph2AA'
        );
        insert transactions;
            
    }


    @isTest
    static void myUnitTest() {
        ChargentOrders__ChargentOrder__c testOrder = [SELECT Id FROM ChargentOrders__ChargentOrder__c LIMIT 1];
		
		ChargentOrders__Transaction__c test_transaction = [SELECT ChargentOrders__Gateway_Date__c from ChargentOrders__Transaction__c LIMIT 1];
        
        
        ApexPages.currentPage().getParameters().put('id', testOrder.Id);

        InvoicePDFController controller = new InvoicePDFController();

        controller.getHasFees();
    }
}