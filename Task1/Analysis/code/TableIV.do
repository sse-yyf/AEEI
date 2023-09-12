clear
cd "G:\我的云端硬盘"
cap erase "Yifan_Yang\Task1\Analysis\outcome\TableIV.doc"
cap erase "Yifan_Yang\Task1\Analysis\outcome\TableIV.txt"

use "Yifan_Yang\Task1\Analysis\input\TableIV_data.dta"
*** Col 1 2 3 4 5 6 7 8 ***
reg  LWKLYWGE EDUC  YR20-YR28 
outreg2 using Yifan_Yang\Task1\Analysis\outcome\TableIV.doc,append ctitle(OLS) bdec(4) tdec(4) keep(EDUC RACE SMSA MARRIED AGEQ AGEQSQ) addtext(9 Year-of-birth dummies, Yes, 8 Region of residences dummies, No)

ivregress 2sls LWKLYWGE YR20-YR28 (EDUC = QTR120-QTR129 QTR220-QTR229 QTR320-QTR329 YR20-YR28)
outreg2 using Yifan_Yang\Task1\Analysis\outcome\TableIV.doc,append ctitle(TSLS) bdec(4) tdec(4) keep(EDUC RACE SMSA MARRIED AGEQ AGEQSQ) addtext(9 Year-of-birth dummies, Yes, 8 Region of residences dummies, No)

reg  LWKLYWGE EDUC  YR20-YR28 AGEQ AGEQSQ 
outreg2 using Yifan_Yang\Task1\Analysis\outcome\TableIV.doc,append ctitle(OLS) bdec(4) tdec(4) keep(EDUC RACE SMSA MARRIED AGEQ AGEQSQ) addtext(9 Year-of-birth dummies, Yes, 8 Region of residences dummies, No)	

ivregress 2sls LWKLYWGE YR20-YR28 AGEQ AGEQSQ (EDUC = QTR120-QTR129 QTR220-QTR229 QTR320-QTR329 YR20-YR28)
outreg2 using Yifan_Yang\Task1\Analysis\outcome\TableIV.doc,append ctitle(TSLS) bdec(4) tdec(4) keep(EDUC RACE SMSA MARRIED AGEQ AGEQSQ) addtext(9 Year-of-birth dummies, Yes, 8 Region of residences dummies, No)

reg  LWKLYWGE EDUC  RACE MARRIED SMSA NEWENG MIDATL ENOCENT WNOCENT SOATL ESOCENT WSOCENT MT YR20-YR28  
outreg2 using Yifan_Yang\Task1\Analysis\outcome\TableIV.doc,append ctitle(OLS) bdec(4) tdec(4) keep(EDUC RACE SMSA MARRIED AGEQ AGEQSQ) addtext(9 Year-of-birth dummies, Yes, 8 Region of residences dummies, No)

ivregress 2sls LWKLYWGE YR20-YR28 RACE MARRIED SMSA NEWENG MIDATL ENOCENT WNOCENT SOATL ESOCENT WSOCENT MT  (EDUC = QTR120-QTR129 QTR220-QTR229 QTR320-QTR329 YR20-YR28)
outreg2 using Yifan_Yang\Task1\Analysis\outcome\TableIV.doc,append ctitle(TSLS) bdec(4) tdec(4) keep(EDUC RACE SMSA MARRIED AGEQ AGEQSQ) addtext(9 Year-of-birth dummies, Yes, 8 Region of residences dummies, No)

reg  LWKLYWGE EDUC  RACE MARRIED SMSA NEWENG MIDATL ENOCENT WNOCENT SOATL ESOCENT WSOCENT MT YR20-YR28 AGEQ AGEQSQ 
outreg2 using Yifan_Yang\Task1\Analysis\outcome\TableIV.doc,append ctitle(OLS) bdec(4) tdec(4) keep(EDUC RACE SMSA MARRIED AGEQ AGEQSQ) addtext(9 Year-of-birth dummies, Yes, 8 Region of residences dummies, No)

ivregress 2sls LWKLYWGE YR20-YR28 RACE MARRIED SMSA NEWENG MIDATL ENOCENT WNOCENT SOATL ESOCENT WSOCENT MT AGEQ AGEQSQ (EDUC = QTR120-QTR129 QTR220-QTR229 QTR320-QTR329 YR20-YR28)
outreg2 using Yifan_Yang\Task1\Analysis\outcome\TableIV.doc,append ctitle(TSLS) bdec(4) tdec(4) keep(EDUC RACE SMSA MARRIED AGEQ AGEQSQ) addtext(9 Year-of-birth dummies, Yes, 8 Region of residences dummies, No)

cap erase "Yifan_Yang\Task1\Analysis\outcome\TableIV.txt"
