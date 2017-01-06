def bget(url, token)
  if token
    ret = Browser.get(url, header: { "Authorization" => "token #{token}"})
  else
    ret = Browser.get(url)
  end

  JSON::parse(ret)
end

def mkdir_p(dir)
  Dir.mkdir(dir) unless File.exists?(dir)
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
      dst = File.join(dir, e["path"])
      mkdir_p(dst)
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
  args = prompt.split

  opts = {}
  args.delete_if do |e|
    if e == "-u"
      opts[:update] = true
      true
    else
      false
    end
  end
  
  args.each do |repo_name| 
    dirname = File.basename(repo_name)
    dir = File.join(Dir.documents, dirname)

    if opts[:update] || !File.exists?(dir)
      mkdir_p(dir)
      github_download(repo_name, dir, token)
    else
      puts "Already exits '#{dirname}'."
    end
  end
end
