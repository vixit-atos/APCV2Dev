@isTest
public class QQ_Util_TEST 
{
    @isTest
    public static void runTest()
    {
        QQ_Util util = new QQ_Util();
        util.formatPrice(Double.valueOf(1234567.50));
        util.formatPrice(Double.valueOf(1234567.50), 'PRICE');
        util.formatPrice(Double.valueOf(1234567), 'MILES');
        
        Date dt = Date.today();
        Date dt1 = dt.addMonths(1);
        Date dt2 = dt.addMonths(2);
        Date dt3 = dt.addMonths(3);
        Date dt4 = dt.addMonths(4);
        Date dt5 = dt.addMonths(5);
        Date dt6 = dt.addMonths(6);
        Date dt7 = dt.addMonths(7);
        Date dt8 = dt.addMonths(8);
        Date dt9 = dt.addMonths(9);
        Date dt10 = dt.addMonths(10);
        Date dt11 = dt.addMonths(11);
        Date dt12 = dt.addMonths(12);
        util.getMonth(dt1);
        util.getMonth(dt2);
        util.getMonth(dt3);
        util.getMonth(dt4);
        util.getMonth(dt5);
        util.getMonth(dt6);
        util.getMonth(dt7);
        util.getMonth(dt8);
        util.getMonth(dt9);
        util.getMonth(dt10);
        util.getMonth(dt11);
        util.getMonth(dt12);
        util.getMonth(dt);
    }
}