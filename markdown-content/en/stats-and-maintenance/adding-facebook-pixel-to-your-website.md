# Add Facebook Pixel to your website

**Section:** Stats & Maintenance  
**Language:** en  
**Original URL:** https://www.voog.com/support/stats-and-maintenance/adding-facebook-pixel-to-your-website.html  
**Extracted:** 2025-08-05 07:49:01 UTC

---

Setting Up Facebook Pixel
Go to Events Manager on Facebook.
Locate the green Connect Data Sources button on the left sidebar and click it.
In the pop-up window, select Web.
Name your Facebook Pixel, e.g., "[name of your website]'s Pixel".
Enter your website's URL into the input box. Ensure you use the correct format, such as https://example.com, and not https://example.voog.com or https://www.example.com. Note that an SSL certificate is required for your domain name.
Click Continue.
Connecting Facebook Pixel to Your Voog Website
Head back to your Events Manager on Facebook.
Choose the desired Facebook Pixel from the list for your website.
Click Continue Pixel Setup.
Opt for Install code manually.
Copy the provided Facebook Pixel code (keep the Events Manager open for now). The code should resemble the following:<!-- Facebook Pixel Code -->
<script>
!function(f,b,e,v,n,t,s)
{if(f.fbq)return;n=f.fbq=function(){n.callMethod?
n.callMethod.apply(n,arguments):n.queue.push(arguments)};
if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
n.queue=[];t=b.createElement(e);t.async=!0;
t.src=v;s=b.getElementsByTagName(e)[0];
s.parentNode.insertBefore(t,s)}(window, document,'script',
'https://connect.facebook.net/en_US/fbevents.js');
fbq('init', '{your-pixel-id-goes-here}');
fbq('track', 'PageView');
</script>
<noscript>
<img height="1" width="1" style="display:none"
src="https://www.facebook.com/tr?id={your-pixel-id-goes-here}&ev=PageView&noscript=1"/>
</noscript>
<!-- End Facebook Pixel Code -->
On your Voog website, navigate to Settings > Site and paste the code into the Header code area.
In the Facebook Events Manager, click Continue until the pop-up closes.
Congratulations! You have successfully learned how to add Facebook Pixel to your website. Your Pixel is now active and monitoring traffic on your site. To further enhance its capabilities, configure the PageView event through the Events Manager.
To enable tracking of shopping cart activities, add an additional script to your website by following the Tracking shopping cart events in Voog guide. Copy the corresponding code to the Settings > Site > Header code area alongside the existing Facebook Pixel code.
Important Notice: When adding Facebook to your website or any third-party widgets that collect user data, you must inform your visitors. Check out our guide on cookie notifications here.

---

*This content was extracted from Voog's support documentation for AI-friendly processing.*
