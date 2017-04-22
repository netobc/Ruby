require 'fox16'
require 'spreadsheet'
require 'roo'
require 'excel2csv'

include Fox

class HelloWorld < FXMainWindow


  def initialize(app)
    datoek = Array[]
    minoek = Array[]
    maxoek = Array[]
    guoek = Array[]


    super(app, "Dragon Spec Converter" , :width => 600, :height => 320)
    origin = FXHorizontalFrame.new(self)
    vFrame1n = FXVerticalFrame.new(origin)
    theButton = FXButton.new(vFrame1n,"")
    theButton.tipText = "Push Me!"
    iconFile = File.open("dragon.png", "rb")
    theButton.icon = FXPNGIcon.new(app, iconFile.read)

    vFrame2n = FXVerticalFrame.new(origin)

    hFrame1 = FXHorizontalFrame.new(vFrame2n)
    chrLabel = FXLabel.new(hFrame1, "--- Search for Fast CorrSpec ---")


    # _______________________________________
    hFrameinter = FXHorizontalFrame.new(vFrame2n)
    hFrameinter2 = FXHorizontalFrame.new(vFrame2n)
    vFrameinter1 = FXHorizontalFrame.new(hFrameinter)
    vFrameinter2 = FXHorizontalFrame.new(hFrameinter)
    groupbox = FXGroupBox.new(vFrameinter1, "Folder options",  :opts => GROUPBOX_NORMAL|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y)
    radio1 = FXRadioButton.new(groupbox, "Production")
    choice = 0
    radio1.checkState = true

    radio1.connect(SEL_COMMAND) {
      radio2.checkState = false
      radio3.checkState = false
      choice = 0
      neto = Dir.entries('//testfilerclus01/Fast/Fast/EasyCorr/Specs/Production')
    }

    groupbox2 = FXGroupBox.new(vFrameinter2, "Output option",  :opts => GROUPBOX_NORMAL|FRAME_GROOVE|LAYOUT_FILL_X|LAYOUT_FILL_Y)
    radio12 = FXRadioButton.new(groupbox2, "Old DRG Spec Template")
    radio22 = FXRadioButton.new(groupbox2, "New DRG Spec Template")
    choice2 = 0
    radio1.checkState = true

    radio12.connect(SEL_COMMAND) {
      radio22.checkState = false
      choice2 = 0
    }
    radio22.connect(SEL_COMMAND) {
      radio12.checkState = false
      choice2 =1
    }


    neto = Dir.entries('//testfilerclus01/Fast/Fast/EasyCorr/Specs/Production')

    FXLabel.new(hFrameinter2, "Spec Seleccionado:")
    seletsion = FXLabel.new(hFrameinter2, "")
    hFrame2 = FXHorizontalFrame.new(vFrame2n)
    categories = FXComboBox.new(hFrame2, 40,
                                :opts => COMBOBOX_NO_REPLACE|FRAME_SUNKEN|FRAME_THICK|LAYOUT_FILL_X)
    categories.numVisible = 10
    for ssupercounter in 3..neto.length
      categories.appendItem(neto[ssupercounter])
    end
    seletsion.text = neto[categories.currentItem]



    # _______________________________________

    hFrame2 = FXHorizontalFrame.new(vFrame2n)
    copyButton = FXButton.new(hFrame2, "Seleecionar archivo!")
    buscarButton = FXButton.new(hFrame2, "Convertir archivo!")
    byeButton = FXButton.new(hFrame2, "   Exit   ")

    byeButton.connect(SEL_COMMAND) do |sender, selector, data|
      exit
    end
    copyButton.connect(SEL_COMMAND) do
      # acquireClipboard([FXWindow.stringType])
      seletsion.text = neto[categories.currentItem+3]
    end
    buscarButton.connect(SEL_COMMAND) do
      renacuajo =  neto[categories.currentItem+3]
      begin
        nuevoSpec = Spreadsheet::Workbook.new
        sheet1 = nuevoSpec.create_worksheet
        sheet1.name = renacuajo.to_s
      rescue
        puts "Cierra el archivo!!"
      end

      begin
        Spreadsheet.open('//testfilerclus01/Fast/Fast/EasyCorr/Specs/Production/'+renacuajo.to_s) do |book|
          renglon = 0
          columna = 0
          information = 0
          columnaDato = 0
          columnaMin = 0
          columnaMax = 0
          columnaGU = 0
          columnaGUL = 0
          r1 = 1
          r2 = 1
          r3 = 1
          r4 = 1
          r5 = 1
          sheet1[0,0] = "Minimum"
          sheet1[0,1] = 2
          book.worksheet(0).each do |row|
            tempo = 0
            columna = 0
            columnizador = 1
            row.each do |column|
              cell = column.to_s

              #-------------------------------------------------------------------------- Test
              if column == "Data"
                puts cell
                columnaDato = columna
                information = renglon
              end
              #-------------------------------------------------------------------------- Min
              if cell.include?("Minimum") or cell.include?("Minimun")
                puts cell
                columnaMin = columna
              end
              #-------------------------------------------------------------------------- Max
              if cell.include?("Maximum") or cell.include?("Maximun")
                puts cell
                columnaMax = columna
              end
              #-------------------------------------------------------------------------- GU
              if cell.include?("GU") or cell.include?("gu")
                puts cell
                if tempo == 0
                  columnaGU = columna
                end
                tempo = tempo + 1
                columnaGUL = columna
              end

              #---------------------------------------------------------------------------------------------------------
              if renglon > information and cell != " " and cell != nil
                if columnaDato == columna
                  # puts cell
                  datoek[r1] = cell
                  sheet1[r1,columnizador] = cell
                  columnizador = columnizador + 1
                  sheet1[r1,columnizador] = "OFFSET"
                  columnizador = columnizador + 1
                  r1 = r1 + 1

                end
                if  columnaMin == columna
                  # puts cell
                  minoek[r2] = cell
                  sheet1[r2,columnizador] = cell.to_f
                  columnizador = columnizador + 1
                  r2 = r2 + 1
                end
                if renglon > information and columnaMax == columna
                  # puts cell
                  maxoek[r3] = cell
                  sheet1[r3,columnizador] = cell.to_f
                  columnizador = columnizador + 1
                  r3 = r3 + 1
                end

              end


              #---------------------------------------------------------------------------------------------------------

              columna =  columna + 1
              # puts column
            end
            #-----------------------------------------------siguiente renglon



            renglon = renglon + 1
          end
        end
        puts datoek
        puts minoek
        puts maxoek

      rescue Exception => e
        puts "bye :("
        puts e.message

      end

      nuevoSpec.write renacuajo
      excel2csv renacuajo renacuajo.tr('xls','')+"csv"
    end

  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end

end









if __FILE__ == $0
  FXApp.new do |app|
    HelloWorld.new(app)
    app.create
    app.run
  end
end