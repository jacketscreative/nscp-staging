public class PharmacyReceiptController {
    public ChargentOrders__ChargentOrder__c order {get; set;}
    public List<Fee__c> fees {get; set;}
	public ChargentOrders__Transaction__c transactions {get; set;}
    public Decimal total {get; set;}
    public Decimal totalWithHST {get; set;}
    public Decimal totalHST {get; set;}
    public String formattedDate { get; set; }
    
    public PharmacyReceiptController(){
        Id RecordId  = ApexPages.currentPage().getParameters().get('id');

        this.order = [SELECT Id, Name, ChargentOrders__Account__r.Name, ChargentOrders__Contact__r.Name, CreatedDate, ChargentOrders__Payment_Method__c, ChargentOrders__Account__r.BillingStreet, ChargentOrders__Account__r.BillingPostalCode, ChargentOrders__Account__r.BillingCity, ChargentOrders__Account__r.BillingState from ChargentOrders__ChargentOrder__c where id = :RecordId];
        this.fees = [SELECT Id, Name, Amount__c, Total_With_HST__c from Fee__c where Payment__r.Id = :RecordId];
        this.transactions = [SELECT ChargentOrders__Gateway_Date__c from ChargentOrders__Transaction__c where ChargentOrders__Order__r.Id = :RecordId Order by ChargentOrders__Gateway_Date__c DESC LIMIT 1];
        
        Decimal grandTotal = 0;
        Decimal grandTotalWithHST = 0;

        for (Fee__c fee : this.fees) {
            grandTotal += fee.Amount__c;
            grandTotalWithHST += fee.Total_With_HST__c;
        }
        this.total = grandTotal;
        this.totalWithHST = grandTotalWithHST;
        this.totalHST = grandTotalWithHST - grandTotal;
        this.formattedDate = String.valueOf(this.transactions.ChargentOrders__Gateway_Date__c.format('yyyy-MM-dd'));
    }
    
    public Boolean getHasFees() {
        return !fees.isEmpty();
    }

}