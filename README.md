<p>During the In Flight Cancellation journey, a request should be sent to downstream system for initiating the return of devices provisioned to the customer. Once the return is initiated, activity tracking is done in downstream system to track the return. The activity tracking request for each of the device is sent from Salesforce.</p><br>
Technical Challenges<br>
-> Provisioning orchestration plan is linked to root technical product, therefore rollback plan will also be linked to same technical product.<br>
-> Due to downstream limitations, it is required to send one single request for each of child products under technical Root product.<br>
-> Business also wants to track each request in Salesforce so we can’t have single callout item sending all the requests.<br>
-> Each of the commercial device has its own technical decomposition and a separate request should be for each technical product in rollback plan.<br><br>

In Classes, NG_ActivityCreationItem apex is used to handle the logic. <br>
InFlight_CancellationScenario IP uses DRE_GetChildCPEFrls dataraptor to fetch all the child FRLs from the parent FRL (linked to orchestration item) and then calls the apex.
