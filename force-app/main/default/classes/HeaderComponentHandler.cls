public class HeaderComponentHandler {
    public SiteSingleTonClass singleTonInstance {get; set;}
    public String profile {get; set;}
    public String activeTab {get;set;}
    public List<String> objList {get;set;}
    @testVisible String objName ;
    public String functionality {get;set;}
    public String searchText {get; set;}
   @testVisible private String uId;
    //public boolean isCreate {get; set;}
   // public boolean istable {get; set;}
    //public boolean isGlobalTable {get; set;}
    public MyUser__C user {get; set;}
   // public boolean isHome {get; set;}
    //public boolean isLoggedIn {get; set;}
    public String query {get; set;}
    public integer QUERY_lIMIT {get; set;}
    public list<String> fieldList {get; set;}
    public boolean isChatter {get; set;}
    
    ////fieldset
    @testVisible List<String> objApiName = new List<String>{'account', 'opportunity', 'contact', 'account'};
    @testVisible List<String> fieldSetName = new List<String>{'FS_Account', 'FS_Opportunity', 'FS_Contact', 'FS_Account_Site'};
                  
    public String getuid(){
    	return uid;
    }
    
    public void setuid(String u){
        if(uid == null){
            uid = u;
        }
    }
     public UserInfo__C customUser ;
    public HeaderComponentHandler(){
      	singleTonInstance = SiteSingleTonClass.getInstance();
        isChatter= false;
        activeTab = 'Home';
        
        id uId = apexpages.currentPage().getParameters().get('userId');
        try{
            user= database.query('SELECT id, first_Name__C, last_Name__c, name, Profile__C FROM MyUSer__C Where id = :uId limit 1');//isCreate, isTable, isGlobalTable, isTaskEvent, isHome
            if(user.profile__c != null)
                profile = user.profile__c;
            customUser= UserInfo__c.getInstance(user.Name);
            customUser.isHome__C= true;
            singleTonInstance.isHome= true;
        }catch(Exception e){
            user = new MyUser__C();
            customUser =new UserInfo__C();
        }
        objList = new List<String>{'account', 'opportunity', 'contact'};
            objName = ''; 
        functionality = '';
        initCustomSetting();
    }
    public String getObjName(){
        return objName;
    }
    public void setobjName(String o ){
        
        if(objName != o || objName == null){
            objName =o;
        }
        
    }
    public PageReference create_ViewRecord(){
        customUser.isHome__C= false;
        customUser.isCreate__c = false;
        customUser.isGlobalTable__C = false;
       // update customUser;
        
        singleTonInstance.iscreate = false;
        singleTonInstance.isChatter = false;
        singleTonInstance.isHome= false;
        singleTonInstance.isGlobalTable=  false;
        if(this.Functionality=='CR'){
            
            singleTonInstance.isHome= true;
            singleTonInstance.isTable= false;
            singleTonInstance.isCreate = true;
            //update customUser;
            
        }
        if(this.Functionality=='VE'){
            singleTonInstance.isTable= true;
            singleTonInstance.isCreate = false;
           // update customUser;
            
            
            //iscreate= customUser.isCreate__c;
           // isTable =   customUser.isTable__C;
            fieldList = new list<String>();
            fieldList= getFieldsFromFieldSet(objApiName.indexOf(objName));
            QUERY_lIMIT = 100;
            getQuery();
        }
        
        PageReference pgr = apexpages.currentPage();
        pgr.getParameters().put('userId',this.user.id);
   
        
        return null;
        
    }
    public void getQuery(){
        query = 'SELECT ' + String.join(fieldList, ', ') + ' FROM ' + objName;
    }
    public Pagereference home(){
         customUser.isHome__c = true;
        //update customUser;
        singleTonInstance.isHome = true;
        
        PageReference pgr = new PageReference('/apex/HeaderMainPage');
        pgr= pgr.setRedirect(true);
        
        return pgr;
        
    }
    public Pagereference chatter(){
        singleTonInstance.iscreate=false;
        singleTonInstance.isTable = false;
        singleTonInstance.isHome= false;
        singleTonInstance.isGlobalTable= false;
        singleTonInstance.isChatter = true;
        return null;
    }
    
    public Pagereference logout(){
        UserInfo__C u;
       // System.debug(u);
        try{
            u= UserInfo__C.getInstance(user.name);
            u.islogged_In__c = false;
            delete u;
        }catch(Exception e){
            apexpages.addMessage(new ApexPages.message(apexpages.Severity.ERROR, 'Somthing is Wrong for updating user information'));
        }
        PageReference pgr = new PageReference('/apex/siteHomePage');
        return pgr;
    }
    public PageReference getSearchResult(){
      
        Pagereference p = Apexpages.currentPage();
        
        customUser.isHome__c = false;
        customUser.isCreate__c = false;
        customUser.isGlobalTable__c = true;
        customUser.isTable__c =false;
        //update customUser;
        Pagereference pgr = ApexPages.currentPage();
        pgr.setRedirect(true);
        singleTonInstance.isHome = false;
        singleTonInstance.isCreate = false;
        singleTonInstance.isChatter = false;
        singleTonInstance.isGlobalTable= true;
        singleTonInstance.isTable=false;
        return null;
    }
    
    public void initCustomSetting(){
        try{
           
            system.debug(user.name);
            system.debug(user.id);
            if(user.id!=null){
                UserInfo__C u =  UserInfo__C.getInstance(user.name);
                singleTonInstance.isLoggedIn = u.islogged_In__c;
            }else
                singleTonInstance.isLoggedIn = false;
        }catch(Exception e){
            apexpages.addMessage(new ApexPages.message(apexpages.Severity.ERROR, 'user not found!! '+e.getMessage()));
        }
    }
    public PageReference backToLoginPage(){
        pagereference pgr = new Pagereference('/apex/siteHomePage');
        return pgr;
    }
    //field set
    @testVisible List<String> getFieldsFromFieldSet(Integer index){
        List<String> sfld = new List<String>();
        try{
            if(Schema.getGlobalDescribe().get(objApiName[index].toLowerCase()).getDescribe().FieldSets.getMap() == null || !Schema.getGlobalDescribe().get(objApiName[index].toLowerCase()).getDescribe().FieldSets.getMap().containsKey(fieldSetName[index].toLowerCase())){
                return sfld;
            }
            for(Schema.FieldSetMember f : Schema.getGlobalDescribe().get(objApiName[index].toLowerCase()).getDescribe().FieldSets.getMap().get(fieldSetName[index].toLowerCase()).getFields())
                sfld.add(f.getFieldPath().toLowerCase());
            
        }catch(Exception e){
            
        }
        return sfld;
    }
    
    
    
    
    
    
}