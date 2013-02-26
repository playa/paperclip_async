require "paperclip_async/version"
require 'paperclip_async/railtie' if defined?(Rails)

module PaperclipAsync
  def paperclip_async attachment, options = {}
    raise "class #{self.name} doesn't have paperclip attachment named #{attachment}" unless attachment_definitions.keys.include?(attachment.to_sym)
    instance_eval <<-CODE, __FILE__, __LINE__ +1
      attr_accessor :post_process_#{attachment}, :#{attachment}_marked_to_process
      
      before_post_process do
        self.#{attachment}_marked_to_process= !post_process_#{attachment}
        post_process_#{attachment} ? true : false 
      end
      
      after_commit if: ->(o){ o.#{attachment}_marked_to_process && o.persisted? } do
        self.class.delay(#{options}).process_attachment(self.id, :#{attachment})
      end
    CODE
    
    unless respond_to?(:process_attachment)
      define_singleton_method :process_attachment do |id, attachment_name|
        object = find(id)
        object.send "post_process_#{attachment_name}=", true
        attachment_object = object.send(attachment_name)
        styles = attachment_object.styles.keys
        attachment_object.options[:only_process] = styles
        attachment_object.assign(attachment_object)
        unless styles.include? :original
          file = attachment_object.queued_for_write.delete(:original) 
          if file
            file.close unless file.closed?
            file.unlink if file.respond_to?(:unlink) && file.path.present? && File.exist?(file.path)
          end
        end
        attachment_object.save
      end
    end
  end
end
