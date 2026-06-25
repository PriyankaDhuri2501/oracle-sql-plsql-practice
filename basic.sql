Create table customer
(
cust_id number(6),
cust_name varchar2(50),
mobile_no number(10),
dob date,
city varchar2(30),
email_id varchar2(30)
);

Insert into customer(cust_id,cust_name,mobile_no,dob,city,email_id) VALUES
(100000,'Arun', 9090909090,to_date('08/04/2000','mm/dd/yyyy'),'Chennai','arun@gmail.com');

INSERT INTO customer(cust_id,cust_name,mobile_no,dob,email_id)
    VALUES (100002,'Geon',4873948743,TO_DATE('12/24/1985','mm/dd/yyyy'),'Geon@gmail.com');
    
INSERT INTO customer(cust_id,cust_name,dob,email_id)
    VALUES (100003,'Shree',TO_DATE('10/24/1935','mm/dd/yyyy'),'Shree@gmail.com');
    
    
SELECT * FROM customer;

DROP TABLE

commit;
rollback;

update customer 
set city='Mumbai' where cust_id=100002;

update customer 
set mobile_no=9821801803,city='Pune' where cust_id=100003;

update customer 
set city=null where cust_id in (100002,100003);

SELECT * FROM customer where city is null;

update customer 
set city='Pune' where city is null;

select length(city) from customer;

alter table customer 
add country varchar2(10);

update customer set country='India';

create table test1( no1 number(3), no2 number(2));

insert into test1 (no1,no2) values (1,2);
insert into test1 (no1,no2) values (4,7);
savepoint a;
insert into test1 (no1,no2) values (2,9);
savepoint b;
insert into test1 (no1,no2) values (1,0);
savepoint c;
rollback to b;

select * from test1;