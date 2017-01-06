def github_download(name)
  url = "https://api.github.com/repos/#{name}/git/trees/master?recursive=1"
  ret = Browser.json(url)

  raise if ret["truncated"]

  ret["tree"].each do |e|
    case e["type"]
    when "blob"
      puts e["path"]

      tree = Browser.json(e["url"])
      raise unless tree["encoding"] == "base64"

      File.open(e["path"], "w") do |f|
        data = Base64.decode(tree["content"].gsub("\n", ""))
        # p tree["content"]
        # p data
        f.write(data)
      end
    when "tree"
      Dir.mkdir e["path"]
    end
  end

  puts "DONE."
end

#---
puts <<EOS
Repository name?
(e.g. ongaeshi/tango)
EOS

loop do
  repo_name = prompt
  github_download(repo_name)
end
