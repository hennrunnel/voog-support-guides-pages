# Use your existing domain with Voog

**Section:** Domains  
**Language:** en  
**Original URL:** https://www.voog.com/support/your-website-addresses/using-your-already-existing-domain.html  
**Extracted:** 2025-08-05 07:49:03 UTC

---

Moving Your Web Address to Voog
After subscribing to Voog, you can move your web address (e.g. mycompany.com, mycompany.co.uk) to Voog to display your website.
If you purchased the domain from another registrar, import it to your Voog account and direct the A-record to Voog's server IP address 85.222.234.14.
Connect Your Existing Website Domain to Your Voog Website
First, you must link your domain name to your Voog website. Doing this ensures that our system correctly identifies which site to display when someone visits yourdomain.com. Follow these simple steps:
Log into your Voog website and navigate to Settings > Domains.
Click the Add new button, select Import and enter your website domain without the www-prefix (e.g., write example.com instead of www.example.com). The www-prefix will be recognized automatically.
Update Your DNS Records to Move Domain
After linking your website domain to your Voog website, it's time to modify the DNS records in your domain registrar's management system.
Log into your domain registrar's management system.
Look for options to edit your domain's DNS settings, often found under "Name Server (DNS)" or "Advanced DNS management." Choose options like "IP Forwarding" or "Modifying an A-record."
Update your domain's A-record to Voog's server IP address: 85.222.234.14. Exclude the www-prefix when adding the domain name (e.g., example.com).
Create a new CNAME record for your www-domain: set the type to CNAME, the value to example.com, and the name to www.example.com.
This process will help you successfully move your domain and use the custom domain for your website.Your CNAME and A-record should now look something like this:NAMETYPEVALUEexample.comA85.222.234.14www.example.comCNAMEexample.com
Note: Changing your A-record may take up to 48 hours to propagate across the internet, depending on your domain's TTL (time to live) settings.Modify DNS Settings for Popular Registrars
GoDaddy and WildWestDomains
Log in to GoDaddy or WildWestDomains.
In the main menu, click Domains and then My Domain Names.
Click on the address you wish to edit.
Click on the link Total DNS Control and MX Records.
Delete any existing A-record and create two new ones:
For the first A-record, set the host to @ and the IP address to 85.222.234.14.
For the second A-record, set the host to www and the IP address to 85.222.234.14.
Verify that you've entered the domain correctly in Voog under Settings > Domains, where you can also click on the Import option to add your domain.
Enom
Log in to your Enom account.
Click on the name of the web address you want to update.
Select the Dynamic DNS link.
Enter the following information:
Hostname: @
Address: 85.222.234.14
Record Type: A (Address)
Click Save Settings for the changes to take effect.
Verify that you've entered the domain correctly in Voog under Settings > Domains, where you can also click on the Import option to add your domain.
Register.com
Log in to your Register.com account.
Click Manage Your Account.
Click on the web address you want to update.
Scroll down to Advanced Technical Settings and click Edit IP Address Records.
Edit the A-record for both * and @ by setting both fields to 85.222.234.14.
Click Continue.
Confirm the changes, which should look like this:
* points to 85.222.234.14
@ points to 85.222.234.14
Click Continue again to finalize your settings.
Verify that you've entered the domain correctly in Voog under Settings > Domains, where you can also click on the Import option to add your domain.

---

*This content was extracted from Voog's support documentation for AI-friendly processing.*
