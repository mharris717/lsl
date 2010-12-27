require 'treetop'
%w(base quoting list file single_command compound_command).each do |g|
  require File.dirname(__FILE__) + "/lsl/grammars/#{g}"
end