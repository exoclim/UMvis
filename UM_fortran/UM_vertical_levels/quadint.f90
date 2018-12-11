module quad

implicit none

contains

  real function quadintflg(x, xflg, y, yflg, xval, flag)

    ! Performs quadratic interpolation.
    ! flag returned as 'OK' for sucess, '1' if outside x-range.

    real, dimension(:), intent(in) :: x, y
    character(len=*), dimension(:), intent(in), optional :: xflg, yflg
    real, intent(in) :: xval
    character(len=*), intent(out) :: flag

    integer :: i, j
    real :: a, b, c

    if (xval<minval(x) .or. xval>maxval(x)) then
      ! We won't extrapolate.
      flag='1'
      quadintflg=0.0
    else
      flag='OK'
      if (size(x) == 2) then
        ! Only enough data for linear interpolation.
        if (present(xflg)) then
          do j=1, 2
            if (xflg(j) /= 'OK') then
              flag=xflg(j)
              quadintflg=0.0
              return
            end if
          end do
        end if
        if (present(yflg)) then
          do j=1, 2
            if (yflg(j) /= 'OK') then
              flag=yflg(j)
              quadintflg=0.0
              return
            end if
          end do
        end if
        quadintflg=y(1) + (y(2)-y(1))*(x(1)-xval)/(x(1)-x(2))
      else
        i=minloc(abs(x-xval),1) 
        ! Always interpolate between the two points either side and the
        ! point whose index is one more (this is for compatibility with 
        ! the numerical recipes routine we used to use, and to ensure 
        ! we do not change the interpolating polynomial between points).
        if ((xval-x(i))/(x(size(x))-x(1)) > 0.0) i=i+1
        if (i == size(x)) i=i-1
        if (i == 1) then
          flag='1'
          quadintflg=0.0
        else if (i >= size(x)) then
          flag='1'
          quadintflg=0.0
        else
          if (present(xflg)) then
            do j=i-1, i+1
              if (xflg(j) /= 'OK') then
                flag=xflg(j)
                quadintflg=0.0
                return
              end if
            end do
          end if
          if (present(yflg)) then
            do j=i-1, i+1
              if (yflg(j) /= 'OK') then
                flag=yflg(j)
                quadintflg=0.0
                return
              end if
            end do
          end if
          a = (y(i-1)-y(i))/(x(i-1)-x(i)) - (y(i)-y(i+1))/(x(i)-x(i+1))
          a = a/((x(i-1)*x(i-1)-x(i)*x(i))/(x(i-1)-x(i)) - &
          (x(i)*x(i)-x(i+1)*x(i+1))/(x(i)-x(i+1)))
          b = (y(i-1)-y(i)-a*(x(i-1)*x(i-1)-x(i)*x(i)))/(x(i-1)-x(i))
          c = y(i-1) - a*x(i-1)*x(i-1) - b*x(i-1)
          quadintflg = a*xval*xval + b*xval + c
        end if
      end if
    end if

  end function quadintflg

  real function quadint(x, y, xval, flag)

    real, dimension(:), intent(in) :: x, y
    real, intent(in) :: xval
    character(len=*), intent(out) :: flag

    character(len=10), allocatable, dimension(:) :: xflg, yflg

    allocate(xflg(size(x)), yflg(size(y)))

    xflg='OK'
    yflg='OK'

    quadint=quadintflg(x, xflg, y, yflg, xval, flag)

    deallocate(xflg, yflg)

  end function quadint

end module quad
