public class QQ_Util 
{
    public string formatPrice(Double price, string format)
    {
        string formatedPrice = '';
        
        string strPrice = string.valueOf(price);
        string num = strPrice.substring(0,strPrice.indexOf('.'));
        string frac = strPrice.substring(strPrice.indexOf('.') + 1, strPrice.length());
		if(frac.length() < 2)	frac = frac +'0';
        List<Integer> lstNum = new List<Integer>(); 
        for(integer i = 0; i < num.length(); i++)
        {
            if(i == num.length()-3 && i != 0)
            {
                lstNum.add(44);
            }
            if(i == num.length()-5 && i != 0)
            {
                lstNum.add(44); 
            }
            if(i == num.length()-7 && i != 0)
            {
                lstNum.add(44); 
            }
            lstNum.add(num.charAt(i));
        }
		
        if(format == 'PRICE')
        {
            formatedPrice = '$ ' + string.fromCharArray(lstNum) + '.' + frac + ' USD';
            //system.debug(formatedPrice);
        }
        else
        {
            formatedPrice = string.fromCharArray(lstNum);
        }
        
        return formatedPrice;
    }
    
    public string formatPrice(Double price)
    {
        string formatedPrice = '';
        
        string strPrice = string.valueOf(price);
        string num = strPrice.substring(0,strPrice.indexOf('.'));
        string frac = strPrice.substring(strPrice.indexOf('.') + 1, strPrice.length());
		if(frac.length() < 2)	frac = frac +'0';
        List<Integer> lstNum = new List<Integer>(); 
        for(integer i = 0; i < num.length(); i++)
        {
            if(i == num.length()-3 && i != 0)
            {
                lstNum.add(44);
            }
            if(i == num.length()-5 && i != 0)
            {
                lstNum.add(44); 
            }
            if(i == num.length()-7 && i != 0)
            {
                lstNum.add(44); 
            }
            lstNum.add(num.charAt(i));
        }
		        
        formatedPrice = '$ ' + string.fromCharArray(lstNum) + '.' + frac + ' USD';
        //system.debug(formatedPrice);
        
        return formatedPrice;
    }
    
    public string getMonth(Date dt)
    {
        string sMonth = '';
        
        if(dt.month() == 1)
            sMonth = 'January';
        if(dt.month() == 2)
            sMonth = 'February';
        if(dt.month() == 3)
            sMonth = 'March';
        if(dt.month() == 4)
            sMonth = 'April';
        if(dt.month() == 5)
            sMonth = 'May';
        if(dt.month() == 6)
            sMonth = 'June';
        if(dt.month() == 7)
            sMonth = 'July';
        if(dt.month() == 8)
            sMonth = 'August';
        if(dt.month() == 9)
            sMonth = 'September';
        if(dt.month() == 10)
            sMonth = 'October';
        if(dt.month() == 11)
            sMonth = 'November';
        if(dt.month() == 12)
            sMonth = 'December';
        return sMonth;
    }
}