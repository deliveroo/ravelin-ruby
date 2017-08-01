# 0.1.6

Fix validation to not require payment_method_id if payment_method provided

# 0.1.5

Add user_agent to device RavelinObject
Add type and time to Transaction
Add missing fields to Pretransaction Object

# 0.1.4

Ravelin sends the work `null` in responses if there are no changes.  This causes JSON.parse to fail.


# 0.1.9

Added support for tags.
