import dotenv from "dotenv";
dotenv.config();

import express from "express";
import cors from "cors";
import express_prom_bundle from "express-prom-bundle";

import userRoutes from "./user/user.routes";

import http from "http";
import https from "https";

http.globalAgent = new http.Agent({
  keepAlive: true,
});

https.globalAgent = new https.Agent({
  keepAlive: true,
});
console.log("HTTP ", http.globalAgent);
console.log("HTTPS ", https.globalAgent);

const metricsMiddleware = express_prom_bundle({
  includeMethod: true,
  includePath: true,
  includeStatusCode: true,
  includeUp: true,
});

const app = express();
app.use(metricsMiddleware);
app.use(cors());
app.use(express.json());

app.use("/user", userRoutes);

app.get("/", (req, res) => {
  return res.status(200).send("Authentication Microservice is running!");
});

const PORT = process.env.PORT || 8000;
app.listen(PORT, () => {
  console.log(`🚀 Authentication Microservice has started on port ${PORT}`);
});
