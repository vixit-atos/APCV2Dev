public class Filter //Class to Define the Filter
{
    public Integer Id{ get; set; }
    public String FieldName{ get; set; }
    public String Operator{ get; set;}
    public String Value{ get; set;}
    
    public Filter(Integer intId,String FN,String Op,String Val)
    {
        Id = intId;
        FieldName=FN;
        Operator=Op;
        Value=Val;
    }
    public Filter(Integer intId)
    {
        Id = intId;
    }
}