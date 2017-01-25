require 'csv'
require 'pry'

=begin
def csvReport
    accounts = CSV.read('accounts.csv')
    cleanAccounts = clean(accounts)
    
    uniquePayers(cleanAccounts)
end


def clean(accounts)
    cleanAccounts = Array.new
    
    for row in accounts 
        cleanRow = Array.new
        for cell in row
            #tried with cleanCell = cell.gsub(/\\n/,'')
            #Strip cleans whitespace before and after
            #there may be data that it screws up

            cleanCellDollar = cell.gsub(/[$]/,'')
            cleanCell = cleanCellDollar.strip
            cleanRow.push(cleanCell)
        end
        cleanAccounts.push(cleanRow)
    end
    #puts cleanAccounts.inspect
    return cleanAccounts
end


def uniquePayers(allOneAccount)

    kvpByName = {}
    
    for i in 1..allOneAccount.length - 1

        entrySet = allOneAccount[i]
        id = entrySet[0]

        unless kvpByName.has_key?(id)
            kvpByName[id] = []

        end

        kvpByName[id].push(entrySet)


    end
    puts kvpByName

end
=end

#Returns an Array of unique names within the CSV file.
def getAccounts(inputCSV)
    accounts = []
    CSV.foreach(inputCSV, {headers: true, return_headers: false}) do |row|
        accounts.push(row["Account"].strip)
    end
    return accounts.uniq
end

#Returns an array of unique categories within the CSV file.
def getCategories(inputCSV)
    categories = []
    CSV.foreach(inputCSV, {headers: true, return_headers: false}) do |row|
        categories.push(row["Category"].strip)
    end
    return categories.uniq
end

#Returns an array of transactions for an account name in a certain category.
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

#Returns the starting balance float.
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

#The CSV file we're organizing
csvFile="accounts.csv"
#Initiates getAccounts function, returns an array of unique names.
accountsArray = getAccounts(csvFile)


#Looping through the information and formatting/tracking what we want.
for accountName in accountsArray 
    #For loop that will loop twice, once for each account name, in this case "Priya" and "Sonia".
    
    accountCategories = getCategories(csvFile)
    totalSpent = 0
    startingBalance = getStartingBalance(accountName,csvFile)
    balanceRemaining = startingBalance

    #Loops through each category in the account.
    for category in accountCategories
        categoryTransactions = listTransactions(accountName, category, csvFile)
        categoryTransactionCount = 0
        categorySpent = 0
   

        for transaction in categoryTransactions
            #Loops for each transaction in the category for the current account.
            transactionCategory = transaction[3]
            transactionOutflow = transaction[4].gsub(/[$]/,'').gsub(/[,]/,'').to_f
            transactionInflow = transaction[5].gsub(/[$]/,'').gsub(/[,]/,'').to_f
            categories = getCategories(csvFile)
            #binding.pry
            categorySpent = categorySpent  + transactionOutflow

        end

        binding.pry

    end

end















