public class FeeItem2 {
    @AuraEnabled
    public String Name { get; set; }
    
    @AuraEnabled
    public Decimal Amount_c { get; set; }
    
    @AuraEnabled
    public Decimal HST_c { get; set; }

    public FeeItem2(String Name, Decimal Amount_c, Decimal HST_c) {
        this.Name = Name;
        this.Amount_c = Amount_c;
        this.HST_c = HST_c;
    }
    
    public FeeItem2() {
      
    }
}