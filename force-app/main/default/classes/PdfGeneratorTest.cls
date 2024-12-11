@isTest
private class PdfGeneratorTest {

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
		Registration__c testRecord = [SELECT Id from Registration__c LIMIT 1];

		PdfGenerator.getCertPharmacistLicenseController(testRecord.Id);
		PdfGenerator.getCertPharmacyLicenseController(testRecord.Id);
		PdfGenerator.getCertPharmacyTechLicenseController(testRecord.Id);
        PdfGenerator.getLetterOfStandingPharmTechController(testRecord.Id);

	}
}