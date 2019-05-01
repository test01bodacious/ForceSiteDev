@isTest
private class MainTest {
    
    private static User restrictedUser;
    private static final string restrictedProfile = 'Read Only';
    
    @isTest
    static Map<String, ThemainController.PickListhandler> getPickoption(){
         Map<String, ThemainController.PickListhandler> Pick = New Map<String, TheMainController.PickListhandler>();
        ThemainController.PicklistHandler  phand = New ThemainController.PicklistHandler();
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Education','Education'));
        options.add(new SelectOption('Electronics','Electronics'));
        options.add(new SelectOption('Energy','Energy'));
        phand.rtPickOptions=options;
        pick.put('Industry', phand);
        return  pick;
    }
    
    @isTest
    static List<TheMainController.MainRecordWrapperClass> getPagingMyData(){
        
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        List<Account> l = new List<Account>{new Account(Name='Sample')};
        insert l;
        l[0].Name = 'New Sample';
        TheMainController.MainRecordWrapperClass mrw = new TheMainController.MainRecordWrapperClass(l[0], true);
        tm.selectedObj = 'account';
        tm.mainObjLst = new List<TheMainController.MainRecordWrapperClass>();
        tm.mainObjLst.add(mrw);
        /*tm.Paging = new Pageable();
        tm.Paging.pagesize = 10;
        tm.Paging.query = 'SELECT Name FROM Account';
        tm.Paging.setCon = new ApexPages.StandardSetController(Database.query(tm.Paging.query));
        tm.Paging.setCon.setPageSize(tm.Paging.pagesize);
        tm.Paging.initPageable();*/
        tm.Paging = new ListCollection();
        tm.Paging.query = 'SELECT Name FROM Account';
        tm.Paging.PageSize = 10;
        tm.Paging.myData = new List<TheMainController.MainRecordWrapperClass>();
        return  tm.mainObjLst;
    }
    
    @isTest
    static ListCollection getPaging(){
        
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        List<Account> l = new List<Account>{new Account(Name='Sample')};
        insert l;
        l[0].Name = 'New Sample';
        TheMainController.MainRecordWrapperClass mrw = new TheMainController.MainRecordWrapperClass(l[0], true);
        tm.selectedObj = 'account';
        tm.mainObjLst = new List<TheMainController.MainRecordWrapperClass>();
        tm.mainObjLst.add(mrw);
        tm.Paging = new ListCollection();
        tm.Paging.query = 'SELECT Name FROM Account';
        tm.Paging.PageSize = 10;
        tm.Paging.myData = new List<TheMainController.MainRecordWrapperClass>();
        return  tm.Paging;
    }
    
    @isTest
    static void initializationForPopupTest(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        ThemainController tm = new TheMainController();
        tm.initializationForPopup();
    }
    
    @isTest
    static void initializeMainAndRelated1test(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        ThemainController tm = new TheMainController();
        tm.initializeMainAndRelated1();
        
    }
    
    
    @isTest
    static void initPickTest(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        ThemainController tm = new TheMainController();
        tm.initPick();
        tm.selectedObj ='Opportunity';
        tm.prepareDatePicklistFields();
        
    }
    @isTest
    static void helpQueryTest(){
        
        Test.setCurrentPage(Page.Main); //Applying page context here
        ThemainController tm = new TheMainController();
        List<String> phoneflds = new List<String>();
        phoneflds.add('Phone');
        phoneflds.add('Fax');
        List<String> emailflds = new List<String>();
        emailflds.add('Email');
        
        String result = tm.helpQuery(phoneFlds, emailFlds, '234');
        System.assert(result.contains('OR  Phone LIKE \'(23%\' OR Phone LIKE \'23%\' OR  Fax LIKE \'23%\' OR Fax LIKE'));
        String result1 = tm.helpQuery(phoneFlds, emailFlds, '23445');
        String result2 = tm.helpQuery(phoneFlds, emailFlds, '234156487');
    }
    
    @isTest
    static void instantiateMainObjLstTest1(){
        
        Test.setCurrentPage(Page.Main); //Applying page context here
        ThemainController tm = new TheMainController();
        tm.mainquery = 'SELECT Name FROM Account';
        tm.Paging = getPaging();
        tm.PAGE_SIZE = 10;
        tm.selectedObj = 'Account';
        tm.dateObj = new DateObject__c();
        tm.instantiateMainObjLst();
    }
    
    
    @isTest
    static void getQueryTest1(){
        boolean b1, b2, b3, b4;
        List<ACcount> acc = new List<Account>();
        List<Account> acc1 = new List<Account>();
        string result = 'SELECT name FROM Account WHERE (name LIKE \'e%\' OR  phone LIKE \'e%\' OR phone LIKE \'%e%\' OR  phone LIKE \'e%\' OR phone LIKE \'e\' OR  fax LIKE \'e%\' OR fax LIKE \'%e%\' OR  fax LIKE \'e%\' OR fax LIKE \'e\')  AND createddate = ';
        string result1 = 'SELECT name FROM Account WHERE (name LIKE \'e%\' OR  phone LIKE \'e%\' OR phone LIKE \'%e%\' OR  phone LIKE \'e%\' OR phone LIKE \'e\' OR  fax LIKE \'e%\' OR fax LIKE \'%e%\' OR  fax LIKE \'e%\' OR fax LIKE \'e\')';
        Test.setCurrentPage(Page.Main); //Applying page context here
        ThemainController tm = new TheMainController();
        tm.mainSearch = 'e';
        tm.PickOptions = null;
        tm.dateFormat = 'THIS_YEAR';
        // tm.dat = System.today();
        tm.dateObj =  new DateObject__c();
        tm.selectedObj='Account';
        tm.dateFldPicklist = 'createddate';
        acc = database.query(tm.getQuery());
        acc1 = database.query(result + 'THIS_YEAR ORDER BY name ASC LIMIT 50000');
        b1 = acc == acc1;
        tm.dateFormat = 'ALLTime';
        acc = database.query(tm.getQuery());
        acc1 = database.query(result1);
        b2 = acc == acc1;
        tm.dateFormat = '>';
        acc = database.query(tm.getQuery());
        acc1 = database.query(result1);
        b3 = acc == acc1;
        System.assert(true == (b1 && b2 && b3 && !(tm.isCustomObject('account')) && (tm.checkValidFieldType('account','billingaddress')) && (tm.checkValidFieldType('opportunity','forecastcategory')) ));
    }
    
    @isTest
    static void getQueryTest2(){
        
        Test.setCurrentPage(Page.Main); //Applying page context here
        ThemainController tm = new TheMainController();
        tm.mainSearch = null;
        tm.PickOptions = null;
        tm.dateFormat = 'THIS_YEAR';
        tm.dateObj =  new DateObject__c();
        tm.selectedObj='Account';
        tm.dateFldPicklist = 'createddate';
        String result = 'SELECT name FROM Account WHERE  createdDate = THIS_YEAR ORDER BY name ASC LIMIT 50000';
        System.assert(true ==(database.query(tm.getQuery()) == database.query(result)));
    }    
    @isTest
    static void getQueryTest3(){
        
        Date dat;
        Datetime dtstart , dtend;
        boolean b1, b2, b3, b4, b5 ,b6, b7;
        List<Account> acc = new List<Account>();
        List<Account> acc1 = new List<Account>();
        String result= 'SELECT name FROM Account WHERE  createddate ';
        String result1= 'SELECT name FROM Opportunity WHERE  closedate = :dat';
       Test.setCurrentPage(Page.Main); //Applying page context here
        ThemainController tm = new TheMainController();
        tm.dateFldPicklist = 'createddate';
        tm.mainSearch = null;
        tm.PickOptions = null;
        
        tm.dateObj =  new DateObject__c(mydate__c=System.today());
        
        tm.selectedObj='Account';
        tm.dateFormat = '>=';
        acc = database.query(tm.getQuery());
        acc1 = database.query(result+ '>= :dat ORDER BY name ASC LIMIT 50000');
        b1 = acc == acc1;
        tm.dateFormat = '<=';
        acc = database.query(tm.getQuery());
        acc1 = database.query(result+'<= :dat ORDER BY name ASC LIMIT 50000');
        b2 = acc == acc1;
        tm.dateFormat = '>';
        acc = database.query(tm.getQuery());
        acc1 = database.query(result+'> :dat ORDER BY name ASC LIMIT 50000');
        b3 = acc == acc1;
        tm.dateFormat = '<';
        acc = database.query(tm.getQuery());
        acc1 = database.query(result+'< :dat ORDER BY name ASC LIMIT 50000');
        b4 = acc == acc1;
        tm.dateFormat = '=';
        acc = database.query(tm.getQuery());
        acc1 = database.query(result+'= :dat ORDER BY name ASC LIMIT 50000');
        b5 = acc == acc1;
        tm.dateFormat = 'THIS_YEAR';
        acc = database.query(tm.getQuery());
        acc1 = database.query('SELECT name FROM Account WHERE createddate = THIS_YEAR ORDER BY name ASC LIMIT 50000');
        b6 = acc == acc1;
        
        tm.dateFldPicklist = 'createddate';
        tm.selectedObj = 'Opportunity';
        b7 = (database.query(tm.getquery()) ==  database.query(result1));
        
        System.assert(true == (b1 &&b2 && b3 && b4 && b5 && b6 && b7));
        
    }  
    
    @isTest
    static void getQueryTest4(){
        
        Test.setCurrentPage(Page.Main); //Applying page context here
        ThemainController tm = new TheMainController();
        tm.dateFldPicklist = 'createddate';
        tm.mainSearch =  'e';
        tm.PickOptions = null;
        tm.dateFormat = null;
        tm.dateObj =  new DateObject__c(MyDate__c=System.today());
        tm.selectedObj='Account';
        String result ='SELECT name FROM Account WHERE (name LIKE \'e%\' OR  phone LIKE \'e%\' OR phone LIKE \'%e%\' OR  phone LIKE \'e%\' OR phone LIKE \'e\' OR  fax LIKE \'e%\' OR fax LIKE \'%e%\' OR  fax LIKE \'e%\' OR fax LIKE \'e\')  ORDER BY name ASC LIMIT 50000';
        System.assert(true == (Database.query(tm.getQuery()) == Database.query(result)));
    }
    @isTest
    static void getQueryTest5(){
        Date dat;
        Datetime dtstart , dtend;
        boolean b1, b2, b3, b4, b5, b6;
        List<Account> acc = new List<Account>();
        List<Account> acc1 = new List<Account>();
        string result = 'SELECT name FROM Account WHERE (name LIKE \'e%\' OR  phone LIKE \'e%\' OR phone LIKE \'%e%\' OR  phone LIKE \'e%\' OR phone LIKE \'e\' OR  fax LIKE \'e%\' OR fax LIKE \'%e%\' OR  fax LIKE \'e%\' OR fax LIKE \'e\')  AND createddate ';
        Test.setCurrentPage(Page.Main); //Applying page context here
        ThemainController tm = new TheMainController();
        tm.dateFldPicklist = 'createddate';
        tm.mainSearch =  'e';
        tm.PickOptions = null;
        tm.dateFormat = 'THIS_YEAR';
        tm.dateObj =  new DateObject__c(MyDate__c=System.today());
        tm.selectedObj='Account';
        tm.getQuery();
        
        tm.dateFormat ='>';
        acc = database.query(tm.getQuery());
        acc1 = database.query(result+'> :dat');
        b1 = acc == acc1;
        
        tm.dateFormat ='>=';
        acc = database.query(tm.getQuery());
        acc1 = database.query(result+'>= :dat');
        b2 = acc == acc1;
        
        tm.dateFormat ='<';
        acc = database.query(tm.getQuery());
        acc1 = database.query(result+'< :dat');
        b3 = acc == acc1;
        
        tm.dateFormat ='<=';
        acc = database.query(tm.getQuery());
        acc1 = database.query(result+'<= :dat');
        b4 = acc == acc1;
        
        tm.dateFormat ='=';
        acc = database.query(tm.getQuery());
        acc1 = database.query(result+'= :dat');
        b5 = acc == acc1;
        
        tm.dateformat = 'AllTime';
        acc = Database.query(tm.getQuery());
        acc1 = database.query('SELECT name FROM Account WHERE (name LIKE \'e%\' OR  phone LIKE \'e%\' OR phone LIKE \'%e%\' OR  phone LIKE \'e%\' OR phone LIKE \'e\' OR  fax LIKE \'e%\' OR fax LIKE \'%e%\' OR  fax LIKE \'e%\' OR fax LIKE \'e\')');
        
        System.assert(true == (b1 &&b2 && b3 && b4 && b5));
    }
    
    @isTest
    static void getQueryTest6(){
        
        Date dat;
        Datetime dtstart , dtend;
        boolean b1, b2, b3, b4, b5, b6;
        List<Account> acc = new List<Account>();
        List<Account> acc1 = new List<Account>();
        string result = 'SELECT name FROM Account WHERE (name LIKE \'e%\' OR  phone LIKE \'e%\' OR phone LIKE \'%e%\' OR  phone LIKE \'e%\' OR phone LIKE \'e\' OR  fax LIKE \'e%\' OR fax LIKE \'%e%\' OR  fax LIKE \'e%\' OR fax LIKE \'e\')  AND (Industry=\'Education\'  OR Industry=\'Electronics\'  OR Industry=\'Energy\'  ) AND createddate = ';
        String result1 = 'SELECT name FROM Account WHERE (name LIKE \'e%\' OR  phone LIKE \'e%\' OR phone LIKE \'%e%\' OR  phone LIKE \'e%\' OR phone LIKE \'e\' OR  fax LIKE \'e%\' OR fax LIKE \'%e%\' OR  fax LIKE \'e%\' OR fax LIKE \'e\')  AND (Industry=\'Education\'  OR Industry=\'Electronics\'  OR Industry=\'Energy\'  )';
        
        Test.setCurrentPage(Page.Main); //Applying page context here
        ThemainController tm = new TheMainController();
        tm.dateFldPicklist = 'createddate';
        tm.mainSearch =  'e';
        tm.PickOptions = getPickoption();
        tm.dateFormat = 'THIS_YEAR';
        tm.dateObj =  new DateObject__c();
        tm.selectedObj='Account';
        
        acc= database.query(tm.getQuery());  //a1 b1 c1 d2
        acc1 = database.query(result + 'THIS_YEAR ORDER BY name ASC LIMIT 50000');
        b1 = acc == acc1;
        
        tm.dateFormat = 'AllTime';
        acc=database.query(tm.getQuery());
        acc1 = database.query(result1);
        b2 = acc == acc1;
        
        tm.dateFormat = '>';
        acc=database.query(tm.getQuery());
        acc1 = database.query(result1);
        b3 = acc == acc1;
        
        System.assert(true == (b1 && b2 && b3));
        
        //test hide method
        tm.isNewRelated = new map<String , boolean>();
        tm.isNewRelated.put('Account', false);
        tm.hide();
        
    }
    @isTest
    Static void getQueryTest7(){
        
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        tm.dateFldPicklist = 'createddate';
        tm.mainSearch =  null;
        tm.PickOptions = getPickoption();
        tm.dateFormat = null;
        tm.dateObj =  new DateObject__c();
        tm.selectedObj='Account';
        String result = 'SELECT name FROM Account WHERE (Industry=\'Education\'  OR Industry=\'Electronics\'  OR Industry=\'Energy\'  ) ORDER BY name ASC LIMIT 50000';
        system.assert(true == (database.query(tm.getQuery()) == database.query(result)));  //a2 b1 c2 d2
    }
    @isTest
    static void getQueryTest8(){
        
        Date dat;
        Datetime dtstart , dtend;
        boolean b1, b2, b3, b4, b5, b6, b7;
        List<Account> acc = new List<Account>();
        List<Account> acc1 = new List<Account>();
        string result ='SELECT name FROM Account WHERE (Industry=\'Education\'  OR Industry=\'Electronics\'  OR Industry=\'Energy\'  ) AND createddate ';
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMAinController tm = new TheMainController();
        tm.dateFldPicklist = 'createddate';
        tm.mainSearch =  null;
        tm.PickOptions = getPickoption();
        tm.dateFormat ='AllTime';
        tm.dateObj =  new DateObject__c(myDate__C = System.today());
        tm.selectedObj='Account';
        
        b1 = database.query(tm.getQuery()) == database.query('SELECT name FROM Account WHERE (Industry=\'Education\'  OR Industry=\'Electronics\'  OR Industry=\'Energy\'  )'); //a2 b1  c1 d1
        
        tm.dateFormat = '>=';
        b2 = Database.query(tm.getQuery()) == (database.query(result + '>= :dat ORDER BY name ASC LIMIT 50000'));
        
        tm.dateFormat = '<=';
        b3 = Database.query(tm.getQuery()) == (database.query(result + '<= :dat ORDER BY name ASC LIMIT 50000'));
        
        tm.dateFormat = '>';
        b4 = Database.query(tm.getQuery()) == (database.query(result + '> :dat ORDER BY name ASC LIMIT 50000'));
        
        tm.dateFormat = '<';
        b5 = Database.query(tm.getQuery()) == (database.query(result + '< :dat ORDER BY name ASC LIMIT 50000'));
        
        tm.dateFormat = '=';
        b6 = Database.query(tm.getQuery()) == (database.query(result + '= :dat ORDER BY name ASC LIMIT 50000'));
        
        tm.RenderDateInputField(); //void
        tm.dateFormat = 'THIS_YEAR';
        b7 = Database.query(tm.getQuery()) == (database.query(result + ' = THIS_YEAR ORDER BY name ASC LIMIT 50000'));
        tm.RenderDateInputField(); //void
        tm.mainquery = 'SELECT Name FROM Account';
        tm.PAGE_SIZE = 10;
        tm.rlFld = new map<String,String>();
        Test.startTest();
        tm.triggerasync();
        Test.stopTest();
        //tm.rlFld.put('contacts','contact');
        tm.initializeMainAndRelated2();
        System.assert(true == (b1 && b2 && b3 && b4 && b5 && b6));
    }
    @isTest
    static void getQueryTest9(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        tm.dateFldPicklist = 'createddate';
        tm.mainSearch  = 'e';
        tm.PickOptions = null;
        tm.dateFormat = null;
        tm.dateObj =  new DateObject__c();
        tm.selectedObj='Account';
        String result = 'SELECT name FROM Account WHERE (name LIKE \'e%\' OR  phone LIKE \'e%\' OR phone LIKE \'%e%\' OR  phone LIKE \'e%\' OR phone LIKE \'e\' OR  fax LIKE \'e%\' OR fax LIKE \'%e%\' OR  fax LIKE \'e%\' OR fax LIKE \'e\')  ORDER BY name ASC LIMIT 50000';
        system.assert(true == (database.query(tm.getQuery()) == database.query(result))); //a1 b2 c2 d2
    }
    @isTest
    static void getQueryTest10(){
        Date dat, dtstart, dtend;
        boolean b1, b2, b3, b4 ,b5, b6, b7;
        String result = 'SELECT name FROM Account WHERE (name LIKE \'e%\' OR  phone LIKE \'e%\' OR phone LIKE \'%e%\' OR  phone LIKE \'e%\' OR phone LIKE \'e\' OR  fax LIKE \'e%\' OR fax LIKE \'%e%\' OR  fax LIKE \'e%\' OR fax LIKE \'e\')  AND createddate ';
        String append  = ' :dat ORDER BY name ASC LIMIT 50000';
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        tm.dateFldPicklist = 'createddate';
        tm.selectedObj='Account';
        tm.mainSearch = 'e';
        tm.PickOptions = getPickoption();
        tm.dateFormat ='AllTime';
        tm.dateObj =  new DateObject__c(MyDate__c =System.today());
        b1 = Database.query(tm.getQuery()) == Database.query(result.substring(0, result.lastIndexOfIgnoreCase(')')+1));
        
        tm.dateFormat ='>=';
        b2 = (Database.query(tm.getQuery()) == Database.query(result + '>=' + append));
        
        tm.dateFormat ='<=';
        b3 = (Database.query(tm.getQuery()) == Database.query(result + '<=' + append));
        
        tm.dateFormat ='<';
        b4 = (Database.query(tm.getQuery()) == Database.query(result + '<' + append));
        
        tm.dateFormat ='>';
        b5 = (Database.query(tm.getQuery()) == Database.query(result + '>' + append));
        
        tm.dateFormat ='=';
        b6 = (Database.query(tm.getQuery()) == Database.query(result + '=' + append));
        tm.dateFormat = 'THIS_YEAR';
        b7 = (Database.query(tm.getQuery()) == Database.query(result + '=  THIS_YEAR ORDER BY name ASC LIMIT 50000'));
        System.assert(true == (b1 && b2 && b3 && b4 && b5 && b6));
    }
    @isTest
    Static void getQuerytest11(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        tm.selectedObj='Account';
        tm.dateFldPicklist = 'createddate';
        tm.mainSearch  = null;
        tm.PickOptions = getPickoption();
        tm.dateFormat = null;
        tm.dateObj =  new DateObject__c(MyDate__c = System.today());
        String result = 'SELECT name FROM Account WHERE (Industry=\'Education\'  OR Industry=\'Electronics\'  OR Industry=\'Energy\'  ) ORDER BY name ASC LIMIT 50000';
        
        System.assert(true == (database.query(tm.getQuery()) == dataBase.query(result)));
    }
    @isTest
    static void getQueryTest12(){
        
        Boolean b1, b2, b3;
        String result = 'SELECT name FROM Account WHERE (Industry=\'Education\'  OR Industry=\'Electronics\'  OR Industry=\'Energy\'  ) ORDER BY name ASC LIMIT 50000';
        String result1 = 'SELECT name FROM Account WHERE (Industry=\'Education\'  OR Industry=\'Electronics\'  OR Industry=\'Energy\'  ) AND createdDate = THIS_YEAR ORDER BY name ASC LIMIT 50000';
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        tm.selectedObj='Account';
        tm.mainSearch = null;
        tm.PickOptions = getPickoption();
        tm.dateFormat = 'AllTime';
        tm.dateObj = New DateObject__C();
        tm.dateFldPicklist = 'createddate';
        b1 = database.query(tm.getQuery()) == database.query(result);
        
        tm.dateFormat = 'THIS_Year';
        b2 = Database.query(tm.getQuery()) == dataBase.query(result1);
        
        tm.dateFormat = '>';
        b3 =  database.query(tm.getQuery()) == dataBase.query(result);
        
        System.assert(true == (b1 && b2 &&b3));
    }
    @isTest
    static void getQueryTest13(){
        String result = 'SELECT name FROM Account WHERE (name LIKE \'u%\' OR  phone LIKE \'u%\' OR phone LIKE \'%u%\' OR  phone LIKE \'u%\' OR phone LIKE \'u\' OR  fax LIKE \'u%\' OR fax LIKE \'%u%\' OR  fax LIKE \'u%\' OR fax LIKE \'u\')  AND (Industry=\'Education\'  OR Industry=\'Electronics\'  OR Industry=\'Energy\'  ) ORDER BY name ASC LIMIT 50000';
       Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        tm.selectedObj='Account';
        tm.mainSearch = 'u';
        tm.PickOptions = getPickoption();
        tm.dateFormat = null;
        tm.dateObj = New DateObject__C();
        System.assert(true == (database.query(tm.getQuery()) == database.query(result)));
    }
    @isTest
    static void getQueryTest14(){
        date dtstart, dtEnd;
        string result = 'SELECT name FROM Account WHERE (name LIKE \'e%\' OR  phone LIKE \'e%\' OR phone LIKE \'%e%\' OR  phone LIKE \'e%\' OR phone LIKE \'e\' OR  fax LIKE \'e%\' OR fax LIKE \'%e%\' OR  fax LIKE \'e%\' OR fax LIKE \'e\')  AND (Industry=\'Education\'  OR Industry=\'Electronics\'  OR Industry=\'Energy\'  ) AND (createddate >= :dtStart AND createddate <= :dtEnd) ORDER BY name ASC LIMIT 50000';
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        tm.selectedObj='Account';
        tm.dateFldPicklist = 'createddate';
        tm.mainSearch = 'e';
        tm.PickOptions = getPickoption();
        tm.dateFormat = null;
        tm.dateObj = New DateObject__C(MyDate__c =System.today());
        System.assert(true == (database.query(tm.getQuery()) == database.query(result)));
    }
    @isTest
    static void getQueryTest15(){
        
        date dtstart, dtEnd, dat;
        boolean b1, b2;
        string result = 'SELECT name FROM Account WHERE createddate >= :dtStart AND createddate <=  :dtEnd ORDER BY name ASC LIMIT 50000';
        string result1 = 'SELECT name FROM Opportunity WHERE closedate =  :dat ORDER BY name ASC LIMIT 50000';
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        tm.selectedObj='Account';
        tm.dateFldPicklist = 'createddate';
        tm.mainSearch = null;
        tm.PickOptions = null;
        tm.dateFormat = null;
        tm.dateObj = New DateObject__C(MyDate__c =System.today());
        b1 = database.query(tm.getQuery()) == database.query(result);
        
        tm.selectedObj='Opportunity';
        tm.dateFldPicklist = 'closedate';
        b2 = database.query(tm.getQuery()) == database.query(result1);
        System.assert(true == (b1 && b2));
    }
    
    
    @isTest
    static void getRelatedQueryTest(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        ThemainController tm = new TheMainController();
        Map<String, list<String>> rld = New map<String, List<String>>();
        List<String> lst = new List<String>();
        lst.add('industry');
        rld.put('account',lst);
        tm.relatedFldMap = rld;
        String result = ', ( SELECT industry FROM account )';
        System.assertEquals(result ,tm.getRelatedQuery());
    }
    @isTest
    Static void getMatchingReferenceFieldNameTest(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        tm.selectedObj = 'Account';
        List<String> ref = new List<String>();
        ref.add('AccountId');
        System.assertEquals(ref, tm.getMatchingReferenceFieldName('Contact'));
    }
    @isTest
    static void showPicklistPopupTest(){
        
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        //tm.showPicklistPopup(); // void
        tm.pickoptions= New Map<String, TheMainController.PickListhandler>();
        //Map<String, List<selectoption>> pickoptions = new map<String, List<selectoption>>();
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Education','Education'));
        options.add(new SelectOption('Energy','Energy'));
        options.add(new SelectOption('Electronics','Electronics'));
        tm.pickedFld = 'Industry';
        tm.picklistOptions = new map<String, List<selectoption>>();
        tm.picklistOptions.put('Industry', options);
        
        tm.showPicklistPopup();
        tm.closePicklistPopup();
        
    }
    
    @isTest
    static void selectOptionSortByValueTest(){
        
        Test.setCurrentPage(Page.Main); //Applying page context here
        theMainController tm =new TheMainController();
        Map<String, List<selectoption>> pickoptions = new map<String, List<selectoption>>();
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Education','Education'));
        options.add(new SelectOption('Energy','Energy'));
        options.add(new SelectOption('Electronics','Electronics'));
        
        
        List<SelectOption> options1 = new List<SelectOption>();
        options1.add(new SelectOption('Education','Education'));
        options1.add(new SelectOption('Electronics','Electronics'));
        options1.add(new SelectOption('Energy','Energy'));
        
        pickoptions.put('Industry',options);
        tm.picklistOptions = pickoptions;
        tm.pickedFld ='Industry';
        tm.PickOptions = getPickoption();
        tm.mapPickValues = new  Map<String, List<String>>();
        tm.mainquery = 'SELECT Name FROM Account';
        tm.PAGE_SIZE = 10;
         tm.selectedObj = 'Account';
        tm.dateObj = new DateObject__c();
        tm.Paging = getPaging();    
        tm.FilterPicklistPopup(); // void
        tm.initializeMainAndRelated1(); // void
        tm.initializeMainAndRelated2(); //void
        System.assert(options1 == tm.selectOptionSortByValue(Options));
    }
    
    @isTest
    static void SavePopupTest(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new ThemainController();
        System.assertEquals(null, tm.SavePopup());
    }
    @isTest
    static void getObjectLabelTest(){
        
        System.debug('$$$$$$$$$$$$$$$$$: ' + TheMainController.getObjectLabel('account'));
        System.assertEquals('Account', TheMainController.getObjectLabel('account'));
    }
    
    @isTest
    static void getRequiredFieldsTest(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        list<String> result = new List<String>();
        result.add('id');
        result.add('isdeleted');
        result.add('name');
        result.add('ownerid');
        result.add('createddate');
        result.add('createdbyid');
        result.add('lastmodifieddate');
        result.add('lastmodifiedbyid');
        result.add('systemmodstamp');
        System.assert(result==tm.getRequiredFields('Account'));
    }
    //tm.selectedObj='Account';
    //Account a = new Account(name ='hello');
    //insert a;
    
    //tm.recordId = a.id;
    //  map<String, List<String>> mp = new Map<String, List<String>>();
    //list<String> a = new List<String>('jhgfjsf');
    // mp.put('hello', new List<String>{'Acccount'});
    //tm.relatedFldMapVF =mp;
    //tm.relatedPartRefresh('Contact');
    
    @isTest
    static void createMainEventsTest(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new ThemainController();
        tm.selectedObj ='Account';
        tm.paging = new ListCollection();
        tm.Paging = getPaging();
        tm.massEvent = new Event();
        tm.mainquery = 'SELECT Name FROM Account';
        tm.PAGE_SIZE = 10;
        tm.dateObj = new DateObject__C();
        System.assertEquals(null, tm.createMainEvents());
    }
    @isTest
    static void showTest(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        Account a = new Account(Name='Account');
        insert a;
        TheMainController.MainRecordWrapperClass mrw = new TheMainController.MainRecordWrapperClass(a, false);
        tm.selectedObj = 'account';
        tm.mainObjLst = new List<TheMainController.MainRecordWrapperClass>();
        tm.mainObjLst.add(mrw);
        tm.Paging = new ListCollection();
        tm.Paging.myData = tm.mainObjLst;
        tm.relatedFldMapVF = new Map<String, List<String>>();
        tm.isRelatedSelectAll = new Map<String, Boolean>();
        tm.recordId = a.Id;
        tm.relatedObjLst = new Map<String, List<TheMainController.RelatedRecordWrapperClass>>();
        for(String so: tm.getAllRelatedObject(tm.selectedObj)){ 
            tm.relatedFldMapVF.put(so, tm.getDefaultFields(so));
        }
        tm.dateObj = new DateObject__c();
        
        System.assertEquals(null, tm.RefreshMain());
        tm.show();
        
        tm.relatedFocusObject ='Contact';
        tm.selectedObj='Contact';
        tm.updateMainRecordMap();/////////////
        tm.getTaskFields();
        tm.getEventFields();
        tm.relatedObjLst =new Map<String, List<TheMainController.RelatedRecordWrapperClass>>() ;
        tm.relatedPartRefresh('Contact');
        
    }
    @isTest
    static void saveRelatedTest(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        themainController tm = new themaincontroller();
        TheMainController.RelatedRecordWrapperClass cv =new TheMainController.RelatedRecordWrapperClass(new Account(), false);
        System.assertEquals(null,tm.saveRelated());
    }
    @isTest
    static void savemaintest(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        themaincontroller tm = new themaincontroller();
        tm.selectedObj ='Account';
        System.assertEquals(null, tm.saveMain());
    }
    
    @isTest
    static void getRelationshipNameTest(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        ThemainController tm = new TheMainController();
        tm.rlFld = new map<String,String>();
        tm.rlFld.put('Contact','Contact');
        System.assertequals('Contact', tm.getRelationshipName('Contact'));
    }
    @isTest
    static void findsObjectRelatedNegativeTest(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        Map<String , Sobject> mp =new Map<String, sobject>();
        Account a = new Account(Name ='Hello');
        tm.relatedObjectLst = new Map<String, Sobject>();
        tm.relatedObjectLst.put('Account', a);
        System.assertEquals(null, tm.FindsObjectRelated('Contact'));
    }
    @isTest
    static void findsObjectRelatedPositiveTest(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        Map<String , Sobject> mp =new Map<String, sobject>();
        Account a = new Account(Name ='Hello');
        tm.relatedObjectLst = new Map<String, Sobject>();
        tm.relatedObjectLst.put('Account', a);
        System.assertEquals(a, tm.FindsObjectRelated('Account'));
    }
    @isTest
    static void FindsObjectMainPositiveTest(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        Map<String , Sobject> mp =new Map<String, sobject>();
        Account a = new Account(Name ='Hello');
        tm.mainObject = new Map<String, Sobject>();
        tm.mainObject.put('Account', a);
        System.assertEquals(a, tm.FindsObjectMain('Account'));
    }
    
    @isTest
    static void FindsObjectMainNegativeTest(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        Map<String , Sobject> mp =new Map<String, sobject>();
        Account a = new Account(Name ='Hello');
        tm.mainObject = new Map<String, Sobject>();
        tm.mainObject.put('Account', a);
        System.assertEquals(null, tm.FindsObjectMain('Contact'));
    }
    @isTest
    static void FindsObjectNameTest(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        Map<String , Sobject> mp =new Map<String, sobject>();
        Account a = new Account(Name ='Hello');
        tm.mainObject = new Map<String, Sobject>();
        tm.mainObject.put('Account', a);
        System.assertEquals('Account', tm.FindsObjectName(a));
    }
    
    @isTest
    static void FindsObjectNameAnotherTest(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        tm.relatedObjectLst =new Map<String, sobject>();
        Account a = new Account(Name ='Hello');
        tm.mainObject = new Map<String, Sobject>();
        tm.relatedObjectLst.put('Account', a);
        System.assertEquals('Account', tm.FindsObjectName(a));
    }
    @isTest
    Static void  convertTosObjectNameTest(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        theMainController tm = new theMainController();
        Account a = new Account(Name='Hello');
        System.assertEquals('Account', tm.ConvertTosObjectName(a));
    }
    @isTest
    static void showNewMainTest(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new ThemainController();
        Boolean b1, b2, b3, b4, b5;
        tm.selectedObj = 'Account';
        tm.relatedFocusObject= 'Contact';
        tm.isNewRelated = new Map<String, boolean>();
        b1= null == tm.showNewMain();
        b2= null == tm.showNewMainTask();
        b3= null == tm.showNewMainEvent();
        b4= null == tm.showNewRelated();
        b5= null == tm.CancelRelated();
        System.assert(true == (b1 && b2 && b3 && b4 && b5));
    }
    
    @isTest
    static void cancelMainTest(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        System.assert(true == (null == tm.cancelMain() && ((null == tm.cancelMainEvents() && null == tm.cancelMainTasks()))));
    }
    
    // Set up the test methods with contrived data
    private static void setup(TEST_setupPermissions permissions){
        
        Id readOnlyProfileId = [SELECT Id FROM Profile WHERE Name = :restrictedProfile LIMIT 1].Id;
        
        PermissionSet ps = new PermissionSet(Name='CRUDFLSPERMISSION', Label='CRUDFLSPERMISSION');
        insert ps;
        
        if(permissions.hasObjectPermissions()){
            ObjectPermissions accountFaxObjectPermission = new ObjectPermissions(SobjectType = permissions.objectName,
                                                                    ParentId = ps.Id,
                                                                    PermissionsCreate = permissions.objects.PermissionsCreate,
                                                                    PermissionsDelete = permissions.objects.PermissionsDelete,
                                                                    PermissionsEdit = permissions.objects.PermissionsEdit,
                                                                    PermissionsRead = permissions.objects.PermissionsRead
                                                                );
            try{
                insert accountFaxObjectPermission;
            }catch(Exception e){
                
            }
            System.debug('\n\naccountFaxObjectPermission  is: ' + accountFaxObjectPermission + '\n\n');
            
            FieldPermissions accountFaxFieldPermission = new FieldPermissions(SobjectType = permissions.objectName,
                                                                    Field = permissions.getFieldFullName(),
                                                                    ParentId = ps.Id,
                                                                    PermissionsRead = permissions.fields.PermissionsRead,
                                                                    PermissionsEdit = permissions.fields.PermissionsEdit
                                                                );
            try{
                insert accountFaxFieldPermission;
            }catch(Exception e){
                
            }
            System.debug('\n\naccountFaxFieldPermission  is: ' + accountFaxFieldPermission + '\n\n');
        }
        
        System.debug('\n\nPermission set is: ' + ps + '\n\n');
        
        // Create a test user:
        if(restrictedUser == null){
            restrictedUser = new User(Username = 'restricted@testuser.com', 
                                    Email = 'restricted@testuser.com', 
                                    firstName = 'testx', 
                                    lastName = 'userx',
                                    Alias = 'rtestusr',
                                    emailencodingkey='UTF-8',
                                    languagelocalekey='en_US',
                                    localesidkey='en_US',
                                    timezonesidkey='America/Los_Angeles',
                                    profileId = readOnlyProfileId);
            insert restrictedUser;  
        }
        
        PermissionSetAssignment assignment = new PermissionSetAssignment(AssigneeId = restrictedUser.Id, PermissionSetId = ps.Id);
        insert assignment;
    }
    
    @isTest
    static void deleteMainRecordsTestSuccess(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        Account a = new Account(Name='Account');
        insert a;
        TheMainController.MainRecordWrapperClass mrw = new TheMainController.MainRecordWrapperClass(a, true);
        tm.selectedObj = 'account';
        tm.mainObjLst = new List<TheMainController.MainRecordWrapperClass>();
        tm.mainObjLst.add(mrw);
        tm.Paging = new ListCollection();
        tm.PAGE_SIZE = 10;
        tm.mainquery = 'SELECT Name FROM Account';
        tm.dateObj = new DateObject__C();
        tm.Paging.mydata = new List<TheMainController.MainRecordWrapperClass>();
        tm.Paging.mydata.add(mrw);
        Test.startTest();
        tm.deleteMainRecords();
        Test.stopTest();
        System.debug([SELECT Name FROM Account].size());
        System.assertEquals(0, [SELECT Name FROM Account].size());     
    }
    
    @isTest
    static void deleteMainRecordsTestFail(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        Account a = new Account(Name='Account');
        insert a;
        Case c = new Case(status='Working', priority='High');
        c.AccountId = a.id;
        insert c;
        TheMainController.MainRecordWrapperClass mrw = new TheMainController.MainRecordWrapperClass(a, true);
        tm.selectedObj = 'account';
        tm.mainObjLst = new List<TheMainController.MainRecordWrapperClass>();
        tm.mainObjLst.add(mrw);
        tm.Paging = new ListCollection();
        tm.Paging.myData = tm.mainObjLst;
        tm.dateObj = new DateObject__C();
        Test.startTest();
        tm.deleteMainRecords();
        Test.stopTest();
        System.assertEquals(1, [SELECT Name FROM Account].size()); 
        
    }
    
    @isTest
    static void deleteMainRecordsTestCRUD(){
        
        TEST_setupPermissions p = new TEST_setupPermissions('Account', 'Fax');
 
        p.fields.PermissionsEdit = false;
        p.fields.PermissionsRead = true;
        p.objects.setAllFalse();
        p.objects.PermissionsRead = true;
        
        setup(p); 
        
        System.runAs(restrictedUser){
            Test.setCurrentPage(Page.Main); //Applying page context here
            TheMainController tm = new TheMainController();
            Account a = new Account(Name='Account');
            insert a;
            TheMainController.MainRecordWrapperClass mrw = new TheMainController.MainRecordWrapperClass(a, true);
            tm.selectedObj = 'account';
            tm.mainObjLst = new List<TheMainController.MainRecordWrapperClass>();
            tm.mainObjLst.add(mrw);
            tm.Paging = new ListCollection();
            tm.Paging.myData = tm.mainObjLst;
            Test.startTest();
            tm.deleteMainRecords();
            Test.stopTest();
            System.assertEquals(1, [SELECT Name FROM Account].size()); 
        }      
    }
    
    @isTest
    static void updateMainRecordsTestSuccess(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        List<Account> l = new List<Account>{new Account(Name='Sample')};
        insert l;
        l[0].Name = 'New Sample';
        TheMainController.MainRecordWrapperClass mrw = new TheMainController.MainRecordWrapperClass(l[0], true);
        tm.selectedObj = 'account';
        tm.mainObjLst = new List<TheMainController.MainRecordWrapperClass>();
        tm.mainObjLst.add(mrw);
        tm.Paging = new ListCollection();
        tm.Paging.myData = tm.mainObjLst;
        tm.dateObj = new DateObject__C();
        Test.startTest();
        tm.updateMainRecords();
        Test.stopTest();
        System.assertEquals('New Sample', [SELECT Name FROM Account][0].Name);     
    }
    
    @isTest
    static void updateMainRecordsTestFail(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        List<Account> l = new List<Account>{new Account(Name='Sample')};
        insert l;
        l[0].Name = '';
        TheMainController.MainRecordWrapperClass mrw = new TheMainController.MainRecordWrapperClass(l[0], true);
        tm.selectedObj = 'account';
        tm.mainObjLst = new List<TheMainController.MainRecordWrapperClass>();
        tm.mainObjLst.add(mrw);
        tm.Paging = new ListCollection();
        tm.Paging.myData = tm.mainObjLst;
        tm.dateObj = new DateObject__C();
        Test.startTest();
        tm.updateMainRecords();
        Test.stopTest();
        System.assertEquals('Sample', [SELECT Name FROM Account][0].Name); 
        
    }
    
    @isTest
    static void updateMainRecordsTestCRUD(){
        
        TEST_setupPermissions p = new TEST_setupPermissions('Account', 'Fax');
 
        p.fields.PermissionsEdit = false;
        p.fields.PermissionsRead = true;
        p.objects.setAllFalse();
        p.objects.PermissionsRead = true;
        
        setup(p); 
        
        System.runAs(restrictedUser){
            Test.setCurrentPage(Page.Main); //Applying page context here
            TheMainController tm = new TheMainController();
            List<Account> l = new List<Account>{new Account(Name='Sample')};
            insert l;
            l[0].Name = 'New Sample';
            TheMainController.MainRecordWrapperClass mrw = new TheMainController.MainRecordWrapperClass(l[0], true);
            tm.selectedObj = 'account';
            tm.mainObjLst = new List<TheMainController.MainRecordWrapperClass>();
            tm.mainObjLst.add(mrw);
            tm.Paging = new ListCollection();
            tm.Paging.myData = tm.mainObjLst;
            Test.startTest();
            tm.updateMainRecords();
            Test.stopTest();
            System.assertEquals('Sample', [SELECT Name FROM Account][0].Name); 
        }         
    }
    
    @isTest
    static void deleteRelatedRecordsTestSuccess(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        Account a1 = new Account(Name='ParentAccount');
        Account a2 = new Account(Name='ChildAccount');
        insert a1;
        a2.ParentId = a1.Id;
        insert a2;
        tm.selectedObj = 'account';
        TheMainController.RelatedRecordWrapperClass rrw = new TheMainController.RelatedRecordWrapperClass(a2, true);
        List<TheMainController.RelatedRecordWrapperClass> lrrw= new List<TheMainController.RelatedRecordWrapperClass>();
        lrrw.add(rrw);
        tm.relatedFocusObject = 'account';
        tm.relatedObjLst = new Map<String, List<TheMainController.RelatedRecordWrapperClass>>();
        tm.relatedObjLst.put('account', lrrw);
        tm.relatedFldMapVF = new Map<String, List<String>>();
        tm.recordId = a1.Id;
        tm.relatedFldMapVF.put('account', new List<String>{'Name', 'Industry', 'Rating'});
        Test.startTest();
        tm.deleteRelatedRecords();
        Test.stopTest();
        System.assertEquals(1, [SELECT Name FROM Account].size());     
    }
    
    @isTest
    static void deleteRelatedRecordsTestFail(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        Account a1 = new Account(Name='ParentAccount');
        Account a2 = new Account(Name='ChildAccount');
        insert a1;
        a2.ParentId = a1.Id;
        insert a2;
        Case c = new Case(Status='Working', priority='Low');
        c.AccountId = a2.Id;
        insert c;
        tm.selectedObj = 'account';
        TheMainController.RelatedRecordWrapperClass rrw = new TheMainController.RelatedRecordWrapperClass(a2, true);
        List<TheMainController.RelatedRecordWrapperClass> lrrw= new List<TheMainController.RelatedRecordWrapperClass>();
        lrrw.add(rrw);
        tm.relatedFocusObject = 'account';
        tm.relatedObjLst = new Map<String, List<TheMainController.RelatedRecordWrapperClass>>();
        tm.relatedObjLst.put('account', lrrw);
        tm.relatedFldMapVF = new Map<String, List<String>>();
        tm.recordId = a1.Id;
        tm.relatedFldMapVF.put('account', new List<String>{'Name', 'Industry', 'Rating'});
        Test.startTest();
        tm.deleteRelatedRecords();
        Test.stopTest();
        System.assertEquals(2, [SELECT Name FROM Account].size()); 
        
    }
    
    @isTest
    static void deleteRelatedRecordsTestCRUD(){
        
        TEST_setupPermissions p = new TEST_setupPermissions('Account', 'Fax');
 
        p.fields.PermissionsEdit = false;
        p.fields.PermissionsRead = true;
        p.objects.setAllFalse();
        p.objects.PermissionsRead = true;
        
        setup(p); 
        
        System.runAs(restrictedUser){
            Test.setCurrentPage(Page.Main); //Applying page context here
            TheMainController tm = new TheMainController();
            Account a1 = new Account(Name='ParentAccount');
            Account a2 = new Account(Name='ChildAccount');
            insert a1;
            a2.ParentId = a1.Id;
            insert a2;
            tm.selectedObj = 'account';
            TheMainController.RelatedRecordWrapperClass rrw = new TheMainController.RelatedRecordWrapperClass(a2, true);
            List<TheMainController.RelatedRecordWrapperClass> lrrw= new List<TheMainController.RelatedRecordWrapperClass>();
            lrrw.add(rrw);
            tm.relatedFocusObject = 'account';
            tm.relatedObjLst = new Map<String, List<TheMainController.RelatedRecordWrapperClass>>();
            tm.relatedObjLst.put('account', lrrw);
            tm.relatedFldMapVF = new Map<String, List<String>>();
            tm.recordId = a1.Id;
            tm.relatedFldMapVF.put('account', new List<String>{'Name', 'Industry', 'Rating'});
            Test.startTest();
            tm.deleteRelatedRecords();
            Test.stopTest();
            System.assertEquals(2, [SELECT Name FROM Account].size());  
        }          
    }
    
    @isTest
    static void updateRelatedRecordsTestSuccess(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        Account a1 = new Account(Name='ParentAccount');
        Account a2 = new Account(Name='ChildAccount');
        insert a1;
        a2.ParentId = a1.Id;
        insert a2;
        a2.Name = 'NewChildAccount';
        tm.selectedObj = 'account';
        TheMainController.RelatedRecordWrapperClass rrw = new TheMainController.RelatedRecordWrapperClass(a2, true);
        List<TheMainController.RelatedRecordWrapperClass> lrrw= new List<TheMainController.RelatedRecordWrapperClass>();
        lrrw.add(rrw);
        tm.relatedFocusObject = 'account';
        tm.relatedObjLst = new Map<String, List<TheMainController.RelatedRecordWrapperClass>>();
        tm.relatedObjLst.put('account', lrrw);
        tm.relatedFldMapVF = new Map<String, List<String>>();
        tm.recordId = a1.Id;
        tm.relatedFldMapVF.put('account', new List<String>{'Name', 'Industry', 'Rating'});
        Test.startTest();
        tm.updateRelatedRecords();
        Test.stopTest();
        System.assertEquals(1, [SELECT Name FROM Account WHERE Name = 'NewChildAccount'].size());     
    }
    
    @isTest
    static void updateRelatedRecordsTestFail(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        Account a1 = new Account(Name='ParentAccount');
        Account a2 = new Account(Name='ChildAccount');
        insert a1;
        a2.ParentId = a1.Id;
        insert a2;
        a2.Name = '';
        Case c = new Case(Status='Working', priority='Low');
        c.AccountId = a2.Id;
        insert c;
        tm.selectedObj = 'account';
        TheMainController.RelatedRecordWrapperClass rrw = new TheMainController.RelatedRecordWrapperClass(a2, true);
        List<TheMainController.RelatedRecordWrapperClass> lrrw= new List<TheMainController.RelatedRecordWrapperClass>();
        lrrw.add(rrw);
        tm.relatedFocusObject = 'account';
        tm.relatedObjLst = new Map<String, List<TheMainController.RelatedRecordWrapperClass>>();
        tm.relatedObjLst.put('account', lrrw);
        tm.relatedFldMapVF = new Map<String, List<String>>();
        tm.recordId = a1.Id;
        tm.relatedFldMapVF.put('account', new List<String>{'Name', 'Industry', 'Rating'});
        Test.startTest();
        tm.updateRelatedRecords();
        Test.stopTest();
        System.assertEquals(1, [SELECT Name FROM Account WHERE Name = 'ChildAccount'].size());  
        
    }
    
    @isTest
    static void updateRelatedRecordsTestCRUD(){
        
        TEST_setupPermissions p = new TEST_setupPermissions('Account', 'Fax');
 
        p.fields.PermissionsEdit = false;
        p.fields.PermissionsRead = true;
        p.objects.setAllFalse();
        p.objects.PermissionsRead = true;
        
        setup(p); 
        
        System.runAs(restrictedUser){
            Test.setCurrentPage(Page.Main); //Applying page context here
            TheMainController tm = new TheMainController();
            Account a1 = new Account(Name='ParentAccount');
            Account a2 = new Account(Name='ChildAccount');
            insert a1;
            a2.ParentId = a1.Id;
            insert a2;
            a2.Name = 'NewChildAccount';
            tm.selectedObj = 'account';
            TheMainController.RelatedRecordWrapperClass rrw = new TheMainController.RelatedRecordWrapperClass(a2, true);
            List<TheMainController.RelatedRecordWrapperClass> lrrw= new List<TheMainController.RelatedRecordWrapperClass>();
            lrrw.add(rrw);
            tm.relatedFocusObject = 'account';
            tm.relatedObjLst = new Map<String, List<TheMainController.RelatedRecordWrapperClass>>();
            tm.relatedObjLst.put('account', lrrw);
            tm.relatedFldMapVF = new Map<String, List<String>>();
            tm.recordId = a1.Id;
            tm.relatedFldMapVF.put('account', new List<String>{'Name', 'Industry', 'Rating'});
            Test.startTest();
            tm.updateRelatedRecords();
            Test.stopTest();
            System.assertEquals(1, [SELECT Name FROM Account WHERE Name = 'ChildAccount'].size());    
        }          
    }
    
    @isTest
    static void createMainTasksTestSuccess(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        Account a = new Account(Name='Account');
        insert a;
        TheMainController.MainRecordWrapperClass mrw = new TheMainController.MainRecordWrapperClass(a, true);
        tm.selectedObj = 'account';
        tm.mainObjLst = new List<TheMainController.MainRecordWrapperClass>();
        tm.mainObjLst.add(mrw);
        tm.Paging = new ListCollection();
        tm.Paging.myData = tm.mainObjLst;
        tm.massTask = new Task();
        tm.massTask.whatId = a.id;
        tm.massTask.ownerId = UserInfo.getUserId();
        tm.massTask.isReminderSet = false;
        tm.massTask.status = 'Working';
        tm.massTask.priority = 'High';
        Test.startTest();
        tm.createMainTasks();
        Test.stopTest();
        System.assertEquals(1, [SELECT id FROM Task WHERE WhatId =: a.id].size()); 
        
    }
    
    @isTest
    static void createMainTasksTestFail(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        Account a = new Account(Name='Account');
        insert a;
        TheMainController.MainRecordWrapperClass mrw = new TheMainController.MainRecordWrapperClass(a, true);
        tm.selectedObj = 'account';
        tm.mainObjLst = new List<TheMainController.MainRecordWrapperClass>();
        tm.mainObjLst.add(mrw);
        tm.Paging = new ListCollection();
        tm.Paging.myData = tm.mainObjLst;
        tm.massTask = new Task();
        tm.massTask.whatId = a.id;
        Test.startTest();
        tm.createMainTasks();
        Test.stopTest();
        System.assertEquals(0, [SELECT id FROM Task WHERE WhatId =: a.id].size()); 
        
    }
    
    @isTest
    static void createMainTasksTestCRUD(){
        
        TEST_setupPermissions p = new TEST_setupPermissions('Task', '');
 
        p.fields.PermissionsEdit = false;
        p.fields.PermissionsRead = true;
        p.objects.setAllFalse();
        p.objects.PermissionsRead = true;
        
        setup(p); 
        
        System.runAs(restrictedUser){
            Test.setCurrentPage(Page.Main); //Applying page context here
            TheMainController tm = new TheMainController();
            Account a = new Account(Name='Account');
            insert a;
            TheMainController.MainRecordWrapperClass mrw = new TheMainController.MainRecordWrapperClass(a, true);
            tm.selectedObj = 'account';
            tm.mainObjLst = new List<TheMainController.MainRecordWrapperClass>();
            tm.mainObjLst.add(mrw);
            tm.Paging = new ListCollection();
            tm.Paging.myData = tm.mainObjLst;
            tm.massTask = new Task();
            tm.massTask.whatId = a.id;
            tm.massTask.ownerId = UserInfo.getUserId();
            tm.massTask.isReminderSet = false;
            tm.massTask.status = 'Working';
            tm.massTask.priority = 'High';
            Test.startTest();
            tm.createMainTasks();
            Test.stopTest();
            System.assertEquals(0, [SELECT id FROM Task WHERE WhatId =: a.id].size());     
        }          
    }
    
    @isTest
    static void createMainEventsTestSuccess(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        Account a = new Account(Name='Account');
        insert a;
        TheMainController.MainRecordWrapperClass mrw = new TheMainController.MainRecordWrapperClass(a, true);
        tm.selectedObj = 'account';
        tm.mainObjLst = new List<TheMainController.MainRecordWrapperClass>();
        tm.mainObjLst.add(mrw);
        tm.Paging = new ListCollection();
        tm.Paging.myData = tm.mainObjLst;
        tm.massEvent = new Event();
        tm.massEvent.whatId = a.id;
        tm.massEvent.ownerId = UserInfo.getUserId();
        tm.massEvent.isReminderSet = false;
        tm.massEvent.isAllDayEvent = false;
        tm.massEvent.isPrivate = false;
        tm.massEvent.activityDateTime = System.now();
        tm.massEvent.durationInMinutes = 60;
        tm.dateObj = new DateObject__C();
        Test.startTest();
        tm.createMainEvents();
        Test.stopTest();
        System.assertEquals(1, [SELECT id FROM Event WHERE WhatId =: a.id].size());  
        
    }
    
    @isTest
    static void createMainEventsTestFail(){
        Test.setCurrentPage(Page.Main); //Applying page context here
        TheMainController tm = new TheMainController();
        Account a = new Account(Name='Account');
        insert a;
        TheMainController.MainRecordWrapperClass mrw = new TheMainController.MainRecordWrapperClass(a, true);
        tm.selectedObj = 'account';
        tm.mainObjLst = new List<TheMainController.MainRecordWrapperClass>();
        tm.mainObjLst.add(mrw);
        tm.Paging = new ListCollection();
        tm.Paging.myData = tm.mainObjLst;
        tm.massEvent = new Event();
        tm.massEvent.whatId = a.id;
        tm.dateObj = new DateObject__C();
        Test.startTest();
        tm.createMainEvents();
        Test.stopTest();
        System.assertEquals(0, [SELECT id FROM Event WHERE WhatId =: a.id].size()); 
        
    }
    
    @isTest
    static void createMainEventsTestCRUD(){
        
        TEST_setupPermissions p = new TEST_setupPermissions('Task', '');
 
        p.fields.PermissionsEdit = false;
        p.fields.PermissionsRead = true;
        p.objects.setAllFalse();
        p.objects.PermissionsRead = true;
        
        setup(p); 
        
        System.runAs(restrictedUser){
            Test.setCurrentPage(Page.Main); //Applying page context here
            TheMainController tm = new TheMainController();
            Account a = new Account(Name='Account');
            insert a;
            TheMainController.MainRecordWrapperClass mrw = new TheMainController.MainRecordWrapperClass(a, true);
            tm.selectedObj = 'account';
            tm.mainObjLst = new List<TheMainController.MainRecordWrapperClass>();
            tm.mainObjLst.add(mrw);
            tm.Paging = new ListCollection();
            tm.Paging.myData = tm.mainObjLst;
            tm.massEvent = new Event();
            tm.massEvent.whatId = a.id;
            tm.massEvent.ownerId = UserInfo.getUserId();
            tm.massEvent.isReminderSet = false;
            tm.massEvent.isAllDayEvent = false;
            tm.massEvent.isPrivate = false;
            tm.massEvent.activityDateTime = System.now();
            tm.massEvent.durationInMinutes = 60;
            tm.dateObj = new DateObject__C();
            Test.startTest();
            tm.createMainEvents();
            Test.stopTest();
            System.assertEquals(0, [SELECT id FROM Event WHERE WhatId =: a.id].size());     
        }          
    }
    
    @isTest
    static void getFieldsFromFieldSetTest(){
        TheMainController tm = new TheMainController();
        List<String> fd_collect1 = tm.getFieldsFromFieldSet(0);
    }
    
    /*@isTest
    static void mixTest(){
        Boolean b1, b2, b3;
        TheMainController tm = new TheMainController();
        map<String, List<String>> mp = new Map<String, List<String>>();
        mp.put('hello', new List<String>{'Acccount'});
        tm.relatedFldMapVF =mp;
        tm.recordId ='0016F00002Pt3zv';
        
        instantiateMainObjLstTest1();
        tm.selectedObj = 'Account';
        tm.getSelObjFields();
        Selectoption []arr = new selectoption[2];
        arr[0] =(new selectoption('Energy', 'Energy'));
        String value = 'Energy&Electronics&Industry';
        tm.setOptions(arr, value);//void
        
        b1 = null == tm.method();
        tm.leftOptionsHidden = 'abc';
        tm.rightOptionsHidden ='xyz';
        b2 = ('abc'==tm.leftOptionsHidden && 'xyz' == tm.rightOptionsHidden);
        System.assert(true == (b1 && b2));
    }*/
    
}