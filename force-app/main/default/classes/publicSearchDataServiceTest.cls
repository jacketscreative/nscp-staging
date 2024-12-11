@isTest
private class publicSearchDataServiceTest {
    @TestSetup static void createRegister() {
        
        Account acc = new Account(FirstName = 'TestAcctFirstName',
                                      LastName='TestAcctLastName',
                                      Pharmacy_Licence_Number__c= 2012,
                                      PersonMailingCity='Montreal',
                                      PersonMailingCountry= 'Canada');
        insert acc; 
        List<Registration__c> testReg = new List<Registration__c>();
        for(Integer i=0;i<2;i++) {
            testReg.add(new Registration__c(Type__c='Pharmacist',
                                            Class__c='Practicing Direct',
                                            Expiry_Date__c=Date.newInstance(2025, 12, 31),
                                            Registrant__c=acc.id));
        }
        insert testReg; 
    }
    @isTest
    static void getPharmacyRecordsTest() {
        // retrive all data
        List<Registration__c> data = new List<Registration__c>();
        data = publicSearchDataService.getPharmacyRecords(true,'0','','','');
        //retrive filter data
        data = publicSearchDataService.getPharmacyRecords(false,'2012','Canada','Montreal','Hi');
        data = publicSearchDataService.getPharmacyRecords(false,'2012',null,null,null);
        data = publicSearchDataService.getPharmacyRecords(false,null,null,null,null);
    }
     @isTest
    static void getPharmacyRecordsTest1() {
        // retrive all data
        List<Registration__c> data = new List<Registration__c>();
        data = publicSearchDataService.getPharmacyRecords(false,null,null,null,null);
    }
    @isTest
    static void getPharmacyRecordsTest2() {
        // retrive all data
        List<Registration__c> data = new List<Registration__c>();
         data = publicSearchDataService.getPharmacyRecords(false,null,'Canada','Montreal','Hi');
    }
    @isTest
    static void getPharmacistRecordsTest(){
        List<Registration__c> data = new List<Registration__c>();
        data = publicSearchDataService.getPharmacistRecords(true,null,null,null);
        // data = publicSearchDataService.getPharmacistRecords(false,'2012','TestAcctFirstName','TestAcctLastName');
        data = publicSearchDataService.getPharmacistRecords(false,'2012',null,null);
        data = publicSearchDataService.getPharmacistRecords(false,null,'TestAcctFirstName',null);
        data = publicSearchDataService.getPharmacistRecords(false,null,null,'TestAcctLastName');
        data = publicSearchDataService.getPharmacistRecords(false,null,null,null);
    }
    @isTest
    static void getPharmacistRecordsTest1(){
        List<Registration__c> data = new List<Registration__c>();
        data = publicSearchDataService.getPharmacistRecords(false,null,null,null);
    }
    @isTest
    static void getPharmacistRecordsTest2(){
        List<Registration__c> data = new List<Registration__c>();
         data = publicSearchDataService.getPharmacistRecords(false,null,'TestAcctFirstName',null);
    }
}