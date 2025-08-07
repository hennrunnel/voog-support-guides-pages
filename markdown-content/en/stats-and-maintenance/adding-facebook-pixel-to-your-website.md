---
title: Setting UpFacebook Pixel
lang: en
section: stats-and-maintenance
slug: adding-facebook-pixel-to-your-website
original_url: https://www.voog.com/support/stats-and-maintenance/adding-facebook-pixel-to-your-website
updated_at: 2025-08-07T21:25:01Z
word_count: 462
---
## **Setting Up****Facebook Pixel**

1. Go to [Events Manager](https://www.facebook.com/events_manager2/) on Facebook.
2. Locate the green **Connect Data Sources** button on the left sidebar and click it.
3. In the pop-up window, select **Web**.
4. Name your Facebook Pixel, e.g., "[name of your website]'s Pixel".
5. Enter your website's URL into the input box. Ensure you use the correct format, such as *https://example.com*, and not *https://example.voog.com* or *https://www.example.com*. Note that an [SSL certificate](/support/your-website-addresses/ssl-certificate) is required for your domain name.
6. Click **Continue**.

## **Connecting**Facebook Pixel****to Your Voog Website****

1. Head back to your [Events Manager](https://www.facebook.com/events_manager2/) on Facebook.
2. Choose the desired Facebook Pixel from the list for your website.
3. Click **Continue Pixel Setup**.
4. Opt for **Install code manually**.
5. Copy the provided Facebook Pixel code (keep the Events Manager open for now). The code should resemble the following:  
   `<!-- Facebook Pixel Code -->
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
   <!-- End Facebook Pixel Code -->`
6. On your Voog website, navigate to **Settings > Site** and paste the code into the **Header code** area.
7. In the Facebook Events Manager, click **Continue** until the pop-up closes.

Congratulations! You have successfully learned how to add Facebook Pixel to your website. Your Pixel is now active and monitoring traffic on your site. To further enhance its capabilities, configure the [PageView](https://developers.facebook.com/docs/facebook-pixel/implementation/#installing-the-pixel) [event](https://developers.facebook.com/docs/facebook-pixel/implementation/#installing-the-pixel) through the Events Manager.

To enable tracking of shopping cart activities, add an additional script to your website by following the [Tracking shopping cart events in Voog](/developers/scripting/ecommerce/tracking-shopping-cart-events) guide. Copy the corresponding code to the **Settings > Site > Header code** area alongside the existing Facebook Pixel code.

**Important Notice: When adding Facebook to your website or any third-party widgets that collect user data, you must inform your visitors. Check out our guide on cookie notifications** [**here**](/support/stats-and-maintenance/cookies-notification)**.**
