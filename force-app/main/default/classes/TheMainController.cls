public with sharing class TheMainController implements Queueable{
    
    public String selectedObj {get;set;}
    public Boolean isObjectSelected{get;set;}
    public Boolean isFieldSelected{get;set;}
    public Integer PAGE_SIZE{get;set;}
    private final Integer QUERY_LIMIT = 200;
    public String mainField {get;set;}
    public Boolean renderMainTable {get;set;}
    public Integer overAllSize {get;set;}
    @testvisible private String mainquery;
    Boolean isUpdateDeleteQuery = false;
    public Boolean isShowError{get;set;}
    public Map<String, Decimal> sumOfCurrency {get;set;}
    public String checkSumFld {get;set;}
    @testVisible String rOldQuery;
    public String opportunityObjectName{get{
        return 'opportunity';
    }set;}
    
    //##############################################################################################
    public Map<String,schema.SObjectType> allobj{get;set;}
    
    Public Map<String,schema.SObjectField> selobjmap{get;set;}
    
    public List<String> objnames{get;set;}
    
    public List<string> fieldnames{get;set;}
    
    Public List<selectoption> options{get;set;}
    
    public List<String> objsupported = new List<String>{'Account'.toLowerCase(), 'Asset'.toLowerCase(), 'Campaign'.toLowerCase(), 'Case'.toLowerCase(), 'Contact'.toLowerCase(),
                                                        'Contract'.toLowerCase(), 'Lead'.toLowerCase(), 'Opportunity'.toLowerCase(),
                                                        'Order'.toLowerCase(), 'Product2'.toLowerCase(), 'Solution'.toLowerCase()};
 
    private Boolean RenderComponent;
    
    public SelectOption[] leftOptions { get; set; }
    public SelectOption[] rightOptions { get; set; }
    
    public SelectOption[] selectedContacts { get; set; }
    public SelectOption[] allContacts { get; set; }
    
    public String message { get; set; }
    
    @testVisible Id jobId;
    
    //##############################################################################################
    
    
    public List<MainRecordWrapperClass> mainObjLst{get;set;}
    public Map<String, List<RelatedRecordWrapperClass>> relatedObjLst{get;set;}
    public Map<String, List<String>> relatedFldMap{get;set;}
    public Map<String, List<String>> relatedFldMapVF {get; set;}
    public Map<String, String> rlFld{get;set;}
    public List<String> mainselectedFld{get;set;}
    public List<SelectOption> mainselectedFldOptions{get;set;}
    public List<SelectOption> allMainFieldOptions{get;set;}
    public List<SelectOption> PageSizeOptions{get;set;}
    public List<SelectOption> DateFieldOptions {set;get;}
    public List<Selectoption> selectedFilterFormatForData {set;get;}
    public String dateFormat {get;set;}
    public String dateFldPicklist {set;get;}
    public DateObject__c dateObj {get;set;}
    DateTime dtStart;
    DateTime dtEnd;
    @testVisible Date dat;
    public String mainSearch{get;set;}
    public Boolean isMainSelectAll {get;set;}
    public Boolean isNewMain {get;set;}
    public Boolean isNewMainTask {get;set;}
    public Boolean isNewMainEvent {get;set;}
    public Map<String, sObject> relatedObjectLst {get; set;}
    public Id recordId{get;set;}
    public Boolean showRelated{get;set;}
    public Boolean RenderDateInput{get;set;}
    public sObject myObj{get;set;}
    public String relatedFocusObject{get;set;}
    public Map<String, Boolean> isRelatedSelectAll{get;set;}
    public Map<String, Boolean> isNewRelated{get;set;}
    public ListCollection Paging {get;set;}
    public Task massTask{get;set;}
    public Event massEvent{get;set;}
    
    // Picklist Opitons
    public Map<String, Boolean> isPicklist{get;set;}
    public Boolean displayPicklistPopup {get; set;}
    public Map<String, Boolean> isFiltered {get;set;}
    public Map<String, List<SelectOption>> picklistOptions{get;set;}
    public String pickedFld{get;set;}
    public Map<String, PickListHandler> PickOptions{get;set;}
    public Map<String, List<String>> mapPickValues{get;set;}
    @TestVisible Map<String, PickListHandler> storedPickOptions;
    
    // New Object Creation Variables
    public Map<String, Map<String, Boolean>> mainObj {get;set;}
    public Map<String, Map<String, Boolean>> relatedObj {get;set;}
    public Map<String, sObject> mainObject {get;set;} 
/*    
    // Sorting a Column
    private String sortDirection = 'ASC';
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
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection = 'ASC';
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
*/    

    static Integer isRepeat = 0;
    public Boolean isWrongObj{get;set;}
    public String wrongObj{get;set;}
    
    @testVisible List<String> objApiName = new List<String>{'Account', 'Opportunity', 'Contact', 'Account'};
    @testVisible List<String> fieldSetName = new List<String>{'FS_Account', 'FS_Opportunity', 'FS_Contact', 'FS_Account_Site'};
    @testVisible List<String> vfPageName = new List<String>{'MainAccount', 'MainOpportunity', 'MainContact', 'MainAccountSite'};

        
    public TheMainController(){
        if(isRepeat == 0){
            System.debug('Constructor: Default'); 
            isFiltered = new Map<String, Boolean>();
            PAGE_SIZE = 10;
            renderMainTable = false;
            isShowError = true;
            checkSumFld = 'amount';
            sumOfCurrency = new Map<String, Decimal>();
            //mainselectedFld = getDefaultFields(selectedObj);
            
            try{
                Boolean check1 = objApiName == null || objApiName.isEmpty();
                Boolean check2 = vfPageName == null || vfPageName.isEmpty();
                Boolean check3 = (vfPageName != null && objApiName != null && fieldSetName != null)? !((vfPageName.size() == objApiName.size()) && (objApiName.size() == fieldSetName.size())) : true;
                if(check1 && check2 && check3){
                    selectedObj = 'NA';
                    isWrongObj = true;
                    wrongObj = selectedobj;
                }else{
                    for(Integer i = 0; i < vfPageName.size(); i++){
                        if(getVFPageName() == vfPageName[i]){
                            isFieldSelected = false;
                            isObjectSelected = true;
                            selectedObj = objApiName[i].toLowerCase();
                            isWrongObj = false;
                            if(Schema.getGlobalDescribe().get(selectedobj) == null){
                                isWrongObj = true;
                                wrongObj = selectedobj;
                            }else{
                                overAllSize = (integer)database.query('SELECT Count(ID) FROM ' + selectedObj)[0].get('expr0');
                                mainField = getNameUniqueField(selectedObj)[0];
                                mainselectedFld = getFieldsFromFieldSet(i);
                                
                                if(mainselectedFld != null && !mainselectedFld.isEmpty()){
                                    isFieldSelected = true;
                                }
                                
                                initializeMainAndRelated1();
                                initializeMainAndRelated2();
                            }
                            
                        }
                    }
                }
                if(getVFPageName() == 'Main'){
                    isWrongObj = false;
                    isFieldSelected = false;
                    isObjectSelected = false;
                    initializationForPopup();
                }
            }catch(Exception e){
                selectedObj = 'NA';
                isWrongObj = true;
                wrongObj = selectedobj;
            } 
        }
        isRepeat++;
    }
    
    public string getVFPageName() {
        // THIS IS THE CLOSEST YOU CAN GET SO FAR
        String pageName = ApexPages.CurrentPage().getUrl();
        // IT ALWAYS STARTS WITH /APEX/ SO REMOVE IT
        pageName = pageName.replaceFirst('/apex/', '');
        pageName = EncodingUtil.urlEncode(pageName, 'UTF-8');
        // %3F IS THE VALUE OF THE QUESTION MARK IN UTF-8 
        string[] pageNameExtra = pageName.split('%3F', 0);
        // SO YOU MAY SPLIT THE STRING AT THAT POINT
        // FOR THIS PURPOSE YOU ONLY NEED THE FIRST
        // IN THE RESULTING ARRAY
        pageName = pageNameExtra[0];
        // HERE IS YOUR PRODUCT  
        system.debug('pageName-->' + pageName);
        return pageName;
    }
    
    public Boolean isAdmin(){
        Id profileId = userinfo.getProfileId();
        String profileName = [Select Id,Name from Profile where Id = :profileId].Name;
        return (profileName == 'System Administrator')? true : false;
    }
    
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
    
    /*public PageReference sortData() {
        //build the full sort expression
        sortFullExp = sortExpression  + ' ' + sortDirection;
        
        //query the database based on the sort expression
        instantiateMainObjLst();
        return null;
    }*/
    
    public void initializationForPopup(){
        System.debug('Function: initializationForPopup');
        mainselectedFldOptions = new List<SelectOption>();
        mainselectedFld = new List<String>();
        leftoptions = new List<SelectOption>();
        rightoptions = new List<SelectOption>();
        allobj=schema.getGlobalDescribe();
        objnames= new List<String>{'Account'.toLowerCase(), 'Asset'.toLowerCase(),
                                    'Campaign'.toLowerCase(), 'Case'.toLowerCase(),
                                    'Contact'.toLowerCase(), 'Contract'.toLowerCase(),
                                    'Lead'.toLowerCase(),
                                    'Opportunity'.toLowerCase(), 'Order'.toLowerCase(),
                                    'Product2'.toLowerCase(), 'Solution'.toLowerCase()
                                 };
        objnames.addAll(getAllCustomSObjects());
        options=new List<selectoption>();
        objnames.sort();
        List<String> newObjNames = new List<String>();
        for(String o: objnames){
            if(isObjectPresent(o)){
                newObjNames.add(o);
            }
        }
        for(string s:newObjNames)
        {
            try{
                options.add(new selectoption(s,allobj.get(s).getDescribe().getLabel(), !Schema.getGlobalDescribe().get(s).getDescribe().isAccessible()));
            }catch(Exception e){
                
            }
        }
        options = selectOptionSortByLabel(options);
        options.add(0, new SelectOption('', 'None'));
    }
    
    public void initializeMainAndRelated1(){
        System.debug('Function: initializeMainAndRelated1');
        showRelated = false;
        relatedObjLst = new Map<String, List<RelatedRecordWrapperClass>>();
        isRelatedSelectAll = new Map<String, Boolean>();
        isMainSelectAll = false;
        isNewMain = false;
        mainObjLst = new List<MainRecordWrapperClass>();
        massTask = new Task();
        massEvent = new Event();
        Paging = new ListCollection();
        
        if(selectedObj != null && selectedObj != 'None'){
            
            instantiateAllPicklist();
            //instantiateAllRelated();
            if(getVFPageName() == 'Main'){
                jobId = System.enqueueJob(this);
            }
        }   
    }
    
    public PageReference triggerasync(){
        if(isWrongObj == null || isWrongObj){
            PageReference retURL = new PageReference('/apex/NoObjectPage?ObjectName=' + WrongObj);
            retURL.setRedirect(true);
            return retURL;
        }
        jobId = System.enqueueJob(this);
        return null;
    }
    
    public void instantiateAllPicklist(){
        instantiatePageSizeSelectPicklist();
        initPick();
        instantiateselectedFilterFormatForData();
        instantiateFieldPicklist();
    }
    
    public void instantiateAllRelated(){
        
        relatedObj = new Map<String, Map<String, Boolean>>();
        isNewRelated = new Map<String, Boolean>();
        relatedFldMapVF = new Map<String, List<String>>();
        
        for(String so: getAllRelatedObject(selectedObj)){
            isNewRelated.put(so, false);
            relatedFldMapVF.put(so, getDefaultFields(so));
            Map<String, Boolean> m = new Map<String, Boolean>();
            for(String sf: getAllFields(so)){
                if(isEditable(so, sf))
                    m.put(sf, isRequired(so, sf));
            }
            relatedObj.put(so, m);
        }
        
        rlFld = new Map<String, String>();
        for (Schema.ChildRelationship cr: Schema.getGlobalDescribe().get(selectedObj).getDescribe().getChildRelationships()) 
        {
            rlFld.put(cr.getRelationshipName(), String.valueOf(cr.getChildSObject()));
        }
        
        relatedFldMap = new Map<String, List<String>>();
        for(String so: getAllRelatedObjectWithRelationshipName(selectedObj)){
            relatedFldMap.put(so, getDefaultFields(rlFld.get(so)));
        }
        
    }
    
    public void execute(QueueableContext context){
        
        instantiateAllRelated();
        Cache.Org.put('local.TheMainInstance.TheMainInstanceKey', this);
    }
    
    public void initializeMainAndRelated2(){
        System.debug('Function: initializeMainAndRelated2');
        isMainSelectAll = false;
        isNewMain = false;
        
        if(selectedObj != null && selectedObj != 'None'){
 
            instantiateMainObj();
            instantiateMainObject();
            instantiateMainObjLst();
        }   
    }
    
    public void initPick(){
        System.debug('Function: initPick');
        dateObj = new DateObject__c();
        dateFldPicklist = 'CreatedDate';
        picklistoptions = new Map<String, List<SelectOption>>();
        pickedFld = '';
        PickOptions = new Map<String, PickListHandler>();
        mapPickValues = new Map<String, List<String>>();
    }
    
    public void instantiateFieldPicklist(){
        System.debug('Function: instantiateFieldPicklist');
        isPicklist = new Map<String, Boolean>();
        prepareDatePicklistFields();
        prepareisPicklist(selectedobj);
        prepareisFiltered(selectedobj);
        getpicklistoptions(selectedobj);
    }
    
    public void prepareDatePicklistFields(){
        System.debug('Function: prepareDatePicklistFields');
        DateFieldOptions = new List<SelectOption>();
        for(String d: dateType(selectedObj)){
            DateFieldOptions.add(new SelectOption(d, Schema.getGlobalDescribe().get(selectedObj).getDescribe().fields.getMap().get(d).getDescribe().getLabel(), !Schema.getGlobalDescribe().get(selectedObj).getDescribe().fields.getMap().get(d).getDescribe().isAccessible()));
        }
        for(String d: dateTimeType(selectedObj)){
            if(d != 'createdDate')
                DateFieldOptions.add(new SelectOption(d, Schema.getGlobalDescribe().get(selectedObj).getDescribe().fields.getMap().get(d).getDescribe().getLabel()));
        }
        DateFieldOptions = selectOptionSortByLabel(DateFieldOptions);
        DateFieldOptions.add(0, new SelectOption('createdDate', 'Created Date', !Schema.getGlobalDescribe().get(selectedObj).getDescribe().fields.getMap().get('createddate').getDescribe().isAccessible()));
    }

    public void prepareisPicklist(String selectedobj){
        System.debug('Function: prepareisPicklist');
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(selectedobj);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        for (String fieldName: fieldMap.keySet()) {
            Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
            isPicklist.put(fieldName, fielddataType == Schema.DisplayType.PICKLIST);
        }
    }
    
    public void prepareisFiltered(String selectedobj){
        System.debug('Function: prepareisFiltered');
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(selectedobj);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        for (String fieldName: fieldMap.keySet()) {
            Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
            if(fielddataType == Schema.DisplayType.PICKLIST){
                isFiltered.put(fieldName, false);
            }
            
        }
    }
    
    public void getpicklistoptions(String selectedobj){ 
        System.debug('Function: getpicklistoptions');
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(selectedobj);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap(); 
        for (String fieldName: fieldMap.keySet()) {
            Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
            if(fielddataType == Schema.DisplayType.PICKLIST){
                picklistOptions.put(fieldName, getPickValues(Schema.getGlobalDescribe().get(selectedobj), fieldName,null));
            }
            
        }
        
    }
   
    public List<selectOption> getPickValues(Schema.sObjectType sobject_type, String field_name, String first_val) {
        System.debug('Function: getPickValues');
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        if (first_val != null) { //if there is a first value being provided
            options.add(new selectOption(first_val, first_val)); //add the first option
        }
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            
            options.add(new selectOption(a.getValue(), a.getLabel())); //add the value and label to our final list
        }
        return options;
    }
    
    public String helpQuery(List<String> phoneFields, List<String> emailFields, String searchTerm){
        System.debug('Function: helpQuery');
        String query='', searchphone='', phonePlus='';
        searchTerm = searchTerm.subString(0,searchTerm.length()-1);
        phoneplus= searchPhone =searchTerm;
        if(searchTerm.isNumeric()){
            
            if(searchterm.length() > 3){
                
                searchphone = '(' + searchTerm.subString(0,3) + ') ' + searchTerm.substring(3,searchTerm.length());
                phoneplus = '%' + phonePlus.subString(0,3)+' '+phonePlus.subString(3,phonePlus.length()) + '%';
                
            }
            else
            {
                phoneplus = phoneplus + '%';
                searchphone = '(' + searchTerm.subString(0,searchTerm.length());
            }
            if(searchTerm.length() >7){
                
                searchphone = Searchphone.subString(0,9) + '-' + searchTerm.subString(6, searchTerm.length());
                
            }
        }
        searchphone = searchphone + '%';
        SearchTerm =searchTerm + '%';
        if(phoneFields!=null && phoneFields.size() > 0){
            
            for(integer i=0 ; i < phoneFields.size();i++){
                query += (' OR  ' + phoneFields[i] + ' LIKE ' + '\'' + searchTerm + '\' OR ' + phoneFields[i] + ' LIKE ' + '\'' + searchTerm + '\''  + ' OR  ' + phoneFields[i] + ' LIKE ' + '\'' + searchphone + '\' OR '  + phoneFields[i] + ' LIKE ' + '\'' + phonePlus + '\'');
            }
        }
        
        SearchTerm =searchTerm + '%';
        if(emailfields!=null && emailfields.size() > 0){
            
            for(integer i=0 ; i < emailFields.size() ; i++){
                query += (' OR  ' + emailFields[i] + ' LIKE ' + '\'' + searchTerm + '\'');
            }
        }
        
        return (query + ') ');
        
    }
    
    public String helpPickQuery(Map<String, PicklistHandler> m){
        System.debug('Function: helpPickQuery');
        String query = '';
        List<String> listvalue = new List<String>();
        if(!m.isEmpty()){
            Set<String> key = m.keySet();
            boolean flag = true;
            for(String key1:key){
                if(key1 != null){
                    listvalue = getStringValues(m.get(key1).rtPickOptions);
                    if(listvalue != null && !listvalue.isEmpty()){
                        if(flag){
                            query+=' AND (';
                            flag =false;
                        }
                        for(String value :listvalue){
                            
                            query += key1 + '=' + '\'' + value + '\'  OR ';
                        }
                        query = query.substring(0,query.lastIndexOf('OR'));
                        query += ' ) AND ( ';
                    }
                }
                
            }
            if(query.lastIndexOf(' ) AND ( ')!=-1){
                query = query.substring(0,query.lastIndexOf(' ) AND'));
                query += ')';
            }
            
        }
        return query;
    }
    
    
    public String helpPickQueryFront(Map<String, PicklistHandler> m){
        System.debug('Function: helpPickQueryFront');
        String query = '';
        List<String> listvalue = new List<String>();
        if(!m.isEmpty()){ 
            
            Set<String> key = m.keySet();
            boolean flag = true;
            for(String key1:key){
                if(key1 != null){
                    listvalue = getStringValues(m.get(key1).rtPickOptions);
                    if(listvalue != null && !listvalue.isEmpty()){
                        if(flag){
                            query+=' WHERE (';
                            flag =false;
                        }
                        
                        
                        for(String value :listvalue){
                            
                            query += key1 + '=' + '\'' + value + '\'  OR ';
                        }
                        
                        query = query.substring(0,query.lastIndexOf('OR'));
                        query += ' ) AND ( ';
                    }
                }
            }
            if(query.lastIndexOf(' ) AND ( ')!=-1){
                query = query.substring(0,query.lastIndexOf(' ) AND'));
                Query += ')';
            }
            
        }
        return query;
    }
    
    public List<String> getStringValues(List<SelectOption> so){
        System.debug('Function: getStringValues');
        List<String> st = new List<String>();
        if(so != null || !so.isEmpty()){
            for(SelectOption s: so){
                st.add(s.getValue());
            }
        }
        return st;
    }
    
    public void showPicklistPopup(){
        System.debug('Function: showPicklistPopup');
        if(((PickOptions == null || PickOptions.isEmpty()) || (!PickOptions.keySet().contains(pickedFld))) && picklistOptions != null){
            PicklistHandler ph = new PicklistHandler();
            ph.ltPickOptions.addAll(picklistOptions.get(pickedFld));
            PickOptions.put(pickedFld, ph);
            storedPickOptions = new Map<String, PickListHandler>();
            storedPickOptions.put(pickedFld, new PickListHandler(PickOptions.get(pickedFld).ltPickOptions, PickOptions.get(pickedFld).rtPickOptions));
        }else{
            storedPickOptions = new Map<String, PickListHandler>();
            storedPickOptions.put(pickedFld, new PickListHandler(PickOptions.get(pickedFld).ltPickOptions, PickOptions.get(pickedFld).rtPickOptions));
        }
        displayPicklistPopup = true;
    }
    
    public void FilterPicklistPopup() {
        System.debug('Function: FilterPicklistPopup');
        List<String> rgtPickValues = new List<String>();
        for(SelectOption so: PickOptions.get(pickedFld).rtPickOptions){
            rgtPickValues.add(so.getValue());
        }
        mapPickValues.put(pickedFld, rgtPickValues);
        if(rgtPickValues.size() > 0){
            isFiltered.put(pickedFld, true);
        }else{
            isFiltered.put(pickedFld,false);
        }
        instantiateMainObjLst();
        displayPicklistPopup = false;    
    }
    
    public void closePicklistPopup() {
        System.debug('Function: closePicklistPopup');
        if(storedPickOptions != null && storedPickOptions.containsKey(pickedFld)){
            PickOptions.put(pickedFld, storedPickOptions.get(pickedFld));
            storedPickOptions.clear();
        }
        displayPicklistPopup = false;    
    }
    
    public List<String> phoneFields(String selectedobj){
        
        System.debug('Function: phoneFields');
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        
        Schema.SObjectType leadSchema = schemaMap.get(selectedobj);
        
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        
        List<String> phoneLst = new List<String>();
        
        for (String fieldName: fieldMap.keySet()) {
            
            Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
            
            if(fielddataType == Schema.DisplayType.PHONE){
                phoneLst.add(fieldName);
            }
            
        }
        return phoneLst;
    }
    
    public List<String> emailFields(String selectedobj){
        
        System.debug('Function: emailFields');
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        
        Schema.SObjectType leadSchema = schemaMap.get(selectedobj);
        
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        
        List<String> emailLst = new List<String>();
        
        for (String fieldName: fieldMap.keySet()) {
            
            Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
            
            if(fielddataType == Schema.DisplayType.EMAIL){
                emailLst.add(fieldName);
            }
            
        }
        return emailLst;
    }
    
    public void instantiateselectedFilterFormatForData(){
        System.debug('Function: instantiateselectedFilterFormatForData');
        selectedFilterFormatForData=new List<Selectoption>();
        selectedFilterFormatForData.add(new selectOption('', '--Select--'));
        selectedFilterFormatForData.add(new selectOption('AllTime', 'AllTime'));
        selectedFilterFormatForData.add(new selectOption('<', '<'));
        selectedFilterFormatForData.add(new selectOption('>', '>'));
        selectedFilterFormatForData.add(new selectOption('<=', '<='));
        selectedFilterFormatForData.add(new selectOption('>=', '>='));
        selectedFilterFormatForData.add(new selectOption('=', '='));
        selectedFilterFormatForData.add(new selectOption('Today', 'Today'));
        selectedFilterFormatForData.add(new selectOption('YESTERDAY', 'Yesterday'));
        selectedFilterFormatForData.add(new selectOption('TOMORROW', 'Tomorrow'));
        selectedFilterFormatForData.add(new selectOption('THIS_WEEK', 'This Week'));
        selectedFilterFormatForData.add(new selectOption('LAST_WEEK', 'Last Week'));
        selectedFilterFormatForData.add(new selectOption('NEXT_WEEK', 'Next Week'));
        selectedFilterFormatForData.add(new selectOption('THIS_MONTH', 'This Month'));
        selectedFilterFormatForData.add(new selectOption('LAST_MONTH', 'Last Month'));
        selectedFilterFormatForData.add(new selectOption('NEXT_MONTH', 'Next Month'));
        selectedFilterFormatForData.add(new selectOption('LAST_90_DAYS', 'Last 90 Days'));
        selectedFilterFormatForData.add(new selectOption('NEXT_90_DAYS', 'Next 90 Days'));
        selectedFilterFormatForData.add(new selectOption('LAST_N_DAYS:180', 'Last 180 Days'));
        selectedFilterFormatForData.add(new selectOption('NEXT_N_DAYS:180', 'Next 180 Days'));
        selectedFilterFormatForData.add(new selectOption('THIS_QUARTER', 'This Quarter')); 
        selectedFilterFormatForData.add(new selectOption('LAST_QUARTER', 'Last Quarter'));
        selectedFilterFormatForData.add(new selectOption('NEXT_QUARTER', 'Next Quarter')); 
        selectedFilterFormatForData.add(new selectOption('THIS_YEAR', 'This Year'));
        selectedFilterFormatForData.add(new selectOption('NEXT_YEAR', 'Next Year'));
    }

    public void instantiatePageSizeSelectPicklist(){
        System.debug('Function: instantiatePageSizeSelectPicklist');
        PageSizeOptions = new List<SelectOption>();
        PageSizeOptions.add(new SelectOption('10', '10'));
        PageSizeOptions.add(new SelectOption('25', '25'));
        PageSizeOptions.add(new SelectOption('50', '50'));
        PageSizeOptions.add(new SelectOption('100', '100'));
    }
    
    public void getSelObjFields()
    {   
        System.debug('Function: getSelObjFields');
        if(selectedObj != null && selectedObj != 'None'){
            isObjectSelected = true;
        }
        if(checkForName(getNameUniqueField(selectedObj))){
            mainField = 'name';
        }else{
            mainField = getNameUniqueField(selectedObj)[0];   
        }
        mainselectedFld.clear();
        rightOptions.clear();
        renderMainTable = false;
        mainselectedFldOptions.clear();
        if (selectedobj != null){
            Schema.DescribeSObjectResult  dfr = allobj.get(selectedobj).getDescribe();
            selobjmap =dfr.fields.getMap();
            fieldnames= new List<string>();
            allMainFieldOptions=new List<selectoption>();
            for(String s: selobjmap.keySet()){
                if(!checkValidFieldType(selectedObj, s)){
                    fieldnames.add(s);
                }
            }
            fieldnames.sort();
            for(string s1:fieldnames)
            {
                allMainFieldOptions.add(new selectoption(s1, selobjmap.get(s1).getDescribe().getLabel()));
            }
            allMainFieldOptions = selectOptionSortByLabel(allMainFieldOptions);
        }
        initializeMainAndRelated1();
    }
    
    public Boolean checkForName(List<String> fld){
        Boolean flag = false;
        for(String f: fld){
            if(f == 'Name'){
                flag = true;
                break;
            }
        }
        return flag;
    }
  
    public List<selectOption> selectOptionSortByLabel(List<selectOption> selectOptionsToSort) {
        
        System.debug('Function: selectOptionSortByLabel');        
        if(selectOptionsToSort == null || selectOptionsToSort.size() <= 1){
            return selectOptionsToSort;
        }
        List<SelectOption> lessSelectOption = new List<SelectOption>();
        List<SelectOption> greaterSelectOption = new List<SelectOption>();
        integer pivot = selectOptionsToSort.size() / 2;
        
        //save the pivot and remove it from the selectOption list
        SelectOption pivotValue = selectOptionsToSort[pivot];
        selectOptionsToSort.remove(pivot);
        for(selectOption SO : selectOptionsToSort){
            if(SO.getLabel() <= pivotValue.getLabel()){
                lessSelectOption.add(SO);
            }else if(SO.getLabel() > pivotValue.getLabel()){
                greaterSelectOption.add(SO);   
            }
        }
        list<selectOption> sortedSelectOptions = new list<selectOption>(); 
        sortedSelectOptions.addAll(selectOptionSortByLabel(lessSelectOption));
        sortedSelectOptions.add(pivotValue);
        sortedSelectOptions.addAll(selectOptionSortByLabel(greaterSelectOption));
        return SortedSelectOptions;
    }
    
    public List<selectOption> selectOptionSortByValue(List<selectOption> selectOptionsToSort){
        System.debug('Function: selectOptionSortByValue');
        if(selectOptionsToSort == null || selectOptionsToSort.size() <= 1){
            return selectOptionsToSort;
        }       
        List<SelectOption> lessSelectOption = new List<SelectOption>();
        List<SelectOption> greaterSelectOption = new List<SelectOption>();
        integer pivot = selectOptionsToSort.size() / 2;
         
        //save the pivot and remove it from the selectOption list
        SelectOption pivotValue = selectOptionsToSort[pivot]; 
        selectOptionsToSort.remove(pivot);
        for(selectOption SO : selectOptionsToSort){
            if(SO.getValue() <= pivotValue.getValue()){
                lessSelectOption.add(SO);
            }else if(SO.getValue() > pivotValue.getValue()){
                greaterSelectOption.add(SO);   
            }
        }
        list<selectOption> SortedSelectOptions = new list<selectOption>(); 
        SortedSelectOptions.addAll(selectOptionSortByValue(lessSelectOption));
        SortedSelectOptions.add(pivotValue);
        SortedSelectOptions.addAll(selectOptionSortByValue(greaterSelectOption));
        return SortedSelectOptions;
    }
    
    public Boolean getRenderComponent(){
        System.debug('Function: getRenderComponent');
        if(selectedobj == null || selectedobj == '' || selectedobj == 'None'){
            return true;
        }else{
            return true;
        }
    }
    
    public PageReference SavePopup() {
        System.debug('Function: SavePopup');
        mainselectedFld.clear();
        for(SelectOption so: mainselectedFldOptions){
            mainselectedFld.add(so.getValue());
        }
        if(mainselectedFld != null && !mainselectedFld.isEmpty()){
            isFieldSelected = true;
        }
        initializeMainAndRelated2();
        return null;
    }
    
    public boolean checkBoxVal{get;set;}
    public boolean displayPopup{get;set;}
    
    public pageReference method(){
        System.debug('Function: method');
        displayPopup = true;
        
        return null;
    }
    
    @testVisible private void setOptions(SelectOption[] options, String value) {
        System.debug('Function: setOptions');
        options.clear();
        String[] parts = value.split('&');
        for (Integer i=0; i<parts.size()/2; i++) {
            options.add(new SelectOption(EncodingUtil.urlDecode(parts[i*2], 'UTF-8'), 
                                         EncodingUtil.urlDecode(parts[(i*2)+1], 'UTF-8')));
        }
    }
    
    // Backing for hidden text field containing the options from the
    // left list
    public String leftOptionsHidden { get; set {    
        leftOptionsHidden = value;
            setOptions(leftOptions, value);
        }
    }
    
    // Backing for hidden text field containing the options from the
    // right list
    public String rightOptionsHidden { get; set {   
        rightOptionsHidden = value;
            setOptions(rightOptions, value);
        }
    }
    
    public void instantiateMainObjLst(){
        System.debug('Function: instantiateMainObjLst');
        List<MainRecordWrapperClass> store = mainObjLst;
        String oldQuery = mainquery;
        mainquery = getQuery();
        mainObjLst = new List<MainRecordWrapperClass>();
        isMainSelectAll = false;
        
        if(mainSelectedFld.size() > 0 && mainSelectedFld.size() <= 20){
            renderMainTable = true;
            for(String fld: mainSelectedFld){
                if(Schema.getGlobalDescribe().get(selectedObj).getDescribe().fields.getMap().get(fld).getDescribe().getType() == Schema.DisplayType.CURRENCY){
                    Decimal d = (Decimal)(Database.query('SELECT Sum(' + fld + ') FROM ' + selectedObj))[0].get('expr0');
                    if(d == null){
                        d = 0;
                    }
                    sumOfCurrency.put(fld, d.setScale(2));
                }else{
                    sumOfCurrency.put(fld, null);
                }
            }
            
        }else{
            renderMainTable = false;
        }
        if(Paging == null){
            Paging = new ListCollection();
        }
        Boolean isLargePageSize = false;
        
        if(this.PAGE_SIZE != Paging.PageSize && this.PAGE_SIZE >= 50){
            isLargePageSize = true;
        }
        
        Paging.PageSize = this.PAGE_SIZE;
        Paging.limitvalue = QUERY_LIMIT; /// Final value
        Paging.dtStart = this.dtStart;
        Paging.dtEnd = this.dtEnd;
        Paging.dat = this.dat;
        Paging.field = getNameUniqueField(selectedObj)[0];
        Paging.order = 'ASC';
        overAllSize = (integer)database.query('SELECT Count(ID) FROM ' + selectedObj)[0].get('expr0');
        try{
            String myQuery = mainquery;
            if(myQuery.containsIgnoreCase('ORDER')){
                myQuery = 'SELECT Count(Id) ' + myQuery.substring(myQuery.indexOfIgnoreCase('FROM'), myQuery.indexOfIgnoreCase(' ORDER'));
            }else if(myQuery.containsIgnoreCase('LIMIT')){
                myQuery = 'SELECT Count(Id) ' + myQuery.substring(myQuery.indexOfIgnoreCase('FROM'), myQuery.indexOfIgnoreCase(' LIMIT'));
            }else{
                myQuery = 'SELECT Count(Id) ' + myQuery.substring(myQuery.indexOfIgnoreCase('FROM'));
            }
            paging.mainSize = (integer)database.query(myQuery)[0].get('expr0');
            Paging.query = mainquery;
            Paging.mysObjData = Database.query(mainquery);
            if(isUpdateDeleteQuery){
                isUpdateDeleteQuery = false;
            }else{
                Paging.moveFirst();
            }   
            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There was some problem with the Query'));
            mainquery = oldQuery;
            String myQuery = mainquery;
            if(myQuery.containsIgnoreCase('ORDER')){
                myQuery = 'SELECT Count(Id) ' + myQuery.substring(myQuery.indexOfIgnoreCase('FROM'), myQuery.indexOfIgnoreCase(' ORDER'));
            }else if(myQuery.containsIgnoreCase('LIMIT')){
                myQuery = 'SELECT Count(Id) ' + myQuery.substring(myQuery.indexOfIgnoreCase('FROM'), myQuery.indexOfIgnoreCase(' LIMIT'));
            }else{
                myQuery = 'SELECT Count(Id) ' + myQuery.substring(myQuery.indexOfIgnoreCase('FROM'));
            }
            paging.mainSize = (integer)database.query(myQuery)[0].get('expr0');
            Paging.query = mainquery;
            Paging.mysObjData = Database.query(mainquery);
            if(isUpdateDeleteQuery){
                isUpdateDeleteQuery = false;
            }else{
                Paging.moveFirst();
            } 
        }
        //Paging.getmyData(Paging.sortsObject(Paging.mysObjData, Paging.field, paging.order));
        Paging.getmyData(Paging.mysObjData);
        
        if(isLargePageSize){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'Page size is too large. Make sure the size is less than 50 for smoother experience'));
        }

    }
    
    public void instantiaterelatedObjectLst(){
        System.debug('Function: instantiaterelatedObjectLst');
        relatedObjectLst = new Map<String, sObject>();
        for(String s: getAllRelatedObject(selectedObj)){
            relatedObjectLst.put(s, ConvertTosObject(s));
        }
    }

    public Boolean isFieldPresent(String obj, String fld){
        Boolean result = false;
        for(String f: Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().keySet()){
            if(fld == f){
                result = true;
                break;
            }
        }
        return result;
    }

    public List<String> getAllRelatedObject(String obj){
        System.debug('Function: getAllRelatedObject');
        Set<String> rObjLst = new Set<String>();
        for (Schema.ChildRelationship cr: Schema.getGlobalDescribe().get(obj).getDescribe().getChildRelationships()) 
        {
            if(cr.getRelationshipName() != null)
                rObjLst.add(String.valueOf(cr.getChildSObject()));
        }
        /*List<String> l = new List<String>();
        for(String s: ){
            if(s.endsWithIgnoreCase('__c')){
                l.add(getObjectLabel(s));
            }else{
                l.add(s);
            }
        }*/
        return filterObjectList(new List<String>(rObjLst));
    }
    
    public List<String> getAllRelatedObjectWithRelationshipName(String obj){
        System.debug('Function: getAllRelatedObjectWithRelationshipName');
        Set<String> rObjLst = new Set<String>();
        for (Schema.ChildRelationship cr: Schema.getGlobalDescribe().get(obj).getDescribe().getChildRelationships()) 
        {
            if(getAllRelatedObject(obj).contains(String.valueOf(cr.getChildSObject())) && cr.getRelationshipName() != null)
                rObjLst.add(cr.getRelationshipName());
        }
        return new List<String>(rObjLst);
    }
    
     public List<String> filterObjectList(List<String> objLst){
        System.debug('Function: filterObjectList');
        List<String> mainLst = new List<String>{'Account', 'Asset', 'Campaign', 'Case', 'Contact',
                                                'Contract', 'Opportunity', 'Order',
                                                'Product', 'Solution', 'Task', 'Event'};
        mainLst.addAll(getAllCustomSObjects());
        //List<String> mainLst = new List<String>{'Account', 'Contact', 'Opportunity', 'Task', 'Event',
        //                                      'Lead', 'Case'};
        Set<String> setObjLst = new Set<String>(objLst);
        setObjLst.retainAll(mainLst);
        List<String> l = new List<String>(setObjLst);
        List<String> toReturn = new List<String>();
        for(String o: l){
             if(isObjectPresent(o)){
                 toReturn.add(o);
             }
        }
        return toReturn;
    }
    
    public Boolean isObjectPresent(String obj){
        Boolean result = false;
        for(String o: Schema.getGlobalDescribe().keyset()){
            if(o == obj){
                result = true;
                break;
            }
        }
        return result;
    }
    
    public static List<String> getAllCustomSObjects()
    {
        System.debug('Function: getAllCustomSObjects');
        List<String> sObjectList = new List<String>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
        {
            Schema.DescribeSObjectResult describeSObjectResultObj = objTyp.getDescribe();
            if(describeSObjectResultObj.isCustom())
            {
                String name = objTyp.getDescribe().getName();
                // Exclude all the unwanted Sobjects e.g. History, Share etc..
                if(!name.containsignorecase('history') && !name.containsignorecase('tag')&&
                   !name.containsignorecase('share') && !name.containsignorecase('feed'))
                {
                    SobjectList.add(name);
                }
            }
        }
        return sObjectList;
    }
    
    public static String getObjectLabel(String objName)
    {
        System.debug('Function: getAllCustomSObjects');
        String lab = '';
        List<String> sObjectList = new List<String>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
        {
            String name = objTyp.getDescribe().getName();
            if(name == objName){
                lab = objTyp.getDescribe().getLabel();
            }
        }
        return lab;
    }
    
    public List<String> getAllFields(String obj){
        System.debug('Function: getAllFields');
        return new List<String>(Schema.getGlobalDescribe().get(obj).getDescribe().fields.getmap().keyset());
    }
    
    public List<String> getRequiredFields(String obj){
        System.debug('Function: getRequiredFields');
        List<String> reqfields = new List<String>();
        for(String fld: Schema.getGlobalDescribe().get(obj).getDescribe().fields.getmap().keyset()){
            if(isRequired(obj, fld)){
                reqfields.add(fld);
            }
        }
        return reqfields;
    }
    
    public List<String> getDefaultFields(String obj){
        System.debug('Function: getDefaultFields');
        List<String> defld = new List<String>();
        if(obj == 'Account'){
            defld = new List<String>{'Name', 'AccountNumber', 'Phone', 'Rating', 'Type', 'Industry'};
        }else if(obj == 'Asset'){
            defld = new List<String>{'Name', 'Product2Id', 'Price', 'Quantity', 'AccountId', 'ContactId'};
        }else if(obj == 'Campaign'){
            defld = new List<String>{'Name', 'isActive', 'Type', 'Status', 'StartDate', 'EndDate'};
        }else if(obj == 'Case'){
            defld = new List<String>{'CaseNumber', 'OwnerId', 'AccountId', 'ContactId', 'Status', 'Priority', 'Origin'};
        }else if(obj == 'Contact'){
            defld = new List<String>{'Name', 'AccountId', 'Phone', 'Email'};
        }else if(obj == 'Contract'){
            defld = new List<String>{'AccountId', 'Status', 'StartDate', 'ContractTerm'};
        }else if(obj == 'Lead'){
            defld = new List<String>{'FirstName', 'LastName', 'Company', 'LeadSource'};
        }else if(obj == 'Opportunity'){
            defld = new List<String>{'Name', 'Amount', 'Probability', 'StageName', 'CloseDate', 'ForecastCategoryName'};
        }else if(obj == 'Order'){
            defld = new List<String>{'AccountId', 'ContractId', 'Status', 'EffectiveDate', 'Type'};
        }else if(obj == 'Product'){
            defld = new List<String>{'Name', 'isActive', 'Family'};
        }else if(obj == 'Solution'){
            defld = new List<String>{'SolutionName', 'isPublished', 'SolutionNumber', 'Status'};
        }else if(obj == 'User'){
            defld = new List<String>{'FirstName', 'LastName', 'Alias', 'Email', 'UserName', 'CommunityNickname'};
        }else if(obj == 'Task'){
            defld = new List<String>{'Subject', 'WhoId', 'WhatId', 'Status', 'ActivityDate', 'Type'};
        }else if(obj == 'Event'){
            defld = new List<String>{'Subject', 'StartDateTime', 'EndDateTime', 'ActivityDate', 'whoId', 'whatId'};
        }
        else{
            defld = getNameUniqueField(obj);
        }
        List<String> toReturn = new List<String>();
        for(String f: defld){
            if(isFieldPresent(obj, f)){
                toReturn.add(f);
            }
        }
        return toReturn;
    }
    
    public Boolean isRequired(String obj, String fld){
        System.debug('Function: isRequired');
        return !Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().get(fld).getDescribe().isNillable();
    }
    
    public List<String> getNameUniqueField(String objType)
    {   System.debug('Function: getNameUniqueField');
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
    
    public string getNameQuery(String obj)
    {   System.debug('Function: getNameQuery');
        String query;
        List<String> strResult =  getNameUniqueField(obj);
        for(String s :strresult){
            if(query==null)
                query=s;
            else
                query += ' OR Name Like ' +s;
        }
        return query;
    }
    
    public List<String> dateType(String obj){
        List<String> DatStr = new List<String>();
        String type=obj;
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        for (String fieldName: fieldMap.keySet()) {
            
            //It provides to get the object fields label.
            
            String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
            
            //It provides to get the object fields data type.
            
            Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
            if(fielddataType == Schema.DisplayType.Date)
                
                datstr.add(fieldname);
            
        }
        return datstr;
    }
    
    
    public List<String> dateTimeType(String obj){
        System.debug('Function: dateTimeType');
        List<String> DatStr = new List<String>();
        String type=obj;
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        for (String fieldName: fieldMap.keySet()) {
            
            //It provides to get the object fields label.
            
            String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
            
            //It provides to get the object fields data type.
            
            Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
            if(fielddataType == Schema.DisplayType.DateTime)
                
                datstr.add(fieldname);
            
        }
        return datstr;
    }
    
    
    public Boolean fieldDataType(String fld , string obj){
        System.debug('Function: fieldDataType');
        boolean status;
        List<String> sDate = dateType(obj);
        List<String> sDateTime = dateTimeType(obj);
        if(sdate.contains(fld.toLowerCase()))
            status = true;
        else if(sdateTime.contains(fld.toLowerCase()))
            status = false;
        return status; 
    }
    
    public String getQuery(){
        System.debug('Function: getQuery');

        Set<String> s = new Set<String>(mainSelectedFld);
        
        s.addAll(getNameUniqueField(selectedObj));
        
        String query = 'SELECT ' + String.join(new List<String>(s), ', ') + ' FROM ' + selectedObj;
        
        String name;
        
        dat = dateObj.myDate__c;
 
        //if((dateFormat==null || dateFormat=='') && dat != null) dateFormat = '=';
            
        Boolean a1 = (mainSearch != null &&  mainSearch != '');
        Boolean a2 = (mainSearch == null ||  mainSearch == '');
        Boolean b1 = (PickOptions != null && !PickOptions.isEmpty() && helpPickQueryFront(Pickoptions) !='');
        Boolean b2 = (PickOptions == null ||  PickOptions.isEmpty() || helpPickQueryFront(Pickoptions)=='');
        Boolean c1 = (dateFormat != null &&  dateFormat != '');
        Boolean c2 = (dateFormat == null ||  dateFormat == '');
        Boolean d1 = (dat != null);
        Boolean d2 = (dat == null);
        if(a1){
            mainSearch = mainSearch.normalizeSpace();
            //mainSearch = adjustSearchTerm(mainSearch);
            if(mainSearch.length() > 2){
                name = '%'+mainSearch+'%';
            }else{
                name = mainSearch+'%';
            }
            
        }
        
        if(a2 && b2 && c2 && d2){
            
            System.debug('##1');
            
        }else if(a2 && b2 && c2 && d1){
            
            System.debug('##2');
            if(!fielddataType(datefldPicklist, selectedObj)){
            Time timeStart = Time.newInstance(0, 0, 0, 0); // Start of Day
            Time timeEnd = Time.newInstance(23, 59, 59, 999); // End of Day
            dtStart = DateTime.newInstance(dat, timeStart);
            dtEnd = DateTime.newInstance(dat, timeEnd);
            query += ' WHERE ' + dateFldPicklist + ' >= :dtStart' + ' AND ' + dateFldPicklist + ' <=  :dtEnd';
            }
            else{
                System.debug('##3');
            query += ' WHERE ' + dateFldPicklist + ' = :dat';
            }
                
        }else if(a2 && b2 && c1 && d2){
            
            if(dateFormat == 'AllTime'){
                
                System.debug('##4');
                
            }
            else if(dateFormat != '<' && dateFormat != '<=' && dateFormat != '>' && dateFormat != '>=' && dateFormat != '='){
                
                System.debug('##5');
                query += ' WHERE  ' + dateFldPicklist + ' = ' + dateFormat;
                
            }else{
                
                System.debug('##6');
                
            }
            
        }else if(a2 && b2 && c1 && d1){
            
            if(dateFormat=='AllTime')
            {
                System.debug('##7');
                
            }
            else  if(dateFormat=='>=')
            {
                System.debug('##8');
                query += ' WHERE  ' + dateFldPicklist + ' >= :dat';
                
            }
            else if(dateFormat=='<=')
            {
                System.debug('##9');
                query += ' WHERE  ' + dateFldPicklist + ' <= :dat';
                
            }
            else if(dateFormat=='<')
            {
                System.debug('##10');
                System.debug('dat: ' + dat);
                query += ' WHERE  ' + dateFldPicklist + ' < :dat';
                
            }
            else if(dateFormat=='>')
            {
                System.debug('##11');
                query += ' WHERE  ' + dateFldPicklist + ' > :dat';
                
            }
            else if(dateFormat=='=')
            {
                System.debug('##12');
                if(!fielddataType(datefldPicklist, selectedObj)){
                Time timeStart = Time.newInstance(0, 0, 0, 0); // Start of Day
                Time timeEnd = Time.newInstance(23, 59, 59, 999); // End of Day
                dtStart = DateTime.newInstance(dat, timeStart);
                dtEnd = DateTime.newInstance(dat, timeEnd);
                query += ' WHERE  ' + dateFldPicklist + ' >= :dtStart AND ' + dateFldPicklist + ' <= :dtEnd';
                }else{
                    System.debug('##12.2');
                    query += ' WHERE ' + dateFldPicklist + ' = :dat';
                }
            }
            else
            {
                System.debug('##13');
                query += ' WHERE ' + dateFldPicklist + ' = ' + dateFormat;  
            }
            
        }else if(a2 && b1 && c2 && d2){
            
            System.debug('##14');
            query += helpPickQueryFront(PickOptions);
            
        }else if(a2 && b1 && c2 && d1){
            
            //Future Implementation
            System.debug('##15');
            query += helpPickQueryFront(PickOptions);
            
        }else if(a2 && b1 && c1 && d2){
            
            if(dateFormat == 'AllTime'){
                
                System.debug('##16');
                query += helpPickQueryFront(PickOptions);
                
            }
            else if(dateFormat != '<' && dateFormat != '<=' && dateFormat != '>' && dateFormat != '>='){
                
                System.debug('##17');
                query += helpPickQueryFront(PickOptions)  + ' AND ' + dateFldPicklist + ' = ' + dateFormat;
                
            }else{
                
                System.debug('##18');
                System.debug('This ');
                query += helpPickQueryFront(PickOptions);
                
            }
            
        }else if(a2 && b1 && c1 && d1){
            
            if(dateFormat=='AllTime')
            {
                System.debug('##19');
                query += helpPickQueryFront(PickOptions);
                
            }
            else  if(dateFormat=='>=')
            {
                System.debug('##20');
                query += helpPickQueryFront(PickOptions)  + ' AND ' + dateFldPicklist + ' >= :dat';
                
            }
            else if(dateFormat=='<=')
            {
                System.debug('##21');
                query += helpPickQueryFront(PickOptions)  + ' AND ' + dateFldPicklist + ' <= :dat';
                
            }
            else if(dateFormat=='<')
            {
                System.debug('##22');
                query += helpPickQueryFront(PickOptions)  + ' AND ' + dateFldPicklist + ' < :dat';
                
            }
            else if(dateFormat=='>')
            {
                System.debug('##23');
                query += helpPickQueryFront(PickOptions) + ' AND ' + dateFldPicklist + ' > :dat';
                
            }
            else if(dateFormat=='=')
            {
                System.debug('##24');
                System.debug(fielddataType(datefldPicklist, selectedObj));
                if(!fielddataType(datefldPicklist, selectedObj)){
                Time timeStart = Time.newInstance(0, 0, 0, 0); // Start of Day
                Time timeEnd = Time.newInstance(23, 59, 59, 999); // End of Day
                dtStart = DateTime.newInstance(dat, timeStart);
                dtEnd = DateTime.newInstance(dat, timeEnd);
                query += helpPickQueryFront(PickOptions)  + ' AND (' + dateFldPicklist + ' >= :dtStart AND ' + dateFldPicklist + ' <= :dtEnd)';
                }
                else{
                    System.debug('##24.2');
                    query += ' WHERE ' + dateFldPicklist + ' = :dat';
                }
                
            }
            else
            {
                System.debug('##25');
                query += helpPickQueryFront(PickOptions)  + ' AND ' + dateFldPicklist + ' = ' + dateFormat;
            }
            
        }else if(a1 && b2 && c2 && d2){
            
            System.debug('##26');
            query += ' WHERE (' + getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name);
            
        }else if(a1 && b2 && c2 && d1){
            
            // Future Implementation
            System.debug('##27');
            query += ' WHERE (' + getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name);
            
            
        }else if(a1 && b2 && c1 && d2){
            
            if(dateFormat == 'AllTime'){
                
                System.debug('##28');
                query += ' WHERE (' + getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name);
                
            }
            else if(dateFormat != '<' && dateFormat != '<=' && dateFormat != '>' && dateFormat != '>='){
                
                System.debug('##29');
                query += ' WHERE (' + getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + ' AND ' + dateFldPicklist + ' = ' + dateFormat;
                
            }else{
                
                System.debug('##30');
                query += ' WHERE (' + getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name);
                
            }                        
            
        }else if(a1 && b2 && c1 && d1){
            
            if(dateFormat=='AllTime')
            {
                System.debug('##31');
                query += ' WHERE (' + getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name);
                
            }
            else  if(dateFormat=='>=')
            {
                System.debug('##32');
                query += ' WHERE (' + getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + ' AND ' + dateFldPicklist + ' >= :dat';
                
            }
            else if(dateFormat=='<=')
            {
                System.debug('##33');
                query += ' WHERE (' + getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + ' AND ' + dateFldPicklist + ' <= :dat';
                
            }
            else if(dateFormat=='<')
            {
                System.debug('##34');
                query += ' WHERE (' + getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + ' AND ' + dateFldPicklist + ' < :dat';
                
            }
            else if(dateFormat=='>')
            {
                System.debug('##35');
                query += ' WHERE (' + getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + ' AND ' + dateFldPicklist + ' > :dat';
                
            }
            else if(dateFormat=='=')
            {
                System.debug('##36');
                System.debug(datefldPicklist);
                if(!fielddataType(datefldPicklist, selectedObj)){
                Time timeStart = Time.newInstance(0, 0, 0, 0); // Start of Day
                Time timeEnd = Time.newInstance(23, 59, 59, 999); // End of Day
                dtStart = DateTime.newInstance(dat, timeStart);
                dtEnd = DateTime.newInstance(dat, timeEnd);
                query += ' WHERE (' + getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + ' AND (' + dateFldPicklist + ' >= :dtStart AND ' + dateFldPicklist + ' <= :dtEnd)';
                }
                else{
                     System.debug('##36.2');
                    query += ' WHERE (' + getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + ' AND (' + dateFldPicklist + ' = :dat)';
                }
                
            }
            else
            {
                System.debug('##37');
                query += ' WHERE ('+ getNameQuery(selectedObj)+ ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + ' AND ' + dateFldPicklist + ' = ' + dateFormat; 
            }
            
            
        }else if(a1 && b1 && c2 && d2){
            
            System.debug('#38');
            query += ' WHERE (' + getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + helpPickQuery(PickOptions);
            
        }else if(a1 && b1 && c2 && d1){
            
            System.debug('##39');
            if(!fielddataType(datefldPicklist, selectedObj)){
                Time timeStart = Time.newInstance(0, 0, 0, 0); // Start of Day
                Time timeEnd = Time.newInstance(23, 59, 59, 999); // End of Day
                dtStart = DateTime.newInstance(dat, timeStart);
                dtEnd = DateTime.newInstance(dat, timeEnd);
                query += ' WHERE (' + getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + helpPickQuery(PickOptions) + ' AND (' + dateFldPicklist + ' >= :dtStart AND ' + dateFldPicklist + ' <= :dtEnd)';
            }else{
                query += ' WHERE (' + getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + helpPickQuery(PickOptions) + + ' AND (' + dateFldPicklist + ' = :dat)';
            }
            
        }else if(a1 && b1 && c1 && d2){
            
            if(dateFormat == 'AllTime'){
                
                System.debug('##40');
                query += ' WHERE (' + getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + helpPickQuery(PickOptions);
                
            }
            else if(dateFormat != '<' && dateFormat != '<=' && dateFormat != '>' && dateFormat != '>=' ){
                
                System.debug('##41');
                query += ' WHERE (' + getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + helpPickQuery(PickOptions) + ' AND ' + dateFldPicklist + ' = ' + dateFormat;
                
            }else{
                
                System.debug('##42');
                query += ' WHERE (' +getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + helpPickQuery(PickOptions);
                
            }
            
        }else{
            
            System.debug('##43');
            if(dateFormat=='AllTime')
            {
                System.debug('##44');
                query += ' WHERE (' +getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + helpPickQuery(PickOptions);
                
            }
            else  if(dateFormat=='>=')
            {
                System.debug('##45');
                query += ' WHERE (' +getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + ' AND ' + dateFldPicklist + ' >= :dat';
                
            }
            else if(dateFormat=='<=')
            {
                System.debug('##46');
                query += ' WHERE (' +getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + helpPickQuery(PickOptions)  + ' AND ' + dateFldPicklist + ' <= :dat';
                
            }
            else if(dateFormat=='<')
            {
                System.debug('##47');
                query += ' WHERE (' +getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + helpPickQuery(PickOptions)  + ' AND ' + dateFldPicklist + ' < :dat';
                
            }
            else if(dateFormat=='>')
            {
                System.debug('##48');
                query += ' WHERE (' +getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + helpPickQuery(PickOptions)  + ' AND ' + dateFldPicklist + ' > :dat';
                
            }
            else if(dateFormat=='=')
            {
                System.debug('##49');
                if(!fielddataType(datefldPicklist, selectedObj)){
                Time timeStart = Time.newInstance(0, 0, 0, 0); // Start of Day
                Time timeEnd = Time.newInstance(23, 59, 59, 999); // End of Day
                dtStart = DateTime.newInstance(dat, timeStart);
                dtEnd = DateTime.newInstance(dat, timeEnd);
                query += ' WHERE (' +getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + helpPickQuery(PickOptions)  + ' AND ' + dateFldPicklist + ' >= :dtStart AND ' + dateFldPicklist + ' <= :dtEnd';
                }
                else{
                      System.debug('##49.2');
                    query += ' WHERE (' +getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + helpPickQuery(PickOptions)  + ' AND ' + dateFldPicklist + ' = :dat';
                }
            }
            else
            {
                System.debug('##50');
                query += ' WHERE (' +getNameQuery(selectedObj) + ' LIKE \'' + name + '\'' + helpQuery(phoneFields(selectedObj), emailFields(selectedObj), name) + helpPickQuery(PickOptions)  + ' AND ' + dateFldPicklist + ' = ' + dateFormat; 
            }
            
        }
        /*query += ' ORDER BY ';
        
        if(sortExpression != null && sortExpression != '' && sortDirection != null && sortDirection != ''){
            query += sortFullExp;
        }else{
            query += getNameUniqueField(selectedObj)[0] + ' ASC';
        }*/
        query += ' ORDER BY createddate ASC LIMIT ' + QUERY_LIMIT + ' OFFSET 0';
        System.debug('QUERY: ' + query);
        return query;
    }
    
        // This function will adjust the query string
    public String adjustSearchTerm(String text){
        
        System.debug('Function: adjustSearchTerm');
        
        System.debug( 'Escaping soql term: ' + text );
        
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
        
        System.debug( 'Escaped soql term: ' + escapedText );
        if(escapedText == null){
            return '';
        }else{
            return escapedText;
        }
        
    }
    
    public String getRelatedQuery(){
        System.debug('Function: getRelatedQuery');
        if (relatedFldMap == null || relatedFldMap.isEmpty()) return '';
        String qr = ', ';
        for(String s: relatedFldMap.keySet()){
            qr += '( SELECT ';
            if(relatedFldMap.get(s) != null && !relatedFldMap.get(s).isEmpty()){
                qr += String.join(relatedFldMap.get(s), ', ');
            }else{
                qr += 'Name ';
            }
            qr += ' FROM '; 
            qr += s;
            qr += ' ), ';
        }
        qr = qr.removeEnd(', ');
        return qr;
    }
    
    public void relatedPartRefresh(String rlObj){
        System.debug('Function: relatedPartRefresh');
        relatedObjLst.put(rlObj, getRelatedWrapperRecordList(selectedObj, recordId, rlObj, relatedFldMapVF.get(rlObj)));
    }
    
    public void show(){
        System.debug('Function: show');
        try{
            if([SELECT Status FROM AsyncApexJob WHERE ID =: jobId].status == 'completed'){
                
                TheMainController tmc;
                
                if(Cache.Org.contains('local.TheMainInstance.TheMainInstanceKey')){
                    
                    tmc = (TheMainController)Cache.Org.get('local.TheMainInstance.TheMainInstanceKey');
                    
                    if(tmc != null){
                        this.relatedObj = tmc.relatedObj;
                        this.isNewRelated = tmc.isNewRelated;
                        this.rlFld = tmc.rlFld;
                        this.relatedFldMapVF = tmc.relatedFldMapVF;
                        this.relatedFldMap = tmc.relatedFldMap;
                        
                        if(this.relatedObj != null || this.isNewRelated != null || this.rlFld != null || this.relatedFldMapVF != null || this.relatedFldMap != null){
                            showRelated = true;    
                            myObj = searchForsObject(recordId);
                            for(String rName: relatedFldMapVF.keySet()){
                                isRelatedSelectAll.put(rName, false);
                                relatedObjLst.put(rName, getRelatedWrapperRecordList(selectedObj, recordId, rName, relatedFldMapVF.get(rName)));
                            }
                        }else{
                            isShowError = false;
                            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'We could not find the data related to load the page you requested'));
                        }
                    }else{
                        isShowError = false;
                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'We could not find the data related to load the page you requested'));
                    }
                    
                    
                }else{
                    isShowError = false;
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'We could not find the data related to load the page you requested'));
                }
            }else{
                isShowError = false;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'We\'re fetching the data necessary to load the page. Please wait untill the processing is completed'));
            }
        }catch(Exception e){
            isShowError = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '<b>Something went wrong<b>: We were not able to start the process'));
        }
        
    }
    
    public List<RelatedRecordWrapperClass> getRelatedWrapperRecordList(String parentObject, ID parentID, String relatedobjName, List<String> relatedObjfieldValues){
        System.debug('Function: getRelatedWrapperRecordList');
        List<RelatedRecordWrapperClass> rlWrap = new List<RelatedRecordWrapperClass>();
        for(sObject s: fetchRelatedRecords(parentObject, parentID, relatedobjName, relatedObjfieldValues)){
            RelatedRecordWrapperClass rrwc = new RelatedRecordWrapperClass(s, false);
            rlWrap.add(rrwc);
        }
        return rlWrap;
    }
    
    public List<sObject> fetchRelatedRecords(String parentObject, ID parentID, String relatedobjName, List<String> relatedObjfieldValues){
        System.debug('Function: fetchRelatedRecords');
        String query = 'SELECT ';
        query += String.join(relatedObjfieldValues, ', ');
        query += ' FROM ';
        query += relatedobjName;
        query += ' WHERE ';
        //query += getMatchingReferenceFieldName(relatedobjName);
        //query += ' =\'';
        //query += parentID;
        //query += '\'';
        for(String s: getMatchingReferenceFieldName(relatedobjName)){
            query += s;
            query += ' =\'';
            query += parentID;
            query += '\' OR ';
        }
        query = query.removeEnd('OR ');
        query += ' LIMIT 500';
        List<sObject> rlObjects = new List<sObject>();
        try{
            rlObjects = Database.query(query);
            rOldQuery = query;
        }catch(Exception e1){
            if(query.containsIgnoreCase(' LIMIT 500')){
                query = query.removeEndIgnoreCase(' LIMIT 500');
                try{
                    rlObjects = Database.query(query);
                    rOldQuery = query;
                }catch(Exception e2){
                    if(rOldQuery == null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e2.getMessage()));
                    }else{
                        rlObjects = Database.query(rOldQuery);
                    } 
                }
            }
            else{
                if(rOldQuery == null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e1.getMessage()));
                }else{
                    rlObjects = Database.query(rOldQuery);
                } 
            }
        }
        if(rlObjects != null){
            return rlObjects;
        }else{
            return new List<sObject>();
        }
    }
    
    public List<String> extractReferenceField(String objName){
        System.debug('Function: extractReferenceField');
        Map<string, Map<String, Schema.SObjectField>> objectFieldsMap = new map<string, Map<String, Schema.SObjectField>>();
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
        List<String> extractedField = new List<String>();
        for(Schema.SObjectField fld :objectFields.values()){
            schema.describeFieldResult dfield = fld.getDescribe();
            string fldType = string.valueOf(dfield.getType());   
            if (fldType == 'REFERENCE'){
                extractedField.add(String.valueOf(dfield.Name));
            }
        }
        return extractedField;
    }
    
    public Boolean checkValidFieldType(String objName, String fldName){
        System.debug('Function: checkValidFieldType');
        Boolean result = false;
        Map<string, Map<String, Schema.SObjectField>> objectFieldsMap = new map<string, Map<String, Schema.SObjectField>>();
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
        List<String> extractedField = new List<String>();
        for(Schema.SObjectField fld :objectFields.values()){
            schema.describeFieldResult dfield = fld.getDescribe();
            string fldType = string.valueOf(dfield.getType());
            String fName = String.valueOf(dfield.getName());
            if (fName == fldName && (fldType == 'ADDRESS' || fldType == 'TEXTAREA')){
                result = true;
            }
            if(fName == fldName && fldName.containsIgnoreCase('geocode')){
                result = true;
            }
            if(fName == fldName && objName == 'campaign' && fldName == 'campaignmemberrecordtypeid'){
                result = true;
            }
            if(fName == fldName && objName == 'opportunity' && fldName == 'forecastcategory'){
                result = true;
            }
        }
        return result;
    }
    
    public String getRelationshipName(String relatedobjName){
        System.debug('Function: getRelationshipName');
        for(String s: rlFld.keySet()){
            if(rlFld.get(s) == relatedobjName){
                return s;
            }
        }
        return '';
    }
    
    public Boolean isCustomObject(String obj){
        System.debug('Function: isCustomObject');
        Boolean isCustObj = false;
        List<String> sObjectList = new List<String>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
        {
            Schema.DescribeSObjectResult describeSObjectResultObj = objTyp.getDescribe();
            if(describeSObjectResultObj.name == obj && describeSObjectResultObj.isCustom()){
                isCustObj = true;
                break;
            }
        }
        return isCustObj;
    }
 
    public sObject searchForsObject(Id rid){
        System.debug('Function: searchForsObject');
        for(MainRecordWrapperClass m: Paging.myData){
            if(m.mainRecords.id == rid){
                return m.mainRecords;
            }
        }
        return null;
    }
    
    public void hide(){
        System.debug('Function: hide');
        for(String s: isNewRelated.keySet()){
            isNewRelated.put(s, false);
        }
        showRelated = false;
    }
    
    public PageReference deleteRelatedRecords(){
        System.debug('Function: deleteRelatedRecords');
        if(relatedFocusObject != null){
            List<RelatedRecordWrapperClass> allRelatedWrapRecords = relatedObjLst.get(relatedFocusObject);
            List<sObject> relatedToDelete = new List<sObject>();
            for(RelatedRecordWrapperClass rwc: allRelatedWrapRecords){
                if(rwc.isSelected){
                    relatedToDelete.add(rwc.relatedRecords);
                }
            }
            if(relatedToDelete.size() == 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Records are Selected'));
            }
            else if(relatedToDelete.size() < 10000){

                    if(Schema.getGlobalDescribe().get(relatedFocusObject).getDescribe().isDeletable()){
                        Database.DeleteResult[] drList = Database.delete(relatedToDelete, false);
                        String error = '';
                        for(Database.DeleteResult dr : drList) {
                            if (dr.isSuccess()){
                            }
                            else {               
                                for(Database.Error err : dr.getErrors()) {
                                    error += ('<b>' + err.getStatusCode() + '</b>: ' + err.getMessage()) + '<br/><br/>';
                                    if(err.getFields().size() > 0)
                                        error += ('Fields that affected this error: ' + err.getFields() + '<br/><br/>');
                                }
                            }
                        }
                        if(error != ''){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
                        }else{
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'All records have been deleted'));
                        }
                        relatedPartRefresh(relatedFocusObject);
                    }else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Insufficient Privileges: Please contact your Admin'));
                    }
            }else{
                MainBatchApex mba = new MainBatchApex(relatedToDelete, 'delete', relatedFocusObject); 
                Database.executeBatch(mba);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This process may take time. We\'ll send you an email as soon as the process completes.'));
                isMainSelectAll = false;
                instantiateMainObjLst();
            }
            
        }
        return null;
    }
    
    public PageReference updateRelatedRecords(){
        System.debug('Function: updateRelatedRecords');
        if(relatedFocusObject != null){
            List<RelatedRecordWrapperClass> allRelatedWrapRecords = relatedObjLst.get(relatedFocusObject);
            List<sObject> relatedToUpdate = new List<sObject>();
            for(RelatedRecordWrapperClass rwc: allRelatedWrapRecords){
                if(rwc.isSelected){
                    relatedToUpdate.add(rwc.relatedRecords);
                }
            }
            if(relatedToUpdate.size() == 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Records are Selected'));
            }
            else if(relatedToUpdate.size() < 10000){
                try{ 
                    if(Schema.getGlobalDescribe().get(relatedFocusObject).getDescribe().isUpdateable()){
                        Database.SaveResult[] srList = Database.update(relatedToUpdate, false);
                        String error = '';
                        for(Database.SaveResult sr : srList) {
                            if (sr.isSuccess()){
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
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'All records have been Updated'));
                        }
                    }else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Insufficient Privileges: Please contact your Admin'));
                    }
                }catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                }
            }else{
                MainBatchApex mba = new MainBatchApex(relatedToUpdate, 'update', relatedFocusObject); 
                database.executeBatch(mba);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This process may take time. We\'ll send you an email as soon as the process completes.'));
                isMainSelectAll = false;
                instantiateMainObjLst();
            }
        }
        return null;
    }
    
    public PageReference deleteMainRecords(){
        System.debug('Function: deleteMainRecords');
        if(selectedObj != null){
            List<sObject> mainToDelete = new List<sObject>();
            for(MainRecordWrapperClass mwc: Paging.myData){
                if(mwc.isSelected){
                    mainToDelete.add(mwc.mainRecords);
                }
            }
            if(mainToDelete.size() < 10000){
                    if(Schema.getGlobalDescribe().get(selectedObj).getDescribe().isDeletable()){
                        Database.DeleteResult[] drList = Database.delete(mainToDelete, false);
                        String error = '';
                       System.debug(mainTodelete[0].id);
                        for(Database.DeleteResult dr : drList) {
                            if (dr.isSuccess()){
                                //isUpdateDeleteQuery = true;
                            }
                            else {               
                                for(Database.Error err : dr.getErrors()) {
                                    error += ('<b>' + err.getStatusCode() + '</b>: ' + err.getMessage()) + '<br/><br/>';
                                    if(err.getFields().size() > 0)
                                        error += ('Fields that affected this error: ' + err.getFields() + '<br/><br/>');
                                }
                            }
                        }
                        if(error != ''){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
                        }else{
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'All records have been deleted'));
                        }
                        isMainSelectAll = false;
                        instantiateMainObjLst();
                    }else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Insufficient Privileges: Please contact your Admin'));
                    }
            }else{
                MainBatchApex mba = new MainBatchApex(mainToDelete, 'delete', selectedObj); 
                Database.executeBatch(mba);                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This process may take time. We\'ll send you an email as soon as the process completes.'));
                isMainSelectAll = false;
                instantiateMainObjLst();
            }
            
        }
        return null;
    }
    
    public PageReference updateMainRecords(){
        System.debug('Function: updateMainRecords');
        if(selectedObj != null){
            List<sObject> mainToUpdate = new List<sObject>();
            for(MainRecordWrapperClass mwc: Paging.myData){
                if(mwc.isSelected){
                    mainToUpdate.add(mwc.mainRecords);
                }
            }
            if(mainToUpdate.size() < 10000){
                    if(Schema.getGlobalDescribe().get(selectedObj).getDescribe().isUpdateable()){
                        Database.SaveResult[] srList = Database.update(mainToUpdate, false);
                        String error = '';
                        for(Database.SaveResult sr : srList) {
                            if (sr.isSuccess()){
                                isUpdateDeleteQuery = true;
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
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'All Records have been updated successfully.'));
                        }
                        isMainSelectAll = false;
                        instantiateMainObjLst();
                    }else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Insufficient Privileges: Please contact your Admin'));
                    }
            }else{
                MainBatchApex mba = new MainBatchApex(mainToUpdate, 'update', selectedObj); 
                database.executeBatch(mba);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This process may take time. We\'ll send you an email as soon as the process completes.'));
                isMainSelectAll = false;
                instantiateMainObjLst();
            }
        }
        return null;
    }
    
    public PageReference createMainTasks(){
        System.debug('Function: createMainTasks');
        if(selectedObj != null){
            List<Task> mainToTask = new List<Task>();
            for(MainRecordWrapperClass mwc: Paging.myData){
                if(mwc.isSelected){
                    Task t = new Task();
                    for(String s: getTaskFields()){
                        t.put(s, massTask.get(s));
                    }
                    t.WhatId = mwc.mainRecords.id;
                    mainToTask.add(t);
                }
            }
            
            if(mainToTask.size() < 10000){
                try{   
                    if(Schema.getGlobalDescribe().get('Task').getDescribe().isCreateable()){
                        Database.SaveResult[] srList = Database.insert(mainToTask, false);
                        String error = '';
                        for(Database.SaveResult sr : srList) {
                            if (sr.isSuccess()){
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
                            massTask = new Task();
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'All Taks have been created successfully.'));
                        }
                    }else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Insufficient Privileges: Please contact your Admin'));
                    }
                    isNewMainTask = false;
                    isMainSelectAll = false;
                    instantiateMainObjLst();
                }catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                }
                
            }else{
                MainBatchApex mba = new MainBatchApex(mainToTask, 'task', 'task'); 
                database.executeBatch(mba);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This process may take time. We\'ll send you an email as soon as the process completes.'));
                isNewMainTask = false;
                isMainSelectAll = false;
                instantiateMainObjLst();
            }
        }
        return null;
    }
    
    public PageReference createMainEvents(){
        System.debug('Function: createMainEvents');
        if(selectedObj != null){
            List<Event> mainToEvent = new List<Event>();
            for(MainRecordWrapperClass mwc: Paging.myData){
                if(mwc.isSelected){
                    Event e = new Event();
                    for(String s: getEventFields()){
                        e.put(s, massEvent.get(s));
                    }
                    e.WhatId = mwc.mainRecords.id;
                    mainToEvent.add(e);
                }
            }
            
            if(mainToEvent.size() < 10000){ 
                    if(Schema.getGlobalDescribe().get('Event').getDescribe().isCreateable()){
                        Database.SaveResult[] srList = Database.insert(mainToEvent, false);
                        String error = '';
                        for(Database.SaveResult sr : srList) {
                            if (sr.isSuccess()){
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
                            massEvent = new Event();
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'All Events have been created successfully.'));
                        }
                    }else{
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Insufficient Privileges: Please contact your Admin'));
                    }
                    isNewMainEvent = false;
                    isMainSelectAll = false;
                    instantiateMainObjLst();
            }else{
                MainBatchApex mba = new MainBatchApex(mainToEvent, 'event', 'event'); 
                database.executeBatch(mba);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This process may take time. We\'ll send you an email as soon as the process completes.'));
                isNewMainEvent = false;
                isMainSelectAll = false;
                instantiateMainObjLst();
            }
        }
        return null;
    }
    
    public PageReference cancelMain(){
        System.debug('Function: cancelMain');
        
        isNewMain = false;
        return null;
    }
    
    public PageReference cancelMainEvents(){
        System.debug('Function: cancelMainEvents');
        isNewMainEvent = false;
        return null;
    }
    
    public PageReference cancelMainTasks(){
        System.debug('Function: cancelMainTasks');
        isNewMainTask = false;
        return null;
    }
    
    public void updateMainRecordMap()
    {
        System.debug('Function: updateMainRecordMap');
        if(selectedObj != null){
            List<sObject> mainToUpdate = new List<sObject>();
            for(MainRecordWrapperClass mwc: getSubsetOfList(Paging.myData, Paging.offset, Paging.pageSize+Paging.offset-1)){
                mwc.isSelected = isMainSelectAll;      
            }
        }
    }
    
    public List<String> getTaskFields(){
        System.debug('Function: getTaskFields');
        List<String> flds = new List<String>();
        for(String sf: getAllFields('Task')){
                if(isEditable('Task', sf))
                    flds.add(sf);
        }
        try{
            flds.remove(flds.IndexOf('whatid'));
            flds.remove(flds.IndexOf('recurrencetimezonesidkey'));
        }catch(Exception e){
            
        }
        return flds;
    }
    
    public List<String> getEventFields(){
        System.debug('Function: getEventFields');
        List<String> flds = new List<String>();
        for(String sf: getAllFields('Event')){
                if(isEditable('Event', sf))
                    flds.add(sf);
        }
        try{
            flds.remove(flds.IndexOf('whatid'));
            flds.remove(flds.IndexOf('recurrencetimezonesidkey'));
        }catch(Exception e){
            
        }
        return flds;
    }
    
    public List<MainRecordWrapperClass> getSubsetOfList(List<MainRecordWrapperClass> lst, Integer st, Integer en){
        System.debug('Function: getSubsetOfList');
        if(en >= lst.size()){
            en = st + (Math.mod(lst.size(), (en-st+1)) - 1);
        }
        List<MainRecordWrapperClass> subLst = new List<MainRecordWrapperClass>();
        for(Integer i = st; i <= en; i++){
            subLst.add(lst[i]);
        }
        return subLst;
    }
    
    // New Object Creation Functions
    public void instantiateMainObj(){
        System.debug('Function: instantiateMainObj');
        mainObj = new Map<String, Map<String, Boolean>>();
        Map<String, Boolean> m = new Map<String, Boolean>();
        for(String fld: getAllFields(selectedObj)){
            if(isEditable(selectedObj, fld))
                m.put(fld, isRequired(selectedObj, fld));
        }
        mainObj.put(selectedObj, m);
    }
    
    public void instantiateMainObject(){
        System.debug('Function: instantiateMainObject');
        mainObject = new  Map<String, sObject>();
        mainObject.put(selectedObj, Schema.getGlobalDescribe().get(selectedObj).newsObject());
    }

    public sObject FindsObjectRelated(String objName){
        System.debug('Function: FindsObjectRelated');
        if(relatedObjectLst.containsKey(objName)){
            return relatedObjectLst.get(objName);
        }else{
            return null;
        }
    }
    
    public sObject FindsObjectMain(String objName){
        System.debug('Function: FindsObjectMain');
        if(mainObject.containsKey(objName)){
            return mainObject.get(objName);
        }else{
            return null;
        }
    }
    
    public String FindsObjectName(sObject sObj){
        System.debug('Function: FindsObjectName');
        for(String s: mainObject.keySet()){
            if(mainObject.get(s) == sobj){
                return s;
            }
        }  
        for(String s: relatedObjectLst.keySet()){
            if(relatedObjectLst.get(s) == sobj){
                return s;
            }
        }
        return null;
    }
    
    public sObject ConvertTosObject(String objName){
        System.debug('Function: ConvertTosObject');
        return Schema.getGlobalDescribe().get(objName).newsObject();
    }
    
    public String ConvertTosObjectName(sObject sObj){
        System.debug('Function: ConvertTosObjectName');
        if(sObj != null){
            return String.valueOf(sObj).subString(0, String.valueOf(sObj).IndexOf(':'));
        }else{
            return null;
        }
    }
    
    public Boolean isEditable(String obj, String fld){
        System.debug('Function: isEditable');
        return Schema.getGlobalDescribe().get(obj).getDescribe().fields.getMap().get(fld).getDescribe().isUpdateable();
    }
    
    public void RenderDateInputField(){
        System.debug('Function: RenderDateInputField');
        if(dateFormat == '<' || dateFormat == '>' || dateFormat == '<=' || dateFormat == '>=' || dateFormat == '='){
            RenderDateInput = true;
        }else{
            System.debug('dateFormat: ' + dateFormat);
            RenderDateInput = false;
            dateObj.myDate__c = null;
        }
    }
    
    public PageReference showNewMain(){
        System.debug('Function: showNewMain');
        isNewMain = true;
        return null;
    }
    
    public PageReference showNewMainTask(){
        System.debug('Function: showNewMainTask');
        isNewMainTask = true;
        return null;
    }
    
    public PageReference showNewMainEvent(){
        System.debug('Function: showNewMainEvent');
        isNewMainEvent = true;
        return null;
    }
    
    public PageReference showNewRelated(){
        System.debug('Function: showNewRelated');
        instantiaterelatedObjectLst();
        try{
            for(String f: getMatchingReferenceFieldName(relatedFocusObject)){
                if(isEditable(relatedFocusObject, f))
                    relatedObjectLst.get(relatedFocusObject).put(f, recordId);
            }
        }catch(Exception e){
        }
        isNewRelated.put(relatedFocusObject, true);
        return null;
    }
    
    public List<String> getMatchingReferenceFieldName(String relatedFocusObject){
        List<String> allRefFld = extractReferenceField(relatedFocusObject);
        List<String> rfld = new List<String>();
        for(String fl: allRefFld){
            if(selectedObj == getRelObjName(fl, relatedFocusObject).toLowerCase()){
                rfld.add(fl);
            }
        }
        return rfld;
    }
    
    public String getRelObjName(String fldName, String childObj){
        String refFldName = '';
        for(Schema.SObjectType reference : Schema.getGlobalDescribe().get(childObj).getDescribe().fields.getMap().get(fldName).getDescribe().getReferenceTo()) {
            refFldName = reference.getDescribe().getName();
            if(refFldName == selectedObj){
                break;
            }
        }
        return refFldName;
    }
    
    public PageReference CancelRelated(){
        System.debug('Function: CancelRelated');
        isNewRelated.put(relatedFocusObject, false);
        return null;
    }
    
    public PageReference saveRelated(){
        System.debug('Function: saveRelated');
        try{
            if(Schema.getGlobalDescribe().get(relatedFocusObject).getDescribe().isCreateable()){
                insert FindsObjectRelated(relatedFocusObject);
                relatedPartRefresh(relatedFocusObject);
                isNewRelated.put(relatedFocusObject, false);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, relatedFocusObject + ' Created Successfully')); 
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Insufficient Privileges: Please contact your Admin'));
            }
        }catch(Exception e){
            System.debug(e.getCause() + ': ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getCause() + ': ' + e.getMessage()));
        }
        
        return null;
    }
    
     public PageReference saveMain(){
        System.debug('Function: saveMain');
        try{
            if(Schema.getGlobalDescribe().get(selectedObj).getDescribe().isCreateable()){
                insert FindsObjectMain(selectedObj);
                FindsObjectMain(selectedObj).clear();
                isNewMain = false;
                instantiateMainObject();
                instantiateMainObjLst();
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Schema.describeSObjects(new List<String>{selectedObj})[0].getLabel() + ' Created Successfully'));
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Insufficient Privileges: Please contact your Admin'));
            }
        }catch(Exception e){
            System.debug(e.getCause() + ': ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getCause() + ': ' + e.getMessage()));
        }
        
        return null;
    }
    
    public PageReference RefreshMain(){
        System.debug('Function: RefreshMain');
        if(Paging.myData.size()>0){
            renderMainTable = true;
        }else{
            renderMainTable = false;
        }
        isMainSelectAll = false;
        mainSearch = '';
        PickOptions = new Map<String, PickListHandler>();
        dateFormat = '';
        dateObj.myDate__c = null;
        for(String s: isFiltered.keySet()){
            isFiltered.put(s, false);
        }
        instantiateMainObjLst();
        return null;
    }
    
    public class RelatedRecordWrapperClass 
    {   
        public Boolean isSelected {get;set;}
        public sObject relatedRecords {get;set;}
        public RelatedRecordWrapperClass(sObject rlObjLst, Boolean isSelected) {
            this.relatedRecords = rlObjLst;
            this.isSelected = isSelected;
        }
    }
    
    public class MainRecordWrapperClass 
    {
        public Boolean isSelected {get;set;}
        public sObject mainRecords {get;set;}
        public MainRecordWrapperClass(sObject mnObj, Boolean isSelected) {
            this.mainRecords = mnObj;
            this.isSelected = isSelected;
        }
    }
    
    public class PicklistHandler{
        public List<SelectOption> ltPickOptions{get;set;}
        public List<SelectOption> rtPickOptions{get;set;}
        public PicklistHandler(){
            ltPickOptions = new List<SelectOption>();
            rtPickOptions = new List<SelectOption>();
        }
        public PicklistHandler(List<SelectOption> ltpo, List<SelectOption> rtpo){
            ltPickOptions = ltpo.clone();
            rtPickOptions = rtpo.clone();
        }
    }
    
}