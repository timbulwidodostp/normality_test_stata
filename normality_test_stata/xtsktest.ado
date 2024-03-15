*******************************************************************************************************
* xtsktest: Tests for skewness and kurtosis in the one-way error component model.
* 
* Reference: http://www.sciencedirect.com/science/article/pii/S0047259X13001346
* Version: 27/10/2014
*******************************************************************************************************

capture program drop xtsktest
program define xtsktest, eclass

version 12

	syntax [varlist(default=none)] [if], [Reps(integer 50) Seed(string) STANDard]

	capture xtset
	if (c(rc))!=0 {
		di as error "data must have xtset format"
		error 498
		}

	if ("`if'"!="" & "`e(model)'"=="re") {
		di as error "if not allowed with xtsktest as postestimation command, " _c
		error 101
		}	
		
	capture set seed `seed'
	if (c(rc))==0 {
		set seed `seed'
		}
		
	if ("`varlist'"=="" & "`e(model)'"=="re") {
		loc y = e(depvar)
		tempname bnames
		mat `bnames' = e(b)
		mat `bnames' = `bnames'[1,1..colsof(`bnames')-1]
		loc x : colnames `bnames'
		loc varlist "`y' `x'" 
		loc if = "if e(sample)"
		}

	if ("`varlist'"=="" & "`e(model)'"=="ols") {
		loc y = e(depvar)
		tempname bnames
		mat `bnames' = e(b)
		mat `bnames' = `bnames'[1,1..colsof(`bnames')-1]
		loc x : colnames `bnames'
		loc varlist "`y' `x'" 
		loc if = "if e(sample)"
		}

	if ("`varlist'"=="" & "`e(model)'"!="ols" & "`e(model)'"!="re") {
		error 301
		}

	if "`if'"!="" {
		preserve
		qui keep `if' 
		_xtsktest_bsestimation `varlist', b(`reps') mode(`standard') 
		restore
		}

	if "`if'"=="" {
		_xtsktest_bsestimation `varlist', b(`reps') mode(`standard')   
		}

	tempname b se pv joint xtsk

	mat `b'  = e(b)
	mat `se' = e(se)
	mat `pv' = [2*(1-normal(`b'[1,1]/`se'[1,1])) , 2*(1-normal(`b'[1,2]/`se'[1,2])) , 2*(1-normal(`b'[1,3]/`se'[1,3])) , 2*(1-normal(`b'[1,4]/`se'[1,4]))]

	loc chi2_nu = (`b'[1,1]/`se'[1,1])^2 + (`b'[1,2]/`se'[1,2])^2
	loc chi2_mu = (`b'[1,3]/`se'[1,3])^2 + (`b'[1,4]/`se'[1,4])^2
	
	loc pv_nu = 1-chi2(2,`chi2_nu')
	loc pv_mu = 1-chi2(2,`chi2_mu')

	di as text "Joint test for Normality on e:" _col(39) "chi2(2) = " as result %6.2f `chi2_nu' as text _col(59) "Prob > chi2 = " as result %5.4f `pv_nu'
	di as text "Joint test for Normality on u:" _col(39) "chi2(2) = " as result %6.2f `chi2_mu' as text _col(59) "Prob > chi2 = " as result %5.4f `pv_mu'
	
	_xtsktest_addline
	if "`standard'"!="" di in gr "Note: standardized coefficients"

	mat `xtsk' = [ e(b)', e(se)', `pv'']
	
	mat colnames `xtsk' = "Coef" "Std Err" "p-value"
	
	mat `joint' = [`chi2_nu',`pv_nu']\[`chi2_mu',`pv_mu']
	mat colnames `joint' = "chi2" "p-value"
	mat rownames `joint' = "e" "u"

	ereturn clear
	
	eret mat joint_test = `joint'
	eret mat xtsk_test = `xtsk'

end


capture program drop _xtsktest_addline
program _xtsktest_addline

        tempname mytab
        .`mytab' = ._tab.new, col(1) lmargin(0)
        .`mytab'.width    78
        .`mytab'.sep, bottom

end


capture program drop  _xtsktest_bsestimation
program define  _xtsktest_bsestimation

	syntax varlist(min=1), [B(integer 50) MODE(string)] 

	qui xtset
	loc panel = r(panelvar)
	loc time  = r(timevar)

	tempvar id
	
	if "`mode'"=="" {
		bootstrap Skewness_e=r(nuhat3) Kurtosis_e=r(nuhat4) Skewness_u=r(muhat3) Kurtosis_u=r(muhat4) ,	/*
			*/ reps(`b') cluster(`panel') idcluster(`id') group(`time')				/*
			*/ nolegend title(Tests for skewness and kurtosis)					/*
			*/ : _xtsktest_calculations `varlist' 
		}

	if "`mode'"!="" {
		bootstrap Skewness_e=r(nuhat3) Kurtosis_e=r(nuhat4) Skewness_u=r(muhat3) Kurtosis_u=r(muhat4) ,	/*
			*/ reps(`b') cluster(`panel') idcluster(`id') group(`time')				/*
			*/ nolegend title(Tests for skewness and kurtosis)					/*
			*/ : _xtsktest_calculations `varlist', `mode' 
		}


end

