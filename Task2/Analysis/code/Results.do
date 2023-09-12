clear all

*** VARIABLES MACROS ***
global DEPENDENT "LWKLYWGE"
global CONTROLS "RACE MARRIED SMSA NEWENG MIDATL ENOCENT WNOCENT SOATL ESOCENT WSOCENT MT"
global QTR		"QTR120-QTR129 QTR220-QTR229 QTR320-QTR329 YR20-YR28"
global KEEP 	"EDUC RACE SMSA MARRIED AGEQ AGEQSQ"

do "RegProg.do"

******* Review *******
foreach dset in AK91_Data AL99_Grade4_Data AL99_Grade5_Data {
	
use "../input/`dset'.dta"	
quietly {
    log using "../outcome/`dset'_review.txt", text replace
    noisily codebook
    log close
}
	
}

******* CREATE TABLES IV-VI *******

foreach x in IV V VI {
	
*** UPLOAD DATA ***
use "../input/Table`x'_Data.dta", clear

*** DATA ANALYSIS ***
cap erase "../outcome/Table`x'.doc"

olsregtable $DEPENDENT EDUC using "../outcome/Table`x'.doc", keep($KEEP)
olsregtable $DEPENDENT EDUC AGEQ AGEQSQ  using "../outcome/Table`x'.doc", keep($KEEP)
olsregtable $DEPENDENT EDUC $CONTROLS using "../outcome/Table`x'.doc", keep($KEEP)
olsregtable $DEPENDENT EDUC $CONTROLS AGEQ AGEQSQ using "../outcome/Table`x'.doc", keep($KEEP)

tslsregtable $DEPENDENT using "../outcome/Table`x'.doc", en(EDUC) ex($QTR) keep($KEEP)
tslsregtable $DEPENDENT AGEQ AGEQSQ using "../outcome/Table`x'.doc", en(EDUC) ex($QTR) keep($KEEP)
tslsregtable $DEPENDENT $CONTROLS  using "../outcome/Table`x'.doc", en(EDUC) ex($QTR) keep($KEEP)
tslsregtable $DEPENDENT $CONTROLS AGEQ AGEQSQ using "../outcome/Table`x'.doc", en(EDUC) ex($QTR) keep($KEEP)

cap erase "../outcome/Table`x'.txt"
}


*** END OF DO FILE ***
