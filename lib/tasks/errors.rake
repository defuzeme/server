require 'find'

def qHash string
  h = 0
  string.each_byte do |b|
    h = (h << 4) + b
    if (g = (h & 0xf0000000)) != 0
      h ^= g >> 23
    end
    h &= ~g;
  end
  h
end

ERRORS_FILE = Rails.root.join('config', 'errors.yml')

namespace :errors do
  desc 'Import errors code from client software source, generating #{ERRORS_FILE}'
  task :fetch do
    path = '../client/client'
    regexp = /throw_exception\(0?x?([0-9a-f]+),.*\"(.*)\".*\)/i
    data = {}
    Find.find path do |file|
      if file =~ /.cpp$/
        i = 1
        File.open(file).each_line do |line|
          if line =~ regexp
            # fetch user code & msg
            ucode, msg = line.scan(regexp).first
            # find module name
            mod = "Base"
            mod = "#{$2.capitalize}#{$1.capitalize}" if file =~ /(core|plugin)s?\/(\w+)\//
            # fine file name
            name = File.basename file
            # compute hash code
            code = (qHash(mod) & 0xFF << 16) | (qHash(name) & 0xFF << 8) | (ucode.to_i(16) & 0xFF)
            #puts "%20s %06X (%30s:%-3d) %s" % [mod, code, name, i, msg]
            data[code] = {:module => mod, :file => name, :line => i, :msg => msg}
          end
          i += 1
        end
      end
    end
    File.open ERRORS_FILE, 'w' do |f|
      f.write data.to_yaml
    end
    puts "#{data.size} errors written to #{ERRORS_FILE}"
  end
  
  desc 'Load errors data from #{ERRORS_FILE} into database'
  task :load => :environment do
    errors = Error.all
    data = YAML::load(File.read(ERRORS_FILE))
    data.each do |code, info|
      e = Error.find_or_create_by_code info.merge(:code => code)
      errors.delete e
    end
    puts "#{data.size} errors sucessfully loaded into database"
    if not errors.empty?
      errors.each &:destroy
      puts "#{errors.size} unsused errors removed"
    end
  end
end
