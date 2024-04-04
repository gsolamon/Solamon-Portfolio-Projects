# Solamon-Portfolio-Projects - Advanced Projects #8, #9, and #10

In these three advanced projects, I will demonstrate my ability to build semantic models in the Power Platform that provide valuable characterizations of operational and financial data.

### **Project List:**

  - [**Project #5:** Projected Ship Dates in the Power Platform](https://github.com/gsolamon/Solamon-Portfolio-Projects/tree/c157b9c3b35e36d1c53749dbf04d1b5745b92b99/Advanced%20Project%20%238%3A%20Customizing%20D365%20Business%20Central%20with%20VSCode)
  - [**Project #9:** ???]()
  - [**Project #10:** ???]()

### **Project Summaries:**

  **Advanced Project #8: Customizing D365 Business Central with VSCode**
  
  1. I learned the basics of customizing our D365 Business Central (BC) environments by using Hougaard's [Simple Object Designer](https://www.hougaard.com/designer/). This tools allows us to create new fields, expose fields as APIs for Power BI, and add our custom fields to pages/reports without maintaining a code library.
  2. I used the Simple Object Designer along with Hougaard's extensive [YouTube library](https://www.youtube.com/c/ErikHougaard) of Business Central developer videos as a stepping stone to publishing customizations to Business Central using [Visual Studio Code](https://code.visualstudio.com/Download) (VSCode).
  3. The customization that I will showcase in this portfolio project is a "Release and Send Confirmation" action button on Sales Orders in our LIVE environment:

  ![Release and Send Confirmation](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/b8b99e26c9666aee0220eec6b1929433352f372e/Advanced%20Project%20%238%3A%20Customizing%20D365%20Business%20Central%20with%20VSCode/Images/Release%20and%20Send%20Confirmation.png)
     
  5. This action button sends an email confirmation with PDF attachment to our customers and the corresponding salesperson when their instrument order is released to production. Below is an example of the HTML-formatted email with PDF attachment:

  ![Example Email with PDF](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/3b3d66dde0df007f632ff180d54e7643fce22879/Advanced%20Project%20%238%3A%20Customizing%20D365%20Business%20Central%20with%20VSCode/Images/Example%20Email%20with%20PDF.png)
     
  7. To build this customization, I wrote a codeunit called SendOrderConfirmation (AL Code found [here](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/20e34930df43ace5c9f7e27bd5161e18e9dbf87a/Advanced%20Project%20%238%3A%20Customizing%20D365%20Business%20Central%20with%20VSCode/AL%20Code/SendOrderConfirmation.al)). This codeunit takes orderNo as a parameter and is called whenever the action button is triggered.
  8. The codeunit contains a procedure that declares 23 variables for the following purposes:

  ![Codeunit Declare Variables](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/20e34930df43ace5c9f7e27bd5161e18e9dbf87a/Advanced%20Project%20%238%3A%20Customizing%20D365%20Business%20Central%20with%20VSCode/Images/Codeunit%20Declare%20Variables.png)

  - ExitValue to return TRUE when the procedure completes.
  - 6 variables that extract information from the sales header record.
  - 4 variables related to the email recipients.
  - 4 variables related to the report format (XML parameters).
  - 8 variables related to creating/temporarily storing the email before sending with proper HTML formatting.
  7. The next part of the procedure fetches the sales order header matching the orderNo parameter using SetRange() then stores the sell-to email, customer name, salesperson code, external document number, and sales amount as variables:

  ![Sales Order Header Information](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/20e34930df43ace5c9f7e27bd5161e18e9dbf87a/Advanced%20Project%20%238%3A%20Customizing%20D365%20Business%20Central%20with%20VSCode/Images/Sales%20Order%20Header%20Information.png)
    
  8. After storing these variables, the procedure uses SetRange() to filter the list of salespeople/purchasers then set the email recipients/CC list:
  
  ![Recipients Information](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/20e34930df43ace5c9f7e27bd5161e18e9dbf87a/Advanced%20Project%20%238%3A%20Customizing%20D365%20Business%20Central%20with%20VSCode/Images/Recipients%20Information.png)

  9. The field c006_Email_List is a custom field that I published to the salesperson/purchasers table using table extension 70004. The custom field was added to related pages using page extensions.
    
  10. I set the XML report parameters with today's date and orderNo then create an outstream as a temporary blob data type, which will store the PDF attachment report before sending the email:
  
  ![XML Parameters](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/20e34930df43ace5c9f7e27bd5161e18e9dbf87a/Advanced%20Project%20%238%3A%20Customizing%20D365%20Business%20Central%20with%20VSCode/Images/XML%20Parameters.png)

  11. To get the original string of XML parameters from Business Central, which acts as a template for my code, I used Job Queues to run a custom AL codeunit RunRequestPage1305 that prints the XML parameters for report 1305 to a message dialog box:
  
  ![Run Request Page](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/20e34930df43ace5c9f7e27bd5161e18e9dbf87a/Advanced%20Project%20%238%3A%20Customizing%20D365%20Business%20Central%20with%20VSCode/Images/RunRequestPage1305.png)

  12. To create the email with PDF attachment, I initiate an if/then loop with Report.SaveAs(), which returns TRUE and terminates the loop when the report is saved as a PDF to the outstream.
  13. I use the CreateInStream() and ToBase64() functions to turn my outstream into an instream that is converted to base-64 and stored as a variable (txtB64).
  14. The email body is composed from an HTML template that incorporates information about the sales order (orderNo, external document number, customer name, and order value) into the message body using concatenation.
  15. The email is created using emailMsg.Create(). Recipients, subject, email body, and CC list are also added.
  16. The order confirmation report is added as a PDF attachment then the email is sent:
  
  ![Save As and Send Email](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/1e813fe9cf42ab455ff5efea73c5e3b3a12a6cd7/Advanced%20Project%20%238%3A%20Customizing%20D365%20Business%20Central%20with%20VSCode/Images/Save%20As%20and%20Send%20Email.png)

  17. If the loop terminates in TRUE, the exitValue is set to TRUE and the procedure exits with this value.
  18. To add an action button to the Sales Order page, I created a page extension called SalesOrderExtension:
  
  ![Action Page Extension](https://github.com/gsolamon/Solamon-Portfolio-Projects/blob/1e813fe9cf42ab455ff5efea73c5e3b3a12a6cd7/Advanced%20Project%20%238%3A%20Customizing%20D365%20Business%20Central%20with%20VSCode/Images/Action%20Page%20Extension.png)

  19. This extension adds an action button next to the native "Release" action button that releases the sales order then runs the SendOrderConfirmation codeunit upon triggering.
  20. This customization has saved our Customer Service team a lot of time, made our order confirmation emails significantly more professional, and allowed customers/salespeople to have a better estimate of when orders will be fulfilled.


  **Advanced Project #9: ???**
  
  1. 


  **Advanced Project #10: ???**
  
  1. 
