// cPanel Entry Point - Application Startup File for Phusion Passenger / Node.js App
const path = require("path");
const fs = require("fs");

// Look for compiled API entry points
const candidates = [
  path.join(__dirname, "apps", "api", "dist", "server.js"),
  path.join(__dirname, "dist", "server.js"),
  path.join(__dirname, "apps", "api", "dist", "src", "server.js"),
  path.join(__dirname, "dist", "src", "server.js")
];

let targetFile = null;
for (const candidate of candidates) {
  if (fs.existsSync(candidate)) {
    targetFile = candidate;
    break;
  }
}

if (!targetFile) {
  console.error("==================================================================");
  console.error("ERROR: Compiled application server file not found!");
  console.error("Please run 'npm run build:api' in your project root or cPanel terminal.");
  console.error("Looked in:");
  candidates.forEach((c) => console.error(" - " + c));
  console.error("==================================================================");
  process.exit(1);
}

// Start application
const exported = require(targetFile);
const server = exported.default || exported.app || exported;

module.exports = server;
