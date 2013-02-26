module PaperclipAsync
  class Railtie < Rails::Railtie
    initializer 'paperclip_async.extend_active_record' do |app|
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send(:extend, PaperclipAsync)
      end
    end
  end
end