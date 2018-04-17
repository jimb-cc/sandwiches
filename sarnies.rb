require 'mongo'
require 'json'
require 'awesome_print'
require 'faker'

#
#  This Script creates a number of fake customer records and inserts them into the database
#  It is not designed to be performant or reliable, but it should work to some extent
#


# Connect to the the Database
Client = Mongo::Client.new(ARGV[0])

@DB = Client.use(:test)
# Reduce the level of verbosity of the Logger
Mongo::Logger.logger.level = ::Logger::WARN

# An Array of cities
@city = ["London", "Birmingham", "Manchester", "Liverpool", "Cardiff", "New York", "San Francisco", "Paris", "Berlin", "Frankfurt", "Amsterdam"]
@sector = ["Financial Services", "Healthcare", "Public Sector", "Education", "Media", "Technology", "BioInformatics", "Retail", "Real Estate", "Insurance", "Unknown"]

# Insert some documents into the database
def insertDocs(coll)

  # start by dropping any existing data
  # result = @DB[coll].drop

  # Insert this many documents
  for i in 1..4000

    # Create a couple of values that we can play with.
    positionAtClose = rand(100000)
    currentDiff = rand(-1000..1000)

    # define the Ruby Hash object for the document
    doc =
        {
            :customerName => Faker::Company.name,
            :customerAddress => Faker::Address.street_address,
            :customerID => i+10000,
            :companyType => Faker::Company.type,
            :positionAtClose => positionAtClose,
            :lastPosition => positionAtClose+currentDiff,
            :currentDiff => currentDiff,
            :sector => @sector[rand(@sector.size)],
            :city => @city[rand(@city.size)],
            :country => Faker::Address.country,
            :lastUpdate => Time.now
        }
    # Send to the console
    ap doc
    # Insert into the database
    result = @DB[coll].insert_one(doc)
  end
end


# call the function to insert the docs
insertDocs("sample")
