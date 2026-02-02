# frozen_string_literal: true

# WORKAROUND: Fix for mysterious "undefined method '<' for nil" error in Puma::Request#fast_write_str
# The error occurs at `while n < byte_size`, implying `n` is nil.
# This patch restores the original logic of fast_write_str, ensuring `n` is properly initialized.

# Ensure Puma::Request is loaded if we are running under Puma or if Puma is available
begin
  require 'puma'
  # Try to load Request specifically if it's available as a file
  require 'puma/request'
rescue LoadError
  # Puma not present or file not found, skip patch
end

if defined?(Puma::Request)
  Puma::Request.module_eval do
    # Redefine fast_write_str to ensure code integrity
    def fast_write_str(socket, str)
      n = 0
      byte_size = str.bytesize

      # Paranoia: Ensure n is not nil (though n=0 above should guarantee it)
      n ||= 0 

      while n < byte_size
        begin
          n += socket.write_nonblock(n.zero? ? str : str.byteslice(n..-1))
        rescue Errno::EAGAIN, Errno::EWOULDBLOCK
          # Use explicit Constant paths to match Puma::Request context
          timeout = defined?(Puma::Const::WRITE_TIMEOUT) ? Puma::Const::WRITE_TIMEOUT : 10
          unless socket.wait_writable(timeout)
            raise Puma::ConnectionError, (defined?(SOCKET_WRITE_ERR_MSG) ? SOCKET_WRITE_ERR_MSG : "Socket timeout writing data")
          end
          retry
        rescue Errno::EPIPE, SystemCallError, IOError
          raise Puma::ConnectionError, (defined?(SOCKET_WRITE_ERR_MSG) ? SOCKET_WRITE_ERR_MSG : "Socket timeout writing data")
        end
      end
    end
  end
  
  # Log to stdout so we can see it in the dev logs
  puts "[PumaPatch] Successfully applied fix for Puma::Request#fast_write_str"
  Rails.logger.info "[PumaPatch] Successfully applied fix for Puma::Request#fast_write_str" if defined?(Rails)
else
  # Only log if we are likely in a server context but failed to find Puma
  if defined?(Rails::Server) || $0.include?('puma')
    puts "[PumaPatch] Puma::Request is NOT defined, patch skipped."
  end
end
