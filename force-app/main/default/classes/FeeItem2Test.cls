@IsTest
public class FeeItem2Test {
    
    @IsTest
    public static void testParameterizedConstructor() {
        // Test the parameterized constructor
        String expectedName = 'Service Fee';
        Decimal expectedAmount = 100.00;
        Decimal expectedHST = 13.00;
        
        FeeItem2 feeItem = new FeeItem2(expectedName, expectedAmount, expectedHST);
        
        // Assert that the properties are set correctly
        System.assertEquals(expectedName, feeItem.Name, 'Name should match the value passed to the constructor');
        System.assertEquals(expectedAmount, feeItem.Amount_c, 'Amount_c should match the value passed to the constructor');
        System.assertEquals(expectedHST, feeItem.HST_c, 'HST_c should match the value passed to the constructor');
    }
    
    @IsTest
    public static void testDefaultConstructor() {
        // Test the default constructor
        FeeItem2 feeItem = new FeeItem2();
        
        // Assert that the properties are initialized to null/default values
        System.assertEquals(null, feeItem.Name, 'Name should be null for default constructor');
        System.assertEquals(null, feeItem.Amount_c, 'Amount_c should be null for default constructor');
        System.assertEquals(null, feeItem.HST_c, 'HST_c should be null for default constructor');
    }
}