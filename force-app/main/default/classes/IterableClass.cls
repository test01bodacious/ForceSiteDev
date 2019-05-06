global class IterableClass implements Iterator<sObject>{   
      
    List<sObject> records {get; set;}   
    Integer index {get; set;}   
      
    public IterableClass(List<sObject> recordList){   
        this.records = recordList;  
        index = 0;   
    }     
      
    global Boolean hasNext(){   
        if(index >= records.size()) {  
            return false;   
        } else {  
            return true;   
        }  
    }      
      
    global sObject next(){  
        if(index == records.size()){return null;}   
        index++;   
        return records[index-1];   
    }   
}
