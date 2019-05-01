public class PaginationComponentController {
    
    @testVisible String query;
    
    @testVisible String queryType;
    
    @testVisible String objName;
    
    @testVisible List<String> fieldLst;
    
    @testVisible Integer QUERY_LIMIT;
    
    @testVisible Integer initialPageSize;
    public TaskRelatedListClass taskRelatedObjList {get; set;}
    public String taskEventObj {get; set;}
    public id recId {get; set;}
    public boolean isTask {get; set;}
    public String profileName{get;set;}
    public list<string> recordIdLst {get; set;}
    public List<RecordWrapper> recordList {get;set;}
    
    public Map<Id, RecordWrapper> mapHoldingRecordList {get;set;}
    
    public Integer pageSize {get;set;}
    
    public Boolean isSelectAll {get;set;}
    
    public Integer selectedTotal{get;set;}
    
    // initialized to DateTime.now() when setCon is initiallized
    @testVisible DateTime setControllerBirthday {get; set;} 
    
    // Make SetController safe 
    private void BubblewrapSetController() {
        
        if (setControllerBirthday < Datetime.now().addMinutes(-10)) {
            Integer pageNum = setCtrl.getPageNumber();  //maintain current page
            Id filterId = setCtrl.getFilterId();        //maintain current filter
            
            setCtrl = new ApexPages.StandardSetController(Database.getQueryLocator(query));
            setctrl.setFilterId(filterId);                //restore filter
            setCtrl.setPageNumber(pageNum);             //restore page
            setControllerBirthday = DateTime.now();    //restart the clock
        }
    }
    
    // Sorting a Column
    private Boolean updateQuery = true;
    private String sortDirection = '';
    private String sortExp = '';
    private string sortFullExp = '';
    
    public String sortExpression
    {
        get
        {
            return sortExp;
        }
        set
        {
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp){
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            }
            else{
                sortDirection = 'ASC';
            }
            
            sortExp = value;
        }
    }
    
    public String getSortDirection()
    {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }
    
    public void setSortDirection(String value)
    {  
        sortDirection = value;
    }
    
    public String getqueryType(){
        return queryType;
    }
    
    public String dumobj ;
    public string refereshMode;
    public userInfo__C customUser {get; set;}
    public string  dummyquery ;
    Site_User__c user;
    public void setqueryType(String qt){
        
        
        id uId = apexpages.currentPage().getParameters().get('userId');
        try{
            user= database.query('SELECT id, first_Name__C, last_Name__c, name, Email__C, Profile__C FROM Site_User__c Where id = :uId limit 1'); //isCreate, isTable, isGlobalTable, isTaskEvent, isHome
            customUser= UserInfo__c.getInstance(user.Email__C);


             if(queryType == null || dumobj != objName || qt != queryType || refereshMode =='update' || refereshMode == 'delete'){  
            queryType = qt;
            setCtrl = null;
            CheckPermission();           
            init();
            if(refereshMode == 'delete')
                selectedTotal = 0;
            dumobj = objName;
            refereshMode='';
            customUser.isGlobalTable__c = false;
            dummyquery = query;
        }
        }catch(Exception e){
            System.debug(e.getLineNumber());
            user = new Site_User__c();
            customUser =new UserInfo__C();
        }
        
       
    }
    public String getquery(){
        return query;
    }
    
    public void setquery(String q){
        System.debug(q);
        if(query == null || query != q){
            query = q;
        }
    }
    
    public String getobjName(){
        return objName;
    }
    
    public void setobjName(String o){
        isSelectAll = false;
        if(objName == null || objName != o){
            
            mapHoldingRecordList = new Map<Id, RecordWrapper>();
            objName = o.toLowerCase();
            selectedTotal=0;
            isSelectAll = false;
            setCtrl = null;
            
        }
        
    }
    
    public List<String> getfieldLst(){
        if (fieldLst == null || fieldLst.size() == 0) {
            Apexpages.addMessage(new Apexpages.message(Apexpages.Severity.ERROR, 'Fields are not selected. Please contact your Administrator'));
            return new List<String>();
        }
        return fieldLst;
    }
    
    public void setfieldLst(List<String> fidLst){
        if(fieldLst == null || fieldLst != fidLst){
            fieldLst = fidLst;
            
        }
    }
    
    public Integer getQUERY_LIMIT(){
        return QUERY_LIMIT;
    }
    
    public void setQUERY_LIMIT(Integer ql){
        if(QUERY_LIMIT == null){
            QUERY_LIMIT = ql;
        }
    }
    
    public Integer getinitialPageSize(){
        return initialPageSize;
    }
    
    public void setinitialPageSize(Integer ips){
        if(initialPageSize == null){
            initialPageSize = ips;
        }
    }
    
    public PageReference sortData() {
        //build the full sort expression
        sortFullExp = sortExpression  + ' ' + sortDirection;
        //query the database based on the sort expression
        updateQuery = true;
        init();
        return null;
    }
    
    public List<String> getNameUniqueField(String objType)
    {  
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(objType);
        List<String> strResult = new List<String>();
        //Schema.sObjectType objType = obj.getSObjectType();
        Schema.DescribeSObjectResult ObjResult =  LeadSchema.getDescribe();
        Map<String, Schema.SObjectField> mapFields = ObjResult.Fields.getMap();
        schema.describeFieldResult dfield;
        for(String s : mapFields.keySet()){
            dfield = mapFields.get(s).getDescribe();
            //for(Schema.SObjectField objField : mapFields)
            
            if(dfield.isNameField())
            {
                strResult.add(dfield.getName().toLowerCase());
                break;
            }
            
            if(dfield.isAutoNumber())
            {
                strResult.add(dfield.getName().toLowerCase());
                break;
            }
            
            if(dfield.isUnique())
            {
                strResult.add(dfield.getName().toLowerCase());
                break;
            }
        }
        return strResult;
    }
    
    public void adjustQueryForSoql(){
        Integer index = query.indexOf('ORDER BY');
        if(index != -1){
            query = query.substring(0, index);
        }
        query += ' ORDER BY ';   
        if(sortExpression != null && sortExpression != '' && sortDirection != null && sortDirection != ''){
            query += sortFullExp;
        }else{
            query += getNameUniqueField(objName)[0] + ' ASC';
        }
        query += ' LIMIT ' + QUERY_LIMIT ;
        updateQuery = false;
    }
    
    public void adjustQueryForSosl(){
        String q = query.substring(0, (query.lastIndexOf(')')));
        q += ' ORDER BY ';
        if(sortExpression != null && sortExpression != '' && sortDirection != null && sortDirection != ''){
            q += sortFullExp;
        }else{
            
            q += getNameUniqueField(objName)[0] + ' ASC';
        }
        q += ' ) LIMIT ' + QUERY_LIMIT ;
        
        query =q;
        updateQuery = false;
    }
    
    ApexPages.StandardSetController setCtrl{get{
        if(setCtrl == null || updateQuery){
            try{
                if(queryType == 'SOQL'){
                    adjustQueryForSoql();
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, query));
                    setCtrl = new ApexPages.StandardSetController(Database.getQueryLocator(query));
                }else if(queryType == 'SOSL'){
                    adjustQueryForSosl();
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, query));
                    setCtrl = new ApexPages.StandardSetController(Search.Query(query)[0]);
                }
            }catch (Exception e) {
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, e.getMessage()));
                setCtrl = new ApexPages.StandardSetController(new List<Account>());
            }
            pageSize = (pageSize == null)? initialPageSize: pageSize;
            selectedTotal = 0;
        }
        return setCtrl;
    }set;}
    
    public PaginationComponentController(){
        taskRelatedObjList = new TaskRelatedListClass();
        taskEventObj ='';
        refereshMode = '';
        recordList = new List<RecordWrapper>();
        mapHoldingRecordList = new Map<Id, RecordWrapper>();
        setControllerBirthday = DateTime.now();
    }
    
    public void init(){
        setCtrl.setPageSize(pageSize);
        updatemapHoldingRecordList();
        recordList = new List<RecordWrapper>();
        if(accessibility1.objectAccessibility.containskey(objName.toLowerCase())){
            
            for(sObject rec: setCtrl.getRecords()){
                
                if(mapHoldingRecordList != null && mapHoldingRecordList.containsKey(rec.Id)){
                    recordList.add(mapHoldingRecordList.get(rec.Id));
                }else{
                    recordList.add(new RecordWrapper(rec, false));
                }
            }
        }
    }
    
    public void updatemapHoldingRecordList() {
        recordIdLst = new List<String>();
        for(RecordWrapper recWrap : recordList){
            if(recordToDelete != null && recordToDelete.size() > 0){
                if(recWrap.isSelected && !recordToDelete.contains(recWrap.record.id)){
                    mapHoldingRecordList.put(recWrap.record.id, recWrap);
                    recordIdLst.add(recWrap.record.id);
                }
                
            }else{
                if(recWrap.isSelected){
                    mapHoldingRecordList.put(recWrap.record.id, recWrap);
                    recordIdLst.add(recWrap.record.id);
                }
            }
            if(recWrap.isSelected == false && mapHoldingRecordList.containsKey(recWrap.record.id)){
                if(recordIdLst.contains(recWrap.record.id))
                    recordIdLst.remove(recordIdLst.indexOf(recWrap.record.id));
                mapHoldingRecordList.remove(recWrap.record.id);
            }
        }
        selectedTotal = mapHoldingRecordList.size();
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

    public Id getRecordTypeIdFromRecordId(Id rid){
        List<Schema.RecordTypeInfo> rtiLst = Schema.getGlobalDescribe().get(objName).getDescribe().getRecordTypeInfos();
        if (rtiLst.size() == 1) {
            return rtiLst[0].getRecordTypeId();
        }else{
            String query = 'SELECT RecordTypeId FROM ' + objName + ' WHERE Id = :rid';
             return ((Id)Database.query(query)[0].get('RecordTypeId') != null)? (Id)Database.query(query)[0].get('RecordTypeId') : (Id)rtiLst[0].getRecordTypeId();
        }
    }

    
    public PageReference showRelatedList(){
        PageReference pgr = new PageReference('/apex/HeaderPage');
       try {
            pgr.getParameters().put('recId', recid);
            pgr.getParameters().put('objectName', objName);
            pgr.getParameters().put('UserId', apexpages.currentPage().getparameters().get('Userid'));
            pgr.getParameters().put('queryType', queryType);
            pgr.setRedirect(true);
            customUser.parentrecid__c = recId;
            customUser.parentObjName__c = objName;
            customUser.isRelated__c = true;
            customUser.isCreate__c = false;
            customUser.isGlobalTable__c = false;
            customUser.isHome__c = false;
            customUser.isTable__c = false;
            customUser.isTask__c = false;
            List<LayoutDescriberHelper.LayoutSection> layoutSections  = LayoutDescriberHelper.describeSectionWithFields(getRecordTypeIdFromRecordId(recId), objName, profileName);
            Cache.Org.put('local.SitePartition.layoutsections' , layoutSections);
            update customUser;
       } catch (Exception e) {
           Apexpages.addMessage(new Apexpages.message(Apexpages.Severity.ERROR, e.getMessage()));
             System.debug('Exception in class: ' + String.valueOf(this).split(':')[0] + ' === Message: ' + e.getMessage() + ' === At Line: ' + e.getLineNumber());
           
       }
        return pgr;
    }
    
    public void saveRecordWrapper(){
        List<sObject> recs = new List<sObject>();
        for(RecordWrapper recWrap : recordList){
            if(recWrap.isSelected){
                recs.add(recWrap.record);
                mapHoldingRecordList.put(recWrap.record.id, recWrap);
            }
            if(recWrap.isSelected == false && mapHoldingRecordList.containsKey(recWrap.record.id)){
                mapHoldingRecordList.remove(recWrap.record.id);
            }
        }
        selectedTotal = mapHoldingRecordList.size();
    }
    
    public void saveRecords(List<sObject> recs){
        try{
            update recs;
        }catch(Exception e){
            
        }
    }
    
    public Integer getpageNumber(){
        return setCtrl.getpageNumber();
    }
    
    public Integer getresultSize(){
        return setCtrl.getResultSize();
    }
    
    
    public Boolean gethasNext(){
        return setCtrl.getHasNext();
    }
    
    public Boolean gethasPrevious(){
        return setCtrl.getHasPrevious();
    }
    
    public void next(){
        dummyquery='';
        BubblewrapSetController();
        setCtrl.next();
        init();
    }
    
    public void previous(){
        BubblewrapSetController();
        setCtrl.previous();
        init();
    }
    
    public void first(){
        BubblewrapSetController();
        setCtrl.first();
        init();
    }
    
    public void last(){
        BubblewrapSetController();
        setCtrl.last();
        init();
    }
    
    List<id> recordToDelete ;
    List<sobject> recordToUpdate; 
    List<SObject> beForerecordToUpdate = new List<sobject>();
    public PageReference updateRecords(){
        
        try {
            if(accessibility1.objectAccessibility.containskey(objName)){
                Accessibility.ObjectAccess objAccess = accessibility1.objectAccessibility.get(objName);
                if(objAccess.hasEditAccess){
                    updatemapHoldingRecordList();
                    
                    recordToUpdate = new list<sobject>();
                    for(id rId : mapHoldingRecordList.keySet()){
                        Sobject s = mapHoldingRecordList.get(rId).dummyRecord;
                        s.put('id', rId);
                        recordToUpdate.add(s);
                    }
                    
                    Database.SaveResult []srList = Database.update(recordToUpdate, false);
                    String error = '';
                    for(Database.SaveResult sr : srList) {
                        if (sr.isSuccess()){
                            refereshMode = 'update';
                        }
                        else {               
                            for(Database.Error err : sr.getErrors()) {
                                error += ('<b>' + err.getStatusCode() + '</b>: ' + err.getMessage()) + '<br/><br/>';
                                if(err.getFields().size() > 0)
                                    error += ('Fields that affected this error: ' + err.getFields() + '<br/><br/>');
                            }
                        }
                    }
                    if(error != ''){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
                    }else{
                        createHistory();
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'All selected records have been updated successfully'));
                    } 
                }else{
                    updateQuery =true;
                    ApexPages.addMessage(new ApexPages.message(apexpages.Severity.WARNING, 'Insufficient Privileges'));
                    init();
                }
            }
        } catch (Exception e) {
            Apexpages.addMessage(New ApexPages.message(Apexpages.Severity.ERROR, e.getStackTraceString()));
        }
        return null;
    }
    
    public PageReference deleteRecords(){

        if(accessibility1.objectAccessibility.containskey(objName)){
            
            Accessibility.ObjectAccess objAccess = accessibility1.objectAccessibility.get(objName);
            if(objAccess.hasDeleteAccess){
                
                recordToDelete = new list<id>();
                updatemapHoldingRecordList();
                recordToDelete.addAll(mapHoldingRecordList.keySet());
                Database.DeleteResult []srList = Database.delete(recordToDelete, false);
                String error = '';
                recordToDelete  = new list<id>();
                for(Database.DeleteResult sr : srList) {
                    if (sr.isSuccess()){
                        refereshMode= 'delete';
                        recordToDelete.add(sr.getId());
                        mapHoldingRecordList.remove(sr.getId());
                        
                    }
                    else {               
                        for(Database.Error err : sr.getErrors()) {
                            error += ('<b>' + err.getStatusCode() + '</b>: ' + err.getMessage()) + '<br/><br/>';
                            if(err.getFields().size() > 0)
                                error += ('Fields that affected this error: ' + err.getFields() + '<br/><br/>');
                        }
                    }
                }
                if(error != ''){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
                }else{
                    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'All selected records have been deleted successfully'));
                } 
            }else{
                updateQuery =true;
                init();
                ApexPages.addMessage(new ApexPages.message(apexpages.Severity.WARNING, 'Insufficient Privileges!! Please Contact your Adminsitrator'));
            }
        }
        return null;
    }
    
     public List<LayoutDescriberHelper.LayoutSection> layoutSections ; 
    
    public Pagereference createtask(){

        try{
              initRecTypeInfoLst();
            if (recTypeInfoLst.size() == 1) {
                layoutSections = LayoutDescriberHelper.describeSectionWithFields(recTypeInfoLst[0].id, taskEventObj, profileName);
                Cache.Org.put('local.SitePartition.layoutsections' , layoutSections);
            }
            updatemapHoldingRecordList();
            customUser.isTask__C = true;
            customUser.isCreate__C = true;
            update customUser;
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'createtask' + e.getMessage()));
        }
        
        return null;
    }
    
    public class RecordWrapper{
        
        public sObject record {get;set;}
        public sObject dummyRecord {get;set;}
        public Boolean isSelected {get;set;}
        
        public RecordWrapper(sObject record, Boolean isSelected){
            this.record = record;
            this.dummyRecord = record.clone();
            this.isSelected = isSelected;
        }
    }
    
    
    /////////////// ####Create History #### ///////////////
    
    public void createHistory(){

        list<SiteHistory__C> siteHistoryObjlst = new List<SiteHistory__C>();
        
        SiteHistory__C histryobj;
        for(sobject sId : recordToUpdate){
            histryobj = new SiteHistory__C();
            if(user != null){
                histryobj.user_Name__C = user.First_Name__C + ' ' + user.Last_Name__C;
                histryobj.Email__c = user.Email__c;
                histryobj.put(getReferenceFieldApiName(), sId.get('id'));
                Map<String ,object> fldMap = sID.getPopulatedFieldsAsMap();
                String msg ='Changed ';
                for(String fld : fldMap.keySet()){
                    
                    if(Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(fld).getDescribe().isUpdateable()){
                        if(mapHoldingRecordList.get((id)sId.get('id')).record.get(fld)!=null && sId.get(fld) !=null){
                            if(!mapHoldingRecordList.get((id)sId.get('id')).record.get(fld).equals(sId.get(fld))){
                                
                                if(mapHoldingRecordList.get((id)sId.get('id')).record.get(fld) != null){
                                    msg += 'Changed ' + fld + ' from ' +  mapHoldingRecordList.get((id)sId.get('id')).record.get(fld) + ' to ' + sID.get(fld) + '\n';  
                                }
                            }else if(sId.get(fld) == null){
                                
                                msg += 'Deleted ' + sId.get(fld) + ' in ' + fld + '\n';
                            }
                        }else if(sId.get(fld) !=null){
                            msg += 'Changed ' + fld + ' to ' + sId.get(fld) + '\n';
                        }else if(mapHoldingRecordList.get((id)sId.get('id')).record.get(fld) !=null){ 
                            msg += ' Deleted '+ mapHoldingRecordList.get((id)sId.get('id')).record.get(fld) + ' in ' + fld + '\n';
                            
                        }
                        
                    }
                }
                histryobj.action__C= msg;
            }
            siteHistoryObjlst.add(histryobj);
        }
        Database.SaveResult [] srList;
        if(siteHistoryObjlst != null){
            srList = Database.insert(siteHistoryObjlst);
        }
        String error='';
        for(Database.SaveResult sr : srList) {
            if (sr.isSuccess() && mapHoldingRecordList.get(sr.getId()) != null){
                
            }
            else {               
                for(Database.Error err : sr.getErrors()) {
                    error += ('<b>' + err.getStatusCode() + '</b>: ' + err.getMessage()) + '<br/><br/>';
                    if(err.getFields().size() > 0)
                        error += ('Fields that affected this error: ' + err.getFields() + '<br/><br/>');
                }
            }
        }
        if(error != ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'All selected records have been updated successfully'));
        } 
    }
    
    public void updateRecordForHistory(list<Sobject> sobj){
        for(Sobject s : sobj){
            mapHoldingRecordList.get((id)s.get('id')).record =  mapHoldingRecordList.get((id)s.get('id')).dummyRecord;
            mapHoldingRecordList.get((id)s.get('id')).record.put('id', s.get('id'));
        }
    }
    
    public String getReferenceFieldApiName(){
        String fldApiName = '';
        map<string, schema.SObjectType> mp = schema.getGlobalDescribe();
        schema.DescribeSObjectResult sdescribe = mp.get(objName.toLowerCase()).getDescribe();
        List<Schema.ChildRelationship> childdesc = sdescribe.getChildRelationships();
        for(Schema.ChildRelationship reference : childdesc) {
            if(reference.getChildSobject().getDescribe().getName() == 'siteHIstory__c')
                fldApiName = reference.getField().getDescribe().getName();
        }
        return fldApiName;
    }
    
   
    
    
    //###########The following code is for object level and field level Security//
    
    public  Accessibility objAccessibiblity {get; set;}
    public Accessibility accessibility1 {get;set;}
    public Accessibility accessibility2 {get;set;}
    public List<CheckPermission.FieldName> permittedfieldList {get;set;}
    public String objectName {get;set;}
    @testVisible String objectNameWithNamespace;
    @testVisible String namespacePrefix;
    
    public void CheckPermission(){
        CheckPermission access;
        try {
              Attachment at ;
           try {
             at = [select name, body from attachment WHERE Name = : profileName + objName LIMIT 1];
           } catch (Exception e) {
               Apexpages.addMessage(new Apexpages.message(Apexpages.Severity.ERROR, 'Profile Permission is not available. Please contact your Administrator'));
               return;
           }
            String str = at.Body.toString();
            access=  (CheckPermission)JSON.deserialize(str, CheckPermission.class);
            
            accessibility1 = access.accessibility1;
            accessibility2 = access.accessibility2;
            permittedfieldList = access.permittedfieldList;
            if(accessibility1== null || permittedfieldList == null){
                Apexpages.addMessage(new Apexpages.message(Apexpages.Severity.INFO, 'Profile Permission data is fetching. Please wait....'));
            }
            List<String> fldLst = new List<String>();
            Object__C obj;
            if (queryType == 'SOQL') {
                obj = [SELECT fields_developer_Name__c FROM Object__C WHERE developer_name__c = :objName AND view__c = 'All Records View'];
            }else {
                obj = [SELECT fields_developer_Name__c FROM Object__C WHERE developer_name__c = :objName AND view__c = 'Search Records View'];
            }
           
            for (String s : (obj.fields_developer_Name__c).split('; ')) {
                 fldLst.add(s.toLowerCase());
            }

            permittedfieldList = new List<CheckPermission.FieldName>();
            System.debug(fieldLst);
            for (CheckPermission.FieldName fld : access.permittedfieldList) {
                System.debug(fld.fieldNameWithoutNamespace);
              if (fieldLst.contains(fld.fieldNameWithoutNamespace)) {

                  permittedfieldList.add(fld);
              }
                
            }
        } catch (Exception e) {
            Apexpages.addMessage(new Apexpages.message(Apexpages.Severity.ERROR, e.getMessage() + ' Line Number== >> ' + e.getLineNumber()));
        }

        //objAccessibiblity =  new Accessibility();
        // profileName='installer';
        //Boolean namespaceExists = initObjectAndNameSpacePrefix();
        //if(namespaceExists){
            //initFields();
            //initRecords();
            //initaccessibility1();
            //initaccessibility2();
        //}else{
            //initFieldsWithoutNameSpace();
            //initaccessibility1WithoutNameSpace();
            //initaccessibility2WithoutNameSpace();
            
        //}
        //objAccessibiblity= accessibility1;
    }
    
    // @testVisible void initaccessibility1(){
    //     accessibility1 = new Accessibility();
    //     accessibility1.Email = '';
    //     accessibility1.Profile = profileName;
    //     initObjectAccessibility(accessibility1);
    //     initFieldAccessibility(accessibility1, objectNameWithNamespace);
    // }
    
    // @testVisible void initaccessibility2(){
    //     accessibility2 = new Accessibility();
    //     accessibility2.Email = '';
    //     accessibility2.Profile = profileName;
    //     initObjectAccessibility(accessibility2);
    //     initFieldAccessibility(accessibility2, objectNameWithNamespace);
    // }
    
    // @testVisible void initObjectAccessibility(Accessibility accessibility){
    //     list<ObjectPermissions> objper = [SELECT Id,SObjectType, PermissionsRead, PermissionsEdit, PermissionsCreate, permissionsDelete 
    //                                       FROM ObjectPermissions 
    //                                       WHERE parentId IN ( SELECT id 
    //                                                          FROM permissionset 
    //                                                          WHERE PermissionSet.Profile.Name = :accessibility.Profile)]; 
    //     for(ObjectPermissions op : objper){
    //         Accessibility.ObjectAccess objaccess = new Accessibility.ObjectAccess();
    //         objaccess.hasReadAccess = op.PermissionsRead;
    //         objaccess.hasEditAccess = op.PermissionsEdit;
    //         objaccess.hasCreateAccess = op.PermissionsCreate;
    //         objaccess.hasdeleteAccess = op.permissionsDelete;
    //         accessibility.objectAccessibility.put((string)op.SObjectType.toLowerCase(), objaccess);
    //     }
    // }
    
    // @testVisible void initFieldAccessibility(Accessibility accessibility, String objectNameWithNamespace){
    //     list<FieldPermissions> fldper =  [SELECT Id,Field, PermissionsRead, PermissionsEdit 
    //                                       FROM FieldPermissions 
    //                                       WHERE parentId IN (SELECT id 
    //                                                          FROM permissionset 
    //                                                          WHERE PermissionSet.Profile.Name = :accessibility.Profile)
    //                                       AND sObjectType = :objectNameWithNamespace]; 
    //     for(FieldPermissions fp:fldper){
    //         Accessibility.FieldAccess fldaccess=new Accessibility.FieldAccess();
    //         fldaccess.hasReadAccess = fp.PermissionsRead;
    //         fldaccess.hasEditAccess = fp.PermissionsEdit;
    //         accessibility.Fieldaccessibility.put(fp.Field, fldaccess);
    //     }
    //     adjustFieldAccessibilityMap(accessibility.Fieldaccessibility);
    // }
    
    // @testVisible void initFields (){
    //     permittedfieldList = new List<FieldName>();
        
    //     String s = objectNameWithNamespace + '.' + namespacePrefix + '__';
    //     for(String fld: getfieldLst()){
    //         FieldName fn;
    //         if(objName == 'task__c' || objName == 'event__c' ){
    //             if(!taskRelatedObjList.taskRelatedObject.contains(fld.toLowerCase())){ 
    //                 fn = new FieldName(fld.toLowerCase(), s.toLowerCase() + fld.toLowerCase());
    //                 permittedfieldList.add(fn);
    //             }
    //         }else {
    //             fn = new FieldName(fld.toLowerCase(), s.toLowerCase() + fld.toLowerCase());
    //             permittedfieldList.add(fn);
    //         }
            
    //     }
    // }

    // @testVisible void adjustFieldAccessibilityMap(Map<String, Accessibility.FieldAccess> fieldAccessMap){
    //     for(FieldName fld: permittedfieldList){
    //         Accessibility.FieldAccess fldaccess=new Accessibility.FieldAccess();
            
    //         if(!fieldAccessMap.containsKey(fld.fieldNameWithNamespace) && !getRequiredFields().contains(fld.fieldNameWithoutNamespace)){
    //             fldaccess.hasReadAccess = false;
    //             fldaccess.hasEditAccess = false;
    //             fieldAccessMap.put(fld.fieldNameWithNamespace, fldaccess);
                
    //         }else{
                
    //             fldaccess.hasReadAccess = true; // Undefined???????????????
    //             fldaccess.hasEditAccess = true; // Undefined???????????????
    //             fieldAccessMap.put(fld.fieldNameWithNamespace, fldaccess);
    //         }
    //     }
    //}
    
    //  
    
    
    public Pagereference createNew(){
        customUser.isCreate__C = true;
        customUser.isHome__c = true;
        initRecTypeInfoLst();
        List<LayoutDescriberHelper.LayoutSection> layoutSections  = LayoutDescriberHelper.describeSectionWithFields(recTypeInfoLst[0].id, objName, profileName);
        Cache.Org.put('local.SitePartition.layoutsections' , layoutSections);
        
        update customUser;
        return null;
    }
    
}