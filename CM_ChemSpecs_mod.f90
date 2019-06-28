! <CM_ChemSpecs_mod.f90 - A component of the EMEP MSC-W Chemical transport Model, version rv4.33>
!*****************************************************************************!
!*
!*  Copyright (C) 2007-2019 met.no
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
! scheme(s)  EmChem16zi VBS_EmChem16z APINENE_BVOC_emis BVOC_EmChem16z Aqueous_EmChem16x Aero2017nx Ash_EmChem16z ShipNOx16z FFireInert16z SeaSalt16z DustExtended16z
module ChemSpecs_mod

  use ChemDims_mod      ! => NSPEC_TOT, NCHEMRATES, ....
  
  implicit none
  private
  character(len=*),parameter, public :: CM_schemes_ChemSpecs = " EmChem16zi VBS_EmChem16z APINENE_BVOC_emis BVOC_EmChem16z Aqueous_EmChem16x Aero2017nx Ash_EmChem16z ShipNOx16z FFireInert16z SeaSalt16z DustExtended16z"
  
  
  integer, public, parameter :: &
      OD          =   1  &
    , OP          =   2  &
    , OH          =   3  &
    , HO2         =   4  &
    , CH3O2       =   5  &
    , C2H5O2      =   6  &
    , C4H9O2      =   7  &
    , ISRO2       =   8  &
    , ETRO2       =   9  &
    , PRRO2       =  10
  
  integer, public, parameter :: &
      OXYO2       =  11  &
    , MEKO2       =  12  &
    , C5DICARBO2  =  13  &
    , MACRO2      =  14  &
    , CH3CO3      =  15  &
    , TERPO2      =  16  &
    , HMVKO2      =  17  &
    , RO2POOL     =  18  &
    , NMVOC       =  19  &
    , O3          =  20
  
  integer, public, parameter :: &
      NO          =  21  &
    , NO2         =  22  &
    , NO3         =  23  &
    , N2O5        =  24  &
    , H2          =  25  &
    , H2O2        =  26  &
    , HONO        =  27  &
    , HNO3        =  28  &
    , HO2NO2      =  29  &
    , CO          =  30
  
  integer, public, parameter :: &
      CH4         =  31  &
    , C2H6        =  32  &
    , NC4H10      =  33  &
    , C2H4        =  34  &
    , C3H6        =  35  &
    , BENZENE     =  36  &
    , TOLUENE     =  37  &
    , OXYL        =  38  &
    , C5H8        =  39  &
    , CH3OH       =  40
  
  integer, public, parameter :: &
      C2H5OH      =  41  &
    , HCHO        =  42  &
    , CH3CHO      =  43  &
    , MACR        =  44  &
    , MEK         =  45  &
    , ACETOL      =  46  &
    , GLYOX       =  47  &
    , MGLYOX      =  48  &
    , BIACET      =  49  &
    , C5DICARB    =  50
  
  integer, public, parameter :: &
      C5134CO2OH  =  51  &
    , C54CO       =  52  &
    , CH3OOH      =  53  &
    , C2H5OOH     =  54  &
    , BURO2H      =  55  &
    , ETRO2H      =  56  &
    , PRRO2H      =  57  &
    , MEKO2H      =  58  &
    , ISRO2H      =  59  &
    , C5DICAROOH  =  60
  
  integer, public, parameter :: &
      HPALD       =  61  &
    , MACROOH     =  62  &
    , OXYO2H      =  63  &
    , CH3CO3H     =  64  &
    , PACALD      =  65  &
    , IEPOX       =  66  &
    , SC4H9NO3    =  67  &
    , NALD        =  68  &
    , ISON        =  69  &
    , PAN         =  70
  
  integer, public, parameter :: &
      MPAN        =  71  &
    , SO2         =  72  &
    , TERPPeroxy  =  73  &
    , VBS_TEST    =  74  &
    , APINENE     =  75  &
    , SQT_SOA_nv  =  76  &
    , TERPOOH     =  77  &
    , MVK         =  78  &
    , shipNOx     =  79  &
    , Dust_road_f =  80
  
  integer, public, parameter :: &
      Dust_road_c =  81  &
    , Dust_wb_f   =  82  &
    , Dust_wb_c   =  83  &
    , Dust_sah_f  =  84  &
    , Dust_sah_c  =  85  &
    , ASOC_ng1e2  =  86  &
    , ASOC_ug1    =  87  &
    , ASOC_ug10   =  88  &
    , ASOC_ug1e2  =  89  &
    , ASOC_ug1e3  =  90
  
  integer, public, parameter :: &
      non_C_ASOA_ng1e2=  91  &
    , non_C_ASOA_ug1=  92  &
    , non_C_ASOA_ug10=  93  &
    , non_C_ASOA_ug1e2=  94  &
    , non_C_ASOA_ug1e3=  95  &
    , BSOC_ng1e2  =  96  &
    , BSOC_ug1    =  97  &
    , BSOC_ug10   =  98  &
    , BSOC_ug1e2  =  99  &
    , BSOC_ug1e3  = 100
  
  integer, public, parameter :: &
      non_C_BSOA_ng1e2= 101  &
    , non_C_BSOA_ug1= 102  &
    , non_C_BSOA_ug10= 103  &
    , non_C_BSOA_ug1e2= 104  &
    , non_C_BSOA_ug1e3= 105  &
    , ffuel_ng10  = 106  &
    , woodOA_ng10 = 107  &
    , SO4         = 108  &
    , NH3         = 109  &
    , NO3_f       = 110
  
  integer, public, parameter :: &
      NO3_c       = 111  &
    , NH4_f       = 112  &
    , POM_f_wood  = 113  &
    , POM_c_wood  = 114  &
    , POM_f_ffuel = 115  &
    , POM_c_ffuel = 116  &
    , EC_f_wood_new= 117  &
    , EC_f_wood_age= 118  &
    , EC_c_wood   = 119  &
    , EC_f_ffuel_new= 120
  
  integer, public, parameter :: &
      EC_f_ffuel_age= 121  &
    , EC_c_ffuel  = 122  &
    , pSO4f       = 123  &
    , pSO4c       = 124  &
    , remPPM25    = 125  &
    , remPPM_c    = 126  &
    , OM25_bgnd   = 127  &
    , OM25_p      = 128  &
    , Ash_f       = 129  &
    , Ash_c       = 130
  
  integer, public, parameter :: &
      ffire_CO    = 131  &
    , ffire_OM    = 132  &
    , ffire_BC    = 133  &
    , ffire_remPPM25= 134  &
    , SeaSalt_f   = 135  &
    , SeaSalt_c   = 136
  
  !+ Defines indices for ADV : Advected species
  integer, public, parameter :: FIRST_ADV=18, &
                                 LAST_ADV=136
  
  integer, public, parameter :: &
      IXADV_RO2POOL     =   1  &
    , IXADV_NMVOC       =   2  &
    , IXADV_O3          =   3  &
    , IXADV_NO          =   4  &
    , IXADV_NO2         =   5  &
    , IXADV_NO3         =   6  &
    , IXADV_N2O5        =   7  &
    , IXADV_H2          =   8  &
    , IXADV_H2O2        =   9  &
    , IXADV_HONO        =  10
  
  integer, public, parameter :: &
      IXADV_HNO3        =  11  &
    , IXADV_HO2NO2      =  12  &
    , IXADV_CO          =  13  &
    , IXADV_CH4         =  14  &
    , IXADV_C2H6        =  15  &
    , IXADV_NC4H10      =  16  &
    , IXADV_C2H4        =  17  &
    , IXADV_C3H6        =  18  &
    , IXADV_BENZENE     =  19  &
    , IXADV_TOLUENE     =  20
  
  integer, public, parameter :: &
      IXADV_OXYL        =  21  &
    , IXADV_C5H8        =  22  &
    , IXADV_CH3OH       =  23  &
    , IXADV_C2H5OH      =  24  &
    , IXADV_HCHO        =  25  &
    , IXADV_CH3CHO      =  26  &
    , IXADV_MACR        =  27  &
    , IXADV_MEK         =  28  &
    , IXADV_ACETOL      =  29  &
    , IXADV_GLYOX       =  30
  
  integer, public, parameter :: &
      IXADV_MGLYOX      =  31  &
    , IXADV_BIACET      =  32  &
    , IXADV_C5DICARB    =  33  &
    , IXADV_C5134CO2OH  =  34  &
    , IXADV_C54CO       =  35  &
    , IXADV_CH3OOH      =  36  &
    , IXADV_C2H5OOH     =  37  &
    , IXADV_BURO2H      =  38  &
    , IXADV_ETRO2H      =  39  &
    , IXADV_PRRO2H      =  40
  
  integer, public, parameter :: &
      IXADV_MEKO2H      =  41  &
    , IXADV_ISRO2H      =  42  &
    , IXADV_C5DICAROOH  =  43  &
    , IXADV_HPALD       =  44  &
    , IXADV_MACROOH     =  45  &
    , IXADV_OXYO2H      =  46  &
    , IXADV_CH3CO3H     =  47  &
    , IXADV_PACALD      =  48  &
    , IXADV_IEPOX       =  49  &
    , IXADV_SC4H9NO3    =  50
  
  integer, public, parameter :: &
      IXADV_NALD        =  51  &
    , IXADV_ISON        =  52  &
    , IXADV_PAN         =  53  &
    , IXADV_MPAN        =  54  &
    , IXADV_SO2         =  55  &
    , IXADV_TERPPeroxy  =  56  &
    , IXADV_VBS_TEST    =  57  &
    , IXADV_APINENE     =  58  &
    , IXADV_SQT_SOA_nv  =  59  &
    , IXADV_TERPOOH     =  60
  
  integer, public, parameter :: &
      IXADV_MVK         =  61  &
    , IXADV_shipNOx     =  62  &
    , IXADV_Dust_road_f =  63  &
    , IXADV_Dust_road_c =  64  &
    , IXADV_Dust_wb_f   =  65  &
    , IXADV_Dust_wb_c   =  66  &
    , IXADV_Dust_sah_f  =  67  &
    , IXADV_Dust_sah_c  =  68  &
    , IXADV_ASOC_ng1e2  =  69  &
    , IXADV_ASOC_ug1    =  70
  
  integer, public, parameter :: &
      IXADV_ASOC_ug10   =  71  &
    , IXADV_ASOC_ug1e2  =  72  &
    , IXADV_ASOC_ug1e3  =  73  &
    , IXADV_non_C_ASOA_ng1e2=  74  &
    , IXADV_non_C_ASOA_ug1=  75  &
    , IXADV_non_C_ASOA_ug10=  76  &
    , IXADV_non_C_ASOA_ug1e2=  77  &
    , IXADV_non_C_ASOA_ug1e3=  78  &
    , IXADV_BSOC_ng1e2  =  79  &
    , IXADV_BSOC_ug1    =  80
  
  integer, public, parameter :: &
      IXADV_BSOC_ug10   =  81  &
    , IXADV_BSOC_ug1e2  =  82  &
    , IXADV_BSOC_ug1e3  =  83  &
    , IXADV_non_C_BSOA_ng1e2=  84  &
    , IXADV_non_C_BSOA_ug1=  85  &
    , IXADV_non_C_BSOA_ug10=  86  &
    , IXADV_non_C_BSOA_ug1e2=  87  &
    , IXADV_non_C_BSOA_ug1e3=  88  &
    , IXADV_ffuel_ng10  =  89  &
    , IXADV_woodOA_ng10 =  90
  
  integer, public, parameter :: &
      IXADV_SO4         =  91  &
    , IXADV_NH3         =  92  &
    , IXADV_NO3_f       =  93  &
    , IXADV_NO3_c       =  94  &
    , IXADV_NH4_f       =  95  &
    , IXADV_POM_f_wood  =  96  &
    , IXADV_POM_c_wood  =  97  &
    , IXADV_POM_f_ffuel =  98  &
    , IXADV_POM_c_ffuel =  99  &
    , IXADV_EC_f_wood_new= 100
  
  integer, public, parameter :: &
      IXADV_EC_f_wood_age= 101  &
    , IXADV_EC_c_wood   = 102  &
    , IXADV_EC_f_ffuel_new= 103  &
    , IXADV_EC_f_ffuel_age= 104  &
    , IXADV_EC_c_ffuel  = 105  &
    , IXADV_pSO4f       = 106  &
    , IXADV_pSO4c       = 107  &
    , IXADV_remPPM25    = 108  &
    , IXADV_remPPM_c    = 109  &
    , IXADV_OM25_bgnd   = 110
  
  integer, public, parameter :: &
      IXADV_OM25_p      = 111  &
    , IXADV_Ash_f       = 112  &
    , IXADV_Ash_c       = 113  &
    , IXADV_ffire_CO    = 114  &
    , IXADV_ffire_OM    = 115  &
    , IXADV_ffire_BC    = 116  &
    , IXADV_ffire_remPPM25= 117  &
    , IXADV_SeaSalt_f   = 118  &
    , IXADV_SeaSalt_c   = 119
  
  !+ Defines indices for SHL : Short-lived (non-advected) species
  integer, public, parameter :: FIRST_SHL=1, &
                                 LAST_SHL=17
  
  integer, public, parameter :: &
      IXSHL_OD          =   1  &
    , IXSHL_OP          =   2  &
    , IXSHL_OH          =   3  &
    , IXSHL_HO2         =   4  &
    , IXSHL_CH3O2       =   5  &
    , IXSHL_C2H5O2      =   6  &
    , IXSHL_C4H9O2      =   7  &
    , IXSHL_ISRO2       =   8  &
    , IXSHL_ETRO2       =   9  &
    , IXSHL_PRRO2       =  10
  
  integer, public, parameter :: &
      IXSHL_OXYO2       =  11  &
    , IXSHL_MEKO2       =  12  &
    , IXSHL_C5DICARBO2  =  13  &
    , IXSHL_MACRO2      =  14  &
    , IXSHL_CH3CO3      =  15  &
    , IXSHL_TERPO2      =  16  &
    , IXSHL_HMVKO2      =  17
  
  !+ Defines indices for SEMIVOL : Semi-volatile organic aerosols
  integer, public, parameter :: FIRST_SEMIVOL=86, &
                                 LAST_SEMIVOL=107
  
  integer, public, parameter :: &
      IXSOA_ASOC_ng1e2  =   1  &
    , IXSOA_ASOC_ug1    =   2  &
    , IXSOA_ASOC_ug10   =   3  &
    , IXSOA_ASOC_ug1e2  =   4  &
    , IXSOA_ASOC_ug1e3  =   5  &
    , IXSOA_non_C_ASOA_ng1e2=   6  &
    , IXSOA_non_C_ASOA_ug1=   7  &
    , IXSOA_non_C_ASOA_ug10=   8  &
    , IXSOA_non_C_ASOA_ug1e2=   9  &
    , IXSOA_non_C_ASOA_ug1e3=  10
  
  integer, public, parameter :: &
      IXSOA_BSOC_ng1e2  =  11  &
    , IXSOA_BSOC_ug1    =  12  &
    , IXSOA_BSOC_ug10   =  13  &
    , IXSOA_BSOC_ug1e2  =  14  &
    , IXSOA_BSOC_ug1e3  =  15  &
    , IXSOA_non_C_BSOA_ng1e2=  16  &
    , IXSOA_non_C_BSOA_ug1=  17  &
    , IXSOA_non_C_BSOA_ug10=  18  &
    , IXSOA_non_C_BSOA_ug1e2=  19  &
    , IXSOA_non_C_BSOA_ug1e3=  20
  
  integer, public, parameter :: &
      IXSOA_ffuel_ng10  =  21  &
    , IXSOA_woodOA_ng10 =  22
  
  !/--   Characteristics of species:
  !/--   Number, name, molwt, carbon num, nmhc (1) or not(0)
  
  public :: define_chemicals    ! Sets names, molwts, carbon num, advec, nmhc
  
  type, public :: Chemical
       character(len=20) :: name
       real              :: molwt
       integer           :: nmhc      ! nmhc (1) or not(0)
       real              :: carbons   ! Carbon-number
       real              :: nitrogens ! Nitrogen-number
       real              :: sulphurs  ! Sulphur-number
  endtype Chemical
  type(Chemical), public, dimension(NSPEC_TOT), target :: species
  
  ! Pointers to parts of species (e.g. short-lived, advected)
  type(Chemical), public, dimension(:), pointer :: species_adv=>null()
  type(Chemical), public, dimension(:), pointer :: species_shl=>null()
  type(Chemical), public, dimension(:), pointer :: species_semivol=>null()

contains
  subroutine define_chemicals()
    integer :: istart ! For NAG compliance
    !+
    ! Pointers to parts of species (e.g. short-lived, advected), only assigned if
    ! non-empty.
    !
    istart = 1
    if (NSPEC_ADV > 0) then
      if( FIRST_ADV > 0 ) istart = FIRST_ADV
      species_adv => species(istart:LAST_ADV)
    end if
    istart = 1
    if (NSPEC_SHL > 0) then
      if( FIRST_SHL > 0 ) istart = FIRST_SHL
      species_shl => species(istart:LAST_SHL)
    end if
    istart = 1
    if (NSPEC_SEMIVOL > 0) then
      if( FIRST_SEMIVOL > 0 ) istart = FIRST_SEMIVOL
      species_semivol => species(istart:LAST_SEMIVOL)
    end if
    
    !+
    ! Assigns names, mol wts, carbon numbers, advec,  nmhc to user-defined Chemical
    ! array, using indices from total list of species (advected + short-lived).
    !                                                      MW  NM   C    N   S
    species(OD          ) = Chemical("OD          ",  16.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(OP          ) = Chemical("OP          ",  16.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(OH          ) = Chemical("OH          ",  17.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(HO2         ) = Chemical("HO2         ",  33.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(CH3O2       ) = Chemical("CH3O2       ",  47.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(C2H5O2      ) = Chemical("C2H5O2      ",  61.0000,  0,   2.0000,   0.0000,   0.0000 )
    species(C4H9O2      ) = Chemical("C4H9O2      ",  89.0000,  0,   4.0000,   0.0000,   0.0000 )
    species(ISRO2       ) = Chemical("ISRO2       ", 101.0000,  0,   5.0000,   0.0000,   0.0000 )
    species(ETRO2       ) = Chemical("ETRO2       ",  77.0000,  0,   2.0000,   0.0000,   0.0000 )
    species(PRRO2       ) = Chemical("PRRO2       ",  91.0000,  0,   3.0000,   0.0000,   0.0000 )
    species(OXYO2       ) = Chemical("OXYO2       ",   0.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(MEKO2       ) = Chemical("MEKO2       ", 103.0000,  0,   4.0000,   0.0000,   0.0000 )
    species(C5DICARBO2  ) = Chemical("C5DICARBO2  ", 147.0000,  0,   5.0000,   0.0000,   0.0000 )
    species(MACRO2      ) = Chemical("MACRO2      ", 119.0000,  0,   4.0000,   0.0000,   0.0000 )
    species(CH3CO3      ) = Chemical("CH3CO3      ",  75.0000,  0,   2.0000,   0.0000,   0.0000 )
    species(TERPO2      ) = Chemical("TERPO2      ",   0.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(HMVKO2      ) = Chemical("HMVKO2      ",   0.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(RO2POOL     ) = Chemical("RO2POOL     ",  64.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(NMVOC       ) = Chemical("NMVOC       ",  36.7670,  0,   0.0000,   0.0000,   0.0000 )
    species(O3          ) = Chemical("O3          ",  48.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(NO          ) = Chemical("NO          ",  30.0000,  0,   0.0000,   1.0000,   0.0000 )
    species(NO2         ) = Chemical("NO2         ",  46.0000,  0,   0.0000,   1.0000,   0.0000 )
    species(NO3         ) = Chemical("NO3         ",  62.0000,  0,   0.0000,   1.0000,   0.0000 )
    species(N2O5        ) = Chemical("N2O5        ", 108.0000,  0,   0.0000,   2.0000,   0.0000 )
    species(H2          ) = Chemical("H2          ",   2.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(H2O2        ) = Chemical("H2O2        ",  34.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(HONO        ) = Chemical("HONO        ",  47.0000,  0,   0.0000,   1.0000,   0.0000 )
    species(HNO3        ) = Chemical("HNO3        ",  63.0000,  0,   0.0000,   1.0000,   0.0000 )
    species(HO2NO2      ) = Chemical("HO2NO2      ",  79.0000,  0,   0.0000,   1.0000,   0.0000 )
    species(CO          ) = Chemical("CO          ",  28.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(CH4         ) = Chemical("CH4         ",  16.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(C2H6        ) = Chemical("C2H6        ",  30.0000,  1,   2.0000,   0.0000,   0.0000 )
    species(NC4H10      ) = Chemical("NC4H10      ",  58.0000,  1,   4.0000,   0.0000,   0.0000 )
    species(C2H4        ) = Chemical("C2H4        ",  28.0000,  1,   2.0000,   0.0000,   0.0000 )
    species(C3H6        ) = Chemical("C3H6        ",  42.0000,  1,   3.0000,   0.0000,   0.0000 )
    species(BENZENE     ) = Chemical("BENZENE     ",  78.0000,  1,   6.0000,   0.0000,   0.0000 )
    species(TOLUENE     ) = Chemical("TOLUENE     ",  92.0000,  1,   7.0000,   0.0000,   0.0000 )
    species(OXYL        ) = Chemical("OXYL        ", 106.0000,  1,   8.0000,   0.0000,   0.0000 )
    species(C5H8        ) = Chemical("C5H8        ",  68.0000,  1,   5.0000,   0.0000,   0.0000 )
    species(CH3OH       ) = Chemical("CH3OH       ",  32.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(C2H5OH      ) = Chemical("C2H5OH      ",  46.0000,  0,   2.0000,   0.0000,   0.0000 )
    species(HCHO        ) = Chemical("HCHO        ",  30.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(CH3CHO      ) = Chemical("CH3CHO      ",  44.0000,  0,   2.0000,   0.0000,   0.0000 )
    species(MACR        ) = Chemical("MACR        ",  70.0000,  0,   4.0000,   0.0000,   0.0000 )
    species(MEK         ) = Chemical("MEK         ",  72.0000,  0,   4.0000,   0.0000,   0.0000 )
    species(ACETOL      ) = Chemical("ACETOL      ",  74.0000,  0,   3.0000,   0.0000,   0.0000 )
    species(GLYOX       ) = Chemical("GLYOX       ",  58.0000,  0,   2.0000,   0.0000,   0.0000 )
    species(MGLYOX      ) = Chemical("MGLYOX      ",  72.0000,  0,   3.0000,   0.0000,   0.0000 )
    species(BIACET      ) = Chemical("BIACET      ",  86.0000,  0,   4.0000,   0.0000,   0.0000 )
    species(C5DICARB    ) = Chemical("C5DICARB    ",  98.0000,  0,   5.0000,   0.0000,   0.0000 )
    species(C5134CO2OH  ) = Chemical("C5134CO2OH  ", 130.0000,  0,   5.0000,   0.0000,   0.0000 )
    species(C54CO       ) = Chemical("C54CO       ", 128.0000,  0,   5.0000,   0.0000,   0.0000 )
    species(CH3OOH      ) = Chemical("CH3OOH      ",  48.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(C2H5OOH     ) = Chemical("C2H5OOH     ",  62.0000,  0,   2.0000,   0.0000,   0.0000 )
    species(BURO2H      ) = Chemical("BURO2H      ",  90.0000,  0,   4.0000,   0.0000,   0.0000 )
    species(ETRO2H      ) = Chemical("ETRO2H      ",  78.0000,  0,   2.0000,   0.0000,   0.0000 )
    species(PRRO2H      ) = Chemical("PRRO2H      ",  92.0000,  0,   3.0000,   0.0000,   0.0000 )
    species(MEKO2H      ) = Chemical("MEKO2H      ", 104.0000,  0,   4.0000,   0.0000,   0.0000 )
    species(ISRO2H      ) = Chemical("ISRO2H      ", 118.0000,  0,   5.0000,   0.0000,   0.0000 )
    species(C5DICAROOH  ) = Chemical("C5DICAROOH  ", 147.0000,  0,   5.0000,   0.0000,   0.0000 )
    species(HPALD       ) = Chemical("HPALD       ", 116.0000,  0,   5.0000,   0.0000,   0.0000 )
    species(MACROOH     ) = Chemical("MACROOH     ", 120.0000,  0,   4.0000,   0.0000,   0.0000 )
    species(OXYO2H      ) = Chemical("OXYO2H      ", 188.0000,  0,   8.0000,   0.0000,   0.0000 )
    species(CH3CO3H     ) = Chemical("CH3CO3H     ",  76.0000,  0,   2.0000,   0.0000,   0.0000 )
    species(PACALD      ) = Chemical("PACALD      ", 130.0000,  0,   5.0000,   0.0000,   0.0000 )
    species(IEPOX       ) = Chemical("IEPOX       ", 118.0000,  0,   5.0000,   0.0000,   0.0000 )
    species(SC4H9NO3    ) = Chemical("SC4H9NO3    ", 119.0000,  0,   4.0000,   1.0000,   0.0000 )
    species(NALD        ) = Chemical("NALD        ", 105.0000,  0,   2.0000,   1.0000,   0.0000 )
    species(ISON        ) = Chemical("ISON        ", 147.0000,  0,   5.0000,   1.0000,   0.0000 )
    species(PAN         ) = Chemical("PAN         ", 121.0000,  0,   2.0000,   1.0000,   0.0000 )
    species(MPAN        ) = Chemical("MPAN        ", 132.0000,  0,   4.0000,   1.0000,   0.0000 )
    species(SO2         ) = Chemical("SO2         ",  64.0000,  0,   0.0000,   0.0000,   1.0000 )
    species(TERPPeroxy  ) = Chemical("TERPPeroxy  ",   0.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(VBS_TEST    ) = Chemical("VBS_TEST    ",   1.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(APINENE     ) = Chemical("APINENE     ", 136.0000,  1,  10.0000,   0.0000,   0.0000 )
    species(SQT_SOA_nv  ) = Chemical("SQT_SOA_nv  ", 302.0000,  0,  14.0000,   0.0000,   0.0000 )
    species(TERPOOH     ) = Chemical("TERPOOH     ", 186.0000,  0,  10.0000,   0.0000,   0.0000 )
    species(MVK         ) = Chemical("MVK         ",  70.0000,  0,   4.0000,   0.0000,   0.0000 )
    species(shipNOx     ) = Chemical("shipNOx     ",  46.0000,  0,   0.0000,   1.0000,   0.0000 )
    species(Dust_road_f ) = Chemical("Dust_road_f ", 200.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(Dust_road_c ) = Chemical("Dust_road_c ", 200.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(Dust_wb_f   ) = Chemical("Dust_wb_f   ", 200.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(Dust_wb_c   ) = Chemical("Dust_wb_c   ", 200.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(Dust_sah_f  ) = Chemical("Dust_sah_f  ", 200.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(Dust_sah_c  ) = Chemical("Dust_sah_c  ", 200.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(ASOC_ng1e2  ) = Chemical("ASOC_ng1e2  ",  12.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(ASOC_ug1    ) = Chemical("ASOC_ug1    ",  12.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(ASOC_ug10   ) = Chemical("ASOC_ug10   ",  12.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(ASOC_ug1e2  ) = Chemical("ASOC_ug1e2  ",  12.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(ASOC_ug1e3  ) = Chemical("ASOC_ug1e3  ",  12.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(non_C_ASOA_ng1e2) = Chemical("non_C_ASOA_ng1e2",   1.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(non_C_ASOA_ug1) = Chemical("non_C_ASOA_ug1",   1.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(non_C_ASOA_ug10) = Chemical("non_C_ASOA_ug10",   1.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(non_C_ASOA_ug1e2) = Chemical("non_C_ASOA_ug1e2",   1.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(non_C_ASOA_ug1e3) = Chemical("non_C_ASOA_ug1e3",   1.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(BSOC_ng1e2  ) = Chemical("BSOC_ng1e2  ",  12.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(BSOC_ug1    ) = Chemical("BSOC_ug1    ",  12.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(BSOC_ug10   ) = Chemical("BSOC_ug10   ",  12.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(BSOC_ug1e2  ) = Chemical("BSOC_ug1e2  ",  12.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(BSOC_ug1e3  ) = Chemical("BSOC_ug1e3  ",  12.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(non_C_BSOA_ng1e2) = Chemical("non_C_BSOA_ng1e2",   1.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(non_C_BSOA_ug1) = Chemical("non_C_BSOA_ug1",   1.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(non_C_BSOA_ug10) = Chemical("non_C_BSOA_ug10",   1.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(non_C_BSOA_ug1e2) = Chemical("non_C_BSOA_ug1e2",   1.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(non_C_BSOA_ug1e3) = Chemical("non_C_BSOA_ug1e3",   1.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(ffuel_ng10  ) = Chemical("ffuel_ng10  ",  15.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(woodOA_ng10 ) = Chemical("woodOA_ng10 ",  20.4000,  0,   1.0000,   0.0000,   0.0000 )
    species(SO4         ) = Chemical("SO4         ",  96.0000,  0,   0.0000,   0.0000,   1.0000 )
    species(NH3         ) = Chemical("NH3         ",  17.0000,  0,   0.0000,   1.0000,   0.0000 )
    species(NO3_f       ) = Chemical("NO3_f       ",  62.0000,  0,   0.0000,   1.0000,   0.0000 )
    species(NO3_c       ) = Chemical("NO3_c       ",  62.0000,  0,   0.0000,   1.0000,   0.0000 )
    species(NH4_f       ) = Chemical("NH4_f       ",  18.0000,  0,   0.0000,   1.0000,   0.0000 )
    species(POM_f_wood  ) = Chemical("POM_f_wood  ",  20.4000,  0,   1.0000,   0.0000,   0.0000 )
    species(POM_c_wood  ) = Chemical("POM_c_wood  ",  20.4000,  0,   1.0000,   0.0000,   0.0000 )
    species(POM_f_ffuel ) = Chemical("POM_f_ffuel ",  15.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(POM_c_ffuel ) = Chemical("POM_c_ffuel ",  15.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(EC_f_wood_new) = Chemical("EC_f_wood_new",  12.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(EC_f_wood_age) = Chemical("EC_f_wood_age",  12.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(EC_c_wood   ) = Chemical("EC_c_wood   ",  12.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(EC_f_ffuel_new) = Chemical("EC_f_ffuel_new",  12.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(EC_f_ffuel_age) = Chemical("EC_f_ffuel_age",  12.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(EC_c_ffuel  ) = Chemical("EC_c_ffuel  ",  12.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(pSO4f       ) = Chemical("pSO4f       ",  96.0000,  0,   0.0000,   0.0000,   1.0000 )
    species(pSO4c       ) = Chemical("pSO4c       ",  96.0000,  0,   0.0000,   0.0000,   1.0000 )
    species(remPPM25    ) = Chemical("remPPM25    ",  12.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(remPPM_c    ) = Chemical("remPPM_c    ",  12.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(OM25_bgnd   ) = Chemical("OM25_bgnd   ",  24.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(OM25_p      ) = Chemical("OM25_p      ",   1.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(Ash_f       ) = Chemical("Ash_f       ",  12.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(Ash_c       ) = Chemical("Ash_c       ",  12.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(ffire_CO    ) = Chemical("ffire_CO    ",  28.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(ffire_OM    ) = Chemical("ffire_OM    ",  20.4000,  0,   1.0000,   0.0000,   0.0000 )
    species(ffire_BC    ) = Chemical("ffire_BC    ",  12.0000,  0,   1.0000,   0.0000,   0.0000 )
    species(ffire_remPPM25) = Chemical("ffire_remPPM25",  12.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(SeaSalt_f   ) = Chemical("SeaSalt_f   ",  58.0000,  0,   0.0000,   0.0000,   0.0000 )
    species(SeaSalt_c   ) = Chemical("SeaSalt_c   ",  58.0000,  0,   0.0000,   0.0000,   0.0000 )
  end subroutine define_chemicals

end module ChemSpecs_mod