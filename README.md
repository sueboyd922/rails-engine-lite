
# Rails Engine Lite

This is my repo for the [Rails Engine Lite project](https://backend.turing.io/module3/projects/rails_engine_lite) used for Turing's Backend Module 3. This project is designed to teach students how to build and expose an API.
From the project descripton: 

```
You are working for a company developing an E-Commerce Application. 
Your team is working in a service-oriented architecture, meaning the front and back ends of this application are separate and communicate via APIs.
Your job is to expose the data that powers the site through an API that the front end will consume.
```

## About this Project

Rails Engine Lite is a backend application that exposes an API in response to certain e-commerce type queries. It uses a Postgres database seeded with mock business data. I built 13 total endpoints for various business queries. RSpec as well as a Postman Test Suite was used to test the application, with the gem Simplecov to test coverage. 

Example Queries:
- Create an Item
- Update an Item
- Delete an Item
- Search for an Item
- Search for all Items

## Learning Goals
Expose an API 
Use serializers to format JSON responses
Test API exposure
Use SQL and AR to gather data 

## Personal Lessons
This was my first project building an API and it was with only 14 weeks experience coding. Looking back at this repo almost 2 months later I see so many things that I would refactor, for example the `find` and `find_all` methods in the `items_controller` is way too large and I would write helper methods that could dry up the code and be abstracted out of the controller. During the project that I worked on after this, GearUp ( [Repository](https://github.com/ShermanA-13/gear-up-be) || [Deployed](https://gearupbeta.herokuapp.com/) ) I was responsible for many of the endpoints and error handling on our backend Rails application and I believe it shows the difference in what I learned after this application. I chose to handroll the serializers in this project because it was my first time working with them and I find that to be how I learn best. In later projects I made use of the json-serializer gem but was also better prepared to handroll more complicated JSON responses. Since this ReadMe was written well after the project was built, I can see by looking back at it and shuddering at some design choices and excessive code just how much I have learned since!  


## Local Setup

1. Fork and Clone the repo
2. Install gem packages: `bundle install`
3. Setup the database: `rails db:{create,migrate,seed}`
4. Import the schema design: `rails db:schema:dump`
5. Go to console and run: `rails s`

## Gems Used
1. Pry
2. Rspec-Rails
3. Factory_bot_rails
4. Faker
5. Shoulda-matchers
6. JSON-serializer **(I ended up handrolling the serializers, to learn how it worked before using the gem)



## Versions

- Ruby 2.7.2

- Rails 5.2.6

## API Testing Suites
[Section 1](https://backend.turing.edu/module3/projects/rails_engine_lite/RailsEngineSection1.postman_collection.json)

[Section 2](https://backend.turing.edu/module3/projects/rails_engine_lite/RailsEngineSection2.postman_collection.json)
