loadscript("mrea.lib.v15.ncl")
loadscript("mrea.def.v15.ncl")
loadscript("mrea.res.v15.ncl")
loadscript("ocean_funcs.ncl")

MAP_DIR = "_mrea_gc_maps/"
dpi = 200
dpi = 240

leg = legLS2
maplona = legmaplonas(leg)
maplonb = legmaplonbs(leg)
maplata = legmaplatas(leg)
maplatb = legmaplatbs(leg)

MYLAT = 40. ; degree
MYSINLAT = sin(MYLAT/180.*3.14159)
MYCOSLAT = cos(MYLAT/180.*3.14159)

G = 9.81
OMEGA = 7.2921e-5
factor = 2*OMEGA*MYSINLAT

dx2 = 1./64
dy2 = 1./64

DX = dx2*60*1852*MYCOSLAT ; m
DY = dy2*60*1852          ; m

print("DX="+DX+TAB+"DY="+DY)
;exit

vlona = 16.5-1./16+1./64.
vlonb = 18.0+1./16-1./64.
vlata = 39.5-1./16+1./64.
vlatb = 40.5+1./16-1./64.

nvlat = 71
nvlon = 103

;lat: 73	39.4375	40.5625
;lon: 105	16.4375	18.0625

;fn = legnames(leg)+"DH_fine.cbin"
;tmp = cbinread(fn,(/nvlat+2,nvlon+2/),"double")
;exit


;% CS1+LS2 1/64
;ny = 73;
;nx = 105;
;dx = 1./64;
;dy = 1./64;
;xa = 16.5-1./16;
;ya = 39.5-1./16;

ny = 73;
nx = 105;
dx = 1./64;
dy = 1./64;
xa = 16.5-1./16;
ya = 39.5-1./16;

xb = xa+dx*(nx-1)
yb = ya+dy*(ny-1)

myvlons = fspan(xa,xb,nx)
myvlats = fspan(ya,yb,ny)

procedure _assign2dv(v:numeric,lats:numeric,lons:numeric)
begin
	v!1 = "lat"
	v!2 = "lon"
	v&lat = lats
	v&lon = lons
	v&lat@units = "degrees_north"
	v&lon@units = "degrees_east"
end

vdhs = new((/NLEG,ny,nx/),double)
edhs = new((/NLEG,ny,nx/),double) ; new errors
vus = new((/NLEG,ny,nx/),double)
vvs = new((/NLEG,ny,nx/),double)
vws = new((/NLEG,ny,nx/),double)

; new,
PREFIX_TXT = "/Data/mrea14/__article/__oa/__matlab/__mrea16_input_final/"
PREFIX_OA  = "/Data/mrea14/__article/__oa/__matlab/__mrea16_output_final/"
SUFFIX_OA  = ".txt_A25_B15_D20_L5."

PREFIX_OA  = "./_from_oa/"
PREFIX_TXT = "./_for_oa/"

mreas = (/"", "MREA14","MREA16"/)


function _read_oa1(ffn:string)
local tmp1,tmp2
begin
;;	_check_file_exists(ffn)
	tmp1 = new((/nx,ny/),double)
	tmp1 = readAsciiTable(ffn,ny,"double",0)
	tmp2 = (/transpose(tmp1)/)
	return tmp2
end

stalons = 0
stalats = 0

procedure _read_oa(sfn:string)
local fn,ffn,tmp,dims
begin
print(sfn)
	_log(sfn)
	ffn = PREFIX_TXT+sfn+".txt"
system("ls -All "+PREFIX_TXT)
print("TXT="+ffn)
;	_check_file_exists(ffn)
	tmp = readAsciiTable(ffn,3,"double",0)
	dims = dimsizes(tmp)
	nsta = dims(0)
	delete(stalons)
	delete(stalats)
	stalons = tmp(:,0)
	stalats = tmp(:,1)
	delete(tmp)
	fn = PREFIX_OA+sfn+SUFFIX_OA
print("OA="+fn)
;fn = "oa_LS3_DH100.txt_A15_B15_D20_L20"
	vdhs(leg,:,:) = _read_oa1(fn+"oa.txt")
	edhs(leg,:,:) = _read_oa1(fn+"err.txt")
end

; new read from txt-files
do leg=legLS1,legLS2
;2016.LSDH.05m.txt

if leg.eq.legLS1 then
	fn ="2014.LS.DH5m"
	ffn ="../_from_oa/2014.LS.DH5m.txt_A25_B15_D20_L5."
end if

if leg.eq.legLS2 then
	fn ="2016.LS.DH5m"
	ffn ="../_from_oa/2016.LS.DH5m.txt_A25_B15_D20_L5."
end if

;	fn = legnames(leg)+"DH_fine.cbin"
;;;	fn = legnames(leg)+".DH.100"
;;	_read_oa(fn)
	vdhs(leg,:,:) = _read_oa1(ffn+"oa.txt")
	edhs(leg,:,:) = _read_oa1(ffn+"err.txt")
;printMinMax(vdhs(leg,:,:),True)
;printMinMax(edhs(leg,:,:),True)

vdhs(leg,:,:) = where(edhs(leg,:,:).lt.0 .or. edhs(leg,:,:).gt.0.5, vdhs@_FillValue, vdhs(leg,:,:))
vdhs(leg,:,:) = -vdhs(leg,:,:)

; 2019 make it smoother
vdhs(leg,:,:) = smth9_Wrap(vdhs(leg,:,:), 0.50, -0.25, False) ; light local smoothing
vdhs(leg,:,:) = smth9_Wrap(vdhs(leg,:,:), 0.50, -0.25, False) ; light local smoothing
vdhs(leg,:,:) = smth9_Wrap(vdhs(leg,:,:), 0.50, -0.25, False) ; light local smoothing
vdhs(leg,:,:) = smth9_Wrap(vdhs(leg,:,:), 0.50, -0.25, False) ; light local smoothing
print("smoothed!")
;exit
;	vdhs(leg,:,:) = cbinread(fn,(/nvlat+2,nvlon+2/),"double")
;	vdhs(leg,:,:) = where(ismissing(vdhs(leg,:,:)),0,vdhs(leg,:,:))
;;	vus(leg,1:ny-2,1:nx-2) = -1./factor*(vdhs(leg,2:ny-1,1:nx-2)-vdhs(leg,0:ny-3,1:nx-2))/ DY * G /2
;;	vvs(leg,1:ny-2,1:nx-2) =  1./factor*(vdhs(leg,1:ny-2,2:nx-1)-vdhs(leg,1:ny-2,0:nx-3))/ DX * G /2
	vus(leg,1:ny-2,1:nx-2) =  1./factor*(vdhs(leg,2:ny-1,1:nx-2)-vdhs(leg,0:ny-3,1:nx-2))/ DY * G /2
	vvs(leg,1:ny-2,1:nx-2) = -1./factor*(vdhs(leg,1:ny-2,2:nx-1)-vdhs(leg,1:ny-2,0:nx-3))/ DX * G /2
;	vus(leg,:,:) = where(vus(leg,:,:).eq.0.,vus@_FillValue,vus(leg,:,:))
;	vvs(leg,:,:) = where(vvs(leg,:,:).eq.0.,vvs@_FillValue,vvs(leg,:,:))



	vws(leg,:,:) = sqrt(vus(leg,:,:)^2+vvs(leg,:,:)^2)
print(legnames(leg)+TAB+avg(vws(leg,:,:))+TAB+max(vws(leg,:,:)))
end do

;print("*** BREAK ***")
;exit

if False then
; old read from cbin-files
do leg=legLS1,legLS2
	fn = legnames(leg)+"DH_fine.cbin"
	fn = legnames(leg)+"DH_fine.cbin"
	vdhs(leg,:,:) = cbinread(fn,(/nvlat+2,nvlon+2/),"double")
;	vdhs(leg,:,:) = where(ismissing(vdhs(leg,:,:)),0,vdhs(leg,:,:))
	vus(leg,1:ny-2,1:nx-2) = -1./factor*(vdhs(leg,2:ny-1,1:nx-2)-vdhs(leg,0:ny-3,1:nx-2))/ DY * G /2
	vvs(leg,1:ny-2,1:nx-2) =  1./factor*(vdhs(leg,1:ny-2,2:nx-1)-vdhs(leg,1:ny-2,0:nx-3))/ DX * G /2
;;	vus(leg,1:ny-2,1:nx-2) =  1./factor*(vdhs(leg,2:ny-1,1:nx-2)-vdhs(leg,0:ny-3,1:nx-2))/ DY * G /2
;;	vvs(leg,1:ny-2,1:nx-2) = -1./factor*(vdhs(leg,1:ny-2,2:nx-1)-vdhs(leg,1:ny-2,0:nx-3))/ DX * G /2
;	vus(leg,:,:) = where(vus(leg,:,:).eq.0.,vus@_FillValue,vus(leg,:,:))
;	vvs(leg,:,:) = where(vvs(leg,:,:).eq.0.,vvs@_FillValue,vvs(leg,:,:))

	vws(leg,:,:) = sqrt(vus(leg,:,:)^2+vvs(leg,:,:)^2)
print(legnames(leg)+TAB+avg(vws(leg,:,:))+TAB+max(vws(leg,:,:)))
end do
end if

;_assign2dv(vdhs,myvlats,myvlons)
_assign2dv(vus,myvlats,myvlons)
_assign2dv(vvs,myvlats,myvlons)
_assign2dv(vws,myvlats,myvlons)

MAP_DIR = "/Data/mrea14/__article/__oa/__mrea16.maps/"
MAP_DIR = "./_mrea_gc_maps_2020/"
print("MAP_DIR = "+MAP_DIR)

procedure _assign2d(v:numeric,lats:numeric,lons:numeric)
begin
	v@_FillValue = -999
	v = where(abs(v).gt.900 .or. v.eq.0 ,v@_FillValue,v)
	v!0 = "lat"
	v!1 = "lon"
	v&lat = lats
	v&lon = lons
	v&lat@units = "degrees_north"
	v&lon@units = "degrees_east"
end

rt = True
rt@txFontHeightF = 0.020
rttext = "(a)"

rn = True
rn@txFontHeightF = 0.022
rn@txJust = "CenterCenter"
rntext = "(a)"

procedure _mfs_map(fn:string,center:string,left:string,right:string,palette:string, \
									 v:numeric,vmin:numeric,vmax:numeric,step:numeric,stride:integer)
local ffn,wks,plot,res
begin
	res = _get_map_res(leg)
  res@gsnSpreadColorStart = 2
  res@gsnSpreadColorEnd = -2
	res@tiMainString    = center
	res@gsnLeftString   = left
	res@gsnRightStringFontHeightF   = 0.020
	res@gsnRightString  = right
	res@gsnDraw       = False          ; do not draw
	res@gsnFrame      = False          ; do not advance
	res@lbLabelBarOn = True
	res@cnFillOn    = True
	res@cnFillDrawOrder = "PreDraw"
	res@mpFillDrawOrder = "PreDraw"
;  res@mpMinLonF = maplona
;  res@mpMaxLonF = maplonb
;  res@mpMinLatF = maplata
;  res@mpMaxLatF = maplatb
	res@cnLevelSelectionMode   = "ManualLevels"
;	gsn_reverse_colormap(wks)
	res@cnMinLevelValF  = vmin
	res@cnMaxLevelValF  = vmax
	res@cnLevelSpacingF = step
	res@lbLabelStride   = stride
  res@mpDataBaseVersion = "HighRes" ; "HighRes"
  res@mpDataResolution  = "Finest"  ; "Medium" ;
	res@pmLabelBarHeightF = 0.08
  res@pmLabelBarOrthogonalPosF = 0.01
  
   res@tmXBMajorLengthF = 0.004
  res@tmXBMajorOutwardLengthF = 0.004

	ffn = MAP_DIR+fn
	wks = gsn_open_wks("ps",ffn)
	gsn_define_colormap(wks,palette)
	plot = gsn_csm_contour_map(wks,v,res)
	draw(plot)
	gsn_text_ndc(wks,rntext,0.16,0.17,rt)
	gsn_text_ndc(wks,rttext,0.25,0.72,rn)
	frame(wks)
	delete(wks)
	system("ps2epsi "+ffn+".ps "+ffn+".eps")
	system("convert -density "+dpi+" -trim "+ffn+".eps -bordercolor White -border 20x20 "+ffn+".jpg")
	system("rm "+ffn+".ps")
;;;	system("rm "+ffn+".eps")
print(ffn+".eps saved")
	_log(fn)
end

procedure _mfs_vmap(fn:string,center:string,left:string,right:string,palette:string, \
			 u:numeric,v:numeric,w:numeric,wmax:numeric,step:numeric,stride:integer,reflength:numeric)
local ffn,wks,plot,res
begin
	res = _get_map_res(leg)
  res@gsnSpreadColorStart = 2
  res@gsnSpreadColorEnd = -2
	res@tiMainString    = center
	res@gsnLeftString   = left
	res@gsnRightString  = right
		res@gsnRightStringFontHeightF = 0.018
		res@gsnRightStringOrthogonalPosF = 0.02
	res@gsnDraw       = False          ; do not draw
	res@gsnFrame      = False          ; do not advance
	res@lbLabelBarOn = True
	res@cnFillOn    = True
  res@mpOutlineOn  =  True
	res@cnFillDrawOrder = "PreDraw"
	res@mpFillDrawOrder    = "PostDraw"
	res@mpOutlineDrawOrder = "PostDraw"
;  res@mpMinLonF = maplona
;  res@mpMaxLonF = maplonb
;  res@mpMinLatF = maplata
;  res@mpMaxLatF = maplatb
	res@cnLevelSelectionMode   = "ManualLevels"
;	gsn_reverse_colormap(wks)
	res@cnMinLevelValF  = 0.0
	res@cnMaxLevelValF  = wmax
	res@cnLevelSpacingF = step
	res@lbLabelStride   = stride
  res@mpDataBaseVersion = "HighRes" ; "HighRes"
  res@mpDataResolution  = "Finest"  ; "Medium" ;

  res@gsnScalarContour = True

  res@vcGlyphStyle            = "CurlyVector" ; "LineArrow"
  res@vcLineArrowColor        = "black"           ; change vector color
 ; res@vcVectorDrawOrder       = "PostDraw"        ; draw vectors last
  res@vcRefAnnoOn             = False
  res@vcLineArrowHeadMaxSizeF = 0.002

  res@vcRefMagnitudeF = 0.8          ; define vector ref mag
  res@vcRefLengthF    = reflength           ; define length of vec ref
  res@vcMinDistanceF  = 0.008  ;0.012
  res@vcMinDistanceF  = 0.020
  res@cnLevelSpacingF = step
  res@lbLabelStride   = stride
  res@cnMinLevelValF  = 0.
  res@cnMaxLevelValF  = wmax
  res@vcLineArrowThicknessF   = 1.4                ; change vector thickness


  res@vcLineArrowHeadMaxSizeF = 0.008
  res@vcRefLengthF    = reflength           ; define length of vec ref
	res@pmLabelBarHeightF = 0.07
  res@pmLabelBarOrthogonalPosF = 0.08
	res@pmLabelBarHeightF = 0.08
  res@pmLabelBarOrthogonalPosF = 0.07
  res@lbLabelFontHeightF = 0.014
  
    res@vcLineArrowHeadMaxSizeF = 0.012
  res@vcLineArrowThicknessF   = 2.0


  res@tmXBMajorLengthF = 0.003
  res@tmXBMajorOutwardLengthF = 0.003
  res@tmXBLabelFontHeightF = 0.011
  res@tmXBMajorLengthF = 0.01
  
     res@tmXBMajorLengthF = 0.004
  res@tmXBMajorOutwardLengthF = 0.004



	ffn = MAP_DIR+fn
	wks = gsn_open_wks("ps",ffn)
	gsn_define_colormap(wks,palette)
	plot = gsn_csm_vector_scalar_map(wks,u,v,w,res)
	draw(plot)
	gsn_text_ndc(wks,rntext,0.16,0.17,rt)
	gsn_text_ndc(wks,rttext,0.25,0.72,rn)
	frame(wks)
	delete(wks)
	system("ps2epsi "+ffn+".ps "+ffn+".eps")
	system("convert -density "+dpi+" -trim "+ffn+".eps -bordercolor White -border 20x20 "+ffn+".jpg")
	system("rm "+ffn+".ps")
;;	system("rm "+ffn+".eps")
;;;	system("rm "+ffn+".eps")
print(ffn+".eps saved")

	_log(fn)
end

procedure _mfs_dh_gc_map(fn:string,center:string,left:string,right:string,palette:string, \
			 u:numeric,v:numeric,w:numeric,wmax:numeric,step:numeric,stride:integer,reflength:numeric)
local ffn,wks,plot,res
begin
	res = _get_map_res(leg)
  res@gsnSpreadColorStart = 2
  res@gsnSpreadColorEnd = -2
	res@tiMainString    = center
	res@gsnLeftString   = left
	res@gsnRightString  = right
		res@gsnRightStringFontHeightF = 0.018
		res@gsnRightStringOrthogonalPosF = 0.02
	res@gsnDraw       = False          ; do not draw
	res@gsnFrame      = False          ; do not advance
	res@lbLabelBarOn = True
	res@cnFillOn    = True
  res@mpOutlineOn  =  True
	res@cnFillDrawOrder = "PreDraw"
	res@mpFillDrawOrder    = "PostDraw"
	res@mpOutlineDrawOrder = "PostDraw"
;  res@mpMinLonF = maplona
;  res@mpMaxLonF = maplonb
;  res@mpMinLatF = maplata
;  res@mpMaxLatF = maplatb
	res@cnLevelSelectionMode   = "ManualLevels"
;	gsn_reverse_colormap(wks)
  res@mpDataBaseVersion = "HighRes" ; "HighRes"
  res@mpDataResolution  = "Finest"  ; "Medium" ;

  res@gsnScalarContour = True

  res@vcGlyphStyle            = "CurlyVector" ; "LineArrow"
  res@vcLineArrowColor        = "black"           ; change vector color
 ; res@vcVectorDrawOrder       = "PostDraw"        ; draw vectors last
  res@vcRefAnnoOn             = False
  res@vcLineArrowHeadMaxSizeF = 0.002

  res@vcRefMagnitudeF = 0.8          ; define vector ref mag
  res@vcRefLengthF    = reflength           ; define length of vec ref
  res@vcMinDistanceF  = 0.008  ;0.012
  res@vcMinDistanceF  = 0.020
  res@cnLevelSpacingF = step
  res@lbLabelStride   = stride
  res@cnMinLevelValF  = -wmax
  res@cnMaxLevelValF  = wmax
  res@vcLineArrowThicknessF   = 1.4                ; change vector thickness


  res@vcLineArrowHeadMaxSizeF = 0.008
  res@vcRefLengthF    = reflength           ; define length of vec ref
	res@pmLabelBarHeightF = 0.07
  res@pmLabelBarOrthogonalPosF = 0.08
	res@pmLabelBarHeightF = 0.08
  res@pmLabelBarOrthogonalPosF = 0.07
  res@lbLabelFontHeightF = 0.014
  
    res@vcLineArrowHeadMaxSizeF = 0.012
  res@vcLineArrowThicknessF   = 2.0


  res@tmXBMajorLengthF = 0.003
  res@tmXBMajorOutwardLengthF = 0.003
  res@tmXBLabelFontHeightF = 0.011
  res@tmXBMajorLengthF = 0.01
  
     res@tmXBMajorLengthF = 0.004
  res@tmXBMajorOutwardLengthF = 0.004
  
  if True then ; final variant
  	res@vcRefAnnoOn     = True
	res@vcRefAnnoPerimOn = False
	res@vcRefAnnoPerimSpaceF = 0.5
	res@vcRefAnnoOrthogonalPosF = -0.95
	res@vcRefAnnoParallelPosF   =  0.95
	res@vcRefAnnoFontHeightF    = 0.016
;  res@vcRefLengthF            = 0.05
  	
  res@vcRefAnnoString1 = "0.1 m/c"
  	
  	res@vcRefAnnoOn     = True
  	res@vcRefAnnoBackgroundColor = -1  ; transparent
  	res@vcRefMagnitudeF = 0.5        
  	res@vcRefMagnitudeF = 0.1        
  	res@vcMinDistanceF  = 0.025
  end if



	ffn = MAP_DIR+fn
	wks = gsn_open_wks("ps",ffn)
	gsn_define_colormap(wks,palette)
	plot = gsn_csm_vector_scalar_map(wks,u,v,w,res)
	draw(plot)
;	gsn_text_ndc(wks,rntext,0.16,0.17,rt)
rt@txFontHeightF = 0.018
	gsn_text_ndc(wks,"Dynamic height, m",0.5,0.18,rt)
	gsn_text_ndc(wks,rttext,0.25,0.72,rn)
	frame(wks)
	delete(wks)
	system("ps2epsi "+ffn+".ps "+ffn+".eps")
	system("convert -density "+dpi+" -trim "+ffn+".eps -bordercolor White -border 20x20 "+ffn+".jpg")
	system("rm "+ffn+".ps")
;;	system("rm "+ffn+".eps")
;;;	system("rm "+ffn+".eps")
print(ffn+".eps saved")

	_log(fn)
end

print("GGGG")
;exit

do leg = legLS1,legLS2
	FN = mreas(leg)
	if leg.eq.legLS2 then
		rttext = "(b)"
	end if
;	FN = "CS1LS2"
;;	_mfs_vmap(FN+"_GC_fine_correct","","Geostrophic currents at 10 m, m/s",legnames(leg),"WhiteBlueGreenYellowRed", \
;;	vus(leg,:,:),vvs(leg,:,:),vws(leg,:,:),0.35,0.005,2,0.1)
vdhs(leg,:,:) = -vdhs(leg,:,:)+avg(vdhs(leg,:,:))
	_assign2dv(vdhs,myvlats,myvlons)
	
if False then
		rntext = "(m)"
	_mfs_map(FN+".dh.5m.ref100.v2","","Dynamic height at 5 m, m",mreas(leg),"BlGrYeOrReVi200",vdhs(leg,:,:),-0.05,0.05,0.005,2)
	
		rntext = "(m/s)"	
	_mfs_vmap(FN+".gc.5m.ref100.v2","","Geostrophic currents at 5 m, m/s",mreas(leg),"WhiteBlueGreenYellowRed", \
	vus(leg,:,:),vvs(leg,:,:),vws(leg,:,:),0.60,0.02,5,0.1)
end if

vus(leg,:,:) = smth9_Wrap(vus(leg,:,:), 0.50, -0.25, False) ; light local smoothing
vvs(leg,:,:) = smth9_Wrap(vvs(leg,:,:), 0.50, -0.25, False) ; light local smoothing

	_mfs_dh_gc_map(FN+".gc.5m.ref100.v4","","Geostrophic currents at 5 m, m/s",mreas(leg),"BlGrYeOrReVi200", \
	vus(leg,:,:),vvs(leg,:,:),vdhs(leg,:,:),0.05,0.005,2,0.04)

end do

exit

MODEL_ROOT_DIR = "/Volumes/LaCie1TB/DATA/MREA14/Ocean_model_outputs/analyses/"
MODEL_ROOT_DIR = ""
nz =  72
NY = 253
NX = 871

sshs = new((/NMODEL,ny,nx/),float)
DHs  = new((/NMODEL,ny,nx/),double)
RHOs = new((/NMODEL,nz,ny,nx/),double)
Ps   = new((/NMODEL,nz,ny,nx/),double)
Ts   = new((/NMODEL,nz,ny,nx/),float)
Ss   = new((/NMODEL,nz,ny,nx/),float)
Us = new((/ny,nx/),double)
Vs = new((/ny,nx/),double)
Ws = new((/ny,nx/),double)

do iz = 0,nz-1
	Ps(:,iz,:,:) = doubletofloat(depth2pres(mygdept_0(iz),MYLAT))
end do

yyyymmdda  = 20141000
;yyyymmdda  = 20141001
yyyymmddb  = 20141010
;yyyymmddb  = 20141001

do model = modelMFS_SYS4E,modelMFS_SYS4E_MREA14

	modelname = modelfiles(model)
	MODEL_DIR = MODEL_ROOT_DIR+"MFS_"+modelname+"/"


	do yyyymmdd = yyyymmdda,yyyymmddb

		yyyymmdd1 = where(yyyymmdd.eq.20141000,20140930,yyyymmdd)
		yyyymmdd2 = yyyymmdd+1
		NCFN = "mfs_sys4e_"+yyyymmdd1+"_"+yyyymmdd2+"_a_"

		fnt = MODEL_DIR+NCFN+"T.nc"
		fnu = MODEL_DIR+NCFN+"U.nc"
		fnv = MODEL_DIR+NCFN+"V.nc"

		ft = addfile(fnt,"r")
		fu = addfile(fnu,"r")
		fv = addfile(fnv,"r")

		Us(model,:,:,:) = (/ft->vozocrtx(0,:,iya:iyb,ixa:ixb)/)
		Vs(model,:,:,:) = (/ft->vomecrty(0,:,iya:iyb,ixa:ixb)/)
		Us(model,:,:,:) = where(abs(Us(model,:,:,:)).gt.999,0,Us(model,:,:,:))
		Vs(model,:,:,:) = where(abs(Vs(model,:,:,:)).gt.999,0,Vs(model,:,:,:))
		Us(model,:,:,0:nx-2) = 0.5*(Us(model,:,:,0:nx-2)+Us(model,:,:,1:nx-1))
		Vs(model,:,:,0:ny-2) = 0.5*(Vs(model,:,0:ny-2,:)+Vs(model,:,1:ny-1),:)
		Ws(model,:,:,:) = sqrt(Us(model,:,:,:)^2+Vs(model,:,:,:)^2)
	_mfs_vmap(FN+"_gc","","Geostrophical currents at 10 m, m/s",legnames(leg),"WhiteBlueGreenYellowRed", \
	vus(leg,:,:),vvs(leg,:,:),vws(leg,:,:),0.0,0.1,0.01,2)


		Ts(model,:,:,:) = (/ft->votemper(0,:,iya:iyb,ixa:ixb)/)
		Ss(model,:,:,:) = (/ft->vosaline(0,:,iya:iyb,ixa:ixb)/)
		RHOs(model,:,:,:) = sw_dens(Ts(model,:,:,:),Ss(model,:,:,:),Ps(model,:,:,:))
		DHs(model,:,:) = 0.d
		do iz = KZA,KZB
			DHs(model,:,:) = DHs(model,:,:) + 1./RHOs(model,iz,:,:) * ( Ps(model,iz+1,:,:)-Ps(model,iz,:,:) )
		end do
		dh = (/DHs(model,:,:)/) / G * 1e4 ; 1e4 - db->Pa
		dh = where(mytmasks(KZB,:,:).ne.0,dh,dh@_FillValue)
		dh = dh-avg(dh)
		_assign2d(dh,mytlats,mytlons)
;		dh = dh*1e2 ; cm
		FN = modelname+"_"+yyyymmdd1+"_"
tmp = Ts(model,3,:,:)
_assign2d(tmp,mytlats,mytlons)
;printMinMax(tmp,True)
;_mfs_map(FN+"t10","",modelname+" temperature at 10 m, PSU",""+yyyymmdd,"BlAqGrYeOrReVi200",tmp,22.,25.5,0.1,5)
delete(tmp)
;continue
tmp = Ss(model,3,:,:)
_assign2d(tmp,mytlats,mytlons)
;printMinMax(tmp,True)
;_mfs_map(FN+"s10","",modelname+" salinity at 10 m, PSU",""+yyyymmdd,"BlAqGrYeOrReVi200",tmp,37.8,38.7,0.05,2)
delete(tmp)
;continue
		if model.eq.modelMFS_SYS4E then
;			_mfs_map(FN+"dh","",modelname+" dynamic height, m",""+yyyymmdd,"BlGrYeOrReVi200",dh,-0.1,0.1,0.01,2)
		else
;			_mfs_map(FN+"dh","",modelname+" dynamic height, m",""+yyyymmdd,"BlGrYeOrReVi200",dh,-0.2,0.2,0.02,5)
			_mfs_map(FN+"dh","",modelname+" dynamic height, m",""+yyyymmdd,"BlGrYeOrReVi200",dh,-0.05,0.05,0.005,2)
		end if
;		dh = dh*1e-2 ; m
		Us(0:ny-2,:) = -1./factor * (dh(1:ny-1,:)-dh(0:ny-2,:))/DY
		Vs(:,0:nx-2) =  1./factor * (dh(:,1:nx-1)-dh(:,0:nx-2))/DX
		Wavg = sqrt(avg(Us^2+Vs^2))
;print(""+DX+ " "+DY)
print(""+Wavg+ " m/s")
;exit
;continue
;print(avg(dh))
;ix = nx/2-1
;iy = ny/2-1
;iz = 14
;print(Ts(model,iz,iy,ix))
;print(Ss(model,iz,iy,ix))
;print(Ps(model,iz,iy,ix))
;print(RHOs(model,iz,iy,ix))
;print(DHs(model,iy,ix))
;		printVarSummary(ssh)
;		printMinMax(ssh,True)
;printMinMax(dh,True)
;print(dh)

continue

		sshs(model,:,:) = (/ft->sossheig(0,iya:iyb,ixa:ixb)/)
		ssh = (/sshs(model,:,:)/)
;		printMinMax(ssh,True)
		_assign2d(ssh,mytlats,mytlons)
;		printVarSummary(ssh)
;		printMinMax(ssh,True)
		FN = modelname+"_"+yyyymmdd+"_"
		_mfs_map(FN+"ssh","",modelname+" SSH, m",""+yyyymmdd,"BlGrYeOrReVi200",ssh,-0.5,-0.3,0.01,5)
		if model.eq.modelMFS_SYS4E_MREA14 then
			ssh = ssh-sshs(modelMFS_SYS4E,:,:)
;			printMinMax(ssh,True)
			_assign2d(ssh,mytlats,mytlons)
	;		printVarSummary(ssh)
;			printMinMax(ssh,True)
			FN = "model_diff_"+yyyymmdd+"_"
			_mfs_map(FN+"ssh","","Model difference SSH, m",""+yyyymmdd,"BlueWhiteOrangeRed",ssh,-0.2,0.2,0.02,5)
		end if
;BlGrYeOrReVi200
;BlAqGrYeOrReVi200
;exit
	end do ; yyyymmdd

end do ; model

_log_finish()

exit

        mfslons = f->lon
        mfslats = f->lat
        mfsdepths = f->depth
        _check(dimsizes(mfslons).eq.MFSNX,"wrong mfs_nx")
        _check(dimsizes(mfslats).eq.MFSNY,"wrong mfs_ny")
        _check(dimsizes(mfsdepths).eq.MFSNZ,"wrong mfs_nz")
        MFSAX = mfslons(0)
        MFSBX = mfslons(MFSNX-1)
        MFSAY = mfslats(0)
        MFSBY = mfslats(MFSNY-1)
        MFSDX = (MFSBX-MFSAX)/(MFSNX-1)
        MFSDY = (MFSBY-MFSAY)/(MFSNY-1)
        mapia = doubletointeger(floor((maplona-MFSAX)/MFSDX))-1
        mapja = doubletointeger(floor((maplata-MFSAY)/MFSDY))-1
        mapib = doubletointeger(ceil((maplonb-MFSAX)/MFSDX))+1
        mapjb = doubletointeger(ceil((maplatb-MFSAY)/MFSDY))+1
        modellons = mfslons(mapia:mapib)
        modellats = mfslats(mapja:mapjb)




ITIME = LEG

MAPDIR = "mfs_maps/"
_check_dir_exists(MAPDIR)

MFSDIR = "mfs/"
_check_file_exists(MFSDIR)

prefix = "-MFSs4e-MED-"
suffix = "_an-fv05.00.nc"

NMAPTIME = 4
maptimeas = (/20141008,20141002,20141009,20141005/)
maptimebs = (/20141008,20141003,20141010,20141005/)
mapnames = (/"CS-1", "LS-1", "LS-2", "MG-1"/)
mapfiles = (/"CS1",  "LS1",  "LS2",  "MG1"/)

NMFSIZS = 4
mfsizs = (/3,7,11,21/)
mfszinames = (/10,30,50,150/)
mfszas = new(NMFSIZS,float)
mfszbs = new(NMFSIZS,float)
mfszas = (mfs_depths(mfsizs-0)+mfs_depths(mfsizs-1))/2
mfszbs = (mfs_depths(mfsizs+1)+mfs_depths(mfsizs+0))/2
print(mfs_depths(mfsizs)+TAB+((mfszas+mfszbs)/2)+TAB+mfszas+TAB+mfszbs)

mfsvs = new((/NVAR,MFSNZ,MFSNY,MFSNX/),float)

;printVarSummary(mfsvs)
;exit

;do itime = 0,NMAPTIME-1
do itime = ITIME,ITIME
  _log(mapnames(itime))
	nday = maptimebs(itime)-maptimeas(itime)+1
  mfsvs = 0
	do iday = 0,nday-1
		ymd = maptimeas(itime)+iday
		sdayb = where(ymd.le.20141006,"b20141014","b20141021")
		do ivar = varT,varU
			fn = ""+ymd+"_dm-INGV--"+varmfsfiles(ivar)+prefix+sdayb+suffix
			ffn = "mfs/"+fn
      _check_file_exists(ffn)
			f = addfile(ffn,"r")
      if .not.isvar("mfslons") then
        mfslons = f->lon
        mfslats = f->lat
        mfsdepths = f->depth
        _check(dimsizes(mfslons).eq.MFSNX,"wrong mfs_nx")
        _check(dimsizes(mfslats).eq.MFSNY,"wrong mfs_ny")
        _check(dimsizes(mfsdepths).eq.MFSNZ,"wrong mfs_nz")
        MFSAX = mfslons(0)
        MFSBX = mfslons(MFSNX-1)
        MFSAY = mfslats(0)
        MFSBY = mfslats(MFSNY-1)
        MFSDX = (MFSBX-MFSAX)/(MFSNX-1)
        MFSDY = (MFSBY-MFSAY)/(MFSNY-1)
        mapia = doubletointeger(floor((maplona-MFSAX)/MFSDX))-1
        mapja = doubletointeger(floor((maplata-MFSAY)/MFSDY))-1
        mapib = doubletointeger(ceil((maplonb-MFSAX)/MFSDX))+1
        mapjb = doubletointeger(ceil((maplatb-MFSAY)/MFSDY))+1
        modellons = mfslons(mapia:mapib)
        modellats = mfslats(mapja:mapjb)
      end if
      if ivar.eq.varSSH then
        mfsvs(varSSH,0,:,:) = mfsvs(varSSH,0,:,:) \
          +f->$varmfsvars(varSSH)$(0,:,:)
      else
        mfsvs(ivar,:,:,:) = mfsvs(ivar,:,:,:) \
          +f->$varmfsvars(ivar)$(0,:,:,:)
      end if
;print(f)
;exit
		end do ; ivar
	end do ; iday
  mfsvs = mfsvs/nday

 ; if ivar.eq.varSSH then
  if True then
    modelv2d = mfsvs(varSSH,0,mapja:mapjb,mapia:mapib)
    mapt = linint2_Wrap(modellons,modellats,modelv2d,False,maplons,maplats,0)
    _assign_map_data(mapt)
    fn = MAPDIR+"ssh_test"
    wks  = gsn_open_wks("ps",fn)
    gsn_define_colormap(wks,"BlAqGrYeOrReVi200")
    ;  plot = gsn_csm_map(wks,res)   ; Create map, but don't draw it yet.
    plot = gsn_csm_contour_map(wks,mapt,resmap)
    ; gsn_polymarker(wks,plot,loclons(1),loclats(1),restxt)
    draw(plot)
      gsn_polymarker(wks,plot,stalons(0:NSTA-1),stalats(0:NSTA-1),restxt)
if False then
;if DO_MAP_LABELS then
  do ista = 0,NSTA-1
    if var.eq.varT then
      vsta = vt1(ista)
      svsta = sprintf("%0.2f",vsta)
    else
      vsta = vs1(ista)
      svsta = sprintf("%0.2f",vsta)
    end if
;printVarSummary(vt1)
;printVarSummary(vsta)
;printVarSummary(svsta)
;print(v)
;print(sv)
;exit
    if .not.ismissing(vsta) then
      gsn_text(wks,plot,svsta,stalons(ista),stalats(ista)+textshift,restxt)
    end if
  end do
end if
      frame(wks)
      delete(wks)
      system("ps2epsi "+fn+".ps "+fn+".eps")
      system("convert -density "+MAP_DPI+" -trim "+fn+".eps -bordercolor White -border "+MAP_MARGIN+"x"+MAP_MARGIN+" "+fn+".png")
      system("rm "+fn+".ps")
_log(fn)
;exit
    delete(modelv2)
  end if

end do ; itime

_log_finish()
exit

; ===========================

fn1 = "txts/LS1_0000_0005.txt"
txt1 = asciiread(fn1,-1,"string")
n1 = dimsizes(txt1)
lats1 = new(n1,double)
lons1 = new(n1,double)
do i = 0,n1-1
	s = txt1(i)
	slon = str_get_field (s,2,TAB)
	slat = str_get_field (s,3,TAB)
	lons1(i) = stringtodouble(slon)
	lats1(i) = stringtodouble(slat)
end do

fn2 = "txts/LS2_0000_0005.txt"
txt2 = asciiread(fn2,-1,"string")
n2 = dimsizes(txt2)
lats2 = new(n2,double)
lons2 = new(n2,double)
do i = 0,n2-1
	s = txt2(i)
	slon = str_get_field (s,2,TAB)
	slat = str_get_field (s,3,TAB)
	lons2(i) = stringtodouble(slon)
	lats2(i) = stringtodouble(slat)
end do

restxt1 = True
restxt1@gsMarkerSizeF = 0.012
restxt1@gsMarkerIndex = 16
restxt1@gsMarkerColor = "red"
restxt1@gsMarkerColor = "tomato"

restxt2 = True
restxt2@gsMarkerSizeF = 0.012
restxt2@gsMarkerIndex = 16
restxt2@gsMarkerColor = "deepskyblue"
restxt2@gsMarkerColor = "turquoise"



DIR = "currents_maps/"

ymda = 20141001
ymdb = 20141011
symds = "2014.10."+(/"01","02","03","04","05","06","07","08","09","10","11"/)

NIZ = 2
IZS = (/0,2/)
ZNAMES = (/"1.5 m", "8 m"/)
ZFILES = (/"_1.5m", "_8m"/)

  med_lat_min = 39.4
  med_lat_max = 40.6
  med_lon_min = 16.4
  med_lon_max = 18.1
  ion_lat_min = 39.4
  ion_lat_max = 40.6
  ion_lon_min = 16.4
  ion_lon_max = 18.1


  res = True

	res@gsnDraw       = False          ; do not draw
  res@gsnFrame      = False          ; do not advance

  res@gsnAddCyclic = False
;;;  res@gsnMaximize  = True
;;;  res@gsnPaperOrientation = "Landscape"
  res@gsnSpreadColors       = True
  res@gsnSpreadColorEnd     = -1
  res@gsnSpreadColorStart   =  1
  res@gsnLeftString   = "Currents at 5m, m/s"
  res@gsnRightString  = "1987-2007"


  res@gsnLeftStringFontHeightF     = 0.010
  res@gsnLeftStringOrthogonalPosF  = 0.005
  res@gsnRightStringFontHeightF    = 0.010
  res@gsnRightStringOrthogonalPosF = 0.008
;  res@gsnRightStringParallelPosF   = 0.95



  res@mpDataBaseVersion = "HighRes" ; "HighRes"
  res@mpDataResolution  = "Finest"  ; "Medium" ;
  res@mpProjection = "Mercator"
  res@mpLimitMode  = "LatLon"
  res@mpOutlineOn  =  True
 res@mpFillOn  =  False
  res@mpMinLatF = med_lat_min
  res@mpMaxLatF = med_lat_max
  res@mpMinLonF = med_lon_min
  res@mpMaxLonF = med_lon_max
  res@mpGridAndLimbOn =  False
  res@mpGridLineThicknessF = 0.0
  res@mpLandFillColor =  (/.96,.87,.7/)
 ; res@mpGeophysicalLineColor  =  (/.44,.44,.44/)
  res@mpGeophysicalLineColor  =  "black"
  res@mpGeophysicalLineThicknessF = 0.3


  res@pmTickMarkDisplayMode    = "Always"
  res@pmLabelBarWidthF         =  0.5
  res@pmLabelBarHeightF        =  0.05
  res@pmLabelBarOrthogonalPosF =  -0.02      ; !!!!!!!!!!!!!!!!!!!

  res@lbAutoManage          = False             ; we control label bar
  res@lbLabelFontHeightF    = 0.009             ; default is HUGE
  res@lbPerimOn             = False             ; default has box

  res@cnFillOn               =  True               ; turn on color
  res@cnLinesOn              =  False              ; turn off contour lines
  res@cnLineLabelsOn         =  False              ; turn off contour line labels
 ; res@cnFillDrawOrder        = "PreDraw"
  res@cnLevelSelectionMode   = "ManualLevels"      ; set manual contour levels
  res@cnLevelSpacingF        = 0.2                 ; set contour spacing


;  res@tmLabelAutoStride      = True
  res@tmXTOn       = True
  res@tmYROn       = True
  res@tmXBMajorLengthF       = 0.002
  res@tmYLMajorLengthF       = 0.002
  res@tmXBMinorLengthF       = 0.001
  res@tmYLMinorLengthF       = 0.001
  res@tmXTMajorLengthF       = 0.002
  res@tmYRMajorLengthF       = 0.002
  res@tmXTMinorLengthF       = 0.001
  res@tmYRMinorLengthF       = 0.001
  res@tmXBLabelFontHeightF   = 0.007
  res@tmYLLabelFontHeightF   = 0.007

  res@gsnScalarContour = True
  res@gsnScalarContour = False ; !!!!!!

  res@vcGlyphStyle            = "CurlyVector" ; "LineArrow"
  res@vcLineArrowColor        = "black"           ; change vector color
 ; res@vcVectorDrawOrder       = "PostDraw"        ; draw vectors last
  res@vcRefAnnoOn             = False
;;;;;  res@vcLineArrowHeadMaxSizeF = 0.002
  res@vcLineArrowHeadMaxSizeF = 0.002

;;;;;  res@vcRefMagnitudeF = 1.0           ; define vector ref mag
  res@vcRefMagnitudeF = 0.8          ; define vector ref mag
  res@vcRefLengthF    = 0.1           ; define length of vec ref
;;;;;;;;;;  res@vcMinDistanceF  = 0.008  ;0.012
  res@vcMinDistanceF  = 0.008  ;0.012
  res@cnLevelSpacingF = 0.01
  res@lbLabelStride   = 5
  res@cnMinLevelValF  = 0.
;;;;;;;;;;;  res@cnMaxLevelValF  = 0.4
  res@cnMaxLevelValF  = 0.35
;;;;;;;;;  res@vcLineArrowThicknessF   = 1.5                ; change vector thickness
  res@vcLineArrowThicknessF   = 1.4                ; change vector thickness

;;;;;;  res@gsnSpreadColorEnd    = -5               ; don't use land color
;;;;;;  res@gsnSpreadColorStart  = 65                ; start at color 17

  res@pmLabelBarDisplayMode    = "Always"      ; turns on label bar
  res@pmLabelBarDisplayMode    = "Never"      ; turns on label bar
  res@pmLabelBarOrthogonalPosF =  0.053        ; !!!!!!!!!!!!!!!!!!!

  res@gsnLeftStringFontHeightF     = 0.015
  res@gsnLeftStringOrthogonalPosF  = 0.010
  res@gsnRightStringFontHeightF    = 0.016
  res@gsnRightStringOrthogonalPosF = 0.011
  res@tmXBLabelFontHeightF   = 0.009
  res@tmYLLabelFontHeightF   = 0.009

  res@lbLabelFontHeightF    = 0.010


  res@mpGridAndLimbOn =  True
  res@mpGridAndLimbOn =  False ; !!!!!!
  res@mpGridLineThicknessF = 0.3
  res@mpGridLineColor = (/0.5,0.5,0.5/)
  res@mpGridLineColor = (/0.0,0.0,0.0/)
  res@mpGridLatSpacingF = 1.
  res@mpGridLonSpacingF = 1.

  res@mpMinLatF = ion_lat_min
  res@mpMaxLatF = ion_lat_max
  res@mpMinLonF = ion_lon_min
  res@mpMaxLonF = ion_lon_max

  res@pmLabelBarOrthogonalPosF =  0.015      ; !!!!!!!!!!!!!!!!!!! if RefAnnoOn

	res@vcRefAnnoOn = True
	res@vcRefAnnoPerimOn = False
	res@vcRefAnnoPerimSpaceF = 0.5
	res@vcRefAnnoOrthogonalPosF = -0.95
	res@vcRefAnnoParallelPosF   =  0.97
	res@vcRefAnnoFontHeightF    = 0.014
  res@vcRefLengthF            = 0.05

	res@cnInfoLabelOn   = False


		res@vcRefMagnitudeF = 0.1
		res@vcRefAnnoString1 = "0.1 m/s"
		res@vcMinDistanceF  = 0.022
		res@vcLineArrowHeadMaxSizeF = 0.010
		res@vcLineArrowHeadMinSizeF = 0.005
		res@vcLineArrowThicknessF   = 1.2

do ymd = ymda,ymdb

	suffix = where(ymd.le.20141006,"b20141014","b20141021")
	fn = ""+ymd+"_dm-INGV--RFVL-MFSs4d-MED-"+suffix+"_an-fv04.00.nc"
	ffn = "mfs/"+fn
	f = addfile(ffn,"r")
	do iz = 0,NIZ-1
		IZ = IZS(iz)
		u = f->vozocrtx(0,IZ,:,:)
		v = f->vomecrty(0,IZ,:,:)
		w = u
		w = sqrt(u*u+v*v)
		fn = DIR+ymd+ZFILES(iz)
		dpi = 144
  res@gsnLeftString   = "Currents at "+ZNAMES(iz)
  res@gsnRightString  = symds(ymd-ymda)
		res@gsnDraw       = False          ; do not draw
		res@gsnFrame      = False          ; do not advance
		res@lbLabelBarOn = True
		res@cnFillDrawOrder = "PreDraw"
		res@mpFillDrawOrder = "PreDraw"
		res@vcVectorDrawOrder = "PostDraw"
		wks = gsn_open_wks("ps",fn)
		gsn_define_colormap(wks,"WhiteBlueGreenYellowRed")
;;;;		plot = gsn_csm_vector_scalar_map(wks,u,v,w,res)
		plot = gsn_csm_vector_map(wks,u,v,res)
;		restxt@tfPolyDrawOrder = "PostDraw"
;		restxt@gsMarkerSizeF = 0.007
;		m0 = gsn_add_polymarker(wks,plot,loclons(0),loclats(0),restxt)
;		m1 = gsn_add_polymarker(wks,plot,loclons(1),loclats(1),restxt)
		m1 = gsn_add_polymarker(wks,plot,lons1,lats1,restxt1)
		m2 = gsn_add_polymarker(wks,plot,lons2,lats2,restxt2)
		draw(plot)
		frame(wks)
		delete(wks)
		system("ps2epsi "+fn+".ps "+fn+".eps")
		system("convert -density "+dpi+" -trim "+fn+".eps -bordercolor White -border 20x20 "+fn+".png")
		system("rm "+fn+".ps")
		_log(fn)
	end do

end do

_log_finish()