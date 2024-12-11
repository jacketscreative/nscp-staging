@isTest()
private class terrabbit_uploadDocumentControllerTest {
    @testSetup static void setup() {
        List<ContentVersion> lcv = new List<ContentVersion>();
        List<ContentDocumentLink> lcdl = new List<ContentDocumentLink>();

        Case c01 = new Case(Status='New',Pending_Status__c='NSCP');
        Case c02 = new Case(Status='New',Pending_Status__c='Registrant');
        insert new List<Case>{c01,c02};
        Document__c d01 = new Document__c(Name='Test Document 01',Description__c='Test Description',Document_Status__c= 'Submitted',Application__c=c01.id);
        Document__c d02 = new Document__c(Name='Test Document 02',Description__c='Test Description',Document_Status__c= 'New',Application__c=c02.id);
        insert new List<Document__c>{d01,d02};
        
        ContentVersion contentVersion1 = new ContentVersion(
            Title          = 'Test Document 01',
            PathOnClient   = 'Pic01.jpg',
            VersionData    = Blob.valueOf('Test Content 01'),
            IsMajorVersion = true);
            lcv.add(contentVersion1);
        ContentVersion contentVersion2 = new ContentVersion(
            Title          = 'Test Document 02',
            PathOnClient   = 'Pic02.jpg',
            VersionData    = Blob.valueOf('Test Content 02'),
            IsMajorVersion = true);
            lcv.add(contentVersion2);
        insert lcv;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink cdl01 = new ContentDocumentLink();
            cdl01.LinkedEntityId = d01.id;
            cdl01.ContentDocumentId = documents[0].Id;
            cdl01.ShareType = 'V';
            cdl01.Visibility = 'AllUsers';
            lcdl.add(cdl01);
            ContentDocumentLink cdl02 = new ContentDocumentLink();
            cdl02.LinkedEntityId = d02.id;
            cdl02.ContentDocumentId = documents[1].Id;
            cdl02.ShareType = 'V';
            cdl02.Visibility = 'AllUsers';
            lcdl.add(cdl02);
        insert lcdl;
        }

    @isTest
    static void myUnitTest() {
        // TO DO: implement unit test
        List<Case> c = [Select id from case];
        terrabbit_uploadDocumentController.getApplicationTemplate(c.get(0).id);
        terrabbit_uploadDocumentController.getApplicationTemplate(c.get(1).id);
    }
}