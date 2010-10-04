require "config/environment"

MODEL_DIR   = File.join(Rails.root, "app/models")
FIXTURE_DIR = File.join(Rails.root, "test/fixtures")

module AnnotateModels

  PREFIX = "== Schema Information"

  # Use the column information in an ActiveRecord class
  # to create a comment block containing a line for
  # each column. The line contains the column name,
  # the type (and length), and any optional attributes
  def self.get_schema_info(klass, header)
    info = "# #{header}\n#\n"
    info << "# Table name: #{klass.table_name}\n#\n"
    
    max_size = klass.column_names.collect{|name| name.size}.max + 1
    klass.columns.sort { |a, b| a.name <=> b.name }.each do |col|
      attrs = []
      attrs << "default(#{col.default})" if col.default
      attrs << "not null" unless col.null
      attrs << "primary key" if col.name == klass.primary_key

      col_type = col.type.to_s
      if col_type == "decimal"
        col_type << "(#{col.precision}, #{col.scale})"
      else
        col_type << "(#{col.limit})" if col.limit
      end 
      info << sprintf("#  %-#{max_size}.#{max_size}s:%-13.13s %s", col.name, col_type, attrs.join(", ")).rstrip + "\n"
    end

    info << "#\n\n"
  end

  # Add a schema block to a file. If the file already contains
  # a schema info block (a comment starting
  # with "Schema as of ..."), remove it first.

  def self.annotate_one_file(file_name, info_block)
    if File.exist?(file_name)
      content = File.read(file_name)

      # Remove Encoding block
      content.sub! /(^|\n+)(#\s+encoding:\s*.*?)\n+/ do
        $1.present? ? "\n" : ''
      end
      encoding = $2 ? "#{$2}\n\n" : ''

      # Remove old schema info
      content.sub!(/^# #{PREFIX}.*?\n(#.*\n)*\n/, '')

      # Write it back
      File.open(file_name, "w") { |f| f.puts encoding + info_block + content }
    end
  end
  
  # Given the name of an ActiveRecord class, create a schema
  # info block (basically a comment containing information
  # on the columns and their types) and put it at the front
  # of the model and fixture source files.

  def self.annotate(klass, header)
    info = get_schema_info(klass, header)
    
    model_file_name = File.join(MODEL_DIR, klass.name.underscore + ".rb")
    annotate_one_file(model_file_name, info)

    fixture_file_name = File.join(FIXTURE_DIR, klass.table_name + ".yml")
    annotate_one_file(fixture_file_name, info)
  end

  # Return a list of the model files to annotate. If we have 
  # command line arguments, they're assumed to be either
  # the underscore or CamelCase versions of model names.
  # Otherwise we take all the model files in the 
  # app/models directory.
  def self.get_model_names
    models = ARGV.dup
    models.shift
    
    if models.empty?
      Dir.chdir(MODEL_DIR) do 
        models = Dir["**/*.rb"]
      end
    end
    models
  end

  # We're passed a name of things that might be 
  # ActiveRecord models. If we can find the class, and
  # if its a subclass of ActiveRecord::Base,
  # then pas it to the associated block

  def self.do_annotations
    header = PREFIX.dup
    version = ActiveRecord::Migrator.current_version rescue 0
    
    self.get_model_names.each do |m|
      class_name = m.sub(/\.rb$/,'').camelize
      begin
        klass = class_name.split('::').inject(Object){ |klass,part| klass.const_get(part) }
        if klass < ActiveRecord::Base && !klass.abstract_class?
          puts "Annotating #{class_name}"
          self.annotate(klass, header)
        else
          puts "Skipping #{class_name}"
        end
      #rescue Exception => e
      #  puts "Unable to annotate #{class_name}: #{e.message}"
      end
      
    end
  end
end
