# typed: false
# frozen_string_literal: true
#
# Log SQL calls that get made to stdout along with their backtrace with formatting
#
# Usage:
# LogSql.start
#   ...
#   <code with db calls you wish to log>
#   ...
# LogSql.finish
#
# or
#
# LogSql.start do
#   ...
#   <code with db calls you wish to log>
#   ...
# end
require 'cli/ui'
module LogSql
  def sql(*args)
    trace = caller
    operation = args.first.payload[:sql].match(%r{^.+\*/ ([A-Z]+ ?[A-Z]+)}).captures.first
    sql = clean_raw(operation, args.first.payload[:sql])
    CLI::UI::StdoutRouter.enable
    CLI::UI::Frame.open(sql, color: COLOR_FORMAT[operation]) do
      Rails.backtrace_cleaner.remove_silencers!
      Rails.backtrace_cleaner.add_silencer { |line| !(line =~ %r{^(components)/}) }
      super
      puts Rails.backtrace_cleaner.clean(trace)
    end
  end
  def self.start
    ::ActiveRecord::LogSubscriber.prepend(LogSql)
    if block_given?
      yield
      finish
    end
  end
  def self.finish
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end
  private
  def clean_raw(operation, raw_text)
    case operation
    when "SELECT"
      raw_text.gsub(/^.+SELECT.+FROM `([\w_]+)`.+/, 'SELECT * FROM \1')
    when "INSERT INTO"
      raw_text.gsub(/^.+INSERT INTO `([\w_]+)`.+/, 'INSERT INTO \1')
    else
      raw_text.gsub(%r{^.+\*/ (.+)}, '\1')
    end
  end
  COLOR_FORMAT = {
    "SELECT" => :magenta,
    "SAVEPOINT" => :gray,
    "INSERT INTO" => :green,
    "RELEASE SAVEPOINT" => :gray,
    "ROLLBACK" => :red,
  }
end


