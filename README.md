# Simple Data

Final project: Jordy Williams, Grant Hummer, Ryan Jones, David Chmura and Eleni Chappen

## Starting your Rails app

After a `bundle install`, run the following to boot the Rails app on port 3000:

```sh
$ foreman start -p 3000
```

## How to use the database and seed file

After you've git cloned this repo and run bundle install, use rake db:setup to create, migrate
and seed the database. You'll notice in the seed file that we create four different types of objects: Users, Services, CSV table objects, and Services.

User is an ActiveRecord model which is fairly self-explanatory. It will eventually have all the authentication information as well about a given user. It also has a one-to-many relationship with Organizations.



Service is a Mongo model that represents one of possibly many APIs per Organization. A Service belongs to an Organization. A Service also has many embedded Records.

Record is also a Mongo model that represents one row of data in a Service (think of 1 row of a csv file corresponding to a record). Since one-to-many relationships in Mongo are best represented with embedding models inside a single document, many records are embedded in a single Service and thus can be queried through the Service.

## Example query

Starting with a given organization, here's a simple example of how you would find the records associated with it:

```sh
Organization.first.services.first.records
```

Notice that the services and records methods return collections. In order to access an element within this collection, you need to pick it out in much the same way that you would with an ActiveRecord collection.

## Dropping the database

Use the following command along with rake db:drop:

```sh
$ rake db:purge
```



