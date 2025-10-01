// ✅ FINAL FIXED server.js with all improvements
const express = require('express');
const oracledb = require('oracledb');
const path = require('path');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, '../public')));

// ✅ Oracle DB config
const dbConfig = {
  user: 'system',
  password: 'Pa$$w0rd',
  connectString: 'localhost:1521/XE'
};

// 📦 Get all products
app.get('/api/products', async (req, res) => {
  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);
    const result = await connection.execute(`SELECT * FROM Product`, [], {
      outFormat: oracledb.OUT_FORMAT_OBJECT
    });
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send('Error fetching products');
  } finally {
    if (connection) await connection.close();
  }
});

// 🔐 Login route
app.post('/api/login', async (req, res) => {
  const { username, password } = req.body;
  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);
    const result = await connection.execute(
      `SELECT customer_id, first_name FROM Customer WHERE username = :username AND password = :password`,
      [username, password],
      { outFormat: oracledb.OUT_FORMAT_OBJECT }
    );
    if (result.rows.length > 0) {
      res.json({ success: true, user: result.rows[0] });
    } else {
      res.json({ success: false, message: 'Invalid credentials' });
    }
  } catch (err) {
    console.error(err);
    res.status(500).send('Login error');
  } finally {
    if (connection) await connection.close();
  }
});

// 🧍 Register route with auto cart creation
app.post('/api/register', async (req, res) => {
  const { first_name, last_name, email, username, password } = req.body;
  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);

    const result = await connection.execute(`SELECT MAX(customer_id) FROM Customer`);
    const newId = (result.rows[0][0] || 0) + 1;

    await connection.execute(
      `INSERT INTO Customer (
        customer_id, first_name, last_name, email, phone,
        street_address, city, state, postal_code, country,
        registration_date, username, password
      ) VALUES (
        :id, :first, :last, :email, '', '', '', '', '', 'Canada',
        SYSDATE, :username, :password
      )`,
      {
        id: newId,
        first: first_name,
        last: last_name,
        email,
        username,
        password
      },
      { autoCommit: true }
    );

    await connection.execute(
      `INSERT INTO Cart (cart_id, customer_id, created_at)
       VALUES ((SELECT NVL(MAX(cart_id), 0) + 1 FROM Cart), :customerId, SYSDATE)`,
      { customerId: newId },
      { autoCommit: true }
    );

    res.json({ success: true });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: 'Registration failed' });
  } finally {
    if (connection) await connection.close();
  }
});

// 🛒 Get cart items
app.get('/api/cart', async (req, res) => {
  const customerId = parseInt(req.query.customer_id);
  if (isNaN(customerId)) {
    return res.status(400).json({ error: "Invalid customer ID." });
  }

  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);
    const result = await connection.execute(
      `SELECT 
         p.product_id AS PRODUCT_ID,
         p.product_name AS PRODUCT_NAME,
         p.price AS PRICE,
         p.image_url AS IMAGE_URL,
         cp.quantity AS QUANTITY
       FROM CartProduct cp
       JOIN Product p ON cp.product_id = p.product_id
       JOIN Cart c ON cp.cart_id = c.cart_id
       WHERE c.customer_id = :customerId`,
      [customerId],
      { outFormat: oracledb.OUT_FORMAT_OBJECT }
    );
    res.json(result.rows);
  } catch (err) {
    console.error("❌ Cart lookup error:", err);
    res.status(500).json({ error: "Failed to load cart items." });
  } finally {
    if (connection) await connection.close();
  }
});

// ✅ Auto-create cart if missing
app.get('/api/cart/by-customer/:customerId', async (req, res) => {
  const customerId = parseInt(req.params.customerId);
  if (isNaN(customerId)) {
    return res.status(400).json({ error: "Invalid customer ID." });
  }

  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);
    const result = await connection.execute(
      `SELECT cart_id FROM Cart WHERE customer_id = :customerId`,
      { customerId },
      { outFormat: oracledb.OUT_FORMAT_OBJECT }
    );

    if (result.rows.length === 0) {
      await connection.execute(
        `INSERT INTO Cart (cart_id, customer_id, created_at)
         VALUES ((SELECT NVL(MAX(cart_id), 0) + 1 FROM Cart), :customerId, SYSDATE)`,
        { customerId },
        { autoCommit: true }
      );

      const newCart = await connection.execute(
        `SELECT cart_id FROM Cart WHERE customer_id = :customerId`,
        { customerId },
        { outFormat: oracledb.OUT_FORMAT_OBJECT }
      );

      return res.json({ cart_id: newCart.rows[0].CART_ID });
    } else {
      return res.json({ cart_id: result.rows[0].CART_ID });
    }
  } catch (err) {
    console.error("Cart lookup error:", err);
    res.status(500).json({ error: "Failed to fetch or create cart." });
  } finally {
    if (connection) await connection.close();
  }
});

// ➕ Add item to cart (MERGE instead of duplicate insert)
app.post('/api/cart/add', async (req, res) => {
  const { cartId, productId, quantity } = req.body;
  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);
    await connection.execute(
      `MERGE INTO CartProduct cp
       USING DUAL
       ON (cp.cart_id = :cartId AND cp.product_id = :productId)
       WHEN MATCHED THEN
         UPDATE SET cp.quantity = cp.quantity + :quantity
       WHEN NOT MATCHED THEN
         INSERT (cart_product_id, cart_id, product_id, quantity)
         VALUES ((SELECT NVL(MAX(cart_product_id), 0) + 1 FROM CartProduct), :cartId, :productId, :quantity)`,
      { cartId, productId, quantity },
      { autoCommit: true }
    );
    res.json({ success: true });
  } catch (err) {
    console.error("Add to cart error:", err);
    res.status(500).json({ error: "Failed to add item to cart" });
  } finally {
    if (connection) await connection.close();
  }
});

// ❌ Remove item from cart
app.delete('/api/cart/remove', async (req, res) => {
  const { cartId, productId } = req.body;
  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);
    await connection.execute(
      `DELETE FROM CartProduct WHERE cart_id = :cartId AND product_id = :productId`,
      { cartId, productId },
      { autoCommit: true }
    );
    res.json({ success: true });
  } catch (err) {
    console.error("Remove from cart error:", err);
    res.status(500).json({ error: 'Failed to remove item from cart' });
  } finally {
    if (connection) await connection.close();
  }
});

// 🧾 Checkout + Save Order
app.post('/api/checkout', async (req, res) => {
  const { customerId, items, total } = req.body;
  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);

    const orderIdResult = await connection.execute(`SELECT NVL(MAX(order_id), 0) + 1 FROM Orders`);
    const newOrderId = orderIdResult.rows[0][0];

    await connection.execute(
      `INSERT INTO Orders (order_id, customer_id, total_amount, order_date)
       VALUES (:orderId, :customerId, :total, SYSDATE)`,
      { orderId: newOrderId, customerId, total },
      { autoCommit: true }
    );

    for (const item of items) {
      await connection.execute(
        `INSERT INTO OrderDetails (
           order_detail_id, order_id, product_id, quantity, price
         ) VALUES (
           (SELECT NVL(MAX(order_detail_id), 0) + 1 FROM OrderDetails),
           :orderId, :productId, :quantity, :price
         )`,
        {
          orderId: newOrderId,
          productId: item.product_id,
          quantity: item.quantity,
          price: item.price
        },
        { autoCommit: true }
      );
    }

    res.json({ success: true, orderId: newOrderId });
  } catch (err) {
    console.error("Checkout error:", err);
    res.status(500).json({ success: false, message: "Failed to process checkout" });
  } finally {
    if (connection) await connection.close();
  }
});

// 🧹 Clear cart after checkout
app.post('/api/clear-cart', async (req, res) => {
  const customerId = parseInt(req.query.customer_id);
  if (isNaN(customerId)) {
    return res.status(400).json({ error: "Invalid customer ID." });
  }

  let connection;
  try {
    connection = await oracledb.getConnection(dbConfig);

    await connection.execute(
      `DELETE FROM CartProduct
       WHERE cart_id = (
         SELECT cart_id FROM Cart WHERE customer_id = :customerId
       )`,
      { customerId },
      { autoCommit: true }
    );

    res.json({ success: true });
  } catch (err) {
    console.error("Clear cart error:", err);
    res.status(500).json({ success: false });
  } finally {
    if (connection) await connection.close();
  }
});

// 🚀 Start the server
app.listen(PORT, () => {
  console.log(`✅ Server running at http://localhost:${PORT}`);
});
