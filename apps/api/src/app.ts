import express from "express";
import cors from "cors";
import helmet from "helmet";
import rateLimit from "express-rate-limit";
import cookieParser from "cookie-parser";
import pinoHttp from "pino-http";
import path from "path";
import fs from "fs";
import { env } from "./config/env";
import { publicRoutes } from "./routes/publicRoutes";
import { adminRoutes } from "./routes/adminRoutes";
import { adminAuthRoutes } from "./routes/adminAuthRoutes";
import { bookingAdminRoutes } from "./routes/bookingAdminRoutes";
import { paymentAdminRoutes } from "./routes/paymentAdminRoutes";
import { rateAdminRoutes } from "./routes/rateAdminRoutes";
import { roomAdminRoutes } from "./routes/roomAdminRoutes";
import { housekeepingRoutes } from "./routes/housekeepingRoutes";
import { maintenanceRoutes } from "./routes/maintenanceRoutes";
import { guestRoutes } from "./routes/guestRoutes";
import { reportRoutes } from "./routes/reportRoutes";
import { staffRoutes } from "./routes/staffRoutes";
import { settingsRoutes } from "./routes/settingsRoutes";
import { auditRoutes } from "./routes/auditRoutes";
import { paymentRoutes } from "./routes/paymentRoutes";
import { calendarRoutes } from "./routes/calendarRoutes";
import { cronRoutes } from "./routes/cronRoutes";
import { errorHandler } from "./middleware/validation";

function findNextDir(): string | null {
  const candidates = [
    process.cwd(),
    path.resolve(__dirname, "../../.."),
    path.resolve(__dirname, "../.."),
  ];
  for (const c of candidates) {
    if (fs.existsSync(path.join(c, ".next"))) {
      return c;
    }
  }
  return null;
}

export function createApp() {
  const app = express();
  app.set("trust proxy", 1);
  app.use(helmet({ contentSecurityPolicy: false }));
  app.use(cookieParser(env.SESSION_SECRET));

  app.use(
    pinoHttp({
      autoLogging: {
        ignore: (req) => Boolean(req.url?.startsWith("/_next/") || req.url?.startsWith("/favicon") || req.url?.endsWith(".png") || req.url?.endsWith(".ico")),
      },
      redact: ["req.headers.authorization", "req.body.md5sig", "req.body.hash"],
    })
  );

  // Health check endpoint
  app.get("/health", (_req, res) => res.json({ ok: true }));

  // API router with CORS, rate limiting, and JSON parsing
  const apiRouter = express.Router();
  apiRouter.use(cors({ origin: env.FRONTEND_URL, credentials: true }));
  apiRouter.use(rateLimit({ windowMs: 60_000, limit: 120 }));
  apiRouter.use(express.json({ limit: "256kb" }));

  apiRouter.use(
    publicRoutes,
    paymentRoutes,
    adminAuthRoutes,
    adminRoutes,
    bookingAdminRoutes,
    paymentAdminRoutes,
    rateAdminRoutes,
    roomAdminRoutes,
    housekeepingRoutes,
    maintenanceRoutes,
    guestRoutes,
    reportRoutes,
    staffRoutes,
    settingsRoutes,
    auditRoutes,
    cronRoutes,
    calendarRoutes
  );
  apiRouter.use(errorHandler);

  app.use("/api/v1", apiRouter);

  // 404 for unhandled API routes
  app.use("/api", (_req, res) => {
    res.status(404).json({ success: false, error: { code: "NOT_FOUND", message: "API endpoint not found" } });
  });

  // Next.js Frontend Integration (serves /, /about, /packages, /book, /admin, /_next/*, etc.)
  const nextDir = findNextDir();
  if (nextDir && process.env.NODE_ENV !== "test") {
    try {
      // eslint-disable-next-line @typescript-eslint/no-var-requires
      const next = require("next");
      const nextApp = next({ dev: false, dir: nextDir });
      const prep = nextApp.prepare();
      const handle = nextApp.getRequestHandler();

      app.use(async (req, res, nextFn) => {
        try {
          await prep;
          return handle(req, res);
        } catch (err) {
          return nextFn(err);
        }
      });
    } catch (err) {
      console.warn("Notice: Next.js could not be attached:", err);
    }
  }

  return app;
}
