require 'treetop'
%w(base quoting main).each do |g|
  require File.dirname(__FILE__) + "/lsl/grammars/#{g}"
end