

!-------------------------------------------------

function factor_mumps_cmplx( n, sym, ooc, A, jA, iA, ierr )  result(pm_out)
!DIR$ ATTRIBUTES DLLEXPORT :: factor_mumps_cmplx
!DIR$ ATTRIBUTES ALIAS: 'factor_mumps_cmplx_':: factor_mumps_cmplx

use mumps_cmplx_mod, only: init, convert_to_mumps_format, factor_matrix, destroy
implicit none

INCLUDE 'zmumps_struc.h'

integer(kind=8):: pm_out   ! mumps pointer
integer(kind=8),intent(in):: n  ! # of rows in A
integer(kind=8),intent(in):: sym  ! =0 unsymmetric, =1 symm. pos def, =2 general symm.
integer(kind=8),intent(in):: ooc  ! = 0 in-core factorization, = 1 out-of-core factorization
complex(kind=8),intent(in):: A(*)
integer(kind=8),intent(in):: jA(*), iA(n+1)

integer(kind=8),intent(out):: ierr
! integer,intent(out):: ierr  ! =0 no error, < 0 error (memory, singular, etc.)

TYPE(ZMUMPS_STRUC),pointer:: pmumps_par
TYPE(ZMUMPS_STRUC):: mumps_par

pointer ( pm, mumps_par )

allocate(pmumps_par)
pm = loc(pmumps_par)

call init( mumps_par, sym)
call convert_to_mumps_format(mumps_par, n, A,jA,iA, ierr )
if (ierr < 0) return  ! allocation error

call factor_matrix(mumps_par, ooc, ierr)

if ( ierr < 0 ) then
   ! Error in factorization.
   call destroy(mumps_par)
   pm_out = 0
else
   pm_out = pm
end if

return
end  function factor_mumps_cmplx

!-------------------------------------------------

subroutine solve_mumps_cmplx( pm_in, nrhs, rhs, x, transpose )
! Solve A*x = rhs

!DIR$ ATTRIBUTES DLLEXPORT :: solve_mumps_cmplx
!DIR$ ATTRIBUTES ALIAS: 'solve_mumps_cmplx_':: solve_mumps_cmplx
use mumps_cmplx_mod, only: solve

implicit none

INCLUDE 'zmumps_struc.h'

integer(kind=8),intent(in):: pm_in  ! mumps pointer
integer(kind=8),intent(in):: nrhs  ! # of right-hand-sides
complex(kind=8),intent(in):: rhs(*)   ! right-hand-side
complex(kind=8),intent(out):: x(*)    ! solution
integer(kind=8),intent(in):: transpose   ! =1 for transpose

TYPE(ZMUMPS_STRUC):: mumps_par
pointer ( pm, mumps_par )
pm = pm_in

call solve(mumps_par, nrhs, rhs, x, (transpose==1) )

return
end subroutine solve_mumps_cmplx

!-------------------------------------------------

subroutine destroy_mumps_cmplx( pm_in )
!  Destroy the instance (deallocate internal data structures)

!DIR$ ATTRIBUTES DLLEXPORT :: destroy_mumps_cmplx
!DIR$ ATTRIBUTES ALIAS: 'destroy_mumps_cmplx_':: destroy_mumps_cmplx
use mumps_cmplx_mod, only: destroy

implicit none
INCLUDE 'zmumps_struc.h'

integer(kind=8),intent(in):: pm_in  ! mumps pointer
TYPE(ZMUMPS_STRUC):: mumps_par
pointer ( pm, mumps_par )
pm = pm_in

call destroy(mumps_par)

return
end subroutine destroy_mumps_cmplx

!-------------------------------------------------

