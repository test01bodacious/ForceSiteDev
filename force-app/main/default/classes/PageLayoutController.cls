public class PageLayoutController {
    
    List<PageLayout__c> pgLst;
    Map<String, LIST<PageLayout__c>> pgMap;
    public Map<String, ProfRTType> proRtMap {get;set;}
    
    public PageLayoutController(){
        try {
            pgLst = [SELECT Name, Object__r.Developer_Name__C, Record_Type__r.Name, Profile__r.Name FROM PageLayout__c ORDER BY Object__c];
            pgMap = new Map<String, LIST<PageLayout__c>>();
            List<PageLayout__c> pgl = new List<PageLayout__c>();
            for(PageLayout__c pg: pgLst){
                if(pgMap.containsKey(pg.Object__r.Developer_Name__C)){
                    pgl.add(pg);
                    pgMap.put(pg.Object__r.Developer_Name__C, pgl);
                }else{
                    pgl = new List<PageLayout__c>();
                    pgl.add(pg);
                    pgMap.put(pg.Object__r.Developer_Name__C, pgl);
                }
            }
            initproRtMap();
        } catch (Exception e) {
            ApexPages.addMessage( new ApexPages.message(ApexpAges.Severity.ERROR, e.getMessage() + ' ' + e.getCause() + '    '  + e.getLineNumber()));
        }
    }
    
    public void initproRtMap(){
        proRtMap = new Map<String, ProfRTType>();
        for(String objName: pgMap.keySet()){
            ProfRTType prt = new ProfRTType();
            List<String> allRtNames = new List<String>();
            prt.rtWrapLst = getrtWrapLst(pgMap.get(objName), allRtNames);
            prt.profWrapLst = getprofWrapLst(pgMap.get(objName), allRtNames, getPageLayoutNamesForObject(objName));
            proRtMap.put(objName, prt);
        }
    }

    public List<SelectOption> getPageLayoutNamesForObject(String objectName){

        return convertListStringTOListSelectoption(getPageLayoutName(objectName));
       // return new List<SelectOption>{new SelectOption('Master', 'Master'), new SelectOption('Master', 'Master'), new SelectOption('Master', 'Master')};
    }
    
    public List<ProfileWrapper> getprofWrapLst(List<PageLayout__c> plLst, List<String> allRtNames, List<SelectOption> pgNameLst){
        List<ProfileWrapper> pwList = new List<ProfileWrapper>();
        List<String> pfNames = new List<String>();
        for(PageLayout__c pl: plLst){
            if(!pfNames.contains(pl.Profile__r.Name)){
                pfNames.add(pl.Profile__r.Name);
                ProfileWrapper pw = new ProfileWrapper();
                pw.profileName = pl.Profile__r.Name;
                pw.prtLayout = getprtLayout(plLst, pw.profileName, pgNameLst, allRtNames);
                pwList.add(pw);
            }
        }
        return pwList;
    }

    public Map<String, PageLayoutWrapper> getprtLayout(List<PageLayout__c> plLst, String profileName, List<SelectOption> pgNameLst, List<String> allRtNames){
        Map<String, PageLayoutWrapper> prtLayoutMap = new Map<String, PageLayoutWrapper>();
        for (PageLayout__c pl : plLst) {
            if(pl.Profile__r.Name == profileName){
                PageLayoutWrapper plWrap = new PageLayoutWrapper();
                plWrap.selectedPlName = pl.Name;
                SelectOption so = new SelectOption(plWrap.selectedPlName, plWrap.selectedPlName);
                if (pgNameLst != null && pgNameLst.size() > 0 && !pgNameLst.contains(so)) {
                    pgNameLst.add(0, so);
                }
                plWrap.pgNames = pgNameLst;
                plWrap.sobj = pl;
                prtLayoutMap.put(pl.Record_Type__r.Name, plWrap);
            }
        }
        for (String rtName : allRtNames) {
            if(!prtLayoutMap.containsKey(rtName)){
                PageLayoutWrapper plWrap = new PageLayoutWrapper();
                plWrap.selectedPlName = 'NA';
                SelectOption so = new SelectOption('NA', 'NA');
                if (!pgNameLst.contains(so)) {
                    pgNameLst.add(0, so);
                }
                plWrap.pgNames = pgNameLst;
                
                prtLayoutMap.put(rtName, plWrap);
            }
        }
        return prtLayoutMap;
    }
    
    public List<RecordTypeWrapper> getrtWrapLst(List<PageLayout__c> plLst, List<String> allRtNames){
        List<RecordTypeWrapper> rtTypeWrapLst = new List<RecordTypeWrapper>();
        List<String> rtTypeName = new List<String>();
        for(PageLayout__c pl : plLst){
            if(!rtTypeName.contains(pl.Record_Type__r.Name)){
                rtTypeName.add(pl.Record_Type__r.Name);
                allRtNames.add(pl.Record_Type__r.Name);
                RecordTypeWrapper rtWrap = new RecordTypeWrapper();
                rtWrap.recordTypeName = pl.Record_Type__r.Name;
                rtTypeWrapLst.add(rtWrap);
            }
        }
        return rtTypeWrapLst;
    }

    public Pagereference save(){
        List<PageLayout__c> updatePgLst = new List<PageLayout__c>();

        try {
            List<String> existinglayout = new  List<String>();
            for (PageLayout__c pg :  [SELECT Profile__r.Name, Name FROM PageLayout__c]) {
                existinglayout.add(pg.Name + pg.Profile__r.Name);
            }
            for (String s : proRtMap.keySet()) {
                for (RecordTypeWrapper rt : proRtMap.get(s).rtWrapLst) {
                    for (ProfileWrapper prw : proRtMap.get(s).profWrapLst) {
                        if(prw.prtlayout.get(rt.recordTypeName).sobj != null){
                            if(!existinglayout.contains(prw.prtlayout.get(rt.recordTypeName).selectedPlName + prw.profileName)){
                                prw.prtlayout.get(rt.recordTypeName).sobj.put('Name', prw.prtlayout.get(rt.recordTypeName).selectedPlName);
                                prw.prtlayout.get(rt.recordTypeName).sobj.put('PagelayoutId__C', getPagelayoutId(prw.prtlayout.get(rt.recordTypeName).selectedPlName));
                               
                                updatePgLst.add((Pagelayout__c)prw.prtlayout.get(rt.recordTypeName).sobj); //.put('name', prw.prtlayout.get(rt.recordTypeName).selectedPlName)
                            }
                        }else {
                            //  prw.prtlayout.get(rt.recordTypeName).sobj = new pagelayout__c();
                            //  prw.prtlayout.get(rt.recordTypeName).sobj.put('Name', prw.prtlayout.get(rt.recordTypeName).selectedPlName);
                            // updatePgLst.add((Pagelayout__c)prw.prtlayout.get(rt.recordTypeName).sobj); //.put('name', prw.prtlayout.get(rt.recordTypeName).selectedPlName)
                        }
                    }
                }
            }
            update updatePgLst;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Page Layouts Updated Successfully'));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage() + ' Line ==> '+ e.getLineNumber()));
        }
        return null;
    }


    public  String accessToken;

    public  void orgAuthentication(){
         GoogleAndConnectedAppCredentials__c credentials = GoogleAndConnectedAppCredentials__c.getInstance('Credential1');
            String grantType = 'password';
            String client_Id = credentials.OrgClientId__c;
            String client_secret = credentials.OrgClientSecret__c;
            String userName = credentials.OrgUserName__c;
            String password = credentials.OrgPassword__c;
            String securityToken = credentials.OrgSecurityToken__c;
            String instanceUrl = 'https://login.salesforce.com';
            String endPointUrl = instanceUrl + '/services/oauth2/token?grant_type=' + grantType + '&client_id=' + client_Id + '&client_secret=' + client_secret + '&username=' + userName + '&password=' + password + securityToken;
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(endPointUrl);
            HttpResponse res = h.send(req);
            String body = res.getBody();
            accessToken = String.valueOf(((Map<String, Object>)JSON.deserializeUntyped(body)).get('access_token'));
            
    }

    public  void goToPageLayOutPage(){
        List<PageLayout__c> toInsertPageLayout  =  new List<PageLayout__c>();
        List<String> checkForPageLayout = new List<String>();
        String obj = '';
        List<String> rectype = new List<String>();
        try {
            List<PageLayout__C> existingPageLayout = [SELECT Name, Object__r.Name, Profile__r.Name,  record_Type__r.Name FROM PageLayout__C];
            for (PageLayout__C playout : existingPageLayout) {
                checkForPageLayout.add(playout.name + playout.Object__r.Name + playout.profile__r.name + playout.record_Type__r.Name);
                
            }
            List<Record_Type__c> recTypeLst = [SELECT Object__r.Developer_Name__c, object__c, Profile__c,  Profile__r.Name, Name FROM record_Type__c  ORDER BY Object__r.developer_Name__C];
            for(Record_Type__c rt : recTypeLst){
               
                if(rt.isPermitted__c = true){
                   
                    if (obj != rt.Object__r.Developer_Name__c) {
                         rectype =  getPageLayoutName(rt.Object__r.developer_Name__c);
                    }
                    obj = rt.Object__r.Developer_Name__c;
                    for (String s : rectype) {
                        PageLayout__c pg = new PageLayout__c();
                        pg.object__c  =  rt.object__c;
                        pg.profile__c = rt.profile__c;
                        pg.Record_Type__c = rt.id;
                        pg.Name =s;
                        String str = s + rt.Object__r.Developer_Name__c + rt.profile__r.Name + rt.Name ;
                        if(!checkForPageLayout.contains(str)){
                            toInsertPageLayout.add(pg);
                        }
                    }
                }else {
                    PageLayout__c pg = new PageLayout__c();
                    pg.object__c  =  rt.object__c;
                    pg.profile__c = rt.profile__c;
                    pg.Record_Type__c = rt.id;
                    //pg.Name = getPageLayoutName(rt.Object__r.developer_Name__c);
                }
                
            }
            insert toInsertPageLayout;
        } catch (Exception e) {
             System.debug('Exception in class: ' + String.valueOf(this).split(':')[0] + ' === Message: ' + e.getMessage() + ' === At Line: ' + e.getLineNumber());
        }
        
    }
    public List<Selectoption> convertListStringTOListSelectoption(List<String> strLst){  //convert list to Map<id, name>
        List<Selectoption> optLst = new List<Selectoption>();
            for (String s : strLst) {
                optLst.add(new SelectOption(s,s));

            }
            return optLst;
    }

Public String getPagelayoutId(String pgName){
    pgName  = EncodingUtil.urlEncode(pgName, 'UTF_8');
    orgAuthentication();
    String pagLayoutId ; 
    try {
        string allLayoutsRestUrl = 'https://'+getUrlPrefix()+'.salesforce.com/services/data/v38.0/tooling/query?q=SELECT+id+FROM+Layout+WHERE+Name=%27' + pgName+'%27+LIMIT+1';
            string urlToRequest = allLayoutsRestUrl ;
            HttpResponse resp = null;
            HttpRequest req = new HttpRequest();

            req.setMethod('GET');
            req.setEndpoint(urlToRequest);
            req.setHeader('Authorization', 'Bearer ' + accessToken);
            
            Http client = new Http();
            resp = client.send(req);
            System.debug(resp.getBody());
           // If((Integer)((Map<String, Object>)JSON.deserializeUntyped(resp.getBody())).get('size') == 1) {
                List<Object> mapName =(List<object>)((Map<String, Object>)JSON.deserializeUntyped(resp.getBody())).get('records');
                Map<String, Object> recNme = (Map<String, Object>)mapName[0];
                pagLayoutId = (String)recNme.get('Id');
           // }
    } catch (Exception e) {
        System.debug('exception ' + e.getLineNumber());
         Apexpages.addMessage(new apexpages.message(Apexpages.Severity.ERROR, e.getMessage() + '   ' + e.getLineNumber()));
    }
    System.debug(pagLayoutId);
            return pagLayoutId ;
}


    public List<String> getPageLayoutName(String objName){
        List<String> layoutLst =  new List<String>();
        orgAuthentication();
        Integer Offset = 0;
        Boolean flag = true;

       try {
            if (!Schema.getGlobalDescribe().get(objName).getdescribe().isCUstom()) {
                
                while(flag){
                string allLayoutsRestUrl = 'https://'+getUrlPrefix()+'.salesforce.com/services/data/v38.0/tooling/query?q=SELECT+Name+FROM+Layout+WHERE+TableEnumOrId=%27' + objName + '%27+LIMIT+1+OFFSET+' + Offset;
                string urlToRequest = allLayoutsRestUrl ;
                HttpResponse resp = null;
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                req.setEndpoint(urlToRequest);
                req.setHeader('Authorization', 'Bearer ' + accessToken);
                
                Http client = new Http();
                resp = client.send(req);
                If((Integer)((Map<String, Object>)JSON.deserializeUntyped(resp.getBody())).get('size') == 1) {
                    List<Object> mapName =(List<object>)((Map<String, Object>)JSON.deserializeUntyped(resp.getBody())).get('records');
                    Map<String, Object> recNme = (Map<String, Object>)mapName[0];
                    String pageLayoutName = (String)recNme.get('Name');
                    layoutLst.add(pageLayoutName);
                    Offset++;
                }else {
                    String pgg = layoutLst[0];
                layoutLst[0] = layoutLst[layoutLst.size()-1] ;
                layoutLst[layoutLst.size()-1] = pgg;
                    flag =false;
                    break;
                }

            }
        } else {
                

             string allLayoutsRestUrl = 'https://'+getUrlPrefix()+'.salesforce.com/services/data/v45.0/sobjects/'+objName+'/describe/layouts/';
                    
                    HttpResponse resp = null;
                    HttpRequest req = new HttpRequest();
                    req.setMethod('GET');
                    req.setEndpoint(allLayoutsRestUrl);
                   
                    req.setHeader('Authorization', 'Bearer ' + accessToken);
                    Http client = new Http();
                    resp = client.send(req);
                    Map<String, Object> mapName =((Map<String, Object>)JSON.deserializeUntyped(resp.getBody()));
                    List<object> lst =(List<object>) mapName.get('recordTypeMappings');
                    String  layoutId  =' (';
                    for(object ob : lst){
                        Map<String, Object> lLst = (Map<String, Object>)(ob);
                       layoutId +=  '\'' + (id)lLst.get('layoutId') + '\', ';
                      
                    }
                    layoutId = layoutId.substring(0, layoutId.lastindexOf(',')) + ')';
                    layoutId = EncodingUtil.urlEncode(layoutId, 'UTF-8');
                    flag = false;
                String  allLayoutsRestUrl1 = 'https://'+getUrlPrefix()+'.salesforce.com/services/data/v38.0/tooling/query?q=SELECT+Name+%2C+Id+FROM+Layout+WHERE+Id+IN+' + layoutId;
                HttpResponse  resp1 = new HttpResponse();
                HttpRequest  req1 = new HttpRequest();
                     
                    req1.setMethod('GET');
                    req1.setEndpoint(allLayoutsRestUrl1);
                    req1.setHeader('Authorization', 'Bearer ' + accessToken);
                    
                    Http client1 = new Http();
                    resp1 = client1.send(req1);
                   
                    try {  
                        List<Object> mapName1 =(List<object>)((Map<String, Object>)JSON.deserializeUntyped(resp1.getBody())).get('records');
                        for (Object obj : mapName1){
                            Map<String, Object> recNme = (Map<String, Object>)(obj);
                           // pg.pgId = (id)recNme.get('Id');
                            layoutLst.add((String)recNme.get('Name'));
                        }
                    } catch (Exception e) {
                        Apexpages.addMessage(new Apexpages.message(Apexpages.Severity.ERROR, e.getMessage() + '   ' + e.getLineNumber()));
                    }
        }
       } catch (Exception e) {
           System.debug('Exception ==>> ' + e.getMessage() + ' line Number == >> ' + e.getLineNumber());
           ApexPages.addMessage(new apexpages.message(Apexpages.Severity.ERROR, e.getMessage() + 'Line Number ==>> ' + e.getLineNumber()));
       }
        // String str = pageLayoutName.subString(pageLayoutName.indexOf(objName) + objName.length() + 1);
        // str = EncodingUtil.urlDecode(str, 'UTF-8');
        return layoutLst;
    }
 string getUrlPrefix(){
        String baseurl = [SELECT InstanceName FROM Organization].InstanceName;
        return baseurl;
    }
    
    public class ProfRTType{
        public List<ProfileWrapper> profWrapLst {get;set;}
        public List<RecordTypeWrapper> rtWrapLst {get;set;}
    }
    
    public class ProfileWrapper{
        public String profileName {get;set;}
        public Map<String, pageLayoutWrapper> prtLayout {get;set;}
    }

    public class RecordTypeWrapper{
        public String recordTypeName {get;set;}
    }

    public class pageLayoutWrapper{
        public sobject sobj ;
        public List<SelectOption> pgNames {get;set;}
        public String selectedPlName {get;set;}
    }
    


//// Insert Section Part //////
    public List<Record_Type__C> recordTypeLst ;
    public List<Section__c> sectionLst {get; set;}
    public List <LayoutDescriberHelper.LayoutSection> layoutSections {
        get;
        set;
    }
    public  void CreateSectionAndField() {
        sectionLst = new List<Section__c>();
        recordTypeLst = new List<Record_type__C>();
        layoutSections = new List<LayoutDescriberHelper.LayoutSection>();
        initSection();
    }

    public void initSection(){
        sectionLst = new List<Section__c>();
        List<String> existingRecordType = new List<String>();
         try {
            // recordTypeLst = [SELECT Name, recordTypeId__c, Object__c, profile__r.Name, Object__R.Name, (SELECT id, name FROM Pagelayouts__r) FROM Record_Type__c];
            
            for (PageLayout__c rt : [SELECT PageLayoutid__C, Record_Type__r.recordTypeId__C, Profile__r.Name, Object__r.Developer_name__C, Name FROM Pagelayout__C ]) {
               
                if (!existingRecordType.contains(rt.Name)) {
                     existingRecordType.add(rt.name);
                    layoutSections = LayoutDescriberHelper.describeSectionWithFields(rt.record_Type__r.RecordTypeId__C, rt.Object__r.Developer_name__C, rt.profile__r.Name);
                    initSectionAndField(rt.id, rt.Object__R.Developer_name__C);
                   
                }
            }
             insertSectionAndField();
         } catch (Exception e) {
             APexpages.addMessage(new Apexpages.message(Apexpages.Severity.ERROR, e.getMessage() + '  ' + e.getCause() + '   ' + e.getLineNumber()));
         }
    }

    public void initSectionAndField(String s,  String obj){
        
        List<String> fldlst;
        List<String> existingSectionLst = new list<String>();
        try {
            for (Section__C sec  : [SELECT Name, PageLayout__r.id FROM Section__C]) {
                existingSectionLst.add(sec.Name + sec.PageLayout__r.id);
            }
            for (LayoutDescriberHelper.LayoutSection section : layoutSections) {
                Section__c sec  = new Section__C();
                sec.Name = section.Name;
                sec.column__c = section.columns;
                sec.pageLayout__C = s;
                sec.ObjectName__c  = obj;
                fldLst = new List<String>();

                for (LayoutDescriberHelper.LayoutField fld : Section.layoutFields) {
                    if(fld.ApiName == 'BillingAddress'){
                        fldLst.add('BillingStreet');
                        fldLst.add('BillingCity');
                        fldLst.add('BillingState');
                        fldLst.add('BillingPostalCode');
                        fldLst.add('BillingCountry');
                    } else if(fld.ApiName == 'ShippingAddress'){
                            fldLst.add('ShippingStreet');
                            fldLst.add('ShippingCity');
                            fldLst.add('ShippingState');
                            fldLst.add('ShippingPostalCode');
                            fldLst.add('ShippingCountry');
                    } else if (fld.ApiName == 'MailingAddress') {
                            fldLst.add('MailingStreet');
                            fldLst.add('MailingCity');
                            fldLst.add('MailingState');
                            fldLst.add('MailingPostalCode');
                            fldLst.add('MailingCountry');
                    } else if(fld.ApiName == 'OtherAddress') {
                            fldLst.add('OtherStreet');
                            fldLst.add('OtherCity');
                            fldLst.add('OtherState');
                            fldLst.add('OtherPostalCode');
                            fldLst.add('OtherCountry');
                    } else {
                        fldLst.add(fld.ApiName);
                    }
                    
                }
                sec.fields_developer_Name__c = String.join(fldLst, '; ');
                if(!existingSectionLst.contains(section.Name +s)){
                        sectionLst.add(sec);
                }
            }
        } catch (Exception e) {
                Apexpages.addMessage(new apexpages.message(Apexpages.Severity.ERROR, e.getMessage() + ' line ==>  ' + e.getLineNumber()));
            }
    }

    public void insertSectionAndField(){
        try {
          if (sectionLst != null) {
                Database.insert(sectionLst, false);
                 ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.CONFIRM,' Sections And Field  Successfully inserted'));
          }
        } catch (Exception e) {
            Apexpages.addMessage(New Apexpages.message(Apexpages.Severity.ERROR, e.getMessage() + 'Line ==> ' + e.getLineNumber()));
            
        }
    }
}