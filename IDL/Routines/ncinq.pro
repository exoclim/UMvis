pro ncinq, fname

; Filename to write info to:
i=strpos(fname,'.nc')
oname=strmid(fname,0,i)+'.txt'
openw, 10, oname

ncid=ncdf_open(fname, /nowrite)

nc_struc=ncdf_inquire(ncid)
num_dim=nc_struc.Ndims
num_var=nc_struc.Nvars
num_attrib=nc_struc.Ngatts
recdim=nc_struc.RecDim


printf, 10, 'num_dim = ', num_dim
printf, 10, 'num_var = ', num_var
printf, 10, 'num_attrib = ', num_attrib
printf, 10, 'recdim = ', recdim

dim_size=intarr(num_dim)
dim_name=strarr(num_dim)
var_size=intarr(num_var)
var_name=strarr(num_var)
;var_type=intarr(num_var)
var_type=strarr(num_var)
var_dims=intarr(num_var)

dim_max=5

var_dimid=intarr(dim_max,num_var)

for i=0,num_dim-1 do begin
  dimid=i
  ncdf_diminq, ncid,dimid,name_tmp,size_tmp
  dim_name(i)=name_tmp
  dim_size(i)=size_tmp
  printf, 10, 'dim ', i, ' : ', dim_name(i), dim_size(i)
endfor

dim_max=1
for i=0,num_var-1 do begin
  i1=i
  var_struc = ncdf_varinq(ncid,i1)
  dimid_tmp=var_struc.Dim
  natts=var_struc.Natts
  var_name(i)=var_struc.Name
  var_type(i)=var_struc.DataType
  var_dims(i)=var_struc.Ndims
  ndimid=n_elements(dimid_tmp)
  var_dimid(0:ndimid-1,i)=reform(dimid_tmp,ndimid)


  ;print, 'natts = ', natts
  dim_max = max([var_dims(i),dim_max])
;  print, 'var ', i, ' : name = ', var_name(i), ' type = ',var_type(i), $
;                      ' dims = ', var_dims(i)

  printf, 10, i, var_name(i),var_type(i),var_dims(i), $
  format='("var",i6," : name = ",a,3x,"type = ",a,3x,"dims = ",i2)'
  printf, 10, '            dimid = ', dimid_tmp

endfor

printf, 10
printf, 10, 'dim_max = ', dim_max

; 31st May 2005
if ( 1 eq 1) then begin
printf, 10 
printf, 10, 'Attributes'
printf, 10, '----------'
printf, 10 
for i=0,num_var-1 do begin
  printf, 10,var_name(i),' :'
  for j=0,num_attrib-1 do begin
    att_name=ncdf_attname(ncid,i,j)
    ;if (stat eq nc_noerror) then begin
      stat=ncdf_attinq(ncid,i,att_name)
      att_type=stat.DataType
      length=stat.length
      ncdf_attget, ncid,i,att_name,att_value
;      printf, 10,'... name   = ',att_name
;      printf, 10,'... type   = ',att_type
;      printf, 10,'... length = ', length
;      printf, 10,'... value  = ', att_value
       printf, 10,'... ',att_name,': ', att_value
    ;endif
  endfor
endfor
endif

ncdf_close, ncid
close,10

end
