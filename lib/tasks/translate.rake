require 'net/http'

def translate_to_lolcat(s)
  if s =~ /<%/
    puts "Skipping ERB: #{s}"
    return s
  else
    result_html = Net::HTTP.get 'speaklolcat.com', "/?from=#{s.gsub(' ','+')}"
    result_html =~ /<textarea id="to" rows="3" cols="30">(.*)<\/textarea>/
    lolcat = $1
    puts "TRANSLATE: #{s}"
    puts "   lolcat: #{s}"
    subs = s.scan(/\%\{(.*?)\}/).collect{ |s| s.first.downcase }
    i = 0
    r = lolcat.gsub(/\%\{(.*?)\}/) { |match| s = "%{#{subs[i]}}"; i += 1; s }
    puts "   return: #{r}"
    return r
  end
end

def translate_hash_to_lolcat(h)
  return_h = {}
  h.keys.each do |k|
    v = h[k]
    if v =~ /\.png|\.gif/
      new_v = v
    elsif v.is_a?(Hash)
      new_v = translate_hash_to_lolcat(v)
    else
      new_v = translate_to_lolcat(v)
    end

    new_k = (k == "en-CA" ? "lolcat" : k)
    return_h[new_k] = new_v
  end
  return return_h
end

namespace :translate do
  desc "translate en-CA to lolcats"
  task :lolcat do
    en_CA = YAML::load(File.read('config/locales/en-CA.yml'))
    defaults = YAML::load(File.read('config/locales/defaults.yml'))
    out_file = File.open(Rails.root.join("config/locales/lolcat.yml"), "w")
    merged_result = translate_hash_to_lolcat(en_CA)["lolcat"].merge(translate_hash_to_lolcat(defaults)["lolcat"])
    merged_hash = { "lolcat" => merged_result }
    out_file.print(merged_hash.to_yaml)
  end

  desc "download latest translations from mygengo for French"
  task :french do
    system "wget http://mygengo.com/string/p/pulse-1/export/language/fr/95a46fda9d19104cbc4b5bb4ccce05b77056d4b26171cd16fc936758271e017a"
    system "mv 95a46fda9d19104cbc4b5bb4ccce05b77056d4b26171cd16fc936758271e017a french.zip"
    system "unzip french.zip"
    system "mv fr/en-CA.yml config/locales/fr.yml"
    system "mv fr/defaults.yml config/locales/fr-defaults.yml"
    system "rmdir fr"
  end
end
