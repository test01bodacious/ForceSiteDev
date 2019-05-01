@isTest
public  class HeaderComponentHandler_Test {
//    @isTest
//     public static void HeaderComponentHandler(){
//         Test.startTest();
//         HeaderComponentHandler headerCHandler=new HeaderComponentHandler();
//         headerCHandler.profile='System Administrator';
//         headerCHandler.activeTab='Account';
//         headerCHandler.objList[0]='Contact';
//         headerCHandler.functionality='Read';
//         headerCHandler.searchText='Account1';
//         headerCHandler.query='SELECT Id,Name FROM Account';
//         headerCHandler.QUERY_lIMIT=100;
//         headerCHandler.isChatter=true;
//         System.assertEquals('System Administrator', headerCHandler.profile);
//         System.assertEquals('Account', headerCHandler.activeTab);
//         System.assert(headerCHandler.objList!=null);
//         System.assertEquals('Read', headerCHandler.functionality);
//         System.assertEquals('Account1', headerCHandler.searchText);
//         System.assertEquals('SELECT Id,Name FROM Account', headerCHandler.query);
//         System.assertEquals(100, headerCHandler.QUERY_lIMIT);
//         System.assertEquals(true, headerCHandler.isChatter);
//         Test.stopTest();
//     }
//     @isTest
//     public static void getuid(){
//         Test.startTest();
//         HeaderComponentHandler headerCHandler=new HeaderComponentHandler();
//         headerCHandler.uid='Abc12304';
//         headerCHandler.getuid();
//         System.assert(headerCHandler.uid != null);
//         Test.stopTest();
//     }
//      @isTest
//     public static void setuid(){
//         Test.startTest();
//         HeaderComponentHandler headerCHandler=new HeaderComponentHandler();
//         headerCHandler.setuid('Abc1234');
//         System.assert(headerCHandler.uid != null);
//         Test.stopTest();
//     }
//     @isTest
//     public static void headerComponent(){
//          Test.startTest();
//          MyUserDataFactory myuser=new MyUserDataFactory();
//          PageReference pageRef =  Page.HeaderMainPage;
//          Test.setCurrentPage(pageRef);
//          ApexPages.currentPage().getParameters().put('UserId',myuser.my.Id);
//          HeaderComponentHandler headerCHandler=new HeaderComponentHandler();
//          System.assert(myuser.my.Id != null);
//          System.assertEquals('System Administrator', myuser.my.profile__c);
//          System.assertEquals('aniketraj8493@gmail.com', myuser.my.name);
//          Test.stopTest();
//     }
//     @isTest
//     public static void getObjName(){
//         Test.startTest();
//         HeaderComponentHandler headerCHandler=new HeaderComponentHandler();
//         headerCHandler.getObjName();
//         System.assert(headerCHandler.objName !=null);
//         Test.stopTest();
//     }
//     @isTest
//     public static void setObjName(){
//         Test.startTest();
//         HeaderComponentHandler headerCHandler=new HeaderComponentHandler();
//         headerCHandler.setobjName('Contact');
//         System.assert(headerCHandler.objName != null);
//         System.assert(headerCHandler.objName =='Contact');
//         Test.stopTest();
//     }
//     @isTest
//     public static void create_ViewRecord(){
//         Test.startTest();
//         HeaderComponentHandler headerCHandler=new HeaderComponentHandler();
//         headerCHandler.functionality='CR';
//         headerCHandler.create_ViewRecord();
//         System.assertEquals('CR', headerCHandler.functionality);
//         headerCHandler.functionality='VE';
//         headerCHandler.create_ViewRecord();
//         System.assertEquals('VE', headerCHandler.functionality);
//         Test.stopTest();
//     }
//     @isTest
//     public static void home(){
//         Test.startTest();
//         HeaderComponentHandler headerCHandler=new HeaderComponentHandler();
//         headerCHandler.home();
//         Test.stopTest();
//     }
//     @isTest
//     public static void chatter(){
//         Test.startTest();
//         HeaderComponentHandler headerCHandler=new HeaderComponentHandler();
//         headerCHandler.chatter();
//         Test.stopTest();
//     }
//     @isTest
//     public static void logout(){
       
//         // MyUserDataFactory myuser=new MyUserDataFactory();
//         userInfo__C userinfo=new userInfo__C();
//         userinfo.name='aniketraj8493@gmail.com';
//         userinfo.email_id__c='aniketraj8493@gmail.com';
//         insert userinfo;
//         Test.startTest();
//         HeaderComponentHandler headerCHandler=new HeaderComponentHandler();
//         headerCHandler.user=new MyUser__c(name='aniketraj8493@gmail.com');
//         headerCHandler.logout();
//         // headerCHandler.user=new MyUser__c(name='aniketsingh8493@gmail.com');
//         // headerCHandler.logout();
//         Test.stopTest();
//     }
//     @isTest
//     public static void logoutException(){
//         HeaderComponentHandler headerCHandler=new HeaderComponentHandler();
//         headerCHandler.logout(); 
//     }
//     @isTest
//     public static void getSearchresult(){
//         Test.startTest();
//         HeaderComponentHandler headerCHandler=new HeaderComponentHandler();
//         headerCHandler.getSearchResult();
//         Test.stopTest();

//     }
//     @isTest
//     public static void initcustomSetting(){
//         // userInfo__C userinfo=new userInfo__C();
//         // userinfo.name='aniketraj8493@gmail.com';
//         // userinfo.email_id__c='aniketraj8493@gmail.com';
//         // insert userinfo;
//         Test.startTest();
//         HeaderComponentHandler headerCHandler=new HeaderComponentHandler();
//         MyUserDataFactory myuser=new MyUserDataFactory();
//         headerCHandler.user=new MyUser__c(name='aniketsingh8493@gmail.com');
//         insert headerCHandler.user;
//         headerCHandler.initCustomSetting();
//         Test.stopTest();
//     }
//     @isTest
//     public static void backTologinPage(){
//         Test.startTest();
//         HeaderComponentHandler headerCHandler=new HeaderComponentHandler();
//         headerCHandler.backToLoginPage();
//         Test.stopTest();

//     }
//     @isTest
//     public static void getFieldsFromFieldset(){
//         Test.startTest();
//         HeaderComponentHandler headerCHandler=new HeaderComponentHandler();
//         headerCHandler.objApiName[0]='Account';
//         headerCHandler.getFieldsFromFieldset(1);
//         Test.stopTest();
//     }
}