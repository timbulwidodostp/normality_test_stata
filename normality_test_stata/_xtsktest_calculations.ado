capture program drop _xtsktest_calculations
program define _xtsktest_calculations, rclass

syntax varlist(min=1), [STANDard]

tempvar uhat muhat muhat2 muhat3 muhat4 nuhat nuhat2 nuhat3 nuhat4 sk_nu ku_nu i

qui xtset 
loc  T  = (r(tmax)-r(tmin))/r(tdelta) + 1
gen `i' = `r(panelvar)'

reg `varlist'

predict `uhat', res
bys `i': egen `muhat' = mean(`uhat')
gen `nuhat' = `uhat' - `muhat'

gen `nuhat2' = `nuhat'^2
summ `nuhat2'
loc sigma2_nu = r(mean)*`T'/(`T'-1)
replace `nuhat2' = `nuhat2' - r(mean)

gen `muhat2' = `muhat'^2
summ `muhat2' 
loc sigma2_mu = r(mean) - 1/`T'*`sigma2_nu'
replace `muhat2' = `muhat2'-r(mean)

*Skewness
gen `nuhat3' = `nuhat'^3
summ `nuhat3'
loc mean_nuhat3 = r(mean)
loc stdr_nuhat3 = `mean_nuhat3'/(`sigma2_nu'^(3/2))

bys `i': egen `sk_nu' = mean(`nuhat3')
gen `muhat3' = `muhat'^3-`T'^-2*`sk_nu'*(1-3*`T'^-1+2*`T'^-2)^-1
summ `muhat3'
loc mean_muhat3 = r(mean)
loc stdr_muhat3 = `mean_muhat3'/(`sigma2_mu'^(3/2))

*Kurtosis
gen `nuhat4' = (`nuhat'^4-`sigma2_nu'^2*(`T'-1)*(6*`T'^-2-9*`T'^-3))/(1 - 4*`T'^-1 + 6*`T'^-2 - 3*`T'^-3)-3*`sigma2_nu'^2
summ `nuhat4'
loc mean_nuhat4 = r(mean)
loc stdr_nuhat4 = (`mean_nuhat4'+ 3*(`sigma2_nu'^2))/(`sigma2_nu'^2) - 3

bys `i': egen `ku_nu' = mean(`nuhat4')
gen `muhat4' = `muhat'^4-`T'^-3*(`ku_nu'+ 3*(`T'-1)*`sigma2_nu'^2)-6*`T'^-1*`sigma2_nu'*`sigma2_mu'-3*`sigma2_mu'^2
summ `muhat4'
loc mean_muhat4 = r(mean)
loc stdr_muhat4 = (`mean_muhat4'+ 3*(`sigma2_mu'^2))/(`sigma2_mu'^2) - 3

* Default
if "`standard'"=="" {
	return scalar nuhat3 = `mean_nuhat3'
	return scalar nuhat4 = `mean_nuhat4'
	return scalar muhat3 = `mean_muhat3'
	return scalar muhat4 = `mean_muhat4'
	}

* Standard
if "`standard'"!="" {
	return scalar nuhat3 = `stdr_nuhat3'
	return scalar nuhat4 = `stdr_nuhat4'
	return scalar muhat3 = `stdr_muhat3'
	return scalar muhat4 = `stdr_muhat4'
	}

end
