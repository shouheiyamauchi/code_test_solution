require 'json'
require './payment_calculator'

rules_json = JSON.parse(File.read('rules_v2.json'))["rules"]
people_json = JSON.parse(File.read('people.json'))["people"]

payment_calculator = PaymentCalculator.new(rules_json)
payment_calculator.print_payments(people_json)
