# frozen_string_literal: true

# WORKAROUND: Fix for Lookbook 2.3 with ViewComponent 4.2+ on Rails 8.1
# The Issue: ActionView::OutputBuffer instances appear to be corrupted (nil @raw_buffer),
# causing "undefined method '<<' for nil" inside safe_concat or <<.
# This global patch makes OutputBuffer self-repairing AND prevents corruption in with_buffer.
#
# Context: https://github.com/ViewComponent/view_component/issues/2157

Rails.application.config.to_prepare do
  if defined?(ActionView::OutputBuffer)
    ActionView::OutputBuffer.class_eval do
      # Patch safe_concat
      unless method_defined?(:_lookbook_fix_safe_concat)
        alias_method :_lookbook_fix_safe_concat, :safe_concat
        
        def safe_concat(value)
          if @raw_buffer.nil?
            # Self-repair corrupted buffer
            @raw_buffer = +""
            @raw_buffer.force_encoding(Encoding::UTF_8)
          end
          _lookbook_fix_safe_concat(value)
        end
        
        # Re-apply alias to ensure it uses the patched method
        alias_method :safe_append=, :safe_concat
      end

      # Patch <<
      unless method_defined?(:_lookbook_fix_concat)
        alias_method :_lookbook_fix_concat, :<<
        
        def <<(value)
          if @raw_buffer.nil?
            # Self-repair corrupted buffer
            @raw_buffer = +""
            @raw_buffer.force_encoding(Encoding::UTF_8)
          end
          _lookbook_fix_concat(value)
        end
        
        # Re-apply aliases
        alias_method :concat, :<<
        alias_method :append=, :<<
      end

      # Patch with_buffer (Root cause fix for ViewComponent)
      # This prevents the buffer from becoming nil in the first place
      def with_buffer(buf = nil)
        # Ensure current buffer is valid before swapping
        @raw_buffer ||= +""
        @raw_buffer.force_encoding(Encoding::UTF_8) if @raw_buffer.encoding != Encoding::UTF_8
        
        new_buffer = buf || +""
        old_buffer, @raw_buffer = @raw_buffer, new_buffer
        yield
        new_buffer
      ensure
        # Ensure we restore a valid buffer, even if old_buffer was somehow nil
        @raw_buffer = old_buffer || +""
        @raw_buffer.force_encoding(Encoding::UTF_8) if @raw_buffer.encoding != Encoding::UTF_8
      end
    end
  end
end
