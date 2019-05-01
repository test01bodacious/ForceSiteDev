@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {  
          
        //System.assertEquals('https://reqres.in/api/users/2', req.getEndpoint());  
        //System.assertEquals('GET', req.getMethod());  
          
        // Create a fake response  
        HttpResponse res = new HttpResponse();  
        res.setHeader('Content-Type', 'application/json');  
        res.setBody('{"totalSize":2,"done":true,"records":[{"attributes":{"type":"MyUser__c","url":"/services/data/v43.0/sobjects/MyUser__c/a010b00000f9kYQAAY"},"Name":"pritamraj.rits@gmail.com","MyUser_PassWord__c":null},{"attributes":{"type":"MyUser__c","url":"/services/data/v43.0/sobjects/MyUser__c/a010b00000f9TWeAAM"},"Name":"joshi.chirag2894@gmail.com","MyUser_PassWord__c":null}]}');  
        res.setStatusCode(200);  
        return res;  
    }  

}