# https://developer.github.com/v3/gists/#create-a-gist
TOKEN = "XXXXXX"

def new_gist(filename, content)
  json = {
    # description: "Created by RubyPico at #{Time.now}",
    public: true,
    files: {
      filename => {
        content: content
      },
    }
  }
  
  Browser.post(
    "https://api.github.com/gists",
    header: { "Authorization" => "token #{TOKEN}" },
    json: json
  )
end

puts "Specify path"
path = prompt

File.open(path) do |f|
  r = new_gist(
    File.basename(path),
    f.read
    )
    
  r = JSON.parse(r)
  if r["html_url"]
    puts r["html_url"]
  else
    puts r
  end
end
