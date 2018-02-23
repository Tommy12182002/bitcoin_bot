# frozen_string_literal: true

$:.unshift File.expand_path(__dir__)

require 'bitflyer_client'

client = BitflyerClient.new(ENV['API_KEY'], ENV['API_SECRET'])
puts client.self_balance
puts client.rate
