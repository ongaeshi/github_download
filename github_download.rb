def github_download(name, dir)
  url = "https://api.github.com/repos/#{name}/git/trees/master?recursive=1"
  ret = Browser.json(url)

  raise "truncated == true" if ret["truncated"]

  ret["tree"].each do |e|
    case e["type"]
    when "blob"
      puts e["path"]

      tree = Browser.json(e["url"])
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

#---
puts <<EOS
Repository name?
(e.g. ongaeshi/tango)
EOS

loop do
  repo_name = prompt
  dirname = File.basename(repo_name)
  dir = File.join(Dir.documents, dirname)

  if File.exists? dir
    puts "Already exits '#{dirname}'."
  else
    Dir.mkdir dir
    github_download(repo_name, dir)
  end
end
