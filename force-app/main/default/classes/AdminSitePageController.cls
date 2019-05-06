public class AdminSitePageController implements Queueable {
    
    @testVisible List<String> supportedObjects;

    public List<String> views {get;set;}
    
    @testVisible String error ;

    public String isJobIdRefresh {get; set;}

    public String fldUpdateValue = ' object__c';
    public Map<String, ObjectOptions> objOpts {get;set;}

    public Map<String, FieldOptions> fldOpts {get;set;}

    public Map<String, RelatedObjOption> rltOpts {get; set;}

    public Map<String, List<ProfileWrapper>> objMap {get;set;}

    public Map<String, List<PageLayout__C>> pageLayoutMap {get;set;}

    @testVisible List<Record_Type__c> rtType;

    public String focusedView {get;set;}

    public Boolean refreshProfile {get; set;}

    public String nextPage {get;set;}
    public  List<PageLayout__c> pglLst {get; set;}
    public AdminSitePageController(){
        isJobIdRefresh = '';
        error = '';
        refreshProfile =  false;
       pglLst =  [SELECT Name, object__c, Record_Type__r.Name, Profile__r.Name FROM PageLayout__C];
        nextPage = 'ObjectSelection';
        initViews();
        initsupportedObjects();
        initObjectOptionsMap();
    }


public Pagereference refresh(){

     AsyncApexJob aap = [SELECT Status FROM AsyncApexJob WHERE Id = :jobId];  

            if(aap.Status == 'Completed' || aap.Status == 'Failed' || aap.Status == 'Aborted'){ 
                    isJobIdRefresh = 'FieldSelection';
            }
            else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Warning, 'The process is already going on. Please wait for sometime, untill it finishes'));  
            }
            return null;
}
    public void initViews(){
        views = new List<String>();
        for (Schema.PicklistEntry viewValue : Schema.getGlobalDescribe().get('Object__c').getDescribe().fields.getMap().get('View__c').getDescribe().getPicklistValues()) {
            views.add(viewValue.getLabel());
        }
        views.add('None');
    }

    public void initsupportedObjects(){
        supportedObjects = new List<String>{'account', 'asset', 'campaign', 'case', 'contact', 'contract', 'idea', 'lead', 'opportunity', 'order', 'product2', 'solution', 'user'};
    }

    public void initObjectOptionsMap(){
        objOpts = new Map<String, ObjectOptions>();
        for (String view : views) {
            ObjectOptions objOpt = new ObjectOptions();
            initObjectOptions(view, objOpt);
            objOpts.put(view, objOpt);
        }
    }

    public void initObjectOptions(String viewName, ObjectOptions objOpt){
        initavailableAndSelectedObjectOptions(viewName, objOpt);
    }

    public void initavailableAndSelectedObjectOptions(String viewName, ObjectOptions objOpt){
        List<SelectOption> allObjOptions = getAllObjectOptions();
        objOpt.selectedObjectOptions = getselectedObjectOptions(viewName, objOpt);
        objOpt.availableObjectOptions = getAvailableObjectOptions(allObjOptions, objOpt.selectedObjectOptions);
    }

    public List<SelectOption> getselectedObjectOptions(String viewName, ObjectOptions objOpt){
        List<SelectOption> selObjOpt = new List<SelectOption>();
        List<Object__c> lstObj = new List<Object__c>();
        if(viewName == 'Related List View'){
            lstObj = [SELECT Name, Developer_Name__c, view__C FROM Object__c WHERE View__c IN ('All Records View', 'Search Records View', 'Related List View') LIMIT 1000 ];
        }else if (viewName == 'None') {
            lstObj = [SELECT Name, Developer_Name__c, View__C FROM Object__c LIMIT 1000];
        }else{
            lstObj = [SELECT Name, Developer_Name__c FROM Object__c WHERE View__c = :viewName ORDER BY Position__c LIMIT 1000];
        }
        for (Object__c ss : lstObj) {
            SelectOption so = new SelectOption(ss.Developer_Name__c, ss.Name);
            if (!selObjOpt.contains(so)) {
                selObjOpt.add(so);
            }
        }
        return selObjOpt;
    }

    public List<SelectOption> getAllObjectOptions(){
        List<SelectOption> allObjOpt = new List<SelectOption>();
        for (Schema.SObjectType sObjType :  Schema.getGlobalDescribe().values()) {
            Schema.DescribeSObjectResult objDescribe = sObjType.getDescribe();
            SelectOption so = new SelectOption(objDescribe.name, objDescribe.label);
            if (objDescribe.isCustom()) {
                allObjOpt.add(so);
            }
            if (supportedObjects.contains(so.getValue().toLowerCase())) {
                allObjOpt.add(so);
            }
        }
        return allObjOpt;
    }

    public List<SelectOption> getAvailableObjectOptions(List<SelectOption> allObjOpt, List<SelectOption> selObjOpt){
        List<SelectOption> avlObjOpt = new List<SelectOption>();
        for (SelectOption aoo : allObjOpt) {
            Boolean flag = true;
            for (SelectOption soo : selObjOpt) {
                if (aoo.getValue() == soo.getValue()) {
                    flag = false;
                }
            }
            if (flag) {
                avlObjOpt.add(aoo);
            }
        }
        return avlObjOpt;
    }
    @testVisible id jobId;


    public Pagereference confirm(){
        
        if(error != '' && error != null)
        sendEmailError(error);
        if(focusedView.trim() == 'Related List View'){  
             updateObjectOptionsMap(focusedView);                       
            initrelatedList();
                                             
            nextPage = 'RelatedList';
             //jobId = System.enqueueJob(this);  
            // nextPage = 'FieldSelection';
            // initFieldOptionsMap(focusedView);
             isJobIdRefresh = 'FieldSelection';
            // ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'The process is started, you\'ll be mailed when it is completed')); 
            return null;

        }else if (focusedView == 'None') {     
            jobId = System.enqueueJob(this);  
            nextPage = 'PageLayoutSelection';
           // isJobIdRefresh = 'refreshbutton';
            Pagereference pgr = new Pagereference('/apex/ProfilePermissionPage');
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'The process is started, you\'ll be mailed when it is completed')); 
            return pgr;

        }else if (focusedView != null) {
            fldUpdateValue = 'object__c';
            if (objOpts.get(focusedView).selectedObjectOptions.isEmpty()) {
                jobId = System.enqueueJob(this);  
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Objects Selected'));
                return null;
            }
            jobId = System.enqueueJob(this);  
            nextPage = 'FieldSelection';
            initFieldOptionsMap(focusedView);
            isJobIdRefresh = 'refreshbutton';
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'The process is started, you\'ll be mailed when it is completed')); 
                return null;

            }
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could\'nt fetch view'));
                    return null;
            }             
    }

public void sendEmailError(String err){
     Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
    message.subject = 'Error in Admin Panel';  
    message.setHtmlBody(err);  
    message.toaddresses = new String[]{'pritamraj.rits@gmail.com'};
    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
    Messaging.SendEmailResult[] results = new list<Messaging.SendEmailResult>();
    try {
        results = Messaging.sendEmail(messages);
    } catch (Exception e) {
        apexpages.addMessage(new apexpages.Message(apexpages.Severity.ERROR, e.getMessage()));
    }
}
    public void initobjMap(){
        List<SelectOption> selObjOpt = objOpts.get('None').selectedObjectOptions;
        List<String> objList = new List<String>();
        objMap = new Map<String, List<ProfileWrapper>>();
        for (SelectOption so : selObjOpt) {
            objList.add(so.getValue());
            objMap.put(so.getValue(), getProfileWrapper(so.getValue()));
        }
        initProfileBatchApex(objList);
    }

    public List<ProfileWrapper> getProfileWrapper(String objName){
        List<ProfileWrapper> profWrapLst = new List<ProfileWrapper>();
        List<Profile__c> profLst = [SELECT Name FROM Profile__c];
        for (Profile__c prof : profLst) {
            ProfileWrapper profWrap = new ProfileWrapper();
            profWrap.profileName = prof.Name;
            profWrap.rtWrap = getRecordTypeWrapper(objName);
            profWrapLst.add(profWrap);
        }
        return profWrapLst;
    }

    public List<RecordTypeWrapper> getRecordTypeWrapper(String objName){
        List<Record_Type__c> recTypeLst = new List<Record_Type__c>();
        List<RecordTypeWrapper> rtWrapLst = new List<RecordTypeWrapper>();
        rtType = new LiST<Record_Type__c>();
        List<Schema.RecordTypeInfo> rtiLst = Schema.getGlobalDescribe().get(objName).getDescribe().getRecordTypeInfos();
        for (Schema.RecordTypeInfo rtInfo : rtiLst) {
            RecordTypeWrapper rtWrap = new RecordTypeWrapper();
            recTypeLst.add(new Record_Type__c(Name = rtInfo.getName()));
            rtWrap.recordTypeName = rtInfo.getName();
            rtWrap.recordTypeDevName = rtInfo.getDeveloperName();
            rtWrap.recordTypeId = rtInfo.getRecordTypeId();
            rtWrap.isActive = rtInfo.isActive();
            rtWrap.isDefault = rtInfo.isDefaultRecordTypeMapping();
            rtWrap.isMaster = rtInfo.isMaster();
            rtWrap.pgNames = getPageLayoutNames(objName);
            Record_Type__c rt = new Record_Type__c(Name = rtWrap.recordTypeName);
            rtType.add(rt);
            if (rtWrap.isActive) {
                rtWrapLst.add(rtWrap);
            }
        }
        // try {
        //     insert recTypeLst;
        // } catch (Exception e) {
        //     System.debug('ERROR ' + e.getMessage());
        // }
        return rtWrapLst;
    }

    public List<SelectOption> getPageLayoutNames(String objName){
        
        List<SelectOption> pgNames = new List<SelectOption>{new SelectOption('NA', 'NA')};
        // String instance = [SELECT instanceName FROM Organization].InstanceName;
        // String baseUrl = 'https://' + instance + '.salesforce.com';
        // String endPoint = '  ';
        // HTTP h = new HTTP();
        // HttpRequest req = new HttpRequest();
        // req.setMethod('GET');
        // req.setEndpoint(endPoint);
        // HttpResponse res = h.send(req);
        // Map<String, Object> resBody = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        // List<Object> pgRecords = (List<Object>) resBody.get('records');
        // for (Object pgr : pgRecords) {
        //     pgNames.add(new SelectOption((String)pgr.get('FullName'), (String)pgr.get('FullName')));
        // }
        PageLayout__C pgl = new PageLayout__c();
        pgl.Name = 'NA';
       // pgl.Object__C = objName;
        // try {
        //     insert pgl;
        // } catch (Exception e) {
        //     System.debug('ERROR ' + e.getMessage());
            
        // }
        return pgNames;
    }

    public void initFieldOptionsMap(String view){
        ObjectOptions objOpt = objOpts.get(view);
        fldOpts = new Map<String, FieldOptions>();
        Integer count = 1;
        for (SelectOption selOpt : objOpt.selectedObjectOptions) {
            FieldOptions fldOpt = new FieldOptions();
            fldOpt.index = count++;
            initFieldOptions(selOpt.getValue(), view, fldOpt);
            fldOpts.put(selOpt.getValue(), fldOpt);
        }
    }

    public void initFieldOptions(String objName, String viewName, FieldOptions fldOpt){
        initavailableAndSelectedFieldOptions(objName, viewName, fldOpt);
    }

    public void initavailableAndSelectedFieldOptions(String objName, String viewName, FieldOptions fldOpt){
        List<SelectOption> allFldOptions = getAllFieldOptions(objName);
        fldOpt.selectedFieldOptions = getselectedFieldOptions(objName, viewName, fldOpt);
        fldOpt.availableFieldOptions = getAvailableFieldOptions(allFldOptions, fldOpt.selectedFieldOptions);
    }

    public List<SelectOption> getAllFieldOptions(String objName){
        List<SelectOption> allFldOpt = new List<SelectOption>();
        for (Schema.SObjectField sObjFldType :  Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().Values()) {
            Schema.DescribeFieldResult fldDescribe = sObjFldType.getDescribe();
            if (!(fldDescribe.Label.contains('Geocode') || fldDescribe.Label.contains('Billing Address') || fldDescribe.Label.contains('Other Address') || fldDescribe.Label.contains('Shipping Address'))) {
                SelectOption so = new SelectOption(fldDescribe.name, fldDescribe.label);  
                allFldOpt.add(so);
            }
            
        }
        return allFldOpt;
    }

    public List<SelectOption> getselectedFieldOptions(String objName, String viewName, FieldOptions fldOpt){
        List<SelectOption> selFldOpt = new List<SelectOption>();
        for (Object__c ss : [SELECT Name, Fields__c, Fields_Developer_Name__c FROM Object__c WHERE Developer_Name__c = :objName AND View__c = :viewName LIMIT 1000]) {
            if (ss.Fields__c == '' || ss.Fields__c == null || ss.Fields_Developer_Name__c == '' || ss.Fields_Developer_Name__c == null) {
                return selFldOpt;
            }
            List<String> fldName =  ss.Fields__c.split('; ');
            List<String> fldDevName = ss.Fields_Developer_Name__c.split('; ');
            if(fldName.size() != fldDevName.size()){
               error += 'Something went wrong! Fields could not be fetched for Object: ' + ss.Name + '<br/>';
               //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Something went wrong! Fields could not be fetched for Object: ' + ss.Name));
               return selFldOpt;
            }
            for (Integer i = 0; i < fldName.size(); i++) {
                SelectOption so = new SelectOption(fldDevName[i], fldName[i]);
                selFldOpt.add(so);   
            }
        }
        return selFldOpt;
    }

    public List<SelectOption> getAvailableFieldOptions(List<SelectOption> allFldOpt, List<SelectOption> selFldOpt){
        List<SelectOption> avlFldOpt = new List<SelectOption>();
        for (SelectOption afo : allFldOpt) {
            Boolean flag = true;
            for (SelectOption sfo : selFldOpt) {
                if (afo.getValue() == sfo.getValue()) {
                    flag = false;
                }
            }
            if (flag) {
                avlFldOpt.add(afo);
            }
        }
        return avlFldOpt;
    }

    public void updateObjectOptionsMap(String viewName){
        List<Object__c> existingObjectRecords = new List<Object__c>();
        try {
            if (ViewName == 'Related List View') {
                existingObjectRecords = [SELECT Developer_Name__c, Position__c, view__C FROM Object__c];
                deleteObjectList(viewName, existingObjectRecords);
                insertAndUpdateObjectList(viewName, existingObjectRecords);
            }else if(viewName == 'None'){
                existingObjectRecords = [SELECT Developer_Name__c, Position__c, view__C FROM Object__c];
                deleteObjectListFromControl(viewName, existingObjectRecords);
                insertAndUpdateObjectList(viewName, existingObjectRecords);
                }else {
                    existingObjectRecords = [SELECT Developer_Name__c, Position__c, view__C FROM Object__c WHERE View__c = :viewName];
                    deleteObjectList(viewName, existingObjectRecords);
                    insertAndUpdateObjectList(viewName, existingObjectRecords);
                }
            
        } catch (Exception e) {
            error += 'Something went wrong. Could\'nt update Schema. Error: ' + e.getMessage() + '<br/>';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Something went wrong. Could\'nt update Schema. Error: ' + e.getMessage()));
        }
    }

    public void deleteObjectList(String viewName, List<Object__c> existingObjectRecords){

        if(viewName == 'Related List View')
            existingObjectRecords = [SELECT developer_Name__c, view__C FROM Object__c WHERE View__c = 'Related List View'];
        List<Object__c> objRecToDelete = new List<Object__c>();
        ObjectOptions objOpt = objOpts.get(viewName);
        List<SelectOption> selObjOpt = objOpt.selectedObjectOptions;
        for (Object__c ss : existingObjectRecords) {
            boolean flag = false;
            for (SelectOption so : selObjOpt) {
                if (ss.Developer_Name__C == so.getValue()) {
                    flag = true;
                }
            }
            if (flag == false) {
                objRecToDelete.add(ss);
            }
        }
        List<id> toDeleteRecType = new List<id>();
        Map<Id, Id> replaceId = new Map<Id, Id>();
        Map<Id, Object__C> mapName = new Map<id, Object__c>([SELECT developer_Name__c, View__c, Name FROM Object__C WHERE Id IN (SELECT Object__c FROM Record_Type__c)]);
        List<id> recTypeToDelete = new List<id>();
        List<Object__c> existingObjectRecords1 = [SELECT Developer_name__c, View__C, Name FROM Object__C];
        try {
            for (Object__c ob : objRecToDelete) {
          
            if (mapName.keySet().contains(ob.id)) {
                
                for (Object__c existObj : existingObjectRecords1) {
                   
                    if (existObj.developer_Name__C == ob.developer_Name__C && existObj.view__C != ob.view__C) {
                       
                        replaceId.put(ob.id, existObj.id);
                        
                    }else {
                        
                        recTypeToDelete.add(ob.id);
                    }
                    
                }
            }
        }
        if(replaceId != null && replaceId.size() >0){

            replaceObjectInRecordType(replaceId);
            replaceObjectInRelatedList(replaceId);
        }
        if (recTypeToDelete != null &&recTypeToDelete.size() > 0) {
            toDeleteRecordType(recTypeToDelete);
        }
        delete objRecToDelete;
        if (objRecToDelete.Size() > 1) {
            Database.emptyRecycleBin(objRecToDelete);
        }
        } catch (Exception e) {
            System.debug(e.getMessage() + '===   ' + e.getLineNumber());
        }
    }

public void replaceObjectInRecordType(Map<id, id> idMap){

    try {
        List<Record_Type__C> toUpdateRcType = [SELECT object__c FROM Record_Type__c WHERE object__c IN :idMap.keyset()];
        for (Record_Type__c rt : toUpdateRcType) {
            rt.Object__c = idMap.get(rt.Object__c);
        
        }
    update toUpdateRcType;
    } catch (Exception e) {
    }
}
public void replaceObjectInRelatedList(Map<id, id> idMap){
    try {
        List<RelatedList__c> toUpdateRL = [SELECT object__c FROM RelatedList__c WHERE object__c IN :idMap.keyset()];
        for (RelatedList__c rt : toUpdateRL) {
            rt.Object__c = idMap.get(rt.Object__c);
        
        }
    update toUpdateRL;
    } catch (Exception e) {
        Apexpages.addMessage(new Apexpages.message(Apexpages.Severity.ERROR, e.getMessage()));
    }
}

 public  void toDeleteRecordType(List<id> recIdLst){

     try {
         Delete [SELECT Id FROM Record_type__c WHERE Object__c IN :recIdLst];
     } catch (Exception e) {
     }
 }
    public void deleteObjectListFromControl(String viewName, List<Object__c> existingObjectRecords){
        List<Object__c> objRecToDelete = new List<Object__c>();
        ObjectOptions objOpt = objOpts.get(viewName);
        if(viewName == 'None')
            existingObjectRecords = [SELECT developer_Name__c FROM Object__c WHERE View__c = ''];
        else {
            existingObjectRecords = [SELECT developer_Name__c FROM Object__c WHERE View__c = 'Related List View'];
        }
        List<SelectOption> selObjOpt = objOpt.selectedObjectOptions;
        for (Object__c ss : existingObjectRecords) {
            boolean flag = false;
            for (SelectOption so : selObjOpt) {
                if (ss.Developer_Name__C == so.getValue()) {
                    flag = true;
                }
            }
            if (flag == false) {
                System.debug(existingObjectRecords.size());
                System.debug(ss);
                objRecToDelete.add(ss);
            }
        }
        try {
            delete objRecToDelete;
        } catch (Exception e) {
             System.debug(e.getMessage() + 'At Line ' + e.getLineNumber());
        }
        if (objRecToDelete.Size() > 1) {
            Database.emptyRecycleBin(objRecToDelete);
        }
    }

    public void insertAndUpdateObjectList(String viewName, List<Object__c> existingObjectRecords){
        List<Object__c> objRecToInsert = new List<Object__c>();
        List<Object__c> objRecToUpdate = new List<Object__c>();
        ObjectOptions objOpt = objOpts.get(viewName);
        List<SelectOption> selObjOpt = objOpt.selectedObjectOptions;
        Integer index = 1;
        List<String> existing =  new List<String>();
        Map<String, List<Object__c>> existingMap = new Map<String, List<Object__c>>();
        for (Object__C ob : [SELECT Developer_Name__c, view__C FROM oBJECT__C WHERE View__C = '']) {
            if(!existing.contains(ob.developer_Name__C)){
                existing.add(ob.developer_Name__c);
                existingMap.put(ob.developer_Name__C, new List<Object__C>{ob});
            }else {
                existingmap.put(ob.developer_Name__c, (List<object__c>)existingMap.get(ob.developer_Name__c).add(ob));
            }
        }
        for (SelectOption so : selObjOpt) {
            boolean flag = false;
            for (Object__c ss : existingObjectRecords) {
                if (so.getValue() == ss.Developer_Name__C) {

                    ss.Position__c = index++;
                    objRecToUpdate.add(ss);
                    flag = true;
                }
            }
            if (flag == false) {
                if (viewName == 'None') {

                    objRecToInsert.add(new Object__c(Name = so.getLabel(), Developer_Name__c = so.getValue()));
                }else {
                    if(existing.contains(so.getValue())){
                        object__C objInstance = existingMap.get(so.getValue())[0];
                        objInstance.view__c = viewName;
                        objInstance.position__c = index++;
                        objRecToUpdate.add(objInstance);
                    }else {
                        objRecToInsert.add(new Object__c(Name = so.getLabel(), Developer_Name__c = so.getValue(), Position__c = index++, view__c = viewName));
                    }
                    
                }
            }
        }
        
        insert objRecToInsert;
        update objRecToUpdate;
       
        //if(viewName == 'None')
            createRecordType(objRecToUpdate, objRecToInsert);
    }
    public void createRecordType(List<Object__c> forUpdate, List<Object__c> forInsert){
        Boolean isInsert = false;
        List<object__c> bothLst = new List<Object__c>();
        bothLst.addAll(forUpdate);
        bothLst.addAll(forInsert);

        List<Profile__c> profileLst = [SELECT Name FROM Profile__c];
        List<record_type__c> recTypeLst = new List<record_type__c>();
        try {
            if(refreshProfile){
                    //will do for Profile refresh
            }else {
                List<String> sObjecttypeLst = new List<String>();
                List<Object__C> bothLst1 = new List<Object__C>();
                for (Object__c ob : bothLst) {
                    if(!sObjecttypeLst.contains(ob.developer_Name__c)){
                        bothLst1.add(ob);
                        sObjecttypeLst.add(ob.developer_Name__c);
                    }
                }
                Map<String, recordType> rectMap = new Map<String,recordType>();
                List<String> existingRecordType = new List<String>();
                 for (Record_Type__c rType :  [SELECT Object__r.developer_Name__c, Name FROM Record_Type__C ORDER BY Object__r.Name]) {
                        existingRecordType.add(rType.Object__r.developer_Name__c + rType.Name);
                    }
                    List<String> objWithoutRType = new List<String>();
                    for (recordType rt  : [SELECT id, Name,sobjectType, isActive FROM RecordType Where sobjecttype IN : sObjecttypeLst ORDER BY SobjectType]) {
                        if(sObjecttypeLst.contains(rt.sobjectType)){
                            sObjecttypeLst.remove(sObjecttypeLst.indexOf(rt.sobjectType));
                        }
                        if(rt.isActive){
                            for(Object__c ob : bothLst1){
                            if (rt.sobjectType == ob.developer_Name__C && !existingRecordType.contains(ob.developer_Name__C + rt.Name) ) {
                                for (Profile__C pr  : profileLst) {
                                    isInsert = true; 
                                    Record_Type__c rtObj = new Record_Type__c();
                                    rtObj.Name = rt.Name;
                                    rtObj.Profile__c = pr.id;
                                    rtObj.Object__c = ob.id;
                                    rtObj.RecordTypeId__C = rt.id;
                                    recTypeLst.add(rtObj);
                                    }
                                }   
                            }
                        }
                        
                    }
                
                initRecTypeForObjWithoutId(sObjecttypeLst);
            }
            
           if(isInsert)
                insert recTypeLst;
                System.debug(recTypeLst);
        } catch (Exception e) {
            error += e.getMessage() + '<br/>';
           // Apexpages.addMessage(New ApexPages.message(Apexpages.Severity.ERROR, e.getMessage()));
            
        }
    }

    public void initRecTypeForObjWithoutId(List<String> objLst){
        // This method insert recordtype which don't have recordType
        Map<String, Schema.SObjectType> mp = Schema.getGlobalDescribe();
        List<Record_Type__C> recTypeLst = new List<Record_Type__C>();
        try {
            List<String> existingRType = new List<String>();
            for(Record_Type__c rt : [SELECT Name, profile__r.id, Object__r.id FROM Record_Type__C WHERE Object__r.developer_Name__C IN : objLst]){
                existingRType.add(rt.Name + rt.Object__r.id + rt.profile__r.id);
            }
            List<String> duplicate  = new list<String>();

            for(Object__C ob : [SELECT developer_name__c  FROM Object__C WHERE Developer_name__C IN :objLst]){
                if(!duplicate.contains(ob.developer_Name__C)){
                    duplicate.add(ob.developer_Name__C);
                    Schema.DescribeSObjectResult d = mp.get(ob.developer_Name__C).getdescribe(); 
                    Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
                    String key = (new list<id>(rtMapById.keyset()) )[0];
                    Schema.RecordTypeInfo recTyp = rtMapById.get(key);
                    for(Profile__c pro : [SELECT Id FROM profile__C]){
                        if (!existingRType.contains(recTyp.name + ob.id + pro.id)) {
                            Record_Type__c rtObj = new Record_Type__c();
                            rtObj.isPermitted__C = true;
                            rtObj.Name = recTyp.Name;
                            rtObj.Profile__c = pro.id;
                            rtObj.Object__c = ob.id;
                            rtObj.RecordTypeId__C = key;
                            recTypeLst.add(rtObj);
                        }
                    }
                }
                
            }
            insert recTypeLst;
        } catch (Exception e) {
            System.debug(e.getMessage() + ' line ==> ' + e.getLineNumber());
           Apexpages.addMessage(new apexpages.message(Apexpages.Severity.ERROR, e.getMessage() + ' line ==> ' + e.getLineNumber()));
        }
    }
    public Pagereference updateFieldOptionsMap(){
        try {
            nextPage = 'ObjectSelection';
            Map<String, FieldValues> updatedValue = new Map<String, FieldValues>();
            for (String objName : fldOpts.keySet()) {
                FieldValues fv = new FieldValues();
                List<SelectOption> selectedFldOpt = fldOpts.get(objName).selectedFieldOptions;
                fv.fieldNames = getLabelsFromSelectOption(selectedFldOpt);
                fv.fieldDevNames = getValuesFromSelectOption(selectedFldOpt);
                updatedValue.put(objName, fv);
            }
            if (fldUpdateValue == 'object__c') {
                List<Object__c> ssRecToUpdate = new List<Object__c>();
                for (Object__c ss : [SELECT Developer_Name__c, Fields__c, Fields_Developer_Name__c FROM Object__c WHERE View__c = :focusedView AND Developer_Name__c IN :fldOpts.keySet()]) {
                    ss.Fields__c = updatedValue.get(ss.Developer_Name__c).fieldNames;
                    ss.Fields_Developer_Name__c = updatedValue.get(ss.Developer_Name__c).fieldDevNames;
                    ssRecToUpdate.add(ss);
                }
                update ssRecToUpdate;
            }else if(fldUpdateValue == 'relatedlist__c'){
                List<RelatedList__c> ssRecToUpdate = new List<RelatedList__c>();
                for (RelatedList__c ss : [SELECT Developer_Name__c, Fields__c, Fields_Developer_Name__c, object__r.Developer_name__c FROM RelatedList__c WHERE Developer_Name__c IN :fldOpts.keySet()]) {
                    
                    ss.Fields__c = updatedValue.get(ss.Developer_Name__c).fieldNames;
                    ss.Fields_Developer_Name__c = updatedValue.get(ss.Developer_Name__c).fieldDevNames;
                    ssRecToUpdate.add(ss);
                }
                update ssRecToUpdate;
            }
        } catch (Exception e) {
            error += 'Something went wrong. Could\'nt update Schema Fields. Error: ' + e.getMessage() + '<br/>';
        }
        return null;
    }

    public String getLabelsFromSelectOption(List<SelectOption> soList){
        List<String> labelList = new List<String>();
        for (SelectOption so : soList) {
            labelList.add(so.getLabel());
        }
        if (!labelList.isEmpty()) {
            return String.join(labelList, '; ');
        }else {
            return '';
        }
    }

    public String getValuesFromSelectOption(List<SelectOption> soList){
        List<String> ValueList = new List<String>();
        for (SelectOption so : soList) {
            ValueList.add(so.getValue());
        }
        if (!ValueList.isEmpty()) {
            return String.join(ValueList, '; ');
        }else {
            return '';
        }
    }

    id batchJobId ; 
    public void initProfileBatchApex(List<String> objString){
        if(batchJobId != null){
            AsyncApexJob aap = [SELECT Status FROM AsyncApexJob WHERE Id = :jobId];  
            if(aap.Status == 'Completed' || aap.Status == 'Failed' || aap.Status == 'Aborted'){ 
                SetProfileSecurityBatch sPro = new SetProfileSecurityBatch(objString);
                batchJobId =  Database.executeBatch(sPro, 5);
               System.debug(batchJobId);
            }
            else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Warning, 'The process is already going on. Please wait for sometime, untill it finishes'));  
            }
        }else {
            SetProfileSecurityBatch sPro = new SetProfileSecurityBatch(objString);
            batchJobId = Database.executeBatch(sPro, 5);
        }
       
    }


    public void initrelatedList(){
       rltOpts = new MAp<String, RelatedObjOption>();
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        try {
             List<Object__c> objLst = [SELECT Developer_Name__C, Name FROM Object__c WHERE view__C IN ('Related List View', 'All Records View', 'Search Records View')];
             Integer count = 1;
            for (Object__c ob : objLst) {
             RelatedObjOption relatedWrap = new RelatedObjOption();
             relatedWrap.index = count++;
             relatedWrap.availableObjOptions = new List<SelectOption>();
             relatedWrap.selectedObjOptions = new List<selectoption>();
             relatedWrap.selectedObjOptions = getSelectedRelatedObj(ob.id);
            Schema.DescribeSObjectResult R = gd.get(ob.developer_Name__c).getDescribe();
            Map<String, String> objList = new Map<String, String>();
            for (Schema.ChildRelationship cr: R.getChildRelationships()) 
                {
                    objList.put(cr.getChildSObject().getDescribe().getName(), cr.getChildSObject().getDescribe().getlabelPlural() );
                
                }
                List<String> o = new List<String>(objList.keySet());
                //List<String> finalObjLst = filterObjectList(o);
                SelectOption selectop ;
                for(String s : o){
                    if(s != 'Event' && s != 'task')
                        selectop = new SelectOption(S, objList.get(s));
                    // relObjMap.put(objList.get(s),s);
                    if(!relatedWrap.selectedObjOptions.contains(selectop))
                        relatedWrap.availableObjOptions.add(selectop);
                }
                rltOpts.put(ob.Developer_Name__C, relatedWrap);
        }
        nextPage ='RelatedList';
        } catch (Exception e) {
            error += e.getMessage() + 'Line ==>>  ' + e.getLineNumber() + '<br/>';
           // Apexpages.addMessage(new apexpages.message(Apexpages.Severity.ERROR, e.getMessage() + 'Line ==>>  ' + e.getLineNumber()));   
        }
    }


public void initrelatedListPbjMap(){

}
    public Pagereference saveRelatedList(){
        List<RelatedList__C> relList = new List<RelatedList__C>();
        List<RelatedList__c> existingRecords = [SELECT Name, developer_name__c FROM relatedList__c];
        Map<String, id> parentObjMap = new Map<String, id>();
        for (Object__c ob : [SELECT id, developer_Name__C FROM  Object__c]) {
            parentObjMap.put(ob.developer_Name__C, ob.id);
        }
        for(String s : rltOpts.keySet()){
            for (selectoption so  : rltOpts.get(s).selectedObjOptions) {
                RelatedList__C rl = new RelatedList__c();
                rl.Name = so.getLabel();
                rl.developer_Name__C = so.getValue();
               
                rl.Object__C = parentObjMap.get(s);
                relList.add(rl);
            }
        }
        insertRelatedObj(relList, existingRecords);
        deleteRelatedObj(relList, existingRecords);
        return null;    
    }

    public void insertRelatedObj(List<RelatedList__C> relList, List<RelatedList__C> existingRecords){
        List<String> objString = new List<String>();
        List<RelatedList__C> toInsert = new List<RelatedList__C>();
        for(RelatedList__c rl : relList){
            Boolean flag = false;
            for (Relatedlist__c rlt : existingRecords) {
                if(rl.developer_Name__c  == rlt.developer_Name__C){
                    flag = true;
                }
            }
            if (flag == false) {
               
                toInsert.add(rl);
                objString.add(rl.developer_Name__C);
            }
        }
        try {
            Insert toInsert;
            if (objString != null && objString.size() > 0 ) {
                initProfileBatchApex(objString);
            }
            Apexpages.addMessage(new Apexpages.message(apexpages.Severity.CONFIRM, 'All records inserted successfully'));
        } catch (Exception e) {
            Apexpages.addMessage(new apexpages.message(Apexpages.Severity.ERROR, e.getMessage() + ' Line ==> ' + e.getLineNumber()));
        }
    }
    Public void deleteRelatedObj(List<RelatedList__C> relList, List<RelatedList__C> existingRecords){

        List<RelatedList__C> toDelete = new List<RelatedList__C>();
        for(RelatedList__c rl :existingRecords){
            Boolean flag = false;
            for (Relatedlist__c rlt : relList) {
                if(rl.developer_Name__c  == rlt.developer_Name__C){
                   flag = true;
                }
            }
            if(flag == false){
                 toDelete.add(rl);
            }
        }

        try {
            delete toDelete;
            if (toDelete.Size() > 1) {
            Database.emptyRecycleBin(toDelete);
        }
        } catch (Exception e) {
            System.debug(e.getMessage());
            Apexpages.addMessage(new Apexpages.message(Apexpages.Severity.ERROR, e.getMessage() + ' ==> ' + e.getLineNumber()));
        }
    }
    public List<selectoption> getSelectedRelatedObj(String ids){
            List<Selectoption> selObjOpt = new List<selectoption>();
           for (RelatedList__c ss : [SELECT Name, developer_Name__c FROM RelatedList__c WHERE object__c = :ids]) {
            SelectOption so = new SelectOption(ss.Developer_Name__c, ss.Name);
            if (!selObjOpt.contains(so)) {
                selObjOpt.add(so);
            }
        }
        return selObjOpt;
    }
    public void initFldOPtionForRelatedObj(){
        fldUpdateValue = 'relatedlist__c';
        nextPage = 'FieldSelection';
        isJobIdRefresh = 'FieldSelection';
        fldOpts = new Map<String, FieldOptions>();
        for(String ss : rltOpts.keySet()){
                Integer count = 1 ;
            for (Selectoption so : rltOpts.get(ss).selectedObjOptions) {
                FieldOptions fldop = new FieldOptions();
                fldop.index = count++;
                fldop.selectedFieldOptions = getSelectedFieldsForRelatedList(so.getValue());
                fldOp.availableFieldOptions = getAvailableFieldOptions(getAllFieldOptions(so.getValue()), fldop.selectedFieldOptions);
                fldOpts.put(so.getValue(), fldOp);
            }
            
        }
    }

    public List<selectoption> getSelectedFieldsForRelatedList(String objName){
        List<SelectOption> selFldOpt = new List<SelectOption>();
        List<String> eliminateObject = new List<String>();
        for (RelatedList__c ss : [SELECT Name, Fields__c, Fields_Developer_Name__c, developer_Name__C FROM RelatedList__c WHERE Developer_Name__c = :objName  LIMIT 1000]) {
            if (ss.Fields__c == '' || ss.Fields__c == null || ss.Fields_Developer_Name__c == '' || ss.Fields_Developer_Name__c == null) {
                return selFldOpt;
            }
            if(!eliminateObject.contains(ss.developer_Name__C)){
                eliminateObject.add(ss.developer_Name__C);
                List<String> fldName =  ss.Fields__c.split('; ');
                List<String> fldDevName = ss.Fields_Developer_Name__c.split('; ');
            
                if(fldName.size() != fldDevName.size()){
                error += 'Something went wrong! Fields could not be fetched for Object: ' + ss.Name + '<br/>';
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Something went wrong! Fields could not be fetched for Object: ' + ss.Name));
                return selFldOpt;
                }
                for (Integer i = 0; i < fldName.size(); i++) {
                    SelectOption so = new SelectOption(fldDevName[i], fldName[i]);
                    selFldOpt.add(so);   
                }
            }
        }
        return selFldOpt;
    }
    Public class RelatedObjOption{
        public List<SelectOption> availableObjOptions {get;set;}
        public List<SelectOption> selectedObjOptions {get;set;}
        public Integer index {get;set;}
    }
    public class FieldValues{
        public String fieldNames;
        public String fieldDevNames;
    }

    public class ObjectOptions{
        public List<SelectOption> availableObjectOptions {get;set;}
        public List<SelectOption> selectedObjectOptions {get;set;}
    }

    public class FieldOptions{
        public List<SelectOption> availableFieldOptions {get;set;}
        public List<SelectOption> selectedFieldOptions {get;set;}
        public Integer index {get;set;}
    }
     public class ProfileWrapper{
        public String profileName {get;set;}
        public List<RecordTypeWrapper> rtWrap {get;set;}
    }
  

    public class RecordTypeWrapper{
        public String recordTypeName {get;set;}
        public String recordTypeDevName {get;set;}
        public String recordTypeId {get;set;}
        public Boolean isActive {get;set;}
        public Boolean isDefault {get;set;}
        public Boolean isMaster {get;set;}
        public List<SelectOption> pgNames {get;set;}
    }

     
    public class WrapperOne{
        public List<PageLayoutWrapper> pglWrapperInstance = new List<PageLayoutWrapper>();
        public List<String> rtList = new List<String>();
        public String profile {get; set;}
    } 
    public class  PageLayoutWrapper{
        public String selectedPageLayout {get; set;}
        public Map<String, List<PageLayout__c>> pageLayoutMap {get; set;}

    }


    public void execute(QueueableContext context){  
        if(focusedView == 'Relatd List View'){
            
        }else if (focusedView == 'None') {
           updateObjectOptionsMap(focusedView);
           initobjMap();                                        
           nextPage = 'PageLayoutSelection';
         
        }else if (focusedView != null) {
            if (objOpts.get(focusedView).selectedObjectOptions.isEmpty()) {
                
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Objects Selected'));
                updateObjectOptionsMap(focusedView);
                //return null;
            }
            updateObjectOptionsMap(focusedView);
            initFieldOptionsMap(focusedView);
            nextPage = 'FieldSelection';
           /// return null;
        }
        else {
            error += 'Could\'nt fetch view <br/>';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could\'nt fetch view'));
           // return null;
        }  
    }  

}