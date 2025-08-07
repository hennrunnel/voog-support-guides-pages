---
title: Tips for successful product importing
lang: en
section: online-store
slug: products-import
original_url: https://www.voog.com/support/online-store/products-import
updated_at: 2025-08-07T21:25:01Z
word_count: 1176
---
## Tips for successful product importing

### General

- Importing can be done within the confines of a single language at a time - translations of names must be imported separately.
- If you choose to update products, for a product with variations, the variations of the product being updated that are not present in the import file will be removed.

### Import file

- **The import file** can **contain a maximum of 10,000 lines**.
- **The size of the import file** can be up to **10 MB**.
- Supported **file formats**: **XLSX, ODS, CSV**.
- For the successful import of a new product without variations, a **minimum of two columns are needed** - **product** **name** and **prices**.
- For importing a product with variations, the import file must contain a row for the main product followed by rows for the variations, i.e., a minimum of 4 columns - ID, Parent ID, Name, Price.

## **Product import file templates**

You can use an [export file downloaded from your website](/support/online-store/manage-your-orders#filtering-and-export), [our sample templates](https://media.voog.com/0000/0036/2183/files/voog-products-import-demo.xlsx), or create the file as a template for your import file.  

## Fields supported in import file during import

When importing a product, the following fields  related to the product are supported for import:  
  

- **ID** – the product identifier, used for product updates and importing products with variations.
- **Parent ID** – on the product variation line, the ID of the associated main product, is used for importing variations.
- **Product code** – the product code (SKU, etc.).
- **Name** – the product name in the respective language (ignored for product variation line).
- **URL slug** – part of the product URL, for example, in **/en/products/my-product** it would be my-product (only the main product line value is considered during import).
- **Variant attributes** – variation types associated with the product variation, in the form **Size: S, Color: Black** (comma is used as the dimension separator and colon as the value separator).
- **Description** – The product description in the respective language (ignored for product variation line).
- **Price** – the net price of the product/variation in the store's currency (mandatory for the main product, optional for variation).
- **Sale price** – the net reduced price of the product/variation in the store's currency (optional for both main product and variation).
- **Stock** – available quantity, if empty, then unlimited stock quantity.
- **Status** – visibility of the product/variation (allowed values Live/Draft).
- **Categories** – categories associated with the product in the respective language, separated by commas (e.g., **Lamps, Another Cat**) (empty value removes categories, ignored for product variation line).
- **Meta description** - when you share the link of your product page on social media, you can add an appropriate product description known as the OG description (Open Graph Description).
- **Length** – the length of the product in meters.
- **Width** – the width of the product in meters.
- **Height** – the height of the product in meters.
- **Weight** – the weight of the product in kilograms.

  
 When you download the export file of existing products from your website, you can access the column names similarly.  

## Import file structure

The import file consists of a header row followed by rows of products to be imported. To facilitate the automatic detection of column types, we recommend using the same field names as described in the supported import fields section.  
  

- **Import of products without variations** - each product is on a separate line. Minimum columns are “Name” and “Price” upon creation, and “ID”, “Name” and “Price” for updating.
- **Import of products with variations** - there are 2-N rows for each product. The first row, or the main product row (matrix), contains the basic information of the product (e.g., name, URL, categories, default price). The following rows are the product variation rows, where the value in the "Parent ID" must match the value in the "ID" column of the main product.

## Product import process

1. Navigate to **Store > Products** view, click on the three dots at the top corner of the page, and in the menu that opens, choose **Import products**.  

   ![Import products button in products menu.](https://media.voog.com/0000/0036/2183/photos/import_products_en_block.jpg "Import products button in products menu.")
2. Note that for importing products, all added information must be in the correct format and structure. If at least one product (which could be a single product, or a main product + variations) does not validate or is faulty, the entire import will be canceled. However, under certain conditions, a row will be ignored. For example, if the first row is immediately a variation row and its main product row is missing, then the variation row will be ignored, and the import will start with the first main product if it is found in the following rows.
3. On the opened **Import Products** page, you can upload the file to be imported (preferably XLSX, ODS).
4. Before importing products, please familiarize yourself with

- [sample import file](https://media.voog.com/0000/0036/2183/files/voog-products-import-demo.xlsx)
- [information on importing translatable fields](/support/online-store/products-import#importing-product-translations)

5. Choose the language in which you want to import products.
6. Set the matches between columns and product fields.
7. After uploading the import file, you will be shown all the columns found in the file, the content of their first 4 rows, and an option to decide if and how each column is imported as a field. Note that only columns with an assigned field will be imported.
8. When you click on the **Start import** button, the system will notify you that the product import has been initiated. Once the import task is completed, you will receive an email notification that the product import is finished. Notifications are sent for both successful and unsuccessful imports.
9. If you close the **Import products** view, you will see an "X imports" menu next to the filter button in the **Products** list view, where you can see the completed and in-progress/queued import tasks.

## Importing product translations

If your website has more then one language, they need to be imported in the language set in the **Import products** view.  
  
 If you want to import product translations (for example Name, URL slug, Description) in bulk, follow these steps:  
  

1. Download or export the desired products.
2. In the downloaded file, retain only the columns **ID**, **Parent ID**, **Name**, **URL slug**, **Description**.
3. Translate these into the language of the downloaded file.
4. In the **Import products** view, select another language into which you wish to import the products.
5. In the **Import products** view, select **Overwrite existing products with matching ID**.

## Important information after product import

In the **Products** view, import tasks are regularly updated if a task is currently in progress. Note that if the product import is completed and you are in the product list view, the product list will reload.  
  
 Be aware that if something goes wrong during the import (for example, if a row fails), then the entire change will be rolled back and no products will be imported.
