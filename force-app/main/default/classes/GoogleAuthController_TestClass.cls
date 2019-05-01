@isTest
public class GoogleAuthController_TestClass {
    @isTest
    public static void GoogleAuthController(){
        Test.startTest();
        GoogleAuthController gacontroller=new GoogleAuthController();
        gacontroller.isrecordlistVisible=false;
        gacontroller.authtoken='atoken123';
        gacontroller.refereshtoken='rtoken321';
        gacontroller.bodyprint='body';
        gacontroller.mybodyprint='mybody';
        gacontroller.status='intiating';
       // gacontroller.user='profile';
        gacontroller.uid='abc01234';
        gacontroller.flag=true;
        gacontroller.isLoggedIn=true;
        gacontroller.isEmailVerified=false;
        //gacontroller.userinfo='info';
        gacontroller.objName='account';
        gacontroller.functionality='function';
        //gacontroller.objList='object';
        gacontroller.customObj='Myobj__c';
        gacontroller.customFunctionality='custom';
        System.assertEquals(false, gacontroller.isrecordlistVisible);
        System.assertEquals('atoken123', gacontroller.authtoken);
        System.assertEquals('rtoken321', gacontroller.refereshtoken);
        System.assertEquals('body', gacontroller.bodyprint); 
        System.assertEquals('mybody', gacontroller.mybodyprint);
        System.assertEquals('intiating', gacontroller.status);
        System.assertEquals('abc01234', gacontroller.uid);
        System.assertEquals(true, gacontroller.flag);
        System.assertEquals(true, gacontroller.isLoggedIn);
        System.assertEquals(false, gacontroller.isEmailVerified);
        System.assertEquals('account', gacontroller.objName);
        System.assertEquals('function', gacontroller.functionality);
        System.assertEquals('Myobj__c', gacontroller.customObj);
        System.assertEquals('custom', gacontroller.customFunctionality); 
       

        Test.stopTest();
    }
    @isTest(SeeAllData=true)
    public static void initcredentials(){
        Test.startTest();
        GoogleAuthController.initCredentials();
       Test.stopTest();
    }
     @isTest
    public static void initcredentials1(){
        Test.startTest();
        GoogleAndConnectedAppCredentials__c gauth=new GoogleAndConnectedAppCredentials__c();
        gauth.name='Credential1';
        insert gauth;
        GoogleAuthController.initCredentials();
        System.assertEquals('Credential1', gauth.name);
        Test.stopTest();
    }
    @isTest
    public static void initcredentials2(){
        Test.startTest();
        GoogleAuthController.initCredentials();
       Test.stopTest();
    }
    @isTest
    public static void connect(){
        Test.startTest();
        GoogleAuthController gacontroller=new GoogleAuthController();
        gacontroller.connect();
        
        //gacontroller.connect();
        Test.stopTest();


    }
    @isTest
    public static void ShowToken(){
        Test.startTest();
        GoogleAuthController gacontroller=new GoogleAuthController();
        gacontroller.showtoken();
        Test.stopTest();

    }
    @isTest
    public static  void ShowToken1(){
        Test.startTest();
        PageReference pageRef = Page.GoogleAuth;
        Test.setCurrentPage(pageRef);
        GoogleAuthController gacontroller=new GoogleAuthController();
        gacontroller.flag=true;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
       // gacontroller.showtoken();  
       
        //gacontroller.flag=false;
        ApexPages.currentPage().getParameters().put('code','test');
        gacontroller.showtoken();
        //gacontroller.showtoken();
        Test.stopTest();
    }
    @isTest
    public static void ShowToken2(){
        Test.startTest();
        PageReference pageRef = Page.GoogleAuth;
        Test.setCurrentPage(pageRef);
        GoogleAuthController gacontroller=new GoogleAuthController();
        gacontroller.bodyprint=null;
        gacontroller.flag=false;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        gacontroller.showtoken();  
       
        //gacontroller.flag=false;
        ApexPages.currentPage().getParameters().put('code','test');
        gacontroller.showtoken();
      // gacontroller.bodyprint=null;

        Test.stopTest();

    }
    @isTest
    public static void ShowToken3(){
        Test.startTest(); 
        PageReference pageRef = Page.GoogleAuth;
        Test.setCurrentPage(pageRef);
        GoogleAuthController gacontroller=new GoogleAuthController();
        //gacontroller.bodyprint='hi';
       GoogleAuthController.GoogleInfo ginfo=new GoogleAuthController.GoogleInfo();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());
       // gacontroller.showtoken();  
       
      
       //gacontroller.userEmail='a@b.com';
        ApexPages.currentPage().getParameters().put('code','test');
        gacontroller.showtoken();
       gacontroller.mybodyprint = '{"totalSize":2,"done":true,"records":[{"attributes":{"type":"MyUser__c","url":"/services/data/v43.0/sobjects/MyUser__c/a010b00000f9kYQAAY"},"Name":"pritamraj.rits@gmail.com","MyUser_PassWord__c":null},{"attributes":{"type":"MyUser__c","url":"/services/data/v43.0/sobjects/MyUser__c/a010b00000f9TWeAAM"},"Name":"joshi.chirag2894@gmail.com","MyUser_PassWord__c":null}]}';
       // ginfo.email='aniket@gmail.com';
       //ginfo.verified_email='aniket@gmail.com';
       // gacontroller.fetchProfile();
      // gacontroller.bodyprint=null;
      
        Test.stopTest();

    }
    /*@isTest
    public static void ShowToken4(){
        Test.startTest(); 
        PageReference pageRef = Page.GoogleAuth;
        Test.setCurrentPage(pageRef);
        GoogleAuthController gacontroller=new GoogleAuthController();
        // gacontroller.userEmail=null;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());
       // gacontroller.showtoken();  
       
        //gacontroller.flag=false;
       ApexPages.currentPage().getParameters().put('code','test');
       
       // ginfo.email='aniket@gmail.com';
       //ginfo.verified_email='aniket@gmail.com';
        //gacontroller.fetchProfile();
         gacontroller.showtoken();
      // gacontroller.bodyprint=null;
      
        Test.stopTest();

    }*/

    @isTest
    public static void GoogleInfo(){
        GoogleAuthController.GoogleInfo ginfo=new GoogleAuthController.GoogleInfo();
    }
}