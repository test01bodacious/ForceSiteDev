@isTest
public class CreateTaskAndEventController_Test {
//    @isTest
//    public static void setaccessbilityobj(){
//        Test.startTest();
//        CreateTaskAndEventComponentController CTaskeController=new CreateTaskAndEventComponentController();
//        CTaskeController.setaccessbilityobj(new Account());
//        Test.stopTest();
//    }
   @isTest
   public static void getaccessbilityobj(){
       Test.startTest();
       CreateTaskAndEventComponentController CTaskeController=new CreateTaskAndEventComponentController();
       CTaskeController.getaccessbilityobj();
       Test.stopTest();
   }
   @isTest
   public static void setrecordsIdList(){
       Test.startTest();
       CreateTaskAndEventComponentController CTaskeController=new CreateTaskAndEventComponentController();
       List<String> lst=new List<String>{'abc123','qwe321'};
       CTaskeController.setrecordsIdList(lst);
       Test.stopTest();
   }
   @isTest
   public static void getrecordsIdList(){
       Test.startTest();
       CreateTaskAndEventComponentController CTaskeController=new CreateTaskAndEventComponentController();
       CTaskeController.getrecordsIdList();
       Test.stopTest();

   }
   @isTest
   public static void getselectedobj(){
       Test.startTest();
       CreateTaskAndEventComponentController CTaskeController=new CreateTaskAndEventComponentController();
       CTaskeController.getselectedobj();
       Test.stopTest();
   }
   @isTest
   public static void setSelectedObj(){
       Test.startTest();
       CreateTaskAndEventComponentController CTaskeController=new CreateTaskAndEventComponentController();
       CTaskeController.setselectedobj('Account');
       Test.stopTest();
   }
   @isTest
   public static void getrecId(){
       Test.startTest();
       CreateTaskAndEventComponentController CTaskeController=new CreateTaskAndEventComponentController();
       CTaskeController.getrecId();
       Test.stopTest();
   }
   @isTest
   public static void setrecId(){
        Account acc=new Account(Name='Account1');
        insert acc;
       Test.startTest();
       CreateTaskAndEventComponentController CTaskeController=new CreateTaskAndEventComponentController();
       CTaskeController.selectedObj='Account';
       String rid=acc.Id;
       CTaskeController.setrecId(rid);
       Test.stopTest();
   }
//    @isTest
//    public static void getAvailableRecordTypes(){
//        Test.startTest();
//        CreateTaskAndEventComponentController CTaskeController=new CreateTaskAndEventComponentController();
//        CTaskeController.getAvailableRecordTypes();
//        Test.stopTest();
//    }
//    @isTest
//    public static void getAccounNames(){
//        Account acc=new Account(Name='Account1');
//        insert acc;
//        Test.startTest();
//        CreateTaskAndEventComponentController CTaskeController=new CreateTaskAndEventComponentController();
//        CTaskeController.getAccounNames();
//        Test.stopTest();

//    }
   @isTest
   public static void initRecord(){
       Account acc=new Account(Name='Account1');
       insert acc;
       Test.startTest();
       CreateTaskAndEventComponentController CTaskeController=new CreateTaskAndEventComponentController();
       CTaskeController.flds =new List<String>{'Id', 'name'};
    //    cfield.add('Id');
    //    cfield.add('name');
     // CTaskeController.flds[1]='Name';
       CTaskeController.selectedobj='Account';
       CTaskeController.recId=acc.Id;
       CTaskeController.initRecord();
       Test.stopTest();

   }
   @isTest
   public static void save(){
       Account acc=new Account(Name='Account1');
       insert acc;
       Test.startTest();
       CreateTaskAndEventComponentController CTaskeController=new CreateTaskAndEventComponentController();
       string s=acc.id;
       CTaskeController.recId='NA';
       CTaskeController.recordsIdList = new List<string>();
       CTaskeController.recordsIdList[0]=s;
      // CTaskeController.recordsIdList[0]='abcd1234';
       CTaskeController.save();
       Test.stopTest();
   }
   @isTest
   public static void getJavaScriptFunctionCall(){
       Test.startTest();
       CreateTaskAndEventComponentController CTaskeController=new CreateTaskAndEventComponentController();
       CTaskeController.getJavaScriptFunctionCall();
       Test.stopTest();
   }
}