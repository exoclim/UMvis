G95 module created on Fri Nov  9 19:19:05 2012 from non_um_eg_idl_theta_forcing_mod.f90
If you edit this, you'll get what you deserve.
module-version 8
(() () () () () () () () () () () () () () () () () () () () ())

()

()

()

()

(2 'atan' '(intrinsic)' 1 ((PROCEDURE UNKNOWN INTRINSIC UNKNOWN NONE
NONE FUNCTION) (UNKNOWN) 0 0 () () () '' () ())
3 'constants' 'constants' 1 ((MODULE UNKNOWN UNKNOWN UNKNOWN NONE NONE)
(UNKNOWN) 0 0 () () () '' () ())
4 'cp' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
REAL 4) 0 0 () (CONSTANT (REAL 4) 0 '14651802' 0 140) () () '' () ())
5 'csxi1_p' 'constants' 1 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE
ALLOCATABLE DIMENSION) (REAL 4) 0 0 () (1 DEFERRED () ()) () '' () ())
6 'csxi2_p' 'constants' 1 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE
ALLOCATABLE DIMENSION) (REAL 4) 0 0 () (1 DEFERRED () ()) () '' () ())
7 'dimen' 'constants' 1 ((DERIVED UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
UNKNOWN) 0 0 () () () '' ((8 'i_start' (INTEGER 4) () () 0 0 0 ()) (9
'i_end' (INTEGER 4) () () 0 0 0 ()) (10 'j_start' (INTEGER 4) () () 0 0
0 ()) (11 'j_end' (INTEGER 4) () () 0 0 0 ()) (12 'k_start' (INTEGER 4)
() () 0 0 0 ()) (13 'k_end' (INTEGER 4) () () 0 0 0 ())) PUBLIC ())
14 'earth_radius' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE
NONE) (REAL 4) 0 0 () (CONSTANT (REAL 4) 0 '11800000' 0 153) () () '' ()
())
15 'eg_idl_theta_forcing' 'non_um_eg_idl_theta_forcing_mod' 1 ((
PROCEDURE UNKNOWN MODULE-PROC DECL NONE NONE SUBROUTINE) (PROCEDURE 0) 0
0 (16 NONE 17 NONE 18 NONE 19 NONE 20 NONE 21 NONE 22 NONE 23 NONE 24
NONE 25 NONE) () () '' () ())
26 'equilibrium_theta' 'non_um_eg_idl_theta_forcing_mod' 1 ((PROCEDURE
UNKNOWN MODULE-PROC DECL NONE NONE FUNCTION INVOKED) (REAL 4) 0 0 (27
NONE 28 NONE 29 NONE 30 NONE 31 NONE 32 NONE) () () '' () ())
33 'g' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
REAL 4) 0 0 () (CONSTANT (REAL 4) 0 '9877586' 0 130) () () '' () ())
34 'hot_jup_day_temp' 'non_um_eg_idl_theta_forcing_mod' 1 ((PROCEDURE
UNKNOWN MODULE-PROC DECL NONE NONE FUNCTION INVOKED) (REAL 4) 0 0 (35
NONE 36 NONE) () () '' () ())
37 'hot_jup_night_temp' 'non_um_eg_idl_theta_forcing_mod' 1 ((PROCEDURE
UNKNOWN MODULE-PROC DECL NONE NONE FUNCTION INVOKED) (REAL 4) 0 0 (38
NONE 39 NONE) () () '' () ())
40 'iro_hd209458b_temp' 'non_um_eg_idl_theta_forcing_mod' 1 ((PROCEDURE
UNKNOWN MODULE-PROC DECL NONE NONE FUNCTION) (REAL 4) 0 0 (41 NONE 42
NONE) () () '' () ())
43 'kappa' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE)
(REAL 4) 0 0 () (CONSTANT (REAL 4) 0 '10770973' 0 125) () () '' () ())
44 'non_um_eg_idl_theta_forcing_mod' 'non_um_eg_idl_theta_forcing_mod' 1
((MODULE UNKNOWN UNKNOWN UNKNOWN NONE NONE) (UNKNOWN) 0 0 () () () '' ()
())
45 'p_zero' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE)
(REAL 4) 0 0 () (CONSTANT (REAL 4) 0 '11000000' 0 151) () () '' () ())
46 'pdims_s' 'constants' 1 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE)
(DERIVED 7) 0 0 () () () '' () ())
47 'pi' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
REAL 4) 0 0 () (CONSTANT (REAL 4) 0 '13176795' 0 128) () () '' () ())
48 'r' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
REAL 4) 0 0 () (CONSTANT (REAL 4) 0 '9406464' 0 139) () () '' () ())
49 'r_theta_levels' 'constants' 1 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN
NONE NONE ALLOCATABLE DIMENSION) (REAL 4) 0 0 () (3 DEFERRED () () () ()
() ()) () '' () ())
50 'recip_kappa' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE
NONE) (REAL 4) 0 0 () (CONSTANT (REAL 4) 0 '13066367' 0 128) () () '' ()
())
51 'recip_newt_tscale_iro' 'non_um_eg_idl_theta_forcing_mod' 1 ((
PROCEDURE UNKNOWN MODULE-PROC DECL NONE NONE FUNCTION INVOKED) (REAL 4)
0 0 (52 NONE) () () '' () ())
53 'recip_newt_tscale_showman' 'non_um_eg_idl_theta_forcing_mod' 1 ((
PROCEDURE UNKNOWN MODULE-PROC DECL NONE NONE FUNCTION INVOKED) (REAL 4)
0 0 (54 NONE 55 NONE 56 NONE) () () '' () ())
57 'recip_relaxation_tscale' 'non_um_eg_idl_theta_forcing_mod' 1 ((
PROCEDURE UNKNOWN MODULE-PROC DECL NONE NONE FUNCTION INVOKED) (REAL 4)
0 0 (58 NONE 59 NONE 60 NONE 61 NONE 62 NONE 63 NONE) () () '' () ())
64 'set_size' 'constants' 1 ((PROCEDURE UNKNOWN MODULE-PROC DECL NONE
NONE SUBROUTINE) (PROCEDURE 0) 0 0 () () () '' () ())
65 'snxi2_p' 'constants' 1 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE
ALLOCATABLE DIMENSION) (REAL 4) 0 0 () (1 DEFERRED () ()) () '' () ())
66 'tdims' 'constants' 1 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE) (
DERIVED 7) 0 0 () () () '' () ())
67 'tdims_s' 'constants' 1 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE)
(DERIVED 7) 0 0 () () () '' () ())
68 'tf_el' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE)
(INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '3') () () '' () ())
69 'tf_hd189733b_showman' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN
UNKNOWN NONE NONE) (INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '9') () ()
'' () ())
70 'tf_hd209458b_heng' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN
NONE NONE) (INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '6') () () '' () ())
71 'tf_hd209458b_heng_smooth' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN
UNKNOWN NONE NONE) (INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '7') () ()
'' () ())
72 'tf_hd209458b_iro' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN
NONE NONE) (INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '8') () () '' () ())
73 'tf_heldsuarez' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN
NONE NONE) (INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '1') () () '' () ())
74 'tf_isothermal' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN
NONE NONE) (INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '100') () () '' ()
())
75 'tf_jupiter' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE
NONE) (INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '5') () () '' () ())
76 'tf_none' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE)
(INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '0') () () '' () ())
77 'tf_shj' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE)
(INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '4') () () '' () ())
78 'tf_tle' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE)
(INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '2') () () '' () ())
79 'timestep' 'constants' 1 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE)
(INTEGER 4) 0 0 () () () '' () ())
80 'tr_el' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE)
(INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '2') () () '' () ())
81 'tr_hd189733b_showman' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN
UNKNOWN NONE NONE) (INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '7') () ()
'' () ())
82 'tr_hd209458b_iro' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN
NONE NONE) (INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '5') () () '' () ())
83 'tr_hd209458b_showman' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN
UNKNOWN NONE NONE) (INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '6') () ()
'' () ())
84 'tr_heldsuarez' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN
NONE NONE) (INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '1') () () '' () ())
85 'tr_jupiter' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE
NONE) (INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '4') () () '' () ())
86 'tr_none' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE)
(INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '0') () () '' () ())
87 'tr_shj' 'constants' 1 ((PARAMETER UNKNOWN UNKNOWN UNKNOWN NONE NONE)
(INTEGER 4) 0 0 () (CONSTANT (INTEGER 4) 0 '3') () () '' () ())
63 'theta' '' 88 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE DIMENSION
DUMMY) (REAL 4) 0 0 () (3 EXPLICIT (VARIABLE (INTEGER 4) 0 67 ((
COMPONENT 7 'i_start'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7 'i_end')))
(VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7 'j_start'))) (VARIABLE (
INTEGER 4) 0 67 ((COMPONENT 7 'j_end'))) (VARIABLE (INTEGER 4) 0 67 ((
COMPONENT 7 'k_start'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7 'k_end'))))
() '' () ())
62 'exner_theta_levels' '' 88 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE
NONE DIMENSION DUMMY) (REAL 4) 0 0 () (3 EXPLICIT (VARIABLE (INTEGER 4)
0 67 ((COMPONENT 7 'i_start'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7
'i_end'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7 'j_start'))) (
VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7 'j_end'))) (VARIABLE (INTEGER 4)
0 67 ((COMPONENT 7 'k_start'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7
'k_end')))) () '' () ())
61 'k' '' 88 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE DUMMY) (
INTEGER 4) 0 0 () () () '' () ())
60 'j' '' 88 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE DUMMY) (
INTEGER 4) 0 0 () () () '' () ())
59 'i' '' 88 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE DUMMY) (
INTEGER 4) 0 0 () () () '' () ())
58 'trelax_number' '' 88 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE
DUMMY) (INTEGER 4) 0 0 () () () '' () ())
56 'trelax_number' '' 89 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE
DUMMY) (INTEGER 4) 0 0 () () () '' () ())
55 'theta_star' '' 89 ((VARIABLE INOUT UNKNOWN UNKNOWN NONE NONE DUMMY)
(REAL 4) 0 0 () () () '' () ())
54 'exner_theta_levels' '' 89 ((VARIABLE INOUT UNKNOWN UNKNOWN NONE NONE
DUMMY) (REAL 4) 0 0 () () () '' () ())
52 'exner_theta_levels' '' 90 ((VARIABLE INOUT UNKNOWN UNKNOWN NONE NONE
DUMMY) (REAL 4) 0 0 () () () '' () ())
42 'tforce_number' '' 91 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE
DUMMY) (INTEGER 4) 0 0 () () () '' () ())
41 'exner_theta_levels' '' 91 ((VARIABLE INOUT UNKNOWN UNKNOWN NONE NONE
DUMMY) (REAL 4) 0 0 () () () '' () ())
39 'tforce_number' '' 92 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE
DUMMY) (INTEGER 4) 0 0 () () () '' () ())
38 'exner_theta_levels' '' 92 ((VARIABLE INOUT UNKNOWN UNKNOWN NONE NONE
DUMMY) (REAL 4) 0 0 () () () '' () ())
36 'tforce_number' '' 93 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE
DUMMY) (INTEGER 4) 0 0 () () () '' () ())
35 'exner_theta_levels' '' 93 ((VARIABLE INOUT UNKNOWN UNKNOWN NONE NONE
DUMMY) (REAL 4) 0 0 () () () '' () ())
32 't_surface' '' 94 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE DUMMY)
(REAL 4) 0 0 () () () '' () ())
31 'exner_theta_levels' '' 94 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE
NONE DIMENSION DUMMY) (REAL 4) 0 0 () (3 EXPLICIT (VARIABLE (INTEGER 4)
0 67 ((COMPONENT 7 'i_start'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7
'i_end'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7 'j_start'))) (
VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7 'j_end'))) (VARIABLE (INTEGER 4)
0 67 ((COMPONENT 7 'k_start'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7
'k_end')))) () '' () ())
30 'k' '' 94 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE DUMMY) (
INTEGER 4) 0 0 () () () '' () ())
29 'j' '' 94 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE DUMMY) (
INTEGER 4) 0 0 () () () '' () ())
28 'i' '' 94 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE DUMMY) (
INTEGER 4) 0 0 () () () '' () ())
27 'tforce_number' '' 94 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE
DUMMY) (INTEGER 4) 0 0 () () () '' () ())
25 'newtonian_timescale' '' 95 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE
NONE DIMENSION DUMMY) (REAL 4) 0 0 () (3 EXPLICIT (VARIABLE (INTEGER 4)
0 67 ((COMPONENT 7 'i_start'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7
'i_end'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7 'j_start'))) (
VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7 'j_end'))) (VARIABLE (INTEGER 4)
0 67 ((COMPONENT 7 'k_start'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7
'k_end')))) () '' () ())
24 'theta_eq' '' 95 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE
DIMENSION DUMMY) (REAL 4) 0 0 () (3 EXPLICIT (VARIABLE (INTEGER 4) 0 67
((COMPONENT 7 'i_start'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7
'i_end'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7 'j_start'))) (
VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7 'j_end'))) (VARIABLE (INTEGER 4)
0 67 ((COMPONENT 7 'k_start'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7
'k_end')))) () '' () ())
23 'error_code' '' 95 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE DUMMY)
(INTEGER 4) 0 0 () () () '' () ())
22 't_surface' '' 95 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE DUMMY)
(REAL 4) 0 0 () () () '' () ())
21 'trelax_number' '' 95 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE
DUMMY) (INTEGER 4) 0 0 () () () '' () ())
20 'tforce_number' '' 95 ((VARIABLE UNKNOWN UNKNOWN UNKNOWN NONE NONE
DUMMY) (INTEGER 4) 0 0 () () () '' () ())
19 'theta_star' '' 95 ((VARIABLE INOUT UNKNOWN UNKNOWN NONE NONE
DIMENSION DUMMY) (REAL 4) 0 0 () (3 EXPLICIT (VARIABLE (INTEGER 4) 0 67
((COMPONENT 7 'i_start'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7
'i_end'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7 'j_start'))) (
VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7 'j_end'))) (VARIABLE (INTEGER 4)
0 67 ((COMPONENT 7 'k_start'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7
'k_end')))) () '' () ())
18 'exner' '' 95 ((VARIABLE INOUT UNKNOWN UNKNOWN NONE NONE DIMENSION
DUMMY) (REAL 4) 0 0 () (3 EXPLICIT (VARIABLE (INTEGER 4) 0 46 ((
COMPONENT 7 'i_start'))) (VARIABLE (INTEGER 4) 0 46 ((COMPONENT 7 'i_end')))
(VARIABLE (INTEGER 4) 0 46 ((COMPONENT 7 'j_start'))) (VARIABLE (
INTEGER 4) 0 46 ((COMPONENT 7 'j_end'))) (VARIABLE (INTEGER 4) 0 46 ((
COMPONENT 7 'k_start'))) (OP (INTEGER 4) 0 PLUS (VARIABLE (INTEGER 4) 0
46 ((COMPONENT 7 'k_end'))) (CONSTANT (INTEGER 4) 0 '1'))) () '' () ())
17 'exner_theta_levels' '' 95 ((VARIABLE INOUT UNKNOWN UNKNOWN NONE NONE
DIMENSION DUMMY) (REAL 4) 0 0 () (3 EXPLICIT (VARIABLE (INTEGER 4) 0 67
((COMPONENT 7 'i_start'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7
'i_end'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7 'j_start'))) (
VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7 'j_end'))) (VARIABLE (INTEGER 4)
0 67 ((COMPONENT 7 'k_start'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7
'k_end')))) () '' () ())
16 'theta' '' 95 ((VARIABLE INOUT UNKNOWN UNKNOWN NONE NONE DIMENSION
DUMMY) (REAL 4) 0 0 () (3 EXPLICIT (VARIABLE (INTEGER 4) 0 67 ((
COMPONENT 7 'i_start'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7 'i_end')))
(VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7 'j_start'))) (VARIABLE (
INTEGER 4) 0 67 ((COMPONENT 7 'j_end'))) (VARIABLE (INTEGER 4) 0 67 ((
COMPONENT 7 'k_start'))) (VARIABLE (INTEGER 4) 0 67 ((COMPONENT 7 'k_end'))))
() '' () ())
)

('atan' 0 2 'constants' 0 3 'cp' 0 4 'csxi1_p' 0 5 'csxi2_p' 0 6 'dimen'
0 7 'earth_radius' 0 14 'eg_idl_theta_forcing' 0 15 'equilibrium_theta'
0 26 'g' 0 33 'hot_jup_day_temp' 0 34 'hot_jup_night_temp' 0 37
'iro_hd209458b_temp' 0 40 'kappa' 0 43 'non_um_eg_idl_theta_forcing_mod'
0 44 'p_zero' 0 45 'pdims_s' 0 46 'pi' 0 47 'r' 0 48 'r_theta_levels' 0
49 'recip_kappa' 0 50 'recip_newt_tscale_iro' 0 51
'recip_newt_tscale_showman' 0 53 'recip_relaxation_tscale' 0 57 'set_size'
0 64 'snxi2_p' 0 65 'tdims' 0 66 'tdims_s' 0 67 'tf_el' 0 68
'tf_hd189733b_showman' 0 69 'tf_hd209458b_heng' 0 70
'tf_hd209458b_heng_smooth' 0 71 'tf_hd209458b_iro' 0 72 'tf_heldsuarez'
0 73 'tf_isothermal' 0 74 'tf_jupiter' 0 75 'tf_none' 0 76 'tf_shj' 0 77
'tf_tle' 0 78 'timestep' 0 79 'tr_el' 0 80 'tr_hd189733b_showman' 0 81
'tr_hd209458b_iro' 0 82 'tr_hd209458b_showman' 0 83 'tr_heldsuarez' 0 84
'tr_jupiter' 0 85 'tr_none' 0 86 'tr_shj' 0 87)
