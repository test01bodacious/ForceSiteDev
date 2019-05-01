@isTest
private class MainBatchApexTest {
    
    private static User restrictedUser;
    private static final string restrictedProfile = 'Read Only';
    
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
    static void testUpdateSuccess(){
        List<Account> l = new List<Account>{new Account(Name='Sample')};
        insert l;
        l[0].Name = 'New Sample';
        Test.startTest();
        MainBatchApex mba = new MainBatchApex(l, 'update', 'Account');
        Database.executeBatch(mba);
        Test.stopTest();
        System.assertEquals('New Sample', [SELECT Name FROM Account][0].Name);   
    }
    
    @isTest
    static void testUpdateFail(){
        List<Account> l = new List<Account>{new Account(Name='Sample')};
        insert l;
        l[0].Name = '';
        Test.startTest();
        MainBatchApex mba = new MainBatchApex(l, 'update', 'Account');
        Database.executeBatch(mba);
        Test.stopTest();
        System.assertEquals('Sample', [SELECT Name FROM Account][0].Name); 
    }
    
    @isTest
    static void testUpdateCRUD(){
        
        TEST_setupPermissions p = new TEST_setupPermissions('Account', 'Fax');
        
        // Specify options to satisfy test case. Here we are creating a profile which user can read but not edit the Account object
        // and only has read permissions for the field Fax:
        p.fields.PermissionsEdit = false;
        p.fields.PermissionsRead = true;
        p.objects.setAllFalse();
        p.objects.PermissionsRead = true;
        
        // Call The setup to create the permission set and assign to the user 'restrictedUser'
        setup(p); 
        
        //CrudFlsCheckResult result;
        System.runAs(restrictedUser){
            // Check the code to test for CRUD/FLS
            List<Account> l = new List<Account>{new Account(Name='Sample')};
            insert l;
            l[0].Name = 'New Sample';
            Test.startTest();
            MainBatchApex mba = new MainBatchApex(l, 'update', 'Account');
            Database.executeBatch(mba);
            Test.stopTest();
            System.assertEquals('Sample', [SELECT Name FROM Account][0].Name);
        }
        
    }
    
    @isTest
    static void testDeleteSuccess(){
        List<Account> l = new List<Account>{new Account(Name='Sample')};
        insert l;
        Test.startTest();
        MainBatchApex mba = new MainBatchApex(l, 'delete', 'Account');
        Database.executeBatch(mba);
        Test.stopTest();
        System.assertEquals(0, [SELECT Name FROM Account].size());
    }
    
    @isTest
    static void testDeleteFail(){
        List<Account> l = new List<Account>{new Account(Name='Sample')};
        insert l;
        Case c = new Case(status='Working', priority='High');
        c.AccountId = l[0].id;
        insert c;
        Test.startTest();
        MainBatchApex mba = new MainBatchApex(l, 'delete', 'Account');
        Database.executeBatch(mba);
        Test.stopTest();
        System.assertEquals('Sample', [SELECT Name FROM Account][0].Name); 
    }
    
    @isTest
    static void testDeleteCRUD(){
       TEST_setupPermissions p = new TEST_setupPermissions('Account', 'Fax');
 
        p.fields.PermissionsEdit = false;
        p.fields.PermissionsRead = true;
        p.objects.setAllFalse();
        p.objects.PermissionsRead = true;
        
        setup(p); 
        
        System.runAs(restrictedUser){
            
            List<Account> l = new List<Account>{new Account(Name='Sample')};
            insert l;
            Test.startTest();
            MainBatchApex mba = new MainBatchApex(l, 'delete', 'Account');
            Database.executeBatch(mba);
            Test.stopTest();
            System.assertEquals('Sample', [SELECT Name FROM Account][0].Name);
        }
    }
    
    @isTest
    static void testTaskSuccess(){
        List<Account> l = new List<Account>{new Account(Name='Sample')};
        insert l;
        List<Task> t = new List<Task>();
        Task tsk = new Task();
        t.add(tsk);
        t[0].WhatId = l[0].id;
        Test.startTest();
        MainBatchApex mba = new MainBatchApex(t, 'task', 'task');
        Database.executeBatch(mba);
        Test.stopTest();
        System.assertEquals(1, [SELECT id FROM Task WHERE WhatId = :l[0].id].size());
    }
    
    @isTest
    static void testTaskFail(){
        List<Task> t = new List<Task>();
        Task tsk = new Task();
        t.add(tsk);
        t[0].WhatId = '0060b00000pNTBj';
        Test.startTest();
        MainBatchApex mba = new MainBatchApex(t, 'task', 'task');
        Database.executeBatch(mba);
        Test.stopTest();
        System.assertEquals(0, [SELECT id FROM Task].size());
    }
    
    @isTest
    static void testTaskCRUD(){
        TEST_setupPermissions p = new TEST_setupPermissions('Task', '');
 
        p.fields.PermissionsEdit = false;
        p.fields.PermissionsRead = true;
        p.objects.setAllFalse();
        p.objects.PermissionsRead = true;
        
        setup(p); 
        
        System.runAs(restrictedUser){
            
            List<Account> l = new List<Account>{new Account(Name='Sample')};
            insert l;
            List<Task> t = new List<Task>();
            Task tsk = new Task();
            t.add(tsk);
            t[0].WhatId = l[0].id;
            Test.startTest();
            MainBatchApex mba = new MainBatchApex(t, 'task', 'task');
            Database.executeBatch(mba);
            Test.stopTest();
            System.assertEquals(0, [SELECT id FROM Task WHERE WhatId = :l[0].id].size());
        }
    }
    
    @isTest
    static void testEventSuccess(){
        List<Account> l = new List<Account>{new Account(Name='Sample')};
        insert l;
        List<Event> e = new List<Event>();
        Event ev = new Event();
        e.add(ev);
        e[0].WhatId = l[0].id;
        e[0].durationInMinutes = 60;
        e[0].activityDateTime = System.now();
        Test.startTest();
        MainBatchApex mba = new MainBatchApex(e, 'event', 'event');
        Database.executeBatch(mba);
        Test.stopTest();
        System.assertEquals(1, [SELECT id FROM Event WHERE WhatId = :l[0].id].size());
    }
    
    @isTest
    static void testEventFail(){
        List<Event> e = new List<Event>();
        Event ev = new Event();
        e.add(ev);
        Test.startTest();
        MainBatchApex mba = new MainBatchApex(e, 'event', 'event');
        Database.executeBatch(mba);
        Test.stopTest();
        System.assertEquals(0, [SELECT id FROM Task].size());
    }
    
    @isTest
    static void testEventCRUD(){
        TEST_setupPermissions p = new TEST_setupPermissions('Event', '');
 
        p.fields.PermissionsEdit = false;
        p.fields.PermissionsRead = true;
        p.objects.setAllFalse();
        p.objects.PermissionsRead = true;
        
        setup(p); 
        
        System.runAs(restrictedUser){
            
            List<Account> l = new List<Account>{new Account(Name='Sample')};
            insert l;
            List<Event> e = new List<Event>();
            Event ev = new Event();
            e.add(ev);
            e[0].WhatId = l[0].id;
            e[0].durationInMinutes = 60;
            e[0].activityDateTime = System.now();
            Test.startTest();
            MainBatchApex mba = new MainBatchApex(e, 'event', 'event');
            Database.executeBatch(mba);
            Test.stopTest();
            System.assertEquals(0, [SELECT id FROM Event WHERE WhatId = :l[0].id].size());
        }
    }
    
}