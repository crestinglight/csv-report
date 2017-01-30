require_relative "classes.rb"
require 'pry'

def tallyTest
	#Setup
	x = Account.new
	x.set_up_initial_values

	#Exercise
	actual = x.update_tally(6.72)
	expected = 6.72

	output(actual, expected)
end

def categoryAvgTest
	#Setup
	x = Category.new
	x.test_amount(30, 3)

	#Exercise
	actual = x.add_transaction(10)
	expected = 10

	output(actual, expected)
end

def categoryListTest
	#Setup
	category = ["Entertainment", "Garbage", "Groceries", "Entertainment", "Car Stuff", "Groceries", "Makeup"]
	
	expected = ["Entertainment", "Garbage", "Groceries", "Car Stuff", "Makeup"]
	x = Account.new
	x.set_up_initial_values

	#Exercise
	x.go_through_categories(category)
	actual = x.categories.keys
	return output(actual, expected)
end

def output(actual, expected)
	if actual === expected
		puts "Pass."
	else
		puts "Fail. I expected #{expected}, but I got #{actual}."
	end
end

tallyTest
categoryAvgTest
categoryListTest
