import os
import csv
csvpath = os.path.join("..","PyBank","Resources","budget_data.csv")


total_month = 0
total_amount = []
total_amount_2 = 0
change_profit = []
month = []

with open(csvpath) as csvfile:
    csvreader = csv.reader(csvfile, delimiter = ',')

    csv_header = next(csvreader)

    print(f"CSV Header: {csv_header}")

    for row in csvreader:
        print(row)
        month.append(row[0])

        total_month += 1
        total_amount.append(int(row[1]))
        total_amount_2 += int(row[1])
    
    for i in range(len(total_amount)-1):
        change_profit.append(total_amount[i+1]-total_amount[i])

    greatest_increase = max(change_profit)
    greatest_decrease = min(change_profit)
    greatest_increase_index = change_profit.index(max(change_profit))+1
    greatest_decrease_index = change_profit.index(min(change_profit)) + 1

    print("financial analysis")
    print("----------------------------------------------------")
    print(f"Total Months:{total_month}")
    print(f"Total Profit/Losses: {sum(total_amount)}")
    print(f"Second option for total profit/losses: {total_amount_2}")
    print(f"Average change: {round(sum(change_profit)/len(change_profit),2)}")
    print(f"Greatest Increase In Profit: {month[greatest_increase_index]} ($ {greatest_increase})")
    print(f"Greatest Decrease In Profit: {month[greatest_decrease_index]} ($ {greatest_decrease})")

    
    output = "../PyBank/output.txt"
    with open(output, "w") as txt:
        txt.write("Financial Analysis: \n")
        txt.write("---------------------------------------\n")
        txt.write(f"Total Months:{total_month}\n")
        txt.write(f"Total Profit/Losses: {sum(total_amount)}\n")
        txt.write(f"Average change: {round(sum(change_profit)/len(change_profit),2)}\n")
        txt.write(f"Greatest Increase In Profit: {month[greatest_increase_index]} ($ {greatest_increase})\n")
        txt.write(f"Greatest Decrease In Profit: {month[greatest_decrease_index]} ($ {greatest_decrease})")
    