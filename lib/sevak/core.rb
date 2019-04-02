module Sevak
  module Core
    def connection
      attempt = 0
      begin
        if attempt < 10
          host = config.host.kind_of?(Array) ? config.host : [config.host]
          @conn = Bunny.new(
            hosts: host,
            port: config.port,
            username: config.user,
            password: config.password)
          @conn.start
          @conn
        end
      rescue Bunny::TCPConnectionFailedForAllHosts => e
        attempt += 1
        sleep(0.1)
        retry
      rescue Bunny::TCPConnectionFailed => e
        attempt += 1
        sleep(0.1)
        retry
      end
    end

    def log(data)
        @logger ||= ::Sevak.get_logger
        @logger.info(data.inspect)
    end

    def config
      ::Sevak.config
    end
  end
end
