# petrol_n_gas

Flutter app for gas stations to sell petrol and gas to customers.

## Firestore structure

Collection "orders"
Document: Order Document (Auto-generated document ID)
 Field: approved (boolean)
 Field: email (String: current authenticated user email)
 Field: orderTime (Current Timestamp: store the date and time the order was placed)
 Field: totalAmount (Number: store the total order amount)
 Subcollection: orderProducts
  Document: OrderProduct Document (Auto-generated document ID)
  (it's a Product Model)
  Field: name (String)
  Field: price (number)
  Field: quantity (number)
  Field: category (String)
  Field: imageFlag (String)

Collection "products"
Document: Product Document (Auto-generated document ID)
 Field: name (String)
 Field: price (number)
 Field: quantity (number)
 Field: category (String)
 Field: imageFlag (String)

Collection "users"
Document: Product Document (Auto-generated document ID)
 Field: email (String)
 Field: role (String)
