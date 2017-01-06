def bget(url, token)
  if token
    ret = Browser.get(url, header: { "Authorization" => "token #{token}"})
  else
    ret = Browser.get(url)
  end

  JSON::parse(ret)
end

def github_download(name, dir, token=nil)
  url = "https://api.github.com/repos/#{name}/git/trees/master?recursive=1"

  ret = bget(url, token)

  raise "truncated == true" if ret["truncated"]

  ret["tree"].each do |e|
    case e["type"]
    when "blob"
      puts e["path"]

      tree = bget(e["url"], token)
      raise unless tree["encoding"] == "base64"

      File.open(File.join(dir, e["path"]), "w") do |f|
        data = Base64.decode(tree["content"].gsub("\n", ""))
        # p tree["content"]
        # p data
        f.write(data)
      end
    when "tree"
      Dir.mkdir File.join(dir, e["path"])
    end
  end

  puts "DONE."
end

# Initialize
begin
  token = GITHUB_DOWNLOAD_TOKEN
rescue NameError
  # token is nil
end

puts <<EOS
Repository name?
(e.g. ongaeshi/tango)
EOS

# Mainloop
loop do
  repo_name = prompt
  dirname = File.basename(repo_name)
  dir = File.join(Dir.documents, dirname)

  if File.exists? dir
    puts "Already exits '#{dirname}'."
  else
    Dir.mkdir dir
    github_download(repo_name, dir, token)
  end
end
