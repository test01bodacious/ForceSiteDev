@isTest
private class GlobalSearchComponentController_Test {
    @isTest
    public static void globalcontroller(){
        Test.startTest();
        GlobalSearchComponentController globalscontroller=new GlobalSearchComponentController();
        globalscontroller.searchQuery='SELECT ID,Name FROM Account';
        globalscontroller.objName='Account';
        globalscontroller.delRecordId='0010b00002KyMch';
        globalscontroller.profileName='System Administrator';
        globalscontroller.openModal=true;
        globalscontroller.rId='001210b000knm';
        System.assertEquals('SELECT ID,Name FROM Account', globalscontroller.searchQuery);
        System.assertEquals('Account', globalscontroller.objName);
        System.assertEquals('0010b00002KyMch', globalscontroller.delRecordId);
        System.assertEquals('System Administrator', globalscontroller.profileName);
        Test.stopTest();

    }
     @isTest
    public static void openModal(){
        Test.startTest();
        GlobalSearchComponentController globalscontroller=new GlobalSearchComponentController();
        globalscontroller.openModal=false;
        System.assertEquals(false, globalscontroller.openModal);
        Test.stopTest();

    }
    @isTest
    public static void setQuery(){
        Test.startTest();
        String q=' ';
        GlobalSearchComponentController globalscontroller=new GlobalSearchComponentController();
        globalscontroller.setQuery(q);
        System.assertEquals(' ', q);
        Test.stopTest();
    }
    @isTest
    public static void getQuery(){
        Test.startTest();
        GlobalSearchComponentController globalscontroller=new GlobalSearchComponentController();
        globalscontroller.getquery();
        Test.stopTest();
    }
    @isTest
    public static void setProfile(){
        Test.startTest();
        String pr='System Administrator';
        GlobalSearchComponentController globalscontroller=new GlobalSearchComponentController();
        globalscontroller.setProfilename(pr);
        System.assertEquals('System Administrator', pr);
        Test.stopTest();
    }
     @isTest
    public static void getProfile(){
        Test.startTest();
        GlobalSearchComponentController globalscontroller=new GlobalSearchComponentController();
        globalscontroller.getProfilename();
        Test.stopTest();
    }
     @isTest
    public static void getSearchTerm(){
        Test.startTest();
        GlobalSearchComponentController globalscontroller=new GlobalSearchComponentController();
        globalscontroller.getsearchTerm();
        Test.stopTest();
    }
      @isTest
    public static void setSearchTerm(){
        
        GlobalSearchComponentController globalscontroller=new GlobalSearchComponentController();
        //String text='Account';
        Account acc=new Account(Name='Accont', website='Account');
        insert acc;
        Test.startTest();
       //globalscontroller.searchTerm='Account';
      // globalscontroller.objApiName[0]='Account';
        globalscontroller.setsearchTerm('Account');
        Test.stopTest();
    }
    @isTest
    public static void getSearchResult(){
        Account acc=new Account(Name='Account');
        insert acc;
        Test.startTest();
        GlobalSearchComponentController globalscontroller=new GlobalSearchComponentController();
        //String text='Account';
        //globalscontroller.objApiName[0]='Account';
        globalscontroller.searchTerm='Account';
        Test.setFixedSearchResults(new List<Id>{acc.Id});
        globalscontroller.getSearchResult();
        Test.stopTest();
    }
    @isTest
    public static void getSearchResult1(){
        List<Account> lstacc=new List<Account>();
        for(integer i=1;i<5;i++){
            Account a=new Account(name='Account'+i);
            lstacc.add(a);
        }
        insert lstacc;
        Test.startTest();
        GlobalSearchComponentController globalscontroller=new GlobalSearchComponentController();
        //String text='Account';
        //globalscontroller.objApiName[0]='Account';
        globalscontroller.searchTerm='Account';
        Test.setFixedSearchResults(new List<Id>{lstacc[0].Id,lstacc[1].Id,lstacc[2].Id,lstacc[3].Id});
        globalscontroller.getSearchResult();
        Test.stopTest();
    }
     @isTest
    public static void getSearchResult2(){
        List<Account> lstacc=new List<Account>();
        for(integer i=1;i<5;i++){
            Account a=new Account(name='Account'+i);
            lstacc.add(a);
        }
        insert lstacc;
        Test.startTest();
        GlobalSearchComponentController globalscontroller=new GlobalSearchComponentController();
        //String text='Account';
        globalscontroller.objApiName[0]='Account';
        globalscontroller.searchTerm='';
        Test.setFixedSearchResults(new List<Id>{lstacc[0].Id,lstacc[1].Id,lstacc[2].Id,lstacc[3].Id});
        globalscontroller.getSearchResult();
        globalscontroller.searchTerm='a';
        globalscontroller.getSearchResult();
        Test.stopTest();
    }
    /* @isTest
    public static void getSearchResult3(){
        // List<Account> lstacc=new List<Account>();
        // for(integer i=1;i<5;i++){
        //     Account a=new Account(name='Account'+i);
        //     lstacc.add(a);
        // }
        // insert lstacc;
        Test.startTest();
        GlobalSearchComponentController globalscontroller=new GlobalSearchComponentController();
        //String text='Account';
        globalscontroller.objApiName[0]='xyz';
        globalscontroller.searchTerm='student';
       // Test.setFixedSearchResults(new List<Id>{lstacc[0].Id,lstacc[1].Id,lstacc[2].Id,lstacc[3].Id});
        globalscontroller.getSearchResult();
        Test.stopTest();
    }*/
    // @isTest
    // public static void castRecord(){
    //     Test.startTest();
    //     Test.stop
    // }
    @isTest
    public static void showMore(){
        GlobalSearchComponentController globalscontroller=new GlobalSearchComponentController();
        globalscontroller.searchTerm='Account';
        globalscontroller.objName='Account';
        globalscontroller.showMore();

    }
    @isTest
    public static void turnoffModal(){
        Test.startTest();
        GlobalSearchComponentController globalscontroller=new GlobalSearchComponentController();
        globalscontroller.turnOffModal();
        Test.stopTest();
    }
      @isTest
    public static void editRecord(){
        Site_User__c site=new Site_User__c(name='Aniket Raj',Email__c='aniketraj8493@gmail.com');
        insert site;
        Test.startTest();
        userInfo__C userinfo=new userInfo__C();
        userinfo.name=site.name;
        userinfo.email_id__c='aniketraj8493@gmail.com';
        insert userinfo;
        GlobalSearchComponentController globalscontroller=new GlobalSearchComponentController();
        PageReference pageRef =  Page.HeaderPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('UserId',site.Id);
       // globalscontroller.userId=my.id;
        globalscontroller.editRecord();
        //globalscontroller.openModal=true;
       // System.assertEquals(true, globalscontroller.openModal);
        Test.stopTest();

    }
    @isTest
    public static void editRecordException(){
        Test.startTest();
        GlobalSearchComponentController globalscontroller=new GlobalSearchComponentController();
        globalscontroller.editRecord();
        Test.stopTest();

    }

    @isTest
    public static void deleteRecord(){
        Account acc=new Account(Name='Account');
        insert acc;
        Test.startTest();
        GlobalSearchComponentController globalscontroller=new GlobalSearchComponentController();
        globalscontroller.dummyObjName='Account';
        globalscontroller.delRecordId=acc.Id;
        globalscontroller.deleteRecord();
        Test.stopTest();

    }
    @isTest
    public static void deleteRecordexception(){
        Account acc=new Account(Name='Account');
        insert acc;
        Test.startTest();
        GlobalSearchComponentController globalscontroller=new GlobalSearchComponentController();
        globalscontroller.dummyObjName='Student__c';
        globalscontroller.delRecordId=acc.Id;
        globalscontroller.deleteRecord();
        Test.stopTest();

    }
    @isTest(seeAllData=true)
    public static void getFieldsFromFieldSet(){
        Test.startTest();
        GlobalSearchComponentController globalscontroller=new GlobalSearchComponentController();
        globalscontroller.objApiName[0]='student__c';
       // globalscontroller.searchTerm='aaa';
        // globalscontroller.objApiName[1]='null';
        // globalscontroller.objApiName[2]='null';
        globalscontroller.getFieldsFromFieldSet(1);
        Test.stopTest();

    }
   /* @isTest
    public static void getFieldsFromFieldSet1(){
        Test.startTest();
        GlobalSearchComponentController globalscontroller=new GlobalSearchComponentController();
        globalscontroller.objApiName[0]='Account';
        globalscontroller.getFieldsFromFieldSet(8);
        Test.stopTest();

    }*/
    @isTest
    public static void Wrapperclass(){
        Test.startTest();
        GlobalSearchComponentController.SearchWraperClass serchwrapper=new GlobalSearchComponentController.SearchWraperClass();
        serchwrapper.count=2;
        serchwrapper.wObjName='Account';
        System.assertEquals(2, serchwrapper.count);
        System.assertEquals('Account', serchwrapper.wObjName);
        Test.stopTest();
    }
    //@isTest
    //public static void 
}