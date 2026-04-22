import "dotenv/config";
import cors from "cors";
import express from "express";
import dotenv from "dotenv";

import "./db/index";
import { appRouter } from "./routers";

dotenv.config();

const app = express();

app.use(
    cors({
        origin: "*",
        methods: ["GET", "POST", "OPTIONS", "PUT", "DELETE"],
    }),
);

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/api", appRouter);

const port = process.env.PORT || 3000;

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
