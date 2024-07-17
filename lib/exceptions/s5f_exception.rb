# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'yaml'
require 'json'
require 'open-uri'
require 'const/vfs_const'
require 'const/acl_const'
require 'const/ssl_const'
require 'const/stat_const'

# Exceptions for S5f
module S5fLib
  # exception classes
  class Error < RuntimeError
  end

  class NullSessionIdError < Error
  end

  class NullArgumentError < Error
  end

  class NullRecordError < Error
  end

  # SpinUser is not found
  class UserNotFoundError < Error
  end

  # SpinGroup is not found
  class GroupNotFoundError < Error
  end

  # SpinGroup is not found
  class UserAuthenticationError < Error
  end

  # SpinGroup is not found
  class SessionNotFoundError < Error
  end
  # failed to delete records
  class DeleteRecordError < Error
  end
  # end of S5fLib exception classes

  # methods
  def self.exception_logger(exception, explicit)
    FileManager.rails_logger("[#{explicit ? 'EXPLICIT' : 'INEXPLICIT'}] #{exception.class}: #{exception.message}")
    # FileManager.rails_logger(exception.backtrace.join("\n"))
  end

  def self.print_exception(exception, explicit)
    if ENV['RAILS_ENV'] == 'production'
      FileManager.rails_logger("[#{explicit ? 'EXPLICIT' : 'INEXPLICIT'}] #{exception.class}: #{exception.message}")
      FileManager.rails_logger(exception.backtrace.join("\n"))
    else
      puts "[#{explicit ? 'EXPLICIT' : 'INEXPLICIT'}] #{exception.class}: #{exception.message}"
      puts exception.backtrace.join("\n")
    end
  end
  # endof self.print_exception

  def self.dump(message)
    if ENV['RAILS_ENV'] == 'production'
      FileManager.rails_logger(">> DUMP : #{message}")
    else
      puts ">> DUMP : #{message}"
    end
  end
  # endof self.print_exception
end
# end of S5fLib module
