! <CM_ChemRates_mod.f90 - A component of the EMEP MSC-W Chemical transport Model, version rv4.45>
!*****************************************************************************!
!*
!*  Copyright (C) 2007-2022 met.no
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
! Generated by GenChem.py - DO NOT EDIT
! scheme(s)  EmChem19a PM_VBS_EmChem19 Aqueous_EmChem16x Aero2017nx ShipNOx PM_FFireInert SeaSalt DustExtended Ash PM_ResNonResInert BVOC_SQT_NV BVOC_IsoMT1_emis Pollen
module ChemRates_mod

  use AeroConstants_mod  ! => AERO%PM etc, ...
  use AeroFunctions_mod  ! => UptakeRates, ...
  use ChemDims_mod       ! => NSPEC_TOT, NCHEMRATES, ....
  use ChemFunctions_mod  ! => IUPAC_troe, RiemerN2O5, ....
  use ChemSpecs_mod      ! => PINALD, .... for FgasJ08
  use DefPhotolysis_mod  ! => IDNO2 etc.
  use ZchemData_mod      ! => rct
  
  implicit none
  private
  character(len=*),parameter, public :: CM_schemes_ChemRates = " EmChem19a PM_VBS_EmChem19 Aqueous_EmChem16x Aero2017nx ShipNOx PM_FFireInert SeaSalt DustExtended Ash PM_ResNonResInert BVOC_SQT_NV BVOC_IsoMT1_emis Pollen"
  
  
  public :: setChemRates
  public :: setPhotolUsed
  
  ! Photolysis rates
  integer, save, public, dimension(NPHOTOLRATES) :: photol_used

contains
  
  subroutine setPhotolUsed()
    photol_used = (/ &
        IDO3_O1D  &
      , IDO3_O3P  &
      , IDH2O2  &
      , IDNO2  &
      , IDNO3  &
      , IDHONO  &
      , IDHNO3  &
      , IDHO2NO2  &
      , IDHCHO_H  &
      , IDHCHO_H2  &
      , IDCH3CHO  &
      , IDMEK  &
      , IDCHOCHO  &
      , IDRCOCHO  &
      , IDCH3COY  &
      , IDCH3O2H  &
    /)  
  end subroutine setPhotolUsed
  
  subroutine setChemRates()
    !integer, intent(in) :: debug_level
  
    rct(1,:) = ((5.681e-34*EXP(-2.6*(LOG(TEMP/300))))*O2)*M
    rct(2,:) = (2.15e-11*EXP(110.0*TINV))*N2
    rct(3,:) = (3.2e-11*EXP(67.0*TINV))*O2
    rct(4,:) = (2.14e-10)*H2O
    rct(5,:) = 4.8e-11*EXP(250.0*TINV)
    rct(6,:) = 2.9e-12*EXP(-160.0*TINV)
    rct(7,:) = 7.7e-12*EXP(-2100.0*TINV)
    rct(8,:) = ((1.0+1.4e-21*H2O*EXP(2200.0*TINV)))*2.2e-13*EXP(600.0*TINV)
    rct(9,:) = (((1.0+1.4e-21*H2O*EXP(2200.0*TINV)))  &
             & *1.9e-33*EXP(980.0*TINV))*M
    rct(10,:) = (IUPAC_TROE(1.0e-31*EXP(1.6*(LOG(300*TINV))),  &
              & 5.0e-11*EXP(0.3*(LOG(300*TINV))),  &
              & 0.85,  &
              & M,  &
              & 0.75-1.27*LOG10(0.85)))
    rct(11,:) = 1.4e-12*EXP(-1310.0*TINV)
    rct(12,:) = 1.4e-13*EXP(-2470.0*TINV)
    rct(13,:) = 1.7e-12*EXP(-940.0*TINV)
    rct(14,:) = 2.03e-16*EXP(-4.57*(LOG(300*TINV)))*EXP(693.0*TINV)
    rct(15,:) = 1.8e-11*EXP(110.0*TINV)
    rct(16,:) = 3.45e-12*EXP(270.0*TINV)
    rct(17,:) = 4.5e-14*EXP(-1260.0*TINV)
    rct(18,:) = (IUPAC_TROE(3.6e-30*EXP(4.1*(LOG(300*TINV))),  &
              & 1.9e-12*EXP(-0.2*(LOG(300*TINV))),  &
              & 0.35,  &
              & M,  &
              & 0.75-1.27*LOG10(0.35)))
    rct(19,:) = (IUPAC_TROE(1.3e-3*EXP(3.5*(LOG(300*TINV)))*EXP(-11000.0*TINV),  &
              & 9.70e14*EXP(-0.1*(LOG(300*TINV)))*EXP(-11080.0*TINV),  &
              & 0.35,  &
              & M,  &
              & 0.75-1.27*LOG10(0.35)))
    rct(20,:) = (IUPAC_TROE(3.2e-30*EXP(4.5*(LOG(300*TINV))),  &
              & 3.0e-11,  &
              & 0.41,  &
              & M,  &
              & 0.75-1.27*LOG10(0.41)))
    rct(21,:) = (KMT3(2.4e-14,  &
              & 460.0,  &
              & 6.5e-34,  &
              & 1335.0,  &
              & 2.7e-17,  &
              & 2199.0))
    rct(22,:) = (IUPAC_TROE(7.4e-31*EXP(2.4*(LOG(300*TINV))),  &
              & 3.3e-11*EXP(0.3*(LOG(300*TINV))),  &
              & 0.81,  &
              & M,  &
              & 0.75-1.27*LOG10(0.81)))
    rct(23,:) = 2.5e-12*EXP(260.0*TINV)
    rct(24,:) = (IUPAC_TROE(1.4e-31*EXP(3.1*(LOG(300*TINV))),  &
              & 4.0e-12,  &
              & 0.4,  &
              & M,  &
              & 0.75-1.27*LOG10(0.4)))
    rct(25,:) = (IUPAC_TROE(4.10e-05*EXP(-10650.0*TINV),  &
              & 6.0e+15*EXP(-11170.0*TINV),  &
              & 0.4,  &
              & M,  &
              & 0.75-1.27*LOG10(0.4)))
    rct(26,:) = 3.2e-13*EXP(690.0*TINV)
    rct(27,:) = 1.85e-12*EXP(-1690.0*TINV)
    rct(28,:) = (1.44e-13*(1+(M/4.2e+19)))
    rct(29,:) = 2.3e-12*EXP(360.0*TINV)
    rct(30,:) = 1.48e-12*EXP(-520.0*TINV)
    rct(31,:) = 2.06e-13*EXP(365.0*TINV)-1.48e-12*EXP(-520.0*TINV)
    rct(32,:) = 3.8e-13*EXP(780.0*TINV)
    rct(33,:) = 2.85e-12*EXP(-345.0*TINV)
    rct(34,:) = 5.3e-12*EXP(190.0*TINV)
    rct(35,:) = 5.4e-12*EXP(135.0*TINV)
    rct(36,:) = 2.0e-12*EXP(-2440.0*TINV)
    rct(37,:) = 6.9e-12*EXP(-1000.0*TINV)
    rct(38,:) = 2.55e-12*EXP(380.0*TINV)
    rct(39,:) = 6.4e-13*EXP(710.0*TINV)
    rct(40,:) = 4.7e-12*EXP(345.0*TINV)
    rct(41,:) = (1.4e-12*EXP(-1860.0*TINV))
    rct(42,:) = (7.5e-12*EXP(290.0*TINV))
    rct(43,:) = (IUPAC_TROE(3.28e-28*EXP(6.87*(LOG(300*TINV))),  &
              & 1.125e-11*EXP(1.105*(LOG(300*TINV))),  &
              & 0.3,  &
              & M,  &
              & 0.75-1.27*LOG10(0.3)))
    rct(44,:) = (IUPAC_TROE(1.10e-05*EXP(-10100.0*TINV),  &
              & 1.90e17*EXP(-14100.0*TINV),  &
              & 0.3,  &
              & M,  &
              & 0.75-1.27*LOG10(0.3)))
    rct(45,:) = (3.14e-12*EXP(580.0*TINV))
    rct(46,:) = 9.8e-12*EXP(-425.0*TINV)
    rct(47,:) = (2.91e-13*EXP(1300.0*TINV))*0.625
    rct(48,:) = (2.7e-12*EXP(360.0*TINV))
    rct(49,:) = (IUPAC_TROE(8.6e-29*EXP(3.1*(LOG(300*TINV))),  &
              & 9.0e-12*EXP(0.85*(LOG(300*TINV))),  &
              & 0.48,  &
              & M,  &
              & 0.75-1.27*LOG10(0.48)))
    rct(50,:) = 1.53e-13*EXP(1300.0*TINV)
    rct(51,:) = 6.82e-15*EXP(-2500.0*TINV)
    rct(52,:) = (IUPAC_TROE(8.0e-27*EXP(3.5*(LOG(300*TINV))),  &
              & 9.0e-9*TINV,  &
              & 0.5,  &
              & M,  &
              & 0.75-1.27*LOG10(0.5)))
    rct(53,:) = 5.77e-15*EXP(-1880.0*TINV)
    rct(54,:) = (2.91e-13*EXP(1300.0*TINV))*0.52
    rct(55,:) = 4.6e-13*EXP(-1155.0*TINV)
    rct(56,:) = 2.3e-12*EXP(-190.0*TINV)
    rct(57,:) = 1.8e-12*EXP(340.0*TINV)
    rct(58,:) = (2.91e-13*EXP(1300.0*TINV))*0.859
    rct(59,:) = (2.3e-12)
    rct(60,:) = (2.91e-13*EXP(1300.0*TINV))*0.706
    rct(61,:) = 1.9e-12*EXP(190.0*TINV)
    rct(62,:) = 3.1e-12*EXP(340.0*TINV)
    rct(63,:) = 1.9e-12*EXP(575.0*TINV)
    rct(64,:) = 2.7e-11*EXP(390.0*TINV)
    rct(65,:) = 1.05e-14*EXP(-2000.0*TINV)
    rct(66,:) = 2.95e-12*EXP(-450.0*TINV)
    rct(67,:) = 1.3e-12*EXP(610.0*TINV)
    rct(68,:) = 4.0e-12*EXP(380.0*TINV)
    rct(69,:) = 4.26e-16*EXP(-1520.0*TINV)
    rct(70,:) = 7.0e-16*EXP(-2100.0*TINV)
    rct(71,:) = 1.6e-12*EXP(305.0*TINV)
    rct(72,:) = (IUPAC_TROE(3.28e-28*EXP(6.87*(LOG(300*TINV))),  &
              & 1.125e-11*EXP(1.105*(LOG(300*TINV))),  &
              & 0.3,  &
              & M,  &
              & 0.75-1.27*LOG10(0.3)))*0.107
    rct(73,:) = 1.88e09*EXP(-7261.0*TINV)*0.052
    rct(74,:) = 1.45e12*EXP(-10688.0*TINV)
    rct(75,:) = 1.34e-11*EXP(410.0*TINV)
    rct(76,:) = 7.5e-13*EXP(700.0*TINV)
    rct(77,:) = 3.8e-12*EXP(200.0*TINV)
    rct(78,:) = 8.22e-16*EXP(-640.0*TINV)
    rct(79,:) = 1.2e-12*EXP(490.0*TINV)
    rct(80,:) = 4.0e-12*FGAS(ASOC_UG1,  &
              & :)
    rct(81,:) = 4.0e-12*FGAS(ASOC_UG10,  &
              & :)
    rct(82,:) = 4.0e-12*FGAS(ASOC_UG1e2,  &
              & :)
    rct(83,:) = 4.0e-12*FGAS(ASOC_UG1e3,  &
              & :)
    rct(84,:) = 4.0e-12*FGAS(NON_C_ASOA_UG1,  &
              & :)
    rct(85,:) = 4.0e-12*FGAS(NON_C_ASOA_UG10,  &
              & :)
    rct(86,:) = 4.0e-12*FGAS(NON_C_ASOA_UG1e2,  &
              & :)
    rct(87,:) = 4.0e-12*FGAS(NON_C_ASOA_UG1e3,  &
              & :)
    rct(88,:) = 4.0e-12*FGAS(BSOC_UG1,  &
              & :)
    rct(89,:) = 4.0e-12*FGAS(BSOC_UG10,  &
              & :)
    rct(90,:) = 4.0e-12*FGAS(BSOC_UG1e2,  &
              & :)
    rct(91,:) = 4.0e-12*FGAS(BSOC_UG1e3,  &
              & :)
    rct(92,:) = 4.0e-12*FGAS(NON_C_BSOA_UG1,  &
              & :)
    rct(93,:) = 4.0e-12*FGAS(NON_C_BSOA_UG10,  &
              & :)
    rct(94,:) = 4.0e-12*FGAS(NON_C_BSOA_UG1e2,  &
              & :)
    rct(95,:) = 4.0e-12*FGAS(NON_C_BSOA_UG1e3,  &
              & :)
    rct(96,:) = HYDROLYSISN2O5()
    rct(97,:) = UPTAKERATE(CNO3,  &
              & GAM=0.001,  &
              & S=S_M2M3(AERO%PM,  &
              & :))
    rct(98,:) = UPTAKERATE(CHNO3,  &
              & GAM=0.1,  &
              & S=S_M2M3(AERO%DU_C,  &
              & :))
    rct(99,:) = UPTAKERATE(CHNO3,  &
              & GAM=0.01,  &
              & S=S_M2M3(AERO%SS_C,  &
              & :))
    rct(100,:) = UPTAKERATE(CHO2,  &
               & GAM=0.2,  &
               & S=S_M2M3(AERO%PM,  &
               & :))
    rct(101,:) = EC_AGEING_RATE()
  
  end subroutine setChemRates

end module ChemRates_mod
