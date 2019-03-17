class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # reload log
  class ActiveSupport::Logger::SimpleFormatter
    def call(severity, time, name, msg)
      sprintf("%s %s %s [%s] %s - %s\n", time.strftime("%Y-%m-%d %H:%M:%S"), `hostname`.to_s.gsub("\n", ""), "Hulk", severity, Process.pid, msg)
    end
  end

  def get_logger(log_name)
    ActiveSupport::TaggedLogging.new(Logger.new("./log/" + log_name))
  end
end
