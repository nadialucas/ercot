cd
clear all
set more off

set scheme s2color

insheet using "/Users/nadialucas/Documents/EPIC/2018/nsf_ercot/settlement_prices_20180813_160019.csv", clear

split settlementpoint, p("_")
drop settlementpoint3 settlementpoint4
*duplicates drop lmp settlementpoint1 settlementpoint2, force
duplicates tag settlementpoint1 settlementpoint2, gen(duptag)

tempfile lmp_prices
save "`lmp_prices'"

insheet using "/Users/nadialucas/Documents/EPIC/2018/nsf_ercot/60d_SCED_Gen_Resource_Data-13-AUG-18.csv", clear
split resourcename, p("_")
gen tag_hi= 0
replace tag_hi = 1 if resourcename1 == "AMOCOOIL"
replace tag_hi = 2 if resourcename1 == "BAC"
replace tag_hi = 3 if resourcename1 == "BYU"
replace tag_hi = 4 if resourcename1 == "DDPEC"
replace tag_hi = 5 if resourcename1 == "MIRAGE"
replace tag_hi = 6 if resourcename1 == "SJS"
replace tag_hi = 7 if resourcename1 == "TXCTY"
replace tag_hi = 8 if resourcename1 == "UCC"

drop resourcename1 resourcename2 resourcename3 resourcename4 resourcename5


*keep if scedtimestamp=="05/28/2018 13:00:15"
*keep if scedtimestamp=="05/28/2018 16:00:13"
keep if scedtimestamp=="06/14/2018 16:00:13"

reshape long sced1curvemw sced1curveprice sced2curvemw sced2curveprice, i(resourcename) j(number)

expand sced1curvemw
sort sced1curveprice sced1curvemw
gen sort = _n

#delimit ;
graph twoway
  (bar sced1curveprice sort if resourcetype=="DSL")
  (bar sced1curveprice sort if resourcetype=="SCLE90")
  (bar sced1curveprice sort if resourcetype=="CCGT90")
  (bar sced1curveprice sort if resourcetype=="HYDRO")
  (bar sced1curveprice sort if resourcetype=="WIND")
  (bar sced1curveprice sort if resourcetype=="CCLE90")
  (bar sced1curveprice sort if resourcetype=="CLLIG")
  (bar sced1curveprice sort if resourcetype=="GSREH")
  (bar sced1curveprice sort if resourcetype=="GSSUP")
  (bar sced1curveprice sort if resourcetype=="GSNONR")
  (bar sced1curveprice sort if resourcetype=="NUC")
  (bar sced1curveprice sort if resourcetype=="PVGR")
  (bar sced1curveprice sort if resourcetype=="PWRSTR")
  (bar sced1curveprice sort if resourcetype=="RENEW")
  (bar sced1curveprice sort if resourcetype=="SCGT90"),
  xtitle("Capacity")
  ytitle("")
  legend(label(1 "DSL") label(2 "SCLE90") label(3 "CCGT90")
    label(4 "HYDRO") label(5 "WIND") row(3) label(6 "CCLE90")
	label(7 "CCLIG") label(8 "GSREH")
	label(9 "GSSUP") label(10 "GSNONR") label(11 "NUC")
	label(12 "PVGR") label(13 "PWRSTR") label(14 "RENEW")
	label(15 "SCGT90"))
;
#delimit cr
graph export "/Users/nadialucas/Documents/EPIC/2018/nsf_ercot/full_merit_curve.pdf", replace


drop if sced1curveprice<0

tempfile tagged_4pm
save "`tagged_4pm'" 
forval i =1/8 {
use `tagged_4pm',clear

keep if tag_hi==`i'
#delimit ;
graph twoway
  (bar sced1curveprice sort if resourcetype=="DSL")
  (bar sced1curveprice sort if resourcetype=="SCLE90")
  (bar sced1curveprice sort if resourcetype=="CCGT90")
  (bar sced1curveprice sort if resourcetype=="HYDRO")
  (bar sced1curveprice sort if resourcetype=="WIND")
  (bar sced1curveprice sort if resourcetype=="CCLE90")
  (bar sced1curveprice sort if resourcetype=="CLLIG")
  (bar sced1curveprice sort if resourcetype=="GSREH")
  (bar sced1curveprice sort if resourcetype=="GSSUP")
  (bar sced1curveprice sort if resourcetype=="GSNONR")
  (bar sced1curveprice sort if resourcetype=="NUC")
  (bar sced1curveprice sort if resourcetype=="PVGR")
  (bar sced1curveprice sort if resourcetype=="PWRSTR")
  (bar sced1curveprice sort if resourcetype=="RENEW")
  (bar sced1curveprice sort if resourcetype=="SCGT90"),
  xtitle("Capacity")
  ytitle("Marginal cost")
  legend(label(1 "DSL") label(2 "SCLE90") label(3 "CCGT90")
    label(4 "HYDRO") label(5 "WIND") row(3) label(6 "CCLE90")
	label(7 "CCLIG") label(8 "GSREH")
	label(9 "GSSUP") label(10 "GSNONR") label(11 "NUC")
	label(12 "PVGR") label(13 "PWRSTR") label(14 "RENEW")
	label(15 "SCGT90"))
;
#delimit cr

graph export "/Users/nadialucas/Documents/EPIC/2018/nsf_ercot/tag_hi`i'.pdf", replace

}
insheet using "/Users/nadialucas/Documents/EPIC/2018/nsf_ercot/60d_SCED_Gen_Resource_Data-13-AUG-18.csv", clear
split resourcename, p("_")
gen tag_lo= 0
replace tag_lo = 1 if resourcename1 == "AMOCOOIL"
replace tag_lo = 2 if resourcename1 == "BAC"
replace tag_lo = 3 if resourcename1 == "BYU"
replace tag_lo = 4 if resourcename1 == "DDPEC"
replace tag_lo = 5 if resourcename1 == "MIRAGE"
replace tag_lo = 6 if resourcename1 == "SJS"
replace tag_lo = 7 if resourcename1 == "TXCTY"
replace tag_lo = 8 if resourcename1 == "UCC"
drop resourcename1 resourcename2 resourcename3 resourcename4 resourcename5


*keep if scedtimestamp=="05/28/2018 13:00:15"
keep if scedtimestamp=="06/14/2018 05:00:12"
*keep if scedtimestamp=="05/28/2018 16:00:13"


reshape long sced1curvemw sced1curveprice sced2curvemw sced2curveprice, i(resourcename) j(number)

expand sced1curvemw
sort sced1curveprice sced1curvemw
gen sort = _n
drop if sced1curveprice<0

tempfile tagged_5am
save "`tagged_5am'" 
forval i =1/8 {
use `tagged_5am',clear
keep if tag_lo==`i'
#delimit ;
graph twoway
  (bar sced1curveprice sort if resourcetype=="DSL")
  (bar sced1curveprice sort if resourcetype=="SCLE90")
  (bar sced1curveprice sort if resourcetype=="CCGT90")
  (bar sced1curveprice sort if resourcetype=="HYDRO")
  (bar sced1curveprice sort if resourcetype=="WIND")
  (bar sced1curveprice sort if resourcetype=="CCLE90")
  (bar sced1curveprice sort if resourcetype=="CLLIG")
  (bar sced1curveprice sort if resourcetype=="GSREH")
  (bar sced1curveprice sort if resourcetype=="GSSUP")
  (bar sced1curveprice sort if resourcetype=="GSNONR")
  (bar sced1curveprice sort if resourcetype=="NUC")
  (bar sced1curveprice sort if resourcetype=="PVGR")
  (bar sced1curveprice sort if resourcetype=="PWRSTR")
  (bar sced1curveprice sort if resourcetype=="RENEW")
  (bar sced1curveprice sort if resourcetype=="SCGT90"),
  xtitle("Capacity")
  ytitle("Marginal cost")
  legend(label(1 "DSL") label(2 "SCLE90") label(3 "CCGT90")
    label(4 "HYDRO") label(5 "WIND") row(3) label(6 "CCLE90")
	label(7 "CCLIG") label(8 "GSREH")
	label(9 "GSSUP") label(10 "GSNONR") label(11 "NUC")
	label(12 "PVGR") label(13 "PWRSTR") label(14 "RENEW")
	label(15 "SCGT90"))
;
#delimit cr

graph export "/Users/nadialucas/Documents/EPIC/2018/nsf_ercot/tag_lo`i'.pdf", replace
}



