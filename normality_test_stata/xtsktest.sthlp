{smcl}
{* *! version 1  18jun2014}{...}
{hi:help xtsktest}{right: ({browse "http://www.stata-journal.com/article.html?article=st0406":SJ15-3: st0406})}
{hline}

{title:Title}

{p2colset 5 17 19 2}{...}
{p2col:{hi:xtsktest} {hline 2}}Tests for skewness and kurtosis in the one-way error-components model{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:xtsktest}
[{it:{varlist}}]
[{it:{help if}}]
[{cmd:,} {opt r:eps(#)} {opt s:eed(#)} {cmdab:stand:ard}]


{marker description}{...}
{title:Description}

{pstd}
In the one-way error-components model, y_it = x_it*b + u_i + e_it,
{cmd:xtsktest} tests for skewness, kurtosis, and normality of u_i and e_it.
{opt xtsktest} can be used as a standard command (which requires at least one
variable in the {it:varlist}) or as a postestimation command after an ordinary
least-squares or random-effects model ({it:varlist} is not required).


{marker option}{...}
{title:Options}

{phang}
{opt reps(#)} specifies the number of bootstrap replications.  The default is
{cmd:reps(50)}.

{phang}
{opt seed(#)} specifies the seed for the random-number generator in the
bootstrap procedure; see {helpb set seed}.

{phang}
{cmd:standard} specifies whether the skewness and kurtosis statistics are
standardized by the estimated variance.  The default is no standardization.


{marker examples}{...}
{title:Examples using {cmd:xtsktest} (standard command)}

{pstd}Setup{p_end}
{phang2}{cmd:. use investment}{p_end}
{phang2}{cmd:. xtset idcode time}{p_end}

{pstd}Test with default options{p_end}
{phang2}{cmd:. xtsktest investment tobinq cashflow}{p_end}

{pstd}Setting the number of replications of {cmd:xtsktest}{p_end}
{phang2}{cmd:. xtsktest investment tobinq cashflow, reps(500)}{p_end}

{pstd}Adding a seed number to pseudorandom-number generator{p_end}
{phang2}{cmd:. xtsktest investment tobinq cashflow, reps(500) seed(123)}{p_end}

{pstd}Standardized coefficients {p_end}
{phang2}{cmd:. xtsktest investment tobinq cashflow, reps(500) seed(123) standard}{p_end}


{title:Examples after ordinary least-squares estimation (postestimation command)}

{pstd}Setup{p_end}
{phang2}{cmd:. use investment}{p_end}
{phang2}{cmd:. xtset idcode time}{p_end}

{pstd}Test with default options{p_end}
{phang2}{cmd:. regress investment tobinq cashflow}{p_end}
{phang2}{cmd:. xtsktest}{p_end}

{pstd}Setting the number of replications of {cmd:xtsktest}{p_end}
{phang2}{cmd:. regress investment tobinq cashflow}{p_end}
{phang2}{cmd:. xtsktest, reps(500)}{p_end}

{pstd}Adding a seed number to pseudorandom-number generator{p_end}
{phang2}{cmd:. regress investment tobinq cashflow}{p_end}
{phang2}{cmd:. xtsktest, reps(500) seed(123)}{p_end}

{pstd}Standardized coefficients {p_end}
{phang2}{cmd:. regress investment tobinq cashflow}{p_end}
{phang2}{cmd:. xtsktest, reps(500) seed(123) standard}{p_end}


{title:Examples after random-effects estimation (postestimation command)}

{pstd}Setup{p_end}
{phang2}{cmd:. use investment}{p_end}
{phang2}{cmd:. xtset idcode time}{p_end}

{pstd}Test with default options{p_end}
{phang2}{cmd:. xtreg investment tobinq cashflow, re}{p_end}
{phang2}{cmd:. xtsktest}{p_end}

{pstd}Setting the number of replications of {cmd:xtsktest}{p_end}
{phang2}{cmd:. xtreg investment tobinq cashflow, re}{p_end}
{phang2}{cmd:. xtsktest, reps(500)}{p_end}

{pstd}Adding a seed number to pseudorandom-number generator{p_end}
{phang2}{cmd:. xtreg investment tobinq cashflow, re}{p_end}
{phang2}{cmd:. xtsktest, reps(500) seed(123)}{p_end}

{pstd}Standardized coefficients {p_end}
{phang2}{cmd:. xtreg investment tobinq cashflow, re}{p_end}
{phang2}{cmd:. xtsktest, reps(500) seed(123) standard}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xtsktest} stores the following in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(xtsk_test)}}matrix of test results, one row per statistic.  First column for point estimation, second column for standard error, and third column for p-values.{p_end}
{synopt:{cmd:e(joint_test)}}matrix of joint tests, one row per component of residuals.  First column for chi-squared statistics and second column for p-values.{p_end}
{p2colreset}{...}


{marker Authors}{...}
{title:Authors}

{pstd}Antonio Galvao{p_end}
{pstd}University of Iowa{p_end}
{pstd}Iowa City, IA{p_end}
{pstd}antonio-galvao@uiowa.edu{p_end}

{pstd}Gabriel Montes-Rojas{p_end}
{pstd}Universidad de San Andr{c e'}s-The National Scientific and Technical Research Council (CONICET){p_end}
{pstd}Victoria, Argentina{p_end}
{pstd}gmontesrojas@udesa.edu.ar{p_end}

{pstd}Walter Sosa-Escudero{p_end}
{pstd}Universidad de San Andr{c e'}s-CONICET{p_end}
{pstd}Victoria, Argentina{p_end}
{pstd}wsosa@udesa.edu.ar{p_end}

{pstd}Liang Wang{p_end}
{pstd}Department of Economics{p_end}
{pstd}University of Wisconsin-Milwaukee{p_end}
{pstd}Milwaukee, WI{p_end}
{pstd}wang42@uwm.edu{p_end}

{pstd}Javier Alejo{p_end}
{pstd}Center for Distributive, Labor and Social Sciences{p_end}
{pstd}Facultad de Ciencias Econ{c o'}micas{p_end}
{pstd}Universidad de La Plata-CONICET{p_end}
{pstd}La Plata, Argentina{p_end}
{pstd}javier.alejo@depeco.econo.unlp.edu.ar{p_end}


{title:Also see}

{p 4 14 2}Article:  {it:Stata Journal}, volume 15, number 3: {browse "http://www.stata-journal.com/article.html?article=st0406":st0406}

{p 7 14 2}Help:  {manhelp sktest R}, {manhelp mvtest MV}, {manhelp swilk R}
{p_end}
