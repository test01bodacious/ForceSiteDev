public  class CreateSectionPageController {
    public List<Record_Type__C> recordTypeLst ;
    public List<Section__c> sectionLst {get; set;}
    public List <LayoutDescriberHelper.LayoutSection> layoutSections {
        get;
        set;
    }
    public CreateSectionPageController() {
        sectionLst = new List<Section__c>();
        recordTypeLst = new List<Record_type__C>();
        layoutSections = new List<LayoutDescriberHelper.LayoutSection>();
        //initSection();
    }

    public void initSection(){
        sectionLst = new List<Section__c>();
        List<String> checkRT = new List<String>();
         try {
             recordTypeLst = [SELECT Name, recordTypeId__c, Object__c, profile__r.Name, Object__R.Name, (SELECT id, name FROM Pagelayouts__r) FROM Record_Type__c];
            for (Record_Type__c rt : recordTypeLst) {
               
                if (!checkRT.contains(rt.Name)) {
                     checkRT.add(rt.name);
                    layoutSections = LayoutDescriberHelper.describeSectionWithFields(rt.recordTypeId__C, rt.Object__R.Name, rt.profile__r.Name);
                    initSectionAndField(rt.PageLayouts__r[0].id, rt.Object__R.Name);
                   
                }
            }
             insertSectionAndField();
         } catch (Exception e) {
             APexpages.addMessage(new Apexpages.message(Apexpages.Severity.ERROR, e.getMessage() + '  ' + e.getCause() + '   ' + e.getLineNumber()));
             System.debug(e.getMessage() + '  ' + e.getCause() + '   ' + e.getLineNumber());
         }
    }

    public void initSectionAndField(String s,  String obj){
        
        List<String> fldlst;
        List<String> sLst = new list<String>();
        for (Section__C sec  : [SELECT Name, PageLayout__r.id FROM Section__C]) {
            sLst.add(sec.Name + sec.PageLayout__r.id);
        }
        for (LayoutDescriberHelper.LayoutSection section : layoutSections) {
            Section__c sec  = new Section__C();
            sec.Name = section.Name;
            sec.column__c = section.columns;
            sec.pageLayout__C = s;
            sec.ObjectName__c  = obj;
            fldLst = new List<String>();
            for (LayoutDescriberHelper.LayoutField fld : Section.layoutFields) {
                
                fldLst.add(fld.ApiName);
            }
            sec.fields_developer_Name__c = String.join(fldLst, '; ');
           if(!sLst.contains(section.Name +s)){
                sectionLst.add(sec);
           }
        }
    }

    public void insertSectionAndField(){
        try {
          if (sectionLst != null) {
                ApexPages.addMessage(new ApexPages.Message( ApexPages.Severity.INFO, String.valueOf(sectionLst)));
                Database.insert(sectionLst, false);
          }
        } catch (Exception e) {
            Apexpages.addMessage(New Apexpages.message(Apexpages.Severity.ERROR, e.getMessage() + 'Line ==> ' + e.getLineNumber()));
            
        }
    }
}