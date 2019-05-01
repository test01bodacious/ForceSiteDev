public class CreateTaskAndEventComponentController {
    
    public List<String> flds{get;set;}
    public RecordWrapper recWrap {get;set;}    
    @testVisible String selectedobj;
    @testVisible String recId;
    @testVisible List<String> recordsIdList;
    public Map<String, NotificationMessage> needJavaScript {get;set;}
    @testVisible String JavaScriptFunctionCall;
    @testVisible Accessibility accessbilityObj;
    public String selectedRecordTypeId {get;set;}
    public List<RTInfo> recTypeInfoLst {get;set;}
    public Boolean isNoRecordType {get;set;}
    
    public void setaccessbilityObj( object acc){
        if(accessbilityobj==null)
            accessbilityobj = (Accessibility)acc;
    }
    
    public Accessibility getaccessbilityobj(){
        return (Accessibility)accessbilityobj;
    }
    
    public void setrecordsIdList(List<String> ids){
        if(recordsIdList == null || recordsIdList != ids){
            recordsIdList = ids;
        }
    }
    
    public List<String>  getrecordsIdList(){
        return recordsIdList;
    }
    
    public String getselectedobj(){
        return selectedobj;
    }
    
    public void setselectedobj(String objName){
        
        if(selectedobj == null || selectedobj != objName ){
            selectedobj = objName;
            System.debug(recWrap);
            initFieldsAndRecordWrapper();
            recId = 'NA';
            initRecord();
            initRecTypeInfoLst();
        }
    }
    
    public String getrecId(){
        return recId;
    }
    
    public void setrecId(String rId){
        if(recId == null ||  recId != rId){
            recId = rId;
            initFieldsAndRecordWrapper();
            initRecord();
        }
    }
    
    
    public CreateTaskAndEventComponentController(){
        selectedRecordTypeId = null;
        initNotificationMap();
    }
    
    public void initFieldsAndRecordWrapper(){
        flds = new List<String>(); 
        Map<String, String> dMap = new Map<String, String>();
        Map<String, String> dtMap = new Map<String, String>();
        Map<String, LookupHandler> refMap = new Map<String, LookupHandler>();
        Map<String, Schema.SObjectField> fldMap;
        try{
            fldMap= Schema.getGlobalDescribe().get(selectedObj.toLowerCase()).getDescribe().fields.getMap();
            
            for(String fld: fldMap.keySet()){
                Schema.DescribeFieldResult fieldResult = fldMap.get(fld).getDescribe();
                if(fieldResult.isAccessible() && fieldResult.isCreateable()  && fld != 'ownerid'){
                    if(fieldResult.getType() == Schema.DisplayType.DATE){
                        dMap.put(fld, String.valueOf(Date.today()));
                    }else if(fieldResult.getType() == Schema.DisplayType.DATETIME){
                        dtMap.put(fld, String.valueOf(DateTime.now()));
                    }else if(fieldResult.getType() == Schema.DisplayType.REFERENCE){
                        refMap.put(fld, new LookupHandler(fieldResult.getReferenceTo()[0].getDescribe().getName()));
                    }
                    flds.add(fld);
                }
            }
            recWrap = new RecordWrapper(Schema.getGlobalDescribe().get(selectedObj).newSObject(), dMap, dtMap, refMap);
        }catch(Exception e){
            apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
        }
    }
    
    public void initRecTypeInfoLst(){
        List<Schema.RecordTypeInfo> rtiLst = Schema.getGlobalDescribe().get(selectedobj).getDescribe().getRecordTypeInfos();
        recTypeInfoLst = new List<RTInfo>();
        selectedRecordTypeId = null;
        for (RecordTypeInfo rti : rtiLst) {
            RTInfo rtInf = new RTInfo();
            rtInf.name = rti.getName();
            rtInf.devName = rti.getDeveloperName();
            rtInf.id = rti.getRecordTypeId();
            rtInf.isActive = rti.isActive();
            rtInf.isDefault = rti.isDefaultRecordTypeMapping();
            rtInf.isMaster = rti.isMaster();
            if (!rtInf.isMaster && rtInf.isActive) {
                recTypeInfoLst.add(rtInf);
            }
            if(recTypeInfoLst.size() == 0){
                isNoRecordType = true;
            }else{
                isNoRecordType = false;
            }
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
    
    static String toolingAPISOQL( String query) {
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
    
    static String getLayoutNameForCurrentUserProfile( String profileId, String recordTypeId ) {
        String body = toolingAPISOQL('select Layout.Name from ProfileLayout where ProfileId = \'' + profileId + '\' AND RecordTypeId = \'' + recordTypeId + '\'');
        String name = body.substringBetween('"Name":"', '"');
        return name;
    }
    
    public Pagereference showAppropriatePageLayout(){
        String pgLayoutName = getLayoutNameForCurrentUserProfile(getProfileId(), selectedRecordTypeId);
        return null;
    }
    
    @testVisible void initRecord(){
        if(recId == 'NA'){
            
        }else{
            String query = 'SELECT ';
            query += String.join(flds, ', ');
            query += ' FROM ';
            query += selectedObj;
            query += ' WHERE Id = \'';
            query += recId;
            query += '\'';
            try{
                System.debug('query'+query);
                recWrap.record = Database.query(query);
                tempRecord = recWrap.record.clone();
                for(String fld: recWrap.dateFields.keySet()){
                    recWrap.dateFields.put(fld, (recWrap.record.get(fld) != null)? String.valueOf((Date)recWrap.record.get(fld)) : String.valueOf(Date.today()));
                }
                for(String fld: recWrap.dateTimeFields.keySet()){
                    recWrap.dateTimeFields.put(fld, (recWrap.record.get(fld) != null)? String.valueOf((DateTime)recWrap.record.get(fld)) : String.valueOf(DateTime.now()));
                }
                recWrap.dummyrecord = recWrap.record.clone();
            }catch(Exception e){
                needJavaScript.put('Success', new NotificationMessage(false, 'NA', 'NA'));
                needJavaScript.put('Failure', new NotificationMessage(true, 'ERROR', e.getMessage()));
                recWrap.record = Schema.getGlobalDescribe().get(selectedObj).newSObject();
                recWrap.dummyrecord = Schema.getGlobalDescribe().get(selectedObj).newSObject();
                recId = 'NA';
            }
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

    public String testVar {get;set;}
    
    Site_User__c user;
    Sobject tempRecord ;
    
    public PageReference save(){
        testVar = 'Hello';
        
        userInfo__C customUser;
        
        id uId = apexpages.currentPage().getParameters().get('userId');
        try{
            user= database.query('SELECT id, first_Name__C, last_Name__c, name, Profile__C, Email__c FROM Site_User__c Where id = :uId limit 1');
            
            customUser= UserInfo__c.getInstance(user.Email__c);
            
            
        }catch(Exception e){
            user = new Site_User__c();
            customUser =new UserInfo__C();
        }
        if(recId == 'NA'){
            setDate(); setDateTime();
            
            list<sobject> tlst = new List<sobject>();
            if(selectedobj == 'task__c'){
                System.debug(recWrap.dummyrecord);
                for(String s: recordsIdList){
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
                for(String s: recordsIdList){
                    id   myId = s;
                    Event__C t = new Event__C();
                    t.OwnerId__C = (id)recWrap.dummyrecord.get('OwnerId__c');
                    t.EndDateTime__c = (datetime)recWrap.dummyrecord.get('EndDateTime__c');
                    t.Subject__C = (string)recWrap.dummyrecord.get('Subject__c');
                    t.StartDateTime__c = (dateTime)recWrap.dummyrecord.get('StartDateTime__c');
                    t.Name = (string)recWrap.dummyrecord.get('Name');
                    // t.dueDate__c = (string)recWrap.dummyrecord.get('dueDate__c');
                    // t.WhatId__C = s;
                    t.put(getReferenceFieldApiName(myId.getSObjectType().getDescribe().getName(), 'task__c'), myId);
                     t.created_By__c = user.id;
                    tlst.add(t);  
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
                       // createHistory(sendObj, true, objId);
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
               if (selectedobj == 'task__c') {
                    sendEmail(tlst, user, (String)recWrap.dummyrecord.get('comments__C'));
               }
               else {
                    sendEmail(tlst, user, '');
               }
           } catch (Exception e) {
               System.debug(e.getMessage() + '======>>>> ' + e.getLineNumber());
           }
            if(error != ''){
                needJavaScript.put('Success', new NotificationMessage(false, 'NA', 'NA'));
                needJavaScript.put('Failure', new NotificationMessage(true, 'ERROR', error));
            }
        }
        else{
            setDate(); setDateTime();
            recWrap.dummyrecord.put('id', recWrap.record.id);
            Database.SaveResult  sr = Database.update(recWrap.dummyrecord, false);
            id objid =  (id)recWrap.dummyrecord.get('id');
            Sobject sendObj = recWrap.dummyrecord;
            
            recWrap.dummyrecord.put('id', null);
            String error='';
            if (sr.isSuccess()){
                try {
                    createHistory(sendObj, false, '');
                } catch (Exception e) {
                    
                }
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
         String msg = '<html><body ><b>Hello ' + taskAssignedUser.get('Name') + ',</b><br/><br/>' ;

        if(selectedobj == 'task__c'){
            message.subject = 'New Task Assignment';  
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
        
        }
        else {
            message.subject = 'New Event Assignment';  
                for(sobject taskobject : taskobjectLst){
                msg += 'Event Name &nbsp;&nbsp;' + taskobject.get('Name');
                msg +=  '<br/>Start Date &nbsp;&nbsp;' + taskobject.get('startdateTime__c') +
                    '<br/>End Date &nbsp;&nbsp;' + taskobject.get('EndDateTime__C') + 
                    '<br/>Assigned By &nbsp;&nbsp;' + siteuser.get('name') ; 
                
                // if(taskobject.get('ActivityDate__c')!= null){
                //     msg += '<br/>DueDate &nbsp;&nbsp;' + taskobject.get('ActivityDate__c') ;
                // }
                // if(taskobject.get('comments__C')!= null){
                //     msg += '<br/>Comments &nbsp;&nbsp;'+ taskobject.get('comments__C') ;
                // }
                msg += '<br/><br/>';
            }
        msg +=  '</html></body>';
        }
        //message.setTemplateId('00X1h000000Hza3');
        // message.plainTextBody = comments;
       
        
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
    }
    
    
    public Pagereference cancel(){
        userInfo__C customUser;
        Site_User__c user;
        id uId = apexpages.currentPage().getParameters().get('userId');
        try{
            user= database.query('SELECT id, first_Name__C, last_Name__c, name, Profile__C, Email__C FROM Site_User__c Where id = :uId limit 1');
            
            customUser= UserInfo__c.getInstance(user.Email__C);
            customUser.isCreate__c= false;
            update customUser;
        }catch(Exception e){
            user = new Site_User__c();
            customUser =new UserInfo__C();
        }
        return null;
    }
    
    
    
    /////////////// ####Create History #### ///////////////
    
    public void createHistory(sobject sobj, boolean iscreated, String objId){
        
        
        SiteHistory__C histryobj;
        histryobj = new SiteHistory__C();
        if(user != null){
            
            histryobj.user_Name__C = user.First_Name__C + ' ' + user.Last_Name__C;
            histryobj.Email__c = user.Email__c;
            
            String msg ='Changed ';
            
            if(!iscreated){
                histryobj.put(getReferenceFieldApiName(selectedobj, 'siteHistory__C'), recId);
                Map<String ,object> fldMap = sobj.getPopulatedFieldsAsMap();
                for(String fld : fldMap.keySet()){
                    
                    if(Schema.getGlobalDescribe().get('account').getDescribe().fields.getMap().get(fld).getDescribe().isUpdateable()){
                        if(tempRecord.get(fld)!=null && sobj.get(fld) !=null){
                            if(!tempRecord.get(fld).equals(sobj.get(fld))){
                                
                                if(tempRecord.get(fld) != null){
                                    msg += 'Changed ' + fld + ' from ' +  tempRecord.get(fld) + ' to ' + sobj.get(fld) + '\n';  
                                }
                            }else if(sobj.get(fld) == null){
                                
                                msg += 'Deleted ' + sobj.get(fld) + ' in ' + fld + '\n';
                            }
                        }else if(sobj.get(fld) !=null){
                            msg += 'Changed ' + fld + ' to ' + sobj.get(fld) + '\n';
                        }else if(tempRecord.get(fld) !=null){ 
                            msg += ' Deleted '+ tempRecord.get(fld) + ' in ' + fld + '\n';
                            
                        }
                        
                    }
                }
                
                
                histryobj.action__C= msg;
            }else{
                histryobj.put(getReferenceFieldApiName(selectedobj, 'siteHistory__c'), objId);
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
    
    
    public class RecordWrapper{
        public sObject record {get;set;}
        public sObject dummyrecord {get;set;}
        public Map<String, String> dateFields {get;set;}
        public Map<String, String> dateTimeFields {get;set;}
        public Map<String, lookupHandler> lookUpMap {get;set;}
        public RecordWrapper(sObject record, Map<String, String> dateFields, Map<String, String> dateTimeFields, Map<String, lookupHandler> lookUpMap){
            this.record = record;
            dummyrecord = record.clone();
            this.dateFields = dateFields.Clone();
            this.dateTimeFields = dateTimeFields.Clone();
            this.lookUpMap = lookUpMap.Clone();
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