# Currencycloud Tech Test

[Introduction](#introduction) | [Quickstart](#quickstart) | [Approach](#approach) | [Challenges](#challenges) | [Next Steps](#next-steps)

## Introduction

This is a tech test for [Currencycloud](https://www.currencycloud.com/). The brief was to use the [Coolpay API](https://coolpayapi.docs.apiary.io/#) to fulfill four user stories:

 - Authenticate to the Coolpay API
 - Add recipients
 - Send them money
 - Check whether a payment was successful

This project is a command line application. As per the brief, it has been written in [Ruby](https://www.ruby-lang.org/en/). The RSpec framework was used to carry out tests.

## Quickstart

To use this application, clone this repo. From the root directory of the project, install the dependencies:

```
bundle install
```

N.B. You will need to have the [Bundler](http://bundler.io/) gem installed.

Enter into a Ruby REPL (such as IRB), and require the session file:

```
>> require './lib/session'
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

Once logged in, you will be able to access the remaining functions of the application:

```
>> session.add_recipient(name_as_string)                        ## creates a new recipient called Marvin
>> session.make_payment(name_as_string, amount_as_integer)      ## makes a payment
>> session.verify_last_payment                                  ## returns a message informing the user of the status of their last payment
```

As all functions take place from within an instance of the Session class, and the authentication token is saved to that class as an instance variable, you do not need to worry about the token after logging in. 
