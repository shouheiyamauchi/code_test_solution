require './payment_calculator'

RSpec.describe PaymentCalculator do
  describe "on #initialize" do
    it "converts the rules string range to a Ruby Range class" do
      sample_rules = [{"applicableWeeks" => "1-25"}, {"applicableWeeks" => "26+"}]
      test_payment_calculator = PaymentCalculator.new(sample_rules)

      expect(test_payment_calculator.rules).to eq([{"applicableWeeks" => 1..25}, {"applicableWeeks" => 26..Float::INFINITY}])
    end

    it "raises an ArgumentError if the applicableWeeks having missing week range(s)" do
      # missing week 26
      sample_rules = [{"applicableWeeks" => "1-25"}, {"applicableWeeks" => "27+"}]

      expect{ PaymentCalculator.new(sample_rules) }.to raise_error(ArgumentError)
    end

    it "raises an ArgumentError if the applicableWeeks have overlapping week ranges" do
      # week 25 is overlapping
      sample_rules = [{"applicableWeeks" => "1-25"}, {"applicableWeeks" => "25-30"}]

      expect{ PaymentCalculator.new(sample_rules) }.to raise_error(ArgumentError)
    end

    it "raises an ArgumentError if there is an upper limit to the week ranges" do
      # week 25 is overlapping
      sample_rules = [{"applicableWeeks" => "1-25"}]

      expect{ PaymentCalculator.new(sample_rules) }.to raise_error(ArgumentError)
    end
  end

  describe "on #calculating_weeks" do
    it "any day from the previous Sunday back to Monday is treated as a week (Monday)" do
      test_payment_calculator = PaymentCalculator.new([{"applicableWeeks" => "1+"}])

      # set a date which is Monday
      allow(Date).to receive(:today).and_return Date.new(2017,1,2)

      # one Monday before the above date
      sample_person = {"injuryDate" => "2016/12/26"}

      expect(test_payment_calculator.calculate_weeks(sample_person)).to eq(1)
    end

    it "any day from the previous Sunday back to Monday is treated as a week (Sunday)" do
      test_payment_calculator = PaymentCalculator.new([{"applicableWeeks" => "1+"}])

      # set a date which is Monday
      allow(Date).to receive(:today).and_return Date.new(2017,1,2)

      # one day before which is a Sunday
      sample_person = {"injuryDate" => "2017/1/1"}

      expect(test_payment_calculator.calculate_weeks(sample_person)).to eq(1)
    end

    it "an injury date on the same week is treated as 0 weeks" do
      test_payment_calculator = PaymentCalculator.new([{"applicableWeeks" => "1+"}])

      # set a date which is Monday
      allow(Date).to receive(:today).and_return Date.new(2017,1,2)

      # day which in the same week
      sample_person = {"injuryDate" => "2017/1/2"}

      expect(test_payment_calculator.calculate_weeks(sample_person)).to eq(0)
    end
  end

  describe "on #select_rule" do
    it "correctly selects the rule from week number" do
      test_payment_calculator = PaymentCalculator.new([{"applicableWeeks" => "1-25"}, {"applicableWeeks" => "26+"}])

      expect(test_payment_calculator.select_rule(23)).to eq({"applicableWeeks" => 1..25})
    end

    it "there are no issues with upper range when large week numbers are inputted" do
      test_payment_calculator = PaymentCalculator.new([{"applicableWeeks" => "1+"}])

      expect(test_payment_calculator.select_rule(100)).to eq({"applicableWeeks" => 1..Float::INFINITY})
    end

    it "selects the no payable rule if weeks since injury is 0" do
      test_payment_calculator = PaymentCalculator.new([{"applicableWeeks" => "1+"}])

      expect(test_payment_calculator.select_rule(0)).to eq({"applicableWeeks" => 0, "percentagePayable" => 0, "overtimeIncluded" => false})
    end
  end

  describe "on #calculate_qualifying_wage" do
    it "adds overtime wages as a part of qualifying wage" do
      test_payment_calculator = PaymentCalculator.new([{"applicableWeeks" => "1+", "overtimeIncluded" => true}])
      sample_person = {"normalHours" => 10, "hourlyRate" => 10, "overtimeHours" => 20, "overtimeRate" => 10}

      # $10 * 10 hours + $20 * 10 hours = $300
      expect(test_payment_calculator.calculate_qualifying_wage(sample_person, test_payment_calculator.rules[0])).to eq(300)
    end

    it "doesn't add overtime wages as a part of qualifying wage" do
      test_payment_calculator = PaymentCalculator.new([{"applicableWeeks" => "1+", "overtimeIncluded" => false}])
      sample_person = {"normalHours" => 10, "hourlyRate" => 10, "overtimeHours" => 20, "overtimeRate" => 10}

      # $10 * 10 hours = $100
      expect(test_payment_calculator.calculate_qualifying_wage(sample_person, test_payment_calculator.rules[0])).to eq(100)
    end
  end

  describe "on #calculate_payment" do
    it "correctly calculates the payment" do
      test_payment_calculator = PaymentCalculator.new([{"applicableWeeks" => "1+", "percentagePayable" => 50}])

      # $100 * 50% = $50
      expect(test_payment_calculator.calculate_payment(100, test_payment_calculator.rules[0])).to eq(50)
    end
  end

  describe "on #print_payments" do
    it "prints correct amounts based on rules and information" do
      # set a date which is Monday
      allow(Date).to receive(:today).and_return Date.new(2017,1,2)

      sample_people = [
                        {"name" => "Overtime Person", "hourlyRate" => 10, "overtimeRate" => 20, "normalHours" => 10, "overtimeHours" => 5, "injuryDate" => "2017/01/01" },
                        {"name" => "Noovertime Person", "hourlyRate" => 10, "overtimeRate" => 20, "normalHours" => 10, "overtimeHours" => 5, "injuryDate" => "2016/01/01" },
                        {"name" => "Nopayable Person", "hourlyRate" => 10, "overtimeRate" => 20, "normalHours" => 10, "overtimeHours" => 5, "injuryDate" => "2017/01/02" }
                      ]

      sample_rules =  [
                        {"applicableWeeks" => "1-25", "percentagePayable" => 90, "overtimeIncluded" => true},
                        {"applicableWeeks" => "26+", "percentagePayable" => 80, "overtimeIncluded" => false}
                      ]

      test_payment_calculator = PaymentCalculator.new(sample_rules)
      # manual calculation for "Overtime Person": (10 * 10 + 20 * 5) * 90% = $180.00
      # manual calculation for "Noovertime Person": (10 * 10) * 80% = $80.00
      # manual calculation for "Noovertime Person": $0.00 due to having 0 weeks since injury
      expect{
        test_payment_calculator.print_payments(sample_people)
      }.to output(
        "Overtime Person's payment is $180.00\nNoovertime Person's payment is $80.00\nNopayable Person's payment is $0.00\n"
      ).to_stdout
    end

  end
end
