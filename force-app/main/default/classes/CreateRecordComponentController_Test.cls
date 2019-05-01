@isTest
public class CreateRecordComponentController_Test {
    @isTest
    public static void getselectedobj(){
        Test.startTest();
        CreateRecordComponentController CreateRCcontroller=new CreateRecordComponentController();
        CreateRCcontroller.getselectedobj();
        System.assert(CreateRCcontroller.getselectedobj() == null);
        Test.stopTest();
    }
    @isTest
    public static void setselectedobj(){
        Test.startTest();
        CreateRecordComponentController CreateRCcontroller=new CreateRecordComponentController();
        String obj='Account';
        CreateRCcontroller.setselectedobj(obj);
        System.assert(obj != null);
        Test.stopTest();

    }
    @isTest
    public static void getRecId(){
        Test.startTest();
        CreateRecordComponentController CreateRCcontroller=new CreateRecordComponentController();
        CreateRCcontroller.getrecId();
        Test.stopTest();
    }
    @isTest
    public static void setRecId(){
        AccountInsert a=new AccountInsert();
        Test.startTest();
        CreateRecordComponentController CreateRCcontroller=new CreateRecordComponentController();
        CreateRCcontroller.SelectedObj='Account';
        CreateRCcontroller.setrecId(a.acc.Id);
        Test.stopTest();
    }
    @isTest
    public static void initInsetter(){
        AccountInsert a=new AccountInsert();
        Test.startTest();
        CreateRecordComponentController CreateRCcontroller=new CreateRecordComponentController();
        CreateRCcontroller.SelectedObj='Account';
        CreateRCcontroller.initInsetter();
        CreateRCcontroller.recId=a.acc.Id;
        CreateRCcontroller.initInsetter();
        CreateRCcontroller.getAvailableRecordTypes();
        // CreateRCcontroller.SelectedObj='Contracts';
        // CreateRCcontroller.recId=a.acc.Id;
        // CreateRCcontroller.initInsetter();
        Test.stopTest();
    }
    @isTest
    public static void getRecordTypeIdFromRecordId(){
        Opportunity opp=new Opportunity(Name='opp1',closeDate=System.Today(),stageName='prospecting');
        Test.startTest();
        CreateRecordComponentController CreateRCcontroller=new CreateRecordComponentController();
        CreateRCcontroller.selectedObj='Opportunity';
        CreateRCcontroller.getRecordTypeIdFromRecordId(opp.Id);
        Test.stopTest();
    }
    // @isTest
    // public static void getAvailableRecordTypes(){
    //     Test.startTest();
    //     CreateRecordComponentController CreateRCcontroller=new CreateRecordComponentController();
    //     CreateRCcontroller.selectedObj='Account';
    //     CreateRCcontroller.getAvailableRecordTypes();
    //     Test.stopTest();
    // }
    @isTest
    public static void initSelectedRecordTypeId(){
        Test.startTest();
        CreateRecordComponentController CreateRCcontroller=new CreateRecordComponentController();
        CreateRCcontroller.initSelectedRecordTypeId();
        Test.stopTest();
    }
    @isTest
    public static void restGet(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        CreateRecordComponentController.restGet('https://www.login.salesforce.com','Get','qsdswj1234567');
        CreateRecordComponentController.toolingAPISOQL('SELECT Id FROM Account');
        Test.stopTest();
    }
    @isTest
    public static void getProfileId(){
        Site_User__c site=new Site_User__c(name='Aniket',profile__c='System Administrator');
        insert site;
        Site_User__c site1=new Site_User__c(name='Aniket',profile__c='custom usr');
        insert site1;
        Test.startTest();
        PageReference pageRef = Page.HeaderPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('UserId',site.Id);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        CreateRecordComponentController CreateRCcontroller=new CreateRecordComponentController();
        CreateRCcontroller.getProfileId();
        // ApexPages.currentPage().getParameters().put('UserId',site1.Id);
        // CreateRCcontroller.getProfileId();
        CreateRecordComponentController.getLayoutNameForCurrentUserProfile('gdgsgds1234','hfdhfkds23434');
        Test.stopTest();
    }
    @isTest
    public static void showAppropriatePageLayout(){
         Site_User__c site=new Site_User__c(name='Aniket',profile__c='System Administrator');
         insert site;
         AccountInsert a=new AccountInsert();
         Section__c s=new Section__c();
         s.name='Description';
         s.column__c=1;
         s.fields_developer_Name__C='Detail';
         s.ObjectName__C='account';
         insert s;
         Test.startTest();
         //ApexPages.currentPage().getParameters().put('UserId',site.Id);
         CreateRecordComponentController CreateRCcontroller=new CreateRecordComponentController();
         CreateRCcontroller.selectedObj='account';
         CreateRCcontroller.showAppropriatePageLayout();
         ApexPages.currentPage().getParameters().put('UserId',site.Id);
         String i=CreateRCcontroller.getRecordTypeIdFromRecordId(a.acc.Id);
         CreateRCcontroller.selectedRecordTypeId=i;
         CreateRCcontroller.showAppropriatePageLayout();
         Test.stopTest();
    }
    //  @isTest
    // public static void showAppropriatePageLayout1(){
    //     Site_User__c site=new Site_User__c(name='Aniket',profile__c='System Administrator');
    //     AccountInsert a=new AccountInsert();
    //     CreateRecordComponentController CreateRCcontroller=new CreateRecordComponentController();
    //     CreateRCcontroller.selectedObj='account';
    //     CreateRCcontroller.recId=a.acc.Id;
    //    // CreateRCcontroller.selectedRecordTypeId;
    //     ApexPages.currentPage().getParameters().put('UserId',site.Id);
    //     String i=CreateRCcontroller.getRecordTypeIdFromRecordId(a.acc.Id);
    //     CreateRCcontroller.selectedRecordTypeId=i;
    //    // CreateRCcontroller.initInsetter();
    //     CreateRCcontroller.showAppropriatePageLayout();
    // }
    @isTest
    public static void sendEmailMsg(){
        Test.startTest();
        CreateRecordComponentController CreateRCcontroller=new CreateRecordComponentController();
        CreateRCcontroller.sendEmailMsg('hi');
        Test.stopTest();
    }
}