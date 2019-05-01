public class HeaderPageController {
    
    @testvisible static String namespacePrefix ;   
    public String profile {get; set;}
    public String activeTab {get;set;}
    public List<String> objList {get;set;}
    public List<String> moreObjList {get;set;}
    @testVisible String objName ;
    public String functionality {get;set;}
    public String searchText {get; set;}
    private String uId;
    public Site_User__c user {get; set;}
    public boolean isCreate {get; set;}
    public boolean istable {get; set;}
    public boolean isGlobalTable {get; set;}
    public boolean isHome {get; set;}
    public boolean isChatter {get; set;}
    public boolean isLoggedIn {get; set;}
    public String query {get; set;}
    public integer QUERY_lIMIT {get; set;}
    public list<String> fieldList {get; set;}
    
    
    ////fieldset
    @testVisible List<String> objApiName = new List<String>{'account', 'opportunity', 'contact', 'account', 'case', 'idt_products__c', 'task__c', 'event__c'}; // Give object Name In LowerCase
        @testVisible List<String> fieldSetName = new List<String>{'FS_Account', 'FS_Opportunity', 'FS_Contact', 'FS_Account_Site', 'FS_Case', 'FS_IDT_PRODUCT', 'FS_TASK', 'FS_EVENT'}; // Give Field set name here
            
            public String getuid(){
                return uid;
            }
    
    public void setuid(String u){
        if(uid == null){
            uid = u;
        }
    }
    
    public UserInfo__C customUser ;
    
    public static Boolean isNameSpacePrefix( HeaderPageController hpc){
        
        ApexClass cs = [select NamespacePrefix from ApexClass where Name =:getClassName(hpc)];
        
        namespacePrefix = cs.NamespacePrefix;
        
        if(namespacePrefix != null){
            return true;
        }else{
            return false;
        }
    }
    
    @testVisible static String getClassName(HeaderPageController hpc){
        
        if(hpc != null){
            return String.valueOf(hpc).split(':')[0];
        }else{
            return String.valueOf(new HeaderPageController()).split(':')[0];
        }
    }
    
    public HeaderPageController(){
        
        isChatter= false;
        activeTab = 'Home';
        
        id uId = apexpages.currentPage().getParameters().get('userid');
        try{
            user= database.query('SELECT id, first_Name__C, last_Name__c, name, Email__C, Profile__C FROM Site_User__c Where id = :uId limit 1'); //isCreate, isTable, isGlobalTable, isTaskEvent, isHome
            if(user.profile__c != null)
                profile = user.profile__c;
            customUser= UserInfo__c.getInstance(user.Email__C);
            customUser.isHome__C= true;
            isHome= customUser.isHome__C;
        }catch(Exception e){
            user = new Site_User__c();
            customUser =new UserInfo__C();
        }
        
        //objList = new List<String>{'account', 'contact', 'case', 'opportunity','idt_products__c', 'task__c', 'event__c'};
        prepareObjectList();
        objName = ''; 
        functionality = '';
        isLoggedIn = true;
        iscreate = false;
        isTable= false;
        isGlobalTable= false;
        isHome =true;
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
    public void prepareObjectList(){
        List<SObject> objectList ;
        objList = new List<String>();
        moreObjList = new List<String>();
        try{
            objectList = Database.query('SELECT Name, developer_Name__c, fields_Developer_Name__c FROM Object__c WHERE view__c = \'All Records View\' ORDER BY Position__c');
           if(objectList.size() ==0 || objectList == null){
               Apexpages.addMessage(new apexpages.message(apexpages.Severity.WARNING, 'Object list is not found from Admin panel. Please contact your Administrator'));
               return;
           }
           integer count = 1;
            for(Sobject s : objectList){
                String str = (String)s.get('Developer_Name__c');
               str=  str.toLowerCase();
               if(count <= 5)
                    objList.add(str);
                else {
                    moreObjList.add(str);
                }
                count++;
            }
        }catch(Exception e){
            System.debug(e.getMessage());
            Apexpages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, e.getMessage()));
        }
    }
    public List<RTInfo> recTypeInfoLst {get;set;}
    public void initRecTypeInfoLst(){
        List<Schema.RecordTypeInfo> rtiLst = Schema.getGlobalDescribe().get(objName).getDescribe().getRecordTypeInfos();
        recTypeInfoLst = new List<RTInfo>();
        
        for (RecordTypeInfo rti : rtiLst) {
            RTInfo rtInf = new RTInfo();
            rtInf.name = rti.getName();
            rtInf.devName = rti.getDeveloperName();
            rtInf.id = rti.getRecordTypeId();
            rtInf.isActive = rti.isActive();
            rtInf.isDefault = rti.isDefaultRecordTypeMapping();
            rtInf.isMaster = rti.isMaster();
            if (rtInf.isActive) {
                recTypeInfoLst.add(rtInf);
            }
            
        }
    }
    
    public class RTInfo{
        public String name {get;set;}
        public String devName {get;set;}
        public String id {get;set;}
        public Boolean isActive {get;set;}
        public Boolean isDefault {get;set;}
        public Boolean isMaster {get;set;}
    }
    public List<LayoutDescriberHelper.LayoutSection> layoutSections ; 
    
    public PageReference create_ViewRecord(){

        customUser.isHome__C= false;
        customUser.isCreate__c = false;
        customUser.isGlobalTable__C = false;
        
        iscreate = customUser.isCreate__c;
        isChatter = false;
        isHome= customUser.isHome__C;
        isGlobalTable=  customUser.isGlobalTable__C;

        if(this.Functionality=='CR'){
            
            initRecTypeInfoLst();
            if (recTypeInfoLst.size() == 1) {
                layoutSections = LayoutDescriberHelper.describeSectionWithFields(recTypeInfoLst[0].id, objName, profile);
                System.debug('layoutSections'+layoutSections);
                Cache.Org.put('local.SitePartition.layoutsections' , layoutSections);
            }
            customUser.isHome__C= true;
            customUser.isTable__C= false;
            customUser.isCreate__c = true;
            
            isHome= customUser.isHome__C;
            isTable=customUser.isTable__C;
            iscreate = customUser.isCreate__c;
        }
        if(this.Functionality=='VE'){
            customUser.isTable__C= true;
            customUser.isCreate__c = false;
            
            iscreate= customUser.isCreate__c;
            isTable =   customUser.isTable__C;
            fieldList = new list<String>();
            fieldList= getFieldsFromFieldSet(objName);
            QUERY_lIMIT = 100;
            getQuery();
            
        }
        
        PageReference pgr = apexpages.currentPage();
        pgr.getParameters().put('userId',this.user.id);
        customUser.isTask__c = false;
        update customUser;
        
        return null;
        
    }
    
    public void getQuery(){
        query = 'SELECT ' + String.join(fieldList, ', ') + ' FROM ' + objName;
    }
    
    public Pagereference home(){
        isHome = true;
        
        PageReference pgr = new PageReference('/apex/HeaderPage');
        
        pgr= pgr.setRedirect(true);
        pgr.getParameters().put('UserId', this.user.id);
        return pgr;
    }
    
    public Pagereference chatter(){
        iscreate=false;
        isTable = false;
        isHome= true;
        isGlobalTable= false;
        isChatter = true;
        return null;
    }
    
    public Pagereference logout(){
        System.debug('email'+user.Email__C);
        UserInfo__C u =  UserInfo__C.getInstance(user.Email__C);
        System.debug('u'+u);
        u.islogged_In__c = false;
        isLoggedIn= false;
        try{
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
        update customUser;
        Pagereference pgr = ApexPages.currentPage();
        pgr.setRedirect(true);
        isHome = customUser.isHome__c;
        isCreate = customUser.isCreate__c;
        isChatter = false;
        isGlobalTable= customUser.isGlobalTable__c;
        isTable=customUser.isTable__c;
        return null;
    }
    
    public void initCustomSetting(){
        try{
            if(user.id!=null){
                UserInfo__C u =  UserInfo__C.getInstance(user.email__c);
                isLoggedIn = u.islogged_In__c;
            }else{
                isLoggedIn = false;
            }
        }catch(Exception e){
            Apexpages.addMessage(new ApexPages.message(apexpages.Severity.ERROR, 'User not found!! ' + e.getMessage()));
        }
    }
    
    public PageReference backToLoginPage(){
        pagereference pgr = new Pagereference('/apex/siteHomePage');
        return pgr;
    }
    
    @testVisible List<String> getFieldsFromFieldSet(String objecDeveloperName){
        List<String> sfld = new List<String>();
         Sobject  objectName = Database.query('SELECT Name, developer_Name__c, fields_Developer_Name__c FROM Object__c WHERE view__c = \'All Records View\' AND  developer_name__c = : objecDeveloperName  LIMIT 1');
           String fieldStr = (String)objectName.get('fields_Developer_Name__c');
           fieldStr = fieldStr.toLowerCase();
           sfld = fieldStr.split('; ');
        // try{
        //     if(Schema.getGlobalDescribe().get(objApiName[index].toLowerCase()).getDescribe().FieldSets.getMap() == null || !Schema.getGlobalDescribe().get(objApiName[index].toLowerCase()).getDescribe().FieldSets.getMap().containsKey(fieldSetName[index].toLowerCase())){
                
        //         return sfld;
        //     }
        //     for(Schema.FieldSetMember f : Schema.getGlobalDescribe().get(objApiName[index].toLowerCase()).getDescribe().FieldSets.getMap().get(fieldSetName[index].toLowerCase()).getFields())
        //         sfld.add(f.getFieldPath().toLowerCase());
            
        // }catch(Exception e){
            
        // }
        return sfld;
    }
    
}