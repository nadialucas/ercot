clear all
cd 
set more off
set scheme tufte
global directory = "/Users/nadialucas/Documents/EPIC/2018/nsf_ercot/ercot_lmps"
cd $directory
local lmpdata    : dir . files "*.csv"

gen hi = 1
tempfile hello
save "`hello'"
foreach file in `lmpdata' {
	
	di "`file'"
	insheet using `file', clear
	append using "`hello'"
	save "`hello'", replace
	
}


gen date_obj = clock(date, "MDYhms")
format date_obj %tc

gen day = date(date, "MDYhms")
gen hour = hh(date_obj)
format day %td
gen Year = year(day)
gen Month = month(day)
egen price_by_day = mean(price), by(day zone)
egen ptag = tag(zone day)
egen ymtag = tag(zone Year Month)
egen price_by_month = mean(price), by(Year Month zone)
egen price_by_year = mean(price), by(Year zone)
keep if day < date("2014", "Y") & day > date("2011", "Y")
egen price_by_hour = mean(price), by(hour zone)
egen hourtag = tag(zone hour)

twoway(line price_by_day day if zone == "LZ_HOUSTON" & ymtag==1, lcolor(blue) ///
	lwidth(medthick) sort yaxis(1)) ///
	(line price_by_day day if zone == "LZ_AEN" & ymtag==1, lcolor(red) ///
	lwidth(medthick) sort yaxis(1)) ///
	(line price_by_day day if zone == "LZ_RAYBN" & ymtag==1, lcolor(yellow) ///
	lwidth(medthick) sort yaxis(1)) ///
	(line price_by_day day if zone == "LZ_SOUTH" & ymtag==1, lcolor(purple) ///
	lwidth(medthick) sort yaxis(1)) ///
	(line price_by_day day if zone == "LZ_CPS" & ymtag==1, lcolor(pink) ///
	lwidth(medthick) sort yaxis(1)) ///
	(line price_by_day day if zone == "LZ_NORTH" & ymtag==1, lcolor(orange) ///
	lwidth(medthick) sort yaxis(1)) ///
	(line price_by_day day if zone == "LZ_LCRA" & ymtag==1, lcolor(brown) ///
	lwidth(medthick) sort yaxis(1)) ///
	(line price_by_day day if zone=="LZ_WEST" & ymtag == 1, lcolor(green) lwidth(medthick) yaxis(1) sort ///
	title("LMPs in Texas"))
	
	
twoway(line price_by_hour hour if zone == "LZ_HOUSTON" & hourtag==1, lcolor(blue) ///
	lwidth(medthick) sort yaxis(1)) ///
	(line price_by_hour hour if zone == "LZ_AEN" & hourtag==1, lcolor(red) ///
	lwidth(medthick) sort yaxis(1)) ///
	(line price_by_hour hour if zone == "LZ_RAYBN" & hourtag==1, lcolor(yellow) ///
	lwidth(medthick) sort yaxis(1)) ///
	(line price_by_hour hour if zone == "LZ_SOUTH" & hourtag==1, lcolor(purple) ///
	lwidth(medthick) sort yaxis(1)) ///
	(line price_by_hour hour if zone == "LZ_CPS" & hourtag==1, lcolor(pink) ///
	lwidth(medthick) sort yaxis(1)) ///
	(line price_by_hour hour if zone == "LZ_NORTH" & hourtag==1, lcolor(orange) ///
	lwidth(medthick) sort yaxis(1)) ///
	(line price_by_hour hour if zone == "LZ_LCRA" & hourtag==1, lcolor(brown) ///
	lwidth(medthick) sort yaxis(1)) ///
	(line price_by_hour hour if zone=="LZ_WEST" & hourtag == 1, lcolor(green) lwidth(medthick) yaxis(1) sort ///
	title("LMPs in Texas 2011-2014") legend(order(8 "WEST LZ")))
	//legend(label(1 "HOUSTON") label(2 "AEN") label(3 "RAYBN") label(4 "SOUTH") ///
	//label(5 "CPS") label(6 "NORTH") label(7 "LCRA") label(8 "WEST")))
	
gr export "/Users/nadialucas/Documents/EPIC/2018/nsf_ercot/lmp_curve1.pdf", replace
	
keep if hourtag==1
egen avg_otherzones = mean(price_by_hour) if zone!="LZ_WEST", by(hour)
keep price_by_hour avg_otherzones zone hour
sort hour zone
keep if zone=="LZ_HOUSTON" | zone=="LZ_WEST"
gen j=1 if zone=="LZ_HOUSTON"
replace j=2 if zone=="LZ_WEST"
drop zone
reshape wide price_by_hour avg_otherzones, i(hour) j(j) 

drop avg_otherzones2

ren price_by_hour2 price_by_hour_lzwest
gen hollaaaa = price_by_hour_lzwest-avg_otherzones1
gen percenty = (price_by_hour_lzwest-avg_otherzones1)/avg_otherzones1

keep if hour <=5 | hour >=20
egen meany = mean(hollaaaa)
egen percentmean = mean(percenty)
