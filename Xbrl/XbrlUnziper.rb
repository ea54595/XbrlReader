require 'rubygems'
require 'zip/zip'
require 'find'
require 'pry'

class XbrlUnziper
  def slef.unzip(base_path)
    zip_list = search_zip(base_path)
    zip_list.each do |zip_path|
       extract zip_path,create_dest(zip_path)
    end
  end

  def extract(zip_file, dest)
    begin
      dest = dest +"/" + (zip_file.split(/\//).last).delete(".zip")
      Zip::ZipFile.foreach(zip_file) do |entry|
        #binding.pry
        if entry.file?
          FileUtils.makedirs("#{dest}/#{File.dirname(entry.name)}")
          entry.get_input_stream do |io|
            open("#{dest}/#{entry.name}","w+") do |w|
              while (bytes = io.read(1024))
                w.write bytes
              end
            end
          end
        else
          FileUtils.makedirs("#{dest}/#{entry.name}")
        end
      end
    rescue Exception => e
      puts e.message
    end
    puts "#{zip_file} unzip complete!"
  end
  private :extract

  def create_dest(zip_path)
    zip_path.gsub(zip_path.split(/\//).last, "")
  end
  private :create_dest

  def search_zip(base_path)
    zip_file_list = [] 
    Find.find(base_path) do |zip_path|
      if zip_path.match(/.zip/) != nil
        zip_file_list << zip_path
      end
    end
    zip_file_list
  end
  private :search_zip
end