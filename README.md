# Pewlett-Hackard-Analysis
## Challenge
1) I was trying to figure out the number of people who are about to retire based on age and then figure out what department had the most number of retirees. I then needed to figure out who could be a part of the Mentorship program. Some problems I encountered, was that the data tables I had were all separated so i had to figure out how to combine certain tables together to extract the information I needed. 

2) To get the list of people who are about to retire I first had to import all my data tables. Then I used INNER JOIN on the employee table, salaries table, and titles table to get all the information I needed. Once that table was created I needed to filter out the duplicates I had in the table. To filter I used a partition
```
SELECT emp_no,
    first_name,
    last_name,
    title,
    to_date,
    salary
INTO new_retire
FROM
 (SELECT emp_no,
    first_name,
    last_name,
    title,
    to_date,
    salary, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM employee_title
 ) tmp WHERE rn = 1
ORDER BY emp_no;

SELECT * FROM new_retire;
```
I had some issues with the partition since I wasn't sure what data tables I needed to use to partition. I also had some trouble understanding what the code was trying to do. With some advice I now understand that the partition splits the data tables into its individual data table and puts it in a temporary table then combines it again to the original data table to see the data with no duplicates. 

3) The results from the analysis are: 90398 employees are of age to retire. The title that have the highest number of retirees are Senior Engineers with 29414 employees who can retire. There were only 1549 employees eligible for the Mentorship program. When creating the retiree table I was given a list of columns I needed to have in my tables but those columns weren't enough to create the partitioned table so I needed to go back and add some columns so the partition would work. When creating the Mentorship table I encountered some duplicates, if I wanted to exclude the duplicates I would've lost a good chunk of data but it might be a good idea to see a table with no duplicates. Some limitations were the birth date range that I used to create the retiree table, I used a year range of 1952-1955 and there could be some employees who are not planning on retiring just yet so the data could be inflated. It's a good idea to use 1952-1955 as an approximate number of people who are about to retire. 
