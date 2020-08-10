public class salesorderresponseclass {
    public SalesOrderResponse SalesOrderResponse;
    
    public class SalesOrderHeader {
        public String SalesOrderNumber;
        public String SalesOrderType;
        public String CustomerPONumber;
        public String SoldToParty;
        public String FacingPDC;
        public String CreatedOn;
    }
    
    public class SalesOrderResponse {
        public String ReturnCode;
        public String ReturnMessage;
        public SalesOrderHeader SalesOrderHeader;
        public List<SalesOrderItem> SalesOrderItem;
    }
    
    public class SalesOrderItem {
        public String OrderLineNumber;
        public String Material;
        public Integer Quantity;
        public String Plant;
        public String ShippingStatus;
        public Long Delivery;
        public Long OriginalDelivery;
        public String ShippingCondition;
        public String Invoice;
        public String PlannerCode;
        public String Vendor;
        public String ETA;
        public Long TrackingNumber;
    }
    
    
    public static salesorderresponseclass parse(String json) {
        return (salesorderresponseclass) System.JSON.deserialize(json, salesorderresponseclass.class);
    }
    
}