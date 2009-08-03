begin
  gem 'SyslogLogger' # http://seattlerb.rubyforge.org/SyslogLogger/
  require 'syslog_logger'

  module Log4r

    # Use the SyslogLogger gem from Seattle.rb . It's a wrapper around the Syslog standard Ruby class.
    # This outputter, unlike SyslogOutputter provided by Log4r, does not set application-wide custom levels,
    # so it does not break other loggers and outputters.
    class SeattleRbSyslogOutputter < Outputter

      # There are 1 hash argument
      #
      # [<tt>:application</tt>]     syslog application, defaults to _name
      def initialize(_name, hash={})
        super(_name, hash)
        application = (hash[:application] or hash['application'] or _name)
        begin
          @syslog = SyslogLogger::new(application)
          @syslog.level = level unless level.nil?
        rescue RuntimeError
          warn "Syslog already opened by another process => No logs will be sent for the application #{application}"
          @syslog = nil
        end
      end

    private

      def canonical_log(logevent)
        @syslog.add(logevent.level, format(logevent)) if @syslog
      end
  
    end

  end
rescue LoadError
  warn 'The outputter SeattleRbSyslogOutputter won\'t be available because the SyslogLogger gem is not installed.'
end