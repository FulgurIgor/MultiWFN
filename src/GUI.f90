module GUI
use plot
implicit real*8(a-h,o-z)
!Used for sharing dislin id between various GUI routines
integer iatm1text,iatm2text,iatm3text,iatm4text,igeomresult
integer idisisosurnumpt,idisisosurdef,idisisosurgood,idisisosurhigh,idisisosurveryhigh,idisisosurperfect

contains

!!--------- Select input file by GUI
subroutine selfilegui
CALL dwgfil("Choose an input file (.wfn/.wfx/.fch/.molden/.31/.chg/.pdb/.xyz/.mol/.cub, etc.)",filename,"*")
end subroutine

!!--------- A GUI for drawing molecular structure and orbital isosurface
subroutine drawmolgui
character ictmp*4,molorblist*50000 !max 9999 orbitals (the 0th is "none"), each one take up 4 characters, adding "|",so 10000*(4+1)=50000
isavepic=0
! Set variables for viewing orbital
molorblist(1:4)="None"
molorblist(5:)=" "
do i=1,nmo
	write(ictmp,"(i4)") i
	molorblist(i*5+1:i*5+5)="|"//ictmp
end do
GUI_mode=1
idrawmol=1 !Molecular structure must be drawn
CALL swgtit('Molecular structure / Orbital isosurfaces')
if (imodlayout==2) then
	call swgwth(80)
	!The main window will appear at left-upper corner
else
	call swgwth(plotwinsize3D)
	CALL SWGOPT("CENTER","POSITION") !Main window appear in the center of screen
end if
call SWGPOP("NOOK")  !Don't show OK&QUIT&HELP in upper menu
call SWGPOP("NOQUIT")
call SWGPOP("NOHELP")
CALL WGINI('HORI',idiswindow)
call swgatt(idiswindow,"INACTIVE","CLOSE") !Disable close button
call swgatt(idiswindow,"OFF","MAXI") !Disable maximization button
CALL WGPOP(idiswindow,"Orbital info.",idisorbinfomenu)
call wgapp(idisorbinfomenu,"Show all",idisorbinfo)
if ((wfntype==0.or.wfntype==1.or.wfntype==2).and.allocated(CObasa)) then
	call wgapp(idisorbinfomenu,"Show up to LUMO+10",idisorbinfo2)
	call wgapp(idisorbinfomenu,"Show occupied orbitals",idisorbinfo3)
end if
CALL WGPOP(idiswindow," Isosur#1 style",idisisosur1style)
call wgapp(idisisosur1style,"Use solid face",idisisosur1solid)
call wgapp(idisisosur1style,"Use mesh",idisisosur1mesh)
call wgapp(idisisosur1style,"Use points",idisisosur1point)
call wgapp(idisisosur1style,"Use solid face+mesh",idisisosur1solidmesh)
call wgapp(idisisosur1style,"Use transparent face",idisisosur1tpr)
call wgapp(idisisosur1style,"Set color for face",idisisosur1solidclr)
call wgapp(idisisosur1style,"Set color for mesh and points",idisisosur1meshptclr)
call wgapp(idisisosur1style,"Set opacity for transparent face",idisisosur1opa)
call wgapp(idisisosur1style,"Exchange positive and negative colors",idisisosur1invclr)
CALL WGPOP(idiswindow," Isosur#2 style",idisisosur2style)
call wgapp(idisisosur2style,"Use solid face",idisisosur2solid)
call wgapp(idisisosur2style,"Use mesh",idisisosur2mesh)
call wgapp(idisisosur2style,"Use points",idisisosur2point)
call wgapp(idisisosur2style,"Use solid face+mesh",idisisosur2solidmesh)
call wgapp(idisisosur2style,"Use transparent face",idisisosur2tpr)
call wgapp(idisisosur2style,"Set color for face",idisisosur2solidclr)
call wgapp(idisisosur2style,"Set color for mesh and points",idisisosur2meshptclr)
call wgapp(idisisosur2style,"Set opacity for transparent face",idisisosur2opa)
CALL WGPOP(idiswindow," Isosur. quality",idisisosurquality)
call wgapp(idisisosurquality,"Set number of grid points",idisisosurnumpt)
call wgapp(idisisosurquality,"Default (fast, 120k points)",idisisosurdef)
call wgapp(idisisosurquality,"good quality (300k points)",idisisosurgood)
call wgapp(idisisosurquality,"High quality (500k points)",idisisosurhigh)
call wgapp(idisisosurquality,"Very high quality (1000k points)",idisisosurveryhigh)
call wgapp(idisisosurquality,"Perfect quality (1500k points)",idisisosurperfect)
CALL WGPOP(idiswindow,"Set perspective",idissetpersp)
CALL wgapp(idissetpersp,"Set rotation angle",idissetangle)
CALL wgapp(idissetpersp,"Set zoom distance",idissetzoom)
CALL WGPOP(idiswindow,"Other settings",idisotherset)
CALL wgapp(idisotherset,"Set extension distance",idisextdist)
CALL wgapp(idisotherset,"Set isovalue",idissetorbisovalue)
CALL wgapp(idisotherset,"Set lightings",idissetlight)
CALL wgapp(idisotherset,"Set atomic label type",idisatmlabtyp)
CALL wgapp(idisotherset,"Set atomic label color",idisatmlabclr)
CALL wgapp(idisotherset,"Use CPK style",idisuseCPK)
CALL wgapp(idisotherset,"Use vdW style",idisusevdW)
CALL wgapp(idisotherset,"Use line style",idisuseline)
CALL wgapp(idisotherset,"Toggle showing hydrogens",idisshowhydrogen)
CALL wgapp(idisotherset,"Set atom highlighting",idishighlightatom)
CALL WGPOP(idiswindow,"Tools",idistools)
CALL wgapp(idistools,"Write settings to GUIsettings.ini",idiswriteGUIsetting)
CALL wgapp(idistools,"Load settings from GUIsettings.ini",idisloadGUIsetting)
CALL wgapp(idistools,"Measure geometry",idismeasure)
CALL wgapp(idistools,"Batch plotting orbitals",idisbatchplot)
CALL wgapp(idistools,"Select fragment",idisselfrag)
if (imodlayout==2) call swgdrw(0.9D0) !Set height of drawing widget 0.9*width to make it fully shown
CALL WGDRAW(idiswindow,idisgraph) !Draw-widget to display molecular structure
CALL SWGWTH(20) !Set parent widget width
CALL SWGSPC(1.3D0,0.0D0) !Set space between widgets below
CALL WGBAS(idiswindow,"VERT",idisright)
if ((isys==1.and.imodlayout==1).or.isys==2) CALL WGBAS(idiswindow,"VERT",idisright2) !Provide another frame for linux version
call wgpbut(idisright,"RETURN",idisreturn)
call wgpbut(idisright,"Up",idisrotup)
call wgpbut(idisright,"Down",idisrotdown)
call wgpbut(idisright,"Left",idisrotleft)
call wgpbut(idisright,"Right",idisrotright)
call wgpbut(idisright,"Zoom in",idiszoomin)
call wgpbut(idisright,"Zoom out",idiszoomout)
call wgpbut(idisright,"Reset view",idisreset)
call wgpbut(idisright,"Save picture",idissavepic)
call wgbut(idisright,"Show labels",ishowatmlab,idisshowatmlab)
call wgbut(idisright,"Show axis",ishowaxis,idisshowaxis)
call wgbut(idisright,"Show+Sel. isosur#2",isosursec,idisisosursec)
call swgatt(idisisosursec,"INACTIVE","STATUS") !User cannot select isosurface 2 when just entered this GUI, it must be activated by selecting an orbital
if (imodlayout<=1) then !When imodlayout=2, make below widgets invisible to ensure the orbital selection box can be shown
	call SWGSTP(0.05D0)
	call wgscl(idisright,"Bonding threshold",0.0D0,5.0D0,1.15D0,2,idisbondcrit)
end if
call SWGSTP(0.1D0)
call wgscl(idisright,"Ratio of atomic size",0.0D0,5.0D0,1.0D0,2,idisatmsize)
if (imodlayout<=1) then
	call SWGSTP(0.02D0)
	call wgscl(idisright,"Radius of bonds",0.0D0,1.0D0,0.2D0,2,idisbondradius)
end if
call SWGSTP(3.0D0)
call wgscl(idisright,"Size of atomic labels",0.0D0,100.0D0,38.0D0,0,idislabelsize)
CALL SWGSPC(0.0D0,0.0D0)
sur_value=0.05D0
if (isys==1.and.(imodlayout==0.or.imodlayout==2)) then
	!Set region for orbital viewing
	call WGLAB(idisright,"Orbitals:",iorbseltext)
	CALL WGBAS(idisright,"FORM",idisbotrig)
	!Set orbital selection list
	call swgwin(0,5,90,130)
	call swgtyp("VSCROLL","LIST") !This is neccessary, else some latter orbitals cannot be displayed on the list
	CALL WGLIS(idisbotrig,molorblist,1,iorblis)
	call WGTXT(idisright,"  0 ",iorbtxt)
! 	call swgatt(iorbtxt,"INVISIBLE","STATUS")
	!Set progress bar
	call swgopt("SMOOTH","PBAR")
	call swgclr(0D0,0D0,1D0,"PBAR")
	call swgtyp("VERT","PBAR")
	call swgwin(78,5,15,115)
	!Set scale bar of isosurvalue
	call swgwin(100,5,70,115)
	call swgtyp("VERT","SCALE")
	call swgstp(0.002D0)
	call wgscl(idisbotrig,"Isovalue",0D0,0.4D0,sur_value,3,idisisosurscl)
else if ((isys==1.and.imodlayout==1).or.isys==2) then !Use different layout for linux, since the sizes of widgets relative to Windows version are different
	CALL SWGSPC(0.0D0,0.5D0)
	call WGLAB(idisright2,"Orbitals:",iorbseltext)
	call swgtyp("SCROLL","LIST")
	call WGLIS(idisright2,molorblist,1,iorblis)
	call WGTXT(idisright2,"  0 ",iorbtxt)
	call swgopt("SMOOTH","PBAR")
	call swgclr(0D0,0D0,1D0,"PBAR")
	call swgtyp("HORI","PBAR")
	call swgtyp("HORI","SCALE")
	call swgstp(0.002D0)
	call wgscl(idisright2,"Isovalue of orbital",0D0,0.4D0,sur_value,3,idisisosurscl)
end if

call SWGCBK(idisorbinfo,showorbinfo)
if ((wfntype==0.or.wfntype==1.or.wfntype==2).and.allocated(CObasa)) then
	call SWGCBK(idisorbinfo2,showorbinfo2)
	call SWGCBK(idisorbinfo3,showorbinfo3)
end if
call SWGCBK(idisisosur1solid,setisosur1solid) !Set style for isosur 1
call SWGCBK(idisisosur1mesh,setisosur1line)
call SWGCBK(idisisosur1point,setisosur1point)
call SWGCBK(idisisosur1solidmesh,setisosur1solidmesh)
call SWGCBK(idisisosur1tpr,setisosur1tpr)
call SWGCBK(idisisosur1solidclr,setisosur1solidclr)
call SWGCBK(idisisosur1invclr,setisosur1invclr)
call SWGCBK(idisisosur1meshptclr,setisosur1meshptclr)
call SWGCBK(idisisosur1opa,setisosur1opa)
call SWGCBK(idisisosur2solid,setisosur2solid) !Set style for isosur 2
call SWGCBK(idisisosur2mesh,setisosur2line)
call SWGCBK(idisisosur2point,setisosur2point)
call SWGCBK(idisisosur2solidmesh,setisosur2solidmesh)
call SWGCBK(idisisosur2tpr,setisosur2tpr)
call SWGCBK(idisisosur2solidclr,setisosur2solidclr)
call SWGCBK(idisisosur2meshptclr,setisosur2meshptclr)
call SWGCBK(idisisosur2opa,setisosur2opa)
call SWGCBK(idisisosurnumpt,setisosurnumpt)
call SWGCBK(idisisosurdef,setisosurnumpt)
call SWGCBK(idisisosurgood,setisosurnumpt)
call SWGCBK(idisisosurhigh,setisosurnumpt)
call SWGCBK(idisisosurveryhigh,setisosurnumpt)
call SWGCBK(idisisosurperfect,setisosurnumpt)
call SWGCBK(idissetangle,setviewangle)
call SWGCBK(idissetzoom,setzoom)
call SWGCBK(idisextdist,setextdist)
call SWGCBK(idissetorbisovalue,setorbisovalue)
call SWGCBK(idissetlight,setlight)
call SWGCBK(idisatmlabtyp,setatmlabtyp)
call SWGCBK(idisatmlabclr,setatmlabclr)
call SWGCBK(idisuseCPK,setCPKstyle)
call SWGCBK(idisusevdW,setvdWstyle)
call SWGCBK(idisuseline,setlinestyle)
call SWGCBK(idisshowhydrogen,setshowhydrogen)
call SWGCBK(idishighlightatom,sethighlightatom)
call SWGCBK(idismeasure,measuregeom)
call SWGCBK(idiswriteGUIsetting,writeGUIsetting)
call SWGCBK(idisloadGUIsetting,loadGUIsetting)
call SWGCBK(idisbatchplot,batchplot)
call SWGCBK(idisselfrag,GUIselfrag)
call SWGCBK(idisreturn,GUIreturn)
call SWGCBK(idisrotleft,rotleft)
call SWGCBK(idisrotright,rotright)
call SWGCBK(idisrotup,rotup)
call SWGCBK(idisrotdown,rotdown)
call SWGCBK(idiszoomin,zoomin)
call SWGCBK(idiszoomout,zoomout)
call SWGCB3(idisgraph,zoominout)
call SWGCBK(idisreset,resetview)
call SWGCBK(idissavepic,savepic)
call SWGCBK(idisshowatmlab,ifshowatmlabel)
call SWGCBK(idisshowaxis,ifshowaxis)
call SWGCBK(idisisosursec,ifisosursec)
call SWGCBK(idisatmsize,setatmsize)
if (imodlayout<=1) then
	call SWGCBK(idisbondradius,setbondradius)
	call SWGCBK(idisbondcrit,setbondcrit)
end if
call SWGCBK(idislabelsize,setlabelsize)
!! Click button and calculate cube data for selected orbital
call SWGCBK(iorblis,showorbsellist)
call SWGCBK(iorbtxt,showorbselbox)
call SWGCBK(idisisosurscl,setisosurscl)
CALL SWGSPC(4.0D0,0.5D0) !Reset the default widget spacing
call swgtyp("HORI","SCALE") !Reset the default mode for list widget
idrawisosur=0 !Don't draw the cubmat in memory at first time go into the GUI
if (isys==1) call drawmol !Directly show image in Windows GUI.
!However, in linux, "draw" widget is available only after WGFIN subroutine so we need a mouse event to active it, before this, the draw widget cannot be used, this is why "if (isys==1)"
CALL WGFIN
idrawisosur=0 !After ending this GUI, recover to initial setting
isosur1style=1 !Recover to solid face
isosur2style=1
isosursec=0 !Don't draw the second isosurface
end subroutine


!!------------ A GUI for drawing relief map
subroutine drawplanegui(init1,end1,init2,end2,init3,end3,idrawtype)
real*8 init1,end1,init2,end2,init3,end3
integer,intent (in) :: idrawtype
character*20 tmpstring
GUI_mode=2
dp_init1=init1
dp_end1=end1
dp_init2=init2
dp_end2=end2
dp_init3=init3
dp_end3=end3
if (isavepic==1) then
	call drawplane(dp_init1,dp_end1,dp_init2,dp_end2,dp_init3,dp_end3,idrawtype)
else if (isavepic==0) then
	if (idrawtype==3) CALL swgtit('Relief map')
	if (idrawtype==4) CALL swgtit('Shaded surface map')
	if (idrawtype==5) CALL swgtit('Shaded surface map with projected color-filled map')
	if (imodlayout==2) then
		call swgwth(73)
	else
		CALL swgwth(96)
		CALL SWGOPT("CENTER","POSITION") !Main window appear in the center of screen
	end if
	call SWGPOP("NOOK")  !Don't show OK&QUIT in upper menu
	call SWGPOP("NOQUIT")
	call SWGPOP("NOHELP")
	CALL WGINI('HORI',idiswindow)
	call swgatt(idiswindow,"INACTIVE","CLOSE") !Disable close button	
	call swgatt(idiswindow,"OFF","MAXI") !Disable maximization button
	CALL WGDRAW(idiswindow,idisgraph) !Draw-widget to display molecular structure
	CALL SWGWTH(20) !Set parent widget width
	CALL WGBAS(idiswindow,"VERT",idisright)
	CALL WGBAS(idisright,"VERT",idisOK)
	! CALL WGBAS(idisright,"FORM",idisOK) !seems this function has bug in current dislin version
	! call swgsiz(int(iscrwidth*0.12D0),50)
	call wgpbut(idisOK,"RETURN",idisreturn)
	call wgsep(idisright,idissep2)
	call wgpbut(idisright,"Up",idisrotup)
	call wgpbut(idisright,"Down",idisrotdown)
	call wgpbut(idisright,"Left",idisrotleft)
	call wgpbut(idisright,"Right",idisrotright)
	call wgpbut(idisright,"Zoom in",idiszoomin)
	call wgpbut(idisright,"Zoom out",idiszoomout)
	call wgpbut(idisright,"Reset view",idisreset)
	write(tmpstring,"(f8.2)") XVU
	call WGLAB(idisright,"Horizontal angle:",idisXVU)
	call WGTXT(idisright,tmpstring,idissetplaneXVU)
	write(tmpstring,"(f8.2)") YVU
	call WGLAB(idisright,"Vertical angle:",idisYVU)
	call WGTXT(idisright,tmpstring,idissetplaneYVU)
	call SWGCBK(idisreturn,GUIreturn)
	call SWGCBK(idisrotleft,rotleft)
	call SWGCBK(idisrotright,rotright)
	call SWGCBK(idisrotup,rotup)
	call SWGCBK(idisrotdown,rotdown)
	call SWGCBK(idiszoomin,zoomin)
	call SWGCBK(idiszoomout,zoomout)
	call SWGCB3(idisgraph,zoominout)
	call SWGCBK(idisreset,resetview)
	call SWGCBK(idissetplaneXVU,setplaneXVU)
	call SWGCBK(idissetplaneYVU,setplaneYVU)
	if (isys==1) call drawplane(dp_init1,dp_end1,dp_init2,dp_end2,dp_init3,dp_end3,idrawtype)
	CALL WGFIN
end if
end subroutine


!!--------- A GUI for drawing isosurface
!if iallowsetstyle==1, then isosurface style can be customly controlled for isosurface 1
!if iallowsetstyle==2, then isosurface style can be customly controlled for both isosurface 1 and 2
subroutine drawisosurgui(iallowsetstyle)
integer iallowsetstyle
character*20 temp
idrawisosur=1
GUI_mode=3 !Use GUI_mode setting in dislin response routine
isavepic=0
CALL swgtit('Isosurface graph')
if (imodlayout==2) then
	call swgwth(73)
else
	CALL swgwth(96)
	CALL SWGOPT("CENTER","POSITION") !Main window appear in the center of screen
end if
call SWGPOP("NOOK")  !Don't show OK&QUIT in upper menu
call SWGPOP("NOQUIT")
call SWGPOP("NOHELP")
! CALL SWGHLP("Green region: Isosurface value|Blue region: Negative of the isosurface value|&
! The min & max value of scale bar is -5 and 5 respectively, if the inputted value exceed this range, scale bar will not change")
CALL WGINI('HORI',idiswindow)
call swgatt(idiswindow,"INACTIVE","CLOSE") !Disable close button
call swgatt(idiswindow,"OFF","MAXI") !Disable maximization button
if (iallowsetstyle==1) then
	call WGPOP(idiswindow," Isosurface style",idisisosur1style)
	call wgapp(idisisosur1style,"Use solid face",idisisosur1solid)
	call wgapp(idisisosur1style,"Use mesh",idisisosur1mesh)
	call wgapp(idisisosur1style,"Use points",idisisosur1point)
	call wgapp(idisisosur1style,"Use solid face+mesh",idisisosur1solidmesh)
	call wgapp(idisisosur1style,"Use transparent face",idisisosur1tpr)
	call wgapp(idisisosur1style,"Set color for face",idisisosur1solidclr)
	call wgapp(idisisosur1style,"Set color for mesh and points",idisisosur1meshptclr)
	call wgapp(idisisosur1style,"Exchange positive and negative colors",idisisosur1invclr)
	call wgapp(idisisosur1style,"Set opacity for transparent face",idisisosur1opa)
else if (iallowsetstyle==2) then
	call WGPOP(idiswindow," Isosurface style",idisisosurallstyle)
	call wgapp(idisisosurallstyle,"Use solid face",idisisosurallsolid)
	call wgapp(idisisosurallstyle,"Use mesh",idisisosurallmesh)
	call wgapp(idisisosurallstyle,"Use points",idisisosurallpoint)
	call wgapp(idisisosurallstyle,"Use solid face+mesh",idisisosurallsolidmesh)
	call wgapp(idisisosurallstyle,"Use transparent face",idisisosuralltpr)
end if
CALL WGPOP(idiswindow,"Set perspective",idissetpersp)
CALL wgapp(idissetpersp,"Set rotation angle",idissetangle)
CALL wgapp(idissetpersp,"Set zoom distance",idissetzoom)
CALL WGPOP(idiswindow,"Other settings",idisotherset)
CALL wgapp(idisotherset,"Set extension distance",idisextdist)
CALL wgapp(idisotherset,"Set lighting",idissetlight)
CALL wgapp(idisotherset,"Set atomic label type",idisatmlabtyp)
CALL wgapp(idisotherset,"Set atomic label color",idisatmlabclr)
CALL wgapp(idisotherset,"Use CPK style",idisuseCPK)
CALL wgapp(idisotherset,"Use vdW style",idisusevdW)
CALL wgapp(idisotherset,"Use line style",idisuseline)

CALL WGDRAW(idiswindow,idisgraph) !Draw-widget to display molecular structure
CALL SWGWTH(20) !Set parent widget width
CALL WGBAS(idiswindow,"VERT",idisright)
CALL WGBAS(idisright,"VERT",idisOK)
! CALL WGBAS(idisright,"FORM",idisOK) !seems this function has bug in current dislin version
! call swgsiz(int(iscrwidth*0.12D0),50)
CALL SWGSPC(1.3D0,0.0D0) !Set space between widgets below
call wgpbut(idisOK,"RETURN",idisreturn)
call wgpbut(idisright,"Up",idisrotup)
call wgpbut(idisright,"Down",idisrotdown)
call wgpbut(idisright,"Left",idisrotleft)
call wgpbut(idisright,"Right",idisrotright)
call wgpbut(idisright,"Zoom in",idiszoomin)
call wgpbut(idisright,"Zoom out",idiszoomout)
call wgpbut(idisright,"Reset view",idisreset)
call wgpbut(idisright,"Save picture",idissavepic)
write(temp,"(f10.5)") sur_value
! call WGLTXT(idisright,"Min:",temp1,70,idisscrmin) !Sadly, up to now dislin don't have routine can change scale widget min&max value
! call WGLTXT(idisright,"Max:",temp2,70,idisscrmax)
call WGLAB(idisright,"Isosurface value:",idislabel)
call WGTXT(idisright,temp,idisscrval)
if (isosursec==0) call wgbut(idisright,"Show both sign",isosurshowboth,idisshowbothsign) !When showing two grid data, this option is meaningless
call wgbut(idisright,"Show molecule",idrawmol,idisshowmol)
call wgbut(idisright,"Show atomic labels",ishowatmlab,idisshowatmlab)
call wgbut(idisright,"Show axis",ishowaxis,idisshowaxis)
call wgbut(idisright,"Show data range",ishowdatarange,idisshowdatarange)
call wgbut(idisright,"Show isosurface",idrawisosur,idisshowisosur)
call swgstp(0.01D0) !Use smaller step size of scale bar than default
if (sur_value>5) then !Do not let sur_value exceed axis range
	call wgscl(idisright,"Isosurface value",-5D0,5D0,5D0,4,idisisosurscl)
else if (sur_value<-5) then
	call wgscl(idisright,"Isosurface value",-5D0,5D0,-5D0,4,idisisosurscl)
else
	call wgscl(idisright,"Isosurface value",-5D0,5D0,sur_value,4,idisisosurscl)
end if
if (imodlayout<=1) then
	call SWGSTP(0.05D0)
	call wgscl(idisright,"Bonding threshold",0.0D0,5.0D0,1.15D0,2,idisbondcrit)
	call SWGSTP(0.02D0)
	call wgscl(idisright,"Radius of bonds",0.0D0,2.0D0,0.2D0,2,idisbondradius)
end if
call SWGSTP(0.1D0)
call wgscl(idisright,"Ratio of atomic size",0.0D0,5.0D0,1.0D0,2,idisatmsize)
call SWGSTP(3.0D0)
call wgscl(idisright,"Size of atomic labels",0.0D0,200.0D0,38.0D0,0,idislabelsize)
CALL SWGSPC(4.0D0,0.5D0) !Reset the default widget spacing

if (iallowsetstyle==1) then
	call SWGCBK(idisisosur1solid,setisosur1solid)
	call SWGCBK(idisisosur1mesh,setisosur1line)
	call SWGCBK(idisisosur1point,setisosur1point)
	call SWGCBK(idisisosur1solidmesh,setisosur1solidmesh)
	call SWGCBK(idisisosur1tpr,setisosur1tpr)
	call SWGCBK(idisisosur1solidclr,setisosur1solidclr)
	call SWGCBK(idisisosur1invclr,setisosur1invclr)
	call SWGCBK(idisisosur1meshptclr,setisosur1meshptclr)
	call SWGCBK(idisisosur1opa,setisosur1opa)
else if (iallowsetstyle==2) then
	call SWGCBK(idisisosurallsolid,setisosurallsolid)
	call SWGCBK(idisisosurallmesh,setisosurallline)
	call SWGCBK(idisisosurallpoint,setisosurallpoint)
	call SWGCBK(idisisosurallsolidmesh,setisosurallsolidmesh)
	call SWGCBK(idisisosuralltpr,setisosuralltpr)
end if
call SWGCBK(idissetangle,setviewangle)
call SWGCBK(idissetzoom,setzoom)
call SWGCBK(idisextdist,setextdist)
call SWGCBK(idissetlight,setlight)
call SWGCBK(idisatmlabtyp,setatmlabtyp)
call SWGCBK(idisatmlabclr,setatmlabclr)
call SWGCBK(idisuseCPK,setCPKstyle)
call SWGCBK(idisusevdW,setvdWstyle)
call SWGCBK(idisuseline,setlinestyle)
call SWGCBK(idisreturn,GUIreturn)
call SWGCBK(idisrotleft,rotleft)
call SWGCBK(idisrotright,rotright)
call SWGCBK(idisrotup,rotup)
call SWGCBK(idisrotdown,rotdown)
call SWGCBK(idiszoomin,zoomin)
call SWGCBK(idiszoomout,zoomout)
call SWGCB3(idisgraph,zoominout)
call SWGCBK(idisreset,resetview)
call SWGCBK(idisisosurscl,setisosurscl)
call SWGCBK(idisscrval,setscrval)
if (isosursec==0) call SWGCBK(idisshowbothsign,setshowbothsign)
call SWGCBK(idisshowmol,setshowmolstruct)
call SWGCBK(idisshowatmlab,setshowatmlab)
call SWGCBK(idisshowdatarange,setshowdatarange)
call SWGCBK(idisshowisosur,ifshowisosur)
call SWGCBK(idisshowaxis,ifshowaxis)
call SWGCBK(idissavepic,savepic)
if (imodlayout<=1) then
	call SWGCBK(idisbondcrit,setbondcrit)
	call SWGCBK(idisbondradius,setbondradius)
end if
call SWGCBK(idislabelsize,setlabelsize)
call SWGCBK(idisatmsize,setatmsize)
if (isys==1) call drawmol
CALL WGFIN
idrawisosur=0
isosur1style=1
isosur2style=1
isosursec=0
end subroutine


!!----------------- A GUI for drawing molecule and CPs and paths
subroutine drawmoltopogui
GUI_mode=4
isavepic=0
CALL swgtit('Molecular structure, critical points and topology paths')
if (imodlayout==2) then
	call swgwth(73)
else
	call swgwth(plotwinsize3D)
	CALL SWGOPT("CENTER","POSITION") !Main window appear in the center of screen
end if
call SWGPOP("NOOK")  !Don't show OK&QUIT&HELP in upper menu
call SWGPOP("NOQUIT")
call SWGPOP("NOHELP")
CALL WGINI('HORI',idiswindow)
call swgatt(idiswindow,"INACTIVE","CLOSE") !Disable close button
call swgatt(idiswindow,"OFF","MAXI") !Disable maximization button
!Menu bar
CALL WGPOP(idiswindow,"Set perspective",idissetpersp)
CALL wgapp(idissetpersp,"Set rotation angle",idissetangle)
CALL wgapp(idissetpersp,"Set zoom distance",idissetzoom)
CALL WGPOP(idiswindow,"Set label color",idissetlabclr)
CALL wgapp(idissetlabclr,"Set atomic label color",idisatmlabclr)
CALL wgapp(idissetlabclr,"Set CP label color",idisCPlabclr)
!Main region
CALL WGDRAW(idiswindow,idisgraph) !Draw-widget to display molecular structure
CALL SWGWTH(20) !Set parent widget width
CALL SWGSPC(1.0D0,0.0D0) !Set space between widgets below
CALL WGBAS(idiswindow,"VERT",idisright)
CALL WGBAS(idisright,"VERT",idisOK)
call wgpbut(idisOK,"RETURN",idisreturn)
call wgpbut(idisright,"Up",idisrotup)
call wgpbut(idisright,"Down",idisrotdown)
call wgpbut(idisright,"Left",idisrotleft)
call wgpbut(idisright,"Right",idisrotright)
call wgpbut(idisright,"Zoom in",idiszoomin)
call wgpbut(idisright,"Zoom out",idiszoomout)
call wgpbut(idisright,"Reset view",idisreset)
call wgpbut(idisright,"Save picture",idissavepic)
call wgbut(idisright,"Atom labels",ishowatmlab,idisshowatmlab)
call wgbut(idisright,"CP labels",ishowCPlab,idisshowCPlab)
call wgbut(idisright,"Path labels",ishowpathlab,idisshowpathlab)
call wgbut(idisright,"Paths",idrawpath,idisshowpath)
call wgbut(idisright,"Basin surface",idrawpath,idisshowbassurf)
call wgbut(idisright,"Show molecule",idrawmol,idisshowmol)
call wgbut(idisright,"Show axis",ishowaxis,idisshowaxis)
call wgbut(idisright,"Show (3,-3)",ishow3n3,idisshow3n3)
call wgbut(idisright,"Show (3,-1)",ishow3n1,idisshow3n1)
call wgbut(idisright,"Show (3,+1)",ishow3p1,idisshow3p1)
call wgbut(idisright,"Show (3,+3)",ishow3p3,idisshow3p3)
CALL SWGSPC(1.0D0,0.0D0)
call SWGSTP(0.1D0)
call wgscl(idisright,"Ratio of atomic size",0.0D0,5D0,ratioatmsphere,2,idisatmsize)
if (imodlayout<=1) then
	call SWGSTP(0.02D0)
	call wgscl(idisright,"Radius of bonds",0.0D0,0.5D0,bondradius,2,idisbondradius)
end if
call SWGSTP(2.0D0)
call wgscl(idisright,"Size of labels",20.0D0,100.0D0,textheigh,0,idislabelsize)
call SWGCBK(idissetangle,setviewangle)
call SWGCBK(idissetzoom,setzoom)
call SWGCBK(idisatmlabclr,setatmlabclr)
call SWGCBK(idisCPlabclr,setCPlabclr)
call SWGCBK(idisreturn,GUIreturn)
call SWGCBK(idisrotleft,rotleft)
call SWGCBK(idisrotright,rotright)
call SWGCBK(idisrotup,rotup)
call SWGCBK(idisrotdown,rotdown)
call SWGCBK(idiszoomin,zoomin)
call SWGCBK(idiszoomout,zoomout)
call SWGCB3(idisgraph,zoominout)
call SWGCBK(idisreset,resetview)
call SWGCBK(idissavepic,savepic)
call SWGCBK(idisshowatmlab,ifshowatmlabel)
call SWGCBK(idisshowCPlab,ifshowCPlabel)
call SWGCBK(idisshowpathlab,ifshowpathlabel)
call SWGCBK(idisshowaxis,ifshowaxis)
call SWGCBK(idisshowpath,setshowpath)
call SWGCBK(idisshowbassurf,setshowbassurf)
call SWGCBK(idisshowmol,setshowmolstruct)
call SWGCBK(idisshow3n3,ifshow3n3)
call SWGCBK(idisshow3n1,ifshow3n1)
call SWGCBK(idisshow3p1,ifshow3p1)
call SWGCBK(idisshow3p3,ifshow3p3)
call SWGCBK(idisatmsize,setatmsize)
if (imodlayout<=1) call SWGCBK(idisbondradius,setbondradius)
call SWGCBK(idislabelsize,setlabelsize)
CALL SWGSPC(4.0D0,0.5D0) !Reset the default widget spacing
call swgtyp("HORI","SCALE") !Reset the default mode for list widget
if (isys==1) call drawmol
CALL WGFIN
end subroutine


!!----------------- A GUI for drawing molecule and surface minima and maxima for quantitative surface analysis
subroutine drawsurfanalysis
GUI_mode=5
isavepic=0
CALL swgtit('Molecular structure, surface minima and maxima')
if (imodlayout==2) then
	call swgwth(73)
else
	call swgwth(plotwinsize3D)
	CALL SWGOPT("CENTER","POSITION") !Main window appear in the center of screen
end if
call SWGPOP("NOOK")  !Don't show OK&QUIT&HELP in upper menu
call SWGPOP("NOQUIT")
call SWGPOP("NOHELP")
CALL WGINI('HORI',idiswindow)
call swgatt(idiswindow,"INACTIVE","CLOSE") !Disable close button
call swgatt(idiswindow,"OFF","MAXI") !Disable maximization button
CALL WGDRAW(idiswindow,idisgraph) !Draw-widget to display molecular structure
CALL SWGWTH(20) !Set parent widget width
CALL SWGSPC(1.0D0,0.0D0) !Set space between widgets below
CALL WGPOP(idiswindow,"Set perspective",idissetpersp)
CALL wgapp(idissetpersp,"Set rotation angle",idissetangle)
CALL wgapp(idissetpersp,"Set zoom distance",idissetzoom)
CALL WGBAS(idiswindow,"VERT",idisright)
CALL WGBAS(idisright,"VERT",idisOK)
call wgpbut(idisOK,"RETURN",idisreturn)
call wgsep(idisright,idissep1)
call wgpbut(idisright,"Up",idisrotup)
call wgpbut(idisright,"Down",idisrotdown)
call wgpbut(idisright,"Left",idisrotleft)
call wgpbut(idisright,"Right",idisrotright)
call wgpbut(idisright,"Zoom in",idiszoomin)
call wgpbut(idisright,"Zoom out",idiszoomout)
call wgpbut(idisright,"Reset view",idisreset)
call wgpbut(idisright,"Save picture",idissavepic)
call wgbut(idisright,"Atom labels",ishowatmlab,idisshowatmlab)
call wgbut(idisright,"Minimum label",ishowlocminlab,idisshowlocminlab)
call wgbut(idisright,"Maximum label",ishowlocmaxlab,idisshowlocmaxlab)
call wgbut(idisright,"Minimum position",ishowlocminpos,idisshowlocminpos)
call wgbut(idisright,"Maximum position",ishowlocmaxpos,idisshowlocmaxpos)
call wgbut(idisright,"Show axis",ishowaxis,idisshowaxis)
CALL SWGSPC(1.0D0,0.0D0)
call SWGSTP(0.1D0)
call wgscl(idisright,"Ratio of atomic size",0.0D0,6D0,ratioatmsphere,2,idisatmsize)
call SWGSTP(0.02D0)
call wgscl(idisright,"Radius of bonds",0.0D0,0.5D0,bondradius,2,idisbondradius)
call SWGSTP(2.0D0)
call wgscl(idisright,"Size of labels",0.0D0,80.0D0,textheigh,0,idislabelsize)
call SWGCBK(idissetangle,setviewangle)
call SWGCBK(idissetzoom,setzoom)
call SWGCBK(idisreturn,GUIreturn)
call SWGCBK(idisrotleft,rotleft)
call SWGCBK(idisrotright,rotright)
call SWGCBK(idisrotup,rotup)
call SWGCBK(idisrotdown,rotdown)
call SWGCBK(idiszoomin,zoomin)
call SWGCBK(idiszoomout,zoomout)
call SWGCB3(idisgraph,zoominout)
call SWGCBK(idisreset,resetview)
call SWGCBK(idissavepic,savepic)
call SWGCBK(idisshowatmlab,ifshowatmlabel)
call SWGCBK(idisshowlocminlab,setshowlocminlab)
call SWGCBK(idisshowlocmaxlab,setshowlocmaxlab)
call SWGCBK(idisshowlocminpos,setshowlocminpos)
call SWGCBK(idisshowlocmaxpos,setshowlocmaxpos)
call SWGCBK(idisshowaxis,ifshowaxis)
call SWGCBK(idisatmsize,setatmsize)
call SWGCBK(idisbondradius,setbondradius)
call SWGCBK(idislabelsize,setlabelsize)
CALL SWGSPC(4.0D0,0.5D0) !Reset the default widget spacing
call swgtyp("HORI","SCALE") !Reset the default mode for list widget
if (isys==1) call drawmol
CALL WGFIN
end subroutine


!!----------------- A GUI for drawing basin as grids
subroutine drawbasinintgui
use basinintmod
character ictmp*4,basinlist*50000 !max 9999 basins (the 0th is "none"), each one take up 4 characters, adding "|",so 10000*(4+1)=50000
GUI_mode=6
isavepic=0
basinlist(1:4)="None"
basinlist(5:)=" "
do irealatt=1,numrealatt
	write(ictmp,"(i4)") irealatt
	basinlist(irealatt*5+1:irealatt*5+5)="|"//ictmp
end do
basinlist((numrealatt+1)*5+1:(numrealatt+1)*5+5)="|"//"Unas" !numrealatt+1 means unassigned
basinlist((numrealatt+2)*5+1:(numrealatt+2)*5+5)="|"//"Boun" !numrealatt+2 means the ones go to boundary

CALL swgtit('Molecular structure, attractors and basins')
if (imodlayout==2) then
	call swgwth(73)
else
	call swgwth(plotwinsize3D)
	CALL SWGOPT("CENTER","POSITION") !Main window appear in the center of screen
end if
call SWGPOP("NOOK")  !Don't show OK&QUIT&HELP in upper menu
call SWGPOP("NOQUIT")
call SWGPOP("NOHELP")
CALL WGINI('HORI',idiswindow)
call swgatt(idiswindow,"INACTIVE","CLOSE") !Disable close button
call swgatt(idiswindow,"OFF","MAXI") !Disable maximization button
CALL WGDRAW(idiswindow,idisgraph) !Draw-widget to display molecular structure
CALL SWGWTH(20) !Set parent widget width
CALL SWGSPC(1.0D0,0.0D0) !Set space between widgets below
CALL WGPOP(idiswindow,"Set perspective",idissetpersp)
CALL wgapp(idissetpersp,"Set rotation angle",idissetangle)
CALL wgapp(idissetpersp,"Set zoom distance",idissetzoom)
CALL WGPOP(idiswindow,"Set basin drawing method",idissetdraw)
if (allocated(b)) CALL wgapp(idissetdraw,"Entire basin",idisshowbasinall)
if (allocated(b)) CALL wgapp(idissetdraw,"rho>0.001 region only",idisshowbasinvdw)
CALL wgapp(idissetdraw,"Set sphere size for showing basins",idissetbasinsphsize)
CALL WGBAS(idiswindow,"VERT",idisright)
CALL WGBAS(idiswindow,"VERT",idisright2) !Provide another frame for linux version
CALL WGBAS(idisright,"VERT",idisOK)
call wgpbut(idisOK,"RETURN",idisreturn)
call wgpbut(idisright,"Up",idisrotup)
call wgpbut(idisright,"Down",idisrotdown)
call wgpbut(idisright,"Left",idisrotleft)
call wgpbut(idisright,"Right",idisrotright)
call wgpbut(idisright,"Zoom in",idiszoomin)
call wgpbut(idisright,"Zoom out",idiszoomout)
call wgpbut(idisright,"Reset view",idisreset)
call wgpbut(idisright,"Save picture",idissavepic)
call wgbut(idisright,"Show molecule",idrawmol,idisshowmol)
call wgbut(idisright,"Show axis",ishowaxis,idisshowaxis)
call wgbut(idisright,"Atom labels",ishowatmlab,idisshowatmlab)
call wgbut(idisright,"Attractor labels",ishowattlab,idisshowattlab)
call wgbut(idisright,"Show basin interior",idrawinternalbasin,idisdrawinternalbasin)
CALL SWGSPC(1.0D0,0.0D0)
if (imodlayout<=1) then
	call SWGSTP(0.1D0)
	call wgscl(idisright,"Ratio of atomic size",0.0D0,5D0,ratioatmsphere,2,idisatmsize)
	call SWGSTP(0.02D0)
	call wgscl(idisright,"Radius of bonds",0.0D0,0.5D0,bondradius,2,idisbondradius)
end if
call SWGSTP(2.0D0)
call wgscl(idisright,"Size of labels",0.0D0,80.0D0,textheigh,0,idislabelsize)
call SWGSTP(0.02D0)
call wgscl(idisright,"Size of attractors",0.0D0,0.3D0,attsphsize,2,idisattsize)
if (isys==1) then
	call WGLAB(idisright,"Basins:",ibasinseltext)
	CALL WGBAS(idisright,"FORM",idisbotrig)
	call swgwin(0,5,80,130)
	call swgtyp("VSCROLL","LIST")
	CALL WGLIS(idisbotrig,basinlist,1,idisbasinplot)
else if (isys==2) then
	call WGLAB(idisright2,"Basins:",ibasinseltext)
	call swgtyp("SCROLL","LIST")
	CALL WGLIS(idisright2,basinlist,1,idisbasinplot)
end if

!Widget response
call SWGCBK(idissetangle,setviewangle)
call SWGCBK(idissetzoom,setzoom)
call SWGCBK(idisreturn,GUIreturn)
call SWGCBK(idisrotleft,rotleft)
call SWGCBK(idisrotright,rotright)
call SWGCBK(idisrotup,rotup)
call SWGCBK(idisrotdown,rotdown)
call SWGCBK(idiszoomin,zoomin)
call SWGCBK(idiszoomout,zoomout)
call SWGCB3(idisgraph,zoominout)
call SWGCBK(idisreset,resetview)
call SWGCBK(idissavepic,savepic)
call SWGCBK(idisshowmol,setshowmolstruct)
call SWGCBK(idisshowaxis,ifshowaxis)
call SWGCBK(idisshowatmlab,ifshowatmlabel)
call SWGCBK(idisshowattlab,ifshowattlabel)
call SWGCBK(idisdrawinternalbasin,ifdrawinternalbasin)
if (imodlayout<=1) then
	call SWGCBK(idisatmsize,setatmsize)
	call SWGCBK(idisbondradius,setbondradius)
end if
call SWGCBK(idislabelsize,setlabelsize)
call SWGCBK(idisattsize,setattsize)
call SWGCBK(idisbasinplot,showbasinsel)
if (allocated(b)) call SWGCBK(idisshowbasinall,showbasinall)
if (allocated(b)) call SWGCBK(idisshowbasinvdw,showbasinvdw)
call SWGCBK(idissetbasinsphsize,setbasinsphsize)
CALL SWGSPC(4.0D0,0.5D0) !Reset the default widget spacing
call swgtyp("HORI","SCALE") !Reset the default mode for list widget
idrawbasinidx=-10 !Don't draw basins by default
if (isys==1) call drawmol
CALL WGFIN
end subroutine



!!----------------- A GUI for illustrate the domain defined by isosurface that to be integrated
!Adapted from drawbasinintgui
subroutine drawdomaingui
character ictmp*4,domainlist*50000 !max 9999 domainlist (the 0th is "none"), each one take up 4 characters, adding "|",so 10000*(4+1)=50000
GUI_mode=6
isavepic=0
domainlist(1:4)="None"
domainlist(5:)=" "
do idomain=1,ndomain
	write(ictmp,"(i4)") idomain
	domainlist(idomain*5+1:idomain*5+5)="|"//ictmp
end do
CALL swgtit('Molecular structure and domains')
if (imodlayout==2) then
	call swgwth(73)
else
	call swgwth(plotwinsize3D)
	CALL SWGOPT("CENTER","POSITION") !Main window appear in the center of screen
end if
call SWGPOP("NOOK")  !Don't show OK&QUIT&HELP in upper menu
call SWGPOP("NOQUIT")
call SWGPOP("NOHELP")
CALL WGINI('HORI',idiswindow)
call swgatt(idiswindow,"INACTIVE","CLOSE") !Disable close button
call swgatt(idiswindow,"OFF","MAXI") !Disable maximization button
CALL WGDRAW(idiswindow,idisgraph) !Draw-widget to display molecular structure
CALL SWGWTH(20) !Set parent widget width
CALL SWGSPC(1.0D0,0.0D0) !Set space between widgets below
CALL WGPOP(idiswindow,"Set perspective",idissetpersp)
CALL wgapp(idissetpersp,"Set rotation angle",idissetangle)
CALL wgapp(idissetpersp,"Set zoom distance",idissetzoom)
CALL WGBAS(idiswindow,"VERT",idisright)
CALL WGBAS(idiswindow,"VERT",idisright2) !Provide another frame for linux version
CALL WGBAS(idisright,"VERT",idisOK)
call wgpbut(idisOK,"RETURN",idisreturn)
call wgpbut(idisright,"Up",idisrotup)
call wgpbut(idisright,"Down",idisrotdown)
call wgpbut(idisright,"Left",idisrotleft)
call wgpbut(idisright,"Right",idisrotright)
call wgpbut(idisright,"Zoom in",idiszoomin)
call wgpbut(idisright,"Zoom out",idiszoomout)
call wgpbut(idisright,"Reset view",idisreset)
call wgpbut(idisright,"Save picture",idissavepic)
call wgbut(idisright,"Show molecule",idrawmol,idisshowmol)
call wgbut(idisright,"Show axis",ishowaxis,idisshowaxis)
call wgbut(idisright,"Atom labels",ishowatmlab,idisshowatmlab)
CALL SWGSPC(1.0D0,0.0D0)
call SWGSTP(0.1D0)
call wgscl(idisright,"Ratio of atomic size",0.0D0,5D0,ratioatmsphere,2,idisatmsize)
call SWGSTP(0.02D0)
call wgscl(idisright,"Radius of bonds",0.0D0,0.5D0,bondradius,2,idisbondradius)
call SWGSTP(2.0D0)
if (isys==1) then
	call WGLAB(idisright,"Domains:",idomainseltext)
	CALL WGBAS(idisright,"FORM",idisbotrig)
	call swgwin(0,5,80,150)
	call swgtyp("VSCROLL","LIST")
	CALL WGLIS(idisbotrig,domainlist,1,idisdomainplot)
else if (isys==2) then
	call WGLAB(idisright2,"Domains:",idomainseltext)
	call swgtyp("SCROLL","LIST")
	CALL WGLIS(idisright2,domainlist,1,idisdomainplot)
end if
call SWGLIS(idisdomainplot,idrawdomainidx+1)
!Widget response
call SWGCBK(idissetangle,setviewangle)
call SWGCBK(idissetzoom,setzoom)
call SWGCBK(idisreturn,GUIreturn)
call SWGCBK(idisrotleft,rotleft)
call SWGCBK(idisrotright,rotright)
call SWGCBK(idisrotup,rotup)
call SWGCBK(idisrotdown,rotdown)
call SWGCBK(idiszoomin,zoomin)
call SWGCBK(idiszoomout,zoomout)
call SWGCB3(idisgraph,zoominout)
call SWGCBK(idisreset,resetview)
call SWGCBK(idissavepic,savepic)
call SWGCBK(idisshowmol,setshowmolstruct)
call SWGCBK(idisshowaxis,ifshowaxis)
call SWGCBK(idisshowatmlab,ifshowatmlabel)
call SWGCBK(idisatmsize,setatmsize)
call SWGCBK(idisbondradius,setbondradius)
call SWGCBK(idisdomainplot,showdomainsel) 
CALL SWGSPC(4.0D0,0.5D0) !Reset the default widget spacing
call swgtyp("HORI","SCALE") !Reset the default mode for list widget
if (isys==1) call drawmol
CALL WGFIN
end subroutine


!!--------- A GUI for setting box of grid data to be calculated
subroutine setboxGUI
use defvar
character*12 ngridstr
GUI_mode=7 !Use GUI_mode setting in dislin response routine
ishowdatarange=1 !Draw box range
ishowatmlab=0 !Don't show atomic labels
CALL swgtit('Setting up box')
if (imodlayout==2) then
	call swgwth(73)
else
	call swgwth(plotwinsize3D+6)
	CALL SWGOPT("CENTER","POSITION") !Main window appear in the center of screen
	call SWGPOP("NOOK")  !Don't show OK&QUIT in upper menu
end if
call SWGPOP("NOQUIT")
call SWGPOP("NOHELP")
CALL WGINI('HORI',idiswindow)
call swgatt(idiswindow,"INACTIVE","CLOSE") !Disable close button
call swgatt(idiswindow,"OFF","MAXI") !Disable maximization button
CALL WGPOP(idiswindow,"Set perspective",idissetpersp)
CALL wgapp(idissetpersp,"Set rotation angle",idissetangle)
CALL wgapp(idissetpersp,"Set zoom distance",idissetzoom)
CALL WGDRAW(idiswindow,idisgraph) !Draw-widget to display molecular structure
CALL SWGWTH(20) !Set parent widget width
CALL WGBAS(idiswindow,"VERT",idisright)
CALL WGBAS(idisright,"VERT",idisOK)
CALL SWGSPC(1.3D0,0.0D0) !Set space between widgets below
if (imodlayout<=1) call wgpbut(idisOK,"RETURN",idisreturn)
call wgpbut(idisright,"Up",idisrotup)
call wgpbut(idisright,"Down",idisrotdown)
call wgpbut(idisright,"Left",idisrotleft)
call wgpbut(idisright,"Right",idisrotright)
call wgpbut(idisright,"Zoom in",idiszoomin)
call wgpbut(idisright,"Zoom out",idiszoomout)
if (imodlayout<=1) then
	call wgbut(idisright,"Show atomic labels",ishowatmlab,idisshowatmlab)
	call swgstp(0.1D0) !step size of scale bar than default
	call wgscl(idisright,"Ratio of atomic size",0.0D0,5.0D0,1.0D0,2,idisatmsize)
end if
!Set box length. The default initial box just encompass the system and the center is located at geometry center
xmin=minval(a%x)
ymin=minval(a%y)
zmin=minval(a%z)
xmax=maxval(a%x)
ymax=maxval(a%y)
zmax=maxval(a%z)
if (dx==0D0) then !The grid has not been set previously
	orgx=xmin
	orgy=ymin
	orgz=zmin
	endx=xmax
	endy=ymax
	endz=zmax
	dx=0.25D0 !This module always assumes that dx=dy=dz
	dy=0.25D0
	dz=0.25D0
    gridvec1=0;gridvec1(1)=dx
    gridvec2=0;gridvec2(2)=dy
    gridvec3=0;gridvec3(3)=dz
end if
boxlenX=endx-orgx
boxlenY=endy-orgy
boxlenZ=endz-orgz
nx=boxlenX/dx+1
ny=boxlenY/dy+1
nz=boxlenZ/dz+1
boxcenX=(orgx+endx)/2D0
boxcenY=(orgy+endy)/2D0
boxcenZ=(orgz+endz)/2D0
if (imodlayout<=1) call wgsep(idisright,idissep)
call swgstp(0.2D0)
call wgscl(idisright,"X length (Bohr)",0.0D0,(xmax-xmin)+2*8,boxlenX,2,idisboxsizeX)
call wgscl(idisright,"Y length (Bohr)",0.0D0,(ymax-ymin)+2*8,boxlenY,2,idisboxsizeY)
call wgscl(idisright,"Z length (Bohr)",0.0D0,(zmax-zmin)+2*8,boxlenZ,2,idisboxsizeZ)
call wgscl(idisright,"X center (Bohr)",minval(a%x),maxval(a%x),boxcenX,2,idisboxposX)
call wgscl(idisright,"Y center (Bohr)",minval(a%y),maxval(a%y),boxcenY,2,idisboxposY)
call wgscl(idisright,"Z center (Bohr)",minval(a%z),maxval(a%z),boxcenZ,2,idisboxposZ)
call swgstp(0.02D0)
call wgscl(idisright,"Grid spacing (Bohr)",0.05D0,1.5D0,dx,2,idisboxspc)
ngrid=nx*ny*nz
write(ngridstr,"(i11)") ngrid
call WGLAB(idisright,"Number of points:",idisnptlab)
call WGLAB(idisright,ngridstr,idisnpt)

call SWGCBK(idissetangle,setviewangle)
call SWGCBK(idissetzoom,setzoom)
if (imodlayout<=1) call SWGCBK(idisreturn,GUIreturn)
call SWGCBK(idisrotleft,rotleft)
call SWGCBK(idisrotright,rotright)
call SWGCBK(idisrotup,rotup)
call SWGCBK(idisrotdown,rotdown)
call SWGCBK(idiszoomin,zoomin)
call SWGCBK(idiszoomout,zoomout)
call SWGCB3(idisgraph,zoominout)
if (imodlayout<=1) then
	call SWGCBK(idisshowatmlab,setshowatmlab)
	call SWGCBK(idisatmsize,setatmsize)
end if
call SWGCBK(idisboxsizeX,setboxsizeX)
call SWGCBK(idisboxsizeY,setboxsizeY)
call SWGCBK(idisboxsizeZ,setboxsizeZ)
call SWGCBK(idisboxposX,setboxcenX)
call SWGCBK(idisboxposY,setboxcenY)
call SWGCBK(idisboxposZ,setboxcenZ)
call SWGCBK(idisboxspc,setboxspc)
if (isys==1) call drawmol
CALL WGFIN
end subroutine



!!--------- A minimum GUI, used for e.g. visualizing molecule in principal orientation
subroutine miniGUI
use defvar
GUI_mode=7 !Use GUI_mode setting in dislin response routine
isavepic=0
CALL swgtit(' ')
if (imodlayout==2) then
	call swgwth(73)
else
	call swgwth(plotwinsize3D+6)
	CALL SWGOPT("CENTER","POSITION") !Main window appear in the center of screen
end if
call SWGPOP("NOOK")  !Don't show OK&QUIT in upper menu
call SWGPOP("NOQUIT")
call SWGPOP("NOHELP")
CALL WGINI('HORI',idiswindow)
call swgatt(idiswindow,"INACTIVE","CLOSE") !Disable close button
call swgatt(idiswindow,"OFF","MAXI") !Disable maximization button
CALL WGPOP(idiswindow,"Set perspective",idissetpersp)
CALL wgapp(idissetpersp,"Set rotation angle",idissetangle)
CALL wgapp(idissetpersp,"Set zoom distance",idissetzoom)
CALL WGDRAW(idiswindow,idisgraph) !Draw-widget to display molecular structure
CALL SWGWTH(20) !Set parent widget width
CALL WGBAS(idiswindow,"VERT",idisright)
CALL WGBAS(idisright,"VERT",idisOK)
CALL SWGSPC(1.3D0,0.5D0) !Set space between widgets below
call wgpbut(idisOK,"RETURN",idisreturn)
call wgpbut(idisright,"Up",idisrotup)
call wgpbut(idisright,"Down",idisrotdown)
call wgpbut(idisright,"Left",idisrotleft)
call wgpbut(idisright,"Right",idisrotright)
call wgpbut(idisright,"Zoom in",idiszoomin)
call wgpbut(idisright,"Zoom out",idiszoomout)
call wgpbut(idisright,"Reset view",idisreset)
call wgpbut(idisright,"Save picture",idissavepic)
call wgbut(idisright,"Show axis",ishowaxis,idisshowaxis)
call wgbut(idisright,"Show atomic labels",ishowatmlab,idisshowatmlab)
call swgstp(0.1D0) !Step size of scale bar
call wgscl(idisright,"Ratio of atomic size",0.0D0,5.0D0,1.0D0,2,idisatmsize)
call SWGSTP(2.0D0)
call wgscl(idisright,"Size of labels",0.0D0,80.0D0,textheigh,0,idislabelsize)

call SWGCBK(idissetangle,setviewangle)
call SWGCBK(idissetzoom,setzoom)
call SWGCBK(idisreturn,GUIreturn)
call SWGCBK(idisrotleft,rotleft)
call SWGCBK(idisrotright,rotright)
call SWGCBK(idisrotup,rotup)
call SWGCBK(idisrotdown,rotdown)
call SWGCBK(idiszoomin,zoomin)
call SWGCBK(idiszoomout,zoomout)
call SWGCB3(idisgraph,zoominout)
call SWGCBK(idisshowatmlab,setshowatmlab)
call SWGCBK(idisatmsize,setatmsize)
call SWGCBK(idisreset,resetview)
call SWGCBK(idissavepic,savepic)
call SWGCBK(idisshowaxis,ifshowaxis)
call SWGCBK(idislabelsize,setlabelsize)
if (isys==1) call drawmol
CALL WGFIN
end subroutine









!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!! ----------------- Dislin GUI callback subroutine
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


!Show all orbitals
subroutine showorbinfo(id)
integer,intent (in) :: id
character*3 :: orbtype(0:2)=(/ "A+B"," A"," B" /)
character*6 :: symstr
symstr=" "
naorb=count(MOtype==1)
write(*,*) "Orbital list:"
do i=1,nmo
	if (allocated(MOsym)) symstr='('//MOsym(i)//')'
	if (wfntype==0.or.wfntype==2.or.wfntype==3) then
		write(*,"(' Orb:',i6,' Ene(au/eV):',f13.6,f13.4,' Occ:',f9.6,' Type:',a,1x,a)") &
		i,MOene(i),MOene(i)*au2eV,MOocc(i),orbtype(MOtype(i)),symstr
	else
		if (MOtype(i)==1) then
			write(*,"(i10,5x,' E(au/eV):',f12.5,f13.4,' Occ:',f9.6,' Typ:',a,1x,a)") &
			i,MOene(i),MOene(i)*au2eV,MOocc(i),orbtype(MOtype(i)),symstr
		else
			write(*,"(i6,' (',i6,')',' E(au/eV):',f12.5,f13.4,' Occ:',f9.6,' Typ:',a,1x,a)") &
			i,i-naorb,MOene(i),MOene(i)*au2eV,MOocc(i),orbtype(MOtype(i)),symstr
		end if
	end if
end do
if (any(MOtype==2)) write(*,"(a)") " Note: For beta orbitals, &
the index in the parenthese shown above is the index counted from the first beta orbital"
end subroutine



!Show orbitals up to LUMO+10, works for wfntype==0,1,2
subroutine showorbinfo2(id)
integer,intent (in) :: id
character*3 :: orbtype(0:2)=(/ "A+B"," A"," B" /)
character*6 :: symstr
symstr=" "
naorb=count(MOtype==1)
if (wfntype==0.or.wfntype==2) then
	write(*,*) "Orbital list:"
	do nmoend=1,nmo
		if (MOocc(nmoend)==0D0) exit
	end do
	nmoend=nmoend+10
	if (nmoend>nmo) nmoend=nmo
	do i=1,nmoend
		if (allocated(MOsym)) symstr='('//MOsym(i)//')'
		write(*,"(' Orb:',i6,' Ene(au/eV):',f13.6,f13.4,' Occ:',f9.6,' Type:',a,1x,a)") &
		i,MOene(i),MOene(i)*au2eV,MOocc(i),orbtype(MOtype(i)),symstr
	end do
else if (wfntype==1) then
	do iLUMOa=1,nmo
		if (MOocc(iLUMOa)==0) exit
	end do
	do iLUMOb=nmo,1,-1
		if (MOocc(iLUMOb)==1) exit
	end do
	iLUMOb=iLUMOb+1
	do ibeta=1,nmo
		if (MOtype(ibeta)==2) exit
	end do
	iaend=iLUMOa+10
	if (iaend>=ibeta) iaend=ibeta-1
	ibend=iLUMOb+10
	if (ibend>nmo) ibend=nmo
	write(*,*) "Alpha orbital list:"
	do i=1,iaend
		if (allocated(MOsym)) symstr='('//MOsym(i)//')'
		write(*,"(i10,5x,' E(au/eV):',f12.5,f13.4,' Occ:',f9.6,' Typ:',a,1x,a)") &
		i,MOene(i),MOene(i)*au2eV,MOocc(i),orbtype(MOtype(i)),symstr
	end do
	write(*,*) "Beta orbital list:"
	do i=ibeta,ibend
		if (allocated(MOsym)) symstr='('//MOsym(i)//')'
		write(*,"(i6,' (',i6,')',' E(au/eV):',f12.5,f13.4,' Occ:',f9.6,' Typ:',a,1x,a)") &
		i,i-naorb,MOene(i),MOene(i)*au2eV,MOocc(i),orbtype(MOtype(i)),symstr
	end do
	write(*,"(a)") " Note: For beta orbitals, &
	the index in the parenthese shown above is the index counted from the first beta orbital"
end if
end subroutine

!Show all occupied orbitals
subroutine showorbinfo3(id)
integer,intent (in) :: id
character*3 :: orbtype(0:2)=(/ "A+B"," A"," B" /)
character*6 :: symstr
symstr=" "
naorb=count(MOtype==1)
write(*,*) "Orbital list:"
do i=1,nmo
	if (MOocc(i)==0) cycle
	if (allocated(MOsym)) symstr='('//MOsym(i)//')'
	if (wfntype==0.or.wfntype==2.or.wfntype==3) then
		write(*,"(' Orb:',i6,' Ene(au/eV):',f13.6,f13.4,' Occ:',f9.6,' Type:',a,1x,a)") &
		i,MOene(i),MOene(i)*au2eV,MOocc(i),orbtype(MOtype(i)),symstr
	else
		if (MOtype(i)==1) then
			write(*,"(i10,5x,' E(au/eV):',f12.5,f13.4,' Occ:',f9.6,' Typ:',a,1x,a)") &
			i,MOene(i),MOene(i)*au2eV,MOocc(i),orbtype(MOtype(i)),symstr
		else
			write(*,"(i6,' (',i6,')',' E(au/eV):',f12.5,f13.4,' Occ:',f9.6,' Typ:',a,1x,a)") &
			i,i-naorb,MOene(i),MOene(i)*au2eV,MOocc(i),orbtype(MOtype(i)),symstr
		end if
	end if
end do
if (any(MOtype==2)) write(*,"(a)") " Note: For beta orbitals, &
the index in the parenthese shown above is the index counted from the first beta orbital"
end subroutine


subroutine rotleft(id)
integer,intent (in) :: id
character*20 tmpstr
XVU=XVU+10
if (GUI_mode/=2) then
	call drawmol
else if (GUI_mode==2) then
	call drawplane(dp_init1,dp_end1,dp_init2,dp_end2,dp_init3,dp_end3,idrawtype)
	write(tmpstr,"(f8.2)") XVU
	call SWGTXT(idissetplaneXVU,tmpstr)
end if
end subroutine

subroutine rotright(id)
integer,intent (in) :: id
character*20 tmpstr
XVU=XVU-10
if (GUI_mode/=2) then
	call drawmol
else if (GUI_mode==2) then
	call drawplane(dp_init1,dp_end1,dp_init2,dp_end2,dp_init3,dp_end3,idrawtype)
	write(tmpstr,"(f8.2)") XVU
	call SWGTXT(idissetplaneXVU,tmpstr)
end if
end subroutine

subroutine rotup(id)
integer,intent (in) :: id
character*20 tmpstr
if (YVU<90D0) YVU=YVU+10
if (GUI_mode/=2) then
	call drawmol
else if (GUI_mode==2) then
	call drawplane(dp_init1,dp_end1,dp_init2,dp_end2,dp_init3,dp_end3,idrawtype)
	write(tmpstr,"(f8.2)") YVU
	call SWGTXT(idissetplaneYVU,tmpstr)
end if
end subroutine

subroutine rotdown(id)
integer,intent (in) :: id
character*20 tmpstr
if (YVU>-90D0) YVU=YVU-10
if (GUI_mode/=2) then
	call drawmol
else if (GUI_mode==2) then
	call drawplane(dp_init1,dp_end1,dp_init2,dp_end2,dp_init3,dp_end3,idrawtype)
	write(tmpstr,"(f8.2)") YVU
	call SWGTXT(idissetplaneYVU,tmpstr)
end if
end subroutine

subroutine zoomin(id)
integer,intent (in) :: id
if (ZVU==2) return !Already too near to the system
ZVU=ZVU-0.5D0
if (GUI_mode/=2) call drawmol
if (GUI_mode==2) call drawplane(dp_init1,dp_end1,dp_init2,dp_end2,dp_init3,dp_end3,idrawtype)
if (ZVU==2) call SWGATT(idiszoomin,"INACTIVE","STATUS") !Too near the molecule, disable zoom in button
end subroutine

subroutine zoomout(id)
integer,intent (in) :: id
if (ZVU==2) call SWGATT(idiszoomin,"ACTIVE","STATUS")
ZVU=ZVU+0.5D0
if (GUI_mode/=2) call drawmol
if (GUI_mode==2) call drawplane(dp_init1,dp_end1,dp_init2,dp_end2,dp_init3,dp_end3,idrawtype)
end subroutine

subroutine zoominout(id,iwheel) !Response mouse wheel action on the graph
integer,intent (in) :: id,iwheel
if (iwheel==1) call zoomin(id)
if (iwheel==-1) call zoomout(id)
end subroutine

subroutine resetview(id)
integer,intent (in) :: id
XVU=150D0
YVU=30D0
atmlabclrR=0D0
atmlabclrG=0D0
atmlabclrB=0D0
if (GUI_mode==1.or.GUI_mode==3) then
	bondcrit=1.15D0
	textheigh=38.0D0
	ratioatmsphere=1.0D0
	bondradius=0.2D0
	ishowatmlab=1
	ishowaxis=1
	call swgbut(idisshowatmlab,ishowatmlab)
	call swgbut(idisshowaxis,ishowaxis)
	if (GUI_mode==1) then
		sur_value=0.05D0
		ZVU=6.0D0
		call swgscl(idisisosurscl,sur_value)
		if (imodlayout/=2) call swgscl(idisbondradius,bondradius)
		call swgscl(idisatmsize,ratioatmsphere)
		if (imodlayout/=2) call swgscl(idisbondcrit,bondcrit)
		call swgscl(idislabelsize,textheigh)
	else if (GUI_mode==3) then
		ZVU=7.0D0
		if (isosursec==0) isosurshowboth=1
		ishowdatarange=0
		idrawmol=1
		idrawisosur=1
		if (isosursec==0) call swgbut(idisshowbothsign,isosurshowboth)
		call swgbut(idisshowdatarange,ishowdatarange)
		call swgbut(idisshowmol,idrawmol)
		call swgbut(idisshowisosur,idrawisosur)
	end if
else if (GUI_mode==4) then
	ZVU=5.0D0 !Let the system seems closer
	ishowatmlab=0
	ishowCPlab=0
	ishowpathlab=0
	ishowaxis=1
	ishow3n3=1
	ishow3n1=1
	ishow3p1=1
	ishow3p3=1
	idrawpath=1
	idrawbassurf=1
	bondradius=0.07D0
	ratioatmsphere=0.6D0
	textheigh=38
	call swgbut(idisshowatmlab,ishowatmlab)
	call swgbut(idisshowCPlab,ishowCPlab)
	call swgbut(idisshowpathlab,ishowpathlab)
	call swgbut(idisshowaxis,ishowaxis)
	call swgbut(idisshowmol,idrawmol)
	call swgbut(idisshow3n3,ishow3n3)
	call swgbut(idisshow3n1,ishow3n1)
	call swgbut(idisshow3p1,ishow3p1)
	call swgbut(idisshow3p3,ishow3p3)
	call swgbut(idisshowpath,idrawpath)
	call swgbut(idisshowbassurf,idrawbassurf)
	if (imodlayout/=2) call swgscl(idisbondradius,bondradius)
	call swgscl(idisatmsize,ratioatmsphere)
	call swgscl(idislabelsize,textheigh)
else if (GUI_mode==5) then
	ZVU=6.0D0
	textheigh=30.0D0
	ratioatmsphere=1.0D0
	bondradius=0.2D0
	ishowatmlab=1
	ishowaxis=1
	ishowlocminlab=0
	ishowlocmaxlab=0
	ishowlocminpos=1
	ishowlocmaxpos=1
	call swgscl(idislabelsize,textheigh)
	call swgscl(idisatmsize,ratioatmsphere)
	call swgscl(idisbondradius,bondradius)
	call swgbut(idisshowatmlab,ishowatmlab)
	call swgbut(idisshowaxis,ishowaxis)
	call swgbut(idisshowlocminlab,ishowlocminlab)
	call swgbut(idisshowlocmaxlab,ishowlocmaxlab)
	call swgbut(idisshowlocminpos,ishowlocminpos)
	call swgbut(idisshowlocmaxpos,ishowlocmaxpos)
else if (GUI_mode==6) then
	ZVU=6.0D0
	idrawmol=1
	ishowaxis=1
	ishowatmlab=0
	idrawinternalbasin=0
	ratioatmsphere=1.0D0
	bondradius=0.2D0
	textheigh=40.0D0
	attsphsize=0.1D0
	call swgbut(idisshowmol,idrawmol)
	call swgbut(idisshowaxis,ishowaxis)
	call swgbut(idisshowatmlab,ishowatmlab)
	call swgbut(idisshowattlab,ishowattlab)
	call swgbut(idisdrawinternalbasin,idrawinternalbasin)
	if (imodlayout/=2) call swgscl(idisatmsize,ratioatmsphere)
	if (imodlayout/=2) call swgscl(idisbondradius,bondradius)
	call swgscl(idislabelsize,textheigh)
	call swgscl(idisattsize,attsphsize)
else if (GUI_mode==2) then
	ZVU=7.0D0
end if
call SWGATT(idiszoomin,"ACTIVE","STATUS")
if (GUI_mode/=2) call drawmol
if (GUI_mode==2) call drawplane(dp_init1,dp_end1,dp_init2,dp_end2,dp_init3,dp_end3,idrawtype)
end subroutine

subroutine savepic(id)
integer,intent (in) :: id
character c80tmp*80
isavepic=1
call drawmol
if (iorbvis==0) then
    call DWGMSG("The graph has been saved to a file with ""dislin"" prefix in current folder")
else
    write(c80tmp,"(i6.6)") iorbvis
    call DWGMSG("The graph has been saved to a file with "//trim(c80tmp)//" prefix in current folder")
end if
isavepic=0
end subroutine

subroutine ifshowatmlabel(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) ishowatmlab=0
if (istat==1) ishowatmlab=1
call drawmol
end subroutine

subroutine ifshowattlabel(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) ishowattlab=0
if (istat==1) ishowattlab=1
call drawmol
end subroutine

subroutine ifdrawinternalbasin(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) idrawinternalbasin=0
if (istat==1) idrawinternalbasin=1
call drawmol
end subroutine

subroutine ifshowCPlabel(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) ishowCPlab=0
if (istat==1) ishowCPlab=1
call drawmol
end subroutine

subroutine ifshowpathlabel(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) ishowpathlab=0
if (istat==1) ishowpathlab=1
call drawmol
end subroutine

subroutine ifshowaxis(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) ishowaxis=0
if (istat==1) ishowaxis=1
call drawmol
end subroutine

subroutine ifshowisosur(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) idrawisosur=0
if (istat==1) idrawisosur=1
call drawmol
end subroutine

!Extract string from orbital selection list and plot orbital orbital by calling showorbsel
!The select orbital is recorded as global variable "iorbvis"
subroutine showorbsellist(id)
integer,intent (in) :: id
character*10 tmpstr
call GWGLIS(id,isel)
iorbvis=isel-1
if (wfntype==0.or.wfntype==2.or.wfntype==3) then !R or RO case
	write(tmpstr,"(i6)") iorbvis
	call SWGTXT(iorbtxt,tmpstr)
else !U case
	naorb=count(MOtype==1)
	if (iorbvis<=naorb) then
		write(tmpstr,"(i6)") iorbvis
	else
		write(tmpstr,"(i6)") -(iorbvis-naorb)
	end if
	call SWGTXT(iorbtxt,tmpstr)
end if
call showorbsel(id,iorbvis)
end subroutine
!Extract string from orbital selection box and plot orbital orbital by calling showorbsel
!The select orbital is recorded as global variable "iorbvis"
subroutine showorbselbox(id)
integer,intent (in) :: id
character*10 tmpstr
call GWGTXT(id,tmpstr)
read(tmpstr,*) iorbvis
if (wfntype==0.or.wfntype==2.or.wfntype==3) then !R or RO case
	if (iorbvis>nmo.or.iorbvis<0) then
		call DWGMSG("Error: The orbital you selected is out of valid range!")
		return
	end if
	call SWGLIS(iorblis,iorbvis+1)
else !U case
	naorb=count(MOtype==1)
	if (iorbvis>=0) then
		if (iorbvis>nmo) then
			call DWGMSG("Error: The orbital you selected is out of valid range!")
			return
		end if
		call SWGLIS(iorblis,iorbvis+1)
		if (iorbvis>naorb) then
			write(tmpstr,"(i6)") -(iorbvis-naorb)
			call SWGTXT(iorbtxt,tmpstr)
		end if
	else
		iorbvis=naorb+abs(iorbvis)
		if (iorbvis>nmo) then
			call DWGMSG("Error: The orbital you selected is out of valid range!")
			return
		end if
		call SWGLIS(iorblis,iorbvis+1)
	end if
end if
call showorbsel(id,iorbvis)
end subroutine
!Calculate grid data of selected orbital and plot it as isosurface
subroutine showorbsel(id,iorb)
use function
integer id,iorb
real*8 molxlen,molylen,molzlen
character*3 :: orbtype(0:2)=(/ "A+B"," A"," B" /)
character*6 :: symstr
! Set grid for calculating cube data
molxlen=(maxval(a%x)-minval(a%x))+2*aug3D
molylen=(maxval(a%y)-minval(a%y))+2*aug3D
molzlen=(maxval(a%z)-minval(a%z))+2*aug3D
orgx=minval(a%x)-aug3D
orgy=minval(a%y)-aug3D
orgz=minval(a%z)-aug3D
dx=(molxlen*molylen*molzlen/dfloat(nprevorbgrid))**(1.0D0/3.0D0)
dy=dx
dz=dx
gridvec1=0;gridvec1(1)=dx
gridvec2=0;gridvec2(2)=dy
gridvec3=0;gridvec3(3)=dz
nx=nint(molxlen/dx)+1
ny=nint(molylen/dy)+1
nz=nint(molzlen/dz)+1
if (iorb==0) then !Namely "None" in the orbital list
	if (isosursec==0) then
		idrawisosur=0
		if (allocated(cubmat)) deallocate(cubmat)
		call swgatt(idisisosursec,"INACTIVE","STATUS")
	else if (isosursec==1) then !When the second isosurface is selected, select "NONE" only clean cubmattmp
		if (allocated(cubmattmp)) deallocate(cubmattmp)
	end if
else
	idrawisosur=1
	call swgatt(idisisosursec,"ACTIVE","STATUS")
	symstr=" "
	if (allocated(MOsym)) symstr='('//MOsym(iorb)//')'
	if (wfntype==0.or.wfntype==2.or.wfntype==3) then
		write(*,"(' Orb:',i6,' Ene(au/eV):',f13.6,f13.4,' Occ:',f9.6,' Type:',a,1x,a)") &
		iorb,MOene(iorb),MOene(iorb)*au2eV,MOocc(iorb),orbtype(MOtype(iorb)),symstr
	else
		if (MOtype(iorb)==1) then
			write(*,"(i10,5x,' E(au/eV):',f12.5,f13.4,' Occ:',f9.6,' Typ:',a,1x,a)") &
			iorb,MOene(iorb),MOene(iorb)*au2eV,MOocc(iorb),orbtype(MOtype(iorb)),symstr
		else
			naorb=count(MOtype==1)
			write(*,"(i6,' (',i6,')',' E(au/eV):',f12.5,f13.4,' Occ:',f9.6,' Typ:',a,1x,a)") &
			iorb,iorb-naorb,MOene(iorb),MOene(iorb)*au2eV,MOocc(iorb),orbtype(MOtype(iorb)),symstr
		end if
	end if
	call SWGTXT(iorbseltext,"Please wait...")
	call SWGFGD(iorbseltext,1.0D0,0D0,0D0)
	if (isosursec==0) then !Save cube data for isosurface 1 to cubmat
		if (allocated(cubmat)) deallocate(cubmat)
		allocate(cubmat(nx,ny,nz))
		!$OMP parallel do PRIVATE(i,j,k) SHARED(cubmat) NUM_THREADS(nthreads)
		do k=1,nz
			do j=1,ny
				do i=1,nx
					cubmat(i,j,k)=fmo(orgx+(i-1)*dx,orgy+(j-1)*dy,orgz+(k-1)*dz,iorb)
				end do
			end do
		end do
		!$OMP end parallel do
		if (ifixorbsign==1.and.sum(cubmat)<0) cubmat=-cubmat
	else if (isosursec==1) then !Save cube data for isosurface 2 to cubmattmp
		if (allocated(cubmattmp)) deallocate(cubmattmp)
		allocate(cubmattmp(nx,ny,nz))
		!$OMP parallel do PRIVATE(i,j,k) SHARED(cubmat) NUM_THREADS(nthreads)
		do k=1,nz
			do j=1,ny
				do i=1,nx
					cubmattmp(i,j,k)=fmo(orgx+(i-1)*dx,orgy+(j-1)*dy,orgz+(k-1)*dz,iorb)
				end do
			end do
		end do
		!$OMP end parallel do
		if (ifixorbsign==1.and.sum(cubmattmp)<0) cubmattmp=-cubmattmp
	end if
	call SWGTXT(iorbseltext,"Orbitals:")
	call SWGFGD(iorbseltext,0D0,0D0,0D0)
end if
call drawmol
end subroutine

subroutine showbasinsel(id)
use basinintmod
integer,intent (in) :: id
call GWGLIS(id,isel)
idrawbasinidx=isel-1
if (isel==1) idrawbasinidx=-10 !Don't draw basins
if (isel==numrealatt+2) idrawbasinidx=0 !Unassigned
if (isel==numrealatt+3) idrawbasinidx=-1 !Moved to boundary
call drawmol
end subroutine

subroutine showdomainsel(id)
use defvar
integer,intent (in) :: id
call GWGLIS(id,isel)
idrawdomainidx=isel-1
if (isel==1) idrawdomainidx=0 !Don't draw domain
call drawmol
end subroutine

subroutine setbondcrit(id)
integer,intent (in) :: id
call GWGSCL(id,bondcrit)
if (allocated(connmat)) then
    write(*,*) "Note: Connectivity is unset since bonding criterion has been changed"
    deallocate(connmat)
end if
call drawmol
end subroutine

subroutine GUIreturn(id)
integer,intent (in) :: id
CALL setxid(0,'NONE') !Return to default setting, otherwise such as spectrum cannot be plotted
call sendok
end subroutine

subroutine setlabelsize(id)
integer,intent (in) :: id
call GWGSCL(id,textheigh)
call drawmol
end subroutine

subroutine setatmsize(id)
integer,intent (in) :: id
call GWGSCL(id,ratioatmsphere)
call drawmol
end subroutine

subroutine setattsize(id)
integer,intent (in) :: id
call GWGSCL(id,attsphsize)
call drawmol
end subroutine

subroutine setbondradius(id)
integer,intent (in) :: id
call GWGSCL(id,bondradius)
call drawmol
end subroutine

subroutine setisosurscl(id) !Drag scale bar, change sur_value & text
integer,intent (in) :: id
character*20 temp
call GWGSCL(id,sur_value)
if (GUI_mode==3) then
	write(temp,"(f8.3)") sur_value
	call SWGTXT(idisscrval,temp)
end if
call drawmol
end subroutine

subroutine setscrval(id) !Input text, change scale bar
integer,intent (in) :: id
call GWGFLT(id,sur_value)
if (sur_value<5D0.and.sur_value>-5D0) call SWGSCL(idisisosurscl,sur_value)
call drawmol
end subroutine

subroutine setshowbothsign(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) isosurshowboth=0
if (istat==1) isosurshowboth=1
call drawmol
end subroutine

subroutine setshowmolstruct(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) idrawmol=0
if (istat==1) idrawmol=1
call drawmol
end subroutine

subroutine setlinestyle(id)
integer,intent (in) :: id
ratioatmsphere=0D0
bondradius=0.02D0
if (imodlayout/=2) call swgscl(idisbondradius,bondradius)
call swgscl(idisatmsize,ratioatmsphere)
call drawmol
end subroutine

subroutine setCPKstyle(id)
integer,intent (in) :: id
ratioatmsphere=1.0D0
bondradius=0.2D0
if (imodlayout/=2) call swgscl(idisbondradius,bondradius)
call swgscl(idisatmsize,ratioatmsphere)
call drawmol
end subroutine

subroutine setvdWstyle(id)
integer,intent (in) :: id
ratioatmsphere=4.0D0
bondradius=0.2D0
if (imodlayout/=2) call swgscl(idisbondradius,bondradius)
call swgscl(idisatmsize,ratioatmsphere)
call drawmol
end subroutine

subroutine setshowhydrogen(id)
integer,intent (in) :: id
if (ishowhydrogen==1) then
    ishowhydrogen=0
else
    ishowhydrogen=1
end if
call drawmol
end subroutine

subroutine setplaneXVU(id)
integer,intent (in) :: id
call GWGFLT(id,XVU)
call drawplane(dp_init1,dp_end1,dp_init2,dp_end2,dp_init3,dp_end3,idrawtype)
end subroutine

subroutine setplaneYVU(id)
integer,intent (in) :: id
call GWGFLT(id,YVU)
call drawplane(dp_init1,dp_end1,dp_init2,dp_end2,dp_init3,dp_end3,idrawtype)
end subroutine

subroutine setshowpath(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) idrawpath=0
if (istat==1) idrawpath=1
call drawmol
end subroutine

subroutine setshowbassurf(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) idrawbassurf=0
if (istat==1) idrawbassurf=1
call drawmol
end subroutine

subroutine setshowatmlab(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) ishowatmlab=0
if (istat==1) ishowatmlab=1
call drawmol
end subroutine

subroutine setshowdatarange(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) ishowdatarange=0
if (istat==1) ishowdatarange=1
call drawmol
end subroutine

subroutine ifshow3n3(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) ishow3n3=0
if (istat==1) ishow3n3=1
call drawmol
end subroutine
subroutine ifshow3n1(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) ishow3n1=0
if (istat==1) ishow3n1=1
call drawmol
end subroutine
subroutine ifshow3p1(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) ishow3p1=0
if (istat==1) ishow3p1=1
call drawmol
end subroutine
subroutine ifshow3p3(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) ishow3p3=0
if (istat==1) ishow3p3=1
call drawmol
end subroutine

!For molecular surface analysis
subroutine setshowlocminlab(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) ishowlocminlab=0
if (istat==1) ishowlocminlab=1
call drawmol
end subroutine
subroutine setshowlocmaxlab(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) ishowlocmaxlab=0
if (istat==1) ishowlocmaxlab=1
call drawmol
end subroutine
subroutine setshowlocminpos(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) ishowlocminpos=0
if (istat==1) ishowlocminpos=1
call drawmol
end subroutine
subroutine setshowlocmaxpos(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) ishowlocmaxpos=0
if (istat==1) ishowlocmaxpos=1
call drawmol
end subroutine



!Set number of grid points for viewing orbitals (namely control isosurface quality)
subroutine setisosurnumpt(id)
integer,intent (in) :: id
character inpstring*30
nprevorbgridold=nprevorbgrid
if (id==idisisosurdef) nprevorbgrid=120000
if (id==idisisosurgood) nprevorbgrid=300000
if (id==idisisosurhigh) nprevorbgrid=500000
if (id==idisisosurveryhigh) nprevorbgrid=1000000
if (id==idisisosurperfect) nprevorbgrid=1500000
if (id==idisisosurnumpt) then
    CALL SWGWTH(40)
    write(inpstring,"(i15)") nprevorbgrid
    call dwgtxt("Input the number of grid points|Higher number leads to finer quality",inpstring)
    read(inpstring,*) nprevorbgrid
    CALL SWGWTH(20) !Recover default
end if
if (nprevorbgrid/=nprevorbgridold) then !Remove current isosurface and corresponding grid data, recover initial state when entering the GUI
	if (allocated(cubmat)) deallocate(cubmat)
	if (allocated(cubmattmp)) deallocate(cubmattmp)
	isosursec=0
	call swgbut(idisisosursec,0)
	if (iorbvis/=0) call showorbsel(id,iorbvis) !iorbvis==0 corresponds to "none"
end if
end subroutine


!Set rotation angle for 3D GUI
subroutine setviewangle(id)
integer,intent (in) :: id
character inpstring*30
CALL SWGWTH(45)
write(inpstring,"(f10.3)") XVU
call dwgtxt("Input XVU angle in degree|More positive = turn left|More negative = turn right",inpstring)
read(inpstring,*) XVU
write(inpstring,"(f10.3)") YVU
call dwgtxt("Input YVU angle in degree|More positive = turn up|More negative = turn down",inpstring)
read(inpstring,*) YVU
call drawmol
CALL SWGWTH(20) !Recover default
end subroutine

!Set zoom distance for 3D GUI
subroutine setzoom(id)
integer,intent (in) :: id
character inpstring*30
CALL SWGWTH(45)
write(inpstring,"(f8.2)") ZVU
call dwgtxt("Input zoom distance|Larger/smaller value = Zoom out/in",inpstring)
read(inpstring,*) ZVU
call drawmol
CALL SWGWTH(20) !Recover default
end subroutine

!Set extension distance for showing orbitals in main function 0
subroutine setextdist(id)
use defvar
integer,intent (in) :: id
character inpstring*30
CALL SWGWTH(60)
write(inpstring,"(f10.3)") aug3D
CALL swgtit("Set extension distance")
call dwgtxt("Input extension distance for calculating grid data of orbitals",inpstring)
read(inpstring,*) aug3D
call drawmol
CALL SWGWTH(20) !Recover default
end subroutine

!Set orbital isovalue to specified value in main function 0 GUI
subroutine setorbisovalue(id)
use defvar
integer,intent (in) :: id
character inpstring*30
CALL SWGWTH(60)
write(inpstring,"(f10.5)") sur_value
CALL swgtit("Set orbital isovalue")
call dwgtxt("Input isovalue for showing orbitals",inpstring)
read(inpstring,*) sur_value
call drawmol
CALL SWGWTH(20) !Recover default
end subroutine

!Set atomic label type in main function 0
subroutine setatmlabtyp(id)
use defvar
integer,intent (in) :: id
CALL swgtit(" ")
if (any(a%index==0)) then
	call dwglis("Choose label type","Element symbol|Atom index|Element+Index|Only Bq index|Bq index starts from 1|No Bq label",iatmlabtype3D)
else
	call dwglis("Choose label type","Element symbol|Atom index|Element+Index",iatmlabtype3D)
end if
call drawmol
end subroutine

!Set atomic label color in main function 0. The default color is defined by "atmlabRGB" in settings.ini
subroutine setatmlabclr(id)
use defvar
integer,intent (in) :: id
character clrlist*200
clrlist="Red|Green|Blue|White|Black|Gray|Cyan|Yellow|Orange|Magenta|Crimson|Dark green|Purple|Brown|Dark blue|Pink"
call SWGPOP("NOOK")  !Don't show OK&QUIT&HELP in upper menu
call SWGPOP("NOQUIT")
call SWGPOP("NOHELP")
CALL swgtit("Select label color")
CALL SWGWTH(30) !Make the list widget wider than default
CALL WGINI('VERT',idiswindow)
call swgatt(idiswindow,"INACTIVE","CLOSE") !Disable close button
call swgatt(idiswindow,"OFF","MAXI") !Disable maximization button
CALL WGLIS(idiswindow,clrlist,0,idisselclr)
call wgpbut(idiswindow,"RETURN",idisreturn)
call SWGCBK(idisselclr,changeatmlabclr)
call SWGCBK(idisreturn,GUIreturn)
CALL WGFIN
CALL SWGWTH(20) !Recover default
end subroutine
!Change atomic label color to selected one. atmlabclrR, atmlabclrG, atmlabclrB are global variable
subroutine changeatmlabclr(id)
use defvar
integer,intent (in) :: id
integer iclr
call gwglis(id,iclr)
call clridx2RGB(iclr,atmlabclrR,atmlabclrG,atmlabclrB)
call drawmol
end subroutine

!Set CP label color in main function 2. The default color is defined by "CP_RGB" in settings.ini
subroutine setCPlabclr(id)
use defvar
integer,intent (in) :: id
character clrlist*200
clrlist="Red|Green|Blue|White|Black|Gray|Cyan|Yellow|Orange|Magenta|Crimson|Dark green|Purple|Brown|Dark blue|Pink"
call SWGPOP("NOOK")  !Don't show OK&QUIT&HELP in upper menu
call SWGPOP("NOQUIT")
call SWGPOP("NOHELP")
CALL swgtit("Select label color")
CALL SWGWTH(30) !Make the list widget wider than default
CALL WGINI('VERT',idiswindow)
call swgatt(idiswindow,"INACTIVE","CLOSE") !Disable close button
call swgatt(idiswindow,"OFF","MAXI") !Disable maximization button
CALL WGLIS(idiswindow,clrlist,0,idisselclr)
call wgpbut(idiswindow,"RETURN",idisreturn)
call SWGCBK(idisselclr,changeCPlabclr)
call SWGCBK(idisreturn,GUIreturn)
CALL WGFIN
CALL SWGWTH(20) !Recover default
end subroutine
!Change CP label color to selected one. CPlabclrR, CPlabclrG, CPlabclrB are global variable
subroutine changeCPlabclr(id)
use defvar
integer,intent (in) :: id
integer iclr
call gwglis(id,iclr)
call clridx2RGB(iclr,CPlabclrR,CPlabclrG,CPlabclrB)
call drawmol
end subroutine


!If show cubmattmp
subroutine ifisosursec(id)
integer,intent (in) :: id
call GWGBUT(id,istat)
if (istat==0) isosursec=0
if (istat==1) isosursec=1
call drawmol
end subroutine

!Set isosurface style. We absolutely avoid that only one isosurface is transparent. So, when we set one of isosurface to transparent, then another too.
!When we set one of isosurface to a specific style, then we check if the old style of another isosurface is transparent, if yes, we set its style to current style together
subroutine setisosur1solid(id)
integer,intent (in) :: id
isosur1style=1
if (isosur2style==5) isosur2style=1
call drawmol
end subroutine
subroutine setisosur1line(id)
integer,intent (in) :: id
isosur1style=2
if (isosur2style==5) isosur2style=2
call drawmol
end subroutine
subroutine setisosur1point(id)
integer,intent (in) :: id
isosur1style=3
if (isosur2style==5) isosur2style=3
call drawmol
end subroutine
subroutine setisosur1solidmesh(id)
integer,intent (in) :: id
isosur1style=4
if (isosur2style==5) isosur2style=4
call drawmol
end subroutine
subroutine setisosur1tpr(id)
integer,intent (in) :: id
isosur1style=5
isosur2style=5
call drawmol
end subroutine
!----
subroutine setisosur2solid(id)
integer,intent (in) :: id
isosur2style=1
if (isosur1style==5) isosur1style=1
call drawmol
end subroutine
subroutine setisosur2line(id)
integer,intent (in) :: id
isosur2style=2
if (isosur1style==5) isosur1style=2
call drawmol
end subroutine
subroutine setisosur2point(id)
integer,intent (in) :: id
isosur2style=3
if (isosur1style==5) isosur1style=3
call drawmol
end subroutine
subroutine setisosur2solidmesh(id)
integer,intent (in) :: id
isosur2style=4
if (isosur1style==5) isosur1style=4
call drawmol
end subroutine
subroutine setisosur2tpr(id)
integer,intent (in) :: id
isosur1style=5
isosur2style=5
call drawmol
end subroutine
!----
subroutine setisosurallsolid(id)
integer,intent (in) :: id
isosur1style=1
isosur2style=1
call drawmol
end subroutine
subroutine setisosurallline(id)
integer,intent (in) :: id
isosur1style=2
isosur2style=2
call drawmol
end subroutine
subroutine setisosurallpoint(id)
integer,intent (in) :: id
isosur1style=3
isosur2style=3
call drawmol
end subroutine
subroutine setisosurallsolidmesh(id)
integer,intent (in) :: id
isosur1style=4
isosur2style=4
call drawmol
end subroutine
subroutine setisosuralltpr(id)
integer,intent (in) :: id
isosur1style=5
isosur2style=5
call drawmol
end subroutine

!Set color for solid representation of isosurface 1
subroutine setisosur1solidclr(id)
integer,intent (in) :: id
character inpstring*30
CALL SWGWTH(40)
write(inpstring,"(f4.2,',',f4.2,',',f4.2)") clrRcub1same,clrGcub1same,clrBcub1same
call dwgtxt("Input R,G,B value, for the same sign part",inpstring)
read(inpstring,*) clrRcub1same,clrGcub1same,clrBcub1same
write(inpstring,"(f4.2,',',f4.2,',',f4.2)") clrRcub1oppo,clrGcub1oppo,clrBcub1oppo
call dwgtxt("Input R,G,B value, for the opposite sign part",inpstring)
read(inpstring,*) clrRcub1oppo,clrGcub1oppo,clrBcub1oppo
call drawmol
CALL SWGWTH(20) !Recover default
end subroutine

!Exchange positive and negative colors for isosurface 1
subroutine setisosur1invclr(id)
integer,intent (in) :: id
tmp1=clrRcub1same
tmp2=clrGcub1same
tmp3=clrBcub1same
clrRcub1same=clrRcub1oppo
clrGcub1same=clrGcub1oppo
clrBcub1same=clrBcub1oppo
clrRcub1oppo=tmp1
clrGcub1oppo=tmp2
clrBcub1oppo=tmp3
tmp1=clrRcub1samemeshpt
tmp2=clrGcub1samemeshpt
tmp3=clrBcub1samemeshpt
clrRcub1samemeshpt=clrRcub1oppomeshpt
clrGcub1samemeshpt=clrGcub1oppomeshpt
clrBcub1samemeshpt=clrBcub1oppomeshpt
clrRcub1oppomeshpt=tmp1
clrGcub1oppomeshpt=tmp2
clrBcub1oppomeshpt=tmp3
call drawmol
end subroutine

!Set color for mesh and points representation of isosurface 1
subroutine setisosur1meshptclr(id)
integer,intent (in) :: id
character inpstring*30
CALL SWGWTH(40)
write(inpstring,"(f4.2,',',f4.2,',',f4.2)") clrRcub1samemeshpt,clrGcub1samemeshpt,clrBcub1samemeshpt
call dwgtxt("Input R,G,B value, for the same sign part",inpstring)
read(inpstring,*) clrRcub1samemeshpt,clrGcub1samemeshpt,clrBcub1samemeshpt
write(inpstring,"(f4.2,',',f4.2,',',f4.2)") clrRcub1oppomeshpt,clrGcub1oppomeshpt,clrBcub1oppomeshpt
call dwgtxt("Input R,G,B value, for the opposite sign part",inpstring)
read(inpstring,*) clrRcub1oppomeshpt,clrGcub1oppomeshpt,clrBcub1oppomeshpt
call drawmol
CALL SWGWTH(20) !Recover default
end subroutine

!Set opacity for transparent face representation of isosurface 1
subroutine setisosur1opa(id)
integer,intent (in) :: id
character inpstring*30
CALL SWGWTH(40)
write(inpstring,"(f4.2)") opacitycub1
call dwgtxt("Input opacity, between 0.0 and 1.0",inpstring)
read(inpstring,*) opacitycub1
call drawmol
CALL SWGWTH(20) !Recover default
end subroutine

!Set color for solid representation of isosurface 2
subroutine setisosur2solidclr(id)
integer,intent (in) :: id
character inpstring*30
CALL SWGWTH(40)
write(inpstring,"(f4.2,',',f4.2,',',f4.2)") clrRcub2same,clrGcub2same,clrBcub2same
call dwgtxt("Input R,G,B value, for the same sign part",inpstring)
read(inpstring,*) clrRcub2same,clrGcub2same,clrBcub2same
write(inpstring,"(f4.2,',',f4.2,',',f4.2)") clrRcub2oppo,clrGcub2oppo,clrBcub2oppo
call dwgtxt("Input R,G,B value, for the opposite sign part",inpstring)
read(inpstring,*) clrRcub2oppo,clrGcub2oppo,clrBcub2oppo
call drawmol
CALL SWGWTH(20) !Recover default
end subroutine

!Set color for mesh and points representation of isosurface 2
subroutine setisosur2meshptclr(id)
integer,intent (in) :: id
character inpstring*30
CALL SWGWTH(40)
write(inpstring,"(f4.2,',',f4.2,',',f4.2)") clrRcub2samemeshpt,clrGcub2samemeshpt,clrBcub2samemeshpt
call dwgtxt("Input R,G,B value, for the same sign part",inpstring)
read(inpstring,*) clrRcub2samemeshpt,clrGcub2samemeshpt,clrBcub2samemeshpt
write(inpstring,"(f4.2,',',f4.2,',',f4.2)") clrRcub2oppomeshpt,clrGcub2oppomeshpt,clrBcub2oppomeshpt
call dwgtxt("Input R,G,B value, for the opposite sign part",inpstring)
read(inpstring,*) clrRcub2oppomeshpt,clrGcub2oppomeshpt,clrBcub2oppomeshpt
call drawmol
CALL SWGWTH(20) !Recover default
end subroutine

!Set opacity for transparent face representation of isosurface 2
subroutine setisosur2opa(id)
integer,intent (in) :: id
character inpstring*30
CALL SWGWTH(40)
write(inpstring,"(f4.2)") opacitycub2
call dwgtxt("Input opacity, between 0.0 and 1.0",inpstring)
read(inpstring,*) opacitycub2
call drawmol
CALL SWGWTH(20) !Recover default
end subroutine

subroutine setlight(id)
integer,intent (in) :: id
call SWGPOP("NOOK")  !Don't show OK&QUIT&HELP in upper menu
call SWGPOP("NOQUIT")
call SWGPOP("NOHELP")
CALL swgtit("Set lightings")
call swgwth(20)
CALL WGINI('VERT',idiswindow)
call swgatt(idiswindow,"INACTIVE","CLOSE") !Disable close button
call swgatt(idiswindow,"OFF","MAXI") !Disable maximization button
call wgbut(idiswindow,"Light 1",ienablelight1,idissetlight1)
call wgbut(idiswindow,"Light 2",ienablelight2,idissetlight2)
call wgbut(idiswindow,"Light 3",ienablelight3,idissetlight3)
call wgbut(idiswindow,"Light 4",ienablelight4,idissetlight4)
call wgbut(idiswindow,"Light 5",ienablelight5,idissetlight5)
call wgpbut(idiswindow,"RETURN",idisreturn)
call SWGCBK(idissetlight1,setlight1)
call SWGCBK(idissetlight2,setlight2)
call SWGCBK(idissetlight3,setlight3)
call SWGCBK(idissetlight4,setlight4)
call SWGCBK(idissetlight5,setlight5)
call SWGCBK(idisreturn,GUIreturn)
CALL WGFIN
end subroutine

!Set lighting 1~5
subroutine setlight1(id)
integer,intent (in) :: id
if (ienablelight1==1) then
	ienablelight1=0
else
	ienablelight1=1
end if
call drawmol
end subroutine
subroutine setlight2(id)
integer,intent (in) :: id
if (ienablelight2==1) then
	ienablelight2=0
else
	ienablelight2=1
end if
call drawmol
end subroutine
subroutine setlight3(id)
integer,intent (in) :: id
if (ienablelight3==1) then
	ienablelight3=0
else
	ienablelight3=1
end if
call drawmol
end subroutine
subroutine setlight4(id)
integer,intent (in) :: id
if (ienablelight4==1) then
	ienablelight4=0
else
	ienablelight4=1
end if
call drawmol
end subroutine
subroutine setlight5(id)
integer,intent (in) :: id
if (ienablelight5==1) then
	ienablelight5=0
else
	ienablelight5=1
end if
call drawmol
end subroutine



!!----------- Routine for setting box
subroutine setboxsizeX(id)
use defvar
integer,intent (in) :: id
call GWGSCL(id,boxlenX)
call updatebox
end subroutine

subroutine setboxsizeY(id)
use defvar
integer,intent (in) :: id
call GWGSCL(id,boxlenY)
call updatebox
end subroutine

subroutine setboxsizeZ(id)
use defvar
integer,intent (in) :: id
call GWGSCL(id,boxlenZ)
call updatebox
end subroutine

subroutine setboxcenX(id)
use defvar
integer,intent (in) :: id
call GWGSCL(id,boxcenX)
call updatebox
end subroutine

subroutine setboxcenY(id)
use defvar
integer,intent (in) :: id
call GWGSCL(id,boxcenY)
call updatebox
end subroutine

subroutine setboxcenZ(id)
use defvar
integer,intent (in) :: id
call GWGSCL(id,boxcenZ)
call updatebox
end subroutine

subroutine setboxspc(id)
use defvar
integer,intent (in) :: id
character*12 ngridstr
call GWGSCL(id,grdspc)
dx=grdspc
dy=grdspc
dz=grdspc
gridvec1=0;gridvec1(1)=dx
gridvec2=0;gridvec2(2)=dy
gridvec3=0;gridvec3(3)=dz
nx=boxlenX/dx+1
ny=boxlenY/dy+1
nz=boxlenZ/dz+1
ngrid=nx*ny*nz
write(ngridstr,"(i11)") ngrid
call SWGTXT(idisnpt,ngridstr)
end subroutine

!------- Calculate box setting (orgx,orgy,orgz,endx,endy,endz,nx,ny,nz) according to (boxlenX,boxlenY,boxlenZ,boxcenX,boxcenY,boxcenZ,dx,dy,dz)
subroutine updatebox
use defvar
character*12 ngridstr
orgx=boxcenX-boxlenX/2
endx=boxcenX+boxlenX/2
orgy=boxcenY-boxlenY/2
endy=boxcenY+boxlenY/2
orgz=boxcenZ-boxlenZ/2
endz=boxcenZ+boxlenZ/2
nx=boxlenX/dx+1
ny=boxlenY/dy+1
nz=boxlenZ/dz+1
ngrid=nx*ny*nz
write(ngridstr,"(i11)") ngrid
call SWGTXT(idisnpt,ngridstr)
call drawmol
end subroutine

subroutine showbasinvdw(id)
use basinintmod
integer,intent (in) :: id
ishowbasinmethod=2
if (ifuncbasin==1.and..not.allocated(rhocub)) then
    allocate(rhocub(nx,ny,nz))
    rhocub=cubmat
end if
call saverhocub !Calculate electron density and store to rhocub if rhocub is not available
call drawmol
end subroutine

subroutine showbasinall(id)
use basinintmod
integer,intent (in) :: id
ishowbasinmethod=1
call drawmol
end subroutine

subroutine setbasinsphsize(id)
use basinintmod
use defvar
integer,intent (in) :: id
character c80tmp*80
if (basinsphsize==0) basinsphsize=dsqrt(dx**2+dy**2+dz**2)/2D0
write(c80tmp,"(f6.3)") basinsphsize
CALL SWGWTH(50)
CALL swgtit("Set sphere size")
call dwgtxt("Input size of spheres for showing basins, e.g. 0.1",c80tmp)
read(c80tmp,*) basinsphsize
call drawmol
end subroutine


!!----------- GUI for measuring geometry between 2/3/4 atoms
subroutine measuregeom(id)
integer,intent (in) :: id
CALL swgtit("Measure geometry")
if (isys==1) then
    call swgwth(55)
else
    call swgwth(60)
end if
CALL WGINI('VERT',idiswindow)
call swgatt(idiswindow,"INACTIVE","CLOSE") !Disable close button
call swgatt(idiswindow,"OFF","MAXI") !Disable maximization button
CALL SWGJUS("CENTER","LABEL") !Center the label text
call WGLAB(idiswindow,"Input 2/3/4 atoms to measure distance/angle/dihedral",itext)
call WGLAB(idiswindow,"Press ENTER button after inputting",itext)
CALL WGBAS(idiswindow,"HORI",idishori)
CALL SWGWTH(8)
CALL SWGSPC(2D0,0.5D0) !Set space between widgets below
call WGLAB(idishori,"Atoms:",itext2)
call WGTXT(idishori," ",iatm1text)
call WGTXT(idishori," ",iatm2text)
call WGTXT(idishori," ",iatm3text)
call WGTXT(idishori," ",iatm4text)
call WGLAB(idiswindow," ",igeomresult)
CALL WGBAS(idiswindow,"FORM",idisbottom)
CALL SWGSIZ(100,35)
!call SWGPOS(200,0) !Make RETURN button at middle point, however in other screen resolution case, this expectation cannot be met
call wgpbut(idisbottom,"RETURN",idisreturn)
call SWGCBK(idisreturn,GUIreturn)
call SWGCBK(iatm1text,domeasure)
call SWGCBK(iatm2text,domeasure)
call SWGCBK(iatm3text,domeasure)
call SWGCBK(iatm4text,domeasure)
CALL WGFIN
end subroutine
!----- The routine actually used to display bond/angle/dihedral, invoked by measuregeom
subroutine domeasure(id)
use defvar
use util
integer,intent (in) :: id
character atm1text*10,atm2text*10,atm3text*10,atm4text*10,resultstr*40
iatm1=0;iatm2=0;iatm3=0;iatm4=0
call GWGTXT(iatm1text,atm1text)
call GWGTXT(iatm2text,atm2text)
call GWGTXT(iatm3text,atm3text)
call GWGTXT(iatm4text,atm4text)
if (atm1text/=" ") read(atm1text,*) iatm1
if (atm2text/=" ") read(atm2text,*) iatm2
if (atm3text/=" ") read(atm3text,*) iatm3
if (atm4text/=" ") read(atm4text,*) iatm4
resultstr=" "
if (atm1text/=" ".and.atm2text/=" ".and.atm3text/=" ".and.atm4text/=" ") then
    if (iatm1<1.or.iatm1>ncenter.or.iatm2<1.or.iatm2>ncenter.or.iatm3<1.or.iatm3>ncenter.or.iatm4<1.or.iatm4>ncenter) then
        resultstr="Error: Atom index exceeded valid range!"
    else
        tmpval=xyz2dih(a(iatm1)%x,a(iatm1)%y,a(iatm1)%z,a(iatm2)%x,a(iatm2)%y,a(iatm2)%z,a(iatm3)%x,a(iatm3)%y,a(iatm3)%z,a(iatm4)%x,a(iatm4)%y,a(iatm4)%z)
        write(resultstr,"('Dihedral:',f10.4,' degree')") tmpval
    end if
else if (atm1text/=" ".and.atm2text/=" ".and.atm3text/=" ") then
    if (iatm1<1.or.iatm1>ncenter.or.iatm2<1.or.iatm2>ncenter.or.iatm3<1.or.iatm3>ncenter) then
        resultstr="Error: Atom index exceeded valid range!"
    else
        tmpval=xyz2angle(a(iatm1)%x,a(iatm1)%y,a(iatm1)%z,a(iatm2)%x,a(iatm2)%y,a(iatm2)%z,a(iatm3)%x,a(iatm3)%y,a(iatm3)%z)
        write(resultstr,"('Angle:',f10.4,' degree')") tmpval
    end if
else if (atm1text/=" ".and.atm2text/=" ") then
    if (iatm1<1.or.iatm1>ncenter.or.iatm2<1.or.iatm2>ncenter) then
        resultstr="Error: Atom index exceeded valid range!"
    else
        tmpval=xyz2dist(a(iatm1)%x,a(iatm1)%y,a(iatm1)%z,a(iatm2)%x,a(iatm2)%y,a(iatm2)%z)
        write(resultstr,"('Distance:',f10.5,' Angstrom')") tmpval*b2a
    end if
else
    resultstr="You should at least input two atoms!"
end if
call SWGTXT(igeomresult,resultstr)
end subroutine




!!!-------- Select a fragment in GUI
subroutine GUIselfrag(id)
use defvar
use util
integer,intent (in) :: id
character c80tmp*80,c2000tmp*2000
integer iffrag(ncenter)
c80tmp=" "
CALL SWGWTH(50)
CALL swgtit("Select fragment")
call dwgtxt("Input index of any atom in the fragment, e.g. 3",c80tmp)
if (c80tmp==" ") return
read(c80tmp,*) iatm
if (iatm<1.or.iatm>ncenter) return
call getfragatoms(iatm,iffrag)

!Convert indices of the selected atoms to string
c2000tmp=" "
do iatm=1,ncenter
    if (iffrag(iatm)==1) then
        write(c80tmp,*) iatm
        nsize=len_trim(adjustl(c80tmp))
        if (c2000tmp/=" ") then
            if (iffrag(iatm-1)==1) then !The index is contiguous, use - to connect to last one
                if (iatm<ncenter) then
                    if (iffrag(iatm+1)==1) cycle
                end if
                ntmp=len_trim(c2000tmp) !Modify last comma as -
                c2000tmp(ntmp:ntmp)='-'
            end if
        end if
        c2000tmp=trim(c2000tmp)//trim(adjustl(c80tmp))
        if (any(iffrag(iatm+1:)==1)) write(c2000tmp(len_trim(c2000tmp)+1:),"(a)") ','
    end if
end do

!Highlight atoms in the fragment
if (allocated(highlightatomlist)) deallocate(highlightatomlist)
allocate(highlightatomlist(count(iffrag==1)))
nhigh=0
do iatm=1,ncenter
    if (iffrag(iatm)==1) then
        nhigh=nhigh+1
        highlightatomlist(nhigh)=iatm
    end if
end do
call drawmol

if (isys==1) then
    CALL SWGWTH(50)
    call dwgtxt("Indices of the atoms in the fragment",c2000tmp)
else
    write(*,"(/,' Indices of the atoms in the fragment:',/,a)") trim(c2000tmp)
    CALL SWGWTH(50)
    call dwgmsg("The atoms in the fragment have been highlighted, their indices have been shown in console window")
end if
deallocate(highlightatomlist)
call drawmol
end subroutine




!!!-------- Plot a batch of orbitals
subroutine batchplot(id)
use defvar
use util
integer,intent (in) :: id
character c2000tmp*2000,c80tmp*80
integer batchlist(nmo)
c2000tmp=" "
CALL SWGWTH(100)
CALL swgtit("Save isosurface of a batch of orbitals as graphical file")
call dwgtxt("Input orbital indices, e.g. 3,7-11,23 (Negative index is not supported)",c2000tmp)
if (c2000tmp==" ") return
call str2arr(c2000tmp,norb,batchlist)
isavepic=1
do idx=1,norb
    iorbvis=batchlist(idx)
    call showorbsel(inouse,iorbvis)
    write(*,"(a,i6.6,a)") " Saved image file with ",iorbvis," prefix in current folder"
end do
isavepic=0
write(*,*) "Done!"
CALL SWGWTH(20) !Recover default
end subroutine




!!!-------- Set highlighting for a batch of atoms
subroutine sethighlightatom(id)
use defvar
use util
integer,intent (in) :: id
character c2000tmp*2000
if (allocated(highlightatomlist)) deallocate(highlightatomlist)
c2000tmp=" "
CALL SWGWTH(100)
CALL swgtit("Set highlighting for a batch of atoms")
call dwgtxt("Input indices of the atoms to be highlighted, e.g. 3,7-11,23",c2000tmp)
CALL SWGWTH(20) !Recover default
if (c2000tmp/=" ") then
    call str2arr(c2000tmp,ntmp)
    allocate(highlightatomlist(ntmp))
    call str2arr(c2000tmp,ntmp,highlightatomlist)
end if
call drawmol
end subroutine


!!!-------- Write GUI setting to GUIsettings.ini current folder
subroutine writeGUIsetting(id)
use defvar
integer,intent (in) :: id
character*200 c200tmp
call getenv("Multiwfnpath",c200tmp)
if (c200tmp/=" ") then
    c200tmp=trim(c200tmp)//"/GUIsettings.ini"
    call dwgmsg("Settings have been written to GUIsettings.ini in the folder defined by ""Multiwfnpath"" environment variable")
else
    c200tmp="GUIsettings.ini"
    call dwgmsg("Settings have been written to GUIsettings.ini in current folder")
end if
open(10,file=c200tmp,status="replace")
write(10,*) "nprevorbgrid      ",nprevorbgrid
write(10,*) "aug3D             ",aug3D
write(10,*) "sur_value         ",sur_value
write(10,*) "ishowhydrogen     ",ishowhydrogen
write(10,*) "iatmlabtype3D     ",iatmlabtype3D
write(10,*) "atmlabclrR        ",atmlabclrR
write(10,*) "atmlabclrG        ",atmlabclrG
write(10,*) "atmlabclrB        ",atmlabclrB
write(10,*) "ienablelight1     ",ienablelight1
write(10,*) "ienablelight2     ",ienablelight2
write(10,*) "ienablelight3     ",ienablelight3
write(10,*) "ienablelight4     ",ienablelight4
write(10,*) "ienablelight5     ",ienablelight5
write(10,*) "ishowatmlab       ",ishowatmlab
write(10,*) "ishowaxis         ",ishowaxis
write(10,*) "isosur1style      ",isosur1style
write(10,*) "isosur2style      ",isosur2style
write(10,*) "bondcrit          ",bondcrit
write(10,*) "textheigh         ",textheigh
write(10,*) "ratioatmsphere    ",ratioatmsphere
write(10,*) "bondradius        ",bondradius
write(10,*) "XVU               ",XVU
write(10,*) "YVU               ",YVU
write(10,*) "ZVU               ",ZVU
write(10,*) "opacitycub1       ",opacitycub1
write(10,*) "opacitycub2       ",opacitycub2
write(10,*) "clrRcub1same      ",clrRcub1same
write(10,*) "clrGcub1same      ",clrGcub1same
write(10,*) "clrBcub1same      ",clrBcub1same
write(10,*) "clrRcub1oppo      ",clrRcub1oppo
write(10,*) "clrGcub1oppo      ",clrGcub1oppo
write(10,*) "clrBcub1oppo      ",clrBcub1oppo
write(10,*) "clrRcub2same      ",clrRcub2same
write(10,*) "clrGcub2same      ",clrGcub2same
write(10,*) "clrBcub2same      ",clrBcub2same
write(10,*) "clrRcub2oppo      ",clrRcub2oppo
write(10,*) "clrGcub2oppo      ",clrGcub2oppo
write(10,*) "clrBcub2oppo      ",clrBcub2oppo
write(10,*) "clrRcub1samemeshpt",clrRcub1samemeshpt
write(10,*) "clrGcub1samemeshpt",clrGcub1samemeshpt
write(10,*) "clrBcub1samemeshpt",clrBcub1samemeshpt
write(10,*) "clrRcub1oppomeshpt",clrRcub1oppomeshpt
write(10,*) "clrGcub1oppomeshpt",clrGcub1oppomeshpt
write(10,*) "clrBcub1oppomeshpt",clrBcub1oppomeshpt
write(10,*) "clrRcub2samemeshpt",clrRcub2samemeshpt
write(10,*) "clrGcub2samemeshpt",clrGcub2samemeshpt
write(10,*) "clrBcub2samemeshpt",clrBcub2samemeshpt
write(10,*) "clrRcub2oppomeshpt",clrRcub2oppomeshpt
write(10,*) "clrGcub2oppomeshpt",clrGcub2oppomeshpt
write(10,*) "clrBcub2oppomeshpt",clrBcub2oppomeshpt
close(10)
end subroutine


!!!-------- load GUI setting from GUIsettings.ini current folder
subroutine loadGUIsetting(id)
use defvar
integer,intent (in) :: id
character c30tmp*30,c200tmp*200
logical alive1,alive2
call getenv("Multiwfnpath",c200tmp)
inquire(file=trim(c200tmp)//"/GUIsettings.ini",exist=alive1)
if (alive1) then
    open(10,file=trim(c200tmp)//"/GUIsettings.ini",status="old")
else
    inquire(file="GUIsettings.ini",exist=alive2)
    if (alive2) open(10,file="GUIsettings.ini",status="old")
end if
if (alive1.or.alive2) then
    read(10,*) c30tmp,nprevorbgrid
    read(10,*) c30tmp,aug3D
    read(10,*) c30tmp,sur_value
    read(10,*) c30tmp,ishowhydrogen
    read(10,*) c30tmp,iatmlabtype3D
    read(10,*) c30tmp,atmlabclrR
    read(10,*) c30tmp,atmlabclrG
    read(10,*) c30tmp,atmlabclrB
    read(10,*) c30tmp,ienablelight1
    read(10,*) c30tmp,ienablelight2
    read(10,*) c30tmp,ienablelight3
    read(10,*) c30tmp,ienablelight4
    read(10,*) c30tmp,ienablelight5
    read(10,*) c30tmp,ishowatmlab
    read(10,*) c30tmp,ishowaxis
    read(10,*) c30tmp,isosur1style
    read(10,*) c30tmp,isosur2style
    read(10,*) c30tmp,bondcrit
    read(10,*) c30tmp,textheigh
    read(10,*) c30tmp,ratioatmsphere
    read(10,*) c30tmp,bondradius
    read(10,*) c30tmp,XVU
    read(10,*) c30tmp,YVU
    read(10,*) c30tmp,ZVU
    read(10,*) c30tmp,opacitycub1
    read(10,*) c30tmp,opacitycub2
    read(10,*) c30tmp,clrRcub1same
    read(10,*) c30tmp,clrGcub1same
    read(10,*) c30tmp,clrBcub1same
    read(10,*) c30tmp,clrRcub1oppo
    read(10,*) c30tmp,clrGcub1oppo
    read(10,*) c30tmp,clrBcub1oppo
    read(10,*) c30tmp,clrRcub2same
    read(10,*) c30tmp,clrGcub2same
    read(10,*) c30tmp,clrBcub2same
    read(10,*) c30tmp,clrRcub2oppo
    read(10,*) c30tmp,clrGcub2oppo
    read(10,*) c30tmp,clrBcub2oppo
    read(10,*) c30tmp,clrRcub1samemeshpt
    read(10,*) c30tmp,clrGcub1samemeshpt
    read(10,*) c30tmp,clrBcub1samemeshpt
    read(10,*) c30tmp,clrRcub1oppomeshpt
    read(10,*) c30tmp,clrGcub1oppomeshpt
    read(10,*) c30tmp,clrBcub1oppomeshpt
    read(10,*) c30tmp,clrRcub2samemeshpt
    read(10,*) c30tmp,clrGcub2samemeshpt
    read(10,*) c30tmp,clrBcub2samemeshpt
    read(10,*) c30tmp,clrRcub2oppomeshpt
    read(10,*) c30tmp,clrGcub2oppomeshpt
    read(10,*) c30tmp,clrBcub2oppomeshpt
    close(10)
    call drawmol
    if (alive1) then
        write(*,"(a)") " Settings have been loaded from the GUIsettings.ini in the folder defined by ""Multiwfnpath"""
    else if (alive2) then
        write(*,*) "Settings have been loaded from GUIsettings.ini in current folder"
    end if
else
    call dwgmsg("Error: Cannot find GUIsettings.ini in either current folder or the folder defined by ""Multiwfnpath""")
end if
end subroutine


end module