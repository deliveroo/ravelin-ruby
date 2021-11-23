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
