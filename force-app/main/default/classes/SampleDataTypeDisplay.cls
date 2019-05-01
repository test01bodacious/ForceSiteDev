public   class SampleDataTypeDisplay {
    
    public Map<String, WrapperClass> fldType = new  Map<String, WrapperClass>();
    public Map<Schema.DisplayType, String> mapSample  = new Map<Schema.DisplayType, String>();
    public list<Sample__C> sampleobjlist = new list<Sample__C>();
    list<DisplayTypeClass> DisplayTypelst = new list<DisplayTypeClass>();
    public list<SampleApi> mainList {get; set;}
    public Map<id, Sobject> records {get; set;}
    public String selectedobj;
    public Boolean isSaved{get;set;}
    public Boolean isCreate {get; Set;}
    public String var {get;Set;}
    public list<MainRecordClass> MainList1 {get; set;}
    public string query;
    public boolean isPickListEdit {get; set;}
   // public list<MainRecordClass> mainObjLst {get; set;}
    public list<string> fld {get; set;}
    public List<String> fldn  {get; set;}
    list<sobject> updateDeleteRecords = new list<sobject>();
    public string userid {get; set;}
    
    @testVisible List<String> objApiName = new List<String>{'account', 'opportunity', 'contact', 'account', 'task'};
    @testVisible List<String> fieldSetName = new List<String>{'FS_Account', 'FS_Opportunity', 'FS_Contact', 'FS_Account_Site', 'Task_Site'};
        
     public String getselectedobj(){
          
                return selectedobj;
        }
    public void setselectedobj(String obj){
        System.debug('#########' + obj + ' ' + selectedobj);
        if(obj!=selectedobj){
           
            selectedobj = obj;
            System.debug('@@@@@@@@@@@@' + selectedobj);
            mainlist.clear();
            initRecords();
            initmapSample();
            dataTypeDisplay();
            createSample(frequencyCount(fldtype));
            setIndex();
            mapToSampleObj();
            
            System.debug(mainlist.size());
            //getRecords();
        }
    }
    public SampleDataTypeDisplay(){
       
        isPickListEdit= false;
        isCreate = false;
        //selectedobj ='';
        isSaved = false;
        mainList = new list<SampleApi>();
       // mainObjLst = new list<MainRecordClass>();
        MainList1 = new list<MainRecordClass>();
        
       // records = [Select Name, Rating, industry, phone From Account order by createddate ASC Limit 20];
         fld = new list<string>();
         fldn = new list<string>();

    }
    public void initRecords(){
       // System.debug('#1- initRecords called');
        
        records = new map<id, Sobject>();
    }
    
    public void initmapSample(){
        
       // System.debug('#1- initmapSample called');
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType sampleSchema = schemaMap.get('Sample__c');
        Map<String, Schema.SObjectField> fieldMap = sampleSchema.getDescribe().fields.getMap();
        
        for (String fieldName: fieldMap.keySet()) {
            
            Schema.DescribeFieldResult dfr = fieldMap.get(fieldName).getDescribe();
            
            String fieldLabel = dfr.getLabel();
            
            if(dfr.isCustom()){
                if(!(dfr.getType() == Schema.DisplayType.PICKLIST) && !(dfr.getType() == Schema.DisplayType.DOUBLE)
                   && !(dfr.getType() == Schema.DisplayType.TEXTAREA && !(dfr.getType() == Schema.DisplayType.MULTIPICKLIST))){
                       mapSample.put(dfr.getType(), fieldName);
                   } //
            }   
        }
        
        mapSample.put(Schema.DisplayType.DOUBLE, 'Number__c');
        mapSample.put(Schema.DisplayType.TEXTAREA, 'TextArea__c');
        mapSample.put(Schema.DisplayType.STRING, 'Text__c');
        mapSample.put(Schema.DisplayType.ID , 'Text__c');
        mapSample.put(Schema.DisplayType.PICKLIST , 'Picklist_del__c');
        mapSample.put(Schema.DisplayType.id , 'id');
        
        
        
        
    }
    
    
    public void  dataTypeDisplay(){
        
       System.debug('#1- dataTypeDisplay called' +selectedobj);
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(selectedobj);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        integer index = objApiName.indexOf(selectedobj);
        fldn= getFieldsFromFieldSet(index);
        fld= fldn;
        for (String fieldName: fieldMap.keySet()) {
            
           
            String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
            Schema.DescribeFieldResult dfr = fieldMap.get(fieldName).getDescribe();
            Schema.DisplayType fielddataType = dfr.getType();
             //System.debug(fieldName);
            if(fldn.contains(fieldName)){
               
                if(dfr.isCreateable()){
                list<string> value = new list<String>();
                value.add('-None-');
                if(fielddataType==DisplayType.PICKLIST){
                    for(picklistEntry pic : dfr.getPicklistValues()){
                        
                        value.add(pic.getValue());
                    }
                    
                }
                /*if(!dfr.isNillable())
                    fieldLabel += '<span style="color:red;">*</span>';*/
                WrapperClass wc = new WrapperClass(fielddataType, value, fieldLabel);
                fldType.put(fieldName, wc);
            }
            }
        }
    }
    
    
    public void changeisPickListEdit(){
		isPickListEdit = (isPickListEdit)? false: true;
    }
    
    public integer frequencyCount(Map<String, WrapperClass> fldType){
        
       // System.debug('#1- frequencyCount called');
        Map<Schema.DisplayType, integer> mapCount = new map<Schema.DisplayType, integer>();
        list<Integer> count = new list<Integer>();
        for(String s : fldType.keyset()){
            
            if(mapCount.containsKey(fldType.get(s).dtype)){
                mapCount.put(fldType.get(s).dtype, mapCount.get(fldType.get(s).dtype) +1);
            }
            else
                mapCount.put(fldType.get(s).dtype, 1);
        }
        count = mapCount.values();
        count.sort();
        if(count.size() >0 && count!=null)
            return count[count.size()-1];
        else 
            return 0;
    }
    
    
    public void createSample(integer freq){
        
        //System.debug('#1- createSample called');
        for(integer i =1 ; i <= freq ; i++)
            sampleobjlist.add(new Sample__c());
    }
    
    
    
    public void setIndex(){
        
       // System.debug('#1- setIndex called');
        Map<schema.DisplayType, integer> mapDisplayType = new map<Schema.DisplayType, integer>();
        
        for(String typ : fldType.keySet()){
            
            if(mapDisplaytype.containsKey(fldType.get(typ).dtype)){
                
                mapDisplaytype.put(fldType.get(typ).dtype, mapDisplaytype.get(fldType.get(typ).dtype) +1);
            }
            else {
                mapDisplayType.put((fldType.get(typ).dtype), 0);
            }
            
            
            DisplayTypelst.add(new DisplayTypeClass(fldType.get(typ).dtype, mapDisplaytype.get(fldType.get(typ).dtype), fldType.get(typ).label, typ, fldType.get(typ).picklistValue));
        }
    }
    
    
    public void mapToSampleObj(){
        
        //System.debug('#1- mapToSampleObj called');
        
        sampleApi sample;
        for(DisplayTypeClass d : DisplayTypelst){
            
            if(mapSample.containsKey(d.type)){
                sample = new SampleApi(sampleobjlist[d.index], mapSample.get(d.type), d.label, d.selctedFldApi, d.index, d.pickValue, d.type, selectedobj);
                mainlist.add(Sample);
            }
        }
        
    }
    
    public pageReference saveRecords(){
        
        
        ///.debug('#1- saveRecords called' + records.values()[0]);
       
        Database.SaveResult[] srList;
       
        if(!isSaved){
            setRecords();
            srList = Database.insert(records.values(), false);
            
        }else{
            updateDeleteRecords.clear();
            updateRecords();
            srList = Database.update(updateDeleteRecords, false);
        }
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
            isSaved = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'All selected records have been updated successfully'));
        } 
        getRecords();
        return null;
    }
    
    
    public pageReference deleteRecords(){
        
        
        //.debug('#1- deleteRecords called');
        Database.deleteResult[] srList;
        
       updateDeleteRecords.clear();
            updateRecords();
       // System.debug(updateDeleteRecords);
            srList = Database.delete(updateDeleteRecords, false);
        
        String error = '';
        for(Database.DeleteResult sr : srList) {
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
            isSaved = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'All selected records have been Deleted successfully'));
        }
        getRecords();
        return null;
    }
    
    public void setRecords(){
        
       // System.debug('#1- setRecords called');
        
        Sobject s ;
        if(!isSaved){
            s = schema.getGlobalDescribe().get(Selectedobj).newsObject();
        }else{
            
        }
        
        for(SampleApi samp : mainList){
            try{
                
                s.put(samp.selctedObjFldApi, sampleobjlist[samp.index].get(samp.samplefldType));
                s.put('id', sampleobjlist[samp.index].get(samp.samplefldType));
                  
            }catch(Exception e){
                
            }
        }
        
        records.put(s.id,s);
        
    }
    
    public void updateRecords(){
        
        // System.debug('#1- updateRecords called');
        //records.clear();
        
        for(MainRecordClass sam : mainlist1){
            System.debug(sam.ischecked);
            if(sam.ischecked){
                
                Sobject s1 =  Schema.getGlobalDescribe().get(selectedobj).newSObject() ;
                s1.id= sam.sid;
                System.debug(selectedobj);
                System.debug(Sam.sid);
               
                for(SampleApi samp : sam.objlst){
                    try{
                        records.get(sam.sid).put(samp.selctedObjFldApi, samp.sampleobj.get(samp.samplefldType) );
                        s1.put(samp.selctedObjFldApi, samp.sampleobj.get(samp.samplefldType) );
                        records.put(sam.sid, s1);
                        
                    }catch(Exception e){
                        
                    }
                }
                // System.debug(s1);
                
                updateDeleteRecords.add(s1);
            }
        }
        createHistory(updateDeleteRecords);
    }
    
    
    public void createHistory(List<sobject> hist){
        System.debug('History' + hist);
        
        list<SiteHistory__C> siteHistoryObjlst = new List<SiteHistory__C>();
        Site_User__c user;
        SiteHistory__C histryobj;
        try{
          /*  if(Cache.Session.contains(userId)){
                System.debug('user '+ cache.Session.get(userId));
             user = (MyUser__c)cache.Session.get(userId);
            }*/
             
            user = [select Name, First_Name__C, last_Name__c From Site_User__c Where id = :userId limit 1];
        }catch(Exception e){
            
        } 
        System.debug('in update ' + user);
         switch on selectedobj {
                    when 'account' {
                        for(Sobject sam : updateDeleteRecords){
                            histryobj = new SiteHistory__C();
                            if(user != null){
                                histryobj.user_Name__C = user.First_Name__C + ' ' + user.Last_Name__C;
                                histryobj.Email__c = user.Name;
                                histryobj.Account__c = sam.id;
                            }
                            siteHistoryObjlst.add(histryobj);
                        }
                    }
                     when 'opportunity' {
                           for(Sobject sam : updateDeleteRecords){
                            histryobj = new SiteHistory__C();
                            if(user != null){
                                histryobj.user_Name__C = user.First_Name__C + ' ' + user.Last_Name__C;
                                histryobj.Email__c = user.Name;
                                histryobj.opportunity__C = sam.id;
                            }
                               siteHistoryObjlst.add(histryobj);
                        }
                    }
					 when 'contact' {
                         for(Sobject sam : updateDeleteRecords){
                            histryobj = new SiteHistory__C();
                            if(user != null){
                                histryobj.user_Name__C = user.First_Name__C + ' ' + user.Last_Name__C;
                                histryobj.Email__c = user.Name;
                                histryobj.contact__C = sam.id;
                            }
                             siteHistoryObjlst.add(histryobj);
                        }
                     }
                }
        Database.SaveResult [] srList;
        if(hist != null){
            srList = Database.insert(siteHistoryObjlst);
        }
        String error='';
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
            //isSaved = true;
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'All selected records have been updated successfully'));
        } 
    }
    
    public void getRecords(){
        getQuery();
        Map<id, Sobject> sobj = new Map<id, sobject>(database.query(query));
        records.clear();
        records = sobj;
        List<SampleApi> samplelistrecord ;
        MainList1.clear();
        for(sobject so : sobj.values()){
            samplelistrecord = new List<SampleApi>();
            SampleApi sampleapi1 ;
            for(SampleApi sp : mainList){
                Sample__c smobj = new Sample__C();
                if(hasSObjectField(sp.selctedObjFldApi, so)){
                    smobj.put(sp.samplefldType, so.get(sp.selctedObjFldApi));
                    sampleapi1 = new sampleapi(smobj, sp.samplefldType, sp.labl, sp.selctedObjFldApi, sp.index, sp.selectedPickValue, sp.fieldType, selectedobj);
                }
                samplelistrecord.add(sampleapi1);
                 
            }
            
            MainRecordClass m = new MainRecordClass();
             m.objlst=samplelistrecord;
                m.ischecked= false;
            m.sid=so.id;
            MainList1.add(m); 
           
        }
        isSaved = true;
    }
    
    
    public  void getQuery(){
        
        query = 'SELECT ';
        
        for(SampleApi s : mainList){
            
            query += s.selctedObjFldApi +', ';
        }
        if(query.contains(','))
        query = query.substring(0, query.lastIndexOf(','));
        query += ' FROM ' + selectedobj + ' ORDER BY Name ASC limit 25 ';
        System.debug(mainList);
    }
    
    
    public static boolean hasSObjectField(String fieldName, SObject so){
        return so.getSobjectType().getDescribe().fields.getMap().keySet().contains(fieldName.toLowerCase());
    }
    
    public PageReference createRecord(){
        
       // System.debug('CreateRecord Called'  + mainlist.size());
        
        for(SampleApi samp : mainList){
            try{
                samp.sampleobj.put(samp.sampleFldtype, null);
            }catch(Exception e){
                
            }
        }
        isCreate=true;
        return null;
    }
    public PageReference saveRecord(){
        
        
       // System.debug('#1- saveRecord called');
        Database.SaveResult[] srList;
        
        setRecord();
        srList = Database.insert(records.values(), false);
        String error = '';
         //createHistory(records.values()); 
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
           // System.debug('in set record');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
        }else{
            isSaved = true;
            isCreate= false;
           
            //getRecords();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'All records have been Inserted'));
        } 
        
        
        
        return null;
    }
    
    public void setRecord(){
        
       // System.debug('#1- setRecord called');
        Sobject s= schema.getGlobalDescribe().get(Selectedobj).newsObject();
        
        records.clear();
       // System.debug(mainlist);
        for(SampleApi samp : mainList){
            try{
                sYSTEM.debug(samp.samplefldType);
                if(samp.samplefldType=='Picklist_del__c'){
                   // System.debug(samp.selctedObjFldApi + '  ' + samp.selectedPickvalue1);
                    s.put(samp.selctedObjFldApi, samp.selectedPickvalue1);
                }
                else
                s.put(samp.selctedObjFldApi, sampleobjlist[samp.index].get(samp.samplefldType));
                
                
            }catch(Exception e){
               // System.debug('in set record');
            }
        }
        
        records.put(s.id, s);
    }
    
    
    public Pagereference cancelRecord(){
        /*mainlist1= new list<MainRecordClass>();
        records= new map<id, sobject>();
        iscreate=false;*/
        return new pagereference('/apex/vf1');
    }
    
    public PageReference refresh(){
        
        getrecords();
        isSaved = true;
        isCreate =false;
        return null;
    }
    
    public static List<selectOption> getPickValues(String objName, String field_name, String first_val) {
        //System.debug(first_val + '   ' +field_name);
        Schema.sObjectType sobject_type = Schema.getGlobalDescribe().get(objName);
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        /*if (first_val != null) { //if there is a first value being provided
            options.add(new selectOption('', first_val));*/ //add the first option
        //}
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            
            options.add(new selectOption(a.getValue(), a.getLabel())); //add the value and label to our final list
        }
        if (first_val != null) { //if there is a first value being provided
            options.add(0, new selectOption(first_val, first_val)); //add the first option
        }else{
            options.add(0, new selectOption('', '-None-'));
        }
        return options;
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
    
    public class SampleApi{
        public String objectName ;
        public Sample__c sampleobj {get;set;}
        public  String samplefldType {get; set;}
        public String labl {get; set;}
        public String selctedObjFldApi{get;set;}
        public integer index ;
        public list<String> selectedPickvalue {get; set;}
        public list<selectoption> selectOptionsValue {get; set;}
        public Schema.DisplayType fieldType {get; set;}
        public String selectedPickvalue1 {get; set;} 
        public list<String> count {get;set;}
        
       
        public SampleApi(Sample__c sam, String fld, String l, String api, integer i, list<String> picvlst, Schema.DisplayType t, String obj){
           // System.debug('#1- SampleApi Constructor  called');
            
            objectName = obj;
            count= new List<String>();
            count.add('Hello');
            this.sampleobj = sam;
            this.samplefldType = fld;
            labl =l;
            selctedObjFldApi = api;
            index = i;
            selectedPickvalue = picVlst;
            fieldType = t;
            selectOptionsValue = new List<selectoption>();
            selectedPickvalue1 ='';
            
            //convertStringToSel;ectOptions();
            if(this.fieldType== schema.DisplayType.PICKLIST)
           selectOptionsValue = getPickValues(objectName, selctedObjFldApi, (String)(sampleobj.get(samplefldType)));
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
            /*if(this.fieldType== schema.DisplayType.PICKLIST && sampleobj.get(samplefldType) != null){
                 System.debug((String)(sampleobj.get(samplefldType)));
            selectOptionsValue.add(0, new selectoption((String)(sampleobj.get(samplefldType)),
                                                       (String)(sampleobj.get(samplefldType))));
            }*/
        }
        
        
        
        /*public void convertStringToSelectOptions(){
            
            for(String s : selectedPickValue){
                selectOptionsValue.add(New SelectOption(s,s));
            }
        }*/
    }
    
    
    public class DisplayTypeClass{
        Schema.DisplayType type;
        Integer index;
        String label;
        String selctedFldApi;
        list<String> pickValue;
        
        public DisplayTypeClass(Schema.DisplayType type, Integer index, String label, String api, list<String> pick){
            
           // System.debug('#1- DisplayTypeClass Constructor  called');
            this.type = type;
            this.index = index;
            this.label = label;
            selctedFldApi = api;
            pickvalue = pick;
             
        }
    }
    
    public  class WrapperClass{
        
        public schema.DisplayType dType;
        public list<String> picklistValue;
        public String label;
        public WrapperClass(schema.DisplayType  dt, list<String> pic, String l){
            //System.debug('#1- WrapperClass Constructor  called');
            dType =dt;
            picklistValue= pic;
            label = l;
           
        }
    }
    public class MainRecordClass{
        public boolean isChecked {get; set;}
        public  list<SampleApi> objlst {get; set;}
        id sid ;
        public MainRecordClass(){
            this.isChecked = false;
            this.objlst = null;
        }
    }
    
}