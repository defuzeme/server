#require Rails.root.join('lib', 'defuzeme', 'ruby_ext')
for path in Dir[Rails.root.join('lib', 'defuzeme', '**', '*.rb').to_s]
  require path
end

ActiveRecord::Base.include_root_in_json = false

