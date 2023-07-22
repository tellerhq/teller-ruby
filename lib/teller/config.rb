require 'openssl'

module Teller::Config
  class Error < StandardError; end

  attr_accessor :access_token, :certificate, :private_key

  def setup(opts = {})
    if block_given?
      yield(self)
    else
      opts.each { |k, v| send(:"#{k}=", v) }
    end
  end

  def certificate=(path)
    begin
      File.open(path, 'r') do |file|
        @certificate = OpenSSL::X509::Certificate.new(file)
      end
    rescue Errno::ENOENT
      raise Error, "Certificate file not found: #{path}"
    rescue OpenSSL::X509::CertificateError
      raise Error, "Invalid certificate data in file: #{path}"
    end
  end

  def private_key=(path)
    begin
      File.open(path, 'r') do |file|
        @private_key = OpenSSL::PKey.read(file, nil)
      end
    rescue Errno::ENOENT
      raise Error, "Private key file not found: #{path}"
    rescue OpenSSL::PKey::PKeyError
      raise Error, "Invalid private key data in file: #{path}"
    end
  end

  extend self
end
