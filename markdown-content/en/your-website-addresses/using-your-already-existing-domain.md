---
title: Moving Your Web Address to Voog
lang: en
section: your-website-addresses
slug: using-your-already-existing-domain
original_url: https://www.voog.com/support/your-website-addresses/using-your-already-existing-domain
updated_at: 2025-08-07T21:25:01Z
word_count: 706
---
## Moving Your Web Address to Voog

After subscribing to [**Voog**](/pricing), you can move your web address (e.g. *mycompany.com*, *mycompany.co.uk*) to Voog to display your website.

If you purchased the domain from another registrar, import it to your Voog account and direct the A-record to Voog's server IP address **85.222.234.14**.

## Connect Your Existing Website Domain to Your Voog Website

First, you must link your domain name to your Voog website. Doing this ensures that our system correctly identifies which site to display when someone visits *yourdomain.com*.  
  
 Follow these simple steps:  
  

1. Log into your Voog website and navigate to **Settings > Domains**.

   ![Cursor on the 'Import' button in domains menu.](https://media.voog.com/0000/0036/2183/photos/Importing_a_domain_block.webp "Cursor on the 'Import' button in domains menu.")
2. Click the **Add new** button, select **Import** and enter your website domain without the **www**-prefix (e.g., write *example.com* instead of *www.example.com*). The **www**-prefix will be recognized automatically.

## Update Your DNS Records to Move Domain

After linking your website domain to your Voog website, it's time to modify the DNS records in your domain registrar's management system.

1. Log into your domain registrar's management system.
2. Look for options to edit your domain's DNS settings, often found under "Name Server (DNS)" or "Advanced DNS management." Choose options like "IP Forwarding" or "Modifying an A-record."
3. Update your domain's **A-record** to Voog's server IP address: **85.222.234.14**. Exclude the **www**-prefix when adding the domain name (e.g., example.com).
4. Create a new **CNAME** record for your **www**-domain: set the type to CNAME, the value to *example.com*, and the name to *www.example.com*.

This process will help you successfully move your domain and use the custom domain for your website.

Your CNAME and A-record should now look something like this:

|  |  |  |
| --- | --- | --- |
| **NAME** | **TYPE** | **VALUE** |
| example.com | A | 85.222.234.14 |
| www.example.com | CNAME | example.com |

  

**Note: Changing your A-record may take up to 48 hours to propagate across the internet, depending on your domain's TTL (*time to live*) settings.**

## Modify DNS Settings for Popular Registrars

### GoDaddy and WildWestDomains

1. Log in to [GoDaddy](https://www.godaddy.com/) or [WildWestDomains](https://www.wildwestdomains.com/).
2. In the main menu, click **Domains** and then **My Domain Names**.
3. Click on the address you wish to edit.
4. Click on the link **Total DNS Control and MX Records**.
5. Delete any existing A-record and create two new ones:

   - For the first A-record, set the host to **@** and the IP address to **85.222.234.14**.
   - For the second A-record, set the host to **www** and the IP address to **85.222.234.14**.
6. Verify that you've entered the domain correctly in Voog under **Settings > Domains**, where you can also click on the **Import** option to add your domain.

### Enom

1. Log in to your [Enom](https://www.enom.com/Login.asp) account.
2. Click on the name of the web address you want to update.
3. Select the **Dynamic DNS** link.
4. Enter the following information:

   - Hostname: **@**
   - Address: **85.222.234.14**
   - Record Type: **A (Address)**
5. Click **Save Settings** for the changes to take effect.
6. Verify that you've entered the domain correctly in Voog under **Settings > Domains**, where you can also click on the **Import** option to add your domain.

### Register.com

1. Log in to your [Register.com](https://www.register.com/myaccount/productdisplay.rcmx) account.
2. Click **Manage Your Account**.
3. Click on the web address you want to update.
4. Scroll down to **Advanced Technical Settings** and click **Edit IP Address Records**.
5. Edit the A-record for both ***** and **@** by setting both fields to **85.222.234.14**.
6. Click **Continue**.
7. Confirm the changes, which should look like this:

   - ***** points to **85.222.234.14**
   - **@** points to **85.222.234.14**
8. Click **Continue** again to finalize your settings.
9. Verify that you've entered the domain correctly in Voog under **Settings > Domains**, where you can also click on the **Import** option to add your domain.
