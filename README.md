# Bulbasaur
Bulbasaur was created with the objective of sharing components used by the Preadly crawler. It is a module for crawler operations, which uses the XML parser Nokogiri. Bulbasaur helps to simplify those HTML operations. This is one of contributions of [pread.ly](http://pread.ly) to the open source community.

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
    
Or install it manually with:
    
	$ gem install bulbasaur
## Usage
Bulbasaur has three main operations: Extract, Replace and Other.

### Extract
Has four sub-operations:
* ExtractImagesFromHTML
* ExtractImagesFromYoutube
* ExtractImagesFromVimeo
* ExtractImagesFromAllResorces 

```ruby
html = "<img src='test.jpg' alt='test' /><img src='test-2.jpg' alt='test' />"
images = Bulbasaur::ExtractImagesFromHTML.new(html).call
puts images #print [{url: 'test.jpg', alt='alt'}, {url: 'test-2.jpg', alt='test'}]
```

### Replaces
Has two sub-operations:
* ReplacesByTagImage
* ReplacesByTagLink

```ruby
html = "<img src='test.jpg' alt='test' />"
image_replaces = [{original_image_url:"test.jpg", url: "new-image.png"}]
Bulbasaur::ReplacesByTagImage.new(html, image_replaces).call
puts html #print <img src='new-image.png' alt='test' />
```

### Others
* NormalizeURL

```ruby
base_url = 'http://github.com'
context_url = 'preadly'
url = Bulbasaur::NormalizeURL.new(base_url, context_url).call
puts url #print http://github.com/preadly
```

For more information about the components, run the RSpec tests with parameter `--format d`.
```ruby
rspec --format d --color
```

## Contributing

1. Fork it ( https://github.com/preadly/bulbasaur );
2. Create your feature branch (`git checkout -b my-new-feature`);
3. Commit your changes (`git commit -am 'Add some feature'`);
4. Push to the branch (`git push origin my-new-feature`);
5. Create a new Pull Request.
