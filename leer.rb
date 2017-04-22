require 'net/ftp'
#puts "Thys is my swamp"
neto = Dir.entries('//testfilerclus01/Credence/Programs/Released/P16_V620_M236_B49/')
fname = "Credence.txt"
somefile = File.open(fname, "w")
somefile.puts neto
somefile.close

neto = Dir.entries('//testfilerclus01/Fast/Fast/Programs-PTX/Released')
fname = "Fast.txt"
somefile = File.open(fname, "w")
somefile.puts neto
somefile.close

fname = "Dragon.txt"
somefile = File.open(fname,"w")
corr = "corrspecs_drg.txt"
newcorr = File.open(corr,"w")
strs = "strs_drg.txt"
newstr = File.open(strs,"w")



server = "m"
user = "drgoper"
password = "drgoper"
dragonas = 144
dragonas = dragonas - 1
romper = 0
ilch = Array[]

supercounter = 1
loop do

  begin

    if supercounter <10
      novo = 'm7drg0'+supercounter.to_s
    else
      novo = 'm7drg'+supercounter.to_s
    end
    #puts novo


    #puts "Trying to connect to #{novo}"

    ftp = Net::FTP.open(novo)

    #puts "sdjahsjkdh"
    #puts "Connected to Dragon #{dragon}"
    ftp.passive = true
    ftp.login user, password
    ftp.chdir('/programs/released')

    begin
      #ftp.gettextfile(transformada,localFilename)
      superneto = ftp.nlst()

      w1 = superneto.length

      for i in 0..w1-1
        if superneto[i].include?("U4")
          ftp.chdir('/programs/released/'+superneto[i])

          tiempo = ftp.nlst()
          somefile.puts superneto[i]
          somefile.puts tiempo

        end
      end


      # somefile.puts superneto
      romper = 1


    rescue
      begin
        ftp.chdir('/programs/release')
        superneto = ftp.nlst()
        w1 = superneto.length

        for i in 0..w1-1
          if superneto[i].include?("U4")
            puts superneto[i]
          end
        end
        somefile.puts superneto

      rescue
        romper = 0
        #File.delete(localFilename)
      end

    end
#-------------------------------------------------------------
    ftp.chdir('/programs/corrspecs')

    begin
      #ftp.gettextfile(transformada,localFilename)
      superneto = ftp.nlst()
      newcorr.puts superneto
      romper = 1


    rescue
      begin
        ftp.chdir('/programs/released')
        superneto = ftp.nlst()
        newcorr.puts superneto

      rescue
        romper = 0
        #File.delete(localFilename)
      end

    end

    #-------------------------------------------------------------
    ftp.chdir('/programs/str')

    begin
      #ftp.gettextfile(transformada,localFilename)
      superneto = ftp.nlst()
      newstr.puts superneto




      romper = 1


    rescue
      begin
        ftp.chdir('/programs/str')
        superneto = ftp.nlst()
        newstr.puts superneto

      rescue
        romper = 0
        #File.delete(localFilename)
      end

    end

    ftp.close
  rescue SocketError, IOError, SystemCallError, Net::FTPError, Net::FTPConnectionError, TimeoutError
    puts "Fails connection to #{novo}. Check network connection!!"
  end

  break if romper==1

end


somefile.close
newcorr.close
newstr.close
sleep(1)








str = <<END
                      _____
                   ,-'     `._
                 ,'           `.        ,-.
               ,'               \       ),.\\
     ,.       /                  \     /(  \;
    /'\\     ,o.        ,ooooo.   \  ,'  `-')
    )) )`. d8P"Y8.    ,8P"""""Y8.  `'  .--"'
   (`-'   `Y'  `Y8    dP       `'     /
    `----.(   __ `    ,' ,---.       (
           ),--.`.   (  ;,---.        )
          / \O_,' )   \  \O_,'        |
         ;  `-- ,'       `---'        |
         |    -'         `.           |
        _;    ,            )          :
     _.'|     `.:._   ,.::" `..       |
  --'   |   .'     """         `      |`.
        |  :;      :   :     _.       |`.`.-'--.
        |  ' .     :   :__.,'|/       |  \\
        `     \--.__.-'|_|_|-/        /   )
         \     \_   `--^"__,'        ,    |
         ;  `    `--^---'          ,'     |
          \  `                    /      /
           \   `    _ _          /
            \           `       /
             \           '    ,'
              `.       ,   _,'
                `-.___.---'
END
puts str

puts "It's all ogre now!"
sleep (2)











