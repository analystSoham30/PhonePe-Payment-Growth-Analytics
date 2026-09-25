# 2.1.1 Calculate the total number of transactions and total 
# transaction amount for each state over the years. Display the results in a tabular format.

select State, Year, sum(transactions) as Total_Transactions, round(sum(`Amount (INR)`),2) as Total_transaction_amount
from state_txn_users
group by State, Year;

# 2.1.2 Identify the top 5 states with the highest transaction volumes 
# and the top 5 states with the lowest transaction volumes. Display the results.

select State, sum(transactions) as Total_Transactions
from state_txn_users
group by State
order by Total_Transactions desc
limit 5;

select State, sum(transactions) as Total_Transactions
from state_txn_users
group by State
order by Total_Transactions asc
limit 5;

# 2.2 For each state and quarter, determine the most frequent transaction type. Display the results in a tabular format.

with cte as (
	select state, Quarter, `transaction type`, sum(Transactions) as Total_transactions,
		row_number() over (partition by state, quarter order by sum(Transactions) desc) as rnk
	from state_txn_category
	group by state, Quarter, `transaction type`
)
select state, Quarter, `transaction type`, Total_transactions
from cte
where rnk = 1;

# 2.3 Identify the device brand with the highest number of registered users in each state. 


with cte as(
select*
from state_txn_users
where Year = (select max(Year) from state_txn_users)
)
select
	c.State,
    c.`Registered Users`,
    d.Population,
    round(c.`Registered Users`/d.`Population`,2)as User_registration_ratio
from cte as c
inner join dist_demo as d
on d.State = c.State
where quarter = (select max(quarter) from cte);

with cte as(
select*
from state_device_data
where Year = (select max(Year) from state_txn_users)
),cte2 as(
select
	State,
    Brand,
    `Registered Users`,
    rank() over(partition by State order by `Registered Users` desc) as Brand_ranking
from cte
where quarter = (select max(quarter) from cte)
)
select
	State,
    Brand,
    `Registered Users`
from cte2
where Brand_ranking = 1;

# 2.4 For each state, identify the district with the highest population.

with cte as (
	select state, district, population,
		dense_rank() over(partition by state order by population desc) as rnk
	from dist_demo
)

select state, district, round(population) as population
from cte
where rnk=1;

# 2.5.1 Compute the average transaction value for each state. Display the results in a tabular format.

select state, round(avg(`ATV (INR)`),2) as Avg_transaction_value
from state_txn_users
group by state
order by Avg_transaction_value desc;

# 2.5.2 Identify the top 5 states with the highest ATV and the top 5 states with the lowest ATV. 

( select state, round(avg(`ATV (INR)`),2) as Avg_transaction_value
from state_txn_users
group by state
order by Avg_transaction_value desc
limit 5 )
union
( select state, round(avg(`ATV (INR)`),2) as Avg_transaction_value
from state_txn_users
group by state
order by Avg_transaction_value asc
limit 5
);

# 2.6 Calculate the total number of app opens over the years and quarters for each state. 

select state, year, quarter, `App opens`
from state_txn_users;

# 3.1: Ensure data consistency across state and district levels
# For each state, calculate the total number of transactions, total transaction amount, and 
# total registered users by summing up the values from the district level data.

with state as ( select State, round(sum(Transactions)) as S_Total_transactions,
	round(sum(`Amount (INR)`),2) as S_Total_TransactionAmount,
    sum(`registered users`) as S_Total_users    
	from state_txn_users s
	group by State
),

district as ( select State, round(sum(Transactions)) as D_Total_transactions,
	round(sum(`Amount (INR)`),2) as D_Total_TransactionAmount,
    sum(`registered users`) as D_Total_users    
	from dist_txn_users 
	group by State
)

select s.state, 
	(S_Total_transactions - D_Total_transactions) as transn_count_delta,
    (S_Total_TransactionAmount - D_Total_TransactionAmount) as transn_amt_delta,
    (S_Total_users - D_Total_users) as Users_delta
from state s 
inner join district d on s.state = d.state;

# 4.1 Merge the State_Txn and Users dataset with the District Demographics dataset to calculate the ratio of 
# registered users to the population for each state. 

with cte as ( select *
from state_txn_users
where year = (select max(year) from state_txn_users) 
	and quarter = (select max(quarter) from state_txn_users
					where year = (select max(year) from state_txn_users))
),

cte2 as ( select state, round(sum(population)) as population
			from dist_demo
            group by state )

select s.state, s.`registered users`,
	d.population, round(s.`registered users`/d.population,3) as ratio
from cte s
inner join cte2 d on s.state = d.state;

# 4.2.1 Merge the District_Txn and Users dataset with the District Demographics dataset.
# 4.2.2 Calculate the correlation between population density and transaction volume.

with cte as ( select *
from dist_txn_users
where year = (select max(year) from dist_txn_users) 
	and quarter = (select max(quarter) from dist_txn_users
					where year = (select max(year) from dist_txn_users))
)

select
	round(((AVG(de.density*d.Transactions) - AVG(de.density) * AVG(d.Transactions))/(STDDEV_POP(de.density) * STDDEV_POP(d.Transactions))),3) as correlation_coefficient
	from cte d 
    inner join dist_demo de on d.code = de.code;

#4.3 Average transaction amount per user 
#4.3.1 Merge relevant datasets to calculate the average transaction amount per user for each state.

with regis_users as ( 
	select state, `Registered Users`
	from state_txn_users
	where year = (select max(year) from state_txn_users) 
		and quarter = (select max(quarter) from state_txn_users
					where year = (select max(year) from state_txn_users))
), 

transac_value as (
	select state, sum(`Amount (INR)`) as Total_amount
    from state_txn_users
    group by state
)

select r.state, s.total_amount, r.`registered users`,
	round((s.total_amount/r.`registered users`),2) as amount_per_user
from regis_users r 
join transac_value s on r.state = s.state
order by amount_per_user desc;

# 4.3.2 Identify the top 5 states with the highest average transaction amount per user and the top 5 states with the 
# lowest average transaction amount per user.

with regis_users as ( 
	select state, `Registered Users`
	from state_txn_users
	where year = (select max(year) from state_txn_users) 
		and quarter = (select max(quarter) from state_txn_users
					where year = (select max(year) from state_txn_users))
), 

transac_value as (
	select state, sum(`Amount (INR)`) as Total_amount
    from state_txn_users
    group by state
)

(select r.state, s.total_amount, r.`registered users`,
	round((s.total_amount/r.`registered users`),2) as amount_per_user
from regis_users r 
join transac_value s on r.state = s.state
order by amount_per_user desc
limit 5)

union

(select r.state, s.total_amount, r.`registered users`,
	round((s.total_amount/r.`registered users`),2) as amount_per_user
from regis_users r 
join transac_value s on r.state = s.state
order by amount_per_user asc
limit 5);

# 4.4 Device brand usage ratio
# 4.4.1 Merge the State_DeviceData dataset with the State_Txn and Users dataset.
# 4.4.2 Calculate the ratio of users using each device brand to the total number of registered users in each state.

with regis_users as ( 
	select state, `Registered Users` as Total_registered_users
	from state_txn_users
	where year = (select max(year) from state_txn_users) 
		and quarter = (select max(quarter) from state_txn_users
					where year = (select max(year) from state_txn_users))
), 
brand_users as (
		select state, brand, `registered users`
        from state_device_data
        where year = (select max(year) from state_device_data)
        and quarter = (select max(quarter) from state_device_data
						where year = (select max(year) from state_device_data))
)

select r.state, b.brand, b.`registered users`, r.Total_registered_users,
	round(b.`registered users`/r.Total_registered_users,2) as user_ratio
from regis_users r 
inner join brand_users b on r.state = b.state;