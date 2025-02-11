;================================================;
; Some useful routines and constants
;================================================;

DEBUG = False

; put time to any output for benchmarking
procedure _log(s:string)
local ss,ch
begin
  ss = systemfunc("date +%T'.'%N")
  ch = stringtochar(ss)
  ss = chartostring(ch(0:7)) ; seconds s
  print(ss+" "+s)
end

; debugging
procedure _debug(s:string)
begin
  if DEBUG then
  	print(""+s)
  end if
end

START=0.
START_STR=""

function _seconds_to_timestr(sec:float)
local str,h,m,s,n
begin
  n = floattointeger(sec)
  h = n/3600
  m = n/60 - h*60
  s = n%60
  str = ""
  if h.gt.0 then
    if h.eq.1 then
      str = str+h+" hour "
    else
      str = str+h+" hours "
    end if
  end if
  if m.gt.0 then
    if m.eq.1 then
      str = str+m+" minute "
    else
      str = str+m+" minutes "
    end if
  end if
  str = str+s+" seconds"
  return str
end

procedure _log_start()
local ss,ch,h,m,s
begin
  ss = systemfunc("date +%T'.'%N")
  ch = stringtochar(ss)
  ss = chartostring(ch(0:9))
START_STR = chartostring(ch(0:7))
  h = stringtointeger(chartostring(ch(0:1)))
  m = stringtointeger(chartostring(ch(3:4)))
  s = stringtofloat(chartostring(ch(6:9)))
  START = s+60*(m+60*h)
  _log("start")
end

procedure _log_finish()
local ss,ch,h,m,s,FINISH
begin
  print(START_STR+" start")
  ss = systemfunc("date +%T'.'%N")
  ch = stringtochar(ss)
  ss = chartostring(ch(0:9))
  h = stringtointeger(chartostring(ch(0:1)))
  m = stringtointeger(chartostring(ch(3:4)))
  s = stringtofloat(chartostring(ch(6:9)))
;  s = stringtofloat(chartostring(ch(6:9)))
  FINISH = s+60*(m+60*h)
  _log("finish")
  print("Elapsed time: "+_seconds_to_timestr(FINISH-START))
end

_log_start

;================================================;
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
;================================================;

setfileoption("bin","ReadByteOrder" ,"LittleEndian")   ; all data files
setfileoption("bin","WriteByteOrder","LittleEndian")   ; all data files

setfileoption("nc","MissingToFillValue",False)

LBR = chartostring(inttochar((/10,0/)))  ; line break
TAB = chartostring(inttochar((/ 9,0/)))  ; tabulation
Q = inttochar(34)
BR = LBR

months_full   = (/"January","February","March","April","May","June","July", \
                  "August","September", "October","November","December"/)
months_MMM    = (/"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep", "Oct","Nov","Dec"/)
months_mmm    = (/"jan","feb","mar","apr","may","jun","jul","aug","sep", "oct","nov","dec"/)
months_M      = (/"J",  "F",  "M",  "A",  "M",  "J",  "J",  "A",  "S",   "O",  "N",  "D"/)
month_days    =  (/31.,28.,31.,30.,31.,30.,31.,31.,30.,31.,30.,31./)
month_days366 =  (/31.,29.,31.,30.,31.,30.,31.,31.,30.,31.,30.,31./)
month_nums    =  (/ 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11 /)

pi            = 3.14159d
degree2radian = pi/180.
mile          = 1852.2d    ; nautic mile in meters
degree2meter  = 60.*mile
degree2km     = 0.001*degree2meter

;==============================

time_units    = "days after 1999-12-31 00:00:00"

today_YYYYMMDD = systemfunc("date +%Y%m%d")
today_yyyymmdd = stringtointeger(today_YYYYMMDD)
today_year     = today_yyyymmdd/10000
today_month    = today_yyyymmdd/100%100
today_day      = today_yyyymmdd%100
today_weekday  = day_of_week(today_year,today_month,today_day) ; "3" means wednesday
today_julian   = ut_inv_calendar(today_year,today_month,today_day,0,0,0,time_units,0)

if today_weekday.ge.2 then
  last_tuesday_julian = today_julian-today_weekday+2   ; from Tuesday to Sunday
else
  last_tuesday_julian = today_julian-today_weekday-5   ; Monday
end if


if today_weekday.ge.3 then
  last_wednesday_julian = today_julian-today_weekday+2 ; from Wednesday to Sunday
else
  last_wednesday_julian = today_julian-today_weekday-5 ; from Monday to Tuesday
end if

;==============================

; integer y,m,d -> double julian day
function _get_julian_y_m_d(y:integer, m:integer, d:integer)
begin
  return ut_inv_calendar(y,m,d,0,0,0,time_units,0)
end

;==============================

; integer yyyymmdd -> double julian day
function _get_julian_yyyymmdd(yyyymmdd:integer)
local y, m, d, z
begin
  z = yyyymmdd
  z = 0
  d =  yyyymmdd % 100
  m = (yyyymmdd % 10000 - d) / 100
  y = (yyyymmdd - 100*m - d) / 10000
  return ut_inv_calendar(y,m,d,z,z,z,time_units,0)
end

;==============================

; string YYYYMMDD -> double julian day
function _get_julian_YYYYMMDD(YYYYMMDD:string)
begin
  return _get_julian_yyyymmdd(stringtointeger(YYYYMMDD))
end
;==============================

; integer yyyymmdd -> double julian day
function _yyyymmdd2julian(yyyymmdd:integer)
local y, m, d, z
begin
	z = yyyymmdd
  z = 0
  d =  yyyymmdd % 100
  m = (yyyymmdd % 10000 - d) / 100
  y = (yyyymmdd - 100*m - d) / 10000
  return ut_inv_calendar(y,m,d,z,z,z,time_units,0)
end

;==============================

; double julian -> integer yyyymmdd
function _julian2yyyymmdd(jul:double)
local j
begin
  j = jul
  j@units = time_units
  return ut_calendar(j, -2)
end

;==============================

; double julian -> string DDMMYYYY
function _julian2DDMMYYYY(jul:double)
local z, y, m, d
begin
  z = _julian2yyyymmdd(jul)
  y =  z / 10000
  m = (z % 10000) / 100
  d =  z % 100
  return sprinti("%0.2i",d)+"/"+sprinti("%0.2i",m)+"/"+y
end

;==============================

; double julian -> string DDMMM
function _julian2DDMMM(jul:double)
local z, m, d
begin
  z = _julian2yyyymmdd(jul)
  m = (z % 10000) / 100
  d =  z % 100
  return sprinti("%0.2i",d)+"-"+months_MMM(m)
end

;==============================

; double julian -> string DDMM
function _julian2DDMM(jul:double)
local z, m, d
begin
  z = _julian2yyyymmdd(jul)
  m = (z % 10000) / 100
  d =  z % 100
  return sprinti("%0.2i",d)+"/"+ sprinti("%0.2i",m)
end

;==============================

; double julian -> string YYMMDD
function _julian2YYMMDD(jul:double)
local i
begin
  i = _julian2yyyymmdd(jul)
  if i.gt.20000000 then
    i = i - 20000000
  else
    i = i - 19000000
  end if
  return sprinti("%0.6i", i)
end

;==============================

procedure _abort(str:string)
begin
  _log("ERROR: "+str)
  _log_finish
  exit
end

procedure _check(true:logical,comment:string)
begin
  if .not.true then
    _abort(comment)
  end if
end

procedure _check_file_exists(fn:string)
begin
  _check(isfilepresent(fn),"no file: "+fn)
end

procedure _check_dir_exists(dirname:string)
begin
  if .not.isfilepresent(dirname) then
    system("mkdir "+dirname)
    print("directory created: "+dirname)
  end if
  _check_file_exists(dirname)
end

;==============================

procedure _get_scale(data:numeric,pa:float,pb:float,nstep:integer,a:float,b:float,spacing:float,stride:integer)
local v,q,k,n,va,vb,r,l10,flr,step
begin
  v = ndtooned(data)
  v = where(ismissing(v),1e20,v)
  qsort(v)
  v = where(v.eq.1e20,v@_FillValue,v)
  n = num(.not.ismissing(v))
  k = round(pa*n,3)
  va = v(k)
  k = round(pb*n,3)
  vb = v(k)
  delete(v)
  r = (vb-va)/nstep
  l10 = log(10.)
  lr = log10(r)
  flr = floor(lr)
  lr = lr-flr
  flr = exp(flr*l10)
  stride = 5
  if lr.gt.0.8 then
    spacing = flr*10.
  else
  if lr.gt.0.5 then
    spacing = flr*5.
    stride = 4
  else
  if lr.gt.0.15 then
    spacing = flr*2.
  else
    spacing = flr
  end if
  end if
  end if
  step = spacing*stride
  a = step*floor(va/step)
  b = step*ceil(vb/step)
end

;==============================

function whoi_z2p(z : numeric, lat : numeric)
local PLAT, D, C1, p
;; http:;;ecco2.jpl.nasa.gov/data1/matlab/whoi/pressure.m
;; Computes pressure given the depth at some latitude
;; P=PRESSURE(D,LAT) gives the pressure P (dbars) at a depth D (m)
;; at some latitude LAT (degrees).
;; This probably works best in mid-latitude oceans, if anywhere!
;; Ref: Saunders, "Practical Conversion of Pressure to Depth",
;;      J. Phys. Oceanog., April 1981.
;; Notes: RP (WHOI) 2/Dec/91
;; I copied this directly from the UNESCO algorithms
begin
  PLAT = abs(lat*3.14159/180)
  D = sin(PLAT)
  C1 = 5.92E-3+(D*D)*5.25E-3
  p = ((1-C1)-sqrt(((1-C1)*(1-C1))-(8.84E-6*z)))/4.42E-6
  return p
end

;==============================

function whoi_rho(S : numeric, T : numeric, PP : numeric)
local SR, x, V350P, B, P
;; http:;;ecco2.jpl.nasa.gov/data1/matlab/whoi/rho.m
;; density of seawater (kg/m^3)
;; given the salinity S (ppt), in situ temperature T (deg C)
;; and pressure P (dbars).
;; Note: D. Menemenlis (MIT 18 jul 94)
begin
;; CONVERT PRESSURE TO BARS AND TAKE SQUARE ROOT SALINITY.
      P = PP/10.
      SR = sqrt(abs(S));

;;  INTERNATIONAL ONE-ATMOSPHERE EQUATION OF STATE OF SEAWATER
      x = (4.8314E-4 * S + \
          ((-1.6546E-6*T+1.0227E-4)*T-5.72466E-3) * SR + \
          (((5.3875E-9*T-8.2467E-7)*T+7.6438E-5)*T-4.0899E-3)*T+8.24493E-1) \
          *S + ((((6.536332E-9*T-1.120083E-6)*T+1.001685E-4)*T \
                        -9.095290E-3)*T+6.793952E-2)*T-28.263737

;; SPECIFIC VOLUME AT ATMOSPHERIC PRESSURE
      V350P = 1.0/1028.1063
      x = -x*V350P/(1028.1063+x)

;; COMPUTE COMPRESSION TERMS
      SR = ((((9.1697E-10*T+2.0816E-8)*T-9.9348E-7) * S + \
          (5.2787E-8*T-6.12293E-6)*T+3.47718E-5) *P + \
          (1.91075E-4 * SR + (-1.6078E-6*T-1.0981E-5)*T+2.2838E-3) * \
          S + ((-5.77905E-7*T+1.16092E-4)*T+1.43713E-3)*T-0.1194975) \
          *P + (((-5.3009E-4*T+1.6483E-2)*T+7.944E-2) * SR + \
          ((-6.1670E-5*T+1.09987E-2)*T-0.603459)*T+54.6746) * S + \
          (((-5.155288E-5*T+1.360477E-2)*T-2.327105)*T+148.4206)*T-1930.06

;; EVALUATE PRESSURE POLYNOMIAL
      B  = (5.03217E-5*P+3.359406)*P+21582.27
      x = x*(1.0 - P/B) + (V350P+x)*P*SR/(B*(B+SR))
      SR = V350P*(1.0 - P/B)
      x = 1028.106331 + P/B/SR - x / (SR*(SR+x))
  return x
end
