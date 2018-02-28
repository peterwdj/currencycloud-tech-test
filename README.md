# Currencycloud Tech Test

[Introduction](#introduction) | [Quickstart](#quickstart) | [Approach](#approach) | [Challenges](#challenges) | [Miscellaneous Notes](#miscellaneous-notes)

## Introduction

This is a tech test for [Currencycloud](https://www.currencycloud.com/). The brief was to use the [Coolpay API](https://coolpayapi.docs.apiary.io/#) to fulfill four user stories:

 - Authenticate to the Coolpay API
 - Add recipients
 - Send them money
 - Check whether a payment was successful

This project is a command line application. As per the brief, it has been written in [Ruby](https://www.ruby-lang.org/en/). The [RSpec](http://rspec.info/) framework was used to carry out tests.

## Quickstart


#### Installation
To use this application, clone this repo. From the root directory of the project, install the dependencies:

```
bundle install
```

N.B. You will need to have the [Bundler](http://bundler.io/) gem installed.


#### Setup

Enter into a Ruby REPL (such as [IRB](http://ruby-doc.org/stdlib-2.0.0/libdoc/irb/rdoc/IRB.html)), and require the session file:

```
$ irb                          ## enters into the REPL
>> require './lib/session'     => true
```

To log in, you will need to supply a valid username and API key. This can be done in two ways. Either create a `.env` file (you can read more about dotenv [here](https://github.com/bkeepers/dotenv)), and set your `USERNAME` and `APIKEY` variables as follows:

```
USERNAME=YourUsernameHere
APIKEY=dummyAPIkey
```

OR inject them into your new session instance when attempting to log in:

```
>> require './lib/session'                                  => true
>> session = Session.new                                    ## returns a new instance of the Session object
>> session.login(username_as_string, api_key_as_string)     ## returns an authentication token
```


#### Usage

Once logged in, you will be able to access the remaining functions of the application:

```
>> session.add_recipient(name_as_string)                        ## creates a new recipient called Marvin
>> session.make_payment(name_as_string, amount_as_integer)      ## makes a payment
>> session.verify_last_payment                                  ## returns a message informing the user of the status of their last payment
```

As all functions take place from within an instance of the Session class, and the authentication token is saved to that class as an instance variable, you do not need to worry about the token after logging in.


#### Testing

The test framework for this project is RSpec. Tests can be run by running:

```
$ rspec                         ## runs the entire test suite
$ rspec path/to/file.rb         ## runs an individual test file
```

## Approach

The first thing I did with this project was to figure out how the API itself worked. This in itself proved interesting, as I had not used interactive documentation in the style of that provided on Apiary before - only having used static, written documentation.

After establishing how the API worked, the next step was to figure out how the program would be designed. Given that this would just be a command line application, it made sense to have a single, overarching class to allow the user to interact with the application in order to reduce the cognitive load of using it. This class (eventually the Session class) would then delegate to other classes in order to actually carry out the logic of what the actions the program would implement. I used [CRC cards](https://en.wikipedia.org/wiki/Class-responsibility-collaboration_card) in order to aid my design process and ensure a sensible breaking down of the program's different functions.

When building the application itself, I focused on using a test-driven approach to development. Moving one user story at a time, I broke each feature down into its component pieces, and wrote tests for each piece (for example, testing that an API request had been called, and that the method was carrying out the correct operations on any data that was returned). Once tests were passing, following the TDD cycle, I then refactored my code, extracting logic to private methods in order to keep methods slim and moving strings to constants stored within the class.


## Challenges

The biggest challenge with this project was in the testing. Having never made external API calls before, I had never had to mock them before. I settled on using [WebMock](https://github.com/bblimke/webmock), as it seemed to be a commonly-used way to stub API requests in Ruby. However, this also meant constructing complex fake objects that mirrored the real objects returned from an actual API call - ensuring that this data was all in the correct format and structure, properly mimicking the real object, was another challenge.

Additionally, whilst this approach verified that the methods I had written were performing the correct operations with the (fake) data provided, they did not necessarily ensure that the API calls were actually being made. To do this, I used a regular RSpec [method stub](https://relishapp.com/rspec/rspec-mocks/v/3-7/docs) to avoid calling the API, and then expected this stub to have been called with the correct parameters to make the request.

These two techniques both allowed me to effectively test that my code was both making the correct API calls, and doing the right things with the data once it was returned by the API call. However, because the objects being sent and received by the API calls are large and complex, this led to issues with test lengths and code readability. Some of this has been solved by extracting the stubbed API calls to separate methods held within the `spec/helpers.rb` file. However, there are still complex objects held within expectation statements within tests, which somewhat hampers readability and bloats file sizes.

Another challenge relating to tests was properly isolating tests, given that instances of the Session class instantiate new instances of the Payment and Recipient classes when certain methods are called. I solved this by bring requiring these classes within `spec/session_spec.rb`, and stubbing the class's `new` method, specifying that it should return a mock object that could receive the relevant methods, and then expecting that these stubbed methods were called on the mock object. This solution **feels** somewhat unsatisfactory, as I instinctively react against the presence of other classes within a test file. However, stubbing a class method is exactly the same thing that WebMock does. Moreover, the RSpec [documentation](https://relishapp.com/rspec/rspec-mocks/docs/verifying-doubles/using-a-class-double) also brings in additional classes into the spec file for a given class. Given both of the above, I feel confident in saying that these tests are properly isolated, despite my instinctive uncomfortability with it.


## Miscellaneous Notes

*DRY code*   
Many of the stubbed API requests made with WebMock look very similar. The same can be said of the private, API-building private methods within `Session`, `Payment`, and `Recipient`. This does not feel good, and in a commercial setting it would definitely be worth exploring whether or not these hard-coded methods could be consolidated into fewer, or even one, single, flexible method to stub API calls or, in the case of the builder methods, into a separate class (see below). Equally, this would likely involve injecting variables into these methods, thus requiring more code in the test setup - which these methods had been extracted to avoid. Either way, exploring this possibility felt like it was beyond the scope of this project.

*Further refactoring*   
The Session class feels like it is on the edge of being too bloated. Building any further on this project, or in a real-world setting, it might make sense to extract the logic for building an API request to a separate `APIBuilder` class. However, this feels like it is beyond the scope of satisfying the user stories for this project in its current context.

Separately, but on a similar note, when making a payment (in the Payment class) a private method makes a call to the recipient endpoint in order to find the ID of the given recipient. This feels like it could also be done by instantiating a Recipient object, and calling a Recipient instance method in order to return this data but, again, seems unnecessary for this basic implementation of the application.

*Edge cases*   
This project has been set up to handle edge cases (such as attempting to make a payment to a recipient that does not yet exist). There will inevitably be edge cases that exist that have not been covered on a small project such as this, but it felt important, as part of the four user stories, to cover some of the more obvious ones in the production code.

*Feature testing*   
Feature testing of this project was carried out manually. As things stand, this has been done by running code in a command line REPL, and then manually checking via the documentation on Apiary whether or not, for example, recipients had been added. This is both slow and impractical, but also, without a means to clean the list of recipients, leads to the returned objects becoming increasingly bloated. In a real-world version of this project, I would want to investigate ways to automate feature testing, and either stubbing API calls made during the automated feature tests, or cleaning the objects returned by the API. Using environment variables initially seems like a good option to explore in order to achieve the latter.



----------
If you have any suggestions or comments on this project, please submit a new issue [here](https://github.com/peterwdj/currencycloud-tech-test/issues/new).
