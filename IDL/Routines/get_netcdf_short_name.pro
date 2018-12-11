function get_netcdf_short_name, netcdf_var_names, target_var, $
                                nofail=nofail
  ; A little routine to find a target UMvis name from a list
  ; and provide the netcdf shortname

  umvis_names=netcdf_var_names(0,*)
  nstrings=n_elements(umvis_names)
  location=find_string_in_arr(nstrings, umvis_names, target_var, $
                              nofail=nofail)
  netcdf_short_name=netcdf_var_names(1,location)
  return, netcdf_short_name
end
