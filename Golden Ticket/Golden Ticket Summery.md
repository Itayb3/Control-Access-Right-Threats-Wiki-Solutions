Golden Ticket Attack   
The Golden Ticket Attack is a type of Kerberos ticket forgery attack.   
It exploits the Kerberos authentication protocol used by Windows Active Directory (AD) environments.  

Mechanism:   
Kerberos uses a ticket-granting ticket (TGT) to validate authenticated users.   
When users authenticate, they receive a TGT, which is then used to obtain service tickets for specific services within the network.   
This TGT is encrypted using the secret key of the Kerberos Key Distribution Center (KDC), specifically the account named KRBTGT.   

Exploitation:   
If an attacker gains access to this KRBTGT account's secret key (often through techniques like privilege escalation or obtaining domain administrator rights), they can forge their own TGTs.   
This forged TGT is often called a "Golden Ticket".   

Impact:   
With a Golden Ticket, an attacker can grant themselves any privilege they want within the AD environment, including Domain Administrator rights.
They can also generate service tickets for any service, effectively bypassing typical access controls.   
The malicious activity can go unnoticed because the attacker is using a seemingly valid TGT.   

Persistence:   
The power of the Golden Ticket lies in its longevity and stealth.   
Even if an attacker's other footholds in a network are detected and removed, as long as the KRBTGT account's secret key hasn't been changed and the ticket hasn't expired, they can maintain access.

Mitigation:   
To protect against this, organizations should frequently rotate the KRBTGT account's secret key, employ strict access controls to prevent unauthorized domain-level access, monitor for anomalous authentication patterns, and implement advanced threat detection solutions
that can identify Golden Ticket usage.

