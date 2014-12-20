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

This starts a Unicorn server.

## How to use the database and seed file

After you've run bundle install, use the regular rake db commands to create, migrate and seed the database. You must have the Unicorn server running to seed the database.

You'll notice in the seed file that we create four different types of objects: 1 User, 1 Organization, 1 Service that's pulling from a CSV, and many Service records.

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

The Mongo database must be dropped separately drom the PostGres database. TO make sure that both your dtaabases are dropped, Use the following commands one after the other:

```sh
$ rake db:drop
$ rake db:purge
```

The purge command drops the Mongo database.

## What API URIs will look like

Our current thinking is that the URI for an API should have the following structure:

When a user wants to retrieve the entire dataset, they would make a request to the following path:
localhost:5000/services/:api_name/records

Maybe we can also put in query string functionality for users to be able to filter for certain columns.


## Random Notes

We're using the mongoid-rspec gem, which adds mongoid functionality to the rspec testing framework. Check out documentation about it at https://github.com/mongoid-rspec/mongoid-rspec.



