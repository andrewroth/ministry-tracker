require 'net/http'

def translate_to_lolcat(s)
  result_html = Net::HTTP.get 'speaklolcat.com', "/?from=#{s.gsub(' ','+')}"
  result_html =~ /<textarea id="to" rows="3" cols="30">(.*)<\/textarea>/
  return $1
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

def translate_to_test(s)
  return "T_#{s.to_s.gsub(' ','_')}"
end

def translate_hash_to_test(h)
  return_h = {}
  h.keys.each do |k|
    v = h[k]
    if v =~ /\.png|\.gif/
      new_v = v
    elsif v.is_a?(Hash)
      new_v = translate_hash_to_test(v)
    else
      new_v = translate_to_test(v)
    end

    new_k = (k == "en-CA" || k == "defaults" ? "test" : k)
    return_h[new_k] = new_v
  end
  return return_h
end

namespace :translate do
  desc "translate en-CA to lolcats"
  task :lolcat do
    en_CA = YAML::load(File.read('config/locales/en-CA.yml'))
    out_file = File.open(Rails.root.join("config/locales/lolcat.yml"), "w")
    out_file.print(translate_hash_to_lolcat(en_CA).to_yaml)
  end

  desc "translate en-CA to lolcats"
  task :test do
    en_CA = YAML::load(File.read('config/locales/en-CA.yml'))
    defaults = YAML::load(File.read('config/locales/defaults.yml'))
    out_file = File.open(Rails.root.join("config/locales/test.yml"), "w")
    merged_result = translate_hash_to_test(en_CA)["test"].merge(translate_hash_to_test(defaults)["test"])
    merged_hash = { "test" => merged_result }
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
