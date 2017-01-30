require 'csv'
require 'pry'

class Account
  def set_up_initial_values
    @tally = 0.00
    @categories = {}
  end

  def update_tally(amount)
    @tally += amount
  end

  def go_through_categories(category)
    for i in 0..category.length-1
      if !already_has_category(category[i])
        add_category(category[i])
      end
    end
  end

  def add_category(category_name)
    @categories[category_name] = Category.new
    @categories[category_name].set_up_initial_values
  end

  def pretty_tally
    return @tally.round(2)
  end

  def already_has_category(category_name)
    return (@categories[category_name] != nil)
  end

  def category(category_name)
    return @categories[category_name]
  end

  def categories
    return @categories
  end
end

class Category
  def set_up_initial_values
    @tally = 0.00
    @num_transactions = 0
    @average_transaction_cost = 0.00
  end

  def test_amount(amount, transactions)
    @tally = amount
    @num_transactions = transactions
  end

  def add_transaction(amount)
    @tally += amount
    @num_transactions += 1
    #Find category average
    @average_transaction_cost = @tally / @num_transactions
  end

  def pretty_tally
    @tally.round(2).to_s.ljust(10)
  end

  def pretty_avg_transaction
    @average_transaction_cost.round(2).to_s.ljust(20)
  end
end

class Money
  def set_value(number_string_from_csv)
    @value = number_string_from_csv.gsub(/[$]/, '').gsub(/[,]/, '').to_f.round(2)
  end

  def to_f
    return @value
  end
end