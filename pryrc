# -*- mode: Ruby;-*-

# Backtrace that filters down Shopify call stack to things likely of interest
def bt
  caller.select do |line|
    line.include?("src/github.com/Shopify") && !line.include?("/instrumentation/")
  end
end
