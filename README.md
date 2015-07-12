# Bulbasaur
Bulbasaur was created with the objective of shares the component used by Preadly on crawler operations. He is mudule for crawler operations on each operation is used the xml parser Nokogiri and Bulbasaur is just helper for simplify operations with HTML.

[![Build Status](https://travis-ci.org/preadly/Bulbasaur.svg?branch=master)](https://travis-ci.org/preadly/Bulbasaur)
[![Code Climate](https://codeclimate.com/github/preadly/Bulbasaur/badges/gpa.svg)](https://codeclimate.com/github/preadly/Bulbasaur)
[![Test Coverage](https://codeclimate.com/github/preadly/Bulbasaur/badges/coverage.svg)](https://codeclimate.com/github/preadly/Bulbasaur/coverage)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bulbasaur'
```

Or to get the latest updates:

```ruby
gem 'bulbasaur', github: 'preadly/bulbasaur', branch: 'master'
```

And then execute:

	$ bundle
    
Or install it yourself as:
    
	$ gem install bulbasaur
## Usage
Bulbasaur is separated in three operations Extracts, Replaces and Others

### Extract
Composted for operations:
* ExtractImagesFromHTML
* ExtractImagesFromYoutube
* ExtractImagesFromVimeo
* ExtractImagesFromAllResorces 

```ruby
html = "<img src='test.jpg' alt='test' /><img src='test-2.jpg' alt='test' />"
images = ExtractImagesFromHTML.new(html).call
puts images #print [{url: 'test.jpg', alt='alt'}, {url: 'test-2.jpg', alt='test'}]
```

### Replaces
Composted for operations:
* ReplacesByTagImage
* ReplacesByTagLink

```ruby
html = "<img src='test.jpg' alt='test' />"
image_replaces = [{original_image_url:"test.jpg", url: "new-image.png"}]
ReplacesByTagImage.new(html, image_replaces).call
puts html #print <img src='new-image.png' alt='test' />
```

### Others
* NormalizeURL

```ruby
base_url = 'http://github.com'
context_url = 'preadly'
url = NormalizeURL.new(base_url, context_url).call
puts url #print http://github.com/preadly
```

For more informations about how this components works run our spec with param "--format d"
```ruby
rspec --format d --color
```

## Contributing

1. Fork it ( https://github.com/preadly/bulbasaur )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
