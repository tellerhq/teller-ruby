# Teller

The official Ruby language bindings for the Teller API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'teller'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install teller

## Usage

First configure the library for your application

```ruby
Teller::Config.setup do |c|
    c.certificate  = "/path/to/teller/cert.pem"
    c.private_key  = "/path/to/its/private_key.pem"
    c.access_token = "access-token-from-teller-connect-enrollment"
end
```

Statically configuring an access token might make sense if you're just building something using your own accounts, but it doesn't if you're building something for thousands of users, which is why you can also set your config when instantiating the client. 

```ruby
client = Teller::Client.new access_token: "test_token_ky6igyqi3qxa4"
```

During instantiation the client will take whatever static config you've made (if any), and apply config given to the constructor. Config values supplied at instantiation will override conflicting statically configured values.

Now you have your client configured you can use it to explore the API.

```ruby
account = client.accounts.first
# => #<Teller::Resource type="credit", subtype="credit_card", status="open", name="Platinum Card", links={"transactions"=>"https://api.teller.io/accounts/acc_oiin624kqjrg2mp2ea000/transactions", "self"=>"https://api.teller.io/accounts/acc_oiin624kqjrg2mp2ea000", "balances"=>"https://api.teller.io/accounts/acc_oiin624kqjrg2mp2ea000/balances"}, last_four="7857", institution={"name"=>"Security Credit Union", "id"=>"security_cu"}, id="acc_oiin624kqjrg2mp2ea000", enrollment_id="enr_oiin624rqaojse22oe000", currency="USD">

account.name
# => "Platinum Card"
```

You can easily load related resources linked to in the "links" section of the API response"

```ruby
account.balances
# =>  #<Teller::Resource links={"self"=>"https://api.teller.io/accounts/acc_oiin624kqjrg2mp2ea000/balances", "account"=>"https://api.teller.io/accounts/acc_oiin624kqjrg2mp2ea000"}, ledger="4698.93", available="204.12", account_id="acc_oiin624kqjrg2mp2ea000">

account.transactions
# => [#<Teller::Resource type="card_payment", status="pending", running_balance=nil, links={"self"=>"https://api.teller.io/accounts/acc_oiin624kqjrg2mp2ea000/transactions/txn_oj0t0gfqpvj7favgn8000", "account"=>"https://api.teller.io/accounts/acc_oiin624kqjrg2mp2ea000"}, id="txn_oj0t0gfqpvj7favgn8000", details={"processing_status"=>"complete", "counterparty"=>{"type"=>"organization", "name"=>"WILLIAMS-SONOMA"}, "category"=>"shopping"}, description="Williams-Sonoma", date="2023-07-23", amount="96.95", account_id="acc_oiin624kqjrg2mp2ea000">, ...]
```

You can also fetch arbitrary members of a collection resource

```ruby
client.accounts.get("acc_oiin624jqjrg2mp2ea000")
# =>  #<Teller::Resource type="depository", subtype="savings", status="open", name="Essential Savings", links={"transactions"=>"https://api.teller.io/accounts/acc_oiin624jqjrg2mp2ea000/transactions", "self"=>"https://api.teller.io/accounts/acc_oiin624jqjrg2mp2ea000", "details"=>"https://api.teller.io/accounts/acc_oiin624jqjrg2mp2ea000/details", "balances"=>"https://api.teller.io/accounts/acc_oiin624jqjrg2mp2ea000/balances"}, last_four="3528", institution={"name"=>"Security Credit Union", "id"=>"security_cu"}, id="acc_oiin624jqjrg2mp2ea000", enrollment_id="enr_oiin624rqaojse22oe000", currency="USD">
```

The client caches API responses after the first time you invoke a method that requests a given resource. To force the client to redo the request you can call reload

```ruby
# When called the first time the client will make a request to the Teller API
client.accounts

# On subsequent invocations locally cached data is returned
client.accounts
client.accounts
client.accounts

# Calling reload will always result in a new API request
client.accounts.reload
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tellerhq/teller-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
