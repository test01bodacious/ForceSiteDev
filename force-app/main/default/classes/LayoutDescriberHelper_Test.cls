@isTest
private class LayoutDescriberHelper_Test {
@isTest(seeAllData=true)
    public static void describeSectionWithFields(){
        AccountInsert a=new AccountInsert();
        //Contact con=new Contact(LastName='Aniket',AccountId=a.acc.Id);
        Test.startTest();
       // PageReference pageRef = Page.HeaderPage;
       // Test.setCurrentPage(pageRef);
       LayoutDescriberHelper.getDefaultRecordType(new Account());
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        // ApexPages.currentPage().getParameters().put('code','test');
        LayoutDescriberHelper layoutDHelper=new LayoutDescriberHelper();
        LayoutDescriberHelper.describeSectionWithFields(a.acc.Id,'account','System Administrator');
        
        Test.stopTest();
    }
    @isTest(seeAllData=true)
    public static void describeSectionWithFieldsException(){
        AccountInsert a=new AccountInsert();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        // ApexPages.currentPage().getParameters().put('code','test');
        LayoutDescriberHelper layoutDHelper=new LayoutDescriberHelper();
        LayoutDescriberHelper.objName='Student__c';
        LayoutDescriberHelper.describeSectionWithFields(a.acc.Id,'account','System Administrator');
        Test.stopTest();
    }
    @isTest
    public static void adjustFieldAccessibilityMapwithoutNameSpace(){
        Test.startTest();
        LayoutDescriberHelper.FieldName fld=new LayoutDescriberHelper.FieldName('account','Aniket_Raj__account');
        fld.fldstr='name';
        //LayoutDescriberHelper.adjustFieldAccessibilityMapwithoutNameSpace(fld);
        Test.stopTest();
    }
    @isTest
    public static void getReferenceFieldApiName(){
        Test.startTest();
        LayoutDescriberHelper.getReferenceFieldApiName('account','contact');
        Test.stopTest();
    }
    /*@isTest
    public static void getRequiredFields(){
        Test.startTest();
        LayoutDescriberHelper layoutDHelper=new LayoutDescriberHelper();
        LayoutDescriberHelper.objName='IDT_Products__c';
        LayoutDescriberHelper.getRequiredFields();
        //LayoutDescriberHelper.objName='IDT_Products__c';
       // LayoutDescriberHelper.getRequiredFields();
        Test.stopTest();
        
    }*/
    @isTest
    public static void initObjectAndNameSpacePrefix(){
        Test.startTest();
        LayoutDescriberHelper layoutDHelper=new LayoutDescriberHelper();
        LayoutDescriberHelper.getClassName();
        LayoutDescriberHelper.initObjectAndNameSpacePrefix();
        Test.stopTest();
    }
   /* @isTest
    public static void initFieldAccessibility1(){
        Test.startTest();
        LayoutDescriberHelper.profileName='System Administrator';
        LayoutDescriberHelper.initaccessibility1();
        Test.stopTest();
    }*/
    
}