public class ChatterComponentController {
    public string postBody { get; set;}
    public string userID1 { get; set;}
    Public String OAUTH_TOKEN_URL ;
    public String bodyprint {get; set;}
    public String userId ;
    public String password;
    public String accessToken ;
    public ChatterJson obj {get; set;}
    
    
    
    public String userImgUrl {get; set;}
    public String userName {get; set;}
    public List<PostedMessage> pstedMessageObject {get; set;}
    
    public ChatterComponentController(){
        userId = 'smith@pritamsfdc.com';
        password = 'bodacious.com1';
        String s1 = 'https://login.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9dZJodJWITStIS6tSI5SP_TRXImUbc64Vw.qvbfjkTGsYkCQ_5RThPKKCbGWdV7nZ1GUH_OqqDx4QzNQW&';
        String s2 = 'client_secret=6046675481206057014&username=sales@alienbrainz.com.sf&password=Qwertyuiop@%23%2412345ti0tK8HnvzNbC2kIf2km9RgPk';
        OAUTH_TOKEN_URL = s1 + s2;
        http h = new http();
        HttpRequest req = new HttpRequest();
            req.setEndpoint(OAUTH_TOKEN_URL);
           
            req.setMethod('POST');
             HttpResponse res ;
        try{
           res = h.send(req);
            bodyprint=res.getbody();
           getData();
          
        }catch(Exception e){
            Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
            res = new HttpResponse();
        }
            
           
    }
    public void getData(){
        http h = new http();
        HttpRequest req = new HttpRequest();
         req.setMethod('GET');
            JSONParser parser = JSON.createParser(bodyprint);
            ChatterComponentController.JsonId obj;
            obj = (ChatterComponentController.JsonId)parser.readValueAs( ChatterComponentController.JsonId.class);
           accessToken = obj.access_token;
            req.setHeader('Authorization','Bearer '+obj.access_token);
           // body = obj.access_token;
            String instanceUrl = 'https://na57.salesforce.com';
            OAUTH_TOKEN_URL = instanceUrl + '/services/data/v45.0/chatter/feeds/news/me/feed-elements';
            OAUTH_TOKEN_URL = instanceUrl + '/services/data/v45.0/chatter/feeds/record/0050b000005QDp9/feed-elements';
            req.setEndpoint(OAUTH_TOKEN_URL);
            HttpResponse res ;
           res = h.send(req);
        bodyPrint = res.getBody();
        getAllCompany();
    }
   
    public void getAllCompany(){
        http h = new http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization','Bearer '+accessToken);
        req.setMethod('GET');
        String instanceUrl = 'https://na57.salesforce.com';
        OAUTH_TOKEN_URL = instanceUrl + '/services/data/v45.0/chatter/feeds/company/feed-elements';
        req.setEndpoint(OAUTH_TOKEN_URL);
        HttpResponse res ;
        res = h.send(req);
        bodyPrint = res.getBody();
        
        
        try{
          obj = ChatterJson.parse(bodyPrint);
           getUserData();
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
            return;
        }
      
    }
    
    public void getUserData(){
        pstedMessageObject = new  List<PostedMessage>();
        for(ChatterJson.elements ele : obj.elements){
            
            PostedMessage pstedMsg = new PostedMessage();
            pstedMsg.feedPostTime  = ele.relativeCreatedDate;
           // System.debug(ele.capabilities.comments.page.items);
            if(ele.body.text != null){
                pstedMsg.postedByUSer = ele.actor.name;
                pstedMsg.userImgUrl =  ele.actor.photo.largePhotoUrl;
               
                for(Chatterjson.MessageSegments msg : ele.body.messageSegments){
                    if(msg.text != null){
                        pstedMsg.messageLst.add(msg.text);
                    }
                }
                if(ele.actor.id.subString(0,15) == '0050b000005QDp9'){
                    userImgUrl =  ele.actor.photo.largePhotoUrl;
                    userName = ele.actor.name;
                }
                pstedMessageObject.add(pstedMsg);  
            }
        }
        
    }
    
    public void postFeed(){
        http h = new http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization','Bearer '+accessToken);
        req.setMethod('POST');
        String instanceUrl = 'https://na57.salesforce.com';
        System.debug(postbody);
       postbody = postbody.normalizeSpace().replaceAll(' ', '+');
        
        OAUTH_TOKEN_URL = instanceUrl + '/services/data/v45.0/chatter/feed-elements?feedElementType=FeedItem&subjectId=0D50b00005YFglpCAD&text=' + postbody;
        System.debug(OAUTH_TOKEN_URL);
        req.setEndpoint(OAUTH_TOKEN_URL);
        HttpResponse res ;
        
        
        
          // String salesforceHost = System.Url.getSalesforceBaseURL().toExternalForm();
        
        String url =  instanceUrl + '/services/data/v23.0/chatter/feeds/record/0050b000005QDp9AAG/feed-items';
                    
        req.setMethod('POST');
        req.setEndpoint(url);
        req.setHeader('Content-type', 'application/json');
        req.setHeader('Authorization', 'OAuth ' + accessToken);
                    
        req.setBody('{ "body" : { "messageSegments" : [ { "type": "text",  "text" : " automatic allocation" } ] } }');
       
        
        
        try{
            res = h.send(req);
            bodyPrint = res.getBody();
            
            
        }catch(Exception e){
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
        }
    }
    
     public class JsonId {
        public String access_token;
        public String instanceUrl;

    }
    public class PostedMessage{
        public String feedPostTime {get; set;}
        public String userImgUrl {get; set;}
        public String postedByUSer {get; set;}
        public List<String> messageLst {get;  set;}
        public PostedMessage(){
            postedByUSer = '';
            messageLst = new List<String>();
        }
        
    }
}