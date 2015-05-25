require 'vigenere'
require 'caesar'
require 'i18n'
require 'awesome_print'

I18n.enforce_available_locales = false  

class Numeric
  def percent_of(n)
    self.to_f / n.to_f * 100.0
  end
end

$output=""

$freq = {
    "A" => 8.167,
    "B" => 1.492,
    "C" => 2.782,
    "D" => 4.253,
    "E" => 12.702,
    "F" => 2.228,
    "G" => 2.015,
    "H" => 6.094,
    "I" => 6.966,
    "J" => 0.153,
    "K" => 0.772,
    "L" => 4.025,
    "M" => 2.406,
    "N" => 6.749,
    "O" => 7.507,
    "P" => 1.929,
    "Q" => 0.095,
    "R" => 5.987,
    "S" => 6.327,
    "T" => 9.056,
    "U" => 2.758,
    "V" => 0.978,
    "W" => 2.360,
    "X" => 0.150,
    "Y" => 1.974,
    "Z" => 0.074
}

def descobreLetra (texto)
    tamTexto = texto.size
    freqHash = {}
    ("A".."Z").each do |caesar|
        freqHash[caesar] = {
            "A" => 0.0,
            "B" => 0.0,
            "C" => 0.0,
            "D" => 0.0,
            "E" => 0.0,
            "F" => 0.0,
            "G" => 0.0,
            "H" => 0.0,
            "I" => 0.0,
            "J" => 0.0,
            "K" => 0.0,
            "L" => 0.0,
            "M" => 0.0,
            "N" => 0.0,
            "O" => 0.0,
            "P" => 0.0,
            "Q" => 0.0,
            "R" => 0.0,
            "S" => 0.0,
            "T" => 0.0,
            "U" => 0.0,
            "V" => 0.0,
            "W" => 0.0,
            "X" => 0.0,
            "Y" => 0.0,
            "Z" => 0.0
        }
        Caesar.decode(caesar,texto).each_char do |c|
            freqHash[caesar][c]+=1
        end
        freqHash[caesar].each do |chave,valor|
            $output=
            freqHash[caesar][chave] = ($freq[chave] - valor.percent_of(tamTexto)).abs
        end
        freqHash[caesar] = freqHash[caesar].values.reduce(:+)
    end
    # ap freqHash
    return freqHash.invert[freqHash.values.min]
end

def normalizaTexto (texto)
    return I18n.transliterate(texto).gsub(/\n/,'').gsub(/[^A-Za-z]/, '').upcase
end

def geraArrayTextosDeslocados (textoCifrado, tamChave)
    count = 0   # contador que itera pelo texto
    textoDeslocado = Array.new(tamChave) { |e| e = "" }
    textoCifrado.each_char do |c|
        textoDeslocado[count] << c
        count = (count+=1)%tamChave
    end
    return textoDeslocado
end

def descobrePalavra(textoDeslocado)
    chaveDescifrada=""
    puts " \e[1;36;49m A Palavra Chave é: \e[0m "
    print "  "
    textoDeslocado.each do |texto|
        letra = descobreLetra(texto)
        print "\e[1;46;49m   " + letra + "\e[0m"
        chaveDescifrada << descobreLetra(texto)
    end
    puts
end

#main {
    chave=ARGV[0]
    tamChave=chave.size
    textoClaro = normalizaTexto(File.open(ARGV[1], 'r') { |f| f.read })
    textoCifrado = Vigenere.encode chave,textoClaro
    textoDeslocado = geraArrayTextosDeslocados(textoCifrado, tamChave)
    descobrePalavra(textoDeslocado)
#}