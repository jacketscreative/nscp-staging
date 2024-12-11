public without sharing class InvoiceFeeItemController {
	public List<Fee_Line_Item_Template__c> feeItems { get; set; }
    public List<Fee_Line_Item_Template__c> feeItemsList { get; set; }
    public List<String> feeMap { get; set; }
    public Decimal total {get; set;}
    public Decimal HST {get; set;}
    public String todaysDate {get; set;}

    public InvoiceFeeItemController() {
        Date today = Date.today();
        feeMap = new List<String>();
        String formattedDate = String.format('{0}-{1}-{2}', new List<Object>{
            today.month().format().leftPad(2, '0'),
            today.day().format().leftPad(2, '0'),
            today.year()
        });
        this.todaysDate = formattedDate;
        
        // Retrieve string containing fees
        String feeString = ApexPages.currentPage().getParameters().get('fees');
        
        List<String> feeIds = formatStringToList(feeString);
        
        feeItemsList = [SELECT Id, Name, Amount__c, HST__c FROM Fee_Line_Item_Template__c WHERE Id IN :feeIds];
        
        // Retrieve the JSON string from the URL parameter
        String jsonFeeItems = ApexPages.currentPage().getParameters().get('feeItems');
        
        // Deserialize the JSON string back into a List of Fee_Line_Item_Template__c objects
        if (jsonFeeItems != null) {
            feeItems = (List<Fee_Line_Item_Template__c>)JSON.deserialize(jsonFeeItems, List<Fee_Line_Item_Template__c>.class);
        }
        
        Decimal grandTotal = 0;
        Decimal grandTotalWithHST = 0;

        for (Fee_Line_Item_Template__c item : feeItemsList) {
            System.debug('---feeItems Name:'+item.Name+', Amount:'+item.Amount__c + ', HST: '+ item.HST__c);
            feeMap.add(item.Name);
            grandTotal += item.Amount__c;
            grandTotalWithHST += item.HST__c;
            
            item.Amount__c = item.Amount__c.setScale(2);
        }
        grandTotal = grandTotal.setScale(2);
        grandTotalWithHST = grandTotalWithHST.setScale(2);
        
        this.total = grandTotalWithHST;
        this.HST = (grandTotalWithHST - grandTotal).setScale(2);
    }
    
    public List<String> formatStringToList(String inputString) {
        // Check if the input string is null or empty
        if (String.isEmpty(inputString)) {
            return new List<String>();
        }
        
        // Split the input string by semicolon
        List<String> listOfString = inputString.split(';');
                
        return listOfString;
    }
    
}