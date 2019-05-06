global class SectionAndFieldIteratorClass implements Iterable<sObject>{  
      
    List<sObject> recordList;  
      
    global SectionAndFieldIteratorClass(List<sObject> recordList){  
        this.recordList = recordList;  
    }  
      
    global Iterator<sObject> Iterator(){  
        return new IterableClass(this.recordList);  
    }  
      
}  
