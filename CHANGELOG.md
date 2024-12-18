# 0.1.48 

Added transfer_type to payment_method.
Added transfer_type to payment_method.
Updated ruby version to to 2.5.8 and bundler to 2.5.11

# 0.1.47

Added support for passing optional request headers to ravelin client and ravelin proxy. 

# 0.1.46

Fixed multiple payment methods serialization [#89](https://github.com/deliveroo/ravelin-ruby/pull/85)

# 0.1.45

Serialize multiple payment methods [#89](https://github.com/deliveroo/ravelin-ruby/pull/89)
Serialize multiple transactions [#90](https://github.com/deliveroo/ravelin-ruby/pull/90)
Update Webmock and rake [#91](https://github.com/deliveroo/ravelin-ruby/pull/91)

# 0.1.44


Add [magic link authentication mechanism](https://developer.ravelin.com/apis/ato/#login.login.authenticationMechanism.magiclink) 
object
# 0.1.43


Add [sms code authentication mechanism](https://developer.ravelin.com/apis/ato/#login.login.authenticationMechanism.smsCode) 
object

# 0.1.42

Fix [social authentication mechanism](https://developer.ravelin.com/apis/ato/#login.login.authenticationMechanism.social) 
object

Add tests

# 0.1.41

Add [social authentication mechanism](https://developer.ravelin.com/apis/ato/#login.login.authenticationMechanism.social) 
object

# 0.1.40

Add [supplier](https://developer.ravelin.com/apis/v2/#postv2supplier) object

# 0.1.39

Adds support for the `custom` property on the `Ravelin::Login` class

# 0.1.38

Add a include_rule_output option

# 0.1.37

Fixes order category from 0.1.36

# 0.1.36

Add category to order

*Don't use* - has a massing comma so category is not available

# 0.1.35
Add scheme paymentMethod key

# 0.1.34
Add App to Order

# 0.1.33
Allow checkout transactions to have just the information available at pretransaction

# 0.1.28
Added returning warning messages in the structured response.

# 0.1.27
Reverted the faraday and rspec versions back to the versions that were in the `0.1.25` gem.

# 0.1.26
Added an ProxyClient as an alternative client
* Instead of calling the Ravelin API directly, it can be done via an HTTP proxy server.

# 0.1.25
Disambiguate between V2 and V3 login events:
* Applies correct timestamp formatting
* Corrects validation

# 0.1.24

Fix date formatting for events:
* ATO Login events provide Unix timestamps with milliseconds 
* ATO Reclaim events provide timestamps in RFC3339 format
* All other events provide Unix timestamps

# 0.1.23

Add support for ATO reclaim API

# 0.1.21

Remove debugging left in accidentally

# 0.1.20

Make customer_id in ato api optional, since the customer may not exist

# 0.1.19

Add support for Account Takeover API

# 0.1.9

Added support for tags.

# 0.1.6

Fix validation to not require payment_method_id if payment_method provided

# 0.1.5

Add user_agent to device RavelinObject
Add type and time to Transaction
Add missing fields to Pretransaction Object

# 0.1.4

Ravelin sends the work `null` in responses if there are no changes.  This causes JSON.parse to fail.
