# http://stackoverflow.com/questions/4397412/read-edit-and-write-a-text-file-line-wise-using-ruby
def getConfig(filename)
  config =Hash.new()

  File.open(filename, "r+") do |f|
    f.each do |line|
      begin
        first_index = line.index('=')
        kv = []
        kv[0] = line[0..first_index-1]
        kv[1] = line[first_index+1..line.length]
        #puts "#{kv[0]} = #{kv[1]}"
        config[kv[0]]=kv[1]
      rescue 
      end

    end

  end
  return config
end




def replaceVariables(rel_path, config)
  files = Dir.glob(File.dirname(__FILE__)+rel_path)

  files.each do |f_name|
    puts "replacing values in #{f_name}"
    File.open(f_name, "r+") do |f|

      out = ""
      f.each do |line|
        if line.start_with?('${')
          #puts line
          variable_key = line[0..line.index('}')]
          if config.key?(variable_key)
            # puts line
            # puts "#{variable_key}     #{config[variable_key]}"
            out <<  line.gsub(line, "#{variable_key}     #{config[variable_key]}")
          else
            out << line
          end
        else
          out << line
        end
      end
    
      f.pos = 0
      f.print out
      f.truncate(f.pos)
    end
  end
end

config = getConfig("config.txt")
replaceVariables("/page-object/*.txt", config)
replaceVariables("/common/*.txt", config)
replaceVariables("/*test.txt", config)

