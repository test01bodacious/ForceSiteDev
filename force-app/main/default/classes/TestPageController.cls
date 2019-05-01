public class TestPageController {
    
    public DummyTask__c dTask {get; set;}
    public list<string> fldLst {get; set;}
    public String selectedobj {get; set;}
    public list<selectOption> objList {get; set;}
    public List<selectOption> dependentRecordLst {get; set;}
    public String selectOptionObj {get; set;}
    public String selectoptionRecord {get; set;}
    public boolean isDependent {get; set;}
  
    public TestPageController(){
        
        isDependent= false;
        selectedobj = 'DummyTask__C';
        fldLst = new list<string>();
        dtask = new DummyTask__c();
        // fldLst = getFieldList();
        fldLst.add('OwnerId__C');
        fldLst.add('Status__c');
        fldLst.add('Subject__c');
        //fldLst.add('Who_id_C');
        fldLst.add('Priority__c');
        selectObjLst();
     	System.debug(objList);
    }
    public void selectObjLst(){
         objList = new List<selectoption>();
        List<String> o = filterObjectList();
         for (String a : o) { //for all values in the picklist list
            
            objList.add(new selectOption(a,a)); //add the value and label to our final list
        }
        
    }
    
    public List<String> filterObjectList(){
       
        List<String> mainLst = new List<String>{'Account', 'Asset', 'Campaign', 'Case', 'Contact',
            'Contract', 'Opportunity', 'Order',
            'Product', 'Solution', 'Task', 'Event'};
                mainLst.addAll(getAllCustomSObjects());
        //List<String> mainLst = new List<String>{'Account', 'Contact', 'Opportunity', 'Task', 'Event',
        //                                      'Lead', 'Case'};
        Set<String> setObjLst = new Set<String>(mainLst);
        setObjLst.retainAll(mainLst);
        List<String> l = new List<String>(setObjLst);
        List<String> toReturn = new List<String>();
        for(String o: l){
            if(isObjectPresent(o)){
                toReturn.add(o);
            }
        }
        return l;
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
	
    public Pagereference initDependentRecordList(){
        System.debug(selectOptionObj);
        isDependent = true;
        if(selectOptionObj!= null)
        	dependentRecordLst = getRecordList(selectOptionObj);
       
     return null;
    }
    
     public  List<selectOption> getRecordList(String objName) {
         String unifld  =getNameUniqueField(objName)[0];
         List<Sobject> records;
         String que = 'SELECT id, ' + unifld  + ' FROM ' + objName + ' ORDER BY createddate LIMIT 100';
         try{
               records= Database.query(que);
         }catch(Exception e){
             Apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
             records = new List<Sobject>();
         }
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        
        for (sobject a : records) { //for all values in the picklist list
            
            options.add(new selectOption(String.valueOf(a.get('id')),String.valueOf(a.get(unifld)))); //add the value and label to our final list
        }
       /* if (first_val != null) { //if there is a first value being provided
            options.add(0, new selectOption(first_val, first_val)); //add the first option
        }else{
            options.add(0, new selectOption('', '-None-'));
        }*/
        return options;
    }
    
    public Pagereference Save(){
        System.debug(selectoptionRecord);
        Task t = new Task();
        t.OwnerId = dTask.OwnerId__c;
        t.Status = dTask.Status__c;
        t.Subject = dTask.Subject__c;
        t.Priority = dTask.Priority__c;   
        try{
            insert t ;
        }catch(Exception e){
            apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return null;
    }
    
     public static List<String> getAllCustomSObjects()
    {
       
        List<String> sObjectList = new List<String>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
        {
            Schema.DescribeSObjectResult describeSObjectResultObj = objTyp.getDescribe();
            if(describeSObjectResultObj.isCustom())
            {
                String name = objTyp.getDescribe().getLabel();
                
                if(!name.containsignorecase('history') && !name.containsignorecase('tag')&&
                   !name.containsignorecase('share') && !name.containsignorecase('feed'))
                {
                    
                    SobjectList.add(name);
                }
            }
        }
        return sObjectList;
    }
    
    public List<String> getNameUniqueField(String objType){
     
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
    
    
    /*public List<String> getFieldList(){
        list<string> fldLst1 = new list<String>();
        Map<String,schema.SObjectType> allobj = Schema.getGlobalDescribe();
        Map<String,schema.SObjectField> selobjmap;
       System.debug('1');
           Schema.DescribeSObjectResult  dfr = allobj.get('DummyTask__c').getDescribe();
            selobjmap =dfr.fields.getMap();
           System.debug(selobjmap);
            for(String s: selobjmap.keySet()){
                  System.debug(s);
                if(!checkValidFieldType('DummyTask__c', s)){
                    fldLst.add(s);
                }
            }
        return fldlst1;
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
    }*/
     
}