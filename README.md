# Solution Code

## Approaches Taken

- Created a PaymentCalculator (payment_calculator.rb) class which initializes an object taking in an array of "rules" as an argument
- The PaymentCalculator class ensures that the week ranges included in the "rules" array will cover all possible weeks, otherwise it will raise an ArgmentError
- Running the print_payments method on the initialized object using an array of "people" as an argument will print out to the terminal all employees' payments for this week
- The PaymentCalculator class was structured to be reusable for different people and rules as long as the data are in the same format
- An assumption was made that "one week" includes up until Sunday from Monday of the previous week
- print_payments.rb is a sample code demonstrating the PaymentCalculator in action using the supplied people.json file and a slightly tweaked rules.json file (see below)
- There were 2 overlapping weeks in the original rules.json on lines 2 and 6, so an updated version, rules_v2.json was used for the sample

```
ruby print_payments.rb
```

## Testing

Rspec was used for testing. If you do not have Rspec installed, please run the following command to install it on your computer:

```
$ gem install rspec
```

After cloning the repo, please run the command below to run the tests:

```
$ rspec payment_calculator_spec.rb --color --format doc
```
