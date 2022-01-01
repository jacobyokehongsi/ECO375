cd "D:\UofT\Y2 Winter\ECO375\A1"
cap log close _all
log using "ECO375_A1.log", replace
set more off
clear
use "Assignment01_Data.dta", clear
datasignature


twoway (scatter cases_log week, sort) (scatter lagvacc_per week, sort yaxis(2)) (lfit cases_log week) (lfit lagvacc_per week, yaxis(2)) if week>tw(2020w48), yscale(range(0 10)) ylabel(#10) title (COVID-19 Cases and Vaccination)

twoway (scatter cases_log age, sort xlabel(,valuelabel) msize(0.02in)), yscale(range(3 10)) ylabel(#10) title(COVID-19 Cases by Age Group, size(12pt))


summarize week age cases_rate cases_log lagvacc_per lagvacc_per2 lagvacc_0 lagvacc_0_10 lagvacc_10_20 lagvacc_20_100

count if lagvacc_0 == 1
count if lagvacc_0_10 == 1
count if lagvacc_10_20 == 1
count if lagvacc_20_100 == 1

reg cases_log lagvacc_per

reg cases_log lagvacc_per i.age i.week 

reg cases_log lagvacc_per lagvacc_per2 i.age i.week 

reg cases_log lagvacc_0_10 lagvacc_10_20 lagvacc_20_100 i.age i.week 

log close