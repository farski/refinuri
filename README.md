# Refinuri

Refinuri provides two primary functions related to querying and filtering data:
* a simple way to produce pretty, meaningful URLs, even with complex query strings
* a standardized, extensible interface to filtering metadata

## In practice

### Pretty URLs

A 'traditional' style URL with standard query strings such as
	
	craigslist.org/search/housing?cat=loft&minPrice=500&maxPrice=1000&cats=true&dogs=true&bedrooms=2

Will become

	craigslist.org/search/housing/type:loft;price:500-1000;pets:cats,dogs;bedrooms:2
	
### Internal interface to filters

Filters are stored within a FilterSet, a Hash-like object that allows for easy access to properly-typed data and merging in changes to the set of filters. Filters and changes are passed into FilterSet as hashes.
	
	>> base_filters = { :name => ['apple','banana','cherry'], :price => 0..5, :weight => '4..' }
	>> set = FilterSet.new(base_filters)
	
The filters can be exposed through

	>> set[:name].value # => ['apple','banana','cherry']
	>> set.to_url # => 'name:apple,banana,cherry;price:0-5;weight:4+'
	>> set.to_h # => { :name => ['apple','banana','cherry'], :price => 0..5, :weight => '4..' }
	
Changes are merged into an existing filter set, either implicitly or explicitly as CRUD functions
	
	# implicit changes generally update existing values
	>> changes = { :name => 'dewberry' }
	>> set.merge!(changes)
	>> set[:name].value # => ['apple','banana','cherry','dewberry']
	
	# explicilty stated CRUD functions
	>> more_changes = { :update => { :name => ['eggplant','fig] }, :destroy => { :price => nil } }
	>> set.merge!(more_changes)
	>> set[:name].value # => ['apple','banana','cherry','dewberry','eggplant','fig']
	>> set[:price] # => nil
	
## Benefits

Not only does Refinuri improve the readability and length of URLs, but behind the scenes each piece of filtering data is being handled as the appropriate data type automatically. A range of prices is an actual Range, a list of brands is an Array, etc.

This is useful both because it allows you to hand the queries off to ActiveRecord very easily, and also because the data can change very freely. A filter can change from an Integer to a Range with very little overhear need to change things on the backend.

The hope is that with most of the heavy lifting being done automatically and in a consistent way, it will be much easier to actually implement a user-facing interface that allows for these more advanced controls than are generally being offered.

## Usage

### Installation
	
	$ sudo gem install refinuri

### Common API aspects

##### URL parsing
	
	>> Refinuri::Parser.parse_url('name:apple,banana,cherry')
	=> #<Refinuri::Base::FilterSet:0x1003ad300>
	
#### Generating URL string
	
	>> @filter_set.to_url
	>> 'name:apple,banana,cherry'
	
#### Creating and modifying FilterSets

New filters a populated with a hash

	>> Refinuri::Base::FilterSet.new({ :name => ['apple','banana','cherry'] })

Filters are modified with #merge! by passing in a hash of changes.

Changes that are not explicitly stated as a CRUD function are assumed to be UPDATEs. UPDATEs will create a new filter if it does not already exist, or will add unique values to an array, or replace a range. CREATE will either create a new filter or completely replace an existing filter.

	# implicit changes, treated as UPDATE
	>> @filter.merge!({ :name => ['dewberry','eggplant'] })
	# @filter[:name].value => ['apple','banana','cherry','dewberry','eggplant']
	# explicit UPDATE
	>> @filter.merge!({ :update => { :name => ['dewberry','eggplant'] } })
	# @filter[:name].value => ['apple','banana','cherry','dewberry','eggplant']
	# explicit CREATE
	>> @filter.merge!({ :creaet => { :name => ['dewberry','eggplant'] } })
	# @filter[:name].value => ['dewberry','eggplant']
	# explicit DELETE
	>> @filter.merge!({ :delete => { :name => nil } })
	# @filter[:name] => nil
	
#### Helpers
	
	# creates a link to the current view, adding 'apple' the the :name filter, 
	# or returning an unchanged link if 'apple' is already in the :name filter
	>> filter_with_link("Apple", { :name => 'apple' })
	
	# toggles the value 'apple' within the name filter, adding it if is not
	# in the set, or removing it if it is
	>> toggle_filter_with_link("Apple", { :name => 'apple' })

### Example Application