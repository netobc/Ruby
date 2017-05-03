require 'net/telnet'

time = Time.new
puts time.hour.to_s+":"+time.min.to_s
fname = "memo.csv"
somefile = File.open(fname, "w")
somefile.puts "Tester, Server Time,Tester Time"
for i in 1..207

  if i<10
    neto = "0"+i.to_s
  else
    neto = i.to_s
  end
  begin
    time =  Time.new
    puts "Comenzando con m7drg#{neto}"

    pipo = "m7drg#{neto}," + time.hour.to_s + ":" + time.min.to_s + ":" +  time.sec.to_s + ","
    localhost = Net::Telnet::new("Host" => "m7drg"+neto,
                                 "Timeout" => 20,
                                 "Prompt" => /[$%#>] \z/n)
    localhost.login("drgoper", "drgoper") { |c| print c }
    su_prompt = "Password: "
    puts "******************************"
    puts "String antes de finalizar: #{pipo}"
    puts "******************************"
    localhost.cmd("date +'%H:%M:%S'") { |c| print c
    c = c.to_s
    c.sub! "date +'%H:%M:%S'", ""
    c.sub! " ", ""
    c.sub! ",", ""
    c.sub! "drgoper@m7drg#{neto}>", ""
    c.sub! "drgoper@M7DRG#{neto}>", ""
    c.sub! "[drgoper@M7DRG#{neto}~]$", ""
    c.delete!("\n")
    if !c.nil?
      c.sub! "date +'%H:%M:%S'", ""
      puts "Fecha de la tester: #{c}"
      pipo = pipo + c
    end

    }

    localhost.cmd("exit" )
    localhost.close
    puts "******************************"
    puts "String que se guarda en CSV : #{pipo}"
    puts "******************************"
    somefile.puts pipo
  rescue Exception => e
    puts e.message
    puts "******************************"
    puts "Failed connection to m7drg"+neto
    puts "******************************"
  end

end

somefile.close
