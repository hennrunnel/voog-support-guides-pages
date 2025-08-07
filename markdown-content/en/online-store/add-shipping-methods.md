---
title: Shipping methods
lang: en
section: online-store
slug: add-shipping-methods
original_url: https://www.voog.com/support/online-store/add-shipping-methods
updated_at: 2025-08-07T21:25:01Z
word_count: 1471
---
## Shipping methods

Open **Store > Settings** in the bottom toolbar and go to **Shipping**.

![Settings for adding a new shipping method.](https://media.voog.com/0000/0036/2183/photos/add_shipping_method_2023_block.png "Settings for adding a new shipping method.")

## Shipping Settings

Here are the settings you can adjust:

- **Name:** this is the name of your shipping method, which will be displayed to customers at checkout (for example, Omniva, Smartpost pick-up points in Estonia or Pick up your Parcel Yourself).
- **Enabled:** this setting indicates whether the delivery method is active and visible to the purchaser at checkout.
- **Description:** this text will appear under the shipping method in the checkout.
- **Net price:** this is the price of the shipping method, excluding VAT. The shipping price, including VAT, is calculated automatically when both Net price and VAT% fields are filled.
- **Reduced price:** this is the net discount price of shipping, which is applied when the net amount of the shopping cart exceeds a specific value. For example, set the reduced price as 0 to offer free shipping
- **Minimum shopping cart value:** this is the minimum net amount of the shopping cart from which the discounted price is applied to the shipping. For example, if you have set free shipping in the Reduced price field, the minimum value of the shopping cart is 50€, and the VAT rate is 20%, then free delivery will apply to the customer from the gross amount of 60€.
- **Delivery method:** this allows you to select Omniva, DPD, or Smartpost pick-up points. The selected pick-up points will be shown in the order summary, and the latest list of pick-up points from the respective service provider will be available to the customer at checkout.
- ![Selecting a delivery method.](https://media.voog.com/0000/0036/2183/photos/select_delivery_method_block.png "Selecting a delivery method.")
- ****Locations:** the customer will see pick-up points of the country specified here.**
- ![Selecting the country of pick-up points.](https://media.voog.com/0000/0036/2183/photos/select_delivery_location_block.png "Selecting the country of pick-up points.")

  **Options:** this text field allows you to add additional options. For example, you can specify delivery times for a courier service. This field is only available if the **Delivery method** is **Custom**.
- ****Enable API**:** leave these fields blank if you do not want automatic data exchange. Enable automatic data exchange to consign orders to Omniva, DPD or SmartPosti automatically and download shipping labels directly from Voog.

![Cursor on the 'Enable API' button.](https://media.voog.com/0000/0036/2183/photos/shipping_enable_API_block.png "Cursor on the 'Enable API' button.")

## Shipping method options

When you add a shipping method, it will be available to customers as a menu at checkout. There are two ways to add more specific options that appear as drop-down menus to each shipping mode. This is not mandatory, and you can also cancel the options – for example, the shipping mode ***pick up*** ***your*** ***parcel yourself***.

1. **Manually entered options.** Select **Custom** as the **Delivery method,** and in the **Options**text area, enter one option to be displayed to the customer for each line. In the order summary, you will also be shown the customer's choice.
2. **An automatically updated list of pick-up points**

- Omniva pick up points in Estonia, Latvia, and Lithuania
- DPD pick-up points in Estonia, Latvia, and Lithuania
- Smartpost pick-up points in Estonia, Latvia, Lithuania, and Finland

By selecting Omniva, DPD, or Smartpost pick-up points, the customer will always see the latest list of pick-up points of the respective service provider as an option in the checkout.  

## Adding a “Pick up your Parcel Yourself" shipping

If the customer chooses to pick up the parcel, you can conveniently hand over your online store purchases from a convenient place. Here's how to add the "Pick up your parcel yourself" shipping method:

1. Click the **Add new shipping method** button.
2. In the **Add shipping method** dialog box, write "Pick up your parcel yourself" in the **Name** field.
3. In the **Description** field, write additional text/address where you can pick up the parcel — it will be displayed in the checkout under the "Pick up your parcel yourself" shipping method.
4. In the **Pricing** section, enter 0 in the **Net price** field. This ensures that the shipping fee is not added to the item.
5. Click the **Save** button.

![Settings of a custom shipping method.](https://media.voog.com/0000/0036/2183/photos/shipping_method_pick-up_block.png "Settings of a custom shipping method.")

## Adding courier shipping

If you want to offer courier shipping where buyers can choose the delivery time, you can do so with manual options. Note that at the moment, we do not have the integration of courier services, and you have to take care of shipping the parcel after receiving the order.

1. Click the **Add new shipping method** button.
2. In the **Add shipping method** dialog box, write "Courier within Estonia" in the Name field.
3. In the **Description** field, write additional text — it will be displayed in the checkout under the shipping.
4. Enter the shipping price in the **Net price** field.
5. Leave **Delivery method** Custom as selection.
6. In the **Options** field, add the **appropriate periods** (e.g. 9.00-17.00 or 17.00-21.00) to receive the package on different lines.
7. Click the **Save** button.

![Example of delivery options.](https://media.voog.com/0000/0036/2183/photos/delivery_options_block.png "Example of delivery options.")

## Adding Pick-up points

To offer the delivery of online store goods, the DPD, Smartpost, or Omniva pick-up points should operate as follows:

1. Click the **Add new shipping method** button.
2. In the **Name** field, enter the name of the shipping method to be displayed to the desired customer, for example, "Omniva pick-up points".
3. In the **Description** field, write additional text — it will be displayed in the checkout under the shipping.
4. Enter the shipping price in the **Net price** field.
5. In the **Delivery method** menu, select the service provider you want.
6. From the **Location** menu, select the pick-up points for the country you want to display to the customer under this shipping method.
7. **Enable API** – leave these fields blank if you do not want automatic data exchange. Enable automatic data exchange to automatically consign orders to Omniva, DPD or SmartPosti and download shipping labels directly from Voog. For more information, check out [automatic data exchange with Omniva](/support/online-store/automatic-data-exchange-with-omniva), [automatic data exchange with DPD](/support/online-store/automatic-data-exchange-with-dpd), and [automatic data exchange with SmartPosti.](/support/online-store/automatic-data-exchange-with-itella)
8. Click the **Save** button.

![Settings for Omniva pick-up points delivery method.](https://media.voog.com/0000/0036/2183/photos/add_pick-up_points_block.png "Settings for Omniva pick-up points delivery method.")

## Set up a discount price or free transport for shipping

If you want to offer customers a shipping price discount or free shipping from the amount of a particular cart, do the following:

1. Click on the shipping method or add a new shipping method to which you want to add a shipping price discount.
2. In the dialog box that opens, enter the discount price in the **Reduced price** field (0 for free shipping).
3. In the field **Minimum shopping cart value**, enter the net amount of the shopping cart, from which the discounted shipping price will be applied.

**Note:** a discount price and free shipping are the net amounts in the shopping cart, i.e. the total amount of the products before taxes are added. For example, if you want orders totalling more than €60 to have discount shipping, enter the minimum value in the shopping cart at €50 (with a 20% tax rate).

![Example of discounts for a delivery method.](https://media.voog.com/0000/0036/2183/photos/shipping_discount_block.png "Example of discounts for a delivery method.")

## Deleting a shipping method

You can delete the added shipping method by clicking the shipping method button, after which the Edit shipping method dialog box opens. In the bottom-right corner, there is a trash can icon. By clicking on this, you can altogether remove the shipping method. You can also turn off the shipping method to hide it in the checkout by de-selecting the **Enabled** button.

![Cursor on the trash bin icon to delete a delivery method.](https://media.voog.com/0000/0036/2183/photos/delete_shipping_method_block.png "Cursor on the trash bin icon to delete a delivery method.")

### Read more about automatic data exchange:

[Automatic data exchange with Omniva](/support/online-store/automatic-data-exchange-with-omniva)[Automatic data exchange with DPD](/support/online-store/automatic-data-exchange-with-dpd)  
[Automatic data exchange with SmartPosti](/support/online-store/automatic-data-exchange-with-itella)
