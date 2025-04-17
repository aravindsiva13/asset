require("dotenv").config();

//Setup Express
const express = require("express");
const bodyparser = require("body-parser");
const cors = require("cors");
const { developmentErrors, notFound } = require("./helpers/errorHandlers");
const mongoose = require("mongoose");
const app = express();
const { MongoClient } = require("mongodb");
const { GridFSBucket } = require("mongodb");

/// Mongo DB for Create Connection for Store Image and Document
let gfs;
const conn = mongoose.createConnection(process.env.MONGO_URL, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});
conn.once("open", () => {
  gfs = new mongoose.mongo.GridFSBucket(conn.db, {
    bucketName: "uploads",
  });
});

/// Mongo DB
const connectMongoDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URL, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log("DB connected");
  } catch (e) {
    console.log(e.message);
  }
};

app.use(bodyparser.json({ limit: "50mb", extended: true }));
app.use(bodyparser.urlencoded({ extended: false }));

// var corsOptions = {
//   origin: ["http://localhost"],
//   optionsSuccessStatus: 200,
// };

app.use(cors());

app.use((req, res, next) => {
  req["gfs"] = gfs;
  console.log(req.url, req.body, req.query);
  next();
});

// Used for Store the Image and Document
const client = new MongoClient(process.env.MONGO_URL, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

app.get("/images/:image", async (req, res) => {
  await client.connect();
  const db = client.db();
  gfs = new GridFSBucket(db, { bucketName: "uploads" });
  const { image } = req.params;
  try {
    let file = await gfs.find({ filename: image }).toArray();
    if (file.length > 0) {
      let stream = gfs.openDownloadStreamByName(image);
      stream.pipe(res);
    } else {
      res.status(404).send("FILE_NOT_FOUND");
    }
  } catch (e) {
    console.log(e);
  }
});

/// Routers
app.use("/user", require("./routers/user.router"));
app.use("/asset", require("./routers/asset.router"));
app.use("/vendor", require("./routers/vendor.router"));
app.use("/company", require("./routers/company.router"));
app.use("/stock", require("./routers/stock.router"));
app.use("/model", require("./routers/model.router"));
app.use("/template", require("./routers/template.router"));
app.use("/type", require("./routers/type.router"));
app.use("/category", require("./routers/category.router"));
app.use("/subCategory", require("./routers/subCategory.router"));
app.use("/location", require("./routers/location.router"));
app.use("/ticket", require("./routers/ticket.router"));
app.use("/help", require("./routers/help.router"));

app.use(notFound);
app.use(developmentErrors);

app.use(express.json());
app.set("view engine", "ejs");

app.listen(process.env.port || 8002, () => {
  connectMongoDB();
  console.log(`Server is running on port ${process.env.port || 8002}`);
});
