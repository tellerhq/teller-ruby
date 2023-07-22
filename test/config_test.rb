require "minitest/autorun"
require "teller"

describe Teller::Config do
  let(:config) { Teller::Config }

  it "allows setting access_token" do
    config.access_token = "your_access_token"
    _(config.access_token).must_equal "your_access_token"
  end

  it "allows setting certificate using certificate=" do
    config.certificate = "test/fixtures/certificate.pem"
    _(config.certificate).must_be_kind_of OpenSSL::X509::Certificate
  end

  it "allows setting private_key using private_key =" do
    private_key_path = "test/fixtures/private_key.pem"
    File.stub(:read, "your_private_key_content") do
      private_key = config.private_key = private_key_path
      _(config.private_key).must_be_kind_of OpenSSL::PKey::EC
    end
  end

  it "allows setting multiple attributes using setup block" do
    config.setup do |conf|
      conf.access_token = "your_access_token"
      conf.certificate = "test/fixtures/certificate.pem"
      conf.private_key = "test/fixtures/private_key.pem"
    end

    _(config.access_token).must_equal "your_access_token"
    _(config.certificate).must_be_kind_of OpenSSL::X509::Certificate
    _(config.private_key).must_be_kind_of OpenSSL::PKey::EC
  end

  it "allows setting multiple attributes using setup hash" do
    config.setup(access_token: "your_access_token",
                 certificate: "test/fixtures/certificate.pem",
                 private_key: "test/fixtures/private_key.pem")

    _(config.access_token).must_equal "your_access_token"
    _(config.certificate).must_be_kind_of OpenSSL::X509::Certificate
    _(config.private_key).must_be_kind_of OpenSSL::PKey::EC
  end

  it "raises Teller::Config::Error for invalid certificate file path" do
    assert_raises(Teller::Config::Error) do
      config.certificate = "non_existent_cert.pem"
    end
  end

  it "raises Teller::Config::Error for invalid private key file path" do
    assert_raises(Teller::Config::Error) do
      config.private_key = "non_existent_key.pem"
    end
  end

  it "raises Teller::Config::Error for invalid certificate data" do
    assert_raises(Teller::Config::Error) do
      config.certificate = "test/fixtures/invalid.pem"
    end
  end

  it "raises Teller::Config::Error for invalid private key data" do
    assert_raises(Teller::Config::Error) do
      config.private_key = "test/fixtures/invalid.pem"
    end
  end

end
