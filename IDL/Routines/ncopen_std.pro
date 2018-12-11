pro ncopen_std, ncid, fname

; Common block holding netCDF info
@nc_info

; Open netCDF file
ncid=ncdf_open(fname, /nowrite)

; Read number of dimensions, variables and attributes
nc_struc=ncdf_inquire(ncid)
num_dim=nc_struc.Ndims
num_var=nc_struc.Nvars
num_attrib=nc_struc.Ngatts
recdim=nc_struc.RecDim

; Read the name and size of each dimension
dim_size=intarr(num_dim)
dim_name=strarr(num_dim)
for i=0,num_dim-1 do begin
  dimid=i
  ncdf_diminq, ncid,dimid,name_tmp,size_tmp
  dim_name(i)=name_tmp
  dim_size(i)=size_tmp
endfor

; Read variable names, types and dimensions
var_name=strarr(num_var)
var_type=strarr(num_var)
var_dims=intarr(num_var)
var_dimid=intarr(num_dim,num_var)
for i=0,num_var-1 do begin
  i1=i
  var_struc=ncdf_varinq(ncid,i1)
  dimid_tmp=var_struc.Dim
  natts=var_struc.Natts
  var_name(i)=var_struc.Name
  var_type(i)=var_struc.DataType
  var_dims(i)=var_struc.Ndims
  ndimid=n_elements(dimid_tmp)
  var_dimid(0:ndimid-1,i)=reform(dimid_tmp,ndimid)
endfor

end
