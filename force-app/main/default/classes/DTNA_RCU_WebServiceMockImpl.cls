@isTest(SeeAllData=True)
global class DTNA_RCU_WebServiceMockImpl implements WebServiceMock 
{
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) 
   {
       iibIms_ConcessionApprovalRequest.SyncResponse_element ObjSyncResp = new iibIms_ConcessionApprovalRequest.SyncResponse_element();
       iibIms_ConcessionApprovalRequest.ServiceResponseMsg_element respElement = 
           new iibIms_ConcessionApprovalRequest.ServiceResponseMsg_element();
       ObjSyncResp.IMSMessageData = 'T12345¢JFTL026 ¢I-611 CONCESSION IS EXPIRED ¢ ¢T12345¢2H6316¢JRFD¢TRUCK COUNTRY OF WISCONSIN¢2H6316¢042516¢EXP¢DE FOREST, WI ¢PATTON ¢ ¢CENTRAL ¢25¢ ¢ ¢ ¢ ¢DYLAN GLINDINNING ¢ ¢ ¢ ¢ ¢FRANK STRANZL ¢HULL TRANSPORT LOGISTICS ¢ ¢ ¢352 INDUSTRIAL CIRCL¢ ¢W63982¢N¢ ¢ ¢ ¢ ¢STOUGHTON ¢WI¢ ¢PX125064S T¢CA125SLP ¢INT¢PET¢ ¢ 15¢Y¢N¢ ¢N¢N¢N¢N¢2H2430¢ 15¢ 30¢ 187637¢ 189289¢ 15¢ 15¢ 74492¢ 75810¢ 15¢ 30¢ ¢ ¢39.50¢*¢ 74769¢ ¢40.05¢*¢ 75810¢ ¢ 113145¢ 113479¢ 2000¢ 2000¢RP1¢042516¢ ¢ ¢030116¢093016¢ ¢ ¢ ¢14C¢Y¢ 3500¢ 5000¢CASCADIA PRL-14C (EFF:10/5/15) ¢ 118645¢ 120479¢14C¢Y¢CASCADIA PRL-14C (EFF:10/5/15) ¢062416¢ ¢ ¢ ¢ ¢NN¢ST¢SLEEPER TANDEM¢ 132852¢ 120479¢ 35.35¢ 4.70¢ ¢ 0¢ ¢ 189289¢ ¢ 0.00¢ 104126¢ 75810¢ ¢ ¢ ¢ ¢ ¢ ¢ ¢APR¢ 28316¢ 400¢ RQSTD DELV:¢ ¢LATEST DELV:¢ ¢ ¢ ¢ ¢ ¢ ¢6 ¢040317¢02.00¢75.00¢|001¢MY17 EATON FULLER IS BUILT IN PRICING ¢E¢CN¢PATTON | ¢MUST HAVE: ¢E¢SP¢PATTON |AF3¢AF3-2CR TRACTOR ONLY WITH NO BODY UPFIT ¢E¢SP¢PATTON |A84¢A84-1GF GENERAL FREIGHT BUSINESS SEGME¢E¢SP¢PATTON |A85¢A85-005 LINEHAUL/LONG HAUL SERVICE ¢E¢SP¢PATTON |PMR¢PMR-998 NO ESCALATOR ¢E¢SP¢PATTON |PMT¢PMT-998 NO 2013 ENGINE ESCALATOR ¢E¢SP¢PATTON |PMU¢PMU-017 2016 OBD/2010 EPA/CARB/GHG17 ESC¢E¢SP¢PATTON |P63¢P63-998 NONE ¢E¢SP¢PATTON |R1X¢R1X-001 2 YEAR SERVICE CONTRACT INCLUDED¢E¢SP¢PATTON |WAI¢WAI-18A EW3: DD15 HWY. $0 DEDUCTIBLE. 4 ¢E¢SP¢PATTON |001¢001-233 CASCADIA 125 INCH SLEEPERCAB ¢E¢SP¢PATTON |002¢002-002 SET BACK AXLE - TRACTOR ¢E¢SP¢PATTON |066¢066-030 CASCADIA EVOLUTION (NO PREDICTIV¢E¢SP¢PATTON |093¢093-2B3 MICHELIN XZA3+ 275/80R22.5 14 ¢E¢SP¢PATTON |094¢094-0M1 MICHELIN XDA ENERGY 275/80R22.¢E¢SP¢PATTON |101¢101-2YK DETROIT DD15 14.8L 455 HP @ 16¢E¢SP¢PATTON |342¢342-419 EATON FULLER FRO-16210C TRANSM¢E¢SP¢PATTON |400¢400-1G3 STEERTEK NXT - WT 12,500# FF1 ¢E¢SP¢PATTON |420¢420-1GR DETROIT DA-RT-40.0-4 HT 40,000¢E¢SP¢PATTON |682¢682-077 72 INCH RAISED ROOF SLEEPERCAB¢E¢SP¢PATTON |829¢829-1AF 125 INCH BBC ALUMINUM CONVENTI¢E¢SP¢PATTON |99C¢99C-017 2016 ONBOARD DIAGNOSTICS/2010 EP¢E¢SP¢PATTON |001¢YEAR OVER YEAR PRICE WALK ¢I¢CN¢PATTON |002¢PREV SN GT8754 ¢I¢CN¢PATTON |003¢PREV CONC 2G7577 ¢I¢CN¢PATTON |004¢PREV INVOICE $113,895.00 ¢I¢CN¢PATTON |005¢SPEC CHARGES ($1,594.03) ¢I¢CN¢PATTON |006¢REVENUE ENHANCEMENT $100.00 ¢I¢CN¢PATTON |007¢MY17 WITH EATON TRANS $2,050.00 ¢I¢CN¢PATTON |008¢SPD OVERRIDE $64.55 ¢I¢CN¢PATTON |009¢+/- VOLUME $0.00 ¢I¢CN¢PATTON |010¢NEW PRICE $114,515.52 ¢I¢CN¢PATTON |011¢NEW CONCESSION 39.50% ¢I¢CN¢PATTON |012¢REPLACD 2H6316 TO INCREASE TO 40.05% TO ¢I¢CN¢PATTON |013¢REDUCE MY17 BY $1050 APPROVED BY KL ¢I¢CN¢PATTON |001¢PREV CONC REQ# 2H2430 ¢I¢DL¢PATTON | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ | ¢ ¢ ¢ ¢ ¢EOF';
       respElement.SyncResponse = ObjSyncResp;
       system.debug('test1 ' + respElement);
       system.debug('test2 ' + stub);
       system.debug('test3 ' + request);
       system.debug('test4 ' + response);
       system.debug('test5 ' + endpoint);
       system.debug('test6 ' + soapAction);
       system.debug('test7 ' + requestName);
       system.debug('test8 ' + responseNS);
       system.debug('test9 ' + responseName);
       system.debug('test9 ' + responseType);
       
       response.put('response_x', respElement); 
       system.debug('test4 ' + response);
   }
}