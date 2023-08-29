Kerberoasting Summary:

Background:

Kerberoasting is a technique attackers use to extract service account credentials from the Windows operating system using the Kerberos authentication protocol.
Kerberos is designed to authenticate users and services in a network.
Service accounts are associated with Service Principal Names (SPNs).
Once a user has a valid Kerberos Ticket Granting Ticket (TGT), they can request service tickets for any SPN. These tickets are encrypted with the NTLM hash of the service account that runs the service related to the SPN.
The Kerberoasting attack focuses on requesting these tickets and then trying to decrypt them offline to obtain the service account's plaintext password.

Attack Mechanics:

1.Attacker obtains a valid Kerberos TGT (this often requires no special privileges).

2.Attacker requests service tickets for all available SPNs.

3.These service tickets are encrypted with the service account's NTLM hash.

4.The attacker exports these tickets and tries to crack them offline using brute-force or dictionary attacks.

Defense & Mitigation:

1.Strong Passwords:

Ensure that service account passwords are complex and lengthy to resist brute-force attacks.

2.Regularly Rotate Passwords:

Change the passwords for service accounts regularly.

3.Monitor for Anomalies:

Use monitoring solutions to detect abnormal Kerberos ticket requests. Multiple ticket requests in a short period can indicate an attack.

4.Account Privileges:

Limit service account permissions. Avoid using high-privilege accounts for services unless necessary.

5.Ticket Encryption:

Use stronger encryption methods for Kerberos tickets

Detection:

Logs in Windows event IDs can be useful in detecting Kerberoasting.
Monitoring for large numbers of TGS (Ticket Granting Service) requests (especially for unique SPNs) in a short time frame can be indicative of an attack.
                                                                                                                                            
Implications:

If Kerberoasting is successful, attackers gain access to the plaintext password of the service account.
This can lead to lateral movement within the network, escalation of privileges (if the service account has high privileges), and further compromise of network resources.

Conclusion:

Kerberoasting is a potent attack technique against the Windows ecosystem that targets service accounts via the Kerberos authentication protocol.
While the attack requires knowledge and specific tools, defenses against it are straightforward and revolve around robust security practices, monitoring, and education.
