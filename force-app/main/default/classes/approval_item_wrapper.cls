public class approval_item_wrapper {    
        public approval_item_wrapper(id id,string name,string objtype,String DateSubmited,string tcmeetingcomments, id approvalid,String ConcessionStatus, String submittedBy  ) {
            this.id = id;
            this.name = name;
            this.objtype = objtype;
            this.DateSubmited = DateSubmited;
            this.tcmeetingcomments=tcmeetingcomments;
            this.approvalid =approvalid ;
            this.ConcessionStatus =ConcessionStatus ;
            this.submittedBy = submittedBy;
        }
        @auraEnabled
        public id id { get; set; }
        @auraEnabled
        public string name { get; set; }
        @auraEnabled
        public string objtype { get; set; }
        @auraEnabled
        public String DateSubmited { get; set; }
        @auraEnabled
        public string tcmeetingcomments{ get; set; }
        @auraEnabled
        public id approvalid { get; set; }
        @auraEnabled
        public String ConcessionStatus { get; set; }
        @auraEnabled
        public String submittedBy { get; set; }
}