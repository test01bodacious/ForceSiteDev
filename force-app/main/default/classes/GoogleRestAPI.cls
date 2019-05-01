@RestResource(urlMapping='/MyUsers/*')
global class GoogleRestAPI {
    
    @HttpGet
    global static MyUserWrapper getMyUsers() {
        MyUserWrapper response = new MyUserWrapper();
        boolean flag = false;
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String email = req.requestURI.subString(req.requestURI.lastIndexOf('/')+1);
        List<Site_User__c> u_list = [SELECT Name from Site_User__c];
        for(Site_User__c myuser : u_list){
            if(myuser.Name==email){
                Flag=true;
                break;
            }
        }
        
        if(flag){
            response.status='Yes';
            response.error='NO Error';
        }
            else
            {
                response.status='No';
                response.error='Email not Found';
            }
            return response;
        }
        
        @HttpPost
        global static String createNewMyUser(String Name) {
            Site_User__c u = new Site_User__c();
            u.Name = Name;
            insert u;
            
            return 'Done';
        }
        
        @HttpDelete
        global static String deleteMyUserById() {
            String Id = RestContext.request.params.get('Id');
            List<Site_User__c> u = [ Select ID from Site_User__c where Id= :Id];
            
            delete u;
            
            return 'Deleted MyUser';
        }
        
        @HttpPut
        global static String updateMyUser(String Id, String NewName) {
            Site_User__c u = [ Select ID, Name from Site_User__c where Id= :Id];
            
            u.Name = NewName;
            update u;
            
            return 'MyUser Updated';
        }
        global class MyUserWrapper{
            public string status;
            public string error;
            public MyuserWrapper(){
                status='NA';
                error ='NA';
            }
        }
    }