public   class TaskController {
    
    public Map<String, WrapperClass> fldType = new  Map<String, WrapperClass>();
    public Map<Schema.DisplayType, String> mapSample  = new Map<Schema.DisplayType, String>();
    public list<Sample__C> sampleobjlist = new list<Sample__C>();
    list<DisplayTypeClass> DisplayTypelst = new list<DisplayTypeClass>();
    public list<SampleApi> mainList {get; set;}
    public list<Sobject> records ;
    public String selectedobj {get; set;}
    public Boolean isSaved{get;set;}
    public Boolean isCreate {get; Set;}
    public String var {get;Set;}
    public list<list<SampleApi>> MainList1 {get; set;}
    public string query;
    
    public TaskController(){
        System.debug('#1- Constructor called');
        
        isCreate = false;
        selectedobj ='task';
        isSaved = false;
        mainList = new list<SampleApi>();
        MainList1 = new list<list<SampleApi>>();
        initRecords();
        initmapSample();
        dataTypeDisplay();
        createSample(frequencyCount(fldtype));
        setIndex();
        mapToSampleObj();
      //  getRecords();
        
    }
    public void initRecords(){
        System.debug('#1- initRecords called');
        
        records = new List<Sobject>();
    }
    
    public void initmapSample(){
        
        System.debug('#1- initmapSample called');
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
        
        
        
    }
    
    
    public void  dataTypeDisplay(){
        
        System.debug('#1- dataTypeDisplay called');
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(selectedobj);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        
        
        for (String fieldName: fieldMap.keySet()) {
            
            
            String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
            Schema.DescribeFieldResult dfr = fieldMap.get(fieldName).getDescribe();
            Schema.DisplayType fielddataType = dfr.getType();
            if(dfr.isCreateable() && dfr.isAccessible()
              
              ){
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
    
    
    public integer frequencyCount(Map<String, WrapperClass> fldType){
        
        System.debug('#1- frequencyCount called');
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
        
        System.debug('#1- createSample called');
        for(integer i =1 ; i <= freq ; i++)
            sampleobjlist.add(new Sample__c());
    }
    
    
    
    public void setIndex(){
        
        System.debug('#1- setIndex called');
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
        
        System.debug('#1- mapToSampleObj called');
        
        sampleApi sample;
        for(DisplayTypeClass d : DisplayTypelst){
            
            if(mapSample.containsKey(d.type)){
                sample = new SampleApi(sampleobjlist[d.index], mapSample.get(d.type), d.label, d.selctedFldApi, d.index, d.pickValue, d.type);
                mainlist.add(Sample);
            }
        }
        
    }
    
    public pageReference saveRecords(){
        
        
        System.debug('#1- saveRecords called');
        Database.SaveResult[] srList;
        
        if(!isSaved){
            setRecords();
            srList = Database.insert(records, false);
            
        }else{
            updateRecords();
            srList = Database.update(records, false);
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
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'All records have been Inserted'));
        } 
        return null;
    }
    
    public void setRecords(){
        
        System.debug('#1- setRecords called');
        
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
        
        records.add(s);
        
    }
    
    public void updateRecords(){
        
        System.debug('#1- updateRecords called');
        
        Sobject s ;
        System.debug(mainlist1);
        integer i = 0;
        for(list<SampleApi> sam : mainlist1){
            for(SampleApi samp : sam){
                try{
                    records[i].put(samp.selctedObjFldApi, samp.sampleobj.get(samp.samplefldType) );
                }catch(Exception e){
                    
                }
            }
            i++;
        }
    }
    
   /* public void getRecords(){
        getQuery();
        list<Sobject> sobj = database.query(query);
        records = sobj;
        List<SampleApi> samplelistrecord ;
        MainList1.clear();
        for(sobject so : sobj){
            samplelistrecord = new  List<SampleApi>();
            SampleApi sampleapi1 ;
            for(SampleApi sp : mainList){
                Sample__c smobj = new Sample__C();
                if(hasSObjectField(sp.selctedObjFldApi, so)){
                    smobj.put(sp.samplefldType, so.get(sp.selctedObjFldApi));
                    sampleapi1 = new sampleapi(smobj, sp.samplefldType, sp.labl, sp.selctedObjFldApi, sp.index, sp.selectedPickValue, sp.fieldType);
                }
                samplelistrecord.add(sampleapi1);  
            }
            MainList1.add(samplelistrecord); 
           
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
        query += ' FROM ' + selectedobj + ' ORDER BY createddate DESC LIMIT 4';
    }
    */
    
    public static boolean hasSObjectField(String fieldName, SObject so){
        return so.getSobjectType().getDescribe().fields.getMap().keySet().contains(fieldName.toLowerCase());
    }
    
    public PageReference createRecord(){
        
        System.debug('CreateRecord Called'  + mainlist.size());
        
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
        
        
        System.debug('#1- saveRecord called');
        Database.SaveResult[] srList;
        
        setRecord();
        srList = Database.insert(records, false);
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
            System.debug('in set record');
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
        
        System.debug('#1- setRecord called');
        Sobject s= schema.getGlobalDescribe().get(Selectedobj).newsObject();
        
        records.clear();
      
        for(SampleApi samp : mainList){
            try{
                sYSTEM.debug(samp.samplefldType);
                if(samp.samplefldType=='Picklist_del__c'){
                    System.debug(samp.selctedObjFldApi + '  ' + samp.selectedPickvalue1);
                    s.put(samp.selctedObjFldApi, samp.selectedPickvalue1);
                }
                else
                s.put(samp.selctedObjFldApi, sampleobjlist[samp.index].get(samp.samplefldType));
                
                
            }catch(Exception e){
                
            }
        }
        
        records.add(s);
    }
    
    
    public Pagereference cancelRecord(){
        
        iscreate=false;
        return null;
    }
    
    public PageReference refresh(){
        
        new TaskController();
        isSaved = true;
        isCreate =false;
        return null;
    }
    
    public static List<selectOption> getPickValues(String objName, String field_name, String first_val) {
        Schema.sObjectType sobject_type = Schema.getGlobalDescribe().get(objName);
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        if (first_val != null) { //if there is a first value being provided
            options.add(new selectOption('', first_val)); //add the first option
        }
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            
            options.add(new selectOption(a.getValue(), a.getLabel())); //add the value and label to our final list
        }
        return options;
    }
    
    
    public class SampleApi{
        
        public Sample__c sampleobj {get;set;}
        public  String samplefldType {get; set;}
        public String labl {get; set;}
        public String selctedObjFldApi{get;set;}
        public integer index ;
        public list<String> selectedPickvalue {get; set;}
        public list<selectoption> selectOptionsValue {get; set;}
        public Schema.DisplayType fieldType {get; set;}
        public String selectedPickvalue1 {get; set;} 
        
        public SampleApi(Sample__c sam, String fld, String l, String api, integer i, list<String> picvlst, Schema.DisplayType t){
            
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
           selectOptionsValue = getPickValues('task', selctedObjFldApi, '-None-');
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
            
            System.debug('#1- DisplayTypeClass Constructor  called');
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
            System.debug('#1- WrapperClass Constructor  called');
            dType =dt;
            picklistValue= pic;
            label = l;
           
        }
    }
    
}