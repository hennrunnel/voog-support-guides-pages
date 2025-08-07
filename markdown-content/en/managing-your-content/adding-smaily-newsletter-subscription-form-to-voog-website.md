---
title: Adding a landing page form with a button
lang: en
section: managing-your-content
slug: adding-smaily-newsletter-subscription-form-to-voog-website
original_url: https://www.voog.com/support/managing-your-content/adding-smaily-newsletter-subscription-form-to-voog-website
updated_at: 2025-08-07T21:25:01Z
word_count: 784
---
## Adding a landing page form with a button

You can create a newsletter form using the [Smaily](https://smaily.com/help/how-to/forms-subscriptions/adding-smaily-newsletter-subscription-form-to-voog-website/) landing pages tool. Learn [how to create a form on a landing page here](https://smaily.com/help/user-manual/landing-pages/creating-a-form-on-a-landing-page/).  
  

1. Navigate to the page where you wish to add the newsletter subscription button.
2. Add a new content area with the type of **Text**.
3. ![Cursor pointing at 'Text' in the content area selection.](https://media.voog.com/0000/0036/2183/photos/Text_content_area_2_block.webp "Cursor pointing at 'Text' in the content area selection.")

   In the text field, write the text you want on the button, e.g. "Sign up for the newsletter".
4. Select the text you want on the button and click the text formatting button (¶) in the text editor.
5. ![Cursor pointing at the 'Button' option in the drop-down menu of text formatting icon.](https://media.voog.com/0000/0036/2183/photos/Button_text_style_block.webp "Cursor pointing at the 'Button' option in the drop-down menu of text formatting icon.")

   Choose **Button** from the drop-down menu.
6. The text will be converted to a button. Click on the button and add the landing page URL in place of **#**.
7. ![Entering the landing page URL of the button.](https://media.voog.com/0000/0036/2183/photos/Linking_a_button_block.webp "Entering the landing page URL of the button.")

   Save the changes. If you click **Preview** in the bottom right corner, you can check if the button directs you to the correct landing page.

## Adding a landing page form by iframe

1. Navigate to the page you wish to add the newsletter subscription form to
2. Add a new content area with the type of **Text**.
3. ![Cursor pointed at 'Text' in the new content area selection.](https://media.voog.com/0000/0036/2183/photos/Text_content_area_2_block.webp "Cursor pointed at 'Text' in the new content area selection.")

   Click on the HTML source button (**</>**) in the text editor menu.  

   ![Cursor pointed at the 'Edit HTML source' button in the text toolbar.](https://media.voog.com/0000/0036/2183/photos/Html_source_button_block.webp "Cursor pointed at the 'Edit HTML source' button in the text toolbar.")
4. Copy the code below and insert your landing page URL  

   ```
   <iframe src=”LANDING_PAGE_URL” title=”Sign up for newsletter”></iframe>
   ```
5. Click on **Update**. The newsletter form should now be added to the page.
6. ![A code inserted to the embed code area.](https://media.voog.com/0000/0036/2183/photos/Code_in_html_source_window_block.webp "A code inserted to the embed code area.")

   You can adjust the size of the iframe by dragging the little dots on the borders
7. Save the changes. If you click **Preview** in the bottom right corner, you can check if the button directs you to the correct landing page.

## Adding a newsletter subscription form with an opt-in code

If you wish to add the newsletter subscription form directly to your webpage without using iframes and landing pages, you can also use Smaily’s HTML opt-in example code.  
  
You can add the form using:  

1. The content area with the type of **Embed**.
2. ![Cursor pointed at the' Embed code' button in new content area selection.](https://media.voog.com/0000/0036/2183/photos/Embed_content_area-1_block.webp "Cursor pointed at the' Embed code' button in new content area selection.")

   Through text content area's **</>** option.  

   ![Cursor pointed at the 'Edit HTML source' button.](https://media.voog.com/0000/0036/2183/photos/Html_source_button_block.webp "Cursor pointed at the 'Edit HTML source' button.")

   **The code of the form with default styles:**

```
<form action="https://<domain>.sendsmaily.net/api/opt-in/" method="post" autocomplete="off">  
  <div style="display:none">  
    <input type="hidden" name="key" value="XDcsks...3sz" />  
    <input type="hidden" name="autoresponder" value="1" />  
    <input type="hidden" name="source" value="web" />  
    <input type="hidden" name="success_url" value="http://www.domeen.ee/ok" />  
    <input type="hidden" name="failure_url" value="http://www.domeen.ee/error" />  
    <input type="text" name="re-email" value="" />  
  </div>  
  <div class="form_area">  
<div class="form_fields">

![](https://media.voog.com/0000/0036/2183/photos/smaily-eng-2_block.png)

  
<div class="form_field form_field_required  ">  
  <label class="form_field_label" for="email">E-mail</label>  
  <input class="form_field_textfield form_field_size_medium" name="email" type="email" value="" />  
</div>  
<div class="form_field">  
  <label class="form_field_label" for="name">Nimi</label>  
  <input class="form_field_textfield form_field_size_medium" name="name" type="text" value="" />  
</div>  
</div>  
   <div class="form_submit">  
     <input class="form_submit_input" name="commit" type="submit" value="Liitu" />  
   </div>  
  </div>  
</form>
```

  
You can see the required parameters [here](https://smaily.com/help/user-manual/integrations-et/an-example-of-a-signup-form/).
