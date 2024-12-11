@isTest
public class PharmacyLicenseRenewalAppControllerTest {
    @isTest
    static void testPharmacyLicenseRenewalAppController() {
        // Create test data
        Account pharmacy = new Account(
            Name = 'Test pharmacy',
            BillingStreet = '123 Test St',
            BillingCity = 'Test City',
            BillingState = 'CA',
            BillingPostalCode = '90001',
            BillingCountry = 'USA',
            Phone = '1234567890',
            Email__c = 'pharmacy@test.com',
            Website = 'www.testpharmacy.com',
            Fax = '0987654321'
        );
        insert pharmacy;

        Contact pharManager = new Contact(
            LastName = 'Pharmacy Manager',
            Email = 'manager@test.com',
            AccountId = pharmacy.Id
        );
        insert pharManager;

        Account pharmacyOwner = new Account(
            Name = 'Pharmacy Owner',
            BillingStreet = '456 Owner St',
            BillingCity = 'Owner City',
            BillingState = 'NY',
            BillingPostalCode = '10001',
            BillingCountry = 'USA',
            Email__c = 'owner@test.com'
        );
        insert pharmacyOwner;

        Contact pharOwnerRep = new Contact(
            LastName = 'Owner Rep',
            Email = 'ownerrep@test.com',
            AccountId = pharmacyOwner.Id
        );
        insert pharOwnerRep;

        // Set up test parameters
        Test.setCurrentPageReference(new PageReference('/apex/pharLicenseRenewalPage'));
        ApexPages.currentPage().getParameters().put('accountId', pharmacy.Id);
        ApexPages.currentPage().getParameters().put('pharManagerId', pharManager.Id);
        ApexPages.currentPage().getParameters().put('pharOwnerId', pharmacyOwner.Id);
        ApexPages.currentPage().getParameters().put('pharOwnerRepId', pharOwnerRep.Id);
        ApexPages.currentPage().getParameters().put('pharOfferedServ', 'Medicine;Injection;Consultation');
        ApexPages.currentPage().getParameters().put('pharmacyStaff', 'John Doe;Jane Smith');
        ApexPages.currentPage().getParameters().put('directors', 'Alice Brown;Bob White');

        // Instantiate the controller
        PharmacyLicenseRenewalAppController controller = new PharmacyLicenseRenewalAppController();

        // Verify that the formatted date is set correctly
        System.assertNotEquals(null, controller.formattedDate, 'Formatted date should not be null');

        // Verify that the pharmacy data is retrieved correctly
        System.assertEquals('Test pharmacy', controller.pharmacy.Name, 'pharmacy name should match');
        System.assertEquals('123 Test St', controller.pharmacy.BillingStreet, 'Billing Street should match');
        System.assertEquals('Test City', controller.pharmacy.BillingCity, 'Billing City should match');
        
        // Verify that the pharmacy manager data is retrieved correctly
        System.assertEquals('Pharmacy Manager', controller.pharManager.Name, 'pharmacy Manager name should match');
        System.assertEquals('manager@test.com', controller.pharManager.Email, 'pharmacy Manager email should match');

        // Verify that the pharmacy owner data is retrieved correctly
        System.assertEquals('Pharmacy Owner', controller.pharmacyOwner.Name, 'pharmacy Owner name should match');
        System.assertEquals('owner@test.com', controller.pharmacyOwner.Email__c, 'pharmacy Owner email should match');

        // Verify that the pharmacy owner rep data is retrieved correctly
        System.assertEquals('Owner Rep', controller.pharOwnerRep.Name, 'pharmacy Owner Rep name should match');
        System.assertEquals('ownerrep@test.com', controller.pharOwnerRep.Email, 'pharmacy Owner Rep email should match');

        // Verify that offered services are formatted correctly
        System.assertEquals('Medicine, Injection, Consultation', controller.offeredServices, 'Offered services should be formatted correctly');

        // Verify that staff members and directors are formatted correctly
        System.assertEquals(2, controller.staffMember.size(), 'Staff member list should have 2 entries');
        System.assertEquals('John Doe', controller.staffMember[0], 'First staff member should match');
        System.assertEquals('Jane Smith', controller.staffMember[1], 'Second staff member should match');

        System.assertEquals(2, controller.directors.size(), 'Directors list should have 2 entries');
        System.assertEquals('Alice Brown', controller.directors[0], 'First director should match');
        System.assertEquals('Bob White', controller.directors[1], 'Second director should match');
    }
}