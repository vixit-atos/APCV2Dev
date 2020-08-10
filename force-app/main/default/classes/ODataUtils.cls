public with sharing class ODataUtils {
    public ODataUtils() {

    }


    static String mNS = 'http://schemas.microsoft.com/ado/2007/08/dataservices/metadata';
    static String dNS = 'http://schemas.microsoft.com/ado/2007/08/dataservices';
    static String aNS = 'http://www.w3.org/2005/Atom';

    public static string getURL(String url) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setClientCertificateName('dtna_soa_gtwy_cert_prod');
        req.setEndpoint(url);
        req.setHeader('Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8');
        req.setMethod('GET');

        System.debug('Request to:' + url);

        HttpResponse res = http.send(req);

        String ret = null;

        if (res.getStatusCode() < 299) {

            System.debug('Body: ' + res.getBody());
            return res.getBody();

        } else {

            //System.debug('Callout failed:' + res.getStatus() + ' : ' + res.getStatusCode());
            throw new CalloutException('Callout failed:' + res.getStatus() + ' : ' + res.getStatusCode());
        }


    }

    public static Dom.XMLNode getOdata(String url) {
        // Get the XML document from the external server
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setClientCertificateName('dtna_soa_gtwy_cert_prod');
        req.setEndpoint(url);
        req.setHeader('Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8');
        req.setMethod('GET');

        System.debug('Request to:' + url);

        HttpResponse res = http.send(req);

        System.debug('>>>>>>>>>> http:' + http);

        // Log the XML content
        System.debug('#res '+res);
        if (res.getStatusCode() < 299) {

            System.debug('#res.getBody() '+res.getBody());
            return res.getBodyDocument().getRootElement();

        } else {

            //System.debug('Callout failed:' + res.getStatus() + ' : ' + res.getStatusCode());
            throw new CalloutException('Callout failed:' + res.getStatus() + ' : ' + res.getStatusCode());
        }

        //feed.getChildElement('entry', aNS).getChildElement('content', aNS).getChildElement('properties', mNS);
    }

    public static Dom.XMLNode getProperties(Dom.XMLNode n) {

        Dom.XMLNode r = n;



        if (r.getName() == 'feed') {
            r = n.getChildElement('entry', aNS);
        }

        if (r == null) return r;

        if (r.getName() == 'entry') {
            r = r.getChildElement('content', aNS).getChildElement('properties', mNS);
        }


        return r.getName() == 'properties' ? r : null;


    }


    public static void fillMap(Dom.XMLNode properties, Map<string, List<string>> mcMap) {

        if (properties == null) return;

        if (properties != null) {

            for (Dom.XMLNode n : properties.getChildElements()) {

                mcMap.put(n.getName(), new String[] {'1', n.getText().trim()});

            }
        }
    }

    public static void fillMap(Dom.XMLNode feed, Map<string, Map<string, List<string>>> mm, String [] keyElements) {

        Map<string, List<string>> currMap;
        String key;

        if (feed == null) return;

        for (Dom.XMLNode n : feed.getChildElements()) {
            if (n.getName() == 'entry') {
                n = getProperties(n);


                currMap = new Map<string, List<string>>();
                fillMap(n, currMap);

                key = '';
                for (String keyElement : keyElements) {

                    //this did not concat keys
                    key = currMap.get(keyElement)[1];
                }

                if (mm.containsKey(key)) {
                    mm.get(key).putAll(currMap);
                } else {
                    mm.put(key, currMap);
                }

            }

        }

    }

    public static void fillMap(Dom.XMLNode feed, List<String> props, Map<string, List<string>> mcMap, Boolean useFullKey) {

        String key;

        if (feed == null) return;

        for (Dom.XMLNode n : feed.getChildElements()) {



            if (n.getName() == 'entry') {

                n = getProperties(n);

                List<String> pvl = new List<String>();

                for (String prop : props) {

                    pvl.add(n.getChildElement(prop, dNS).getText().trim());


                }


                key = useFullKey ? pvl[0] : pvl[0].left(4);

                //System.debug(pvl);

                if (mcMap.containsKey(key)) {

                    mcMap.get(key).addAll(pvl);

                } else {
                    mcMap.put(key, new string[] {string.valueof(props.size())});
                    mcMap.get(key).addAll(pvl);
                }

            }

        }



    }

    public static Map<string, List<string>> gen3map(Map<string, List<string>> input) {
        Map<string, List<string>> output = new Map<string, List<string>>();
        for (String key : input.keySet()) {
            output.put(key.left(3), input.get(key));
        }
        return output;

    }

    public static void printList(List<Map<string, List<string>>> ml) {
        for (Map<string, List<string>> le : ml) {
            printMap(le);
        }

    }

    public static void printMap(Map<string, List<string>> escMap) {

        List<String> dliString;



        for (String key : escMap.keySet()) {

            if (escMap.containsKey(key)) {

                dliString = escMap.get(key);

                if (dliString != null) {
                    for (String element : dliString) {

                        System.debug(key + ' : ' + element);


                    }
                }

            }
        }


    }

    public static SObject updateSObject(String destObjectName, SObject sObj, Map<string, Map<string, List<string>>> importMap) {
        Map<string, List<string>> mcMap;
        SObject so;
        String[] s;
        Integer index;


        for (TWS_Data_Map__c m : TWS_Data_Map__c.getAll().values()) {


            if (importMap.containsKey(m.Source_Table__c)) {

                mcMap = importMap.get(m.Source_Table__c);

                if (m.Dest_Object__c == destObjectName)  {
                    so = sObj;

                    if (mcMap.containsKey(m.Source_Field__c)) {

                        //System.debug('Working : ' + m.Source_Field__c + ' : ' + mcMap.get(m.Source_Field__c));

                        s = mcMap.get(m.Source_Field__c);
                        index = Integer.valueOf(s[0]) == 1 ? 1 : 2;

                        if (s[index] != null && s[index] != '') {

                            if (so.get(m.Dest_Field__c) == null) {
                                //dont overwrite stuff


                                if (m.Type__c == 'Decimal') {

                                    so.put(m.Dest_Field__c, Decimal.valueOf(s[index]));

                                } else if (m.Type__c == 'Date') {

                                    so.put(m.Dest_Field__c, Date.valueOf(s[index]));

                                } else {

                                    so.put(m.Dest_Field__c, s[index]);
                                }
                            }
                        }

                    }
                }
            }
        }

        return so;
    }

    public static Decimal sumField(Map<string, Map<string, List<string>>> input, String fieldName) {
        Decimal result = 0;
        List<string> cs ;
        for (Map<string, List<string>> cm : input.Values()) {
            if (cm.containsKey(fieldName)) {
                cs = cm.get(fieldName);
                if (cs.Size()>0  && cs != null) {
                    result = result + Decimal.Valueof(cs[1]);
                }

            }


        }



        return result;


    }

}