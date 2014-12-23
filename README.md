# Simple Data

Final project: Jordy Williams, Grant Hummer, Ryan Jones, David Chmura and Eleni Chappen

## Installing Mongo on your computer

You must have Mongo installed on your computer in order to work with our app. In your app's root file, run:

```sh
brew install mongo
```

## Starting your Rails app

After a `bundle install`, run the following to boot the Rails app on port 3000:

```sh
$ foreman start -p 3000
```

This starts a Unicorn server. Note that running foreman start with no -p will start a server on port 5000 by default.

## How to use the database and seed file

After you've run bundle install, use the regular rake db commands to create, migrate and seed the database. You must have the Unicorn server running to seed the database.

If you want to drop the database, you need to stop the server first. To re-seed, you need to run rake db:create and rake db:migrate. Then start the server with foreman start and run rake db:seed. It's possible that you will need to use bundle exec with these commands as well.

You'll notice in the seed file that we create four different types of objects: 1 User, 1 Organization, 1 Service that's pulling from a CSV, and many Service records.

## Models

Organization is the top-level model in our schema. It is an ActiveRecord model. An organization has many users and many services.

User is an ActiveRecord model. It will eventually have all the authentication information about a given user. A user belongs to an organization, and thus has access to the organizations many services.

Service is a Mongo model that represents one of possibly many APIs per Organization. Think of one service as one document in our Mongo database. A Service belongs to an Organization. A Service also has many embedded Records.

Record is also a Mongo model that represents one row of data in a Service (think of one row of a csv file corresponding to one record). Since one-to-many relationships in Mongo are best represented with embedding models inside a single document, many records are embedded in a single Service and thus can be queried through the Service.

## Example query

Starting with a given organization, here's a simple example of how you would find the records associated with it:

```sh
Organization.first.services.first.records
```

Notice that the services and records methods return collections. In order to access an element within this collection, you need to pick it out in much the same way that you would with an ActiveRecord collection.

## Dropping the database for both ActiveRecord and Mongo

The Mongo database must be dropped separately drom the PostGres database. TO make sure that both your databases are dropped, use the following commands:

```sh
$ rake db:drop
$ rake db:purge
```

The purge command drops the Mongo database. Note that purge can only be done while the server is running.

## What API URIs could look like

Our current thinking is that the URI for an API should have the following structure:

When a user wants to retrieve the entire dataset, they would make a request to the following path:
localhost:5000/services/:api_name/records

Maybe we can also put in query string functionality for users to be able to filter for certain columns.

For querying the API itself, we plan to provide several methods to enable the API consumer to get specific attributes from the data. For example, we have a limit method which allows the consumer to get the first 10 (or however many) records when they visit /services/:service_name/records?limit=10

Another method we plan to add is filtering. The tests we've been conducting result in a query string which is a bit ugly, but would look something like the following:
/services/:service_name/records?filter[]=column1&filter[]=column2&filter[]=column3




## Random Notes

We're using the mongoid-rspec gem, which adds mongoid functionality to the rspec testing framework. Check out documentation about it at https://github.com/mongoid-rspec/mongoid-rspec.



