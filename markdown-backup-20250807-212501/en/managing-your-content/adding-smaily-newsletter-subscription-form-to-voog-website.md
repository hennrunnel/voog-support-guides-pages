# Add a Smaily newsletter subscription form to your website

**Section:** Content Management  
**Language:** en  
**Original URL:** https://www.voog.com/support/managing-your-content/adding-smaily-newsletter-subscription-form-to-voog-website.html  
**Extracted:** 2025-08-05 07:49:01 UTC

---

Adding a landing page form with a buttonYou can create a newsletter form using the Smaily landing pages tool. Learn how to create a form on a landing page here.Navigate to the page where you wish to add the newsletter subscription button.Add a new content area with the type of Text.
In the text field, write the text you want on the button, e.g. "Sign up for the newsletter".Select the text you want on the button and click the text formatting button (¶) in the text editor.
Choose Button from the drop-down menu.The text will be converted to a button. Click on the button and add the landing page URL in place of #.
Save the changes. If you click Preview in the bottom right corner, you can check if the button directs you to the correct landing page.Adding a landing page form by iframeNavigate to the page you wish to add the newsletter subscription form toAdd a new content area with the type of Text.
Click on the HTML source button (</>) in the text editor menu.
Copy the code below and insert your landing page URL<iframe src=”LANDING_PAGE_URL” title=”Sign up for newsletter”></iframe>Click on Update. The newsletter form should now be added to the page.
You can adjust the size of the iframe by dragging the little dots on the bordersSave the changes. If you click Preview in the bottom right corner, you can check if the button directs you to the correct landing page.Adding a newsletter subscription form with an opt-in codeIf you wish to add the newsletter subscription form directly to your webpage without using iframes and landing pages, you can also use Smaily’s HTML opt-in example code.You can add the form using:The content area with the type of Embed.
Through text content area's </> option.
The code of the form with default styles:<form action="https://<domain>.sendsmaily.net/api/opt-in/" method="post" autocomplete="off">  <div style="display:none">    <input type="hidden" name="key" value="XDcsks...3sz" />    <input type="hidden" name="autoresponder" value="1" />    <input type="hidden" name="source" value="web" />    <input type="hidden" name="success_url" value="http://www.domeen.ee/ok" />    <input type="hidden" name="failure_url" value="http://www.domeen.ee/error" />    <input type="text" name="re-email" value="" />  </div>  <div class="form_area"><div class="form_fields">
<div class="form_field form_field_required  ">  <label class="form_field_label" for="email">E-mail</label>  <input class="form_field_textfield form_field_size_medium" name="email" type="email" value="" /></div><div class="form_field">  <label class="form_field_label" for="name">Nimi</label>  <input class="form_field_textfield form_field_size_medium" name="name" type="text" value="" /></div></div>   <div class="form_submit">     <input class="form_submit_input" name="commit" type="submit" value="Liitu" />   </div>  </div></form>You can see the required parameters here.

---

*This content was extracted from Voog's support documentation for AI-friendly processing.*
