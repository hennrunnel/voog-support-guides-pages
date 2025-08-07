---
title: View your orders
lang: en
section: online-store
slug: manage-your-orders
original_url: https://www.voog.com/support/online-store/manage-your-orders
updated_at: 2025-08-07T21:25:01Z
word_count: 1456
---
## View your orders

You can see and manage your orders when you open **Store > Orders**. If you’ve inserted the **Store notification email address** upon [setting up your store](/support/online-store/add-online-store) you’ll also receive email notifications for each new order.  

![Orders view in admin panel.](https://media.voog.com/0000/0036/2183/photos/Manage_your_orders1_block.jpg "Orders view in admin panel.")

The general orders view gives you basic information about each order, such as in the image above. Click on any order to see more information about it. This includes **billing** and **shipping** information and **order details**, which lists all ordered items and their prices.  

![View of order details.](https://media.voog.com/0000/0036/2183/photos/billing%20shipping%20information%202023_block.png "View of order details.")

## Updating orders

You can modify the following information for customer orders:

- **Billing Information**: Update the contact details entered during the checkout process. Note that if the shipping information uses the same details entered during checkout, making changes here will not affect the shipping information.
- **Shipping Information**: Change the shipping address or parcel machine selection. However, you cannot modify the shipping method.
- **Note**: Add or edit notes related to the order.

To make these changes, navigate to the order details page and look for the **Edit** button next to each relevant section. Clicking on this button will open a panel on the right side of the screen, where you can make the necessary adjustments.

![Shipping information form with cursor pointing at "shipping method option" field.](https://media.voog.com/0000/0036/2183/photos/update%20order%202023_block.png "Shipping information form with cursor pointing at \"shipping method option\" field.")

## Filtering and export

Use the **Filter** button on the upper right corner of the orders view to display orders based on specific criteria.   
  
You can filter orders by date, sum, payment and shipping status and by customer’s name or e-mail. It’s also possible to filter by whether or not the orders are archived. We'll get back to archiving below.

![Cursor pointing at 'Filter' button in orders menu.](https://media.voog.com/0000/0036/2183/photos/Manage_your_orders3_block.jpg "Cursor pointing at 'Filter' button in orders menu.")

By clicking **the three dots** beside the **Filter** button, you can download your orders in **XLS** or **CSV** format. In addition, you can choose **CSV with items** in which case individual products are listed in separate rows. If you prefer, you can export only selected orders by applying filters first or ticking the boxes of the desired orders.

## Archive your old orders

It's a good idea to archive your old orders so they don't clutter your order list view. **NB! You can’t delete your orders.** That’s because you may need to look up an old order and by archiving, you’ll always have access to them.

![Cursor pointing at 'Archive' in order options menu.](https://media.voog.com/0000/0036/2183/photos/Manage_your_orders4_block.jpg "Cursor pointing at 'Archive' in order options menu.")

To archive an order, simply click the three dots at the end of the row and select **Archive**. To view archived orders, use filtering. You can also unarchive orders at any time by selecting **Unarchive** by the three dots.

## Order statuses

To better keep track of your orders you can use different statuses to indicate the progress of each order. Note that order status also affects [inventory management](/support/online-store/inventory-management-in-your-webstore) of the products in the order. To manage your orders more efficiently we’ve separated payment and shipping statuses.

## Payment statuses:

- **Unpaid** – the order has been placed by the customer but it isn't paid yet. Generally, this status is only necessary for offline payments, since with other payment methods the payment is made during checkout. An order paid through a bank link or with a credit card is in **Unpaid** status until the payment is completed. If it stays in that status, it’s most likely caused by a redirecting error between bank and merchant or the customer has abandoned the order halfway through payment. **NB! Orders paid with an offline invoice need to be manually changed to "Paid" because the customer makes a payment directly to your bank account and Voog doesn't get notified of this.**
- **Paid** – the order has been placed and is paid. **NB! When an order is placed the products are “booked”, regardless of whether the order is in “Unpaid” or “Paid” status.**
- **Pending** – this status is displayed for payments with a bank link or a credit card when the initial validation for the payment is completed. You can also use this status for orders with offline invoice as needed.
- **Cancelled** – this status you can also apply yourself in cases when a customer has requested to cancel their order or when you choose to cancel an unpaid order that you consider overdue. Cancelling an order removes the “booking” and the “booked” products become available again.

![Cursor pointing at 'Paid' option of payment status.](https://media.voog.com/0000/0036/2183/photos/Manage_your_orders5_block.jpg "Cursor pointing at 'Paid' option of payment status.")

## Shipping statuses:

- **Not fulfilled** – by default the shipping status of a new order is **Not fulfilled**.
- **Fulfilled** – once you’ve shipped an order you can change it to **Fulfilled**. This removes the “booking” and also removes these units from the inventory.

![Cursor pointing at 'Fulfilled' option for order shipping status.](https://media.voog.com/0000/0036/2183/photos/Manage_your_orders6_block.jpg "Cursor pointing at 'Fulfilled' option for order shipping status.")

## Shipping labels

If you turn on automatic data exchange, you can generate shipping labels for Omniva, DPD and SmartPosti orders directly on Voog.  

![Cursor pointing at the 'Print shipping label' button in order details view.](https://media.voog.com/0000/0036/2183/photos/Manage_your_orders9_block.jpg "Cursor pointing at the 'Print shipping label' button in order details view.")

You can download the order’s shipping label via the **Print shipping label** button in order details view.  
  
**The shipping label is supported if:**  

1. You have set up and activated the integration of a delivery service provider (Omniva, DPD, SmartPosti).
2. The customer has placed an order where the chosen delivery method is Omniva, DPD or SmartPosti.
3. The buyer's name and phone number are filled in on the order.

  
More information about automatic data exchange and how to activate it with [Omniva](/support/online-store/automatic-data-exchange-with-omniva), [SmartPosti](/support/online-store/automatic-data-exchange-with-itella), and [DPD](/support/online-store/automatic-data-exchange-with-dpd).  
  
Important information about the shipping label:  

- The name of the store entered in the store settings is marked as the sender of the package on the shipping label.
- The return address will be the one entered in the store settings.
- In order to create a shipping label, it is necessary to mark the buyer's name and telephone fields as mandatory in the shopping cart. Shopping cart fields can be edited in **Store settings > Checkout** view.

  
After making the necessary changes to an order, **you can regenerate the shipping label** with the updated information and download it.  

![Cursor on the 'Regenerate the shipping label' button in order details view.](https://media.voog.com/0000/0036/2183/photos/regenerate%20shipping%20label_block.png "Cursor on the 'Regenerate the shipping label' button in order details view.")

## Bulk actions

With bulk actions, you can save time and update multiple orders at once in Voog. Here's how:  
  
1. To select multiple orders, put a checkmark in front of the rows of orders that you want to change at once. To select all orders, check the box in front of the column headings.  
2. Click on the **Edit** button to change the status of selected orders.  

![Cursor pointing at 'Edit' button in orders menu.](https://media.voog.com/0000/0036/2183/photos/Manage_your_orders7_block.jpg "Cursor pointing at 'Edit' button in orders menu.")

3. You can change **the payment status** (paid, pending, unpaid, or cancelled), **shipping status** (not fulfilled or fulfilled), and **order status** (not archived or archived) for all selected orders.  

![Cursor on 'Download PDF invoices' in orders menu.](https://media.voog.com/0000/0036/2183/photos/Manage_your_orders8_block.jpg "Cursor on 'Download PDF invoices' in orders menu.")

You can also download invoices and shipping labels for several orders at once using bulk actions. Simply put a checkmark in front of the orders you want to download the invoices or shipping labels for, click on the three dots icon, and select **Download PDF invoices** or **Download shipping labels**. Note that shipping labels will only be printed for orders that already have generated shipping labels - these orders will have a truck icon beside the shipping status in the orders view.
