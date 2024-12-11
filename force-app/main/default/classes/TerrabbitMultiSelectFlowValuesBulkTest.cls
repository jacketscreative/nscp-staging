@isTest
public class TerrabbitMultiSelectFlowValuesBulkTest {
    @isTest
    static void testCheckValues() {
        // Test input with one element and one value
        List<String> values = new List<String> { 'Value 1' };
        List<List<String>> expectedOutput = new List<List<String>> { new List<String> { 'Value 1' } };
        List<List<String>> actualOutput = TerrabbitMultiSelectFlowValuesBulk.CheckValues(values);
        System.assertEquals(expectedOutput, actualOutput);

        // Test input with one element and multiple values
        values = new List<String> { 'Value 1;Value 2;Value 3' };
        expectedOutput = new List<List<String>> { new List<String> { 'Value 1', 'Value 2', 'Value 3' } };
        actualOutput = TerrabbitMultiSelectFlowValuesBulk.CheckValues(values);
        System.assertEquals(expectedOutput, actualOutput);

        // Test input with multiple elements and one value each
        values = new List<String> { 'Value 1', 'Value 2', 'Value 3' };
        expectedOutput = new List<List<String>> { new List<String> { 'Value 1' }, new List<String> { 'Value 2' }, new List<String> { 'Value 3' } };
        actualOutput = TerrabbitMultiSelectFlowValuesBulk.CheckValues(values);
        System.assertEquals(expectedOutput, actualOutput);

        // Test input with multiple elements and multiple values each
        values = new List<String> { 'Value 1;Value 2;Value 3', 'Value 4;Value 5', 'Value 6' };
        expectedOutput = new List<List<String>> { new List<String> { 'Value 1', 'Value 2', 'Value 3' }, new List<String> { 'Value 4', 'Value 5' }, new List<String> { 'Value 6' } };
        actualOutput = TerrabbitMultiSelectFlowValuesBulk.CheckValues(values);
        System.assertEquals(expectedOutput, actualOutput);

        // Test input with empty element
        values = new List<String> { 'Value 1;Value 2;Value 3', '', 'Value 6' };
        expectedOutput = new List<List<String>> { new List<String> { 'Value 1', 'Value 2', 'Value 3' }, new List<String>(), new List<String> { 'Value 6' } };
        actualOutput = TerrabbitMultiSelectFlowValuesBulk.CheckValues(values);
        System.assertEquals(expectedOutput, actualOutput);
    }
}