# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'openssl'
require 'json'

class BitflyerClient
  def initialize(key, secret)
    @key           = key
    @secret        = secret
    @uri           = URI.parse('https://api.bitflyer.jp')
    @https         = Net::HTTP.new(@uri.host, @uri.port)
    @https.use_ssl = true
  end

  # 残高取得
  def self_balance
    @uri.path   = '/v1/me/getbalance'
    request_uri = @uri.request_uri
    timestamp   = Time.now.to_i.to_s

    header = {
      'ACCESS-KEY' => @key,
      'ACCESS-TIMESTAMP' => timestamp,
      'ACCESS-SIGN' => access_sign(request_uri, 'GET', timestamp),
    }

    response = @https.request(Net::HTTP::Get.new(request_uri, header))
    JSON.parse(response.body)
  end

  # 現在のレートを取得する
  def rate
    @uri.path  = '/v1/ticker'
    @uri.query = ''
    response   = @https.get @uri.request_uri
    JSON.parse(response.body)
  end

  private

  # ACCESS-SIGNを作る
  def access_sign(request_uri, http_method, timestamp)
    @uri.path = request_uri
    text      = timestamp + http_method + @uri.request_uri
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, text)
  end
end
