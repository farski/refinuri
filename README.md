# Refinuri #
## ri-fahy-nuh-ree ##

Refinuri has two primary functions related to querying and filtering data:

+ a simple way to produce pretty, meaningful URLs, even with complex query strings
+ a standardized, extensible interface to filtering metadata

## The dime tour ##

Refactor an ugly 'traditional' URL, such as
	
	craigslist.org/search/housing?cat=loft&minPrice=500&maxPrice=1000&cats=true&dogs=true&bedrooms=2

to
	
	craigslist.org/search/housing/type:loft;price:500-1000;pets:cats,dogs;bedrooms:2/

And parse it into a convenient set of filters

	@filters = Refinuri::Parser.parse_url(params[:filters])

Now you can pass all that filtery goodness straight into your ActiveRecord object
	
	Apartment.filtered(@filters)
	# which can be scoped even further just like normal
	Apartment.filtered(@filters).order('bedrooms DESC').limit(20).includes(:amenities)
	
And easily add links to your views to create, update, or delete the filters
	
	filter_with_link("Allow Ferrets", { :pets => 'ferrets' })
	filter_with_link("Only cats", { :create => { :pets => 'cats' } })
	filter_with_link("Any Price", { :delete => { :price => nil } })

## Benefits ##

Not only does Refinuri improve the readability and length of URLs, but behind the scenes each piece of filtering data is being handled as the appropriate datatype automatically. A range of prices is an actual Range, a list of items is actually an Array, etc.

This is useful both because it allows you to hand the queries off to ActiveRecord very easily, and also because the data can be changed very easily. Individuals filters can accept arbitrary numbers of items, numeric filters and go from Integers to Ranges with no effort, etc.

The hope is that, with most of the heavy lifting being done automatically and in a consistent way, it will be much easier to actually implement a user-facing interface that allows for more advanced and useful controls to be implemented.

## Usage

### Installation
	
	$ sudo gem install refinuri

### Example Application ###

#### routes.rb ####

	match 'products/:id/:filters' => 'products#index'

#### application_controller.rb ####

	before_filter :refine_filters
	
	private
	def refine_filters
		@filters = Refinuri::Parser.parse_url(params[:filters]) if params[:filters]
	end

#### products_controller.rb ####

	@products = Product.filtered(@filters)
	
#### products/index.html.erb ####

	<%= filter_with_link("Price less than $50", { :price => '..50' }) %>
	<% @products.each do |product| %>
		<%= product.name %>
	<% end %>
	
## API ##

### Defining filters ###

Filters are initially defined as a Hash, where each key represents an attribute upon which a resource can be filtered, and the value represents the values that will pass the filter.

The following hash creates three filters:

	{ :name => ['apple','banana','cherry'], :price => 0..5, :weight => '4..' }
	
The Hash is used to create a new FilterSet, the class responsible for handling changes to the filters and outputting the filter values appropriately when necessary.

	Refinuri::Base::FilterSet.new({ :name => ['apple','banana','cherry'], :price => 0..5, :weight => '4..' })

### Modifying filters ###

The FilterSet uses #merge! to accept changes to an existing set of filters. #merge! also accepts a hash, but allows for defining how the filters should be merged into the set.

By incorporating the various CRUD functions into the Hash, the new filters and values will be merged into the existing set.

	@filters.merge!({ :create => { :color => 'orange' }, :update => { :name => 'dewberry', :price => 0..10 }, :delete => { :weight => nil } })
	
Any filters being merged that aren't explicitly stated as one of the CRUD functions is assumed to be an :update.

### Returning values ###

#### Values of entire filter sets: ####

\#to_h returns the entire set as a hash, similar to the one used to initialize the filter, but with any changes that have been made
	
	@filters.to_h
	=> { :name => ['apple','banana','cherry','dewberry'], :color => ['orange'], :price => 0..10, :weight => '4..' }

\#to\_url returns the entire set as a URL-friendly string, which could be included as an option in a link_to() helper
	
	@fitlers.to_url
	=> "name:apple,banana,cherry,dewberry;color:orange;price:0-10;weight:4+"

#### Values of individual filters within a set: ####

\#value returns the filter value as it was defined

	@filters[:name].value
	=> ['apple','banana','cherry']

\#to_db returns a value suitable for passing to a #where chain of an ActiveRecord object
	
	@filters[:name].to_db
	=> { :name => ['apple','banana','cherry'] }
	
\#to_s returns a value suitable for use in a URL
	
	@filters[:name].to_s
	=> "apple,banana,cherry"
	
### Parsing filter strings ###

Filters defined within strings, such as those contained in a URL, can be parsed into a FilterSet using:
	
	Refinuri::Parser.parse_url()
	
### ActiveRecord integration ###

There are two ways of using FilterSets and filters with ActiveRecord.

#### Individually ####

The first is to utilize an individual filter manually along side the #where method, which is part of the Rails 3 query interface. The #to_db method returns values for filters specifically designed for use as a #where argument.
	
	Product.where(@filters[:price].to_db) # => like Product.where(:price => 0..10)
	Product.where(@filters[:name].to_db) # => like Product.where(:name => ['apple','banana','cherry'])
	Product.where(@filters[:weight].to_db) # => like Product.where('weight <= 10')

#### En masse ####

The second is to pass the entire FilterSet off to ActiveRecord, and filter the object using all currently defined filters. The #filtered method is provided to ActiveRecord::Base for this purpose.

	Product.filtered(@filters)
	
This is like doing
	
	Product.where(@filters[:price].to_db).where(@filters[:name].to_db).where(@filters[:weight].to_db)

### ActionView helpers ###

There are several link helpers included to serve common needs of creating and updating filters through the UI.

The first is a simple interface for passing a set of changes to the current set of filters, and returning the appropriate link.
	
	filter_with_link("+ apple", { :name => 'apple' })
	filter_with_link("- apple", { :delete => { :name => 'apple' } })

The next acts as a toggle for values within array-based filters, and will toggle individual values (not the entire filter, per se)
	
	toggle_filter_with_link("+/- apple", { :name => 'apple' })

## Data types ##

### Arrays

In URLs an array is represented as

	key:item1,item2,item3
	
Which are parsed as standard Ruby arrays, available through the FilterSet

	@set[:key] => ['item1','item2','item3']

### Ranges

In URLs a range is represented as

	key:10-20
	
Which are parsed as standard Ruby ranges, available through the FilterSet

	@set[:key] => 10..20

(Support for both inclusive and exclusive ranges is not yet included, but coming soon)

### Unbounded ranges

Unbounded ranges are a non-ruby-standard datatype, which allows for a convenient way of defining only an upper- or lower-bound on a range.

### Lower-bound ranges

Represented in URLs as

	key:10+
	
Parsed into the filter as strings in the format

	@set[:key] => '10..'
	
And provides a convenience method for use in an ActiveRecord #where

	@set[:key].to_db => 'key >= 10'

### Upper-bound ranges

Represented in URLs as

	key:10-
	
Are parsed into strings in the format

	@set[:key] => '..10'
	
And provides a convenience method for use in an ActiveRecord #where

	@set[:key].to_db => 'key <= 10'