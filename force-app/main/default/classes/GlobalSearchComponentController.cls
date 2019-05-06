public class GlobalSearchComponentController {
    
    
    public List<SearchWraperClass> globalList {get; set;}
    public string searchQuery {get; set;}
    @testVisible string query ;
    public String objName {get;set;}
    public boolean isPagination {get; set;}
    public list<String> fieldList {get; set;}
    public string delRecordId {get; set;}
    @testVisible String profileName {get; set;}
    @testVisible String searchTerm;
    @testVisible List<String> objApiName ;//= new List<String>{'account', 'opportunity', 'contact'};
    @testVisible List<String> fieldSetName = new List<String>{'FS_Account', 'FS_Opportunity', 'FS_Contact'};         
    @testVisible Boolean isEditCalled;
    
    public void setQuery(string q){
        if(query == null || query != q)
            query =q;
    }
    
    public String getquery(){
        
        return query;
    }
    
    public void setProfilename(String pr){
        
        if(ProfileName == null){
            profileName = pr;
        }
    }
    
    public String getProfilename(){
        return profileName;
    }
    
    public Boolean openModal{get{
        Site_User__c user;
        UserInfo__c customUser;
        
        try{
            id uId = apexpages.currentPage().getParameters().get('userId');
            user= database.query('SELECT id, first_Name__C, last_Name__c, name, Profile__C, Email__C FROM Site_User__c Where id = :uId limit 1');//isCreate, isTable, isGlobalTable, isTaskEvent, isHome
            customUser= UserInfo__c.getInstance(user.Email__C);
            
            
        }catch(Exception e){
            user = new Site_User__c();
            customUser =new UserInfo__C();
            
        }
        return  false;
    } set;}
    
    public String rId {get;set;}          
    
    public GlobalSearchComponentController(){
        isCreate = true;
        objApiName = new list<String>();
        openModal = false;
        Site_User__c user;
        try{
            id uId = apexpages.currentPage().getParameters().get('userId');
            user= database.query('SELECT id, first_Name__C, last_Name__c, name, Profile__C, Email__C FROM Site_User__c Where id = :uId limit 1');//isCreate, isTable, isGlobalTable, isTaskEvent, isHome
            customUser= UserInfo__c.getInstance(user.Email__C);
            
            
        }catch(Exception e){
            user = new Site_User__c();
            customUser =new UserInfo__C();
            
        }
        customUser.isChatter__c = false;
        customUser.isCreate__c = false;
        customUser.isTable__C = false ;
        customUser.isGlobalTable__C = false ;
        customUser.isHome__c = false;
        customUser.isPagination__C = false;
        customUser.isTask__c = false ;
        globalList = new List<SearchWraperClass>();
    }
    
    public String getsearchTerm(){
        return searchTerm;
    }
    public Boolean isCreate {get; set;}
    public void setsearchTerm(String text){
        
        if(searchTerm!=text){
            customUser.isTable__c = false;
            searchTerm= text;
        }
        if(!customUser.isCreate__c){
            openModal = false;
            customUser.isCreate__C = false;
        }
        if(isshowMore != text){
            customUser.isTable__C = false;

        }

        prepareObjectList();
        if (objApiName == null || objApiName.size() == 0) {
            apexpages.addMessage(new Apexpages.message(Apexpages.Severity.ERROR, 'No object selected for search.'));
            return ;
        }
        globalList.clear();
        getSearchResult();
    }
    
    public void prepareObjectList(){
        List<SObject> objectList ;
        objApiName = new List<String>();
        Site_User__c user;
        try{
            objectList = Database.query('SELECT Name, developer_Name__c FROM Object__c WHERE view__c = \'Search Records View\' ORDER BY Position__c');
            for(Sobject s : objectList){
                String str = (String)s.get('Developer_Name__c');
               str=  str.toLowerCase();
                objApiName.add(str);
            }
            id uId = apexpages.currentPage().getParameters().get('userId');
            user= database.query('SELECT id, first_Name__C, last_Name__c, name, Profile__C, Email__C FROM Site_User__c Where id = :uId limit 1');//isCreate, isTable, isGlobalTable, isTaskEvent, isHome
            customUser= UserInfo__c.getInstance(user.Email__C);
           
        }catch(Exception e){
            System.debug(e.getMessage() + '  ' + e.getLineNumber());
            Apexpages.addMessage(new ApexPages.message(Apexpages.Severity.ERROR, e.getMessage()));
        }
    }
    public PageReference getSearchResult(){
        
        if(searchTerm.length() > 1){
            if(searchTerm.contains('\'') || searchTerm.contains('"') || searchTerm.contains('') || searchTerm.contains('!') || searchTerm.contains('`') ||  searchTerm.contains('\\')){
               searchTerm =  adjustSearchTerm(searchTerm);
            }

            String searchStr1 = '*'+searchTerm+'*';
            searchQuery = 'FIND \'' + searchStr1 + '\' IN ALL FIELDS RETURNING ';
            for(String s : objApiName){
                searchQuery += s + ' (' + String.join(getFields(s), ', ') + ' ), ';
            }
            searchQuery = searchQuery.substring(0, searchQuery.lastIndexOf(','));
            List<List <sObject>> searchList;
            try{
                searchList   = search.query(searchQuery);
            }catch(Exception e){
                searchList = new List<List <sObject>>();
                apexpages.addMessage(new ApexPages.message(apexpages.Severity.ERROR, 'exception occures in search query ' + e.getMessage()));
            }
            Boolean flag =  false;
            for(List<sobject> sobjlst : searchList){
                if(sobjLst.size() > 0){
                    flag =  true;
                    break ;
                }
            }
            if(!flag){
                apexPages.addmessage(new apexpages.message(apexpages.severity.WARNING, 'No matches found'));
                
            }else{
                Map<String, Schema.SObjectType> mp =  Schema.getGlobalDescribe();
                SearchWraperClass swrap ;
                for(List<sobject> sl : searchList){
                    integer recordSize = sl.size();
                    if(sl.size() > 3){
                        while(sl.size() > 3){
                            sl.remove(sl.size()-1);
                            
                        }
                    }
                    for(String obj: objApiName){
                        Schema.SObjectType objtype = mp.get(obj);
                        if(sl.getSobjectType() == objtype){  
                            swrap= new SearchWraperClass();
                            swrap.count = recordSize;
                            
                            swrap.wObjLst= castRecord(sl, objtype);
                            swrap.wObjName = obj;
                            
                            CheckPermissionOnObject permission = new CheckPermissionOnObject(obj, profileName,  getFields(obj), this);
                            permission.CheckPermission();
                            for(fieldName f : permission.permittedfieldList){
                                if(permission.accessibility1.fieldAccessibility.get(f.fieldNameWithoutNamespace).hasReadAccess)
                                    swrap.wFldLst.add(f.fieldNameWithoutNamespace);
                            }
                            globalList.add(swrap);
                            
                        }
                    }
                }
            }
        }
        else if(searchTerm==''){
            Pagereference pgr = new Pagereference('/apex/HeaderPage');
            return pgr;
        }else{
            apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Please enter at least two characters..'));
            
        }
        return null;
    }
    

    public String adjustSearchTerm(String text){
        
        
        String escapedText;
        
        if ( String.isBlank( text ) ) {
            
            escapedText = null;
            
        } else {
            
            // Escaping characters is a bit annoying because
            // we are having to plan for multiple levels of evaluation of the escaped characters:
            //  1. Apex   -- this code requires double slahes (\\) to equate to a single slash (\) in the string literal
            //  2. Regex  -- when the replaceAll method parses the input sequence the apex \\ is read as a single \, so have to double up again in Apex to get \\ in regex land
            //  3. SOSL   -- when Search.query() method parses the query string it expects valid apex string literal, so any \ must be escaped as \\
            
            // In addition to my below logic, you can check out some other solutions here:
            // http://salesforce.stackexchange.com/questions/64757/function-to-properly-escape-dynamic-sosl-input
            
            // escape single quotes
            // we do not handle the single quote escaping in the matcher.replaceAll method along with the other escaping because we would end up with incorrect number of slashes
            escapedText = String.escapeSingleQuotes( text ) ;
            
            // remove special logical operators from the term (case insensitive)
            // these are keywords for SOSL, can't escape them so we exclude them from the search term
            escapedText = escapedText.replaceAll( '(?i)( AND NOT | AND | OR )', ' ' );
            
            // escape reserved characters
            // note, we handled single quotes above already
            // note, we do not handle \, it ends up being overly escaped
            // ? & | ! { } [ ] ( ) ^ ~ * : \ " ' + -
            Pattern myPattern = Pattern.compile( '(\\?|\\&|\\||\\!|\\{|\\}|\\[|\\]|\\(|\\)|\\^|\\~|\\*|\\:|\\"|\\+|\\-)' );
            Matcher myMatcher = myPattern.matcher( escapedText );
            
            // remember all the notes above about the 7 circles of hell of escaping text for apex, regex, sosl??
            // so all that comes into play here when we now perform the escaping of the matched special characters
            // we need 8 slashes (\\\\\\\\)
            //      ...in apex that translates into a string literal of just 4 (\\\\)
            //      ...once the replaceAll method runs it parses the input as regex, and regex like apex needs slashes escaped so the 4 (\\\\) it received is interpreted as regex literal of 2 (\\)
            //      ...we return the apex literal string with each special character now prefixed with 2 slashes (\\)
            //      ...when Search.query() method parses the escaped string literal we return from here those 2 slashes (\\) get interpreted as 1 slash (\)
            escapedText = myMatcher.replaceAll( '\\\\\\\\$1' );
            
            // collapse repeated whitespace
            escapedText = escapedText.replaceAll( '( )+', ' ' ).trim();
            
        }
        if(escapedText == null){
            return '';
        }else{
            return escapedText;
        }
        
    }
    public List<sObject> castRecord(List<sObject> rec, Schema.SObjectType sObjType){
        
        List<sObject> castRecords = new List<Account>();
        
        if (sObjType != null)
        {
            String listType = 'List<' + sObjType + '>';
            castRecords = (List<SObject>)Type.forName(listType).newInstance();
            castRecords.addAll(rec);
        }
        
        return castRecords;
    }
    
    public list<string> getFields(String objecDeveloperName){
        list<String> searchLst = new List<String>();

        try {
             Sobject  objectName = Database.query('SELECT Name, developer_Name__c, fields_Developer_Name__c FROM Object__c WHERE view__c = \'Search Records View\' AND  developer_name__c = : objecDeveloperName  LIMIT 1');
           String fieldStr = (String)objectName.get('fields_Developer_Name__c');
           fieldStr = fieldStr.toLowerCase();
           searchLst = fieldStr.split('; ');
        } catch (Exception e) {
            System.debug('Exception in class: ' + String.valueOf(this).split(':')[0] + ' === Message: ' + e.getMessage() + ' === At Line: ' + e.getLineNumber());
            Apexpages.addMessage(new apexpages.message(apexpages.Severity.ERROR, e.getMessage()));
        }
        // integer index = objApiName.indexOf(selectedobj.toLowerCase());
        // searchLst = getFieldsFromFieldSet(index);
        return searchLst;
    }
    
    public String isShowMore ;
    
    public Pagereference showMore(){
        isShowMore = searchTerm;
        fieldList = getFields(objName.toLowerCase());
        query = 'FIND \'' + searchTerm + '\' IN ALL FIELDS RETURNING ';
        query +=  objName.toLowerCase()+ ' (' + String.join(fieldList, ', ') + ' ), ';
        customUser.isTable__C = true;
        update customUser;
        return null;
    }
    
    public String dummyObjName {get;set;}
    
    public void turnOffModal(){
        openModal = false;
    }
    
    public  userInfo__C customUser {get{
         try{
            Site_User__c user;
            if (user == null) {
                id uId = apexpages.currentPage().getParameters().get('userId');
                user= database.query('SELECT id, first_Name__C, last_Name__c, name, Profile__C, Email__C FROM Site_User__c Where id = :uId limit 1');
                System.debug(UserInfo__c.getInstance(user.Email__C).isCreate__C);
                return UserInfo__c.getInstance(user.Email__C);
            }else {
                return UserInfo__c.getInstance(user.Email__C);
            }
            
            
        }catch(Exception e){
            return new UserInfo__C();
            
        }
    } set;}

    public Id getRecordTypeIdFromRecordId(Id rid){
        List<Schema.RecordTypeInfo> rtiLst = Schema.getGlobalDescribe().get(dummyObjName).getDescribe().getRecordTypeInfos();
        if (rtiLst.size() == 1) {
            return rtiLst[0].getRecordTypeId();
        }else{
            String query = 'SELECT RecordTypeId FROM ' + dummyObjName + ' WHERE Id = :rid';
            return ((Id)Database.query(query)[0].get('RecordTypeId') != null)? (Id)Database.query(query)[0].get('RecordTypeId') : (Id)rtiLst[0].getRecordTypeId();
        }
    }

    public List<LayoutDescriberHelper.LayoutSection> layoutSections ;
    

    public PageReference editRecord(){ 
        Site_User__c user;
        id uId;
        try{
            uId = apexpages.currentPage().getParameters().get('UserId');
            user= database.query('SELECT id, first_Name__C, last_Name__c, name, Profile__C, Email__C FROM Site_User__c Where id = :uId limit 1');//isCreate, isTable, isGlobalTable, isTaskEvent, isHome
            customUser= UserInfo__c.getInstance(user.Email__C);
            customuser.isCreate__c = true;
          // layoutSections = LayoutDescriberHelper.describeSectionWithFields(getRecordTypeIdFromRecordId(delRecordId), dummyObjName, user.Profile__c);
            //layoutSections = getLayoutSectionsFromDatabase(getRecordTypeIdFromRecordId(delRecordId), user.Profile__c);
           // Cache.Org.put('local.SitePartition.layoutsections' , layoutSections);
            update customUser;
        }catch(Exception e){
            user = new Site_User__c();
            customUser =new UserInfo__C();
        }
        return null;
    }
    
 public List<LayoutDescriberHelper.LayoutSection> getLayoutSectionsFromDatabase(String recTypeId, String profile){

         List<LayoutDescriberHelper.LayoutSection> layoutSections1 = new List<LayoutDescriberHelper.LayoutSection>();
        
        try {
            Record_type__C rtType = [SELECT RecordTypeId__C, Name, isPermitted__c FROM Record_Type__c WHERE RecordTypeId__C = :recTypeId AND (Object__r.Name = :dummyObjName AND profile__r.Name = :profile)LIMIT 1];
            if(rtType != null && rtType.isPermitted__C == true){
                PageLayout__C pgLayout = [SELECT Name FROM PageLayout__C WHERE (Object__r.Name = :dummyObjName AND Profile__r.Name = : profile) AND Record_Type__r.Name = :rtType.Name LIMIT 1];
                String pgName = pgLayout.Name;
                List<Section__c> secLst = [SELECT Name, column__C, Fields_developer_Name__c FROM Section__c WHERE PageLayout__r.Name = :pgName AND ObjectName__C = : dummyObjName];
                for (Section__C sc : secLst) {
                    List<LayoutDescriberHelper.LayoutField> lFld = new List<LayoutDescriberHelper.LayoutField>();
                    LayoutDescriberHelper.LayoutSection lay  = new LayoutDescriberHelper.LayoutSection();
                    lay.name = sc.Name;
                    lay.columns = (Integer)sc.column__C;
                    for(String s : sc.Fields_Developer_Name__c.split('; ')){
 
                        LayoutDescriberHelper.LayoutField fl = new LayoutDescriberHelper.LayoutField();
                        fl.ApiName = s;
                        lFld.add(fl);
                    }
                    lay.layoutFields = lFld;
                    layoutSections1.add(lay);
                    

                }
            }else {
                Apexpages.addMessage(new Apexpages.message(Apexpages.Severity.ERROR, 'You don\'t have a permission on Record Type. Please contact your Administrator'));
            }
        } catch (Exception e) {
                 Apexpages.addMessage(new Apexpages.message(Apexpages.Severity.ERROR, e.getMessage()));
        }
        return layoutSections1;
    }

    public PageReference deleteRecord(){
        
        openModal = false;
        
        String q = 'SELECT id FROM ' + dummyObjName + ' WHERE id = \'' + delRecordId + '\'';
        
        try{
            list<sobject> s= database.query(q);
            delete s;
            apexpages.addMessage(new ApexPages.message(apexpages.Severity.CONFIRM, 'Record Deleted Successfully'));
        }catch(Exception e){
            
            apexpages.addMessage(new ApexPages.message(apexpages.Severity.ERROR, e.getMessage()));   
        }
        
        return null;
    }
    
    @testVisible List<String> getFieldsFromFieldSet(Integer index){
        prepareObjectList();
        List<String> sfld = new List<String>();
        try{
            if(Schema.getGlobalDescribe().get(objApiName[index].toLowerCase()).getDescribe().FieldSets.getMap() == null || !Schema.getGlobalDescribe().get(objApiName[index].toLowerCase()).getDescribe().FieldSets.getMap().containsKey(fieldSetName[index].toLowerCase())){
                return sfld;
            }
            for(Schema.FieldSetMember f : Schema.getGlobalDescribe().get(objApiName[index].toLowerCase()).getDescribe().FieldSets.getMap().get(fieldSetName[index].toLowerCase()).getFields())
                sfld.add(f.getFieldPath().toLowerCase());
            
        }catch(Exception e){
            System.debug('Exception in class: ' + String.valueOf(this).split(':')[0] + ' === Message: ' + e.getMessage() + ' === At Line: ' + e.getLineNumber());
        }
        return sfld;
    }
    
    public class SearchWraperClass{
        public integer count {get; set;}
        public String wObjName {get; set;}
        public List<sobject> wObjlst {get; set;}
        public list<string> wFldlst {get; set;}
        
        public SearchWraperClass(){
            
            wObjlst = new List<sObject>();
            wFldlst = new List<string>();
        }
        
    }
    
    public PageReference showRelatedList(){
        PageReference pgr = new PageReference('/apex/HeaderPage');
        pgr.getParameters().put('recId', delRecordId);
        pgr.getParameters().put('objectName', dummyObjName);
        pgr.getParameters().put('UserId', apexpages.currentPage().getparameters().get('Userid'));
        pgr.setRedirect(true);
        customUser.parentrecid__c = delRecordId;
        customUser.parentObjName__c = dummyObjName;
        customUser.isRelated__c = true;
        customUser.isTable__c = false;
        customUser.isGlobaltable__c = false;
        try {
            layoutSections  = LayoutDescriberHelper.describeSectionWithFields(getRecordTypeIdFromRecordId(delRecordId), dummyObjName, profileName);
            Cache.Org.put('local.SitePartition.layoutsections' , layoutSections);
            update customUser;
        } catch (Exception e) {
            System.debug('Exception in class: ' + String.valueOf(this).split(':')[0] + ' === Message: ' + e.getMessage() + ' === At Line: ' + e.getLineNumber());
        }
        return pgr;
    }
    
    public Class CheckPermissionOnObject{
        private GlobalSearchComponentController outerInstance;
        public  Accessibility objAccessibiblity {get; set;}
        public Accessibility accessibility1 {get;set;}
        public Accessibility accessibility2 {get;set;}
        //public List<Account> permittedrecordList{get;set;}
        public String profileName {get; set;}
        public List<FieldName> permittedfieldList {get;set;}
        public String objectName {get;set;}
        @testVisible String objectNameWithNamespace;
        @testVisible String namespacePrefix;
        List<String> firstFldLst = new List<String>();
        
        public CheckPermissionOnObject(String objectName, String profileName, list<String> firstFldLst, GlobalSearchComponentController outerInstance){
            this.objectName = objectName;
            this.profileName = profileName;
            this.firstFldLst = firstFldLst;
            this.outerInstance = outerInstance;
        }
        public void CheckPermission(){
            objAccessibiblity =  new Accessibility();
            Boolean namespaceExists = initObjectAndNameSpacePrefix();
            if(namespaceExists){
                initFields();
                //initRecords();
                initaccessibility1();
                initaccessibility2();
            }else{
                initFieldsWithoutNameSpace();
                initaccessibility1WithoutNameSpace();
                
            }
            objAccessibiblity= accessibility1;
        }
        
        @testVisible void initaccessibility1(){
            accessibility1 = new Accessibility();
            accessibility1.Email = '';
            accessibility1.Profile = profileName;
            initObjectAccessibility(accessibility1);
            initFieldAccessibility(accessibility1, objectNameWithNamespace);
        }
        
        
        @testVisible void initaccessibility2(){
            accessibility2 = new Accessibility();
            accessibility2.Email = '';
            accessibility2.Profile = profileName;
            initObjectAccessibility(accessibility2);
            initFieldAccessibility(accessibility2, objectNameWithNamespace);
        }
        
        @testVisible void initObjectAccessibility(Accessibility accessibility){
            list<ObjectPermissions> objper = [SELECT Id,SObjectType, PermissionsRead, PermissionsEdit, PermissionsCreate, permissionsDelete 
                                              FROM ObjectPermissions 
                                              WHERE parentId IN ( SELECT id 
                                                                 FROM permissionset 
                                                                 WHERE PermissionSet.Profile.Name = :accessibility.Profile)]; 
            for(ObjectPermissions op : objper){
                Accessibility.ObjectAccess objaccess = new Accessibility.ObjectAccess();
                objaccess.hasReadAccess = op.PermissionsRead;
                objaccess.hasEditAccess = op.PermissionsEdit;
                objaccess.hasCreateAccess = op.PermissionsCreate;
                objaccess.hasdeleteAccess = op.permissionsDelete;
                accessibility.objectAccessibility.put((string)op.SObjectType.toLowerCase(), objaccess);
            }
        }
        
        @testVisible void initFieldAccessibility(Accessibility accessibility, String objectNameWithNamespace){
            list<FieldPermissions> fldper =  [SELECT Id,Field, PermissionsRead, PermissionsEdit 
                                              FROM FieldPermissions 
                                              WHERE parentId IN (SELECT id 
                                                                 FROM permissionset 
                                                                 WHERE PermissionSet.Profile.Name = :accessibility.Profile)
                                              AND sObjectType = :objectNameWithNamespace]; 
            for(FieldPermissions fp:fldper){
                Accessibility.FieldAccess fldaccess=new Accessibility.FieldAccess();
                fldaccess.hasReadAccess = fp.PermissionsRead;
                fldaccess.hasEditAccess = fp.PermissionsEdit;
                accessibility.Fieldaccessibility.put(fp.Field, fldaccess);
            }
            adjustFieldAccessibilityMap(accessibility.Fieldaccessibility);
        }
        
        @testVisible void initFields (){
            permittedfieldList = new List<FieldName>();
            
            String s = objectNameWithNamespace + '.' + namespacePrefix + '__';
            for(String fld: firstFldLst){
                FieldName fn = new FieldName(fld.toLowerCase(), s.toLowerCase() + fld.toLowerCase());
                permittedfieldList.add(fn);
                
                
            }
        }
        
        
        @testVisible void adjustFieldAccessibilityMap(Map<String, Accessibility.FieldAccess> fieldAccessMap){
            for(FieldName fld: permittedfieldList){
                Accessibility.FieldAccess fldaccess=new Accessibility.FieldAccess();
                
                if(!fieldAccessMap.containsKey(fld.fieldNameWithNamespace) && !getRequiredFields().contains(fld.fieldNameWithoutNamespace)){
                    fldaccess.hasReadAccess = false;
                    fldaccess.hasEditAccess = false;
                    fieldAccessMap.put(fld.fieldNameWithNamespace, fldaccess);
                    
                }else{  
                    fldaccess.hasReadAccess = true; // Undefined???????????????
                    fldaccess.hasEditAccess = true; // Undefined???????????????
                    fieldAccessMap.put(fld.fieldNameWithNamespace, fldaccess);
                }
            }
        }
        
        public Boolean initObjectAndNameSpacePrefix(){
            
            ApexClass cs = [select NamespacePrefix from ApexClass where Name =:getClassName()];
            namespacePrefix = cs.NamespacePrefix;
            
            if(namespacePrefix != null){
                objectNameWithNamespace = namespacePrefix + '__' + objectName;
                return true;
            }else{
                return false;
            }
        }
        
        @testVisible String getClassName(){
            
            return String.valueOf(outerInstance).split(':')[0];
        }
        
        @testVisible List<String> getRequiredFields(){
            List<String> reqfields = new List<String>();
            for(String fld: Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getmap().keyset()){
                
                if(isRequired(objectName, fld)){
                    reqfields.add(fld);
                }
            }
            return reqfields;
        }
        
        public Boolean isRequired(String obj, String fld){
            return !Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().get(fld).getDescribe().isNillable();
        }    
        
        @testVisible void initaccessibility1WithoutNameSpace(){
            accessibility1 = new Accessibility();
            accessibility1.Email = '';
            accessibility1.Profile = profileName;
            initObjectAccessibility(accessibility1);
            initFieldAccessibilityWithoutNameSpace(accessibility1, objectName);
        }
        
        @testVisible void initFieldAccessibilityWithoutNameSpace(Accessibility accessibility, String objectName){
            list<FieldPermissions> fldper =  [SELECT Id,Field, PermissionsRead, PermissionsEdit, sobjectType, ParentId 
                                              FROM FieldPermissions 
                                              WHERE parentId IN (SELECT id 
                                                                 FROM permissionset 
                                                                 WHERE PermissionSet.Profile.Name = :accessibility.Profile)
                                              AND sObjectType = :objectName]; 
            for(FieldPermissions fp:fldper){
                
                Accessibility.FieldAccess fldaccess=new Accessibility.FieldAccess();
                fldaccess.hasReadAccess = fp.PermissionsRead;
                fldaccess.hasEditAccess = fp.PermissionsEdit;
                accessibility.Fieldaccessibility.put(fp.Field.toLowerCase() , fldaccess);
            }
            adjustFieldAccessibilityMapwithoutNameSpace(accessibility.Fieldaccessibility);
        }
        
        @testVisible void initFieldsWithoutNameSpace (){
            permittedfieldList = new List<FieldName>();  
            
            String s = objectName + '.';
            for(String fld: firstFldLst){
                FieldName fn = new FieldName(fld.toLowerCase(), s.toLowerCase() + fld.toLowerCase());
                permittedfieldList.add(fn);
                
            }
        }
        
        @testVisible void adjustFieldAccessibilityMapwithoutNameSpace(Map<String, Accessibility.FieldAccess> fieldAccessMap){
            
            List<String> reqFld = getRequiredFields();
            for(FieldName fld: permittedfieldList){
                Accessibility.FieldAccess fldaccess=new Accessibility.FieldAccess();
                if( !reqFld.contains(fld.fieldNameWithoutNamespace.toLowerCase())){
                    string f = getParentObjectField(fld.fieldNameWithNamespace).toLowerCase();
                    if(!fieldAccessMap.containsKey(f)){
                        fldaccess.hasReadAccess = false;
                        fldaccess.hasEditAccess = false;
                        fieldAccessMap.put(fld.fieldNameWithoutNamespace, fldaccess);
                    }else{
                        fldaccess.hasReadAccess = fieldAccessMap.get(f).hasReadAccess; // Undefined???????????????
                        fldaccess.hasEditAccess = fieldAccessMap.get(f).hasEditAccess;// Undefined???????????????
                        fieldAccessMap.put(fld.fieldNameWithoutNamespace, fldaccess);
                    }
                    if((fld.fieldNameWithoutNamespace.toLowerCase().toLowerCase() == 'name')){
                        fldaccess.hasReadAccess = true; // Undefined???????????????
                        fldaccess.hasEditAccess = true; // Undefined???????????????
                        fieldAccessMap.put(fld.fieldNameWithoutNamespace, fldaccess);
                    }
                }else{
                    fldaccess.hasReadAccess = true; // Undefined???????????????
                    fldaccess.hasEditAccess = true; // Undefined???????????????
                    fieldAccessMap.put(fld.fieldNameWithoutNamespace, fldaccess);
                }
                
            }
        }
        
        public String getParentObjectField(String fld){
            String newFld = fld;
            Map<String, sobjectType> sp = Schema.getGlobalDescribe();
            if(fld.containsIgnoreCase(sp.get(objectName).getDescribe().getName())){
                fld = fld.substring(sp.get(objectName).getDescribe().getName().length() + 1);
            }
            Schema.DescribeFieldResult f = sp.get(objectName).getDescribe().fields.getMap().get(fld).getDescribe();
            if(f.getRelationshipName() != null){
                for(Schema.SObjectType reference : f.getReferenceTo()) {
                    
                    
                    schema.DescribeSObjectResult sdescribe = reference.getDescribe();
                    List<Schema.ChildRelationship> childdesc = sdescribe.getChildRelationships();
                    for(Schema.ChildRelationship referen : childdesc) {
                        if(referen.getChildSobject().getDescribe().getName().toLowerCase() == objectName.toLowerCase())
                            fld = objectName + '.' + referen.getField().getDescribe().getName();
                    }
                }
            }else{
                fld = newFld;
            }
            return fld;
            
        }
        
        
        public String getReferenceFieldApiName(String parentObjName, String childobjName){
            String fldApiName = '';
            map<string, schema.SObjectType> mp = schema.getGlobalDescribe();
            schema.DescribeSObjectResult sdescribe = mp.get(parentObjName.toLowerCase()).getDescribe();
            List<Schema.ChildRelationship> childdesc = sdescribe.getChildRelationships();
            for(Schema.ChildRelationship reference : childdesc) {
                if(reference.getChildSobject().getDescribe().getName() == childobjName)
                    fldApiName = reference.getField().getDescribe().getName();
            }
            return fldApiName;
        }
        
        
    }
    
    public class FieldName{
        public String fieldNameWithoutNamespace {get;set;}
        public String fieldNameWithNamespace {get;set;}
        public List<String> taskReferencedFld {get; set;}
        public string fldStr {get; set;}
        public FieldName(String fieldNameWithoutNamespace, String fieldNameWithNamespace){
            taskReferencedFld = new List<String>();
            this.fieldNameWithoutNamespace = fieldNameWithoutNamespace; 
            this.fieldNameWithNamespace = fieldNameWithNamespace;
        }
    }
    
}