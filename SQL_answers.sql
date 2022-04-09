#SQL Questions - Classification

-- Select all the data from table credit_card_data to check if the data was imported correctly.
select * 
from credit_card_data;

-- Use the alter table command to drop the column q4_balance from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.
ALTER TABLE credit_card_data
DROP COLUMN q4_balance;

-- Use sql query to find how many rows of data you have.
select count(*) from credit_card_data;

-- What are the unique values in the column Offer_accepted?
select distinct offer_accepted
from credit_card_data;

-- What are the unique values in the column Reward?
select distinct reward
from credit_card_data;

-- What are the unique values in the column mailer_type?
select distinct mailer_type
from credit_card_data;

-- What are the unique values in the column credit_cards_held?
select distinct credit_cards_held
from credit_card_data;

-- What are the unique values in the column household_size?
select distinct household_size
from credit_card_data;

-- Arrange the data in a decreasing order by the average_balance of the house. Return only the customer_number of the top 10 customers with the highest average_balances in your data.
select customer_number 
from credit_card_data
order by average_balance desc
limit 10;

-- What is the average balance of all the customers in your data?
select avg(average_balance)
from credit_card_data;

-- What is the average balance of the customers grouped by Income Level? The returned result should have only two columns, income level and Average balance of the customers. Use an alias to change the name of the second column.
select avg(average_balance) as Average_balance, income_level
from credit_card_data
group by income_level
order by Average_balance;

-- What is the average balance of the customers grouped by number_of_bank_accounts_open? The returned result should have only two columns, number_of_bank_accounts_open and Average balance of the customers. Use an alias to change the name of the second column.
select bank_accounts_open as number_of_bank_accounts_open, avg(average_balance) as Average_balance 
from credit_card_data
group by bank_accounts_open
order by Average_balance;

-- What is the average number of credit cards held by customers for each of the credit card ratings? The returned result should have only two columns, rating and average number of credit cards held. Use an alias to change the name of the second column.
select credit_rating, avg(credit_cards_held) as average_credit_cards
from credit_card_data
group by credit_rating;

-- Is there any correlation between the columns credit_cards_held and number_of_bank_accounts_open? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
select bank_accounts_open, avg(credit_cards_held)
from credit_card_data
group by bank_accounts_open; # there is no correlation.

-- Your managers are only interested in the customers with the following properties:
-- Credit rating medium or high
-- Credit cards held 2 or less
-- Owns their own home
-- Household size 3 or more
-- Can you filter the customers who accepted the offers here?
select customer_number, credit_rating,  credit_cards_held, own_your_home, household_size
from credit_card_data
where (credit_rating = 'Medium' or credit_rating = 'High') 
and (credit_cards_held < 2 or credit_cards_held = 2) 
and (own_your_home = 'Yes')
and (household_size = 3 or household_size > 3)
and (offer_accepted ='Yes');

-- Your managers want to find out the list of customers whose average balance is less than the average balance of all the customers in the database. Write a query to show them the list of such customers. You might need to use a subquery for this problem.
select customer_number, average_balance
from credit_card_data
where average_balance < (select avg(average_balance) as average_balance_of_all
from credit_card_data);

-- Since this is something that the senior management is regularly interested in, create a view of the same query.
create view less_than_avg_balance as
select customer_number, average_balance
from credit_card_data
where average_balance < (select avg(average_balance) as average_balance_of_all
from credit_card_data);

-- What is the number of people who accepted the offer vs number of people who did not?
select count(customer_number) as number_of_customers, offer_accepted
from credit_card_data
group by offer_accepted;

-- Your managers are more interested in customers with a credit rating of high or medium. What is the difference in average balances of the customers with high credit card rating and low credit card rating?
with blah as 
(select avg(average_balance) as avg_balance, credit_rating
from credit_card_data
where credit_rating = 'High' or credit_rating = 'Low'
group by credit_rating)

select avg_balance - lag(avg_balance, 1) over (order by avg_balance) as difference 
from blah;

-- In the database, which all types of communication (mailer_type) were used and with how many customers?
select count(customer_number) as number_of_customers, mailer_type
from credit_card_data
group by mailer_type;

-- Provide the details of the customer that is the 11th least Q1_balance in your database.
with ranking_q1 as (
select customer_number, 
q1_balance, 
dense_rank() over (order by q1_balance asc) as rank_no
from credit_card_data)

select customer_number, q1_balance, rank_no
from ranking_q1
where rank_no = 11 ; 

