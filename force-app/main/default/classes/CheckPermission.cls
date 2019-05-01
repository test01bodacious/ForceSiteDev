 public class CheckPermission {
   public  Accessibility objAccessibiblity {get; set;}
    public Accessibility accessibility1 {get;set;}
    public Accessibility accessibility2 {get;set;}
    public List<FieldName> permittedfieldList {get;set;}
    public String objectName {get;set;}
    public TaskRelatedListClass taskRelatedObjList {get; set;}
    public String profileName ;
    public List<String> fieldLst ;
    @testVisible String objectNameWithNamespace;
    @testVisible String namespacePrefix;
    
    public  CheckPermission( String objectName, String profileName, list<String> fieldLst){
        this.fieldLst = fieldLst;
        this.profileName = profileName;
        this.objectName = objectName;
        objAccessibiblity =  new Accessibility();
        taskRelatedObjList = new TaskRelatedListClass();
        // profileName='installer';
        Boolean namespaceExists = initObjectAndNameSpacePrefix();
        if(namespaceExists){
            initFields();
            //initRecords();
            initaccessibility1();
            initaccessibility2();
        }else{
            initFieldsWithoutNameSpace();
            initaccessibility1WithoutNameSpace();
            //initaccessibility2WithoutNameSpace();
            
        }
        objAccessibiblity= accessibility1;
    }
    

    public List<String> getFieldLst(){
        return fieldLst;
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
        for(String fld: getfieldLst()){
            FieldName fn;
            if(objectName == 'task__c' || objectName == 'event__c' ){
                if(!taskRelatedObjList.taskRelatedObject.contains(fld.toLowerCase())){ 
                    fn = new FieldName(fld.toLowerCase(), s.toLowerCase() + fld.toLowerCase());
                    permittedfieldList.add(fn);
                }
            }else {
                fn = new FieldName(fld.toLowerCase(), s.toLowerCase() + fld.toLowerCase());
                permittedfieldList.add(fn);
            }
            
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
        return String.valueOf(this).split(':')[0];
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
    
    @testVisible void initaccessibility1WithoutNameSpace(){
        accessibility1 = new Accessibility();
        accessibility1.Email = '';
        accessibility1.Profile = profileName;
        initObjectAccessibility(accessibility1);
        initFieldAccessibilityWithoutNameSpace(accessibility1, objectName);
    }
    
    @testVisible void initFieldAccessibilityWithoutNameSpace(Accessibility accessibility, String objname){
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
        adjustFieldAccessibilityMapwithoutNameSpace(accessibility.Fieldaccessibility);
    }
    
    @testVisible void initFieldsWithoutNameSpace (){
        permittedfieldList = new List<FieldName>();  
        
        String s = objectName + '.';
        for(String fld: getfieldLst()){
            FieldName fn ;
            if(objectName == 'task__c' || objectName == 'event__c' ){
                if(!taskRelatedObjList.taskRelatedObject.contains(fld)){ 
                    fn = new FieldName(fld.toLowerCase(), s.toLowerCase() + fld.toLowerCase());
                    permittedfieldList.add(fn);
                }
            }else {
                fn = new FieldName(fld.toLowerCase(), s.toLowerCase() + fld.toLowerCase());
                permittedfieldList.add(fn);
            }
            
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
                    if(referen.getChildSobject().getDescribe().getName() == objectName)
                        fld = objectName + '.' + referen.getField().getDescribe().getName();
                }
            }
        }else{
            fld = newFld;
        }    
        return fld;
        
    }
}