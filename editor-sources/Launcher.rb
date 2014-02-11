=begin
 Event Extender 5
 Custom Editor
 ===============================================================================
 http://www.biloucorp.com
 ===============================================================================
 By Grim
 Thanks to Zeus81
=end
#--------------------------------------------------------------------------
# * Importation
#--------------------------------------------------------------------------
EMPTY = "x\x9C\u{3 0 0 0 0 1}"
$EDITOR = true
Graphics.resize_screen(640, 480)
load_data("../Data/Scripts.rvdata2").each do |script| 
  unless script[2] == EMPTY
    eval(Zlib::Inflate.inflate(script[2]))
  end
end