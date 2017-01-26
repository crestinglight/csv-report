require 'csv'
require 'pry'

args = ARGV
csvFile="accounts.csv"

accountCategories = getCategories(csvFile)
totalSpent = 0
startingBalance = getStartingBalance(accountName,csvFile)
balanceRemaining = 0

categoryList = []
categoryBalanceList = []
categoryCountList = []
categoryAvgList = []


categoryTransactionCount = 0
categoryBalance = 0

def getAccounts(inputCSV)
    accounts = []
    CSV.foreach(inputCSV, {headers: true, return_headers: false}) do |row|
        accounts.push(row["Account"].strip)
    end
    return accounts.uniq
end

def getCategories(inputCSV)
    categories = []
    CSV.foreach(inputCSV, {headers: true, return_headers: false}) do |row|
        categories.push(row["Category"].strip)
    end
    return categories.uniq
end

def listTransactions(name, category, inputCSV)
    transactions = []
    CSV.foreach(inputCSV, {headers: true, return_headers: false}) do |row|
        strippedName = row["Account"].strip
        row["Account"] = strippedName
        strippedCategory = row["Category"].strip
        row["Category"] = strippedCategory
        if strippedName == name then
            if strippedCategory == category then
                transactions.push(row)
            end
        end
    end
    return transactions
end


def getStartingBalance(name, inputCSV)
    transactions = []
    CSV.foreach(inputCSV, {headers: true, return_headers: false}) do |row|
        strippedName = row["Account"].strip
        row["Account"] = strippedName
        strippedPayee = row["Payee"].strip
        row["Payee"] = strippedPayee
        if strippedName == name then
            if strippedPayee == "STARTING BALANCE" then
                transactions.push(row)
            end
        end
    end
    return transactions[0]["Inflow"].gsub(/[$]/,'').gsub(/[,]/,'').to_f
end

def convertToFloat(transaction)
    transaction.gsub(/[$]/,'').gsub(/[,]/,'').to_f
end

def processTransactions(categoryTransactions, categoryBalance, categoryTransactionCount, categoryCountList, categoryBalanceList)
    for transaction in categoryTransactions
        #Loops for each transaction for Priya and Sonia. Stripping the "$" and "," then converting to integer.
        transactionOutflow = convertToFloat(transaction[4])
        transactionInflow = convertToFloat(transaction[5])

        transactionCountUpdate(categoryTransactionCount, categoryCountList)
        balanceUpdate(transactionInflow, transactionOutflow, categoryBalance, categoryBalanceList)
    end
end

def transactionCountUpdate(categoryTransactionCount, categoryCountList)
    categoryTransactionCount = categoryTransactionCount + 1
    categoryCountList.push(categoryTransactionCount)
end

def balanceUpdate(transactionInflow, transactionOutflow, categoryBalance, categoryBalanceList)
    categoryBalance = categoryBalance  - transactionOutflow + transactionInflow
    categoryBalanceList.push(categoryBalance.round(2))
end



if args.length > 0 
    #if we are passed an account name in the command line
    #only loop over the single account
    accountsArray = [args[0]]
else
    #loop over all the accounts
    accountsArray = getAccounts(csvFile)
end

    #console output stuff goes here
    #remember to skip outputting a category if categoryCountList[i] == 0
def consoleHeader(accountName, balanceRemaining)
    print ("=" * 80) + "\n"
    print "Account: " + accountName + "... Balance: $" + balanceRemaining.round(2).to_s + "\n"
    print ("=" * 80) + "\n"
    print "Category" + (" " * 22) + "|  " + "Total Spent" + (" " * 4) + "|  " + "Average Transaction" + "\n"
    print ("-" * 29) + " | " + ("-" * 15) + " | " + ("-" * 30) + "\n"
end

def consoleBody(categoryList, categoryCountList, categoryBalanceList, categoryAvgList)
    for i in 0..categoryList.length-1
        if categoryCountList[i] > 0 then
            print categoryList[i] + (" " * (30 - categoryList[i].length)) + "|  " + categoryBalanceList[i].round(2).to_s + (" " * (15 - categoryBalanceList[i].to_s.length)) + "|  " + categoryAvgList[i].round(2).to_s + "\n" 
        end 
    end
    print "\n" + "\n"
end


def consoleOutput(accountName, balanceRemaining, categoryList, categoryCountList, categoryBalanceList, categoryAvgList)
    consoleHeader(accountName, balanceRemaining)
    consoleBody(categoryList, categoryCountList, categoryBalanceList, categoryAvgList)
end


for accountName in accountsArray 
    #For loop that will loop twice, once for each account name, in this case "Priya" and "Sonia".
    
    

    

    for category in accountCategories
        categoryTransactions = listTransactions(accountName, category, csvFile)
        categoryList.push(category)
   ###################################
        
        #Calling the for loop that processes each transaction for a category.
        processTransactions(categoryTransactions, categoryBalance, categoryTransactionCount, categoryCountList, categoryBalanceList)
        binding.pry

        if categoryTransactionCount > 0 
            categoryAvg = categoryBalance / categoryTransactionCount
        else
            categoryAvg = 0
        end

        categoryAvgList.push(categoryAvg)


    end

    for categoryBalance in categoryBalanceList
        balanceRemaining = balanceRemaining + categoryBalance
    end
    consoleOutput(accountName, balanceRemaining, categoryList, categoryCountList, categoryBalanceList, categoryAvgList)
end    


