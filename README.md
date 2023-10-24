During the In Flight Cancellation journey, a request should be sent to downstream system for initiating the return of devices provisioned to the customer. Once the return is initiated, activity tracking is done in downstream system to track the return. The activity tracking request for each of the device is sent from Salesforce.
Technical Challenges
-> Provisioning orchestration plan is linked to root technical product, therefore rollback plan will also be linked to same technical product.
-> Due to downstream limitations, it is required to send one single request for each of child products under technical Root product.
-> Business also wants to track each request in Salesforce so we can’t have single callout item sending all the requests.
-> Each of the commercial device has its own technical decomposition and a separate request should be for each technical product in rollback plan.
