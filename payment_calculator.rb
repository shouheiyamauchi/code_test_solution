require 'date'

class PaymentCalculator
  attr_accessor :rules

  def initialize(rules)
    @rules = []

    raise ArgumentError, "All week ranges are not covered" if !check_ranges_covered(rules)

    rules.each do |rule|
      week = rule["applicableWeeks"]

      # extract start and end weeks from string and convert to integer
      (week.index("-") != nil) ? (
        start_week = week[0...week.index("-")].to_i
        end_week = week[week.index("-")+1...week.length].to_i
      ) : (
        start_week = week[0...week.index("+")].to_i
        end_week = (Float::INFINITY)
      )

      # convert ranges string into a Range class
      rule["applicableWeeks"] = start_week..end_week

      # rules updated with integer range
      @rules.push(rule)
    end
  end

  def print_payments(people)
    people.each do |person|
      weeks_since_injury = calculate_weeks(person)
      applicable_rule = select_rule(weeks_since_injury)
      qualifying_wage = calculate_qualifying_wage(person, applicable_rule)
      payment = calculate_payment(qualifying_wage, applicable_rule)

      puts "#{person["name"]}'s payment is $#{'%.02f' % payment}"
    end
  end

  # ensure that all week ranges in the rules array, otherwise return false
  def check_ranges_covered(rules)
    return (rules[0]["applicableWeeks"] == "1+") if rules.length == 1

    rules.each_with_index do |rule, index|
      week = rule["applicableWeeks"]
      previous_week = rules[index - 1]["applicableWeeks"]

      if index == 0
        return false if (week[0].to_i != 1)
      elsif index <= rules.length - 2
        return false if (week[0...week.index("-")].to_i - previous_week[previous_week.index("-")+1...previous_week.length].to_i) != 1
      elsif index == rules.length - 1
        return false if (week[0...week.index("+")].to_i - previous_week[previous_week.index("-")+1...previous_week.length].to_i) != 1 || week.index("+") == nil
      end
    end

    true
  end

  def calculate_weeks(person)
    range_start_date = Date.parse(person["injuryDate"])

    # get the date of Monday of the current week
    range_end_date = Date.today - Date.today.wday + 1

    # return an integer number of weeks (assuming always rounded up, i.e. 1 - 6 days is 1 week)
    ((range_end_date.mjd -  range_start_date.mjd).to_f / 7).ceil
  end

  def select_rule(week)
    # return an edge case rule when week == 0, where no amounts are payable
    no_payable_rule = {"applicableWeeks" => 0, "percentagePayable" => 0, "overtimeIncluded" => false}
    return no_payable_rule if (week == 0)

    # return the appropriate rule when week falls into the range
    @rules.each do |rule|
      week_range = rule["applicableWeeks"]
      return rule if week_range.include?week
    end
  end

  def calculate_qualifying_wage(person, applicable_rule)
    qualifying_wage = person["normalHours"] * person["hourlyRate"]

    # add on overtime hours pay if rule states to do so
    qualifying_wage += person["overtimeHours"] * person["overtimeRate"] if applicable_rule["overtimeIncluded"]

    qualifying_wage
  end

  def calculate_payment(qualifying_wage, applicable_rule)
    qualifying_wage * applicable_rule["percentagePayable"] / 100
  end

end
