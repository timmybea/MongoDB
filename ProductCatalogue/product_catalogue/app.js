//Bring in your dependencies from the node_modules directory
const express = require('express');
const bodyParser = require('body-parser');
const mongojs = require('mongojs');
const db = mongojs('catalogue', ['products']);

const port = 3000

const app = express();

app.use(bodyParser.json());

//CORS allows your API to be public?? FIND OUT MORE

app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

//Home
//Create a route with app.get
//() => {} is the same as function() {}
// '/' is the homepage
//3 parameters: request, resonse and next
app.get('/', (req, res, next) => {
  res.send('please use /api/v1/products');
});

//Fetch all products
app.get('/api/v1/products', (req, res, next) => {
  //res.send('list products');
  db.products.find((err, docs) => {
    if(err) {
      res.send(err);
    }
    console.log("All products successfully retrieved");
    res.json(docs);
  });
});

//Fetch single product
//:id is a placeholder for the product that is being fetched
app.get('/api/v1/products/:id', (req, res, next) => {
  //res.send('Fetch product ' + req.params.id);
  db.products.findOne({_id: mongojs.ObjectId(req.params.id)}, (err, doc) => {
    if(err) {
      res.send(err);
    }
    console.log("product id successfully retrieved");
    res.json(doc);
  });


});

//Add product
app.post('/api/v1/products', (req, res, next) => {
  //res.send('add new product');
  db.products.insert(req.body, (err, doc) => {
    if(err) {
      res.send(err);
    }
    console.log('Adding product');
    res.json(doc);
  });
});


//update product
app.put('/api/v1/products/:id', (req, res, next) => {
  //res.send('update product with the id ' + req.params.id);
   db.products.findAndModify({query: {_id: mongojs.ObjectId(req.params.id)}, update: {$set: {
    name: req.body.name,
    category: req.body.category,
    model: req.body.model,
    price: req.body.price,
    image: req.body.image,
    details: req.body.details
  }}, new: true }, (err, doc) => {
    if(err) {
      res.send(err);
    }
    console.log('Updating product');
    res.json(doc);
});
});
//note that new: means if the record doesn't already exist then it will be created

//delete product
app.delete('/api/v1/products/:id', (req, res, next) => {
  //res.send('delete product with the id ' + req.params.id);
  db.products.remove({_id: mongojs.ObjectId(req.params.id)}, (err, doc) => {
    if (err) {
      res.send(err);
    }
    console.log('Removing product');
    res.json(doc);
  });
});

//Instruct the app to listen to a port on a server
app.listen(port, () => {
  console.log('Server started on port ' + port);
});