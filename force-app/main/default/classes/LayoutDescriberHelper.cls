public class LayoutDescriberHelper {
    
    public static string urlPrefixToUse {get;set;}
    public static String profileName ;
    public Static String objName ;
    public Static List<String> reqFld ;
    
    public static List<LayoutSection> describeSectionWithFields(Id recordTypeId, string objectType, String profile){
        profileName = profile;
        objName = objectType;
        List<LayoutSection> layoutSections;
        Map<string,List<LayoutField>> layoutFields;
        layoutSections = new List<LayoutSection>();
        TaskRelatedListClass s =  new TaskRelatedListClass();
        String accessToken = s.accessToken;
        string theRespBody;
        
        if (accessToken == null || accessToken == '') {
            GoogleAndConnectedAppCredentials__c credentials = GoogleAndConnectedAppCredentials__c.getInstance('Credential1');
            String grantType = 'password';
            String client_Id = credentials.OrgClientId__c;
            String client_secret = credentials.OrgClientSecret__c;
            String userName = credentials.OrgUserName__c;
            String password = credentials.OrgPassword__c;
            String securityToken = credentials.OrgSecurityToken__c;
            String instanceUrl = 'https://login.salesforce.com';
            String endPointUrl = instanceUrl + '/services/oauth2/token?grant_type=' + grantType + '&client_id=' + client_Id + '&client_secret=' + client_secret + '&username=' + userName + '&password=' + password + securityToken;
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(endPointUrl);
            HttpResponse res = h.send(req);
            String body = res.getBody();
            accessToken = String.valueOf(((Map<String, Object>)JSON.deserializeUntyped(body)).get('access_token'));
            theRespBody = GetLayoutSchema(recordTypeId, objectType, accessToken);
        }else{
            theRespBody = GetLayoutSchema(recordTypeId, objectType, accessToken);
        }
        
        Map<String, Object> m;
        
        try {
            m = (Map<String, Object>) JSON.deserializeUntyped(theRespBody);
            CheckPermission();
            reqFld = getRequiredFields();
        } catch (Exception e) {
            if (theRespBody.containsIgnoreCase('INVALID_SESSION_ID') ) {
                GoogleAndConnectedAppCredentials__c credentials = GoogleAndConnectedAppCredentials__c.getInstance('Credential1');
                String grantType = 'password';
                String client_Id = credentials.OrgClientId__c;
                String client_secret = credentials.OrgClientSecret__c;
                String userName = credentials.OrgUserName__c;
                String password = credentials.OrgPassword__c;
                String securityToken = credentials.OrgSecurityToken__c;
                String instanceUrl = 'https://login.salesforce.com';
                String endPointUrl = instanceUrl + '/services/oauth2/token?grant_type=' + grantType + '&client_id=' + client_Id + '&client_secret=' + client_secret + '&username=' + userName + '&password=' + password + securityToken;
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setMethod('POST');
                req.setEndpoint(endPointUrl);
                HttpResponse res = h.send(req);
                String body = res.getBody();
                accessToken = String.valueOf(((Map<String, Object>)JSON.deserializeUntyped(body)).get('access_token'));
                theRespBody = GetLayoutSchema(recordTypeId, objectType, accessToken);
                m = (Map<String, Object>) JSON.deserializeUntyped(theRespBody);
                
            }
        }
        
        if(m.containsKey('editLayoutSections'))
        {
            List<object > targetLayout = (List<object>) m.get('editLayoutSections');
            
            for(object sectionObject: targetLayout){
                Map<String,object> section = (Map<String,object>) sectionObject;
                string sectionH = (string)section.get('heading');
                boolean useH = (boolean)section.get('useHeading');
                integer columns = (integer)section.get('columns');
                boolean useCollapse = (boolean)section.get('useCollapsibleSection');
                
                LayoutSection ls = new LayoutSection();
                ls.Name = sectionH;// == 'Stage 0+' || useH == false ? '' : sectionH;
                ls.useHeader = useH;
                ls.columns = columns;
                ls.allowCollapse = useCollapse;
                ls.layoutFields = new List<LayoutField>();  
                ls.accessibilityInstance = accessibility1;              
                layoutSections.add(ls);
                
                
                List<object> layoutRows = (List<object>)  section.get('layoutRows');
                
                for(Object itemObject : layoutRows ){
                    Map<String,object> item = (Map<String,object>) itemObject;
                    List<object> layoutItem = (List<object>)item.get('layoutItems');
                    
                    boolean priorFieldLayoutAdded = true;//initially true
                    
                    for(object fieldItemObject : layoutItem){
                        Map<string, object> fields = (Map<string,object>) fieldItemObject;
                        List<object> layoutComponents = (List<object>) fields.get('layoutComponents');
                        string apiName = '';
                        string fieldType = '';
                        for(Object layoutComponent: layoutComponents){
                            Map<string, object> componentMap = (Map<string,object>)layoutComponent;
                            if(componentMap.containsKey('value')){
                                apiName = (string) componentMap.get('value');
                            }
                            
                            if(componentMap.containsKey('type')){
                                fieldType = (string) componentMap.get('type');
                            }
                            
                        }
                        boolean placeholderF = (boolean) fields.get('placeholder'); 
                        boolean isEditable = (boolean) fields.get('editable');
                        if( (apiName != '' && fieldType =='Field') || (   placeholderF)){
                            
                            LayoutField lf = new LayoutField();
                            lf.required      = (Boolean)fields.get('required');
                            lf.isPlaceHolder = placeholderF;
                            lf.editableField = isEditable;
                            lf.ApiName = apiName;
                            Map<String, Accessibility.FieldAccess> fldAccess = adjustFieldAccessibilityMapwithoutNameSpace(new FieldName(objName.toLowerCase() + '.' + apiname.toLowerCase(), objName.toLowerCase() + '.' + apiName.toLowerCase()));
                            
                            if(ls.Name != '' || layoutSections.size() == 1) {
                                //if(fldAccess.get(objName.toLowerCase() + '.' + apiName.toLowerCase()).hasReadAccess){
                                    ls.layoutFields.add(lf);
                                //}
                            }                               
                            else if(layoutSections.size() - 2 >= 0)
                                //if(fldAccess.get(objName.toLowerCase() + '.' + apiName.toLowerCase()).hasReadAccess){
                                    layoutSections.get(layoutSections.size() - 2).layoutFields.add(lf);
                               // }
                            priorFieldLayoutAdded = true;
                        }else
                            priorFieldLayoutAdded = false;
                    }
                    
                }
                if(layoutSections.get(layoutSections.size() -1).layoutFields.size() <= 0)  
                    layoutSections.remove(layoutSections.size() - 1);
            }
        }
        return layoutSections;
    }
    


    static string getUrlPrefix(){
        String baseurl = [SELECT InstanceName FROM Organization].InstanceName;
        return baseurl;
    }
    
    public static string GetLayoutSchema(id recordTypeId, string objectType, String accessToken){
        string allLayoutsRestUrl = 'https://'+getUrlPrefix()+'.salesforce.com/services/data/v45.0/sobjects/'+objectType+'/describe/layouts/';
        string urlToRequest = allLayoutsRestUrl + recordTypeId;
        
    
        HttpResponse resp = null;
        
        HttpRequest req = new HttpRequest();
        
        req.setMethod('GET');
        req.setEndpoint(urlToRequest);
        req.setHeader('Authorization', 'Bearer ' + accessToken);
        
        Http client = new Http();
        resp = client.send(req);
        return resp.getBody();
    }
    
    public static Id  getDefaultRecordType(SObject obj) {
        
        Schema.DescribeSObjectResult describeResult = obj.getsObjectType().getDescribe();
        List<Schema.RecordTypeInfo> rtInfos = describeResult.getRecordTypeInfos();
        for(Schema.RecordTypeInfo rtInfo : rtInfos) {
            // walk through the map to determine the correct record type, this is done with the isAvailable() function
            if(rtInfo.DefaultRecordTypeMapping) {              
                return  rtInfo.getRecordTypeId();
            }
        }
        
        return null;
    }
    
    public class LayoutSection
    {
        public Boolean useHeader {get;set;}
        public String name {get;set;}
        public Boolean allowCollapse {get;set;}  
        public integer columns {get;set;}
        public List<LayoutField> layoutFields {get;set;}
        public Accessibility accessibilityInstance {get;set;}
        
    }
    
    public class LayoutField
    {
        public Boolean required {get; set;}
        public Boolean isPlaceHolder {get;set;}        
        public String ApiName {get;set;}
        public Boolean editableField {get;set;}
         public Integer fieldCount {get;set;}
        

    }
    
    
    //////// ####   SECURITY ####### //////////
    
    public Static Map<String, Accessibility.FieldAccess> fieldAccessMap ;
    public Static Accessibility objAccessibiblity {get; set;}
    public Static Accessibility accessibility1 {get;set;}
    public Static Accessibility accessibility2 {get;set;}
    public  Static List<FieldName> permittedfieldList {get;set;}
    public Static String objectName {get;set;}
    @testVisible  Static String objectNameWithNamespace;
    @testVisible  Static String namespacePrefix;
    
    public Static void CheckPermission(){
        objAccessibiblity =  new Accessibility();
        Boolean namespaceExists = false;
        if(namespaceExists){
            initaccessibility1();
            initaccessibility2();
        }else{
            initaccessibility1WithoutNameSpace();
        }
        objAccessibiblity= accessibility1;
    }
    
    @testVisible Static void initaccessibility1(){
        accessibility1 = new Accessibility();
        accessibility1.Email = '';
        accessibility1.Profile = profileName;
        initObjectAccessibility(accessibility1);
        initFieldAccessibility(accessibility1, objectNameWithNamespace);
    }
    
    
    @testVisible Static void initaccessibility2(){
        accessibility2 = new Accessibility();
        accessibility2.Email = '';
        accessibility2.Profile = profileName;
        initObjectAccessibility(accessibility2);
        initFieldAccessibility(accessibility2, objectNameWithNamespace);
    }
    
    @testVisible Static void initObjectAccessibility(Accessibility accessibility){
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
    
    @testVisible Static void initFieldAccessibility(Accessibility accessibility, String objectNameWithNamespace){
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
    
    @testVisible Static void adjustFieldAccessibilityMap(Map<String, Accessibility.FieldAccess> fieldAccessMap){
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
    
    public Static Boolean initObjectAndNameSpacePrefix(){
        ApexClass cs = [select NamespacePrefix from ApexClass where Name =:getClassName()];
        namespacePrefix = cs.NamespacePrefix;
        objectName = objName;
        if(namespacePrefix != null){
            objectNameWithNamespace = namespacePrefix + '__' + objName;
            return true;
        }else{
            return false;
        }
    }
    
    @testVisible Static String getClassName(){
        return String.valueOf(new LayoutDescriberHelper()).split(':')[0];
    }
    
    @testVisible Static List<String> getRequiredFields(){
        List<String> reqfields = new List<String>();
       Schema.DescribeSObjectResult objectDescribe =  Schema.getGlobalDescribe().get(objName).getDescribe();
        for(String fld: objectDescribe.fields.getmap().keyset()){
            
           if(objectDescribe.isCustom() && fld.toLowerCase() == 'name'){
                reqfields.add(objName.toLowerCase() + '.' + fld.toLowerCase());
           }else {
               if(isRequired(objName, fld)){
                reqfields.add(objName.toLowerCase() + '.' + fld.toLowerCase());
            }
           }
        }
        return reqfields;
    }
    
    public Static Boolean isRequired(String obj, String fld){
        return !Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().get(fld).getDescribe().isNillable();
    }    
    
    @testVisible Static void initaccessibility1WithoutNameSpace(){
        accessibility1 = new Accessibility();
        accessibility1.Email = '';
        accessibility1.Profile = profileName;
        initObjectAccessibility(accessibility1);
        initFieldAccessibilityWithoutNameSpace(accessibility1, objName);
    }
    
    @testVisible Static void initFieldAccessibilityWithoutNameSpace(Accessibility accessibility, String objname){
        list<FieldPermissions> fldper =  [SELECT Id,Field, PermissionsRead, PermissionsEdit, sobjectType, ParentId 
                                          FROM FieldPermissions 
                                          WHERE parentId IN (SELECT id 
                                                             FROM permissionset 
                                                             WHERE PermissionSet.Profile.Name = :accessibility.Profile)
                                          AND sObjectType = :objname]; 
        for(FieldPermissions fp:fldper){
            
            Accessibility.FieldAccess fldaccess=new Accessibility.FieldAccess();
            fldaccess.hasReadAccess = fp.PermissionsRead;
            fldaccess.hasEditAccess = fp.PermissionsEdit;
            accessibility.Fieldaccessibility.put(fp.Field.toLowerCase() , fldaccess);
        }
        fieldAccessMap =  accessibility.Fieldaccessibility;
    }
    
    @testVisible Static  Map<String, Accessibility.FieldAccess> adjustFieldAccessibilityMapwithoutNameSpace(FieldName fld){
        Accessibility.FieldAccess fldaccess=new Accessibility.FieldAccess();
        System.debug(fld);
        if( !reqFld.contains(fld.fieldNameWithoutNamespace.toLowerCase())){
            
            string f = getParentObjectField(fld.fieldNameWithNamespace).toLowerCase();
            if(!fieldAccessMap.containsKey(f)){
                fldaccess.hasReadAccess = false;
                fldaccess.hasEditAccess = false;
                fieldAccessMap.put(fld.fieldNameWithoutNamespace.toLowerCase(), fldaccess);
            }else{
                fldaccess.hasReadAccess = fieldAccessMap.get(f).hasReadAccess; // Undefined???????????????
                fldaccess.hasEditAccess = fieldAccessMap.get(f).hasEditAccess;// Undefined???????????????
                fieldAccessMap.put(fld.fieldNameWithoutNamespace.toLowerCase(), fldaccess);
            }
            if((fld.fieldNameWithoutNamespace.toLowerCase().toLowerCase() == 'name')){
                fldaccess.hasReadAccess = true; // Undefined???????????????
                fldaccess.hasEditAccess = true; // Undefined???????????????
                fieldAccessMap.put(fld.fieldNameWithoutNamespace.toLowerCase(), fldaccess);
            }
        }else{
            fldaccess.hasReadAccess = true; // Undefined???????????????
            fldaccess.hasEditAccess = true; // Undefined???????????????
            fieldAccessMap.put(fld.fieldNameWithoutNamespace.toLowerCase(), fldaccess);
        }
       
        return fieldAccessMap;
    }
    
    
    
    public  Static String getParentObjectField(String fld){
        String newFld = fld;
        
        Map<String, sobjectType> sp = Schema.getGlobalDescribe();
        try {
            if(fld.containsIgnoreCase(sp.get(objName).getDescribe().getName())){
                fld = fld.substring(sp.get(objName).getDescribe().getName().length() + 1);
            }
            if(fld != null && fld != ''){
                Schema.DescribeFieldResult f = sp.get(objName).getDescribe().fields.getMap().get(fld).getDescribe();
                
                if(f.getRelationshipName() != null){
                    for(Schema.SObjectType reference : f.getReferenceTo()) {
                        
                        
                        schema.DescribeSObjectResult sdescribe = reference.getDescribe();
                        List<Schema.ChildRelationship> childdesc = sdescribe.getChildRelationships();
                        for(Schema.ChildRelationship referen : childdesc) {
                            if(referen.getChildSobject().getDescribe().getName() == objName)
                                fld = objName + '.' + referen.getField().getDescribe().getName();
                            fld= fld.toLowerCase();
                        }
                    }
                }else{
                    fld = newFld;
                } 
            } 
        } catch (Exception e) {
            
            fld = newFld;
            apexpages.addMessage(new apexpages.message(Apexpages.Severity.ERROR, e.getMessage() + e.getLineNumber()));
        }  
        
        
        return fld;
        
    }
    
    public Static String getReferenceFieldApiName(String parentObjName, String childobjName){
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
    
    public  class FieldName{
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