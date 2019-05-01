@isTest
public  class HeaderPageController_Test {
   @isTest
    public static void HeaderPageController(){
        Test.startTest();
        HeaderPageController HeaderpController=new HeaderPageController();
        HeaderpController.profile='System Administrator';
        HeaderpController.isCreate=true;
        HeaderpController.isTable=true;
        HeaderpController.isGlobalTable=false;
        HeaderpController.isChatter=true;
        HeaderpController.isLoggedIn=true;
        HeaderpController.isHome=true;
        HeaderpController.searchText='account';
        HeaderpController.QUERY_lIMIT=4;
        System.assertEquals('System Administrator', HeaderpController.profile) ;
        System.assertEquals(true, HeaderpController.isCreate) ;
        System.assertEquals(true, HeaderpController.istable) ;
        System.assertEquals(false, HeaderpController.isGlobalTable) ;
        System.assertEquals(true, HeaderpController.isChatter) ;
        System.assertEquals(true, HeaderpController.isLoggedIn) ;
        System.assertEquals(true, HeaderpController.isHome) ;
        System.assertEquals('account', HeaderpController.searchText);
        Test.stopTest();

    }
    @isTest
    public static void HeaderPageController1(){
        site_User__c site=new Site_User__c(Name='Aniket',Email__c='aniketraj8493@gmail.com',Profile__c='System Administrator');
        insert site;
        Test.startTest();
        PageReference pageRef =  Page.HeaderPage;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('UserId',site.Id);
        HeaderPageController HeaderpController=new HeaderPageController();
        HeaderpController.isHome=true;
        Test.stopTest();
    }
    @isTest
    public static void getuid(){
        Test.startTest();
        HeaderPageController HeaderpController=new HeaderPageController();
        HeaderpController.getuid();
        Test.stopTest();
    }
    @isTest
    public static void setuid(){
        AccountInsert a=new AccountInsert();
        Test.startTest();
        HeaderPageController HeaderpController=new HeaderPageController();
        HeaderpController.setuid(a.acc.Id);
        Test.stopTest();
    }
    @isTest
    public static void isNameSpacePrefix(){
        Test.startTest();
        HeaderPageController HeaderpController=new HeaderPageController();
        HeaderPageController.isNameSpacePrefix(HeaderpController);
        HeaderpageController.getClassName(new HeaderPageController());
        Test.stopTest();
    }
    @isTest
    public static void getClassName(){
        Test.startTest();
        HeaderPageController.getClassname(new HeaderPageController());
        Test.stopTest();
    }
    @isTest
    public static void getObjName(){
        Test.startTest();
        HeaderPageController HeaderpController=new HeaderPageController();
        HeaderpController.getObjName();
        Test.stopTest();
    }
    @isTest
    public static void setObjName(){
        Test.startTest();
        HeaderPageController HeaderpController=new HeaderPageController();
        HeaderpController.setobjName('account');
        Test.stopTest();
    }
    @isTest
    public static void prepareObjectList(){
        Object__c obj=new Object__c();
        obj.Name='Account';
        obj.Fields__c='Account Name';
        obj.Developer_Name__c='Account';
        obj.Fields_Developer_Name__c='Name';
        insert obj;
        Test.startTest();
        HeaderPageController HeaderpController=new HeaderPageController();
        HeaderpController.prepareObjectList();
        Test.stopTest();
    }
     @isTest
    public static void prepareObjectListElse(){
        List<Object__c> lobj=new List<Object__c>();
        for(integer i=0;i<7;i++)
        {
            Object__c obj=new Object__c();
            obj.Name='Account'+i;
            obj.Fields__c='Account Name'+i;
            obj.Developer_Name__c='Account'+i;
            obj.Fields_Developer_Name__c='Name'+i;
            obj.view__c='All Records View';
            lobj.add(obj);
        }
        insert lobj;
        Test.startTest();
        HeaderPageController HeaderpController=new HeaderPageController();
        HeaderpController.prepareObjectList();
        Test.stopTest();
    }
     @isTest
    public static void prepareObjectListException(){
        Object__c obj=new Object__c();
        obj.Name='Account';
        obj.Fields__c='Account Name';
       // schema.Developer_Name__c='Account';
        //schema.Fields_Developer_Name__c='Name';
        insert obj;
        Test.startTest();
        HeaderPageController HeaderpController=new HeaderPageController();
        HeaderpController.prepareObjectList();
        Test.stopTest();
    }
    @isTest
    public static void initRecTypeInfoLst(){
        Test.startTest();
        HeaderPageController HeaderpController=new HeaderPageController();
        HeaderpController.objName='lead';
        HeaderpController.initRecTypeInfoLst();
        Test.stopTest();
    }
    @isTest(SeeAllData=true)
    public static void create_ViewRecord(){
        UserInfo__c usr=new UserInfo__c();
        usr.Email_Id__c='aniketraj8493@gmail.com';
        usr.name='aniketraj8493@gmail.com';
        insert usr;
        site_User__c site=new Site_User__c(Name='Aniket',Email__c=usr.Email_Id__c,Profile__c='System Administrator');
        insert site;
        Test.startTest();
        LayoutDescriberHelper.getDefaultRecordType(new Account());
        HeaderPageController HeaderpController=new HeaderPageController();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        ApexPages.currentPage().getParameters().put('UserId',site.Id);
        HeaderpController.objName='account';
        HeaderpController.profile='System Administrator';
        HeaderpController.functionality='CR';
        HeaderpController.create_ViewRecord();
        System.assertEquals('CR', HeaderpController.functionality);
        HeaderpController.functionality='VE';
        HeaderpController.create_ViewRecord();
        System.assertEquals('VE', HeaderpController.functionality);
        Test.stopTest();
    }
   /* @isTest
    public static void create_viewRecord1(){
        UserInfo__c usr=new UserInfo__c();
        usr.Email_Id__c='aniketraj8493@gmail.com';
        usr.name='aniketraj8493@gmail.com';
        insert usr;
        site_User__c site=new Site_User__c(Name='Aniket',Email__c=usr.Email_Id__c,Profile__c='System Administrator');
        insert site;
        Test.startTest();
        LayoutDescriberHelper.getDefaultRecordType(new Account());
        HeaderPageController HeaderpController=new HeaderPageController();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        ApexPages.currentPage().getParameters().put('UserId',site.Id);
        HeaderpController.objName='lead';
        HeaderpController.profile='System Administrator';
        HeaderpController.functionality='CR';
        HeaderpController.create_ViewRecord();
        Test.stopTest();
    }*/
    @isTest
    public static void getQuery(){
        Test.startTest();
        HeaderPageController headerpController=new HeaderPageController();
        headerpController.objName='account';
        headerpController.fieldList=new List<String>{'name'};
        headerpController.getQuery();
        Test.stopTest();
    }
    @isTest
    public static void home(){
        Test.startTest();
        PageReference pageRef =  Page.HeaderPage;
        Test.setCurrentPage(pageRef);
        HeaderPageController headerpController=new HeaderPageController();
        headerpController.home();
        Test.stopTest();
    }
    @isTest
    public static void chatter(){
        Test.startTest();
        HeaderPageController headerpController=new HeaderPageController();
        headerpController.chatter();
        Test.stopTest();
    }
    @isTest
    public static void logout(){
        UserInfo__c usr=new UserInfo__c();
        usr.Email_Id__c='aniketraj8493@gmail.com';
        usr.name='aniketraj8493@gmail.com';
        insert usr;
        Site_User__c site=new Site_User__c();
        site.Name='Aniket';
        site.Email__c=usr.Email_Id__c;
        site.Profile__c='System Administrator';
        insert site;
        Test.startTest();
        PageReference pageRef =  Page.HeaderPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('UserId',site.Id);
        HeaderPageController headerpController=new HeaderPageController();
        headerpController.logout();
        Test.stopTest();
    }
    @isTest
    public static void initCustomSetting(){
        Test.startTest();
        PageReference pageRef =  Page.HeaderPage;
        Test.setCurrentPage(pageRef);
        //ApexPages.currentPage().getParameters().put('UserId',site.Id);
        HeaderPageController headerpController=new HeaderPageController();
        headerpController.initCustomSetting();
        Test.stopTest();
    }
  /*   @isTest
    public static void initCustomSettingException(){
         UserInfo__c usr=new UserInfo__c();
        usr.Email_Id__c='aniketraj8493@gmail.com';
        usr.name='aniketraj8493@gmail.com';
        insert usr;
         Site_User__c site=new Site_User__c();
        site.Name='Aniket';
        site.Email__c='aniketsingh@gmail.com';
        site.Profile__c='System Administrator';
        insert site;
        Test.startTest();
        PageReference pageRef =  Page.HeaderPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('UserId',site.Id);
        HeaderPageController headerpController=new HeaderPageController();
        headerpController.initCustomSetting();
        Test.stopTest();
    }*/
    @isTest
    public static void getSearchResult(){
        UserInfo__c usr=new UserInfo__c();
        usr.Email_Id__c='aniketraj8493@gmail.com';
        usr.name='aniketraj8493@gmail.com';
        insert usr;
         Site_User__c site=new Site_User__c();
        site.Name='Aniket';
        site.Email__c='aniketsingh@gmail.com';
        site.Profile__c='System Administrator';
        insert site;
        Test.startTest();
         PageReference pageRef =  Page.HeaderPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('UserId',site.Id);
        HeaderPageController headerpController=new HeaderPageController();
        headerpController.getSearchResult();
        Test.stopTest();
    }
    @isTest
    public static void backToLoginPage(){
        Test.startTest();
        PageReference pageRef =  Page.HeaderPage;
        Test.setCurrentPage(pageRef);
        HeaderPageController headerpController=new HeaderPageController();
        headerpController.backToLoginPage();
        Test.stopTest();
    }
    @isTest
    public static void getFieldsFromFieldSet(){
        Object__c obj=new Object__c();
        obj.Name='Account';
        obj.Fields__c='Account Name';
        obj.developer_Name__c='account';
        obj.fields_Developer_Name__c='name';
        obj.view__c='All Records View';
        insert obj;
        Test.startTest();
        HeaderPageController headerpController=new HeaderPageController();
        headerpController.getFieldsFromFieldSet('account');
        Test.stopTest();
    }
}