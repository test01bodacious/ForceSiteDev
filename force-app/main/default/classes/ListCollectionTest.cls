@isTest
private class ListCollectionTest {
    
    
    @isTest
    static void moveNextTest(){
       
         listCollection lst = new listCollection();
        setup(lst);
        lst.moveNext();
        lst.movePrev();
       
         lst.movePrev();
         lst.inc=0;
         lst.moveNext();
    }
    
	@istest
    static void moveNextLast(){
         listCollection lst = new listCollection();
        setup(lst);
        lst.Offsetvalue10 = 2000;
        lst.limitvalue =200;
        lst.recordcount =2000;
        lst.movefirst();
         lst.Offsetvalue10 = 2000;
        lst.limitvalue =200;
        lst.datLst.add(Datetime.newInstance(2018, 09, 09));
         lst.dat10= datetime.newInstance(2018, 09, 09);
        lst.MoveFunction(lst.query);
        
    }
    	@istest
    static void moveNextTest1(){
         listCollection lst = new listCollection();
        setup(lst);
        lst.Offsetvalue10 = 2000;
        lst.limitvalue =200;
        lst.moveFunction('SELECT Name FROM Account');
        lst.datLst.add(Datetime.newInstance(2018, 09, 09));
         lst.dat10= datetime.newInstance(2018, 09, 09);
        lst.moveNext();
        
        
    }
    
    
    @isTest
    static void MoveprevTest()
    {
        ListCollection lst = new ListCollection();
        setup(lst);
        lst.flag = true;
        lst.inc=0;
        lst.movePrev();
        lst.datLst.add(DateTime.newInstance(2018, 09,10));
        lst.datLst.add(DateTime.newInstance(2018, 09,11));
        lst.datfirst = system.now();
         lst.movePrev();
        lst.dat10= datetime.newInstance(2018, 09, 11);
    
        lst.prevFunction(lst.query);
        lst.dat20= datetime.newInstance(2018, 09, 11);
        lst.flag = true;
        lst.prevFunction('SELECT Name FROm Contract Order By createdate ');
    }
      @isTest
    static void MoveprevFlagTest()
    {
        ListCollection lst = new ListCollection();
        setup(lst);
        lst.flag = true;
        lst.inc=0;
        
        lst.datLst.add(DateTime.newInstance(2018, 09,10));
        lst.datLst.add(DateTime.newInstance(2018, 09,11));
        lst.datfirst = system.now();
        
        lst.dat10= datetime.newInstance(2018, 09, 11);
        lst.movePrev();
        lst.moveFunction(lst.query);
        lst.query = 'SELECT NAme FROM Account ';
         lst.moveFunction(lst.query);
        
    }
   
    static void setup( listCollection lst){
        
         List<Account> acc = new List<Account>();
        for(integer i =1 ; i < 3010 ;i++)
        {
            acc.Add(new Account(Name ='Account-'+i));
        }
        insert acc;
       //Account a = new Account(Name= 'Account');
       // insert a;
        lst.mysObjData = acc;
       lst.obj=acc;
        lst.prevObj = acc;
        lst.mainSize =2;
        lst.limitvalue=200;
        
        lst.pagesize=10;
        lst.inc=19;
        lst.query = 'SELECT Name FROm Account WHERE name != null LIMIT 200 OFFSET 100';
    }
}