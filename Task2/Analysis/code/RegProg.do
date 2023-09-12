
*** REGRESSION ***

cap program drop olsregtable
program  olsregtable
	syntax varlist using/, keep(string)
	qui xi: reg `varlist' 
	outreg2 using "`using/'", append ctitle(OLS) bdec(4) tdec(4) keep(`keep')
end

cap program drop tslsregtable
program  tslsregtable
	syntax varlist using/, en(string) ex(string) keep(string)
	qui xi: ivregress 2sls `varlist' i.YOB (`en' = `ex'), robust
	outreg2 using "`using/'", append ///
	ctitle(TSLS) bdec(4) tdec(4) ///
	keep(`keep')	
end



*** END OF DO FILE ***