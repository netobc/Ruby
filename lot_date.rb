require 'net/ftp'
require 'find'
#puts "Thys is my swamp"

fname = "Dragonfiles.txt"
# somefile = File.open(fname, "w")

supercounter = 1
romper = false

loop do
  folders = Array[]
    somefile = File.open(fname, "w")

  if supercounter <10
    novo = 'M7DRG0'+supercounter.to_s
  else
    novo = 'M7DRG'+supercounter.to_s
  end




  begin
    neto = Dir.entries('//mexdragonfiler01/Dragon/'+novo)
    pdf_file_paths = []
    Find.find('//mexdragonfiler01/Dragon/'+novo) do |path|
      if path.include?("X-FILES") or path.include?(".csv") or path.include?(".std")
        # puts "X"
      else
        puts path
        # pdf_file_paths << path if path =~ /.*\.txt$/
      end

    end
    # puts pdf_file_paths
    romper = false
  rescue
    romper = true
  end
  somefile.puts neto
  somefile.close

  puts novo



  break if romper == true



  supercounter = supercounter + 1
end
