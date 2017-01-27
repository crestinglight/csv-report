require 'csv'
require 'pry'

$args = ARGV
$csvFile = "accounts.csv"

$balanceRemaining = 0


$categoryBalanceList = []
$categoryCountList = []
$categoryAvgList = []

$categoryTransactionCount = 0
$categoryBalanceAmount = 0

def userInput
	if $args.length > 0
		accountsRetrieved = [$args[0]]
		
	else 
		accountsRetrieved = findUniqueAccountNames

	end
	return accountsRetrieved
end


###IF USING THE ENTIRE FILE
def findUniqueAccountNames
	accountsUniqueRetrieved = []
	CSV.foreach($csvFile, {headers: true, return_headers: false}) do |row|
		accountsUniqueRetrieved.push(row["Account"].strip)
	end
	
	return accountsUniqueRetrieved.uniq
end

def findUniqueCategoryNames
	categoryUniqueRetrieved = []
	CSV.foreach($csvFile, {headers: true, return_headers: false}) do |row|
		categoryUniqueRetrieved.push(row["Category"].strip)
	end
	
	return categoryUniqueRetrieved.uniq
end

$accountUniqueNamesList = userInput
$categoryUniqueNamesList = findUniqueCategoryNames

def processEachCategoryForThisAccount(accName, category)
	$categoryTransactionCount = 0
	$categoryBalanceAmount = 0
	processTransactionsForThisCategory(accName, category)
	$categoryBalanceList.push($categoryBalanceAmount.round(2))
	$categoryCountList.push($categoryTransactionCount)
	binding.pry
end

def processTransactionsForThisCategory(accName, category)
	listOfTransactionsForThisCategory = getTransactionsArray(accName, category)
	
	for i in 0..listOfTransactionsForThisCategory.length-1
		outflowFloat = makeStringIntoFloat(listOfTransactionsForThisCategory[i]["Outflow"])
		inflowFloat = makeStringIntoFloat(listOfTransactionsForThisCategory[i]["Inflow"])
		$categoryTransactionCount = $categoryTransactionCount + 1
		$categoryBalanceAmount = $categoryBalanceAmount - outflowFloat + inflowFloat
	end
end

def makeStringIntoFloat(column)
	column.gsub(/[$]/,'').gsub(/[,]/,'').to_f
end

def getTransactionsArray(accName, category)
	transactions = []
	CSV.foreach($csvFile, {headers: true, return_headers: false}) do |row|
		strippedName = row["Account"].strip
		row["Account"] = strippedName
		strippedCategory = row["Category"].strip
		row["Category"] = strippedCategory
		if ifRelevantTransaction(accName, strippedName, category, strippedCategory) then
			transactions.push(row)
		end
	end
	return transactions
end

def ifRelevantTransaction(wantName, actualName, wantCategory, actualCategory)
	return actualName == wantName && actualCategory == wantCategory
end

processEachCategoryForThisAccount("Sonia", "Entertainment")

# def updateBalance
# 	update total balance for this account, in this category
# 	totalBalance
# end

# def categoryCount
# 	Update number of transactions for this account, in this category
# end

# def totalBalanceForCategory
# 	update overall balance of $ spent
# end

# def ignoreZeroCategories
# 	if category has 0 transactions for that account
# 		ignore category, set average to 0 (cannot divide by 0)
# 	else
# 		add category to total for that account
# 	end
# end

# def averageAmountForCategory
# 	find average for the category, per account
# end

# def totalBalance
# 	add up total amount spent and find ending balance
# end

# def outputConsoleFormat
# 	Console Format
# end

# def outputHTML
# 	HTML
# end

# def outputCSV
# 	CSV format
# end
