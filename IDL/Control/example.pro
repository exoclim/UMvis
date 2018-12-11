pro example, netcdf_um_in, netcdf_name_key

; A basic example to create a plot for 
; data from HD209458b, depicting vertical velocity (contours)
; and horizontal velocity (vectors/arrows)
; After 20 days

; fname is where are the data stored

;-----------------------------------------------------
; What is the planet planet_setup (planet_setup_list)
planet_setup_in='HD209458b'
;-----------------------------------------------------
; List of required variables
variable_list='Wvel&Horizvel'
;-----------------------------------------------------
; Vertical Axis: Pressure, Sigma, Height
vert_type='Height'  
;vert_type='Pressure'  
;vert_type='Sigma'  
; Use of each dimension when plotting
plot_grid_use_in=STRARR(4)
;plot_grid_use_in(0)='mean' ; Longitude
;plot_grid_use_in(0)='min' ; Longitude
;plot_grid_use_in(0)='max' ; Longitude
;plot_grid_use_in(0)='sum'  ; Longitude
plot_grid_use_in(0)='x'    ; Longitude
;plot_grid_use_in(0)='y'    ; Longitude
;plot_grid_use_in(0)='90.0'  ; Longitude
;plot_grid_use_in(1)='mean' ; Latitude
;plot_grid_use_in(1)='min' ; Latitude
;plot_grid_use_in(1)='max' ; Latitude
;plot_grid_use_in(1)='sum'  ; Latitude
;plot_grid_use_in(1)='x'    ; Latitude
plot_grid_use_in(1)='y'    ; Latitude
;plot_grid_use_in(1)='45.0'  ; Latitude
;plot_grid_use_in(2)='mean' ; Vertical
;plot_grid_use_in(2)='min' ; Vertical
;plot_grid_use_in(2)='max' ; Vertical
;plot_grid_use_in(2)='sum'  ; Vertical
;plot_grid_use_in(2)='x'    ; Vertical
;plot_grid_use_in(2)='y'    ; Vertical
plot_grid_use_in(2)='9.0e6'  ; Vertical
;plot_grid_use_in(3)='mean' ; Time
;plot_grid_use_in(3)='min' ; Time
;plot_grid_use_in(3)='max' ; Time
;plot_grid_use_in(3)='sum'  ; Time
;plot_grid_use_in(3)='x'    ; Time
;plot_grid_use_in(3)='y'    ; Time
plot_grid_use_in(3)='20.125'  ; Time
;-----------------------------------------------------
; Limits to array when plotting (i.e. after mapping)
; OPTIONAL-> DEFAULT='min'/max
; These are ignored if a value is selected
; in the relevant plot_grid_use
;plot_limits_in=strarr(4,2)
;plot_limits_in(0,0)='min'    ; Longitude
;plot_limits_in(0,1)='max'    ; Longitude
;plot_limits_in(1,0)='min'    ; Latitude
;plot_limits_in(1,1)='max'     ; Latitude
;plot_limits_in(2,0)='min'    ; Height/Pressure/Sigma
;plot_limits_in(2,1)='max'    ; Height/Pressure/Sigma
;plot_limits_in(3,0)='min'    ; Time
;plot_limits_in(3,1)='max'    ; Time
;-----------------------------------------------------
; Setup the contours, colour scale etc for the vertical
; velocity (type=wind)
contour_setup='wind'
; Thin out the default arrows a bit, and lengthen
vect_arr_lgth_ovrd=3.0
vect_arr_thin_ovrd=2.0

; Call routine for standard plot
um_plot, variable_list,$
         vert_type, $
         netcdf_name_key=netcdf_name_key, $
         netcdf_um_in=netcdf_um_in, $
         planet_setup_in=planet_setup_in, $
         plot_grid_use_in=plot_grid_use_in, $
         contour_setup=contour_setup, $
         vect_arr_lgth_ovrd=vect_arr_lgth_ovrd, $
         vect_arr_thin_ovrd=vect_arr_thin_ovrd, $
         ; add a colour bar
         /plot_cbar
end
