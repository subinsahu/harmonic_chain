!! this programs run simulation for heat transfer
!!! for a chain of coupled harmonic oscillator 
!!!and stores  the heat current
!!  at each lattice site for given temperature



!!!!!!!!!Description of variables!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!          constants
!!!!!!    k=     coupling constant
!!!!!!    Da=  onsite force constant
!!!!!!    sim_time= Actual simulation time
!!!!!!    heat_time=pre heating time
!!!!!!    n= number of lattice point
!!!!!    m= mass
!!!!!    kb= boltzman constant

!!!       arrays
!!!!!!    yn=  yn(t)
!!!!!!   yf=  yn(t+dt)
!!!!!!   yp=  yn(t-dt)
!!!!!!  force= deterministic force
!!!!!!  random =  due to  random force
!!!!!   dw=coupling between yn and y_{n-1}
!!!!!!  v=velocities
!!!!!!  jn= total heat transfer
!!!!!!! gamma_n= gammas
!!!!!! temp_n = temperature of each lattice point

!! other variables
!!!!!!   YL= LEFT LATTICE DISPLACEMENT
!!!!!!!  YR= RIGHT LATTICE DISPLACEMENT 
!!!!!!! TEMP = TEMPERATURE OF COLD SIDE


MODULE CONSTANTS
REAL*8, PARAMETER::  K=1, KB=1, DA=1 ,M=1
REAL *8,PARAMETER::  TEMP_GRAD=100.0
REAL*8,PARAMETER::  DT=10E-4 , sim_time= 5e6 ,measure_time=1e3, temp=3000
INTEGER,PARAMETER::N=100
END MODULE CONSTANTS

PROGRAM MAIN
USE CONSTANTS
IMPLICIT NONE

REAL*8,DIMENSION(N)::YN,YP,TEMP_N,GAMMA_N,J_N,DW,VN
REAL*8 GAMMA,TIME,time1
INTEGER I,j,order,digit1
CHARACTER(LEN=12)::FILE_NAME
character(len=20)::restart_file
character(len=1)::sign


READ(*,*) GAMMA
order=floor(log10(gamma))
digit1=int(gamma/10d0**order)

if (order.ge.0) sign='+'
if(order.lt.0) sign='-'


CALL RAND_SEED(abs(order*digit1))

WRITE(FILE_NAME,'(i1,a1,a1,i1 ,A7)') ,digit1,'e',sign,abs(order),'pns.dat'
write(restart_file,'(I1,a1,a1,i1,A15)')   ,digit1,'e',sign,abs(order),'pns_restart.cor'

open(unit=11,file=adjustl(restart_file),action='read',status='old')
read(11,*) time
read(11,*)Yp(1:n)
read(11,*)yn(1:n)
read(11,*)j_n(1:n)
close(11)



GAMMA_N=GAMMA


TEMP_N(1)=TEMP
TEMP_N(N)=TEMP+TEMP_GRAD
FORALL (I=2:99) TEMP_N(I)=TEMP+(I-1)*TEMP_GRAD/99.0


FORALL (I=2:99) GAMMA_N(I)=0.0                                        ! ONCE HEATING CYCLE IS OVER TURN OFF LANGEVIN BATH IN MIDDLE
do while (time.le.sim_time)
   time1=0
   do while (time1.le.measure_time)
      DW(1)=K*YN(1)
      FORALL (I=2:100) DW(I)=K*(YN(I)-YN(I-1))
      CALL  BBK(YP,YN,VN,GAMMA_N,TEMP_N)
      J_N=J_N+VN*DW*DT
      TIME1=TIME1+DT
   end do
   time=time+time1
   OPEN (UNIT=12,FILE=ADJUSTL(FILE_NAME),ACCESS='APPEND',STATUS='unknown')   ! DATA FILE
   WRIte (12,*) time, j_n /(time*temp_grad)
   OPEN (UNIT=13,FILE=ADJUSTL(restart_FILE),ACCESS='APPEND',STATUS='replace')   ! DATA FILE
   WRIte (13,*) time
   WRIte (13,*) YP
   WRIte (13,*) YN
   WRIte (13,*) j_n

   close(13)

   close(12)
   j=0
end do
end program main


subroutine bbk(yp,yn,vn,gamma_n,temp_n)
use constants
implicit none
real*8,dimension(n)::yn,yf,yp,yl,yr,gamma_n,temp_n,vn,random,force
real*8 ::random_normal
integer::i
 
  yl(1)=0; yr(n)=0                                                   ! fixed boundary conditon
  forall (i=2:100) yl(i)=yn(i-1)
  forall (i=1:99) yr(i)=yn(i+1)
 
do i=1,n
   random(i)=sqrt(2*gamma_n(i)*kb*temp_n(i)/m/DT)*random_normal() 
end do
force = -k*(yn-yl) +k*(yr-yn)-Da*yn


yf=yn+(1.0-gamma_n*DT/2.0)/(1.0+gamma_n*DT/2.0)*(yn-yp)&
     +1.0/(1.0+gamma_n*DT/2.0)*DT**2*(force/m+random)                  !bbk integrator
vn=(yf-yp)/(2*DT)
yp=yn
yn=yf
return
end subroutine bbk


! function to generate random gaussian distribution
real*8 FUNCTION random_normal()


!     Local variables
REAL*8     :: s = 0.449871, t = -0.386595, a = 0.19600, b = 0.25472,  half=0.5,         &
            r1 = 0.27597, r2 = 0.27846, u, v, x, y, q
integer :: temp,i

!     Generate P = (u,v) uniform in rectangle enclosing acceptance region

DO
  CALL RANDOM_NUMBER(u)
  CALL RANDOM_NUMBER(v)
  v = 1.7156 * (v - half)

!     Evaluate the quadratic form
  x = u - s
  y = ABS(v) - t
  q = x**2 + y*(a*y - b*x) 
!     Accept P if inside inner ellipse
  IF (q < r1) EXIT
!     Reject P if outside outer ellipse
  IF (q > r2) CYCLE
!     Reject P if outside acceptance region
  IF (v**2 < -4.0*LOG(u)*u**2) EXIT
END DO
!     Return ratio of P's coordinates as the normal deviate
random_normal = v/u
RETURN

END FUNCTION random_normal



subroutine rand_seed(temp)
 integer :: seed_size,temp
       integer,allocatable :: seed(:)
       call random_seed() ! initialize with system generated seed
       call random_seed(size=seed_size) ! find out size of seed
       allocate(seed(seed_size))
       call random_seed(get=seed) ! get system generated seed
       seed=temp
       call random_seed(put=seed) ! set current seed
       call random_seed(get=seed) ! get current seed
       deallocate(seed)           ! safe
end subroutine
