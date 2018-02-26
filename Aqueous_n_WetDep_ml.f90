! <Aqueous_n_WetDep_ml.f90 - A component of the EMEP MSC-W Chemical transport Model, version rv4.17>
!*****************************************************************************!
!*
!*  Copyright (C) 2007-2018 met.no
!*
!*  Contact information:
!*  Norwegian Meteorological Institute
!*  Box 43 Blindern
!*  0313 OSLO
!*  NORWAY
!*  email: emep.mscw@met.no
!*  http://www.emep.int
!*
!*    This program is free software: you can redistribute it and/or modify
!*    it under the terms of the GNU General Public License as published by
!*    the Free Software Foundation, either version 3 of the License, or
!*    (at your option) any later version.
!*
!*    This program is distributed in the hope that it will be useful,
!*    but WITHOUT ANY WARRANTY; without even the implied warranty of
!*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!*    GNU General Public License for more details.
!*
!*    You should have received a copy of the GNU General Public License
!*    along with this program.  If not, see <http://www.gnu.org/licenses/>.
!*****************************************************************************!
module Aqueous_ml
!-----------------------------------------------------------------------
! Aqueous scavenging and cloud-processing routines.
!
! The scavenging of soluble compounds is based upon the work of Berge
! and Jakobsen (1998) and Eliassen and Saltbones (1983).
! Simple scavenging coefficients are used. A distinction is made
! between in-cloud and sub-cloud scavenging.
!
! Usage:
!
! imports CM_WetDep.inc, which gives the chemistry-dependent species and
! associated rates (generated by GenChem.pl)
!
! Setup_Clouds(i,j)  called from Runchem_ml
! WetDeposition(i,j) called from Runchem_ml if prec. clouds are present
!
! Refs:
! Berge, E., 1993, Coupling of wet scavenging of sulphur to clouds in a
!    numerical weather prediction model, Tellus, 45B, 1-22
! Berge, E. and Jakobsen, H.A., 1998, {A regional scale multi-layer model for
!    the calculation of long-term transport and deposition of air pollution in
!    Europe, Tellus, 50,205-223
! Eliassen, A. and Saltbones, J., 1983, Modelling of long-range transport of
!    sulphur over Europe: a two year model run and some experiments, Atmos.
!    Environ., 17, 1457-1473
! Seland, O. and T. Iversen (1999) A scheme for black carbon and
!    sulphate aerosols tested in a hemispheric scale, Eulerian dispersion
!    model. Atm.  Env. Vol. 33, pp.2853-2879.
!-----------------------------------------------------------------------

use My_Derived_ml,    only: WDEP_WANTED ! Which outputs wanted!
use My_Derived_ml,    only: nWDEP => nOutputWdep ! number WDEP used
use CheckStop_ml,     only: CheckStop
use ChemSpecs                 
use ChemGroups_ml,    only: ChemGroups
use DerivedFields_ml, only: f_2d, d_2d     ! Contains Wet deposition fields
use GridValues_ml,    only: gridwidth_m,xm2,dA,dB
use Io_ml,            only: IO_DEBUG, datewrite
use MassBudget_ml,    only : wdeploss,totwdep
use Config_module,only: &
    CHEMTMIN, CHEMTMAX      &       ! -> range of temperature
   ,MasterProc              &
   ,DEBUG   &  !  => DEBUG%AQUEOUS, DEBUG%MY_WETDEP, DEBUG%pH &
   ,KMAX_MID                &       ! -> ground, k=20
   ,KUPPER                  &       ! -> top of cloud-chemistry, k=6
   ,KCHEMTOP                &       ! -> top of chemistry, now k=2
   ,dt => dt_advec          &       ! -> model timestep
   ,IOU_INST                        ! Index: instantaneous values
use MetFields_ml,       only: pr, roa, z_bnd, cc3d, lwc
use MetFields_ml,       only: ps
use OrganicAerosol_ml,  only: ORGANIC_AEROSOLS
use OwnDataTypes_ml,    only: depmap  ! has adv, calc, vg
use Par_ml,             only: limax,ljmax, me,li0,li1,lj0,lj1
use PhysicalConstants_ml,only: GRAV,AVOG,  &    ! "g" & Avogadro's No.
                               ATWAIR,&         ! Mol. weight of air(Jones,1992)
                               RGAS_ATML,RGAS_J ! Gas-constant
use Setup_1dfields_ml,  only: xn_2d, amk, Fpart, Fgas, &
                              temp, itemp        ! temperature (K)
use SmallUtils_ml,      only: find_index
use Units_ml,           only: Group_Scale,group_umap

implicit none
private

! Subroutines:
public :: Init_WetDep       ! Call from Unimod
public :: WetDep_Budget     ! called here
public :: init_aqueous
public :: Setup_Clouds      ! characterises clouds and calls WetDeposition if rain
public :: WetDeposition     ! simplified setup_wetdep
private:: tabulate_aqueous
private:: get_frac
private:: setup_aqurates

! Outputs:
logical, public, save,allocatable, dimension(:) :: &
  incloud              ! True for in-cloud k values
! Variables used in module:
real, private, save,allocatable, dimension(:) :: &
  pr_acc                  ! Accumulated precipitation
!hf NEW (here for debugging)
real, private, save,allocatable, dimension(:) :: &
  pH,so4_aq,no3_aq,nh4_aq,nh3_aq,hso3_aq,so2_aq,so32_aq,co2_aq,hco3_aq   ! pH in cloud

integer, private, save  :: kcloudtop   ! k-level of highest-cloud
integer, private, save  :: ksubcloud   ! k-level just below cloud

real, private, parameter :: & ! Define limits for "cloud"
  PR_LIMIT = 1.0e-7,  &      ! for accumulated precipitation
  CW_LIMIT = 1.0e-10, &      ! for cloud water, kg(H2O)/kg(air)
  B_LIMIT  = 1.0e-3         ! for cloud cover (fraction)

!hf  real, private, save :: &      ! Set in init below
!hf      INV_Hplus          &      ! = 1.0/Hplus       (1/H+)
!hf     ,INV_Hplus0p4              ! = INV_Hplus**0.4  (1/H+)**0.4

! The Henry's law coefficients, K, given in units of M or M atm-1,
! are calculated as effective. A factor K1fac = 1+K1/H+ is defined
! here also.

integer, public, parameter :: &
!hf pH
  NHENRY  = 5, &  ! No. of species with Henry's law applied
  NK1     = 1, &  ! No. of species needing effective Henry's calc.
  IH_SO2  = 1, &
  IH_H2O2 = 2, &
  IH_O3   = 3, &
  IH_NH3  = 4, &     !hf pH
  IH_CO2  = 5
! Aqueous fractions:
real, save,allocatable, public,  dimension(:,:) :: frac_aq
real, private, dimension(NHENRY,CHEMTMIN:CHEMTMAX), save :: H
!hf NEW
real, private, dimension(CHEMTMIN:CHEMTMAX), save :: &
  K1,           & ! K for SO2->HSO3-
  K2,           & ! HSO3->SO32-
  Knh3,         & ! NH3+H20-> NH4+
  Kw,           & ! K for water
  Kco2
! Aqueous reaction rates for usage in gas-phase chemistry:
integer, private, parameter :: &
  NAQUEOUS = 4, & ! No. aqueous rates
  NAQRC    = 3    ! No. constant rates

real, public, save,allocatable, dimension(:,:) :: aqrck
real, private, dimension(NAQRC), save :: aqrc ! constant rates for
                                              ! so2 oxidn.
logical, public,save :: prclouds_present      ! true if precipitating clouds

integer, public, parameter :: &
  ICLOHSO2  = 1, & ! for [oh] + [so2]
  ICLRC1    = 2, & ! for [h2o2] + [so2]
  ICLRC2    = 3, & ! for [o3] + [so2]
  ICLRC3    = 4    ! for [o3] + [o2] (Fe catalytic)

! Incloud scavenging: (only dependant on precipitation (not cloud water)
!-----------------------------------------------------------------------
! The parameterization of the scavenging of soluble chemical
! components is scaled to the precipitation in each layer. For
! incloud scavenging it is based on the parameterization described
! in Berge (1998). The incloud scavenging of a soluble component
! X is given by the expression:
!
!       X * f * pr_acc * W_sca
! Q =  ------------------------
!         Z_sca * rho_water
!
! where pr_acc is the accumulated precipitation in the layer,
! Z_sca is the scavenging depth (scale=1000m) and rho_water is the
! density of water.
! f is an efficiency parameter. The module My_WetDep_ml should
! return the user-defined array WetDep%W_sca, with W_Sca representing
! the value of f.W_Sca/Z_sca/rho_water


! Sub cloud scavenging:
!-----------------------------------------------------------------------
! The sub-cloud scavenging distinguishes between particulate and
! gas-phase components. The scavenging of gases is calculated as
! Q = vw * P, where P is the accumulated precipitation (pr_acc, m)
! from all the layers above. (From setup_1d)
! For particles the scavenging is believed to be much less effective,
! as they follow the air-current around the droplets (Berge, 1993).
! Scavenging for particles is calculated as
!    Q = A.e.P/v
! where A is 5.2 m3 kg-1 s-1, v is the fall-speed of the droplets,
! 5 m s-1, and e is the scavenging efficiency, 0.1.



! ------------ WetDep initialisation (old My_WetDep --------------
type, public :: WScav
  real :: W_sca       ! Scavenging ratio/z_Sca/rho = W_sca/1.0e6
  real :: W_sub       ! same for subcloud
end type WScav

integer, public, parameter :: NWETDEP_CALC =  22 ! No. of solublity classes
!  Note - these are for "master" or model species - they do not
!  need to be present in the chemical scheme. However, the chemical
!  scheme needs to define wet scavenging after these. If you would
!  like other characteristics, add them here.
integer, parameter, public :: &
  CWDEP_SO2  =  1, CWDEP_SO4  =  2, CWDEP_NH3  =  3, CWDEP_HNO3 =  4, &
  CWDEP_H2O2 =  5, CWDEP_HCHO =  6, CWDEP_PMf  =  7, CWDEP_PMc  =  8, &
  CWDEP_ECfn =  9, CWDEP_SSf  = 10, CWDEP_SSc  = 11, CWDEP_SSg  = 12, &
  CWDEP_POLLw= 13, &
  CWDEP_ROOH = 14, &   ! TEST!!
  CWDEP_0p2 = 15, CWDEP_0p3 = 16, CWDEP_0p4 = 17, CWDEP_0p5 = 18, &
  CWDEP_0p6 = 19, CWDEP_0p7 = 20, CWDEP_0p8 = 21, CWDEP_1p3 = 22
integer, parameter, public :: &
  CWDEP_ASH1=CWDEP_PMf,CWDEP_ASH2=CWDEP_PMf,CWDEP_ASH3=CWDEP_PMf,&
  CWDEP_ASH4=CWDEP_PMf,CWDEP_ASH5=CWDEP_PMc,CWDEP_ASH6=CWDEP_PMc,&
  CWDEP_ASH7=CWDEP_PMc

!===========================================!
! Chemistry-dependent mapping:
! WdepMap = (/
!    depmap( HNO3, CWDEP_HNO3, -1) & etc.
! .... produced from GenChem, also with e.g.
!integer, public, parameter ::  NWETDEP_ADV  = 14
!===========================================!
include 'CM_WetDep.inc'
!===========================================!

! And create an array to map from the "calc" to the advected species
! Use zeroth column to store number of species in that row
integer, public, dimension(NWETDEP_CALC,0:NWETDEP_ADV) :: Calc2adv

! arrays for species and groups, e.g. SOX, OXN
integer, private, save :: nwgrp = 0, nwspec = 0  ! no. groups & specs
integer, private, allocatable, dimension(:), save :: wetGroup, wetSpec
type(group_umap), private, allocatable, dimension(:), target, save :: wetGroupUnits

type(WScav), public, dimension(NWETDEP_CALC), save  :: WetDep

integer, public, save  :: WDEP_PREC=-1   ! Used in Aqueous_ml
contains

subroutine Init_WetDep()
  integer :: iadv, igrp, icalc, n, nc, f2d, alloc_err
  character(len=30) :: dname
!/ SUBCLFAC is A/FALLSPEED where A is 5.2 m3 kg-1 s-1,
!  and the fallspeed of the raindroplets is assumed to be 5 m/s.
  real, parameter :: FALLSPEED = 5.0               ! m/s
  real, parameter :: SUBCLFAC = 5.2 / FALLSPEED

!/ e is the scavenging efficiency (0.02 for fine particles, 0.4 for course)
  real, parameter :: EFF25 = 0.02*SUBCLFAC, &
                     EFFCO = 0.4 *SUBCLFAC, &
                     EFFGI = 0.7 *SUBCLFAC

  allocate(incloud(KUPPER:KMAX_MID),pr_acc(KUPPER:KMAX_MID))
  allocate(pH(KUPPER:KMAX_MID),so4_aq(KUPPER:KMAX_MID),no3_aq(KUPPER:KMAX_MID))
  allocate(nh4_aq(KUPPER:KMAX_MID),nh3_aq(KUPPER:KMAX_MID),hso3_aq(KUPPER:KMAX_MID))
  allocate(so2_aq(KUPPER:KMAX_MID),so32_aq(KUPPER:KMAX_MID),co2_aq(KUPPER:KMAX_MID))
  allocate(hco3_aq(KUPPER:KMAX_MID))
  allocate(frac_aq(NHENRY,KUPPER:KMAX_MID))
  allocate(aqrck(NAQUEOUS,KCHEMTOP:KMAX_MID))

!/.. setup the scavenging ratios for in-cloud and sub-cloud. For
!    gases, sub-cloud = 0.5 * incloud. For particles, sub-cloud=
!    efficiency * SUBCLFAC
!/..                             W_Sca  W_sub
  WetDep(CWDEP_SO2)   = WScav(   0.3,  0.15)  ! Berge+Jakobsen
  WetDep(CWDEP_SO4)   = WScav(   1.0,  EFF25) ! Berge+Jakobsen
  WetDep(CWDEP_NH3)   = WScav(   1.4,  0.5 )  ! subcloud = 1/3 of cloud for gases
  WetDep(CWDEP_HNO3)  = WScav(   1.4,  0.5)   !
  WetDep(CWDEP_H2O2)  = WScav(   1.4,  0.5)   !
  WetDep(CWDEP_HCHO)  = WScav(   0.1,  0.03)  !
  WetDep(CWDEP_ECfn)  = WScav(   0.05, EFF25)
  WetDep(CWDEP_SSf)   = WScav(   1.6,  EFF25)
  WetDep(CWDEP_SSc)   = WScav(   1.6,  EFFCO)
  WetDep(CWDEP_SSg)   = WScav(   1.6,  EFFGI)
  WetDep(CWDEP_PMf)   = WScav(   1.0,  EFF25) !!
  WetDep(CWDEP_PMc)   = WScav(   1.0,  EFFCO) !!
  WetDep(CWDEP_POLLw) = WScav(   1.0,  SUBCLFAC) ! pollen
!RB extras:
!perhaps too high for MeOOH? About an order of magnitude lower H* than HCHO:
  WetDep(CWDEP_ROOH)  = WScav(   0.05, 0.015) ! assumed half of HCHO - 
  WetDep(CWDEP_0p2)  = WScav(   0.2, 0.06) !
  WetDep(CWDEP_0p3)  = WScav(   0.3, 0.09) !
  WetDep(CWDEP_0p4)  = WScav(   0.4, 0.12) !
  WetDep(CWDEP_0p5)  = WScav(   0.5, 0.15) !
  WetDep(CWDEP_0p6)  = WScav(   0.6, 0.18) !
  WetDep(CWDEP_0p7)  = WScav(   0.7, 0.21) !
  WetDep(CWDEP_0p8)  = WScav(   0.8, 0.24) ! 
  WetDep(CWDEP_1p3)  = WScav(   1.3, 0.39) !

! Other PM compounds treated with SO4-LIKE array defined above

!####################### gather indices from My_Derived
! WDEP_WANTED array, and determine needed indices in d_2d

  nwspec=count(WDEP_WANTED(1:nWDEP)%txt2=="SPEC")
  nwgrp =count(WDEP_WANTED(1:nWDEP)%txt2=="GROUP")
  allocate(wetSpec(nwspec),wetGroup(nwgrp),wetGroupUnits(nwgrp),stat=alloc_err)
  call CheckStop(alloc_err, "alloc error wetSpec/wetGroup")

  nwspec=0;nwgrp=0
  do n = 1, nWDEP ! size(WDEP_WANTED(:)%txt1)
    dname = "WDEP_"//trim(WDEP_WANTED(n)%txt1)
    f2d = find_index(dname,f_2d(:)%name)
    call CheckStop(f2d<1, "AQUEOUS f_2d PROBLEM: "//trim(dname))

    iadv=0;igrp=0
    select case(WDEP_WANTED(n)%txt2)
    case("PREC")
      WDEP_PREC=f2d
      if(WDEP_PREC>0) then
        iadv=-999;igrp=-999 ! just for printout
      elseif(DEBUG%AQUEOUS.and.MasterProc)then
        call CheckStop(WDEP_PREC,find_index(dname,f_2d(:)%name),&
          "Inconsistent WDEP_WANTED/f_2d definition for "//trim(dname))
      end if
    case("SPEC")
      iadv=f_2d(f2d)%index
      if(iadv>0) then
        nwspec = nwspec + 1
        wetSpec(nwspec) = f2d
      elseif(DEBUG%AQUEOUS.and.MasterProc)then
        call CheckStop(iadv,find_index(dname,species_adv(:)%name),&
          "Inconsistent WDEP_WANTED/f_2d definition for "//trim(dname))
      end if
    case("GROUP")
      igrp=f_2d(f2d)%index
      if(igrp>0) then
        nwgrp = nwgrp + 1
        wetGroup(nwgrp) = f2d
        wetGroupUnits(nwgrp) = Group_Scale(igrp,f_2d(f2d)%unit,&
          debug=DEBUG%AQUEOUS.and.MasterProc)
      elseif(DEBUG%AQUEOUS.and.MasterProc)then
        call CheckStop(igrp,find_index(dname,chemgroups(:)%name),&
          "Inconsistent WDEP_WANTED/f_2d definition for "//trim(dname))
      end if
    end select

    if(DEBUG%AQUEOUS.and.MasterProc)  then
      write(*,"(2a,3i5)") "WETPPP ", trim(f_2d(f2d)%name), f2d, iadv, igrp
      if(igrp>0) write(*,*) "WETFGROUP ", nwgrp, wetGroupUnits(nwgrp)%iadv
      if(iadv>0) write(*,*) "WETFSPEC  ", nwspec, iadv
    end if
  end do

!####################### END indices here ##########

! Now create table to map calc species to actual advected ones:
  Calc2adv = 0
  do n = 1, NWETDEP_ADV
    icalc = WDepMap(n)%calc
    iadv  = WDepMap(n)%ind
    nc    = Calc2adv(icalc,0) + 1
    if(MasterProc.and.DEBUG%AQUEOUS) write(*,"(a,4i5)") &
      "CHECKING WetDep Calc2adv ", n,icalc,iadv,nc
    Calc2adv(icalc,0 ) = nc
    Calc2adv(icalc,nc) = iadv
  end do

  if(MasterProc.and.DEBUG%AQUEOUS) then
    write(*,*) "FINAL WetDep Calc2adv "
    write(*,"(i3,i4,15(1x,a))") (icalc, Calc2adv(icalc,0), &
      (trim(species_adv(Calc2adv(icalc,nc))%name),nc=1,Calc2adv(icalc,0)),&
        icalc=1,NWETDEP_CALC)
  end if
end subroutine Init_WetDep
!-----------------------------------------------------------------------
subroutine Setup_Clouds(i,j,debug_flag)
!-----------------------------------------------------------------------
! DESCRIPTION
! Define incloud and precipitating clouds.
! The layer must contain at least 1.e-7 kgwater/kg air to
! be considered a cloud.
!
! Also calculates
!  pr_acc - the accumulated precipitation for each k
!  b      - fractional cloud cover for each k
!-----------------------------------------------------------------------
  integer, intent(in) ::  i,j
  logical, intent(in) :: debug_flag

  real, dimension(KUPPER:KMAX_MID) :: &
    b,           &  ! Cloud-area (fraction)
    cloudwater,  &  ! Cloud-water (volume mixing ratio)
                    ! cloudwater = 1.e-6 same as 1.g m^-3
    pres            ! Pressure (Pa)
  integer :: k

! Add up the precipitation in the column:
!old defintion:
!  pr_acc(KUPPER) = sum ( pr(i,j,1:KUPPER) ) ! prec. from above
!  do k= KUPPER+1, KMAX_MID
!    pr_acc(k) = pr_acc(k-1) + pr(i,j,k)
!    pr_acc(k) = max( pr_acc(k), 0.0 )
!  end do

!now pr is already defined correctly (>=0)
  do k= KUPPER, KMAX_MID
    pr_acc(k) = pr(i,j,k)
  end do

  prclouds_present=(pr_acc(KMAX_MID)>PR_LIMIT) ! --> precipitation at the surface

! initialise with .false. and 0:
  incloud(:)  = .false.
  cloudwater(:) = 0.
  pres(:)=0.0

! Loop starting at surface finding the cloud base:
  ksubcloud = KMAX_MID+1       ! k-coordinate of sub-cloud limit
  do k = KMAX_MID, KUPPER, -1
    if(lwc(i,j,k)>CW_LIMIT) exit
    ksubcloud = k
  end do
  if(ksubcloud == 0) return ! No cloud water found below level 6
                            ! Cloud above level 6 are likely thin
                            ! cirrus clouds, and if included may
                            ! need special treatment...
                            ! ==> assume no cloud

! Define incloud part of the column requiring that both cloud water
! and cloud fractions are above limit values
  kcloudtop = -1               ! k-level of cloud top
  do k = KUPPER, ksubcloud-1
    b(k) = cc3d(i,j,k)
! Units: kg(w)/kg(air) * kg(air(m^3) / density of water 10^3 kg/m^3
! ==> cloudwater (volume mixing ratio of water to air in cloud
! (when devided by cloud fraction b )
! cloudwater(k) = 1.0e-3 * cw(i,j,k,1) * roa(i,j,k,1) / b(k)
    if(lwc(i,j,k)>CW_LIMIT) then
      cloudwater(k) = lwc(i,j,k) / b(k) ! value of cloudwater in the
                                        ! cloud fraction of the grid

!hf : alternative if cloudwater exists (and can be used) from met model
!        cloudwater(k) = 1.0e-3 * cw(i,j,k,1) * roa(i,j,k,1) / b(k)
!        cloudwater min 0.03 g/m3 (0.03e-6 mix ratio)
!        cloudwater(k) = max(0.3e-7, (1.0e-3 * cw(i,j,k,1) * roa(i,j,k,1) ))
!        cloudwater(k) =         cloudwater(k)/ b(k)
      incloud(k) = .true.
!hf
      pres(k)=ps(i,j,1)
      if(kcloudtop<0) kcloudtop = k
    end if
  end do

  if(kcloudtop == -1) then
    if(prclouds_present.and.DEBUG%AQUEOUS) &
      write(*,"(a20,2i5,3es12.4)") "ERROR prclouds sum_cw", &
        i,j, maxval(lwc(i,j,KUPPER:KMAX_MID),1), maxval(pr(i,j,:)), pr_acc(KMAX_MID)
    kcloudtop = KUPPER ! for safety
  end if

! sets up the aqueous phase reaction rates (SO2 oxidation) and the
! fractional solubility

!hf add pres
  call setup_aqurates(b ,cloudwater,incloud,pres)

  if(DEBUG%pH .and. debug_flag .and. incloud(kcloudtop)) then
!   write(*,"(a,l1,2i4,es14.4)") "DEBUG_AQ ",prclouds_present, &
!            kcloudtop, ksubcloud, pr_acc(KMAX_MID)

    write(*,*) "DEBUG%pH ",prclouds_present, &
              kcloudtop, ksubcloud, (pH(k),k=kcloudtop,ksubcloud-1)
    write(*,*) "CONC (mol/l)",&
      so4_aq(ksubcloud-1),no3_aq(ksubcloud-1),nh4_aq(ksubcloud-1),&
      nh3_aq(ksubcloud-1),hco3_aq(ksubcloud-1),co2_aq(ksubcloud-1)
    write(*,*)"H+(ph_factor) ",&
      hco3_aq(ksubcloud-1)+2.*so4_aq(ksubcloud-1)+hso3_aq(ksubcloud-1)&
     +2.*so32_aq(ksubcloud-1)+no3_aq(ksubcloud-1)-nh4_aq(ksubcloud-1)-nh3_aq(ksubcloud-1)
    write(*,*) "CLW(l_vann/l_luft) ",cloudwater(ksubcloud-1)
    write(*,*) "xn_2d(SO4) ugS/m3 ",(xn_2d(SO4,k)*10.e12*32./AVOG,k=kcloudtop,KMAX_MID)
  end if

end subroutine Setup_Clouds
!-----------------------------------------------------------------------
subroutine init_aqueous()
!-----------------------------------------------------------------------
! DESCRIPTION
! Calls initial tabulations, sets frac_aq to zero above cloud level, and
! sets constant rates.
! MTRLIM represents mass transport limitations between the clouds
! and the remainder of the grid-box volume. (so2 will be rapidly
! depleted within the clouds, and must be replenished from the
! surrounding cloudfree volume.
!-----------------------------------------------------------------------
!hf  real, parameter :: &
!hf     Hplus = 5.0e-5                    ! H+ (Hydrogen ion concentration)
!     h_plus = 5.0e-5                    ! H+ (Hydrogen ion concentration)
  real, parameter :: MASSTRLIM = 1.0   ! Mass transport limitation
!hf  INV_Hplus    = 1.0/Hplus             ! 1/H+
!hf  INV_Hplus0p4 = INV_Hplus**0.4        ! (1/H+)**0.4

! tabulations
!========================
  call tabulate_aqueous()
!========================

! Constant rates: The rates given in Berge (1993) are in mol-1 l.
! These need to be multiplied by 1.0e3/AVOG/Vf,so we perform the
! 1.0e3/AVOG scaling here.

! so2aq + h2o2   ---> so4, ref: Möller 1980
  aqrc(1) = 8.3e5 * 1.0e3/AVOG * MASSTRLIM

! (so2aq + hso3-) + H+ + o3 ---> so4, ref: Martin & Damschen 1981
  aqrc(2) = 1.8e4 * 1.0e3/AVOG * MASSTRLIM

! (so2aq + hso3-) + o2 ( + Fe ) --> so4, see documentation below
  aqrc(3) = 3.3e-10  * MASSTRLIM

! Regarding aqrc(3):
! catalytic oxidation with Fe. The assumption is that 2% of SIV
! is oxidised per hour inside the droplets, corresponding to a
! conversion rate of 5.6^-6 (units s^-1  -- Therfore no conversion
! from mol l^-1)

! 5.6e-6 * 0.5e-6 (liquid water fraction) /8.5e-3 (fso2 at 10deg C)

! multiply with the assumed liquid water fraction from Seland and
! Iversen (0.5e-6) and with an assumed fso2 since the reaction is
! scaled by the calculated value for these parameters later.
end subroutine init_aqueous
!-----------------------------------------------------------------------
subroutine tabulate_aqueous()
!-----------------------------------------------------------------------
! DESCRIPTION
! Tabulates Henry's law coefficients over the temperature range
! defined in Tabulations_ml.
! For SO2, the effective Henry's law is given by
!   Heff = H * ( 1 + K1/H+ )
! where k2 is omitted as it is significant only at high pH.
! We tabulate also the factor 1+K1/H+ as K1fac.
!-----------------------------------------------------------------------
  real, dimension(CHEMTMIN:CHEMTMAX) :: t, tfac ! Temperature, K, factor
  integer :: i

  t(:)          = (/ ( real(i), i=CHEMTMIN, CHEMTMAX ) /)
  tfac(:)       = 1.0/t(:) -  1.0/298.0

  H(IH_SO2 ,:)  = 1.23    * exp(3020.0*tfac(:))
  H(IH_H2O2,:)  = 7.1e4   * exp(6800.0*tfac(:))
  H(IH_O3  ,:)  = 1.13e-2 * exp(2300.0*tfac(:))
  H(IH_NH3 ,:)  = 60.0    * exp(4400.0*tfac(:)) !http://www.ceset.unicamp.br/~mariaacm/ST405/Lei%20de%20Henry.pdf
  H(IH_CO2,:)   = 3.5e-2  * exp(2400.0*tfac(:)) !http://www.ceset.unicamp.br/~mariaacm/ST405/Lei%20de%20Henry.pdf

  K1(:)   = 1.23e-2 * exp( 2010.0*tfac(:))
  K2(:)   = 6.6e-8  * exp( 1122.0*tfac(:))!Seinfeldt&Pandis 1998
  Knh3(:) = 1.7e-5  * exp(-4353.0*tfac(:))!Seinfeldt&Pandis 1998
  Kw(:)   = 1.0e-14 * exp(-6718.0*tfac(:))!Seinfeldt&Pandis 1998
  Kco2(:) = 4.3e-7  * exp( -921.0*tfac(:))!Seinfeldt&Pandis 1998

end subroutine tabulate_aqueous
!-----------------------------------------------------------------------
subroutine setup_aqurates(b ,cloudwater,incloud,pres)
!-----------------------------------------------------------------------
! DESCRIPTION
! sets the rate-coefficients for thr aqueous-phase reactions
!-----------------------------------------------------------------------
  real, dimension(KUPPER:KMAX_MID) :: &
    b,          &  ! cloud-aread (fraction)
    cloudwater, &  ! cloud-water
    pres           ! Pressure(Pa) !hf

  logical, dimension(KUPPER:KMAX_MID) :: &
    incloud  ! True for in-cloud k values

! Outputs  -> aqurates

! local
  real, dimension(KUPPER:KMAX_MID) :: &
    fso2grid, & ! f_aq * b = {f_aq}
    fso2aq,   & ! only so2.h2o part (not hso3- and so32-)
    caqh2o2,  & ! rate of oxidation of so2 with H2O2
    caqo3,    & ! rate of oxidation of so2 with H2O2
    caqsx      ! rate of oxidation of so2 with o2 ( Fe )

! PH
  real, dimension(KUPPER:KMAX_MID) :: &
    phfactor, &
    h_plus

  real, parameter :: CO2conc_ppm = 392 !mix ratio for CO2 in ppm
  real :: CO2conc !Co2 in mol/l
 !real :: invhplus04, K1_fac,K1K2_fac, Heff,Heff_NH3
  real :: invhplus04, K1K2_fac, Heff,Heff_NH3,pH_old
  integer, parameter :: pH_ITER = 2 ! num iter to calc pH. 
                                    !Do not change without knowing what you are doing
  real, dimension (KUPPER:KMAX_MID) :: VfRT ! Vf * Rgas * Temp
  real, parameter :: Hplus43=5.011872336272724E-005! 10.0**-4.3
  real, parameter :: Hplus55=3.162277660168379e-06! 10.0**-5.5
  real ::pHin(0:pH_ITER),pHout(0:pH_ITER)!start at zero to avoid debugger warnings for iter-1
  integer k, iter

  call get_frac(cloudwater,incloud) ! => frac_aq

! initialize:
  aqrck(:,:)=0.

! for PH

  pH(:)=4.3!dspw 13082012
  h_plus(:)=Hplus43!dspw 13082012
  pH(:)=5.5!stpw 23082012
  h_plus(:)=Hplus55!stpw 23082012

  ph_old=0.0
! Gas phase ox. of SO2 is "default"
! in cloudy air, only the part remaining in gas phase (not
! dissolved) is oxidized
  aqrck(ICLOHSO2,:) = 1.0

  do k = KUPPER,KMAX_MID
    if(.not.incloud(k)) cycle ! Vf > 1.0e-10) ! lwc > CW_limit
!For pH calculations:
!Assume total uptake of so4,no3,hno3,nh4+
!For pH below 5, all NH3 will be dissolved, at pH=6 around 50%
!Effectively all dissolved NH3 will ionize to NH4+ (Seinfeldt)
    so4_aq(k)= (xn_2d(SO4,k)*1000./AVOG)/cloudwater(k) !xn_2d=molec cm-3
                                                !cloudwater volume mix. ratio
                                                !so4_aq= mol/l
    no3_aq(k)= ( (xn_2d(NO3_F,k)+xn_2d(HNO3,k))*1000./AVOG)/cloudwater(k)
    nh4_aq(k)=  ( xn_2d(NH4_F,k) *1000./AVOG )/cloudwater(k)!only nh4+ now
 !   hso3_aq(k)= 0.0 !initial, before dissolved
 !   so32_aq(k)= 0.0
 !   nh3_aq(k) = 0.0 !nh3 dissolved and ionized to nh4+(aq)
 !   hco3_aq(k) = 0.0 !co2 dissolved and ionized to hco3

    VfRT(k) = cloudwater(k) * RGAS_ATML * temp(k)

    !dissolve CO2 and SO2 (pH independent)
    !CO2conc=392 ppm
    CO2conc=CO2conc_ppm * 1e-9 * pres(k)/(RGAS_J *temp(k)) !mol/l

    frac_aq(IH_CO2,k) = 1.0 / ( 1.0+1.0/( H(IH_CO2,itemp(k))*VfRT(k) ) )
    co2_aq(k)=frac_aq(IH_CO2,k)*CO2CONC /cloudwater(k)

    frac_aq(IH_SO2,k) = 1.0 / ( 1.0+1.0/( H(IH_SO2,itemp(k))*VfRT(k) ) )
    so2_aq(k)= frac_aq(IH_SO2,k)*(xn_2d(SO2,k)*1000./AVOG)/cloudwater(k)

 
    do iter = 1,pH_ITER !iteratively calc pH
      pHin(iter)=pH(k)!save input pH

!     moved pH calculation after X_aq determination 
      !nh4+, hco3, hso3 and so32 dissolve and ionize
      Heff_NH3= H(IH_NH3,itemp(k))*Knh3(itemp(k))*h_plus(k)/Kw(itemp(k))
      frac_aq(IH_NH3,k) = 1.0 / ( 1.0+1.0/( Heff_NH3*VfRT(k) ) )
      nh3_aq(k)= frac_aq(IH_NH3,k)*(xn_2d(NH3,k)*1000./AVOG)/cloudwater(k)

      hco3_aq(k)= co2_aq(k) * Kco2(itemp(k))/h_plus(k)
      hso3_aq(k)= so2_aq(k) * K1(itemp(k))/h_plus(k)
      so32_aq(k)= hso3_aq(k) * K2(itemp(k))/h_plus(k)
 
      pH_old=pH(k)
      phfactor(k)=hco3_aq(k)+2.*so4_aq(k)+hso3_aq(k)+2.*so32_aq(k)+no3_aq(k)-nh4_aq(k)-nh3_aq(k)
      h_plus(k)=0.5*(phfactor(k) + sqrt(phfactor(k)*phfactor(k)+4.*1.e-14) )
      h_plus(k)=min(1.e-1,max(h_plus(k),1.e-7))! between 1 and 7
      pH(k)=-log(h_plus(k))/log(10.)

      pHout(iter)=pH(k)!save output pH

      if(iter>1.and.(abs(pHin(iter-1)-pHin(iter)-pHout(iter-1)+pHout(iter))>1.E-10))then
         !linear interpolation for pH . (Solution of f(pH)=pH)
         !assume a linear relation between pHin and pHout.
         !make a straight line between vaues at iter and iter-a, 
         !and find where the line cross the diagonal, i.e. pHin = pHout
         pH(k)=(pHin(iter-1)*pHout(iter)-pHin(iter)*pHout(iter-1))&
              /(pHin(iter-1)-pHin(iter)-pHout(iter-1)+pHout(iter))
         pH(k)=max(1.0,min(pH(k),7.0))! between 1 and 7
         h_plus(k)=exp(-pH(k)*log(10.))
      end if

   end do


!after pH determined, final numbers of frac_aq(IH_SO2)
!= effective fraction of S(IV):
!include now also ionization to SO32-
!        K1_fac  =  &
!             1.0 + K1(k)/h_plus(k) !not used
!        H (IH_SO2 ,itemp(k))  = H(IH_SO2,itemp(k)) * K1_fac
    invhplus04= (1.0/h_plus(k))**0.4
    K1K2_fac=&
          1.0 + K1(itemp(k))/h_plus(k) + K1(itemp(k))*K2(itemp(k))/(h_plus(k)**2)
    Heff  = H(IH_SO2,itemp(k)) * K1K2_fac
    frac_aq(IH_SO2,k) = 1.0 / ( 1.0+1.0/( Heff*VfRT(k) ) )
    fso2grid(k) = b(k) * frac_aq(IH_SO2,k)!frac of S(IV) in grid in aqueous phase
!   fso2aq  (k) = fso2grid(k) / K1_fac
    fso2aq  (k) = fso2grid(k) / K1K2_fac  !frac of SO2 in total grid in aqueous phase
    caqh2o2 (k) = aqrc(1) * frac_aq(IH_H2O2,k) / cloudwater(k)
    caqo3   (k) = aqrc(2) * frac_aq(IH_O3,k) / cloudwater(k)
    caqsx   (k) = aqrc(3) / cloudwater(k)
    ! oh + so2 gas-phase
    aqrck(ICLOHSO2,k) = ( 1.0-fso2grid(k) ) ! now correction factor!
    aqrck(ICLRC1,k)   = caqh2o2(k) * fso2aq(k) !only SO2
    !        aqrck(ICLRC2,k)   = caqo3(k) * INV_Hplus0p4 * fso2grid(k)
    aqrck(ICLRC2,k)   = caqo3(k) * invhplus04 * fso2grid(k)
    aqrck(ICLRC3,k)   = caqsx(k) *  fso2grid(k)
  end do
end subroutine setup_aqurates
!-----------------------------------------------------------------------
subroutine get_frac(cloudwater,incloud)
!-----------------------------------------------------------------------
! DESCRIPTION
! Calculating pH dependant solubility fractions: Calculates the fraction
! of each soluble gas in the aqueous phase, frac_aq
!-----------------------------------------------------------------------
! intent in from used modules  : cloudwater and logical incloud
! intent out to rest of module : frac_aq

! local
  real, dimension (KUPPER:KMAX_MID), intent(in) :: &
      cloudwater    ! Volume fraction - see notes above.
  logical, dimension(KUPPER:KMAX_MID), intent(in) :: &
      incloud       ! True for in-cloud k values
  real    :: VfRT   ! Vf * Rgas * Temp
  integer :: ih, k  ! index over species with Henry's law, vertical level k

! Make sure frac_aq is zero outside clouds:
  frac_aq(:,:) = 0.0

  do k = KUPPER, KMAX_MID
    if(.not.incloud(k)) cycle

    VfRT = cloudwater(k) * RGAS_ATML * temp(k)
! Get aqueous fractions:
    do ih = 1, NHENRY
      frac_aq(ih,k) = 1.0 / ( 1.0+1.0/( H(ih,itemp(k))*VfRT ) )
    end do
  end do
end subroutine get_frac
!-----------------------------------------------------------------------
subroutine WetDeposition(i,j,debug_flag)
!-----------------------------------------------------------------------
! DESCRIPTION
! Calculates wet deposition and changes in xn concentrations
! WetDeposition called from RunChem if precipitation reach the surface
!-----------------------------------------------------------------------
! input
  integer, intent(in) ::  i,j
  logical, intent(in) :: debug_flag

! local
  integer :: itot,iadv,is !  index in xn_2d arrays
  integer :: k, icalc

  real    :: invgridarea ! xm2/(h*h)
  real    :: f_rho       ! Factors in rho calculation
  real    :: rho(KUPPER:KMAX_MID)
  real    :: loss    ! conc. loss due to scavenging
  real, dimension(KUPPER:KMAX_MID) :: vw ! Svavenging rates (tmp. array)
  real, dimension(KUPPER:KMAX_MID) :: lossfac ! EGU
  real, dimension(KUPPER:KMAX_MID) :: lossfacPMf ! for particle fraction of semi-volatile (VBS) species

  invgridarea = xm2(i,j)/( gridwidth_m*gridwidth_m )
  f_rho  = 1.0/(invgridarea*GRAV*ATWAIR)
! Loop starting from above:
  do k=kcloudtop, KMAX_MID           ! No need to go above cloudtop
    rho(k) = f_rho*(dA(k) + dB(k)*ps(i,j,1))/ amk(k)
  end do

  wdeploss(:) = 0.0

! calculate concentration after wet deposition and sum up the vertical
! column of the depositions for the fully soluble species.

  if(DEBUG%AQUEOUS.and.debug_flag) write(*,*) "(a15,2i4,es14.4)", &
     "DEBUG_WDEP2", kcloudtop, ksubcloud, pr_acc(KMAX_MID)

! need particle fraction wet deposition for semi-volatile species - here hard coded to use scavenging parameters for PMf
  vw(kcloudtop:ksubcloud-1) = WetDep(CWDEP_PMf)%W_sca ! Scav. for incloud
  vw(ksubcloud:KMAX_MID  )  = WetDep(CWDEP_PMf)%W_sub ! Scav. for subcloud
  do k = kcloudtop, KMAX_MID
    lossfacPMf(k)  = exp( -vw(k)*pr_acc(k)*dt )
  enddo 

  do icalc = 1, NWETDEP_CALC  ! Here we loop over "model" species

! Put both in- and sub-cloud scavenging ratios in the array vw:

    vw(kcloudtop:ksubcloud-1) = WetDep(icalc)%W_sca ! Scav. for incloud
    vw(ksubcloud:KMAX_MID  )  = WetDep(icalc)%W_sub ! Scav. for subcloud

    do k = kcloudtop, KMAX_MID
      lossfac(k)  = exp( -vw(k)*pr_acc(k)*dt )

      ! For each "calc" species we have often a number of model
      ! species
      do is = 1, Calc2adv(icalc,0)  ! number of species
        iadv = Calc2adv(icalc,is)
        itot = iadv+NSPEC_SHL

    ! For semivolatile species only the particle fraction is deposited
!RB: This assumption needs to be revised. The semi-volatile organics are likely highly soluble and should wet deposit also in the gas phase
        if(itot>=FIRST_SEMIVOL .and. itot<=LAST_SEMIVOL) then
!          loss = xn_2d(itot,k) * Fpart(itot,k)*( 1.0 - lossfac(k)  )
          loss = xn_2d(itot,k) * ( Fpart(itot,k)*( 1.0 - lossfacPMf(k) ) + (1.0-Fpart(itot,k))*( 1.0 - lossfac(k) ) )
        else
          loss = xn_2d(itot,k) * ( 1.0 - lossfac(k)  )
        endif
        xn_2d(itot,k) = xn_2d(itot,k) - loss
        wdeploss(iadv) = wdeploss(iadv) + loss * rho(k)
      enddo ! is
    enddo ! k loop

    if(DEBUG%AQUEOUS.and.debug_flag.and.pr_acc(KMAX_MID)>1.0e-5) then
      do k = kcloudtop, KMAX_MID
        write(*,"(a,2i4,a,9es12.2)") "DEBUG_WDEP, k, icalc, spec", k, &
          icalc, trim(species_adv(iadv)%name), vw(k), pr_acc(k), lossfac(k)
      end do ! k loop
    end if ! DEBUG%AQUEOUS

  end do ! icalc loop

  if(WDEP_PREC>0)d_2d(WDEP_PREC,i,j,IOU_INST) = pr(i,j,KMAX_MID) * dt ! Same for all models

! add other losses into twetdep and wdep arrays:
  call WetDep_Budget(i,j,invgridarea,debug_flag)
 end subroutine WetDeposition
!-----------------------------------------------------------------------
subroutine WetDep_Budget(i,j,invgridarea, debug_flag)
  integer, intent(in) ::  i,j
  real,    intent(in) :: invgridarea
  logical, intent(in) :: debug_flag

  integer :: f2d, igrp ,iadv, n, g
  real    :: wdep
  type(group_umap), pointer :: gmap=>null()  ! group unit mapping

  ! Mass Budget: Do not include values on outer frame
  if(.not.(i<li0.or.i>li1.or.j<lj0.or.j>lj1)) &
    totwdep(:) = totwdep(:) + wdeploss(:)

  ! Deriv.Output: individual species (SO4, HNO3, etc.) as needed
  do n = 1, nwspec
    f2d  = wetSpec(n)
    iadv = f_2d(f2d)%index
    d_2d(f2d,i,j,IOU_INST) = wdeploss(iadv) * invgridarea

    if(DEBUG%MY_WETDEP.and.debug_flag) &
      call datewrite("WET-PPPSPEC: "//species_adv(iadv)%name,&
        iadv,(/wdeploss(iadv)/))
  end do

  ! Deriv.Output: groups of species (SOX, OXN, etc.) as needed
  do n = 1, nwgrp
    f2d  =  wetGroup(n)
    gmap => wetGroupUnits(n)
    igrp = f_2d(f2d)%index

    wdep = dot_product(wdeploss(gmap%iadv),gmap%uconv(:))
    d_2d(f2d,i,j,IOU_INST) = wdep * invgridarea

    if(DEBUG%MY_WETDEP.and.debug_flag)then
      do g=1,size(gmap%iadv)
        iadv=gmap%iadv(g)
        call datewrite("WET-PPPGROUP: "//species_adv(iadv)%name ,&
          iadv,(/wdeploss(iadv)/))
      end do
    end if
  end do
end subroutine WetDep_Budget
!-----------------------------------------------------------------------
end module Aqueous_ml
