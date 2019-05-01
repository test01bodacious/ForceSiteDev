public   class GoogleAuthController {
    
    public boolean isrecordlistVisible {get; set;}
    public string authtoken{get;set;}
    public string refereshtoken{get;set;}
    public string bodyprint{get;set;}
    public string mybodyprint{get;set;}
    public string status{get;set;}
    public string accessToken;
    public string instanceUrl;
    public string tokenType;
    public string userList;
    public  String userEmail;
    public Site_User__c user {get; set;}
    public String uid {get; set;}
    private Boolean flag = true;
    public Boolean isLoggedIn {get;set;}
    public boolean isEmailVerified = false;
    public UserInformation userinfo{get;set;}
    public Account acc{get;set;}
    public Contact con{get;set;}
    public Opportunity opp{get;set;}
    public String objName{get;set;}
    public String functionality{get;set;}
    public list<String> objList {get; set;}
    
    public static String ORG_CLIENT_SECRET; //Fill as per your registered app settings in connected app
    public static String ORG_CLIENT_ID; //Fill as per your registered app settings in connected app
    public static String ORG_USER_NAME;
    public static String ORG_PASSWORD;
    public static String ORG_SECURITY_TOKEN;
    
    public static final String ORG_CODE_END_POINT_URL='https://login.salesforce.com/services/oauth2/token?';
    public static final String ORG_GRANT_TYPE='password';
    public static final String ORG_REDIRECT_URL='http://localhost:8080/';
    
    public static String CLIENT_SECRET; //Fill as per your registered app settings in google console
    public static String CLIENT_ID; //Fill as per your registered app settings in google console
    public static String REDIRECT_URL;
    
    public static final String OAUTH_TOKEN_URL='https://accounts.google.com/o/oauth2/token';
    public static final String OAUTH_CODE_END_POINT_URL='https://accounts.google.com/o/oauth2/auth';
    public static final String OAUTH_PROFILE_FETCH_VIA_ACCESS_TOKEN_END_POINT_URL='https://www.googleapis.com/oauth2/v1/userinfo?access_token='; 
    public static final String GRANT_TYPE='grant_type=authorization_code';
    
    //Scope URL as per oauth 2.0 guide of the google 
    public static final String GSCOPE='https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile';
    public static final String STATE='/profile';
    
    //Approval Prompt Constant
    public static final String APPROVAL_PROMPT='force';
    public string customObj {get; set;}
    public string customFunctionality {get; set;}
    
    public GoogleAuthController(){
        objList = new List<String>();
        objList.add('account');
        objList.add('contact');
        objList.add('opportunity');
        initBooleanVariable();
        initsObjects();
        initVariables();
    }
    
    @testVisible void initBooleanVariable(){
        isLoggedIn = false;
    }
    
    public void initsObjects(){
        acc = new Account();
        con = new Contact();
        opp = new Opportunity();
        
    }
    
    @testVisible void initVariables(){
        objName = '';
        functionality = '';
    }
    
    static{
        initCredentials();
    }
    
    @testVisible static Boolean initCredentials(){
        try{
            List<GoogleAndConnectedAppCredentials__C> gcApp = [SELECT GoogleClientSecret__c, GoogleClientId__c, GoogleRedirectURL__c, OrgClientId__c, OrgClientSecret__c,
                                                               OrgPassword__c, OrgSecurityToken__c, OrgUserName__c FROM GoogleAndConnectedAppCredentials__C];
            CLIENT_SECRET = gcApp[0].GoogleClientSecret__c;
            CLIENT_ID = gcApp[0].GoogleClientId__c;
            REDIRECT_URL = gcApp[0].GoogleRedirectURL__c;
            ORG_CLIENT_SECRET = gcApp[0].OrgClientSecret__c;
            ORG_CLIENT_ID = gcApp[0].OrgClientId__c;
            ORG_USER_NAME = gcApp[0].OrgUserName__c;
            ORG_PASSWORD = gcApp[0].OrgPassword__c;
            ORG_SECURITY_TOKEN = gcApp[0].OrgSecurityToken__c;
            
            if(CLIENT_SECRET==null || CLIENT_ID == null || REDIRECT_URL == null || ORG_CLIENT_SECRET == null || ORG_CLIENT_ID == null || ORG_USER_NAME == null || ORG_PASSWORD == null || ORG_SECURITY_TOKEN == null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'You lack some custom settings needed for the authorization. Please check your custom settings'));
                return false;
            }
            return true;
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'You lack some custom settings needed for the authorization. Please check your custom settings'));
            return false;
        }
        
    }
    
    public pagereference connect(){
        Boolean res = initCredentials();
        System.debug(res);
        if(!res){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'You lack some custom settings needed for the authorization. Please check your custom settings'));
            return null;
        } 
        String x;
        try{
            x = OAUTH_CODE_END_POINT_URL+'?scope='+EncodingUtil.urlEncode(GSCOPE,'UTF-8')+'&state='+EncodingUtil.urlEncode(STATE,'UTF-8')+'&redirect_uri='+EncodingUtil.urlEncode(REDIRECT_URL,'UTF-8')+'&response_type=code&client_id='+CLIENT_ID+'&approval_prompt='+APPROVAL_PROMPT;
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'You lack some custom settings needed for the authorization. Please check your custom settings'));
            return null;
        }
        pagereference p=new pagereference(x); 
        System.debug(x);
        return p;
        
    }
    
    public pagereference showtoken(){
        String codeparam=apexpages.currentpage().getparameters().get('code');
        System.debug(codeparam);
        if(codeparam == null){
            return null;
        }
        
        if(flag){
            // Instantiate a new http object
            Http h = new Http();
            String body='code='+codeparam+'&client_id='+CLIENT_ID+'&client_secret='+CLIENT_SECRET+'&redirect_uri='+REDIRECT_URL+'&'+GRANT_TYPE;
            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            HttpRequest req = new HttpRequest();
            req.setEndpoint(OAUTH_TOKEN_URL);
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            req.setMethod('POST');
            req.setBody(body);
            // Send the request, and return a response
            HttpResponse res = h.send(req);
            bodyprint=res.getbody();
            System.debug(bodyprint);
            flag = false;
        }else{
            
        }
        fetchProfile();
        return null;
    }
    
    // fetching basic information of google account
    public void fetchProfile(){
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        
        JSONParser parser = JSON.createParser(bodyprint);
        GoogleAuthController.JsonId obj;
        try{
            obj = (GoogleAuthController.JsonId)parser.readValueAs( GoogleAuthController.JsonId.class);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
            return;
        }
        String access_token = obj.access_token;
        
        req = new HttpRequest();
        req.setEndpoint(OAUTH_PROFILE_FETCH_VIA_ACCESS_TOKEN_END_POINT_URL + access_token);
        req.setHeader('Authorization','Authorization '+access_token);
        req.setMethod('GET');
        HttpResponse res;
        res = h.send(req);

        string googleInfo = res.getbody();
        System.debug(googleInfo);
        JSONparser parser1 = JSON.createParser(googleinfo);
        GoogleInfo obj1;
        try{
            obj1 = (GoogleInfo)parser1.readValueAs(GoogleInfo.class);
            System.debug(obj1);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
            return;
        }
        userEmail =obj1.email;
        String verified_email = obj1.verified_email;
        
        if(useremail == null || verified_email == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Email not found! Please try reconnecting.'));
        }else{
            getOrgInfo();
            isEmailVerified= true;
            passUserId(userEmail);
        }
        
    }
    
    public void getOrgInfo(){
        System.RestContext.request = new RestRequest();
        System.RestContext.response = new RestResponse();
        httpRequest req= new httpRequest();
        http h = new http();
        HttpResponse res;
        system.debug(ORG_CODE_END_POINT_URL + 'grant_type=' + ORG_GRANT_TYPE + '&client_id=' + ORG_CLIENT_ID + '&client_secret=' + ORG_CLIENT_SECRET + '&username=' + ORG_USER_NAME + '&password=' + ORG_PASSWORD + ORG_SECURITY_TOKEN);
        req.setEndpoint(ORG_CODE_END_POINT_URL + 'grant_type=' + ORG_GRANT_TYPE + '&client_id=' + ORG_CLIENT_ID + '&client_secret=' + ORG_CLIENT_SECRET + '&username=' + ORG_USER_NAME + '&password=' + ORG_PASSWORD + ORG_SECURITY_TOKEN);
        req.setMethod('POST');
        res= h.send(req);
        mybodyprint = res.getBody();
        JSONparser parser = JSON.createParser(mybodyprint);
        OrgInfo obj;
        try{
            obj = (OrgInfo)parser.readValueAs(OrgInfo.class);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
            return;
        }
        accessToken =obj.access_token;
        instanceUrl = obj.instance_url;
        tokenType =  obj.token_type;
        query();
        checkEmail();
    }
    
    
    public void query(){
        Http h = new Http();
        String url = instanceUrl+'/services/data/v45.0/query?q=SELECT%20email%5F%5FC,%20Name%20FROM%20Site_User__c';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setHeader('Authorization',tokenType+' '+accessToken);
        req.setMethod('GET');
        HttpResponse res;
        try{
            res = h.send(req);
        }catch(Exception e){
            userList='';
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage() + e.getLineNumber()));
            return;
        }
        userList = res.getBody();
        system.debug(userList);
    }
    
    public void checkEmail(){
        list<string> name = new List<string>();
        //list<string> password = new List<String>();
        userList = userList.replaceAll('__', '_');
        JsonParser parser = Json.createParser(userList);
        JSON2Apex obj;
        try{
            obj = (JSON2Apex)parser.readValueAs(JSON2Apex.class);
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
            return;
        }
        for(integer i =0 ; i < obj.records.size();i++){
            name.add(obj.records[i].email_c);
        }
        
        status = 'Sorry! Your email is not present in our Database.';
        isLoggedIn = false;
        for(integer i = 0 ; i < name.size() ; i++){
            if(useremail==name[i]){
                status = 'Your Email is found in our Database.';
                isLoggedIn = true;
                
                initSiteUser(useremail);
                break;
            }
        }
    }
    
    @testvisible String namespacePrefix ;
    
    public Boolean isNameSpacePrefix(){
        ApexClass cs = [select NamespacePrefix from ApexClass where Name =:getClassName()];
        namespacePrefix = cs.NamespacePrefix;
        
        if(namespacePrefix != null){
            
            return true;
        }else{
            return false;
        }
    }
    
    @testVisible String getClassName(){        
        return String.valueOf(this).split(':')[0];
    }
    
    public void initSiteUser(String email){
        
        Site_User__c myuser = [SELECT Profile__C, name, first_Name__c, last_Name__C, email__C FROM Site_User__c WHERE email__C = :email];
        UserInfo__C u = new UserInfo__c();
        u.Name = email;
        u.email_id__c = email;
        u.isLogged_in__C = true;
        u.Profile__c =  myUser.profile__c;
        UserInfo__C ui = UserInfo__c.getInstance(email);
        try{
            
            if(ui!=null)
                update ui;
            else{
                insert u;
            }
            
        }catch(Exception e){
            Apexpages.addMessage(new ApexPages.message(apexpages.Severity.ERROR, 'Somthing wrong in fetching user Information from custom setting'));
        }
    }
    
    public void passUserId(String email){
        try{
            user= database.query('SELECT id, first_Name__C, last_Name__c, Email__c, name FROM Site_User__c Where email__c = :email limit 1');
            uid = user.id;
            userinfo();
            UserInfo.userName= user.First_Name__C + '  ' + user.last_Name__C;
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'UserId not found!!!' + e.getMessage()));
        }
        
    }
    
    public void userinfo(){
        UserInfo = new UserInformation();
        UserInfo.isUserlogin = true;
    }
    
    public class JsonId {
        public string access_token;
        
    }
    
    public class GoogleInfo{
        public string email;
        public String verified_email;
    }
    
    public class OrgInfo{
        public string access_token;
        public string instance_url;
        public string token_type;
    }
    
    public class UserInformation{
        public String userName{get; set;}
        public boolean isUserLogin  {get; set;}
        
    }
}