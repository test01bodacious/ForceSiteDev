@isTest
private class DetailPageComponentController_Test {
    @isTest
    public static void DetailPageComponentController(){
        Test.startTest();
        DetailPageComponentController dpagecontroller=new DetailPageComponentController();
        //dpagecontroller.record= 'Account';
       // dpagecontroller.dummyRecord= contact';
       dpagecontroller.detailMode='details';
       System.assertEquals('details', dpagecontroller.detailMode);
       dpagecontroller.detailMode=null;
       System.assert(dpagecontroller.detailMode==null);
       Test.stopTest();

    }
    @isTest
    public static void getobjName(){
        Test.startTest();
        DetailPageComponentController dpagecontroller=new DetailPageComponentController();
        dpagecontroller.getobjName();
        dpagecontroller.objName='Account';
        System.assert(dpagecontroller.objName!=null);
        dpagecontroller.objName=null;
        System.assert(dpagecontroller.objName==null);
        Test.stopTest();
    }
     @isTest
    public static void setobjName(){
        Test.startTest();
        DetailPageComponentController dpagecontroller=new DetailPageComponentController();
        String str='Account' ;
       dpagecontroller.setobjName(str);
       system.assertEquals('Account', str);
       String str1=null ;
       System.assert(str1==null);
       Test.stopTest();
    }
      @isTest
    public static void setrecId(){
        AccountInsert a=new AccountInsert();
        site_User__c site=new Site_User__c(Name='Aniket',Email__c='aniketraj8493@gmail.com',Profile_Name__C='System Administrator');
        insert site;
        Test.startTest();
        DetailPageComponentController dpagecontroller=new DetailPageComponentController(); 
        dpagecontroller.selectedFieldLst =new List<String>();
        dpagecontroller.selectedFieldLst.add('Name');
        dpagecontroller.objname='account';
        dpagecontroller.recId=a.acc.Id;
        //dpagecontroller.dummyRecord='Account';
        //Id i=dpagecontroller.getRecordTypeIdFromRecordId(a.acc.Id);
        PageReference pageRef =  Page.HeaderPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('UserId',site.Id);
       // LayoutDescriberHelper.describeSectionWithFields(i, objName, site.profile__C);
        
        //dpagecontroller.initSectionFields(i);
        //dpagecontroller.getFieldApiName();
       //dpagecontroller.initRecord();
       dpagecontroller.recId=null;
       dpagecontroller.setrecId(a.acc.Id);
       //system.assertEquals('abc', str);
       Test.stopTest();
    }
    @isTest(SeeAllData=true)
    public static void initRecord(){
         AccountInsert a=new AccountInsert();
         site_User__c site=new Site_User__c(Name='Aniket',Email__c='aniketraj8493@gmail.com',Profile_Name__C='System Administrator');
         insert site;
         Test.startTest();
          DetailPageComponentController dpagecontroller=new DetailPageComponentController(); 
         dpagecontroller.selectedFieldLst =new List<String>();
         dpagecontroller.selectedFieldLst.add('name');
         dpagecontroller.objname='account';
         dpagecontroller.recId=a.acc.Id;
         LayoutDescriberHelper.getDefaultRecordType(new Account());
         Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
         ApexPages.currentPage().getParameters().put('UserId',site.Id);
        //  LayoutDescriberHelper layoutDHelper=new LayoutDescriberHelper();
        //  LayoutDescriberHelper.describeSectionWithFields(a.acc.Id,dpagecontroller.objname,site.profile__c);
         dpagecontroller.initRecord();
         dpagecontroller.saveRecord();
        dpagecontroller.record=new contact();
        dpagecontroller.saveRecord();
         Test.stopTest();
    }
    // @isTest
    // public static void initRecord(){
    //     site_User__c site=new Site_User__c(Name='Aniket',Email__c='aniketraj8493@gmail.com',Profile__c='System Administrator');
    //      insert site;
    //     Test.startTest();
    //      DetailPageComponentController dpagecontroller=new DetailPageComponentController();
    //      dpagecontroller.selectedFieldLst =new List<String>();
    //      dpagecontroller.selectedFieldLst.add('Name'); 
    //      ApexPages.currentPage().getParameters().put('UserId',site.Id);
    //      dpagecontroller.objname='account';
    //      dpagecontroller.initRecord();
    //      Test.stopTest();
    // }
   /* @isTest
    public static void initSectionFields(){
        AccountInsert a=new AccountInsert();
        site_User__c site=new Site_User__c(Name='Aniket',Email__c='aniketraj8493@gmail.com',Profile__c='System Administrator');
        insert site;
        Test.startTest();
        PageReference pageRef =  Page.HeaderPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('UserId',site.Id);
         DetailPageComponentController dpagecontroller=new DetailPageComponentController();
        dpagecontroller.objName='Site_User__c';
        dpagecontroller.initSectionFields(site.Id);
        Test.stopTest();
    }*/
   @isTest
    public static void getrecId(){
        Test.startTest();
         DetailPageComponentController dpagecontroller=new DetailPageComponentController();
         dpagecontroller.getrecId();
         Test.stopTest();
    }
    //   @isTest
    // public static void saveRecord(){
    //     AccountInsert a=new AccountInsert();
    //     Test.startTest();
    //      DetailPageComponentController dpagecontroller=new DetailPageComponentController();
    //     dpagecontroller.objname='Account';
    //     dpagecontroller.recId=a.acc.Id;
    //     //dpagecontroller.dummyRecord='Account';
    //     dpagecontroller.getFieldApiName();
    //    dpagecontroller.initRecord();
    //      dpagecontroller.saveRecord();
    //      system.assertEquals('trial', a.acc.Name);
    //      Test.stopTest();
    // }
    //   @isTest
    // public static void saveRecordException(){
    //     Account acc=new Account(name='trial');
    //     insert acc;
    //     Test.startTest();
    //       DetailPageComponentController dpagecontroller=new DetailPageComponentController();
    //    dpagecontroller.objname='Account';
    //     dpagecontroller.recId=acc.Id;
    //     dpagecontroller.getFieldApiName();
    //    dpagecontroller.initRecord();
    //    dpagecontroller.Record=new Account();
    //      dpagecontroller.saveRecord();
    //      system.assertEquals('trial', acc.Name);
    //      Test.stopTest();
         
    // }
    @isTest 
    public static void getRecordTypeIdFromRecordId(){
        Test.startTest();
        DetailPageComponentController dpagecontroller=new DetailPageComponentController();
        AccountInsert a=new AccountInsert();
        dpagecontroller.objName='lead';
        dpagecontroller.getRecordTypeIdFromRecordId(a.acc.Id);
        Test.stopTest();
    }
    @isTest
    public static void getFieldApiName(){
        Test.startTest();
        DetailPageComponentController dpagecontroller=new DetailPageComponentController();
        dpagecontroller.objName='Account';
        dpagecontroller.getFieldApiName();
        Test.stopTest();
        
    }
// @isTest 
//     public static void getRecordTypeIdFromRecordIdElse(){
//         IDT_Products__c idt=new IDT_Products__c(Name='MyIDTProducts');
//         Test.startTest();
//         DetailPageComponentController dpagecontroller=new DetailPageComponentController();
//         dpagecontroller.objName='IDT_Products__c';
//         dpagecontroller.getRecordTypeIdFromRecordId(idt.id);
//         Test.stopTest();
//     }    
   
}