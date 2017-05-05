# README
Steps to take to run this application and its tests.
Things you may want to cover:
1. Clone down our project [rails_engine](https://github.com/samlandfried/rails_engine.git)
1. Clone down the spec harness [rales_engine_spec_harness](https://github.com/turingschool/rales_engine_spec_harness)
1. Navigate into our project directory
1. `bundle`
1. Create the database `rake db:create db:migrate`
1. Load the csv files `rake seed:seed_data`
1. Start the server `rails s`
1. In a different terminal window, navigate to the spec harness directory
1. `bundle`
1. `rake`
1. Watch tests pass (or fail)...