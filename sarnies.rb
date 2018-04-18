require 'mongo'
require 'json'
require 'awesome_print'
require 'faker'

#
#  This Script creates a number of fake sandwiches and inserts them into the database
#  It is not designed to be performant or reliable, but it should work to some extent
#

# ruby sarnies.rb <num records> <db> <collection> <uri>

# Connect to the the Database
Client = Mongo::Client.new(ARGV[3])

@DB = Client.use(ARGV[1])
# Reduce the level of verbosity of the Logger
Mongo::Logger.logger.level = ::Logger::WARN


# An Array of cities
@bread = ["White Bread", "Brown Bread", "a Seeded bun", "a kiln fired flatbread", "a pitta", "a wrap", "sourdough", "a croissant", "rye bread", "a artisan baked stone ground bloomer", "a barm cake", "a traditional northern cob"]
@price = [1.99, 2.99, 3.99, 3.49, 3.75, 3.99, 4.49, 4.99, 5.49, 5.99, 8.99]
@range = ["Basic", "Kids", "Xtra Hungry", "Artisan", "Home Made", "Luxury", "Bespoke"]
# Insert some documents into the database
def insertDocs(coll)

  # start by dropping any existing data
  # result = @DB[coll].drop

  # Insert this many documents
  for i in 1..ARGV[0].to_i

    ing1 = Faker::Food.ingredient
    ing2 = Faker::Food.ingredient
    ing3 = Faker::Food.ingredient
    bread = @bread[rand(@bread.size)]
    range = @range[rand(@range.size)]
    # define the Ruby Hash object for the document
    doc =
        {
            :description => "#{range} #{ing1}, #{ing2} and #{ing3} on #{bread}",
            :fillings => [
                {
                    :ingredient => ing1,
                    :calories => rand(100),
                },
                {
                    :ingredient => ing2,
                    :calories => rand(100),
                },
                {
                    :ingredient => ing3,
                    :calories => rand(100),
                },
            ],
            :on => bread,
            :price => @price[rand(@price.size)],
            :rating => rand(10),
            :lastUpdate => Time.now
        }
    # Send to the console
    ap doc
    # Insert into the database
    result = @DB[coll].insert_one(doc)
  end
end


# call the function to insert the docs
insertDocs(ARGV[2])
