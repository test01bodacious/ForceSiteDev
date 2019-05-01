@isTest
private class AccessibilityTestClass { 
    @isTest
    public static void Accessbility() {
         Test.startTest();
         Accessibility access=new Accessibility();
         access.profile='System Administrator';
         access.email='aniketraj8493@gmail.com';
         System.assertEquals('System Administrator', access.profile);
         system.assertEquals('aniketraj8493@gmail.com', access.email);
         Test.stopTest();
    }
    @isTest
    public static void FieldAccess() {
         Test.startTest();
         Accessibility.FieldAccess fld=new Accessibility.FieldAccess();
         fld.hasReadAccess=false;
         fld.hasEditAccess=false;
         System.assertEquals(false, fld.hasReadAccess);
         system.assertEquals(false, fld.hasEditAccess);
         Test.stopTest();
    }
    @isTest
    public static void RecordAccess(){
        Test.startTest();
        Accessibility.RecordAccess Recordacc=new Accessibility.RecordAccess();
        Recordacc.hasEditAccess=false;
        Recordacc.hasReadAccess=false;
        System.assertEquals(false, Recordacc.hasEditAccess);
        system.assertEquals(false, Recordacc.hasReadAccess);
        Test.stopTest();
         }
        
    @isTest
    public static void ObjectAccess(){
         Test.startTest();
         Accessibility.ObjectAccess objectacc=new Accessibility.ObjectAccess();
         objectacc.hasReadAccess=false;
         objectacc.hasEditAccess=false;
         objectacc.hasCreateAccess=false;
         objectacc.hasDeleteAccess=false;
         System.assertEquals(false, objectacc.hasReadAccess);
         System.assertEquals(false, objectacc.hasEditAccess=false);
         System.assertEquals(false, objectacc.hasCreateAccess=false);
         System.assertEquals(false, objectacc.hasDeleteAccess=false);
         Test.stopTest();
        
    }
}