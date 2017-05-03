require 'rubygems'
require 'net/ftp'
require 'net/http'
require 'tk'
require 'mechanize'


inicio = TkRoot.new do
  title  "Cargando..."
  minsize(200,100)
end
progress = Tk::Tile::Progressbar.new(inicio,:mode=>'determinate',:orient=>:horizontal,:maximum=>100)
progress.pack

#------------------------------------------------HTTP request and search------------------------------------------------
mechanize = Mechanize.new
front_page = mechanize.get('http://mexprodapps02/MonitoringTesterStatusPerformance/?Platform=Dragon')
category_links = front_page.search "//td[@class='dxgv']"

fname = "Part_numbers_tester.txt"
somefile = File.open(fname, "w")

nname = "Part_numbers_alone.txt"
thefile = File.open(nname, "w")


cont = 1
testers = 0
apendizador = []
dragona = []
partes = []
nums = 0
dragonacont = 0
maquina=" "
progreso=0
progress.value = progreso

  Thread.new do
    category_links.each do |cat_link|

      progreso = progreso +1

      fixer = cont-4
      fixer2 = cont -1
      if fixer2%17==0 && cont>1
        maquina = cat_link.text
      end
      if fixer%17==0 && cont>4

        somefile.puts maquina+"-"+cat_link.text
        thefile.puts cat_link.text
        dragona [dragonacont]= maquina
        partes [dragonacont]= cat_link.text
        dragonacont = dragonacont +1
        if testers==0
          apendizador[0]=cat_link.text
          nums =1

        else
          longi = apendizador.length
          bandera=0
          for ifon in 0..longi
            if apendizador[ifon]==cat_link.text
              bandera=1
            end
          end
          if bandera ==0
            apendizador[nums]=cat_link.text

            neto = (progreso*100)/category_links.length
            puts neto
            progress.value = neto
            nums=nums+1
          end

        end

        testers=testers+1
      end
      cont=cont+1

    end

    neto =100
    puts neto
    progress.value = neto
    Tk.exit
  end
  Tk.mainloop

thefile.close
somefile.close


#-------------------------------------------------Transform File Retriever----------------------------------------------
def transformacion (dragona, partes)
  server = "m"
  user = "drgoper"
  password = "drgoper"
  numparte = "13702_18_A1"
  dragonas = dragona.length
  dragonas = dragonas - 1


    for supercounter in 0..dragonas

      begin

        novo =server+ dragona[supercounter].downcase

        numparte = partes [supercounter]

        numparte.slice!(0,4)

        #puts "Trying to connect to #{novo}"

        ftp = Net::FTP.open(novo)

        #puts "Connected to Dragon #{dragon}"
        ftp.passive = true
        ftp.login user, password
        ftp.chdir('/var/home/resource/transform_file')

        localFilename = 'C:/Users/delatre/Desktop/Transformers/'+numparte+'.'+novo+'.cf'
        transformada = numparte+'.'+novo+'.cf'

        begin
          ftp.gettextfile(transformada,localFilename)
        rescue
          begin
            transformada = numparte+'.'+novo.upcase+'.cf'
            ftp.gettextfile(transformada,localFilename)
          rescue

          File.delete(localFilename)
          end

        end

        ftp.close

      rescue SocketError, IOError, SystemCallError, Net::FTPError, Net::FTPConnectionError, TimeoutError
        puts "Fails connection to #{novo}. Check network connection!!"
      end
    end
  puts "Finished"
  #Tk.exit
end
#---------------------------------------------individual transformers---------------------------------------------------
def transfindividual (dragona)
  server = "m"
  user = "drgoper"
  password = "drgoper"
  dragonas = dragona.length
  dragonas = dragonas - 1

  numparte = $names[$popi.curselection[0]]

  numparte.slice!(0,4)

  time = Time.new

  for supercounter in 0..dragonas

    begin

      novo =server+ dragona[supercounter].downcase



      #puts "Trying to connect to #{novo}"

      ftp = Net::FTP.open(novo)

      #puts "Connected to Dragon #{dragon}"
      ftp.passive = true
      ftp.login user, password
      ftp.chdir('/var/home/resource/transform_file')

      directory_name = 'C:/Users/delatre/Desktop/Transformers/'+time.strftime("%m-%d-%Y")+'-'+numparte
      Dir.mkdir(directory_name) unless File.exists?(directory_name)

      localFilename = directory_name+'/'+numparte+'.'+novo+'.cf'
      transformada = numparte+'.'+novo+'.cf'

      begin
        ftp.gettextfile(transformada,localFilename)
      rescue
        begin
          transformada = numparte+'.'+novo.upcase+'.cf'
          ftp.gettextfile(transformada,localFilename)
        rescue
          File.delete(localFilename)
        end

      end

      ftp.close

    rescue SocketError, IOError, SystemCallError, Net::FTPError, Net::FTPConnectionError, TimeoutError
      puts "Fails connection to #{novo}. Check network connection!!"
    end
  end
  puts "Finished"
  #Tk.exit
end



#--------------------------------------------------productioner---------------------------------------------------------
def productioner(dragona,partes)
  server = "m"
  user = "drgoper"
  password = "drgoper"
  dragonas = dragona.length
  dragonas = dragonas - 1

  numparte = $names[$popi.curselection[0]]



  numparte.slice!(0,4)

  time = Time.new

  caracol = "DRG_"+numparte

  for supercounter in 0..dragonas

    if partes[supercounter] == caracol
      begin

        novo =server+ dragona[supercounter].downcase



        #puts "Trying to connect to #{novo}"

        ftp = Net::FTP.open(novo)

        #puts "Connected to Dragon #{dragon}"
        ftp.passive = true
        ftp.login user, password
        ftp.chdir('/var/home/resource/transform_file')

        directory_name = 'C:/Users/delatre/Desktop/Transformers/'+time.strftime("%m-%d-%Y")+'-'+numparte+"-PROD"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)

        localFilename = directory_name+'/'+numparte+'.'+novo+'.cf'
        transformada = numparte+'.'+novo+'.cf'

        begin
          ftp.gettextfile(transformada,localFilename)
        rescue
          begin
            transformada = numparte+'.'+novo.upcase+'.cf'
            ftp.gettextfile(transformada,localFilename)
          rescue
            File.delete(localFilename)
          end

        end

        ftp.close

      rescue SocketError, IOError, SystemCallError, Net::FTPError, Net::FTPConnectionError, TimeoutError
        puts "Fails connection to #{novo}. Check network connection!!"
      end
    end

  end
  puts "Finished"
  #Tk.exit
end

#--------------------------------------------------individualizer---------------------------------------------------------
def individualizer(dragona,partes,esta)
  server = "m"
  user = "drgoper"
  password = "drgoper"
  dragonas = dragona.length
  dragonas = dragonas - 1

  numparte = esta

  numparte.slice!(0,4)

  time = Time.new

  caracol = "DRG_"+numparte

  for supercounter in 0..dragonas
      begin

        novo =server+ dragona[supercounter].downcase



        #puts "Trying to connect to #{novo}"

        ftp = Net::FTP.open(novo)

        #puts "Connected to Dragon #{dragon}"
        ftp.passive = true
        ftp.login user, password
        ftp.chdir('/var/home/resource/transform_file')

        directory_name = 'C:/Users/delatre/Desktop/Transformers/'+time.strftime("%m-%d-%Y")+'-'+numparte+"-PROD"
        Dir.mkdir(directory_name) unless File.exists?(directory_name)

        localFilename = directory_name+'/'+numparte+'.'+novo+'.cf'
        transformada = numparte+'.'+novo+'.cf'

        begin
          ftp.gettextfile(transformada,localFilename)
        rescue
          begin
            transformada = numparte+'.'+novo.upcase+'.cf'
            ftp.gettextfile(transformada,localFilename)
          rescue
            File.delete(localFilename)
          end

        end

        ftp.close

      rescue SocketError, IOError, SystemCallError, Net::FTPError, Net::FTPConnectionError, TimeoutError
        puts "Fails connection to #{novo}. Check network connection!!"
      end
  end
  puts "Finished"
  #Tk.exit
end
#------------------------------------------------TK Dialog Box----------------------------------------------------------
  Tk.restart

  root = TkRoot.new do
    title  "Transformer Analyzer 3000"

    minsize(420,230)
  end


  $names = apendizador
  $partnumber = TkVariable.new($names)

  $maquinotas = dragona
  $testeres = TkVariable.new($maquinotas)


  TkLabel.new(root) do
    text 'Production Testers: '+testers.to_s
    #pack('padx'=>10, 'pady'=>10, 'side'=>'left')
    place('x' => 30, 'y' => 185)
  end

  TkLabel.new(root) do
    text 'Manual search:'
    #pack('padx'=>10, 'pady'=>10, 'side'=>'left')
    place('x' => 218, 'y' => 50)
  end



  entry1 = TkEntry.new(root) do

    place('height' => 25,
          'width'  => 140,
          'x'      => 220,
          'y'      => 70)
  end


getting = TkButton.new(root) do
  text "Get!"
  height "1"
  width "4"
  borderwidth 2
  state "normal"
  font TkFont.new('arial 9')
  foreground  "black"
  relief      "groove"
  #pack("side" => "right",  "padx"=> "20", "pady"=> "50")
  #grid('row'=>1, 'column'=>3)
  place('x' => 360, 'y' => 70)
end


variable1 = TkVariable.new
entry1.textvariable = variable1
variable1.value = "DRG_13702_18_A1"

getting.command proc {
  begin
    individualizer(dragona,partes,variable1.value)
  rescue
    popo(1)
  end
  #label.text = "The result is: #{result}"--------------------------------------------------------*
}




  #TkLabel.new(root) do
   # text 'Dragon: '
   # place('x' => 220, 'y' => 50)
  #end
  #country = Tk::Tile::Combobox.new(root)do
    #  values $maquinotas
     # textvariable 'Dragons'
      #place('width' => 80,'x' => 270, 'y' => 50)
  #end

  TkLabel.new(root) do
    text 'Seleccionar número de parte'
    #pack('padx'=>10, 'pady'=>10, 'side'=>'left')
    place('x' => 20, 'y' => 5)
  end



  list = TkListbox.new(root) do
    listvariable $partnumber
    pack('fill' => 'x')
    selectmode 'single'
    place('height' => 150,'width' => 170,'x' => 10,'y' => 30)
    #grid('row'=>2, 'column'=>0)
  end

  $popi = list
  $individrag = dragona

def popo (a)

  if a == 0
    puts $names[$popi.curselection[0]]
  end

end
TkButton.new(root) do
  text "Get this on All Testers"
  height "1"
  width "24"
  borderwidth 2
  state "normal"
  font TkFont.new('arial 9')
  foreground  "black"
  relief      "groove"
  command (proc{begin transfindividual (dragona) rescue popo(1) end})
  #pack("side" => "right",  "padx"=> "20", "pady"=> "50")
  #grid('row'=>1, 'column'=>3)
  place('x' => 220, 'y' => 100)
end

TkButton.new(root) do
  text "Get only on Production"
  height "1"
  width "24"
  borderwidth 2
  state "normal"
  font TkFont.new('arial 9')
  foreground  "black"
  relief      "groove"
  command (proc { begin productioner(dragona,partes) rescue popo(1) end})
  #pack("side" => "right",  "padx"=> "20", "pady"=> "50")
  #grid('row'=>1, 'column'=>3)
  place('x' => 220, 'y' => 130)
end


TkButton.new(root) do
  text "Get Running Transform Files"
  height "1"
  width "24"
  borderwidth 2
  state "normal"
  font TkFont.new('arial 9')
  foreground  "black"
  relief      "groove"
  command (proc {transformacion(dragona, partes)})
  #pack("side" => "right",  "padx"=> "20", "pady"=> "30")
  #grid('row'=>2, 'column'=>3)
  place('x' => 220, 'y' => 160)
end

  $popi.bind '<ListboxSelect>', proc{popo(1)}



  scroll = TkScrollbar.new(root) do
    orient 'vertical'
    place('height' => 150, 'x' => 180, 'y'=> 30)
    #grid('row'=>2, 'column'=>0)
  end
  list.yscrollcommand(proc { |*args|
    scroll.set(*args)
  })
  scroll.command(proc { |*args|
    list.yview(*args)
  })



Tk.mainloop




