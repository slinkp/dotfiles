# -*- mode: Ruby;-*-

# Backtrace that filters down Shopify call stack to things likely of interest
def bt
  caller.select do |line|
    line.include?("src/github.com/Shopify") && !line.include?("/instrumentation/")
  end
end

# Shortcuts
if defined?(PryByebug)
  # Pry.config.pager = false
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
end
