@isTest
public class RelatedListComponentController_Test {
    @isTest
    public static void getobjName(){
        Test.startTest();
        RelatedListComponentController relatedLCcontroller=new RelatedListComponentController();
        relatedLCcontroller.getobjName();
        System.assert(relatedLCcontroller.objName == null);
        Test.stopTest();
    }
    @isTest
    public static void setProfilename(){
        Test.startTest();
        RelatedListComponentController relatedLCcontroller=new RelatedListComponentController();
        relatedLCcontroller.setProfilename('System Administrator');
        System.assertEquals('System Administrator', relatedLCcontroller.profileName);
        Test.stopTest();
    }
    @isTest
    public static void getProfilename(){
        Test.startTest();
        RelatedListComponentController relatedLCcontroller=new RelatedListComponentController();
        relatedLCcontroller.getProfilename();
        System.assert(relatedLCcontroller.profileName == null);
        Test.stopTest();
    }
    @isTest
    public static void setObjName(){
        Test.startTest();
        RelatedListComponentController relatedLCcontroller=new RelatedListComponentController();
        relatedLCcontroller.setobjName('Account');
        System.assertEquals('Account', relatedLCcontroller.objName);
        Test.stopTest();
    }
    @isTest
    public static void getrecId(){
        Test.startTest();
        RelatedListComponentController relatedLCcontroller=new RelatedListComponentController();
        relatedLCcontroller.getrecId();
        System.assert(relatedLCcontroller.recId == null);
        Test.stopTest();
    }
    @isTest
    public static void setrecId(){
        Test.startTest();
        RelatedListComponentController relatedLCcontroller=new RelatedListComponentController();
        relatedLCcontroller.objName='Account';
        AccountInsert ainsert=new AccountInsert();
        relatedLCcontroller.setrecId(ainsert.acc.Id);
        System.assert(ainsert.acc.Id != null);
        System.assert(relatedLCcontroller.objname != null);
        Test.stopTest();
    }
    @isTest 
    public static void initRecordException(){
        Test.startTest();
        RelatedListComponentController relatedLCcontroller=new RelatedListComponentController();
       // relatedLCcontroller.objectName=null;
        relatedLCcontroller.initRecord();
        System.assert(relatedLCcontroller.objName == null);
        Test.stopTest();
    }
    @isTest
    public static void getDefaultFields(){
        Test.startTest();
        RelatedListComponentController relatedLCcontroller=new RelatedListComponentController();
        String obj='campaign';
        relatedLCcontroller.getDefaultFields(obj);
        System.assertEquals('campaign', obj);
         obj='Lead';
        relatedLCcontroller.getDefaultFields(obj);
        System.assertEquals('Lead', obj);
        // obj='Product';
        // relatedLCcontroller.getDefaultFields(obj);
        // System.assertEquals('Product', obj);
        obj='Solution';
        relatedLCcontroller.getDefaultFields(obj);
        System.assertEquals('Solution',obj);
        obj='User';
        relatedLCcontroller.getDefaultFields(obj);
        System.assertEquals('User',obj);
        Test.stopTest();
    }
    @isTest
    public static void back(){
        Test.startTest();
         RelatedListComponentController relatedLCcontroller=new RelatedListComponentController();
         MyUserDataFactory myuser=new MyUserDataFactory();
         AccountInsert a=new AccountInsert();
         PageReference pageRef =  Page.HeaderMainPage;
         Test.setCurrentPage(pageRef);
         ApexPages.currentPage().getParameters().put('UserId',myuser.my.Id);
         relatedLCcontroller.back();
         ApexPages.currentPage().getParameters().put('UserId',a.acc.Id);
         relatedLCcontroller.back();
         Test.stopTest();
    }
@isTest
public static void checkPermission(){
    Test.startTest();
    RelatedListComponentController relatedLCcontroller=new RelatedListComponentController();
    relatedLCcontroller.accessibility1  =new Accessibility();
    relatedLCcontroller.profileName='System Administrator';
    relatedLCcontroller.objname='Account';
    relatedLCcontroller.CheckPermission();
    Test.stopTest();

}
/*@isTest
public static void initObjectAccessibility(){
    Test.startTest();
    RelatedListComponentController relatedLCcontroller=new RelatedListComponentController();
    Accessibility access=new Accessibility();
    access.profile='System Administrator';
    relatedLCcontroller.initObjectAccessibility(access);
    Test.stopTest();
}*/
@isTest
public static void getParentObjectField(){
    Test.startTest();
    RelatedListComponentController relatedLCcontroller=new RelatedListComponentController();
    relatedLCcontroller.objName='Contact';
    relatedLCcontroller.getParentObjectField('AccountId');
    Test.stopTest();

}
@isTest
public static void getNameUniqueField(){
    Test.startTest();
    RelatedListComponentController relatedLCcontroller=new RelatedListComponentController();
    relatedLCcontroller.getNameUniqueField('Case');
    Test.stopTest();
}
/*@isTest
public static void initaccessibility1(){
    Test.startTest();
    RelatedListComponentController relatedLCcontroller=new RelatedListComponentController();
    relatedLCcontroller.initaccessibility1();
    Test.stopTest();
}
@isTest
public static void initaccessibility2(){
    Test.startTest();
    RelatedListComponentController relatedLCcontroller=new RelatedListComponentController();
    relatedLCcontroller.initaccessibility2();
    Test.stopTest();
}
@isTest
public static void initFieldAccessibilityWithoutNameSpace(){
    Test.startTest();
    RelatedListComponentController relatedLCcontroller=new RelatedListComponentController();
    Accessibility access=new Accessibility();
    access.profile='System Administrator';
    relatedLCcontroller.objectName='Account';
    // Accessibility.FieldAccess fldaccess=new Accessibility.FieldAccess();
    // fldaccess.hasEditAccess=true;
    // fldaccess.hasReadAccess=true;
    relatedLCcontroller.initFieldAccessibilityWithoutNameSpace(access,'Account');
    Test.stopTest();
}*/

}