public class CreateRecordComponentController {
    

    public List<String> recordIdList {get; set;}
    public List<String> flds{get;set;}
    public RecordWrapper recWrap {get;set;}
    
    @testVisible String selectedobj;
    @testVisible String recId;
    
    public Map<String, NotificationMessage> needJavaScript {get;set;}
    @testVisible String JavaScriptFunctionCall;
    
    public String selectedRecordTypeId {get;set;}
    public List<RTInfo> recTypeInfoLst {get;set;}
    public Boolean isNoRecordType {get;set;}
    public Boolean isrecordType {get; set;}
    
    public List < LayoutDescriberHelper.LayoutSection > layoutSections {
        get;
        set;
    }
    
    public Map<String, List<String>> sectionFields {get;set;}
    
    public String getselectedobj(){
        return selectedobj;
    }
    
    public void setselectedobj(String objName){
        if(selectedobj == null || selectedobj != objName ){
            selectedobj = objName;
            initInsetter();
        }
    }
    
    public void setrecId(String rId){
        
        if(recId == null ||  recId != rId){
            recId = rId;
            initInsetter();
        }
    }
    
    public void initInsetter(){
        isrecordType = true;
        recordIdList = new List<String>();
        Id uId = Apexpages.currentPage().getParameters().get('UserId');
        user= database.query('SELECT id, first_Name__C, last_Name__c, name, Profile__C, Email__C FROM Site_User__c Where id = :uId limit 1'); 
        if (recId != 'NA' && recId != null) {
            // Edit mode
            try{
                initRecTypeInfoLst();
                initSectionFields(getRecordTypeIdFromRecordId(recId));
                initRecord();
                getSelectedValueFromMultiSelectPickList();
            }catch(Exception e){
                System.debug('Exception in class: ' + String.valueOf(this).split(':')[0] + ' === Message: ' + e.getMessage() + ' === At Line: ' + e.getLineNumber());
            }
        }else{
            // Create Mode
            try{
                initFieldsAndRecordWrapper();
            }catch(Exception e){
                System.debug('Exception in class: ' + String.valueOf(this).split(':')[0] + ' === Message: ' + e.getMessage() + ' === At Line: ' + e.getLineNumber());
            }
        } 
    }
    
    public Id getRecordTypeIdFromRecordId(Id rid){
        if (recTypeInfoLst != null) {
            if (recTypeInfoLst.size() == 1) {
                return recTypeInfoLst[0].id;
            }else{
                String query = 'SELECT RecordTypeId FROM ' + selectedobj + ' WHERE Id = :rid';
                return (Id)Database.query(query)[0].get('RecordTypeId');
            }
        }else{
            //List<Schema.RecordTypeInfo> rtiLst = Schema.getGlobalDescribe().get(selectedobj).getDescribe().getRecordTypeInfos();
            List<Record_Type__C> rtiLst = getRecordTypeIDFromDatabase();
            if (rtiLst.size() == 1) {
                return rtiLst[0].id;
            }else{
                String query = 'SELECT RecordTypeId FROM ' + selectedobj + ' WHERE Id = :rid';
                return (Id)Database.query(query)[0].get('RecordTypeId');
            }
        }
    }
    

    public list<Record_Type__C> getRecordTypeIDFromDatabase(){
        List<Record_Type__C> RecTypeLst = new List<Record_Type__C>();
        try {
            List<Record_type__C> rtTypeLst = [SELECT RecordTypeId__C, Name, isPermitted__c FROM Record_Type__c WHERE Object__r.developer_Name__C = :selectedobj AND profile__r.Name = :user.Profile__c];
           
            for (Record_Type__C rt  : rtTypeLst) {
                if(rt.isPermitted__C == true){
                    RecTypeLst.add(rt);
                }else {
                    needJavaScript.put('Success', new NotificationMessage(false, 'NA', 'NA'));
                    needJavaScript.put('Failure', new NotificationMessage(true, 'ERROR', 'You don\' have permission on record type. Please Contact your administrator.'));
                }

            }
        } catch (Exception e) {
            needJavaScript.put('Success', new NotificationMessage(false, 'NA', 'NA'));
            needJavaScript.put('Failure', new NotificationMessage(true, 'ERROR', e.getMessage()));
        }
        return RecTypeLst;
    }
    public String getrecId(){
        return recId;
    }
    
    
    public CreateRecordComponentController(){
        isrecordType = false;
        recordIdList = new List<String>();
        selectedRecordTypeId = null;
        initNotificationMap();
    }
    
    public void initFieldsAndRecordWrapper(){
            initRecTypeInfoLst();
            if (this.isNoRecordType == null) {
                needJavaScript.put('Success', new NotificationMessage(false, 'NA', 'NA'));
                needJavaScript.put('Failure', new NotificationMessage(true, 'ERROR', 'You don\' have permission on record type. Please Contact your administrator.'));
              
                flds = new List<String>();
            }else if (this.isNoRecordType) {
                initSectionFields(recTypeInfoLst[0].id);
                }else{
                    flds = new List<String>();
                }
        
    }
    
    public void initRecTypeInfoLst(){
        //List<Schema.RecordTypeInfo> rtiLst = Schema.getGlobalDescribe().get(selectedobj).getDescribe().getRecordTypeInfos();
        recTypeInfoLst = new List<RTInfo>();
        selectedRecordTypeId = null;
        try {

            List<Record_type__C> rtTypeLst = [SELECT RecordTypeId__C, Name, isPermitted__c FROM Record_Type__c WHERE Object__r.developer_Name__C = :selectedobj AND profile__r.Name = :user.Profile__c];
           
            for (Record_Type__C rt  : rtTypeLst) {
                 if(rt.Name == 'Master' && rtTypeLst.size() == 1){
                        RTInfo rtInf = new RTInfo();
                        rtInf.Name = rt.Name;
                        rtInf.id = rt.RecordTypeId__c;
                        recTypeInfoLst.add(rtInf);
                        isNoRecordType = true;
                    }else{
                        isNoRecordType = false;
                        if(rt.isPermitted__C == true){
                            RTInfo rtInf = new RTInfo();
                            rtInf.Name = rt.Name;
                            rtInf.id = rt.RecordTypeId__c;
                            recTypeInfoLst.add(rtInf);
                        }else {
                            needJavaScript.put('Success', new NotificationMessage(false, 'NA', 'NA'));
                            needJavaScript.put('Failure', new NotificationMessage(true, 'ERROR', 'You don\' have permission on record type. Please Contact your administrator.'));
                    
                        }
                    }
            }
        } catch (Exception e) {
            System.debug(e.getMessage() + '  ' + e.getLineNumber());
            needJavaScript.put('Success', new NotificationMessage(false, 'NA', 'NA'));
            needJavaScript.put('Failure', new NotificationMessage(true, 'ERROR', e.getMessage()));
        }
        // for (RecordTypeInfo rti : rtiLst) {
        //     RTInfo rtInf = new RTInfo();
        //     rtInf.name = rti.getName();
        //     rtInf.devName = rti.getDeveloperName();
        //     rtInf.id = rti.getRecordTypeId();
        //     rtInf.isActive = rti.isActive();
        //     rtInf.isDefault = rti.isDefaultRecordTypeMapping();
        //     rtInf.isMaster = rti.isMaster();
        //     if (rtInf.isActive) {
        //         recTypeInfoLst.add(rtInf);
        //     }
        //     if(recTypeInfoLst.size() == 1){
        //         isNoRecordType = true;
        //     }else{
        //         removeMasterRecordType(recTypeInfoLst);
        //         isNoRecordType = false;
        //     }
        // }
    }
    
    public void removeMasterRecordType(List<CreateRecordComponentController.RTInfo> rtinf){
        Integer index = -1;
        for(Integer i = 0; i < rtinf.size(); i++){
            if(rtinf[i].isMaster == true){
                index = i;
            }
        }
        if(index != -1){
            rtinf.remove(index);
        }
    }
    
    public List<SelectOption> getAvailableRecordTypes(){
        
        List<SelectOption> availableRT = new List<SelectOption>();
        
        for (RTInfo rti : recTypeInfoLst) {
            SelectOption so = new SelectOption(rti.id, rti.name);
            availableRT.add(so);
        }
        return availableRT;
    }
    
    public Pagereference initSelectedRecordTypeId(){
        selectedRecordTypeId = null;
        return null;
    }
    
    @testVisible static String restGet(String endPoint, String method, String sid) {
        Http h = new Http();
        HttpRequest hr = new HttpRequest();
        hr.setHeader('Authorization', 'Bearer ' + sid);
        hr.setTimeout(60000);
        hr.setEndpoint(endPoint);
        hr.setMethod(method);
        HttpResponse r = h.send(hr);
        return r.getBody();
    }
    
   @testVisible static String toolingAPISOQL( String query) {
        String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
        return restGet( baseURL + '/services/data/v41.0/tooling/query?q='+ (query.replace(' ', '+')), 'GET', UserInfo.getSessionId() );
    }
    
    @testVisible Id getProfileId(){
        try {
            String sUserid = ApexPages.currentPage().getParameters().get('UserId');
            String profileName = [SELECT profile__c FROM Site_User__c WHERE Id = :sUserid][0].Profile__c;
            return [SELECT Id FROM Profile WHERE Name = :profileName][0].Id;
        } catch (Exception e) {
            return '';
        }
    }
    
   @testVisible static String getLayoutNameForCurrentUserProfile( String profileId, String recordTypeId ) {
        String body = toolingAPISOQL('select Layout.Name from ProfileLayout where ProfileId = \'' + profileId + '\' AND RecordTypeId = \'' + recordTypeId + '\'');
        String name = body.substringBetween('"Name":"', '"');
        return name;
    }
    
    public Pagereference showAppropriatePageLayout(){
        isrecordType = false;
        if(selectedRecordTypeId == null){
            // Notification Plugin Use
            needJavaScript.put('Success', new NotificationMessage(false, 'NA', 'NA'));
            needJavaScript.put('Failure', new NotificationMessage(true, 'ERROR', 'Record Type could not be fetched'));
        }else{
            Id uId = Apexpages.currentPage().getParameters().get('UserId');
            try{
                user= database.query('SELECT id, first_Name__C, last_Name__c, name, Profile__C, Email__C FROM Site_User__c Where id = :uId limit 1');            
            }catch(Exception e){
                System.debug('Exception in class: ' + String.valueOf(this).split(':')[0] + ' === Message: ' + e.getMessage() + ' === At Line: ' + e.getLineNumber());
                user = new Site_User__c();
            }

            /*
            for (Section__C st : secLst) {
                LayoutDescriberHelper.LayoutSection lsection = new LayoutDescriberHelper.LayoutSection();
                lsection.Name = st.Name;
                lsection.columns = (Integer)st.column__c;
                lsection.accessibilityInstance = new Accessibility();
                lsection.allowCollapse = false;
                lsection.useHeader = false;
                String str = st.fields_developer_Name__c;
                List<String> fldLst = str.split('; ');
                for (String s : fldLst) {
                    LayoutDescriberHelper.LayoutField lFld = new LayoutDescriberHelper.LayoutField();
                    lsection.layoutFields = new List<LayoutDescriberHelper.LayoutField>();
                    lFld.ApiName = s;
                    lFld.editableField = true;
                    lFld.isPlaceHolder = false;
                    lFld.required = false;
                    lsection.layoutFields.add(lFld);
                    
                }
                layoutSections.add(lsection);
            }*/
           layoutSections = getLayoutSectionsFromDatabase(selectedRecordTypeId);
            //layoutSections = LayoutDescriberHelper.describeSectionWithFields(selectedRecordTypeId, selectedobj, user.Profile__c);



            
            Cache.Org.put('local.SitePartition.layoutsections' , layoutSections);
            initSectionFields(selectedRecordTypeId);
        }
        return null;
    }
    

    public List<LayoutDescriberHelper.LayoutSection> getLayoutSectionsFromDatabase(String recTypeId){

         List<LayoutDescriberHelper.LayoutSection> layoutSections1 = new List<LayoutDescriberHelper.LayoutSection>();
        
        try {
            Record_type__C rtType = [SELECT RecordTypeId__C, Name, isPermitted__c FROM Record_Type__c WHERE RecordTypeId__C = :recTypeId AND (Object__r.developer_Name__C = :selectedobj AND profile__r.Name = :user.Profile__c)LIMIT 1];
            if(rtType != null && rtType.isPermitted__C == true){
                PageLayout__C pgLayout = [SELECT Name FROM PageLayout__C WHERE (Object__r.developer_Name__C = :selectedobj AND Profile__r.Name = : user.Profile__c) AND Record_Type__r.Name = :rtType.Name LIMIT 1];
                String pgName = pgLayout.Name;
                List<Section__c> secLst = [SELECT Name, column__C, Fields_developer_Name__c FROM Section__c WHERE PageLayout__r.Name = :pgName AND ObjectName__C = : selectedobj];
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
                
                needJavaScript.put('Success', new NotificationMessage(false, 'NA', 'NA'));
                needJavaScript.put('Failure', new NotificationMessage(true, 'Permission Error ', 'You don\'t have a permission on Record Type. Please contact your Administrator'));
            }
        } catch (Exception e) {
            needJavaScript.put('Success', new NotificationMessage(false, 'NA', 'NA'));
            needJavaScript.put('Failure', new NotificationMessage(true, 'Exception', e.getMessage()));
           
        }
        return layoutSections1;
    }
    public void sendEmailMsg(String msg){
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { 'aniketsalesforce@gmail.com' };
        message.subject = 'Check Message';
        message.plainTextBody = msg;
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }
    
    @testVisible void initRecord(){
        
        String query = 'SELECT ';
        query += String.join(flds, ', ');
        query += ' FROM ';
        query += selectedObj;
        query += ' WHERE Id = ';
        query += ':recId';
        try{
            try{
                System.debug(query);
                recWrap.record = Database.query(query);
            }catch(Exception e){
                System.debug('Exception in class: ' + String.valueOf(this).split(':')[0] + ' === Message: ' + e.getMessage() + ' === At Line: ' + e.getLineNumber());
                recWrap.record = Schema.getGlobalDescribe().get(selectedobj).newSObject();
            }
            tempRecord = recWrap.record.clone();
            for(String fld: recWrap.dateFields.keySet()){
                recWrap.dateFields.put(fld, (recWrap.record.get(fld) != null)? String.valueOf((Date)recWrap.record.get(fld)) : String.valueOf(Date.today()));
            }
            for(String fld: recWrap.dateTimeFields.keySet()){
                recWrap.dateTimeFields.put(fld, (recWrap.record.get(fld) != null)? String.valueOf((DateTime)recWrap.record.get(fld)) : String.valueOf(DateTime.now()));
            }
            recWrap.dummyrecord = recWrap.record.clone();
        }catch(Exception e){
            System.debug('Exception in class: ' + String.valueOf(this).split(':')[0] + ' === Message: ' + e.getMessage() + ' === At Line: ' + e.getLineNumber());
            needJavaScript.put('Success', new NotificationMessage(false, 'NA', 'NA'));
            needJavaScript.put('Failure', new NotificationMessage(true, 'ERROR', e.getMessage()));
            recWrap.record = Schema.getGlobalDescribe().get(selectedObj).newSObject();
            recWrap.dummyrecord = Schema.getGlobalDescribe().get(selectedObj).newSObject();
            recId = 'NA';
        }        
    }
    
    
    @testVisible void setDate(){
        for(String dFld: recWrap.DateFields.keySet()){
            String dateValue = recWrap.DateFields.get(dFld);
            if(dateValue != null || dateValue != ''){
                List<String> dList = dateValue.split('-');
                recWrap.dummyrecord.put(dFld, Date.newInstance(Integer.valueOf(dList[0]), Integer.valueOf(dList[1]), Integer.valueOf(dList[2])));
            }else{
                
            }            
        }
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
    public List<selectoption> convertListToSelectOption(List<String> strValue){
        List<SelectOption> returnValue = new List<selectoption>();
        for (String s : strValue) {
            returnValue.add(new SelectOption(s,s));
            
        }
        return returnValue;
    }
    @testVisible void setDateTime(){
        for(String dtFld: recWrap.DateTimeFields.keySet()){
            String dateTimeValue = recWrap.DateTimeFields.get(dtFld);
            if((dateTimeValue != null || dateTimeValue != '') && dateTimeValue.containsIgnoreCase('T')){
                List<String> dtList = dateTimeValue.split('T');
                List<String> dtList_d = dtList[0].split('-');
                List<String> dtList_t = dtList[1].split(':');
                recWrap.dummyrecord.put(dtFld, DateTime.newInstance(Integer.valueOf(dtList_d[0]), Integer.valueOf(dtList_d[1]), Integer.valueOf(dtList_d[2]), Integer.valueOf(dtList_t[0]), Integer.valueOf(dtList_d[1]), 0));
            }else if(dateTimeValue != null || dateTimeValue != ' '){
                List<String> dtList = dateTimeValue.split(' ');
                List<String> dtList_d = dtList[0].split('-');
                List<String> dtList_t = dtList[1].split(':');
                recWrap.dummyrecord.put(dtFld, DateTime.newInstance(Integer.valueOf(dtList_d[0]), Integer.valueOf(dtList_d[1]), Integer.valueOf(dtList_d[2]), Integer.valueOf(dtList_t[0]), Integer.valueOf(dtList_d[1]), Integer.valueOf(dtList_d[2])));
            }else{
                
            }            
        }
    }
    
    Site_User__c user;
    Sobject tempRecord ;
    
    public PageReference save(){
        userInfo__C customUser;
        Id uId = Apexpages.currentPage().getParameters().get('UserId');
        try{
            user= database.query('SELECT id, first_Name__C, last_Name__c, name, Profile__C, Email__C FROM Site_User__c Where id = :uId limit 1');
            customUser= UserInfo__c.getInstance(user.Email__C);            
        }catch(Exception e){
            System.debug('Exception in class: ' + String.valueOf(this).split(':')[0] + ' === Message: ' + e.getMessage() + ' === At Line: ' + e.getLineNumber());
            user = new Site_User__c();
            customUser =new UserInfo__C();
        }
        if(recordIdList == null || recordIdList.size() == 0){
            if(recId == 'NA'){                                          
            setDate(); setDateTime(); // getSelectedValueFromMultiSelectPickList();
            convertSelectoptionToString();
            Database.SaveResult  sr = Database.insert(recWrap.dummyrecord, false);
            id objid =  (id)recWrap.dummyrecord.get('id');
            sobject sendObj = recWrap.dummyrecord;
            recWrap.dummyrecord.put('id', null);
            String error='';
            if (sr.isSuccess()){
                initFieldsAndRecordWrapper();
                try {
                    createHistory(sendObj, true, objId);
                } catch (Exception e) {
                    System.debug('Exception in class: ' + String.valueOf(this).split(':')[0] + ' === Message: ' + e.getMessage() + ' === At Line: ' + e.getLineNumber());
                }
                //customUser.isCreate__C = false;
                //update customUser;
                System.debug('In save method');
                needJavaScript.put('Success', new NotificationMessage(true, 'Record Created', 'The record was successfully created'));
                needJavaScript.put('Failure', new NotificationMessage(false, 'NA', 'NA'));
            }
            else {
                Database.Error[] errLst = sr.getErrors();
                if(errLst.size() == 1){
                    needJavaScript.put('Success', new NotificationMessage(false, 'NA', 'NA'));
                    needJavaScript.put('Failure', new NotificationMessage(true, String.valueOf(errLst[0].getStatusCode()), errLst[0].getMessage()));
                }else{
                    for(Database.Error err : errLst) {
                        error += ( err.getStatusCode() + ': ' + err.getMessage()) + '\n\n';
                        if(err.getFields().size() > 0)
                            error += ('Fields that affected this error: ' + err.getFields() + '\n\n');
                    }
                }
                
            }
            if(error != ''){
                needJavaScript.put('Success', new NotificationMessage(false, 'NA', 'NA'));
                needJavaScript.put('Failure', new NotificationMessage(true, 'ERROR', error));
            }
        }
        else{
            
            setDate(); setDateTime(); //getSelectedValueFromMultiSelectPickList();
            recWrap.dummyrecord.put('id', recWrap.record.id);
            convertSelectoptionToString();
            Database.SaveResult  sr = Database.update(recWrap.dummyrecord, false);
            id objid =  (id)recWrap.dummyrecord.get('id');
            Sobject sendObj = recWrap.dummyrecord;
            
            recWrap.dummyrecord.put('id', null);
            String error='';
            if (sr.isSuccess()){
                try {
                     
                   createHistory(sendObj, false, '');
                } catch (Exception e) {
                    System.debug('Exception in class: ' + String.valueOf(this).split(':')[0] + ' === Message: ' + e.getMessage() + ' === At Line: ' + e.getLineNumber());
                }
                customUser.isCreate__C = false;
                update customUser;
                needJavaScript.put('Success', new NotificationMessage(true, 'Record Updated', 'The record was successfully updated'));
                needJavaScript.put('Failure', new NotificationMessage(false, 'NA', 'NA'));
            }
            else {
                Database.Error[] errLst = sr.getErrors();
                if(errLst.size() == 1){
                    needJavaScript.put('Success', new NotificationMessage(false, 'NA', 'NA'));
                    needJavaScript.put('Failure', new NotificationMessage(true, String.valueOf(errLst[0].getStatusCode()), errLst[0].getMessage()));
                }else{
                    for(Database.Error err : errLst) {
                        error += ( err.getStatusCode() + ': ' + err.getMessage()) + '\n\n';
                        if(err.getFields().size() > 0)
                            error += ('Fields that affected this error: ' + err.getFields() + '\n\n');
                    }
                }
                
            }
            if(error != ''){
                needJavaScript.put('Success', new NotificationMessage(false, 'NA', 'NA'));
                needJavaScript.put('Failure', new NotificationMessage(true, 'ERROR', error));
            }
        }
        }else {
             System.debug(recWrap.dummyrecord);
            setDate(); setDateTime();
            
            list<sobject> tlst = new List<sobject>();
            if(selectedobj == 'task__c'){
                System.debug(recWrap.dummyrecord);
                for(String s: recordIdList){
                    id   myId = s;
                    Task__C t = new Task__C();
                    t.OwnerId__C = (id)recWrap.dummyrecord.get('OwnerId__c');
                    t.Status__C = (string)recWrap.dummyrecord.get('Status__c');
                    t.Subject__C = (string)recWrap.dummyrecord.get('Subject__c');
                    t.Priority__C = (string)recWrap.dummyrecord.get('Priority__c');
                    t.Name = (string)recWrap.dummyrecord.get('Name');
                    t.ActivityDate__c = (date)recWrap.dummyrecord.get('ActivityDate__c');
                    t.comments__C = (String)recWrap.dummyrecord.get('comments__C');
                    t.created_By__c = user.id;
                    t.put(getReferenceFieldApiName(myId.getSObjectType().getDescribe().getName(), 'task__c'), myId);
                    //t.WhatId__C = s;
                    tlst.add(t);  
                }
            }else {
                tlst = new List<Sobject>();
                for(String s: recordIdList){
                    event__C t = new event__C();
                    // t.OwnerId__C = (id)recWrap.dummyrecord.get('OwnerId__c');
                    // t.EndDateTime__c = (datetime)recWrap.dummyrecord.get('EndDateTime__c');
                    // t.Subject__C = (string)recWrap.dummyrecord.get('Subject__c');
                    // t.StartDateTime__c = (dateTime)recWrap.dummyrecord.get('StartDateTime__c');
                    // t.Name = (string)recWrap.dummyrecord.get('Name');
                    // // t.dueDate__c = (string)recWrap.dummyrecord.get('dueDate__c');
                    // //t.WhatId__C = s;
                    // tlst.add(t);  
                }
            }
           
            Database.SaveResult[]  srList = Database.insert(tlst, false);
            id objid =  (id)recWrap.dummyrecord.get('id');
            sobject sendObj = recWrap.dummyrecord;
            recWrap.dummyrecord.put('id', null);
            String error='';
            for( Database.SaveResult sr : srList){
                if (sr.isSuccess()){
                    
                    initFieldsAndRecordWrapper();
                    
                    
                    try {
                        createHistory(sendObj, true, objId);
                    } catch (Exception e) {
                        
                    }
                    needJavaScript.put('Success', new NotificationMessage(true, 'Record Created', 'The record was successfully created'));
                    needJavaScript.put('Failure', new NotificationMessage(false, 'NA', 'NA'));
                    customUser.isCreate__c= false;
                   try {
                        update customUSer;
                        System.debug('Custom setting '+ customUser.isCreate__c);
                   } catch (Exception e) {
                       Apexpages.addMessage(new apexpages.message(Apexpages.Severity.ERROR, e.getMessage() + '=====> ' + e.getLineNumber()));
                   }
                }
                else {
                    Database.Error[] errLst = sr.getErrors();
                    if(errLst.size() == 1){
                        needJavaScript.put('Success', new NotificationMessage(false, 'NA', 'NA'));
                        needJavaScript.put('Failure', new NotificationMessage(true, String.valueOf(errLst[0].getStatusCode()), errLst[0].getMessage()));
                    }else{
                        for(Database.Error err : errLst) {
                            error += ( err.getStatusCode() + ': ' + err.getMessage()) + '\n\n';
                            if(err.getFields().size() > 0)
                                error += ('Fields that affected this error: ' + err.getFields() + '\n\n');
                        }
                    }
                    
                }
            }
           try {
                sendEmail(tlst, user, (String)recWrap.dummyrecord.get('comments__C'));
           } catch (Exception e) {
               System.debug(e.getMessage() + '======>>>> ' + e.getLineNumber());
           }
            if(error != ''){
                needJavaScript.put('Success', new NotificationMessage(false, 'NA', 'NA'));
                needJavaScript.put('Failure', new NotificationMessage(true, 'ERROR', error));
            }
        }
        return null;
        
    }
    

    public void sendEmail(list<sobject> taskobjectLst, sobject siteuser, String comments){
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        Site_User__c taskAssignedUser ;
        
        try{
            taskAssignedUser = Database.query('Select Name, Email__c FROM Site_User__c Where id =  \'' + (id)taskobjectLst[0].get('OwnerId__c') + '\'');
        }catch(Exception e){
            taskAssignedUser = new Site_User__c();
            Apexpages.addMessage(new Apexpages.Message(apexpages.Severity.ERROR, e.getMessage()));
        }
        
        message.toAddresses = new String[] { (String)taskAssignedUser.get('Email__C')};
            message.optOutPolicy = 'FILTER';
        if(selectedobj == 'task__c')
            message.subject = 'New Task Assignment';  
        else {
            message.subject = 'New Event Assignment';  
        }
        //message.setTemplateId('00X1h000000Hza3');
        // message.plainTextBody = comments;
        String msg = '<html><body ><b>Hello ' + taskAssignedUser.get('Name') + ',</b><br/><br/>' ;
        for(sobject taskobject : taskobjectLst){
            msg += 'Task Name &nbsp;&nbsp;' + taskobject.get('Name');
            msg +=  '<br/>Priority &nbsp;&nbsp;' + taskobject.get('priority__C') +
                '<br/>Status &nbsp;&nbsp;' + taskobject.get('status__C') + 
                '<br/>Assigned By &nbsp;&nbsp;' + siteuser.get('name') ; 
            
            if(taskobject.get('ActivityDate__c')!= null){
                msg += '<br/>DueDate &nbsp;&nbsp;' + taskobject.get('ActivityDate__c') ;
            }
            if(taskobject.get('comments__C')!= null){
                msg += '<br/>Comments &nbsp;&nbsp;'+ taskobject.get('comments__C') ;
            }
            msg += '<br/><br/>';
        }
        msg +=  '</html></body>';
        message.setHtmlBody(msg);            
        // message.setTargetObjectId(userId);
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = new list<Messaging.SendEmailResult>();
        try {
            results = Messaging.sendEmail(messages);
        } catch (Exception e) {
            apexpages.addMessage(new apexpages.Message(apexpages.Severity.ERROR, e.getMessage()));
        }
        
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
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
    public void convertSelectoptionToString(){

        for(String fld : recWrap.rValue.keySet()){

            List<String> stringValues = new List<String>();
            for(SelectOption so: recWrap.rValue.get(fld).values){
                stringValues.add(so.getValue());
            }
            recWrap.dummyrecord.put(fld, String.join(stringValues, ';'));
        }
       
    }
    
     @testVisible void  getSelectedValueFromMultiSelectPickList(){

        for(String dFld: recWrap.rValue.keySet()){
            MultiSelectPicklist MPicklistInstance = recWrap.rvalue.get(dFld);
            MultiSelectPicklist MPicklistInstance1 = recWrap.lvalue.get(dFld);
            if(MPicklistInstance != null ){
              String seleValue = (String)recWrap.dummyrecord.get('MultiTest__c');
               List<String> valueList = new List<String>() ;
              if(seleValue != null)
                 valueList = seleValue.split(';');
                MPicklistInstance.values =convertListToSelectOption(valueList);
                recWrap.rValue.put(dFld, MPicklistInstance);
                MPicklistInstance1.values = getAvailableObjectOptions( MPicklistInstance1.values, convertListToSelectOption(valueList));
                 recWrap.LValue.put(dFld, MPicklistInstance1);

            }else{
                
            }            
        }
    }
    public String getJavaScriptFunctionCall(){
        String toReturn = '';
        if(needJavaScript.get('Success').show){
            toreturn =  SuccessScript(needJavaScript.get('Success'));
        }else if(needJavaScript.get('Failure').show){
            toreturn =  FailureScript(needJavaScript.get('Failure'));
        }
        initNotificationMap();
        return toReturn;
    }
    
    @testVisible String SuccessScript(NotificationMessage nm){
        if(recId == 'NA'){
            return '<script> notify(\'Success\', \'' + nm.statusCode + '\', \'' + nm.message + '\', \'center\', 3000); cancelModal(); </script>';
        }else{
            return '<script> notify(\'Success\', \'' + nm.statusCode + '\', \'' + nm.message + '\', \'center\', 3000); cancelModal(); </script>';
        }   
    }
    
    @testVisible String FailureScript(NotificationMessage nm){
        if(recId == 'NA'){
            return '<script> notify(\'Error\', \'' + nm.statusCode + '\', \'' + nm.message + '\', \'center\', 3000); </script>';
        }else{
            return '<script> notify(\'Error\', \'' + nm.statusCode + '\', \'' + nm.message + '\', \'center\', 3000); </script>';
        }   
        
    }
    
    public void initNotificationMap(){
        needJavaScript = new Map<String, NotificationMessage>();
        needJavaScript.put('Success', new NotificationMessage(false, 'NA', 'NA'));
        needJavaScript.put('Failure', new NotificationMessage(false, 'NA', 'NA'));
    }
    
    public class NotificationMessage{
        public Boolean show;
        public String statusCode;
        public String message;
        
        public NotificationMessage(Boolean show, String statusCode, String message){
            this.show = show;
            this.statusCode = String.escapeSingleQuotes(statusCode);
            this.message = String.escapeSingleQuotes(message);
        }
    }
    
    public class LookupHandler{
        public String refObjName {get;set;}
        public String uniqueField {get;set;}
        public List<String> refObjRecords {get;set;}
        public LookupHandler(String refObjName){
            this.refObjName = refObjName;
            uniqueField = getNameUniqueField(this.refObjName)[0];
            try{
                refObjRecords = new List<String>();
                for(sObject s : Database.query('SELECT ' + uniqueField + ' FROM ' + this.refObjName + ' LIMIT 50')){
                    refObjRecords.add('\"' + String.valueOf(s.get(uniqueField)) + '\"');
                }
            }catch(Exception e){
                refObjRecords = new List<String>();
            }
        }
        
        public List<String> getNameUniqueField(String objType){
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType leadSchema = schemaMap.get(objType);
            List<String> strResult = new List<String>();
            Schema.DescribeSObjectResult ObjResult =  LeadSchema.getDescribe();
            Map<String, Schema.SObjectField> mapFields = ObjResult.Fields.getMap();
            schema.describeFieldResult dfield;
            for(String s : mapFields.keySet()){
                dfield = mapFields.get(s).getDescribe();
                
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
    }
    
    
    public Pagereference cancel(){
        
        userInfo__C customUser;
        Site_User__c user;
        id uId = apexpages.currentPage().getParameters().get('userId');
        try{
            user= database.query('SELECT id, first_Name__C, last_Name__c, name, Profile__C FROM Site_User__c Where id = :uId limit 1');
            customUser = UserInfo__c.getInstance(user.Name);
            customUser.isCreate__c= false;
            update customUser;
            recWrap.dummyrecord = Schema.getGlobalDescribe().get(selectedObj).newSObject();
            recWrap.record = Schema.getGlobalDescribe().get(selectedObj).newSObject();
        }catch(Exception e){
            user = new Site_User__c();
            customUser =new UserInfo__C();
        }
        selectedRecordTypeId = null;
        return null;
    }
    
    public String sampleText {get;set;}
    
    public void updateText(){
        sampleText = 'Hello';
    }
    
    
    /////////////// #### Create History #### ///////////////
    
    
    public void createHistory(sobject sobj, boolean iscreated, String objId){
        SiteHistory__C histryobj;
        histryobj = new SiteHistory__C();
        if(user != null){
            
            histryobj.user_Name__C = user.First_Name__C + ' ' + user.Last_Name__C;
            histryobj.Email__c = user.Email__C;
            
            String msg ='';
            
            if(!iscreated){
                histryobj.put(getReferenceFieldApiName(), recId);
                Map<String ,object> fldMap = sobj.getPopulatedFieldsAsMap();
                for(String fld : fldMap.keySet()){
                   Map<String, Schema.SObjectField> fieldMap =  Schema.getGlobalDescribe().get(selectedobj.toLowerCase()).getDescribe().fields.getMap();
                    if(fieldMap.get(fld).getDescribe().isUpdateable()){
                        if(tempRecord.get(fld)!=null && sobj.get(fld) !=null){
                            if(!tempRecord.get(fld).equals(sobj.get(fld))){
                                
                                if(tempRecord.get(fld) != null){
                                    msg += 'Changed ' + fieldMap.get(fld).getDescribe().getLabel() + ' from ' +  tempRecord.get(fld) + ' to ' + sobj.get(fld) + '\n';  
                                }
                            }else if(sobj.get(fld) == null){
                                
                                msg += 'Deleted ' + sobj.get(fld) + ' in ' + fieldMap.get(fld).getDescribe().getLabel() + '\n';
                            }
                        }else if(sobj.get(fld) !=null){
                            msg += 'Changed ' + fieldMap.get(fld).getDescribe().getLabel() + ' to ' + sobj.get(fld) + '\n';
                        }else if(tempRecord.get(fld) !=null){ 
                            msg += ' Deleted '+ tempRecord.get(fld) + ' in ' + fieldMap.get(fld).getDescribe().getLabel() + '\n';
                            
                        }
                        
                    }
                }
                
                
                histryobj.action__C= msg;
            }else{
                histryobj.put(getReferenceFieldApiName(), objId);
                histryobj.action__C = 'Created';
            }
            
        }else{
            
        }
        
        Database.SaveResult  sr;
        if(histryobj != null){
            sr = Database.insert(histryobj);
        }
        String error='';
        
        if (sr.isSuccess()){
            tempRecord = recWrap.dummyrecord.clone();
            
            //recWrap.Record.put('id', recId);
        }
        else {
            for(Database.Error err : sr.getErrors()) {
                error += ('<b>' + err.getStatusCode() + '</b>: ' + err.getMessage()) + '<br/><br/>';
                if(err.getFields().size() > 0)
                    error += ('Fields that affected this error: ' + err.getFields() + '<br/><br/>');
            }
            
        }
        
        if(error != ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
        }else{
            
        }
    }
    
    public String getReferenceFieldApiName(){
        String fldApiName = '';
        map<string, schema.SObjectType> mp = schema.getGlobalDescribe();
        schema.DescribeSObjectResult sdescribe = mp.get(selectedobj.toLowerCase()).getDescribe();
        List<Schema.ChildRelationship> childdesc = sdescribe.getChildRelationships();
        for(Schema.ChildRelationship reference : childdesc) {
            if(reference.getChildSobject().getDescribe().getName().toLowerCase() == 'sitehistory__c')
                fldApiName = reference.getField().getDescribe().getName();
        }
        return fldApiName;
    }
    
    // Sections and Fields
    
  public   userInfo__C customUser {get; set;}
    public void initSectionFields(Id recTypeId){
        try{
            flds = new List<String>();
            /*List<Section__C> SecLst = [SELECT name, column__c, fields_developer_Name__C FROM Section__c Where ObjectName__C = :selectedobj];
            for (Section__C st : secLst) {
                LayoutDescriberHelper.LayoutSection lsection = new LayoutDescriberHelper.LayoutSection();
                lsection.Name = st.Name;
                lsection.columns = (Integer)st.column__c;
                lsection.accessibilityInstance = new Accessibility();
                lsection.allowCollapse = false;
                lsection.useHeader = false;
                String str = st.fields_developer_Name__c;
                List<String> fldLst = str.split('; ');
                for (String s : fldLst) {
                    LayoutDescriberHelper.LayoutField lFld = new LayoutDescriberHelper.LayoutField();
                    lsection.layoutFields = new List<LayoutDescriberHelper.LayoutField>();
                    lFld.ApiName = s;
                    lFld.editableField = true;
                    lFld.isPlaceHolder = false;
                    lFld.required = false;
                    lsection.layoutFields.add(lFld);
                    
                }
                layoutSections.add(lsection);
            }*/
            //layoutSections = (List<LayoutDescriberHelper.LayoutSection>) Cache.Org.get('local.SitePartition.layoutsections');
            layoutSections = getLayoutSectionsFromDatabase(recTypeId);
            Map<String, String> dMap = new Map<String, String>();
            Map<String, String> dtMap = new Map<String, String>();
            Map<String, LookupHandler> refMap = new Map<String, LookupHandler>();
            Map<String, MultiSelectPicklist> rValueMap = new Map<String, MultiSelectPicklist>();
            Map<String, MultiSelectPicklist> lvalueMap = new Map<String, MultiSelectPicklist>();
            for (LayoutDescriberHelper.LayoutSection ldh : layoutSections) {
                ldh.layoutFields = getFilteredFieldsAndInitRecordWrapper(ldh.layoutFields, dMap, dtMap, refMap, rValueMap, lvalueMap);
            }
            sobject sobj = Schema.getGlobalDescribe().get(selectedObj).newSObject();
            initparentField();
            if(customUser.isRelated__C){
                try{
                    sobj.put(getReferenceFieldonchildObj(customUser.parentObjName__C.toLowerCase(), selectedobj.toLowerCase()), customUser.parentRecId__c);
                }catch(Exception e){
                    System.debug('Exception in class: ' + String.valueOf(this).split(':')[0] + ' === Message: ' + e.getMessage() + ' === At Line: ' + e.getLineNumber());
                }
            }
            recWrap = new RecordWrapper(sobj, dMap, dtMap, refMap, rValueMap, lvalueMap);
        }catch(Exception e){
            layoutSections = new List<LayoutDescriberHelper.LayoutSection>();
            System.debug('Exception in class: ' + String.valueOf(this).split(':')[0] + ' === Message: ' + e.getMessage() + ' === At Line: ' + e.getLineNumber());
        }
    }
    
    public void initparentField(){
        
        
        Id uId = Apexpages.currentPage().getParameters().get('UserId');
        try{
            user= database.query('SELECT id, first_Name__C, last_Name__c, name, Profile__C, Email__C FROM Site_User__c Where id = :uId limit 1');
            
            customUser= UserInfo__c.getInstance(user.Email__C);
            
            
        }catch(Exception e){
            System.debug('Exception in class: ' + String.valueOf(this).split(':')[0] + ' === Message: ' + e.getMessage() + ' === At Line: ' + e.getLineNumber());
            user = new Site_User__c();
            customUser =new UserInfo__C();
        }
    }
    
    public String getReferenceFieldonchildObj(String parentObjName,  String childobjName ){
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
    
    public List<LayoutDescriberHelper.LayoutField> getFilteredFieldsAndInitRecordWrapper(List<LayoutDescriberHelper.LayoutField> fldLst, Map<String, String> dMap, Map<String, String> dtMap, Map<String, LookupHandler> refMap, Map<String, MultiSelectPicklist> rValueMap, Map<String, MultiSelectPicklist> lvalueMap){
        List<LayoutDescriberHelper.LayoutField> Lflds = new List<LayoutDescriberHelper.LayoutField>();
        Map<String, Schema.SObjectField> fldMap;
        try{
            fldMap= Schema.getGlobalDescribe().get(selectedObj.toLowerCase()).getDescribe().fields.getMap();
            Integer fldcount = 0;
            for(LayoutDescriberHelper.LayoutField Lfld: fldLst){
                String fld = Lfld.ApiName;
                if(fld != null && fld != ''){
                    flds.add(fld);
                    Schema.SObjectField sof = fldMap.get(fld);
                    Schema.DescribeFieldResult fieldResult = sof.getDescribe();
                    if(fieldResult.isAccessible() && fieldResult.isCreateable()  && fld != 'ownerid' && !fld.containsIgnoreCase('geocode')){
                        if(fieldResult.getType() == Schema.DisplayType.DATE){
                            dMap.put(fld, String.valueOf(Date.today()));
                        }else if(fieldResult.getType() == Schema.DisplayType.DATETIME){
                            dtMap.put(fld, String.valueOf(DateTime.now()));
                        }else if(fieldResult.getType() == Schema.DisplayType.REFERENCE){
                            refMap.put(fld, new LookupHandler(fieldResult.getReferenceTo()[0].getDescribe().getName()));
                        } else if (fieldResult.getType() == Schema.DisplayType.MULTIPICKLIST) {
                            
                         MultiSelectPicklist m = new MultiSelectPicklist(getMultiselectValue(selectedobj, fld), fld);
                         lvalueMap.put(fld, m);
                         
                         rValueMap.put(fld, new MultiSelectPicklist(new List<Selectoption>(), fld));
                        }
                        Lfld.fieldCount = ++fldcount;
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
   
    public List<String> getFieldsFromFieldSet(String fldSetName){
        List<String> fls = new List<String>();
        List<Schema.FieldSetMember> fieldSetMemberList =  readFieldSet(fldSetName, selectedobj);
        for(Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList)
        {
            fls.add(fieldSetMemberObj.getFieldPath());
        }
        return fls;
    }
    
    public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String ObjectName)
    {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
        return fieldSetObj.getFields(); 
    }  

public Static List<Selectoption> getMultiselectValue(string objName, String fld){
        list<selectoption> AvailableValues = new List<Selectoption>();
        Map<String, Schema.SObjectType> sp = Schema.getGlobalDescribe();
        Schema.DescribeSObjectResult  objSchema  = sp.get(objName).getDescribe();
        Map<String, Schema.SObjectField> fieldMap = objSchema.fields.getmap();
        List<Schema.Picklistentry> fldLst =fieldmap.get(fld).getDescribe().getpicklistValues();
        List<String> pickList = new List<String>();

        for(Schema.Picklistentry pl : fldLst)
        {
            AvailableValues.add(new SelectOption(pl.getValue(), pl.getValue()));
        }
        return AvailableValues;
}  
    public class RecordWrapper{
        public sObject record {get;set;}
        public sObject dummyrecord {get;set;}
        public Map<String, String> dateFields {get;set;}
        public Map<String, String> dateTimeFields {get;set;}
        public Map<String, lookupHandler> lookUpMap {get;set;}
       
        public Map< String, MultiSelectPicklist> rValue {get; set;}
        public Map<String, MultiSelectPicklist> lValue {get; set;}
        public RecordWrapper(sObject record, Map<String, String> dateFields, Map<String, String> dateTimeFields, Map<String, lookupHandler> lookUpMap, Map<String, MultiSelectPicklist> rValue, Map<String, MultiSelectPicklist> lValue ){
            this.lValue = lValue;
            this.rValue  = rValue;
            this.record = record;
            dummyrecord = record.clone();
            this.dateFields = dateFields.Clone();
            this.dateTimeFields = dateTimeFields.Clone();
            this.lookUpMap = lookUpMap.Clone();
        }
        
    }
    public class MultiSelectPicklist{
        public list<selectoption> values {get; set;}
        public String fldName {get;  set;}
        public MultiSelectPicklist(List<Selectoption> values, String fldName){
            this.values = values;

            this.fldName = fldName;
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
    
}