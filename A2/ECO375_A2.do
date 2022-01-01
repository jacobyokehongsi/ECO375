cd "D:\UofT\Y2 Winter\ECO375\A2"
cap log close _all
log using "ECO375_A2.log", replace
set more off
clear
use "daAssignment2.dta", clear
datasignature

*Table 1
summarize fhpolrigaug lrgdpch nsave laborshare age_veryyoung age_young age_midage age_old age_veryold medage education lpop polity4 socialist colony year

twoway (scatter fhpolrigaug lrgdpch, mlcolor(gs8) mfcolor(gs8) msize(0.01in)) (lfit fhpolrigaug lrgdpch, lpattern(solid) lwidth(0.01in)), title(Relationship between real GDP per capita and Political Freedom, size(12pt)) ytitle(Augmented Freedom House Political Rights Index) xtitle(Log real GDP per capita)

twoway (scatter education lrgdpch, mlcolor(gs8) mfcolor(gs8) msize(0.01in)) (lfit education lrgdpch, lpattern(solid) lwidth(0.01in)), title(Relationship between Education and real GDP per capita, size(12pt)) ytitle(Education) xtitle(Real GDP per Capita)

twoway (scatter education colony, mlcolor(gs8) mfcolor(gs8) msize(0.01in)) (lfit education colony, lpattern(solid) lwidth(0.01in)), title(Relationship between Education and Colonies, size(12pt)) ytitle(Education) xtitle(Colonies)


*DO THE TABLE 2 SPECIFICATIONS

// 1.
reg fhpolrigaug L1.lrgdpch, robust
estimates store s1

// 2.
reg fhpolrigaug L1.lrgdpch, vce(cluster code_numeric)
estimates store s2

// 3.
reg fhpolrigaug L1.lrgdpch i.code_numeric, vce(cluster code_numeric)
estimates store s3

// 4.
areg fhpolrigaug L1.lrgdpch i.code_numeric, absorb(year_numeric) vce(cluster code_numeric)
estimates store s4

// year fixed effects
reg fhpolrigaug L1.lrgdpch i.code_numeric i.year_numeric
reg fhpolrigaug L1.lrgdpch i.code_numeric

di (36.2635059-32.295602)/1
di 32.295602/866
di 3.9679039/.03729284 // f-stat = 106.39854
di Ftail(1, 866, 106.39854) // p-value = 1.313e-23

// 5.
areg fhpolrigaug L1.lrgdpch L1.age_young L1.age_midage L1.age_old L1.age_veryold L1.education L1.lpop i.code_numeric, absorb(year_numeric) cluster(code_numeric)
gen demo_sample=(e(sample)==1)
areg fhpolrigaug L1.lrgdpch i.code_numeric if demo_sample==1, absorb(year_numeric) vce(cluster code_numeric)
estimates store s5

// year fixed effects

reg fhpolrigaug L1.lrgdpch i.code_numeric i.year_numeric if demo_sample==1
reg fhpolrigaug L1.lrgdpch i.code_numeric if demo_sample==1

di (((25.6920214-23.258915)/1)/(23.258915/583)) // f-stat = 60.987412
di Ftail(1, 583, 60.987412) // p-value = 2.682e-14

// 6.
areg fhpolrigaug L1.lrgdpch i.code_numeric L1.age_young L1.age_midage L1.age_old L1.age_veryold L1.education L1.lpop, absorb(year_numeric) cluster(code_numeric)
estimates store s6
//
// year fixed effects
reg fhpolrigaug L1.lrgdpch i.code_numeric L1.age_young L1.age_midage L1.age_old L1.age_veryold L1.education L1.lpop i.year_numeric
reg fhpolrigaug L1.lrgdpch i.code_numeric L1.age_young L1.age_midage L1.age_old L1.age_veryold L1.education L1.lpop

di (((24.4398402-22.4576371)/1)/(22.4576371/577)) // f-stat = 50.928385
di Ftail(1, 577, 50.928385) // p-value = 2.889e-12


// age controls
reg fhpolrigaug L1.lrgdpch i.code_numeric L1.age_young L1.age_midage L1.age_old L1.age_veryold L1.education L1.lpop i.year_numeric
reg fhpolrigaug L1.lrgdpch i.code_numeric L1.education L1.lpop i.year_numeric

di (((32.295602-22.4576371)/4)/(22.4576371/577)) // f-stat = 4.3295226
di Ftail(4, 577, 4.3295226) // p-value = .00185436


// demographic controls
reg fhpolrigaug L1.lrgdpch i.code_numeric L1.age_young L1.age_midage L1.age_old L1.age_veryold L1.education L1.lpop i.year_numeric
reg fhpolrigaug L1.lrgdpch i.code_numeric i.year_numeric

di (((32.295602-22.4576371)/6)/(22.4576371/577)) // f-stat = 42.127508
di Ftail(6, 577, 42.127508) // p-value = 1.199e-42

//
// esttab s1 s2 s3 s4 s5 s6 using "base_spec.rtf", se drop(*.code_numeric _cons) replace mtitles("estimate" "estimate" "estimate" "estimate" "estimate" "estimate") stats(N, labels("Number of Obs.")) compress

*EXTENSION

// gen income_education = lrgdpch*education
gen income_saving = lrgdpch*nsave
gen income_saving_test = lrgdpch*(nsave-(-0.01623))

gen income_socialist = lrgdpch*socialist
gen income_socialist_test = lrgdpch*(socialist-(-0.14445))


areg fhpolrigaug L1.lrgdpch L1.nsave L1.education L1.income_saving i.code_numeric L1.age_young L1.age_midage L1.age_old L1.age_veryold  L1.lpop, absorb(year_numeric) cluster(code_numeric)
estimates store es1

areg fhpolrigaug L1.lrgdpch L1.nsave L1.education L1.income_saving_test i.code_numeric L1.age_young L1.age_midage L1.age_old L1.age_veryold  L1.lpop, absorb(year_numeric) cluster(code_numeric)

areg fhpolrigaug L1.lrgdpch L1.socialist L1.education L1.income_socialist i.code_numeric L1.age_young L1.age_midage L1.age_old L1.age_veryold  L1.lpop, absorb(year_numeric) cluster(code_numeric)
estimates store es2

areg fhpolrigaug L1.lrgdpch L1.socialist L1.education L1.income_socialist_test i.code_numeric L1.age_young L1.age_midage L1.age_old L1.age_veryold  L1.lpop, absorb(year_numeric) cluster(code_numeric)



log close