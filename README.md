Coding Challenge:
=================

Implementation for the given coding challenge.

Assumptions:
------------

1. The structure of the code is as follows,
  > * Clients: These are classes specific to the downstream API calls.
  > * Wrappers: These models the clients responses as required by the application.
  > * Models: These are the domain models. Uses Activerecord for persistence.
  > * Services: Services performs the procedural tasks necessary for a given feature. 

2. Unit tests cover the tests for individual Classes. The unit tests uses mocks when there is a dependency on a different Class.
3. Integration test covers the connecting points of individual classes. Only the actual API call is stubbed for integration tests.
4. Haven't written the acceptance test or functional tests. In our context, this will be similar to integration tests but without stubbing the API call.
5. Network errors, AdService response errors are not handled.
6. If a local campaign has no associated remote campaign, its ignored and is not considered for discrepancy. Similarly if a remote campaign has no associated local campaign, its ignored.
7. Output format is as below. Its slighlty changed from the given format where the discrepancies was an array. 
```
[
  {
    "remote_reference": "1",
    "discrepancies": {
      "status": {
        "remote": "disabled",
        "local": "active"
      },
      "description": {
        "remote": "Rails Engineer",
        "local": "Ruby on Rails Developer"
      }
    }
  }
]
```
8. Ruby version used is 2.6.3.
9. For the purpose of coding assignment, I have created Campaigns database table with `force: true` which will re-create the table everytime.