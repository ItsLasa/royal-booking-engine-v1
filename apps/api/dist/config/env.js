"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.env = void 0;
const fs_1 = require("fs");
const path_1 = require("path");
const zod_1 = require("zod");
function loadDotEnv() {
    const candidatePaths = [
        (0, path_1.resolve)(process.cwd(), ".env"),
        (0, path_1.resolve)(__dirname, ".env"),
        (0, path_1.resolve)(__dirname, "../../.env"),
        (0, path_1.resolve)(__dirname, "../../../.env"),
        (0, path_1.resolve)(process.cwd(), "apps/api/.env"),
    ];
    for (const envPath of candidatePaths) {
        if (!(0, fs_1.existsSync)(envPath))
            continue;
        try {
            const content = (0, fs_1.readFileSync)(envPath, "utf8");
            for (const rawLine of content.split(/\r?\n/)) {
                const line = rawLine.trim();
                if (!line || line.startsWith("#"))
                    continue;
                const equalsIndex = line.indexOf("=");
                if (equalsIndex === -1)
                    continue;
                const key = line.slice(0, equalsIndex).trim();
                let value = line.slice(equalsIndex + 1).trim();
                if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
                    value = value.slice(1, -1);
                }
                if (process.env[key] === undefined)
                    process.env[key] = value;
            }
            break;
        }
        catch {
            // Continue searching next candidate path
        }
    }
}
loadDotEnv();
const envSchema = zod_1.z.object({
    NODE_ENV: zod_1.z.enum(["development", "test", "production"]).default("development"),
    FRONTEND_URL: zod_1.z.string().url().default("http://localhost:3000"),
    API_URL: zod_1.z.string().url().default("http://localhost:4000"),
    PORT: zod_1.z.union([zod_1.z.coerce.number(), zod_1.z.string()]).default(4000),
    DATABASE_URL: zod_1.z.string().min(1),
    SESSION_SECRET: zod_1.z.string().min(16).default("development-session-secret-change-me"),
    PROPERTY_TIMEZONE: zod_1.z.string().default("Asia/Colombo"),
    DEFAULT_CURRENCY: zod_1.z.string().default("LKR"),
    PAYHERE_MODE: zod_1.z.enum(["sandbox", "live"]).default("sandbox"),
    PAYHERE_MERCHANT_ID: zod_1.z.string().default(""),
    PAYHERE_MERCHANT_SECRET: zod_1.z.string().default(""),
    PAYHERE_NOTIFY_URL: zod_1.z.string().url().optional(),
    PAYHERE_RETURN_URL: zod_1.z.string().url().optional(),
    PAYHERE_CANCEL_URL: zod_1.z.string().url().optional(),
    RESEND_API_KEY: zod_1.z.string().optional(),
    EMAIL_FROM: zod_1.z.string().optional(),
    ADMIN_NOTIFICATION_EMAIL: zod_1.z.string().email().optional(),
    CRON_SECRET: zod_1.z.string().min(16).default("development-cron-secret"),
    BOOKING_HOLD_MINUTES: zod_1.z.coerce.number().int().positive().default(15),
    MANAGE_BOOKING_TOKEN_SECRET: zod_1.z.string().min(16).default("development-manage-token-secret"),
    ICAL_FEED_SECRET: zod_1.z.string().min(16).default("development-ical-feed-secret"),
});
exports.env = envSchema.parse(process.env);
