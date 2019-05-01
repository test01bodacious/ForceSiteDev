@isTest
global class MockHttpResponseGenerator1 implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest req) {  
          
        //System.assertEquals('https://reqres.in/api/users/2', req.getEndpoint());  
        //System.assertEquals('GET', req.getMethod());  
          
        // Create a fake response  
        HttpResponse res = new HttpResponse();  
        res.setHeader('Content-Type', 'application/json');  
        res.setBody('{ "id": 118051627019532805457,"email": "pritamraj.rits@gmail.com","verified_email": true,"name": "pritam yaduwanshi","given_name": "pritam","family_name": "yaduwanshi","picture": "https://lh6.googleusercontent.com/-qnGe33nt7LQ/AAAAAAAAAAI/AAAAAAAAAAA/ACHi3rd4c8bOLwZZu6Cm-bTo1R5fyj_tDg/mo/photo.jpg"}');  
        res.setStatusCode(200);  
        return res;  
    }  

}