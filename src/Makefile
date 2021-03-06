SIMD = -msse3
OPT = -O2 -qopenmp -qopenmp-link=static -threads -qopt-matmul $(SIMD) -diag-disable 8290,8291,6371,10316 -fpp -mkl -static-intel
#Options in the next line is for debugging purpose
#OPT = -O0 -qopenmp -diag-disable 8290,8291,6371 -threads -qopenmp-link=static -debug all -g -traceback -check all -fstack-protector -fpp -mkl -static-intel

LIB = ./dislin_d-11.0.a -lXm -lXt -lX11 -lGL #Works for CentOS 7.x
FC = ifort
EXE = Multiwfn
LIBRETAPATH = ./libreta_slow

objects = define.o util.o plot.o Bspline.o sym.o libreta.o function.o GUI.o sub.o integral.o Lebedev-Laikov.o \
DFTxclib.o edflib.o fileIO.o spectrum.o DOS.o Multiwfn.o 0123dim.o LSB.o \
population.o orbcomp.o bondorder.o topology.o excittrans.o otherfunc.o \
otherfunc2.o otherfunc3.o surfana.o procgriddata.o AdNDP.o fuzzy.o CDA.o basin.o \
orbloc.o visweak.o EDA.o atmraddens.o NAONBO.o minpack.o ean.o hrr_012345.o eanvrr_012345.o boysfunc.o

default : $(objects) 
	$(FC) $(OPT) $(objects) $(LIB) -o $(EXE)
	@echo " ------------------------------------------------------ " 
	@echo "          Multiwfn has been successfully built." 
	@echo " ------------------------------------------------------ " 

clean:
	rm -f $(EXE) *.o *.mod

cleanlibreta:
	rm -f $(EXE) libreta.o ean.o hrr_012345.o eanvrr_012345.o \
	boysfunc.o libreta.mod hrr.mod ean.mod eanvrr.mod boysfunc.mod


#Define modules that used by other files

dislin_d.mod : dislin_d.f90
	$(FC) $(OPT) -c dislin_d.f90

define.o : define.f90 dislin_d.mod
	$(FC) $(OPT) -c define.f90

Bspline.o : Bspline.f90
	$(FC) $(OPT) -c Bspline.f90

util.o : util.f90 define.o
	$(FC) $(OPT) -c util.f90

function.o : function.f90 define.o util.o Bspline.o libreta.o
	$(FC) $(OPT) -c function.f90

plot.o : plot.f90 define.o util.o
	$(FC) $(OPT) -c plot.f90

GUI.o : GUI.f90 define.o plot.o function.o
	$(FC) $(OPT) -c GUI.f90

modules = define.o util.o function.o plot.o GUI.o libreta.o


#Library or adpated third-part codes

DFTxclib.o : DFTxclib.F
	$(FC) $(OPT) -c DFTxclib.F

Lebedev-Laikov.o : Lebedev-Laikov.F
	$(FC) $(OPT) -c Lebedev-Laikov.F

sym.o : sym.F
	$(FC) $(OPT) -c sym.F

edflib.o : edflib.f90
	$(FC) $(OPT) -c edflib.f90

atmraddens.o : atmraddens.f90
	$(FC) $(OPT) -c atmraddens.f90

minpack.o : minpack.f90
	$(FC) $(OPT) -c minpack.f90
	

#Others

sub.o : sub.f90 $(modules)
	$(FC) $(OPT) -c sub.f90

integral.o : integral.f90 $(modules)
	$(FC) $(OPT) -c integral.f90

fileIO.o : fileIO.f90 $(modules)
	$(FC) $(OPT) -c fileIO.f90

spectrum.o : spectrum.f90 $(modules)
	$(FC) $(OPT) -c spectrum.f90

DOS.o : DOS.f90 $(modules)
	$(FC) $(OPT) -c DOS.f90

Multiwfn.o : Multiwfn.f90 $(modules)
	$(FC) $(OPT) -c Multiwfn.f90

0123dim.o : 0123dim.f90 $(modules)
	$(FC) $(OPT) -c 0123dim.f90

LSB.o : LSB.f90 $(modules)
	$(FC) $(OPT) -c LSB.f90

population.o : population.f90 $(modules)
	$(FC) $(OPT) -c population.f90

orbcomp.o : orbcomp.f90 $(modules)
	$(FC) $(OPT) -c orbcomp.f90

bondorder.o : bondorder.f90 $(modules)
	$(FC) $(OPT) -c bondorder.f90

topology.o : topology.f90 $(modules)
	$(FC) $(OPT) -c topology.f90

excittrans.o : excittrans.f90 $(modules)
	$(FC) $(OPT) -c excittrans.f90

otherfunc.o : otherfunc.f90 $(modules)
	$(FC) $(OPT) -c otherfunc.f90

otherfunc2.o : otherfunc2.f90 $(modules)
	$(FC) $(OPT) -c otherfunc2.f90

otherfunc3.o : otherfunc3.f90 $(modules)
	$(FC) $(OPT) -c otherfunc3.f90

surfana.o : surfana.f90 $(modules)
	$(FC) $(OPT) -c surfana.f90

procgriddata.o : procgriddata.f90 $(modules)
	$(FC) $(OPT) -c procgriddata.f90

AdNDP.o : AdNDP.f90 $(modules)
	$(FC) $(OPT) -c AdNDP.f90

fuzzy.o : fuzzy.f90 $(modules)
	$(FC) $(OPT) -c fuzzy.f90

CDA.o : CDA.f90 $(modules)
	$(FC) $(OPT) -c CDA.f90

basin.o : basin.f90 $(modules)
	$(FC) $(OPT) -c basin.f90

orbloc.o : orbloc.f90 $(modules)
	$(FC) $(OPT) -c orbloc.f90

visweak.o : visweak.f90 $(modules)
	$(FC) $(OPT) -c visweak.f90

EDA.o : EDA.f90 $(modules)
	$(FC) $(OPT) -c EDA.f90

NAONBO.o : NAONBO.f90 $(modules)
	$(FC) $(OPT) -c NAONBO.f90



# Interfaces of libreta to Multiwfn

libreta.o: ${LIBRETAPATH}/libreta.f90 ean.o hrr_012345.o eanvrr_012345.o boysfunc.o
	$(FC) $(OPT) -c ${LIBRETAPATH}/libreta.f90

# Pure libreta files

ean.o: ${LIBRETAPATH}/ean.f90 hrr_012345.o eanvrr_012345.o boysfunc.o ${LIBRETAPATH}/ean_data1.h ${LIBRETAPATH}/ean_data2.h
	$(FC) $(OPT) -c ${LIBRETAPATH}/ean.f90

hrr_012345.o: ${LIBRETAPATH}/hrr_012345.f90
	$(FC) -O2 -diag-disable 6843 $(SIMD) -c ${LIBRETAPATH}/hrr_012345.f90

eanvrr_012345.o: ${LIBRETAPATH}/eanvrr_012345.f90 boysfunc.o
	$(FC) $(OPT) -c ${LIBRETAPATH}/eanvrr_012345.f90

boysfunc.o: ${LIBRETAPATH}/boysfunc.f90 ${LIBRETAPATH}/boysfunc_data1.h ${LIBRETAPATH}/boysfunc_data2.h
	$(FC) $(OPT) -c ${LIBRETAPATH}/boysfunc.f90
