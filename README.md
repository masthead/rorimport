This is the test import app

In the tmp/ directory are sample files for:

1.  Appointment
2.  Service
3.  Sale

After bundling application, run rake db:create, rake db:schema:load, and rake db:seed

You should then be able to rake data_import.  This will register 146 import files and loop through them until completed.  I've removed any asynchronous processing (through Sidekiq) so that an accurate measure can be taken for single threading this import.

In production I would expect to be able to run multiple imports simultaneously and control the number of threads via some configuration file or parameter to make sure we keep the database from maxing out.

On my local machine, these 146 records import in ~3300 seconds.  I would expect the performance of the Go application to be much faster.

In general, each of the three file types contains the following objects:

Customer
Vehicle

Each of the file types is essentially an object or class that relates a Dealer to a Customer and Vehicle through its "transaction."

A Customer belongs to a Dealer (so a dealer has many customers).

A Customer can have many Vehicles (related through CustomerVehicle) as many customers can have many vehicles.

A Sale, Service, and Appointment record belong to a Dealer, Customer, and Customer Vehicle.

A Customer has multiple Event records, and an Event shows all Customer interactions (transactions) across all types associated to a Vehicle.

For each file, we parse the rows in the file to create the various objects and relations within the file.  First we find-or-create the Customer, then find-or-create the Vehicle, then find-or-create the CustomerVehicle.  We then create the class record (Sale, Service, Appointment) and find-or-create the Event associated with the Customer, CustomerVehicle, and class record.

Based on the Sale and Service events for a customer, we also estimate the current odometer reading of the vehicle.
