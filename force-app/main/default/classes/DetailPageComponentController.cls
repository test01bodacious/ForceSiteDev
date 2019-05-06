public class DetailPageComponentController {
    
    @testVisible String objName;
    @testVisible String recId;
    public String profileName {get; set;}
    public sObject record {get;set;}
    public sObject dummyRecord {get;set;}
    public list<String> selectedFieldLst {get; set;}
    public String detailMode {get;set;}
    
    public List <LayoutDescriberHelper.LayoutSection > layoutSections {get;set;}
    
    public String getobjName(){
        return objName;
    }
    
    public void setobjName(String obNm){
        if(objName == null){
            objName = obNm;
        }
    }

    public String getrecId(){
        return recId;
    }
    
    public void setrecId(String recordId){
        if(recId == null){
            recId = recordId;
            initRecord();
        } 
    } 
    
    public void initRecord(){
        try {
            initSectionFields(getRecordTypeIdFromRecordId(recId));
            String query = 'SELECT ' + String.join(selectedFieldLst, ', ') + ' FROM ' + objName + ' WHERE id =  \'' + recId + '\'';
            System.debug(query);
            List<sobject> sobjList = Database.query(query);
            record = sobjList[0];
            dummyRecord = record.clone();
            dummyRecord.put('id', null);
        } catch (Exception e) {
            System.debug('Exception in class: ' + String.valueOf(this).split(':')[0] + ' === Message: ' + e.getMessage() + ' === At Line: ' + e.getLineNumber());
            record = new Account();
        }
    }
    
    
    public DetailPageComponentController(){
        detailMode =  'output';
        profileName = '';  
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

    public list<string>  getFieldApiName(){
        list<string> fldlst = new list<String>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(objName);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        
        for (String fieldName: fieldMap.keySet()) {
            String fieldLabel = fieldMap.get(fieldName).getDescribe().getLabel();
            Schema.DescribeFieldResult dfr = fieldMap.get(fieldName).getDescribe();
            Schema.DisplayType fielddataType = dfr.getType();
            if(dfr.isCreateable()  && dfr.accessible && !fieldName.containsIgnoreCase('geocode') && fieldName != 'ownerid'){
                fldlst.add(FieldName);
            }
        }    
        return fldlst ;
    }

    public void initSectionFields(Id recTypeId){
        id userId = Apexpages.currentPage().getParameters().get('Userid');
        Site_User__c siteUser = [SELECT Profile_Name__r.Name FROM Site_User__c WHERE Id = :userId LIMIT 1];
        try{
            selectedFieldLst = new List<String>();
            
            //layoutSections = LayoutDescriberHelper.describeSectionWithFields(recTypeId, objName, siteUser.Profile_Name__r.Name);
            layoutSections = getSectionsAndField(siteUser.Profile_Name__r.Name);
            for (LayoutDescriberHelper.LayoutSection ldh : layoutSections) {
                ldh.layoutFields = getFilteredFieldsAndInitRecordWrapper(ldh.layoutFields);
            }
        }catch(Exception e){
            System.debug('Exception in class: ' + String.valueOf(this).split(':')[0] + ' === Message: ' + e.getMessage() + ' === At Line: ' + e.getLineNumber());
        }
    }

    public List<LayoutDescriberHelper.LayoutSection> getSectionsAndField(String profile){
        List<LayoutDescriberHelper.LayoutSection> layoutSections1 = new List<LayoutDescriberHelper.LayoutSection>();
        
        try {
          
            Record_type__C rtType = [SELECT RecordTypeId__C, Name, isPermitted__c FROM Record_Type__c WHERE Object__r.Name = :objName AND (profile__r.Name = :profile AND RecordTypeId__c = : getRecordTypeIdFromRecordId(recId) ) LIMIT 1];
            if(rtType != null && rtType.isPermitted__C == true){

                PageLayout__C pgLayout = [SELECT Name FROM PageLayout__C WHERE (Object__r.Name = :objName AND Profile__r.Name = : profile) AND Record_Type__r.Name = :rtType.Name LIMIT 1];
                String pgName = pgLayout.Name;
                List<Section__c> secLst = [SELECT Name, column__C, Fields_developer_Name__c FROM Section__c WHERE PageLayout__r.Name = :pgName AND ObjectName__C = : objName];
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
            System.debug(e.getMessage());
            Apexpages.addMessage(new Apexpages.message(Apexpages.Severity.ERROR, e.getMessage()));
        }
        return layoutSections1;
    }

    public List<LayoutDescriberHelper.LayoutField> getFilteredFieldsAndInitRecordWrapper(List<LayoutDescriberHelper.LayoutField> fldLst){
        List<LayoutDescriberHelper.LayoutField> Lflds = new List<LayoutDescriberHelper.LayoutField>();
        Map<String, Schema.SObjectField> fldMap;
        try{
            fldMap= Schema.getGlobalDescribe().get(objName.toLowerCase()).getDescribe().fields.getMap();
            for(LayoutDescriberHelper.LayoutField Lfld: fldLst){
                String fld = Lfld.ApiName;
                if(fld != null && fld != ''){
                    selectedFieldLst.add(fld);
                    Schema.SObjectField sof = fldMap.get(fld);
                    Schema.DescribeFieldResult fieldResult = sof.getDescribe();
                    if(fieldResult.isAccessible() && fieldResult.isCreateable()  && fld != 'ownerid' && !fld.containsIgnoreCase('geocode')){
                        Lflds.add(Lfld);
                    }
                }
            }
            return Lflds;
        }catch(Exception e){
            System.debug('Exception in class: ' + String.valueOf(this).split(':')[0] + ' === Message: ' + e.getMessage() + ' === At Line: ' + e.getLineNumber());
            return Lflds;
        }
    }
        
    public PageReference saveRecord(){     
        dummyrecord.put('id', Record.get('id'));
        try{
            update dummyrecord;
            apexpages.addMessage(new ApexPages.message(apexpages.Severity.CONFIRM, 'Record Upadte Successfully'));
        }catch(Exception e){
            apexpages.addMessage(new ApexPages.message(apexpages.Severity.ERROR, e.getMessage()));
        }
        dummyRecord.put('id', null);
        return null;
    }
    
}