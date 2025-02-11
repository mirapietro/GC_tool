FINAL = True

varZ = 0
varT = 1
varS = 2
varD = 3
varB = 4

legzmaxs = new(NLEG,double)
legzmaxs = (/100.,300.,300.,15./)

if FINAL then
legzmaxs = (/300.,300.,300.,15./)
end if

legvarmaxs = new((/NLEG,NVAR/),double)
legvarmins = new((/NLEG,NVAR/),double)

legvarmins(:,varT) = (/14,14,14,22.9/)
legvarmaxs(:,varT) = (/25,25,25,23.4/)

legvarmins(:,varS) = (/37.7,37.5,37.5,37.4/)
legvarmaxs(:,varS) = (/38.8,39.0,39.0,38.1/)

if FINAL then
legvarmins(:,varS) = (/37.5,37.5,37.5,37.4/)
legvarmaxs(:,varS) = (/39.0,39.0,39.0,38.1/)
end if

legvarmins(:,varD) = (/25.,25.,25.,25/)
legvarmaxs(:,varD) = (/30.,30.,30.,30/)

legvarmins(:,varB) = 0.
legvarmaxs(:,varB) = (/24.,18.,18.,18./)

; precision for mean profiles
varprecs = (/0,2,3,2,1/)
varprecs = (/0,2,3,0,0/)
vardiffprecs = (/0,2,3,1,0/)

; ranges for LS2-LS1
vardiffas = (/0.,-1.0,-0.15,-0.30,-5.0/)
vardiffbs = (/0., 1.0, 0.15, 0.30, 5.0/)

tsmins = (/37.5,37.5,37.5,37.5/)
tsmaxs = (/39.0,39.0,39.0,39.0/)
tsmint = (/13.0,13.0,13.0,13.0/)
tsmaxt = (/24.0,24.0,24.0,24.0/)

MEAN_PRF_DPI = 120
MEAN_PRF_MARGIN = 12

MAP_DPI = 160
MAP_MARGIN = 10


; MAPS

legmaplonas = new(NLEG,double)
legmaplonbs = new(NLEG,double)
legmaplatas = new(NLEG,double)
legmaplatbs = new(NLEG,double)
legmaprscans = new(NLEG,double)
legmapnxs = new(NLEG,integer)
legmapnys = new(NLEG,integer)

legmaplonas(legCS1) = 16.+50./60.
legmaplonbs(legCS1) = 17.+25./60.
legmaplatas(legCS1) = 40.+05./60.
legmaplatbs(legCS1) = 40.+35./60.
legmaprscans(legCS1) = 0.06

legmaplonas(legCS1) = 16.+52./60.
legmaplonbs(legCS1) = 17.+20./60.
legmaplatas(legCS1) = 40.+09./60.
legmaplatbs(legCS1) = 40.+31.5/60.
legmaprscans(legCS1) = 0.08

legmaplonas(legCS1) = 16.+50./60. ; better map
legmaplonbs(legCS1) = 17.+20./60.
legmaplatas(legCS1) = 40.+10./60.
legmaplatbs(legCS1) = 40.+33./60.
legmaprscans(legCS1) = 0.08

legmapnxs(legCS1) = 500
legmapnys(legCS1) = 500

legmaplonas(legLS1) = 16.+30./60.
legmaplonbs(legLS1) = 18.+00./60.
legmaplatas(legLS1) = 39.+30./60.
legmaplatbs(legLS1) = 40.+31./60.
legmaprscans(legLS1) = 0.30
legmapnxs(legLS1) = 500
legmapnys(legLS1) = 500

legmaplonas(legLS1) = 16.+25./60. ; better maps
legmaplonbs(legLS1) = 18.+00./60.
legmaplatas(legLS1) = 39.+30./60.
legmaplatbs(legLS1) = 40.+34./60.


legmaplonas(legLS2) = legmaplonas(legLS1)
legmaplonbs(legLS2) = legmaplonbs(legLS1)
legmaplatas(legLS2) = legmaplatas(legLS1)
legmaplatbs(legLS2) = legmaplatbs(legLS1)
legmaprscans(legLS2) = legmaprscans(legLS1)
legmapnxs(legLS2) = legmapnxs(legLS1)
legmapnys(legLS2) = legmapnys(legLS1)

legmaplonas(legMG1) = 17.+09./60.
legmaplonbs(legMG1) = 17.+15./60.
legmaplatas(legMG1) = 40.+25./60.
legmaplatbs(legMG1) = 40.+29./60.
legmaprscans(legMG1) = 0.010
legmapnxs(legMG1) = 500
legmapnys(legMG1) = 500

oalonas = legmaplonas
oalonbs = legmaplonbs
oalatas = legmaplatas
oalatbs = legmaplatbs
oanxs = legmapnxs
oanys = legmapnys
oarscans = (/0.06,0.08,0.08,0.01/)
oarscans = (/15,40,40,3/)/(1.852*60) ; km -> degree
;print(oarscans)
;exit

delta = 1./32.
preciplona = 16+ 9/16.+delta+1./16
preciplonb = 17+14/16.-delta+1./16
preciplata = 39+ 8/16.+delta
preciplatb = 40+ 9/16.-delta



;!!!!!
legmapnxs = 100
legmapnys = 100



function _get_map_res(leg:integer)
local res
begin
	res = True
	res@gsnDraw             = False       ; don't draw yet
	res@gsnFrame            = False       ; don't advance frame yet
	res@gsnAddCyclic = False
	res@mpProjection = "Mercator"
	res@mpLimitMode = "LatLon"
	res@mpMinLonF = legmaplonas(leg)
	res@mpMaxLonF = legmaplonbs(leg)
	res@mpMinLatF = legmaplatas(leg)
	res@mpMaxLatF = legmaplatbs(leg)
	res@mpDataBaseVersion = "HighRes" ; "HighRes"
	res@mpDataResolution  = "Finest"  ; "Medium" ;
	res@mpFillDrawOrder  = "PostDraw" ;
	res@pmTickMarkDisplayMode = "Always"  ; turn on tickmarks
	res@gsnRightString          = legnames(leg)
	res@gsnLeftStringFontHeightF = 0.018
	res@gsnRightStringFontHeightF = 0.024
;	res@pmLabelBarHeightF = 0.07
;	res@pmLabelBarOrthogonalPosF = 0.03
	res@tmXBLabelFontHeightF = 0.012
	res@tmYLLabelFontHeightF = 0.012
;	res@cnFillOn    = True

	return res
end

function get_xy_res()
begin
  res = True

  if FINAL then
  	res@tiYAxisString = " Depth (m)"
  	res@tiYAxisFontHeightF = 0.010
  end if

	res@gsnDraw            = False                   ; don't draw
	res@gsnFrame           = False                   ; don't advance frame

  res@vpWidthF  = 0.5
  res@vpHeightF = 0.7

  res@trYReverse = True
  res@trYMinF    = 0.d
;;;;;  res@trYMaxF    = plot_z_max

;;;;;  res@trXMinF    = var_mins(var)
;;;;;  res@trXMaxF    = var_maxs(var)

  res@tiXAxisSide  = "Top"
;;;  res@tiYAxisString = "Profondita, m"

  res@tmXBOn = False
  res@tmXTLabelsOn = True
  res@tmXTLabelDeltaF = 0;;-0.1

  res@tiXAxisFontHeightF = 0.024
  res@tiYAxisFontHeightF = 0.024

  res@gsnRightStringFontHeightF  = 0.022
  res@gsnLeftStringFontHeightF   = 0.022
  res@gsnCenterStringFontHeightF = 0.022

  res@gsnRightStringOrthogonalPosF  = 0.090
  res@gsnLeftStringOrthogonalPosF   = 0.090
  res@gsnCenterStringOrthogonalPosF = 0.02

;  res@gsnRightString  = DDMMYYYY
;  res@gsnLeftString   = location
;  res@gsnCenterString = var_names(var)

  res@xyMarkLineMode   = "MarkLines"
  res@xyMarker         =  16
  res@xyMarkerSizeF    =   0.008
;  res@xyLineColors     = var_colors(var)
;  res@xyMarkerColors   = var_colors(var)
  res@xyLineThicknessF= 3.0
  res@xyDashPatterns   = 0

  res@tmXMajorGrid  = True
  res@tmXMinorGrid  = False
  res@tmYMajorGrid  = True
  res@tmYMinorGrid  = False
  res@tmXMajorGridThicknessF = 0.2
  res@tmXMinorGridThicknessF = 0.05
  res@tmYMajorGridThicknessF = 0.2
  res@tmYMinorGridThicknessF = 0.05

  res@tmYLMajorLengthF = 0.008
  res@tmYLMinorLengthF = 0.005
  res@tmYLMajorOutwardLengthF = 0.008
  res@tmYLMinorOutwardLengthF = 0.005

  res@tmXTLabelFontHeightF = 0.018
  res@tmXBLabelFontHeightF = 0.018
  res@tmYLLabelFontHeightF = 0.018

  return res
end

procedure _plot_ts(fn:string,ileg:integer,vts:double,vss:double)
local res,wks,plot
begin
	res = get_xy_res()
  res@vpHeightF = 0.5
  res@trYReverse = False
    res@tiXAxisSide  = "Top"
;;;  res@tiYAxisString = "Profondita, m"
  res@tmXBOn = True
  res@tmXBLabelsOn = True
  res@tmXTOn = False
  res@tmXTLabelsOn = False

  res@tmYLFormat = "f"
  res@tmXBFormat = "f"
;  res@tmXBPrecision = 3
;  res@tmYLPrecision = 2

	res@xyMarkLineMode   = "Markers"
	res@trYMinF = tsmint(ileg)
	res@trYMaxF = tsmaxt(ileg)
	res@trXMinF = tsmins(ileg)
	res@trXMaxF = tsmaxs(ileg)
;	res@gsnLeftString  = varnames(ivar)
;	res@gsnRightString = legnames(ileg)
	res@gsnCenterString = ""
	res@gsnLeftString  = ""
	res@gsnRightString = ""
	res@gsnCenterString = legnames(ileg)

	res@tiXAxisSide = "Bottom"
	res@tiXAxisString = varnames(varS) +", "+varunits(varS)
	res@tiYAxisString = varnames(varT) +", "+varunits(varT)
	res@tiXAxisFontHeightF = 0.018
	res@tiYAxisFontHeightF = 0.018
  res@tmXBLabelFontHeightF = 0.016
  res@tmYLLabelFontHeightF = 0.016


	res@xyLineColor     = "black"
;	res@tmXBAutoPrecision = True
;	res@tmXBPrecision = varprecs(ivar)
;	if ileg.eq.legMG1 .and. ivar.eq.varT then
;		res@tmXBPrecision = 3
;	end if
  wks = gsn_open_wks("ps", fn)
  plot = gsn_csm_xy(wks, vss, vts, res)
	draw(plot)
	frame(wks)
  delete(wks)
;  system("convert -density 72 -trim "+f+".ps[0] +repage "+ \
;         "-bordercolor White -border 5x5 "+f+".gif")
	system("ps2epsi "+fn+".ps "+fn+".eps")
	system("convert -density "+MEAN_PRF_DPI+" -trim "+ \
				fn+".eps -bordercolor White -border "+MEAN_PRF_MARGIN+" "+fn+".png")
	system("rm "+fn+".ps")
	system("mv "+fn+".eps _eps")
	_log(fn)
end


procedure _plot_ts2(fn:string,vts:double,vss:double)
local res,wks,plot
begin
	colors = (/"grey70","black"/)
	res = get_xy_res()
  res@vpHeightF = 0.5
  res@trYReverse = False
  res@tmXBOn = True
  res@tmXBLabelsOn = True
  res@tmXTOn = False
  res@tmXTLabelsOn = False

;  res@tmYLFormat = "##f"
;  res@tmXBFormat = "##.#f"
  res@tmXBPrecision = 3
  res@tmYLPrecision = 2

	res@xyMarkLineMode   = "Markers"
	res@xyMarkerColors   = colors
	res@xyMarkerSizes    = (/4,2/)
	res@trYMinF = tsmint(legLS1)
	res@trYMaxF = tsmaxt(legLS1)
	res@trXMinF = tsmins(legLS1)
	res@trXMaxF = tsmaxs(legLS1)
;	res@gsnLeftString  = varnames(ivar)
;	res@gsnRightString = legnames(ileg)
	res@gsnCenterString = ""
	res@gsnLeftString  = ""
	res@gsnRightString = ""
	res@gsnCenterString = "LS1 and LS2"

	res@tiXAxisSide = "Bottom"
	res@tiXAxisString = varnames(varS) +", "+varunits(varS)
	res@tiYAxisString = varnames(varT) +", "+varunits(varT)
	res@tiXAxisFontHeightF = 0.018
	res@tiYAxisFontHeightF = 0.018
  res@tmXBLabelFontHeightF = 0.016
  res@tmYLLabelFontHeightF = 0.016


	res@xyLineColor     = "black"
;	res@tmXBAutoPrecision = True
;	res@tmXBPrecision = varprecs(ivar)
;	if ileg.eq.legMG1 .and. ivar.eq.varT then
;		res@tmXBPrecision = 3
;	end if
  wks = gsn_open_wks("ps", fn)
  plot = gsn_csm_xy(wks, vss, vts, res)
	draw(plot)
	frame(wks)
  delete(wks)
;  system("convert -density 72 -trim "+f+".ps[0] +repage "+ \
;         "-bordercolor White -border 5x5 "+f+".gif")
	system("ps2epsi "+fn+".ps "+fn+".eps")
	system("convert -density "+MEAN_PRF_DPI+" -trim "+ \
				fn+".eps -bordercolor White -border "+MEAN_PRF_MARGIN+" "+fn+".png")
	system("rm "+fn+".ps")
	system("mv "+fn+".eps _eps")
	_log(fn)
end


procedure _plot_ts_all(fn:string,vts:double,vss:double)
local res,wks,plot,s2,t2,inds,n
begin
_log(" *** _plot_ts_all START")
	colors = (/"grey70","black"/)
	colors = (/"black","black"/)
	res = get_xy_res()
  res@vpHeightF = 0.5
  res@trYReverse = False
  res@tmXBOn = True
  res@tmXBLabelsOn = True
  res@tmXTOn = False
  res@tmXTLabelsOn = False

;  res@tmYLFormat = "##f"
;  res@tmXBFormat = "##.#f"
  res@tmXBPrecision = 3
  res@tmYLPrecision = 2

	res@xyMarkLineMode   = "Markers"
	res@xyMarkerColors   = colors
	res@xyMarkerColor   = "black"
;	res@xyMarkerSizes    = (/4,2/)
	res@xyMarkerSizes    = (/0.0015/)
	res@xyMarkerSizeF    = 0.0015
	res@xyMarkerSizes    = (/0.002/)
	res@xyMarkerSizeF    = 0.002
	res@trYMinF = 13.5
	res@trYMaxF = 24.5
	res@trXMinF = 37.25
	res@trXMaxF = 39.0
;	res@gsnLeftString  = varnames(ivar)
;	res@gsnRightString = legnames(ileg)
	res@gsnCenterString = ""
	res@gsnLeftString  = ""
	res@gsnRightString = ""
	res@gsnCenterString = ""

	res@tiXAxisSide = "Bottom"
	res@tiXAxisString = varnames(varS) +", "+varunits(varS)
	res@tiYAxisString = varnames(varT) +", "+varunits(varT)
	res@tiXAxisFontHeightF = 0.018
	res@tiYAxisFontHeightF = 0.018
  res@tmXBLabelFontHeightF = 0.016
  res@tmYLLabelFontHeightF = 0.016


	res@xyLineColor     = "black"
	res@xyLineColors     = "black"
	res@tmXMajorGridLineColor = "grey50"
	res@tmYMajorGridLineColor = "grey50"
;	res@tmXBAutoPrecision = True
;	res@tmXBPrecision = varprecs(ivar)
;	if ileg.eq.legMG1 .and. ivar.eq.varT then
;		res@tmXBPrecision = 3
;	end if
_log(" *** _plot_ts_all 2 IND")
  wks = gsn_open_wks("ps", fn)
  s2 = ndtooned(vss)
  t2 = ndtooned(vts)
  inds = ind(.not.ismissing(s2))
  n = dimsizes(inds)
  print("N="+n)
 ; n = 10000
;  plot = gsn_csm_xy(wks, vss, vts, res)
  plot = gsn_csm_xy(wks, s2(inds(0:n-1)), t2(inds(0:n-1)), res)
_log(" *** _plot_ts_all 3 PLOT")
	draw(plot)
	frame(wks)
  delete(wks)
_log(" *** _plot_ts_all 4 V0")
 system("convert -density 300 -trim "+fn+".ps[0] +repage -bordercolor White -border 15x15 "+fn+".v0.png")
_log(" *** _plot_ts_all 5 PS2EPS")
	system("ps2epsi "+fn+".ps "+fn+".eps")
_log(" *** _plot_ts_all 6 PNG")
	system("convert -density 144 -trim "+fn+".eps -bordercolor White -border 20 "+fn+".png")
	system("rm "+fn+".ps")
	system("mv "+fn+".eps _eps")
_log(" *** _plot_ts_all 7  END")
	_log(fn)
end

procedure _plot_ts_all_v2(fn:string,vts:double,vss:double)
local res,wks,plot,s2,t2,inds,n
begin
_log(" *** _plot_ts_all START")
	colors = (/"grey70","black"/)
	colors = (/"black","black"/)
	res = get_xy_res()
  res@vpHeightF = 0.5
  res@trYReverse = False
  res@tmXBOn = True
  res@tmXBLabelsOn = True
  res@tmXTOn = False
  res@tmXTLabelsOn = False

;  res@tmYLFormat = "##f"
;  res@tmXBFormat = "##.#f"
  res@tmXBPrecision = 3
  res@tmYLPrecision = 2

	res@xyMarkLineMode   = "Markers"
	res@xyMarkerColors   = colors
	res@xyMarkerColor   = "black"
;	res@xyMarkerSizes    = (/4,2/)
	res@xyMarkerSizes    = (/0.0015/)
	res@xyMarkerSizeF    = 0.0015
	res@xyMarkerSizes    = (/0.002/)
	res@xyMarkerSizeF    = 0.002
	res@trYMinF = 13.5
	res@trYMaxF = 24.5
	res@trXMinF = 37.25
	res@trXMaxF = 39.0
;	res@gsnLeftString  = varnames(ivar)
;	res@gsnRightString = legnames(ileg)
	res@gsnCenterString = ""
	res@gsnLeftString  = ""
	res@gsnRightString = ""
	res@gsnCenterString = ""

	res@tiXAxisSide = "Bottom"
	res@tiXAxisString = varnames(varS) +", "+varunits(varS)
	res@tiYAxisString = varnames(varT) +", "+varunits(varT)
	res@tiXAxisFontHeightF = 0.018
	res@tiYAxisFontHeightF = 0.018
  res@tmXBLabelFontHeightF = 0.016
  res@tmYLLabelFontHeightF = 0.016


	res@xyLineColor     = "black"
	res@xyLineColors     = "black"
	res@tmXMajorGridLineColor = "grey50"
	res@tmYMajorGridLineColor = "grey50"
;	res@tmXBAutoPrecision = True
;	res@tmXBPrecision = varprecs(ivar)
;	if ileg.eq.legMG1 .and. ivar.eq.varT then
;		res@tmXBPrecision = 3
;	end if



_log(" *** _plot_ts_all 2 IND")
  wks = gsn_open_wks("ps", fn)
  s2 = reshape(vss,(/2,NSTA*NZ/))
  t2 = reshape(vts,(/2,NSTA*NZ/))
printVarSummary(vts)
printVarSummary(t2)

print(num(.not.ismissing(vts(0,:,:))))
print(num(.not.ismissing(vts(1,:,:))))
printMinMax(vts(0,:,:),True)
printMinMax(vts(1,:,:),True)
;;  inds = ind(.not.ismissing(s2))
 ;; n = dimsizes(inds)
 ;; print("N="+n)
 ; n = 10000
;  plot = gsn_csm_xy(wks, vss, vts, res)
;;;;;;;;;;  plot = gsn_csm_xy(wks, s2(inds(0:n-1)), t2(inds(0:n-1)), res)
	res@xyMarkers   = (/5,4/) ; 5-circle 4-cross
	res@xyMarkers   = (/16,16/) ; 5-circle 4-cross
	delete(res@xyMarker)
	res@xyMarkerColors   = (/"red3","royalblue3"/) ; 5-circle 4-cross
	delete(res@xyMarkerSizes)
	res@xyMarkerSizes  = (/0.002,0.002/)
	delete(res@xyMarkerColor)
	delete(res@xyMarkerSizeF)
  plot = gsn_csm_xy(wks, s2, t2, res)
_log(" *** _plot_ts_all 3 PLOT")

restxt = True
restxt@txFontHeightF = 0.017
restxt@txFontColor   = "red3"
gsn_text_ndc(wks,"LS1",0.3,0.61,restxt)
restxt@txFontColor   = "royalblue3"
gsn_text_ndc(wks,"LS2",0.3,0.58,restxt)


	draw(plot)
	frame(wks)
  delete(wks)
_log(" *** _plot_ts_all 4 V0")
 system("convert -density 300 -trim "+fn+".ps[0] +repage -bordercolor White -border 15x15 "+fn+".v0.png")
_log(" *** _plot_ts_all 5 PS2EPS")
	system("ps2epsi "+fn+".ps "+fn+".eps")
	system("convert "+fn+".eps "+fn+".pdf")
_log(" *** _plot_ts_all 6 PNG")
	system("convert -density 144 -trim "+fn+".eps -bordercolor White -border 20 "+fn+".png")
	system("rm "+fn+".ps")
;	system("mv "+fn+".eps _eps")
_log(" *** _plot_ts_all 7  END")
	_log(fn)
end


procedure _plot_profile(fn:string,ileg:integer,ivar:integer,vavgs:double)
local res,wks,plot
begin
	res = get_xy_res()
	res@xyMarkLineMode   = "Lines"
	res@trYMaxF = legzmaxs(ileg)
	res@trXMinF = legvarmins(ileg,ivar)
	res@trXMaxF = legvarmaxs(ileg,ivar)
	res@gsnLeftString  = varnames(ivar)
	res@gsnRightString = legnames(ileg)
	res@gsnCenterString = ""
	res@gsnLeftString  = ""
	res@gsnRightString = ""
	res@gsnCenterString = varnames(ivar) +", "+varunits(ivar)
	res@xyLineColor     = "black"
res@tmXTAutoPrecision = False
res@tmXTPrecision = varprecs(ivar)
res@tmXTFormat = "#+^se"
	if ileg.eq.legMG1 .and. ivar.eq.varT then
		res@tmXTPrecision = 3
	end if
  wks = gsn_open_wks("ps", fn)
  plot = gsn_csm_xy(wks, vavgs, zs, res)
	draw(plot)
	frame(wks)
  delete(wks)
;  system("convert -density 72 -trim "+f+".ps[0] +repage "+ \
;         "-bordercolor White -border 5x5 "+f+".gif")
	system("ps2epsi "+fn+".ps "+fn+".eps")
	system("convert -density "+MEAN_PRF_DPI+" -trim "+ \
				fn+".eps -bordercolor White -border "+MEAN_PRF_MARGIN+" "+fn+".png")
	system("rm "+fn+".ps")
	system("mv "+fn+".eps _eps")
	_log(fn)
end

procedure _plot_profile_diff(fn:string,ivar:integer,vavgs:double)
local res,wks,plot
begin
	res = get_xy_res()
	res@gsnXRefLine = 0.0
	res@xyMarkLineMode   = "Lines"
	res@trYMaxF = legzmaxs(legLS1)
	res@trXMinF = vardiffas(ivar)
	res@trXMaxF = vardiffbs(ivar)
	res@gsnLeftString  = varnames(ivar)
;	res@gsnRightString = legnames(ileg)
	res@gsnCenterString = ""
	res@gsnLeftString  = ""
	res@gsnRightString = ""
	res@gsnCenterString = varnames(ivar) +" ("+varunits(ivar)+")"
	res@xyLineColor     = "black"
res@tmXTAutoPrecision = False
res@tmXTPrecision = vardiffprecs(ivar)
res@tmXTFormat = "#+^se"
;	if ileg.eq.legMG1 .and. ivar.eq.varT then
;		res@tmXTPrecision = 3
;	end if
;	res@tmXBAutoPrecision = True
;	res@tmXBPrecision = varprecs(ivar)
;	if ileg.eq.legMG1 .and. ivar.eq.varT then
;		res@tmXBPrecision = 3
;	end if
  wks = gsn_open_wks("ps", fn)
  plot = gsn_csm_xy(wks, vavgs, zs, res)
	draw(plot)
	frame(wks)
  delete(wks)
;  system("convert -density 72 -trim "+f+".ps[0] +repage "+ \
;         "-bordercolor White -border 5x5 "+f+".gif")
	system("ps2epsi "+fn+".ps "+fn+".eps")
	system("convert -density "+MEAN_PRF_DPI+" -trim "+ \
				fn+".eps -bordercolor White -border "+MEAN_PRF_MARGIN+" "+fn+".png")
	system("rm "+fn+".ps")
	system("mv "+fn+".eps _eps")
	_log(fn)
end

procedure _plot_profile3(fn:string,ileg:integer,ivar:integer,vs:double,opt:integer)
local res,wks,plot,zs4,colors,titles,widths
begin
	if opt.eq.optSTAT then
		colors = 0.01*(/(/90,40,90/),(/50,0,50/),(/40,90,90/),(/ 0,50,50/)/)
		colors = 0.01*(/(/100,60,60/),(/80,0,0/),(/60,60,100/),(/ 0,0,80/)/)
		colors = 0.01*(/(/60,60,100/),(/ 0,0,80/),(/100,60,60/),(/80,0,0/)/)
		colors = 0.01*(/(/60,60,100/),(/100,60,60/),(/ 0,0,80/),(/80,0,0/)/)
		widths = 4*(/2.,2.,1.,1./)
	end if
	if opt.eq.optPROF then
		colors = 0.01*(/(/0,0,0/),(/0,100,0/),(/100,0,0/)/)
		colors = 0.01*(/(/0,0,0/),(/20,20,100/),(/100,0,0/)/)
		widths = 2.5*(/1.5,1.5,1.5/)
	end if
	zs4 = new((/4,NZ/),double)
	zs4(0,:) = zs
	zs4(1,:) = zs
	zs4(2,:) = zs
	zs4(3,:) = zs
;do i = 0,3
;printMinMax(vs(i,:),True)
;end do
	res = get_xy_res()
	res@gsnXRefLine           = 0.0
	res@gsnXRefLineThicknessF = 1.5
	if ivar.eq.varT .and. opt.eq.optSTAT then
		res@trXMinF =-1.
		res@trXMaxF = 3.
	end if
	res@tmXBFormat = where(ivar.eq.varT .and. opt.eq.optPROF, "f", "f") ; best!
;	res@tmXBFormat = where(ivar.eq.varS .and. opt.eq.optPROF, "*.2f", res@tmXBFormat) ; best!
	res@xyMarkLineModes   = (/"Lines","Lines","Lines","Lines"/)
	res@xyMarkLineMode   = "Lines"
	res@trYMaxF = legzmaxs(legLS1)
;	res@trXMinF = legvarmins(legLS1,ivar)
;	res@trXMaxF = legvarmaxs(legLS1,ivar)
	res@gsnLeftString  = varnames(ivar)
	res@gsnRightString = legnames(ileg)
	res@gsnCenterString = ""
	res@gsnLeftString  = ""
	res@gsnRightString = ""
	res@gsnCenterString = varnames(ivar) +", "+varunits(ivar)
;	res@gsnCenterString = legnames(ileg)
	res@gsnRightString = legnames(ileg)
	res@gsnRightStringFontHeightF = 0.028
	res@gsnRightStringOrthogonalPosF = -0.96
	if ivar.eq.varS .and. opt.eq.optPROF then
		res@gsnRightStringParallelPosF = 0.2
	else
		res@gsnRightStringParallelPosF = 0.87
	end if
	res@xyLineColors = colors
	res@xyLineThicknesses = widths
  wks = gsn_open_wks("ps", fn)
  plot = gsn_csm_xy(wks, vs, zs4, res)
	draw(plot)
	frame(wks)
  delete(wks)
;  system("convert -density 72 -trim "+f+".ps[0] +repage "+ \
;         "-bordercolor White -border 5x5 "+f+".gif")
	system("ps2epsi "+fn+".ps "+fn+".eps")
	system("convert -density "+1*MEAN_PRF_DPI+" -trim "+ \
				fn+".eps -bordercolor White -border "+1*MEAN_PRF_MARGIN+" "+fn+".png")
	system("rm "+fn+".ps")
	system("mv "+fn+".eps _eps")
	_log(fn)
;	exit
end

procedure _plot_profile2(fn:string,ivar:integer,vavgs:double)
local res,wks,plot,zs2,colors
begin
	colors = (/"grey70","black"/)
	zs2 = new((/2,NZ/),double)
	zs2(0,:) = zs
	zs2(1,:) = zs
	res = get_xy_res()
	res@xyMarkLineMode   = "Lines"
	res@trYMaxF = legzmaxs(legLS1)
	res@trXMinF = legvarmins(legLS1,ivar)
	res@trXMaxF = legvarmaxs(legLS1,ivar)
	res@gsnLeftString  = varnames(ivar)
;	res@gsnRightString = legnames(ileg)
	res@gsnCenterString = ""
	res@gsnLeftString  = ""
	res@gsnRightString = ""
	res@gsnCenterString = varnames(ivar) +" ("+varunits(ivar)+")"
	res@xyLineColors = colors
	res@xyLineThicknesses = (/6.,2./)
res@tmXTAutoPrecision = False
res@tmXTPrecision = varprecs(ivar)
res@tmXTFormat = "#+^se"
;	if ileg.eq.legMG1 .and. ivar.eq.varT then
;		res@tmXTPrecision = 3
;	end if
;	res@tmXBAutoPrecision = True
;	res@tmXBPrecision = varprecs(ivar)
;	if ileg.eq.legMG1 .and. ivar.eq.varT then
;		res@tmXBPrecision = 3
;	end if
  wks = gsn_open_wks("ps", fn)
  plot = gsn_csm_xy(wks, vavgs, zs2, res)
	draw(plot)
	frame(wks)
  delete(wks)
;  system("convert -density 72 -trim "+f+".ps[0] +repage "+ \
;         "-bordercolor White -border 5x5 "+f+".gif")
	system("ps2epsi "+fn+".ps "+fn+".eps")
	system("convert -density "+MEAN_PRF_DPI+" -trim "+ \
				fn+".eps -bordercolor White -border "+MEAN_PRF_MARGIN+" "+fn+".png")
	system("rm "+fn+".ps")
	system("mv "+fn+".eps _eps")
	_log(fn)
end

procedure _plot_profiles(fn:string,ileg:integer,ivar:integer,vavgs:double,vstds:double)
local polyx,polyy,i,j,n,x,dx,z, \
			res,respoly,wks,plot,dummy
begin

	polyx = new( (/2*NZ+1/), double )
	polyz = new( (/2*NZ+1/), double )
	n = num(.not.ismissing(vstds))
	do i = 0,n-1
		j = 2*n-1-i
		dx = vstds(i)
		x  = vavgs(i)
		z  = zs(i)
		polyx(i) = x-dx
		polyx(j) = x+dx
		polyz(i) = z
		polyz(j) = z
	end do
	polyx(2*n) = polyx(0)
	polyz(2*n) = polyz(0)

	respoly = True
	respoly@tfPolyDrawOrder   = "Predraw" ; draw this first
	respoly@gsFillColor       = 0.8*(/1,1,1/)

	res = get_xy_res()
	res@xyMarkLineMode   = "Lines"
	res@trYMaxF = legzmaxs(ileg)
	res@trXMinF = legvarmins(ileg,ivar)
	res@trXMaxF = legvarmaxs(ileg,ivar)
	res@gsnLeftString  = varnames(ivar)
	res@gsnRightString = legnames(ileg)
	res@gsnCenterString = ""
	res@gsnLeftString  = ""
	res@gsnRightString = ""
	res@gsnCenterString = varnames(ivar)
if FINAL then
	res@gsnCenterString = varnames(ivar)+" ("+varunits(ivar)+")"
end if
	res@xyLineColor     = "black"
	res@tmXBAutoPrecision = False
	res@tmXBPrecision = varprecs(ivar)
	if ileg.eq.legMG1 .and. ivar.eq.varT then
		res@tmXBPrecision = 3
	end if

  wks = gsn_open_wks("ps", fn)
  plot = gsn_csm_xy(wks, vavgs, zs, res)
	dummy = gsn_add_polygon (wks,plot,polyx(0:2*n),polyz(0:2*n),respoly)
	draw(plot)
	frame(wks)
  delete(wks)
;  system("convert -density 72 -trim "+f+".ps[0] +repage "+ \
;         "-bordercolor White -border 5x5 "+f+".gif")
	system("ps2epsi "+fn+".ps "+fn+".eps")
	system("convert -density "+MEAN_PRF_DPI+" -trim "+ \
				fn+".eps -bordercolor White -border "+MEAN_PRF_MARGIN+" "+fn+".png")
	system("rm "+fn+".ps")
	system("mv "+fn+".eps _eps")
	_log(fn)
end

DO_GRID = True
GRID_NAME = "MFS T-grid"
GRID_FILE = "MFS_grid"

DO_MASK = True

leglons = new((/NLEG,7/),double)
leglats = new((/NLEG,7/),double)
leglons(legCS1,0:4) = (/ 17.044435, 17.319275, 17.294060, 16.867724, 17.044435/)
leglats(legCS1,0:4) = (/ 40.490719, 40.353479, 40.153219, 40.372339, 40.490719/)
leglons(legLS1,0:4) = (/ 16.992898, 17.932663, 17.490471, 16.526728, 16.992898/)
leglats(legLS1,0:4) = (/ 40.520524, 40.070978, 39.497768, 39.984716, 40.520524/)
;leglons(legLS2,0:6) = (/ 17.962563, 17.479431, 16.622044, 17.041786, 17.302586, 17.434971, 17.962563 /)
;leglats(legLS2,0:6) = (/ 40.082350, 39.487805, 39.911590, 40.390138, 40.295209, 40.370430, 40.082350 /)
leglons(legMG1,0:6) = (/ 17.161352, 17.191171, 17.226670, 17.256351, 17.215794, 17.159671, 17.161352/)
leglats(legMG1,0:6) = (/ 40.463944, 40.480540, 40.477769, 40.461092, 40.418871, 40.453612, 40.463944/)

leglons(legLS2,0:5) = (/  17.948472,  17.491905,  16.641684,  17.038526,  17.521717, 17.948472 /)
leglats(legLS2,0:5) = (/  40.078916,  39.508928,  39.934202,  40.381377,  40.322458, 40.078916 /)

; new, better
leglons(legMG1,0:6) = (/17.15937784184523,17.16137501316719,17.19422610774802,17.22010411293843, \
												17.25708620826471,17.21600247454976,17.15937784184523/)
leglats(legMG1,0:6) = (/40.45279781336341,40.46529591841483,40.48423277309248,40.48354105539801, \
												40.4574171839914 ,40.41758196375217,40.45279781336341/)


DO_GRID_STATIONS = False

procedure _plot_map(fn:string,leg:integer, \
					do_stas:logical,do_vals:logical,vals:numeric, \
					va:numeric,vb:numeric,dval:numeric,stride:integer)
local res,plot,wks, \
i,n,xs,ys,restxt,rect,txt,markers, res2
begin
	restxt = True
	restxt@gsMarkerIndex = 16
	res = _get_map_res(leg)
res@cnInfoLabelOn     = False
	wks = gsn_open_wks("ps",fn)
	if .not.do_vals then
		if .not.do_stas then ;
			res@mpFillDrawOrder  = "PreDraw" ;
			res@gsnRightString = ""
			res@gsnLeftString = "Precipitation area"
			if DO_GRID then
				res@gsnLeftString = GRID_NAME
			end if
		end if
		plot = gsn_csm_map(wks,res)
		if do_stas then
			n = legnstas(leg)
			gsn_polymarker(wks,plot,stalons(leg,0:n-1),stalats(leg,0:n-1),True)
			n = num(.not.ismissing(leglons(leg,:)))
print(leg)
print(n)
print(leglons(leg,:)+TAB+leglats(leg,:))
			rect = gsn_add_polyline(wks,plot,leglons(leg,0:n-1),leglats(leg,0:n-1),restxt)
		end if
		if .not.do_stas .and..not.DO_GRID then ;
			xs = (/preciplona,preciplona,preciplonb,preciplonb,preciplona/)
			ys = (/preciplata,preciplatb,preciplatb,preciplata,preciplata/)
			n = legnstas(leg)
			restxt@tfPolyDrawOrder  = "PostDraw" ;
			res@mpFillDrawOrder  = "PreDraw" ;
			gsn_polymarker(wks,plot,stalons(leg,0:n-1),stalats(leg,0:n-1),restxt)
;			gsn_polymarker(wks,plot,stalons(legCS1,0:n-1),stalats(legCS1,0:n-1),restxt)
			rect = gsn_add_polyline(wks,plot,xs,ys,restxt)
		end if
		if .not.do_stas .and.DO_GRID then ;
			txt = readAsciiTable("_txt/"+GRID_FILE+".txt",2,"double",0)
			xs = txt(:,0)
			ys = txt(:,1)
			n = dimsizes(xs)
			restxt@tfPolyDrawOrder  = "PostDraw" ;
			restxt@gsMarkerSizeF  = 0.006 ;
			restxt@gsMarkerColor  = "black" ;
			res@mpFillDrawOrder  = "PreDraw" ;
			markers = gsn_add_polymarker(wks,plot,xs,ys,restxt)
			if DO_GRID_STATIONS then
				n = legnstas(leg)
				res2 = True
				res2@gsMarkerSizeF  = 0.012 ;
				gsn_polymarker(wks,plot,stalons(leg,0:n-1),stalats(leg,0:n-1),res2)
			end if
;			gsn_polymarker(wks,plot,stalons(legCS1,0:n-1),stalats(legCS1,0:n-1),restxt)
;			rect = gsn_add_polyline(wks,plot,xs,ys,restxt)
		end if
	end if ; not do_vals
	if do_vals then
;printMinMax(vals,True)
;printVarSummary(vals)
		plot = gsn_csm_contour_map(wks,vals,res)
		if do_stas then
			n = legnstas(leg)
			gsn_polymarker(wks,plot,stalons(leg,0:n-1),stalats(leg,0:n-1),True)
		end if
	end if

	draw(plot)
	frame(wks)
	delete(wks)
	system("ps2epsi "+fn+".ps "+fn+".eps")
	system("convert -density "+MAP_DPI+" -trim "+fn+".eps -bordercolor White -border "+MAP_MARGIN+"x"+MAP_MARGIN+" "+fn+".png")
	system("rm "+fn+".ps")
	system("mv "+fn+".eps _eps")
	_log(fn)
end

procedure _plot_map_file(txtfn:string,fn:string,leg:integer, \
					do_stas:logical,va:numeric,vb:numeric,dval:numeric,stride:integer)
local wks,plot,res
begin
end


