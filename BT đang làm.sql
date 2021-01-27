--
select * from transactions
select * from customer
select * from Branch
select * from account
select * from Bank

select count (cust_name) from customer 

select count(*) from customer
--1.	Có bao nhiêu khách hàng có ở Quảng Nam thuộc chi nhánh ngân hàng Vietcombank Đà Nẵng
Select COUNT(*) as soluongKH
from customer join Branch on customer. Br_id = Branch.BR_id
where Cust_ad like N'QUẢNG NAM' AND BR_name like N'Vietcombank Đà Nẵng'

--2.	Hiển thị danh sách khách hàng thuộc chi nhánh Vũng Tàu và số dư trong tài khoản của họ.
-- cột? hàng ? đk?
select cust_name, ac_balance
from customer join account on customer.Cust_id =account.cust_id 
			join Branch on Branch.BR_id= customer.Br_id
where BR_name like N'%Vũng Tàu%' 

--3.	Trong quý 1 năm 2012, có bao nhiêu khách hàng thực hiện giao dịch rút tiền tại Ngân hàng Vietcombank?
select count(distinct customer.Cust_id) as SoLuongKH
from transactions join  account on transactions.ac_no = account.Ac_no
                  join customer on customer.cust_id = account.cust_id
				  join Branch on customer.Br_id = Branch.BR_id
				  join Bank on Bank.b_id = Branch.B_id
where transactions.t_type = 0 
      and YEAR(t_date)= 2012 and MONTH(t_date) between 1 and 3
	  and b_name = N'Ngân hàng Công thương Việt Nam'

--4.	Thống kê số lượng giao dịch, tổng tiền giao dịch trong từng tháng của năm 2014
select count(t_id) as Soluonggiaodich, sum(t_amount) as tongtien, month(t_date) as thang
from transactions 
where year(t_date)= 2014
 group by month(t_date)

--5.	Thống kê tổng tiền khách hàng gửi của mỗi chi nhánh, sắp xếp theo thứ tự giảm dần của tổng tiền
select Br_name, sum(t_amount) as TongTien 
from customer   join  branch on customer.Br_id = branch.br_id 
				join account on 	customer.cust_id = account.cust_id
				join transactions on account.ac_no =transactions.ac_no
where t_type = 1
group by Branch.Br_name, Branch.Br_ad
order by sum( t_amount ) DESC 

--6.	Chi nhánh Sài Gòn có bao nhiêu khách hàng không thực hiện bất kỳ giao dịch nào trong vòng 3 năm trở lại đây.
-- Nếu có thể, hãy hiển thị tên và số điện thoại của các khách đó để phòng marketing xử lý. 
select Cust_name, cust_phone
from Customer join Branch on customer.Br_id=Branch.BR_id
				join account on customer.Cust_id= account.cust_id
where BR_name = N'Chi nhánh Sài Gòn'

and Account. Ac_no not in (select ac_no from transactions
                     where
					 DATEDIFF(yyyy,t_date, getdate()) < 3)

--7.	Thống kê thông tin giao dịch theo mùa, nội dung thống kê gồm: số lượng giao dịch, 
-- lượng tiền giao dịch trung bình, tổng tiền giao dịch, lượng tiền giao dịch nhiều nhất, lượng tiền giao dịch ít nhất. 
Select count(t_id) as Soluonggiaodich, avg(t_amount) as Luongtiengiaodichtrungbinh, max(t_amount ) as luongtiengiaodichnhieunhat, min(t_amount) as Luongtiengiaodichitnhat
from transactions 
group by DATEPART( QUARTER, T_date)


--8.	Tìm số tiền giao dịch nhiều nhất trong năm 2016 của chi nhánh Huế. Nếu có thể, hãy đưa ra tên của khách hàng thực hiện giao dịch đó.
select cust_name, max(t_amount) as Sotiengiaodichnhieunhat
from customer join Branch on customer.Br_id=branch.BR_id
			  join account on customer.Cust_id=account.cust_id
			  join transactions on account.Ac_no=transactions.ac_no

where Br_name like N'%Huế%'
	  and year(t_date)=2016

group by  Cust_name	
	--9.	Tìm khách hàng có lượng tiền gửi nhiều nhất vào ngân hàng trong năm 2017 (nhằm mục đích tri ân khách hàng)
	select cust_name, sum (t_amount) as Tienguinhieunhat
	from customer  join account on customer.Cust_id=account.cust_id
	               join transactions on account.Ac_no=transactions.ac_no

	where t_type = 1 and YEAR(t_date)= 2017
	and t_amount = (select top 1 sum(t_amount )
					from customer    join account on customer.cust_id = account.cust_id
									join transactions on account.Ac_no = transactions.ac_no
					where YEAR(t_date)=2017
					group by customer.Cust_id
					order by sum(t_amount) DESC )
	group by cust_name
--10.	Tìm những khách hàng có cùng chi nhánh với ông Phan Nguyên Anh
select Cust_name
from customer join Branch on customer.Br_id= Branch.BR_id
where Branch.BR_id in ( select BR_id
				from customer
				where BR_name= N'Phan Nguyên'
				      ) 


--11.	Liệt kê những giao dịch thực hiện cùng giờ với giao dịch của ông Lê Nguyễn Hoàng Văn ngày 2016-12-02
select T_id, t_time, t_date, Cust_name
from transactions join account on transactions.ac_no=account.Ac_no
				join customer on customer.Cust_id = account.cust_id
where DATEPART(hour,t_time)  in (select DATEPART(hour,t_time)
				from transactions join account on transactions.ac_no=account.Ac_no
				join customer on customer.Cust_id = account.cust_id
				where Cust_name = N'Lê Nguyễn Hoàng Văn'
				      and t_date= '2016-12-02')


--12.	Hiển thị danh sách khách hàng ở cùng thành phố với Trần Văn Thiện Thanh
select cust_name
from customer
where Cust_ad like (select cust_ad
                 from customer
				 where Cust_name = N'Trần Văn Thiện Thanh'
				 )
group by Cust_name 
--

select cust_id, cust_name, Cust_ad
from customer 
where REVERSE(LEFT(reverse(cust_ad), CHARINDEX(',', REVERSE(replace(cust_ad,'-', ',')))-1))
in (select REVERSE(left(reverse(cust_ad), CHARINDEX(',', REVERSE(replace(cust_ad,'-', ',')))-1))
      from customer
where cust_name= N'Trần Văn Thiện Thanh')

--13.	Tìm những giao dịch diễn ra cùng ngày với giao dịch có mã số 0000000217
--14.	Tìm những giao dịch cùng loại với giao dịch có mã số 0000000387
--15.	Những chi nhánh nào thực hiện nhiều giao dịch gửi tiền trong tháng 12/2015 hơn chi nhánh Đà Nẵng
--16.	Hãy liệt kê những tài khoảng trong vòng 6 tháng trở lại đây không phát sinh giao dịch
--17.	Ông Phạm Duy Khánh thuộc chi nhánh nào? Từ 01/2017 đến nay ông Khánh đã thực hiện bao nhiêu giao dịch gửi tiền vào ngân hàng với tổng số tiền là bao nhiêu.
--18.	Thống kê giao dịch theo từng năm, nội dung thống kê gồm: số lượng giao dịch, lượng tiền giao dịch trung bình
--19.	Thống kê số lượng giao dịch theo ngày và đêm trong năm 2017 ở chi nhánh Hà Nội, Sài Gòn
--20.	Hiển thị danh sách khách hàng chưa thực hiện giao dịch nào trong năm 2017?




-- gộp theo nhóm dữ liệu- select danh sách cột 1, hàm gộp 1. hàm gộp 2 from(where) /group by:ds cột 2
select BR_ID ,COUNT(*) as SoluongKH 
from Customer
group by BR_ID 
having COUNT(*) > 0
--
select BR_ID ,COUNT(*) as SoluongKH 
from Customer
group by BR_ID 
having COUNT(*) > 2
--
select * 
from customer join Branch on customer.Br_id = Branch.Br_id
--tìm ra những khách hàng có cùng chi nhánh với ông Hà công lực
-- cột ? bảng? điều kiện?
select Cust_name, br_id
from customer
where Br_id = (select customer.Br_id
                FROM customer  JOIN Branch ON customer.Br_id= Branch.BR_id
				WHERE Cust_name = N'Hà Công Lực')
-- 
select ac_no, ac_balance
from account 
where ac_balance > all (select ac_balance
						from account join customer on account.cust_id=customer.Cust_id
						where Br_id = 'VB004')