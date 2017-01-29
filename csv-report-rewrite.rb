require 'csv'
require 'pry'

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
           cleanCellDollar = cell.gsub(/[$]/,'')
           cleanCell = cleanCellDollar.strip
           cleanRow.push(cleanCell)
       end
       cleanAccounts.push(cleanRow)
   end
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

csvReport