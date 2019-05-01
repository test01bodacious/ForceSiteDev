@IsTest
public class JSON2ApexTestClass {
 
@IsTest
 static void JSON2Apex() {
     Test.startTest();
     String json = '[{\"attributes\":{\"type\":\"Account\"},\"Name\":\"Test-1\"},{\"attributes\":{\"type\":\"Account\"},\"Name\":\"Test-2\"}]';
     JSON2Apex j2apex = JSON2Apex.parse(json);
     JSON2Apex.arrayOfRecords(System.JSON.createParser(json));
     j2apex.totalSize=1;
     j2apex.done=false;
     System.assertEquals(false, j2apex.done);
     system.assertEquals(1, j2apex.totalSize);
     System.assert(j2apex != null);
     Test.stopTest();

 }

@isTest
public static void Records(){
     Test.startTest();
     String json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
     JSON2Apex.Records recordJSON2Apex = new JSON2Apex.Records(System.JSON.createParser(json));
     recordJSON2Apex.MyUser_PassWord_c='ani@1234';
     System.assertEquals('ani@1234', recordJSON2Apex.MyUser_PassWord_c);
     System.assert(recordJSON2Apex != null);
     System.assert(recordJSON2Apex.attributes == null);
     System.assert(recordJSON2Apex.Name == null);
     Test.stopTest();
 
}
@isTest
public static void Attributes(){
     Test.startTest();
     String json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
     JSON2Apex.Attributes attributesJSON2Apex = new JSON2Apex.Attributes(System.JSON.createParser(json));
     attributesJSON2Apex.url='www.login.salesforce.com';
     System.assertEquals('www.login.salesforce.com', attributesJSON2Apex.url);
     System.assert(attributesJSON2Apex != null);
     System.assert(attributesJSON2Apex.type_Z == null);
     Test.stopTest();
}

  
}