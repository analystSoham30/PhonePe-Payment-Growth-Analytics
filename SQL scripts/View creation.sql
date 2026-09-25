# views creation for importing to PowerBI

create or replace view `dist_demo vw` as
select State, District, Headquarters, Population, `Area (sq km)`, Density, Code, `Alternate Name`
from `dist_demo`;

create or replace view `dist_txn_users vw` as
select State, Year, Quarter,CONCAT(Year, '-', Quarter) AS Time_Key, District, Code, Transactions,  `Amount (INR)`, `ATV (INR)`, `Registered Users`, `App Opens`
from `dist_txn_users`;

create or replace view `state_device_data vw` as
select State, Year, Quarter,CONCAT(Year, '-', Quarter) AS Time_Key, Brand, `Registered Users`, `Percentage`  
from `state_device_data`;

create or replace view `state_txn_category vw` as
select State, Year, Quarter,CONCAT(Year, '-', Quarter) AS Time_Key, `Transaction Type`, Transactions, `Amount (INR)`, `ATV (INR)`
from `state_txn_category`;

create or replace view `state_txn_users vw` as
select  State, Year, Quarter, CONCAT(Year, '-', Quarter) AS Time_Key, Transactions, `Amount (INR)`, `ATV (INR)`, `Registered Users`, `App Opens`  
from `state_txn_users`;

create or replace view `dim_state vw` as
select distinct state from state_txn_users;

create or replace view `dim_time vw` as 
select distinct year, quarter, concat(year, '-', quarter) as Time_Key
from state_txn_users;
 