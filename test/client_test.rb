require "test_helper"

describe Teller::Config do
  let(:client) { Teller::Client.new(access_token: "test_token_ky6igyqi3qxa4") }

  before do
    stub_request(:get, /^https:\/\/api.teller.io\//).
      with(basic_auth: ["test_token_ky6igyqi3qxa4", ""]).
      to_return do |request|
        file = request.uri.path == "/" ? "root" : request.uri.path 
        File.open(File.join "test/fixtures/json", "#{file}.json")
      end
  end

  it "use access tokens for bearer auth" do
    client.accounts

    assert_requested :get, "https://api.teller.io/accounts", 
      headers: {'Authorization'=>'Basic dGVzdF90b2tlbl9reTZpZ3lxaTNxeGE0Og=='}
  end

  it "fetches each uri once and caches the response" do
    client.accounts
    client.accounts

    assert_requested :get, "https://api.teller.io/accounts", times: 1
  end

  it "reloads uris when required to" do
    client.accounts
    client.accounts.reload

    assert_requested :get, "https://api.teller.io/accounts", times: 2
  end

  it "maps response properties to object instance methods" do
    json = JSON.parse(File.read("test/fixtures/json/raw_account.json"))
    account = client.accounts.first

    json.delete "links"

    json.each do |k, v|
      _(account.send k).must_equal v
    end 
  end

  it "maps links to object instance methods and loads them on demand" do
    json = JSON.parse(File.read("test/fixtures/json/raw_account.json"))
    account = client.accounts.first

    json["links"].each do |k, v|
      account.send k
    end

    assert_requested :get, "https://api.teller.io/accounts/acc_oiin624kqjrg2mp2ea000", times: 1
    assert_requested :get, "https://api.teller.io/accounts/acc_oiin624kqjrg2mp2ea000/transactions", times: 1
    assert_requested :get, "https://api.teller.io/accounts/acc_oiin624kqjrg2mp2ea000/balances", times: 1
  end

  it "can fetch arbitrary members of a resource collection" do
    client.accounts.get("acc_oiin624kqjrg2mp2ea000")
  
    assert_requested :get, "https://api.teller.io/accounts/acc_oiin624kqjrg2mp2ea000", times: 1
  end
end