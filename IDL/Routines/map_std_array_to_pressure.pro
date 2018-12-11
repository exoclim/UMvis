function map_std_array_to_pressure, var_for_map, var_grid_size, p_mapped, $
                                    nz_map, z_map, missing=missing, value=value, $
                                    grid_boundaries=grid_boundaries, $
                                    var_boundaries=var_boundaries
  ; This function just maps the variable var_for_map
  ; onto the pressure structure z_map, using the pressure
  ; given in p_mapped
  ; The std_array part is just that this assumes that
  ; the variables are (lon,lat,vert,time)
  ; (The pressure variables should in ln(pressure) on input
  ; to make an accurate interpolation)
  ; Allocate output array
  arr_size=INTARR(4)
  arr_size(0)=var_grid_size(0)
  arr_size(1)=var_grid_size(1)
  arr_size(2)=nz_map
  arr_size(3)=var_grid_size(3)
  var_mapped=safe_alloc_arr(4, arr_size, /float_arr)
  ; Need to set the sense of the axis
  ; i.e. height increases with index, pressure decreases
  index_increment='negative'
  ; this means the value decreases with index
  ; appropriate for pressure
  ; whereas height would increase with index
  ; This needs to be done in a loop as the 
  ; axis we interpolate onto, i.e. pressure
  ; changes for each column
  ; Allocate array sizes for each column
  var_column=safe_alloc_arr(1, var_grid_size(2), /float_arr)
  p_column=safe_alloc_arr(1, var_grid_size(2), /float_arr)
  for itime=0, var_grid_size(3)-1 do begin
     for ilat=0, var_grid_size(1)-1 do begin
        for ilon=0, var_grid_size(0)-1 do begin
           ; Setup column data
           ; Must be done like this to keep number
           ; of dimensions at 1 i.e. cant use
           ; var_column=var_for_map(ilon,ilat,*,itime)
           var_column(0:var_grid_size(2)-1)=$
              var_for_map(ilon,ilat,0:var_grid_size(2)-1,itime)
           p_column(0:var_grid_size(2)-1)=$
              p_mapped(ilon,ilat,0:var_grid_size(2)-1,itime)
           ; Interpolate the column
           map_column=linear_interp_whole_axis($
                      1, $
                      var_column, p_column, z_map, 0, $
                      missing=missing, $
                      index_increment=index_increment, $
                      value=value, $
                      grid_boundaries=grid_boundaries, $
                      var_boundaries=var_boundaries)
           var_mapped(ilon,ilat,*,itime)=map_column(*)
        endfor
     endfor
     string_out=string(itime+1)+'/'+string(var_grid_size(3))
     string_out=strcompress(string_out,/remove_all)
     print, 'Mapping to pressure Timestep: ', string_out
  endfor
  return, var_mapped
end
