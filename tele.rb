require 'rubygems'
require 'net/ftp'
require 'fileutils'
require 'write_xlsx'



user = "drgoper"
password = "drgoper"
dragoncounter = 0
dragonas = 174
network = Array[]
problems = 0

for supercounter in 1..dragonas
  if supercounter == 141 || supercounter == 140
    #puts ":("
  else
    # noinspection RubyUnusedLocalVariable
    begin
      if supercounter <10
        novo = 'm7drg0'+supercounter.to_s
      else
        novo = 'm7drg'+supercounter.to_s
      end
      #puts novo


      #puts "Trying to connect to #{novo}"

      Timeout.timeout(0.5) do
        ftp = Net::FTP.open(novo)

        #puts "sdjahsjkdh"
        #puts "Connected to Dragon #{dragon}"
        ftp.passive = true
        ftp.login "drgoper", "drgoper"

        ftp.chdir('/opt/ltx_nic/user_data')



        directory_name = Dir.pwd+'/Inventory'
        Dir.mkdir(directory_name) unless File.exists?(directory_name)
        transformada = 'tester_history'
        localFilename = Dir.pwd+'/Inventory/Inventory_'+novo+'.txt'

        begin
          ftp.gettextfile(transformada,localFilename)
          dragoncounter = dragoncounter + 1
            #puts dragoncounter
            #puts novo
        rescue
          begin
            transformada = 'tester_history'
            ftp.gettextfile(transformada,localFilename)
          rescue

            File.delete(localFilename)
          end

        end

        ftp.close
      end
    rescue SocketError, IOError, SystemCallError, Net::FTPError, Net::FTPConnectionError, TimeoutError
      begin
        ftp = Net::FTP.open(novo.upcase)

        #puts "sdjahsjkdh"
        #puts "Connected to Dragon #{dragon}"
        ftp.passive = true
        ftp.login "drgoper", "drgoper"
        ftp.chdir('/opt/ltx_nic/user_data')


        directory_name = Dir.pwd+'/Inventory'
        Dir.mkdir(directory_name) unless File.exists?(directory_name)
        transformada = 'tester_history'
        localFilename = Dir.pwd+'/Inventory/Inventory_'+novo+'.txt'

        begin
          ftp.gettextfile(transformada,localFilename)
            #dragoncounter = dragoncounter + 1
            #puts "hola"
        rescue
          begin
            transformada = 'tester_history'
            ftp.gettextfile(transformada,localFilename)
          rescue

            File.delete(localFilename)
          end

        end

      rescue
        puts "Fails connection to #{novo}. Check network connection!!"
        #dragoncounter = dragoncounter - 1
        network[problems] = novo.to_s
        problems = problems + 1
      end

    end
  end

end


time = Time.new
guardador = Array[]
version = Array[]
item = Array[]
guardador2 = ""
version2 = 0
temp1 = ""
temp2 = ""
temp3 = ""
temp4 = ""
bandera = 0
concatenador = ""
concatenador2 = ""
contador = 2

begin
  workbook = WriteXLSX.new("Inventory_"+time.strftime("%m_%d_%Y")+'.xlsx')
rescue
  puts "Debe cerrar el arvhivo Inventory_"+time.strftime("%m_%d_%Y")+'.xlsx, para poder continuar!!'
end

worksheet = workbook.add_worksheet("Inventory by Dragon")

format = workbook.add_format
format.set_center_across
worksheet.write(0, 2, 'Current Inventory Analysis', format)
worksheet.write_blank(0, 3, format)
worksheet.write(1,0,'Tester',format)
worksheet.write(1,1,'Version',format)
worksheet.write(1,2,'Rev',format)
worksheet.write(1,3,'Serial #',format)
worksheet.write(1,4,'Item',format)

for supercounter in 1..dragonas
  if supercounter == 141 || supercounter == 140
    #puts ":("
  else
    if supercounter <10
      novo = 'm7drg0'+supercounter.to_s
    else
      novo = 'm7drg'+supercounter.to_s
    end

    localFilename = Dir.pwd+'/Inventory/Inventory_'+novo+'.txt'

    begin
      File.open(localFilename, "r") do |f|
        f.each_line do |line|
          #puts line
          #for contador in 0..tests-1
            if line.include?("RF32_BRICK")
              guardador[0] = line
              version[0] = line.index('-1259')
              item[0] = "RF32_BRICK"
             #puts line
            elsif line.include?("RFE_GEN_SGMA_6G")
              guardador[1] = temp1
              version[1] = temp2
              item[1] = "RFE_GEN_SGMA_6G_1"

              guardador[2] = line
              version[2] = line.index('-8259')
              item[2] = "RFE_GEN_SGMA_6G_2"

              temp1 = guardador[2]
              temp2 = version[2]
            elsif line.include?("RFE_GEN_SGMA_12G")
              guardador[3] = line
              version[3] = line.index('-8258')
              item[3] = "RFE_GEN_SGMA_12G"
            elsif line.include?("DIGHB")
              guardador[4] = line
              version[4] = line.index('-1616')
              item[4] = "DIGHB"
              bandera = 1
            elsif line.include?("OCTAL_VI")
              guardador[5] = line
              version[5] = line.index('-0122')
              item[5] = "OVI"
            elsif line.include?(" HCOVI")
              guardador[6] = line
              version[6] = line.index('-1014')
              item[6] = "HCOVI"
            elsif line.include?("STEPBUSII_ADAP")
              guardador[7] = line
              version[7] = line.index('-0021')
              item[7] = "SSBA"
            elsif line.include?("TH_FACFX")
              guardador[8] = line
              version[8] = line.index('-1008')
              item[8] = "FX1 Board"
            elsif line.include?("TH_TMBDFX_DIR_TMP_REFCLK")
              guardador[9] = line
              version[9] = line.index('-1110')
              item[9] = "TMBD Board"
            elsif line.include?("SWGHSB")
              guardador[10] = temp3
              version[10] = temp4
              item[10] = "SWGHSB_1"

              guardador[11] = line
              version[11] = line.index('-1157')
              item[11] = "SWGHSB_2"

              temp3 = guardador[11]
              temp4 = version[11]
            elsif line.include?("DIGHSB") and bandera == 0
              guardador[12] = line
              version[12] = line.index('-1004')
              item[12] = "DIGHSB"
                          end
          #end
        end
      end
    rescue
      #puts "no file recovered"
    end

    if bandera == 1
      guardador[12] = nil
      version[12] = nil
      item[12] = nil
    end


    for i in 0..12
      begin
        worksheet.write(contador,0,novo,format)
        worksheet.write(contador,1,guardador[i].split('')[version[i]+7],format)
        worksheet.write(contador,2,guardador[i].split('')[version[i]+10]+guardador[i].split('')[version[i]+11],format)
        worksheet.write(contador,3,guardador[i].split('')[version[i]+14]+guardador[i].split('')[version[i]+15]+guardador[i].split('')[version[i]+16]+guardador[i].split('')[version[i]+17]+guardador[i].split('')[version[i]+18]+guardador[i].split('')[version[i]+19]+guardador[i].split('')[version[i]+20]+guardador[i].split('')[version[i]+21],format)
        worksheet.write(contador,4,item[i],format)
        contador = contador + 1
      rescue

      end

    end

    end

    bandera = 0
    guardador2 = ""

  end

  #Guardador..............



begin
  workbook.close
rescue
  puts "Debe cerrar el arvhivo Inventory_"+time.strftime("%m_%d_%Y")+'.xlsx, para poder continuar!!'
end

puts ""
puts "It's all ogre now!"
FileUtils.rm_rf Dir.pwd+'/Inventory'
sleep (7)