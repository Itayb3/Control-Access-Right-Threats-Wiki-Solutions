one way to approad the issue would be setting the right policy to harden the network for such attack.     
Therefore i suggest:     
1. Limiting and Monitoring Privileged Access     
    Using the "Least Privilege" tactic:     
     Granting the minimum required privileges for any task. Most users (including IT personal) don't need domain-level access.     
    Regular Audits:     
     Review group memberships for privileged groups in Active Directory (e.g., Domain Admins, Enterprise Admins).        
    Two-Factor Authentication:     
     Require 2FA for administrative tasks, especially for accessing the domain controller and critical servers.     
   
2. Protecting Domain Controllers     
    Add Segmentation:     
     Ensure Domain Controllers (DC) are isolated in a dedicated network segment.     
    Patch & Update:     
     Regularly update and patch DCs. Ensure they are running the latest OS versions and security patches.     
     This might seem pointless but nonetheless it helps.     
    Monitoring:     
     Implement monitoring tools to alert for suspicious activity on DCs.     

3. Strengthen Kerberos Protocol Configuration     
    Stronger Encryption:     
     Use the strongest available encryption for Kerberos tickets.     
    Shorter Ticket Lifetimes:     
     Reduce the lifetime of TGTs. While this might mean more frequent authentications, it limits the window an attacker can use a Golden Ticket.     
     *Please note that shorter ticket life time can and will harm the user experiance if not handeled correctly.     
   
4. Rotate KRBTGT Account's Secret Key     
    Regular Rotation:     
     Frequently change the KRBTGT account's secret key.     
     Note: This can invalidate all current TGTs, so plan rotations carefully in order to ensure no services etc. harmed and will cause down-time.     
   
5. Backup & Restore     
    Backup: Regularly back up the Active Directory database.     
    I suggest to preform tests frequently on existing backups to ensure that, in time of need, they will work.     

But at the end of the day,     
The Golden Ticket Attack is a "post-exploitation technique".    
By the time an attacker is in a position to use it, they've already compromised a significant part of the network.     
and youll need to deal with fixing the other issues first.     
but after you finish cleaning up the initial mess there are a few things you can do.     
Once done, I suggest changing every existing hash,and invalidating all existing TGTs in order to insure there arent any "golden tickets" left around.     
This can be achieved by changing the KRBTGT account password and either Wait for the default Kerberos ticket lifetime (typically 10 hours) or force all users to log off and log back in.
while also looking into using a backup version or at least checking for any changes made compared to it.


