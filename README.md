# rubypico_github
RubyPico Tools to access the GitHub

## github_downaload.rb
Download GitHub repository

### Install
Copy [github_download.rb](https://github.com/rubypico/rubypico_github/blob/master/github_download.rb)([raw](https://raw.githubusercontent.com/rubypico/rubypico_github/master/github_download.rb)) to Your RubyPico root directory.

### Setup App Tab
1. Create `.app/github_download` 
2. Add below
3. Appear `github_download` your App tab 
```ruby
require "github_download"
# When placed in "rubypico_github/github_download.rb"
# require "rubypico_github/github_download"
```

### Setup TOKEN (Optional)
Add `GITHUB_DOWNLOAD_TOKEN` constant to `.app/github_download`

```ruby
GITHUB_DOWNLOAD_TOKEN = "xxxxxx" # Your github repository token
require "github_download"
```

### Usage
```
Repository name?
(e.g. app_installer, ongaeshi/tango)

# Download GitHub repository
$ app_installer

# Download GitHub repository (Overwrite)
$ app_installer -u
```
