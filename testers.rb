require 'rubygems'
require 'net/ftp'
require 'fileutils'
#puts "This is my swamp..."
user = "drgoper"
password = "drgoper"
dragoncounter = 0
dragonas = 169
network = Array[]
problems = 0

for supercounter in 1..dragonas
  if supercounter == 141 || supercounter == 140 || supercounter == 160
    #puts ":("
  else
    begin
      if supercounter <10
        novo = 'm7drg0'+supercounter.to_s
      else
        novo = 'm7drg'+supercounter.to_s
      end
      #puts novo


        #puts "Trying to connect to #{novo}"
begin
      Timeout.timeout(0.5) do
    puts novo

              ftp = Net::FTP.open(novo)

        #puts "sdjahsjkdh"
        #puts "Connected to Dragon #{dragon}"
        ftp.passive = true
        ftp.login "drgoper", "drgoper"

        ftp.chdir('/opt/ltx_nic/user_data')



      directory_name = Dir.pwd+'/diags'
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
        transformada = 'diag_log_1'
      localFilename = Dir.pwd+'/diags/diag_'+novo+'.txt'

        begin
          ftp.gettextfile(transformada,localFilename)
          dragoncounter = dragoncounter + 1
          #puts dragoncounter
          #puts novo
        rescue
          begin
            transformada = 'diag_log'
            ftp.gettextfile(transformada,localFilename)
          rescue

            File.delete(localFilename)
          end

        end

        ftp.close

            end

rescue Timeout::Error
  puts "Fails connection to #{novo}. Check network connection!!"
  #dragoncounter = dragoncounter - 1
  network[problems] = novo.to_s
  problems = problems + 1
        end
    rescue SocketError, IOError, SystemCallError, Net::FTPError, Net::FTPConnectionError
    begin
          ftp = Net::FTP.open(novo.upcase)

          #puts "sdjahsjkdh"
          #puts "Connected to Dragon #{dragon}"
          ftp.passive = true
          ftp.login "drgoper", "drgoper"
          ftp.chdir('/opt/ltx_nic/user_data')


          directory_name = Dir.pwd+'/diags'
          Dir.mkdir(directory_name) unless File.exists?(directory_name)
          transformada = 'diag_log_1'
          localFilename = Dir.pwd+'/diags/diag_'+novo+'.txt'

          begin
            ftp.gettextfile(transformada,localFilename)
            #dragoncounter = dragoncounter + 1
              #puts "hola"
          rescue
            begin
              transformada = 'diag_log'
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


pruebas = Array["inventory_ck.eva","connect_ck.eva","hss_ck.vti","fan_ck.eva","ssba_ck.eva",\
"meter_ck.eva","freq_std_cal.vti","awghsb_ck.una","awghsb_cal.una","awghsb_vrf.una","digital_ck.eva","digital_cal.eva",\
"digital_vrf.eva","tmu_ck.eva","tmu_vrf.eva","rf32_vrf.una","/ovi_ck.una","/ovi_cal.una","/ovi_vrf.una","hcovi_ck.una",\
"hcovi_cal.una","hcovi_vrf.una","dighsb_ck.una","dighsb_cal.una","dighsb_vrf.una","rf32_ck.una","rf32_cal.una"]
c=0
pc=0
otro=0
dragonas = 169
unison = 0
chafa = 0
differents = Array[]
netoek = Array[]

fname = "Diagnosticos_"+time.strftime("%m_%d_%Y")+'.csv'
somefile = File.open(fname, "w")
somefile.puts "TESTER,CALIBRATION VERIFIER"
tests = pruebas.length
contador_test = Array.new(tests,0)

for supercounter in 1..dragonas
  if supercounter == 141 or supercounter == 140
    #puts ":("
  else
    if supercounter <10
      novo = 'm7drg0'+supercounter.to_s
    else
      novo = 'm7drg'+supercounter.to_s
    end

    localFilename = Dir.pwd+'/diags/diag_'+novo+'.txt'

    begin
      File.open(localFilename, "r") do |f|
        f.each_line do |line|
          #puts line
          for contador in 0..tests-1
            if line.include?(pruebas[contador])
              if line.include?(" F ")
                #puts novo+": Failed "+pruebas[contador].delete('/')
                somefile.puts novo+","+pruebas[contador].delete('/')
                c = 1
                otro = otro + 1
                contador_test[contador]= contador_test[contador] +1
              end
            end
          end
          if line.include?("rf32_cal.una")
            if line.include?("U4.3.1")
              #puts "---------- U 4.3.1 -----------"
              #puts novo
              #puts line
              unison = unison + 1
            else
              #puts "----------otro-------------"
              if line.include?("U4.2.1")
                netoek[chafa] = "U4.2.1"
              elsif line.include?("U4.2.B2")
                netoek[chafa] = "U4.2.B2"
              elsif line.include?("U4.3.0")
                netoek[chafa] = "U4.3.0"
              elsif line.include?("U4.3.2.B1")
                netoek[chafa] = "U4.3.2.B1"
              elsif line.include?("U4.3.2.1")
                netoek[chafa] = "U4.3.2.1"
              elsif line.include?("U4.3.2")
                netoek[chafa] = "U4.3.2"
              end
              #puts novo
              #puts line
              #puts chafa
              differents[chafa] = novo.to_s
              #puts differents[chafa]
              chafa = chafa + 1

            end
          end

        end
      end
    rescue
      #puts "no file recovered"
    end
    if c==1
      c=0
      pc = pc + 1
    end
  end

end
#puts 'Testers: '+pc.to_s
somefile.puts ""
somefile.puts "TOTAL TESTERS VERIFIED,"+dragoncounter.to_s
somefile.puts 'TESTERS WITH FAILING VERIFIERS,'+pc.to_s
#puts 'Pruebas: '+otro.to_s
somefile.puts 'NUMBER OF VERIFIERS IN CAL,'+otro.to_s


somefile.puts ""
somefile.puts "CAL TESTS,FAILING COUNT"
for neto in 0..tests-1
  #puts pruebas[neto].to_s.delete('/')+': '+contador_test[neto].to_s
  somefile.puts pruebas[neto].to_s.delete('/')+','+contador_test[neto].to_s
end
somefile.puts ""
somefile.puts "TESTERS WITH NETWORK ISSUES"

for neto in 0..network.length-1
  somefile.puts network[neto].to_s
end

#puts chafa

if chafa > 0
  somefile.puts ""
  somefile.puts "WARNING!! Calibrated with old Version"
  puts "-----------------WARNING----------------------"
  puts "----------ERROR DE CALIBRACION----------------"
  somefile.puts "Tester,Unison SW"
  neto = 0
  for neto in 0..differents.length-1
    puts "Tester "+ differents[neto].to_s+" calibrada con "+netoek[neto].to_s
    somefile.puts differents[neto].to_s+","+netoek[neto].to_s
  end

end
puts "------------------------------------------------"
somefile.puts ""
somefile.puts "Unison U4.3.1,"+unison.to_s
somefile.close

puts ""
puts "It's all ogre now!"
FileUtils.rm_rf Dir.pwd+'/diags'
sleep (7)
