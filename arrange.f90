! this program writes data of different gamma in one file

program arrange
implicit none
integer i,order,digit
character(len=11)::input_name
character(len=8)::output_name
real*8,dimension(101)::data
real*8, dimension(13)::gamma_num
character(len=4),dimension(13):: gamma_str
gamma_str=['1e-2' ,'3e-2', '5e-2'  ,'1e-1' ,'3e-1', '5e-1' , '1e+0' ,'3e+0', '5e+0' ,'1e+1','3e+1' ,'5e+1' , '1e+2']
gamma_num=[ .01, .03, .05, .1, .3,  .5 , 1.0, 3.0 , 5.0, 10.0 , 30.0, 50.0 , 100.0]

output_name='plot.dat'
open (unit=11,file=output_name,access='append',status='replace')   

do i=1,13
   write(input_name, '(a4, a7)') gamma_str(i),'pns.dat'
   input_name=adjustl(input_name)
   open(unit=12,file=input_name,action='read',status='old')
   do
      read(12,*,end=20) data(1:101)
   end do
20 close (12)
   write(11,*) gamma_num(i), data(51)
end do
close (11)
end program arrange
