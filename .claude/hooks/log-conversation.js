#!/usr/bin/env node
// Stop hook: appends any new transcript turns to CONVERSATION_LOG.md and pushes to GitHub.
const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");

const repoDir = path.resolve(__dirname, "..", "..");
const logFile = path.join(repoDir, "CONVERSATION_LOG.md");
const stateDir = path.join(repoDir, ".claude", "hooks", ".state");

function readStdin() {
  try {
    return fs.readFileSync(0, "utf8");
  } catch {
    return "";
  }
}

function extractText(message) {
  const content = message && message.content;
  if (content == null) return "";
  if (typeof content === "string") return content;
  if (Array.isArray(content)) {
    return content
      .map((block) => {
        if (!block || typeof block !== "object") return "";
        if (block.type === "text") return block.text || "";
        if (block.type === "tool_use") return `[used tool: ${block.name}]`;
        return "";
      })
      .filter(Boolean)
      .join("\n");
  }
  return "";
}

function main() {
  const raw = readStdin();
  let input;
  try {
    input = JSON.parse(raw);
  } catch {
    return;
  }

  const transcriptPath = input.transcript_path;
  const sessionId = input.session_id || "unknown";
  if (!transcriptPath || !fs.existsSync(transcriptPath)) return;

  fs.mkdirSync(stateDir, { recursive: true });
  const markerFile = path.join(stateDir, `${sessionId}.lastline`);

  let lastLine = 0;
  if (fs.existsSync(markerFile)) {
    lastLine = parseInt(fs.readFileSync(markerFile, "utf8").trim(), 10) || 0;
  }

  const lines = fs.readFileSync(transcriptPath, "utf8").split("\n");
  const totalLines = lines.length;
  if (totalLines <= lastLine) return;

  const newLines = lines.slice(lastLine);
  const entries = [];
  for (const line of newLines) {
    if (!line.trim()) continue;
    let obj;
    try {
      obj = JSON.parse(line);
    } catch {
      continue;
    }
    if (obj.type !== "user" && obj.type !== "assistant") continue;
    const text = extractText(obj.message);
    if (!text) continue;
    entries.push(
      `**${obj.type}** _(${obj.timestamp || ""})_\n\n${text}\n\n---\n`
    );
  }

  if (entries.length > 0) {
    if (!fs.existsSync(logFile)) {
      fs.writeFileSync(logFile, "# Conversation Log\n\n");
    }
    fs.appendFileSync(logFile, entries.join("\n") + "\n");
  }

  fs.writeFileSync(markerFile, String(totalLines));

  try {
    execSync("git add CONVERSATION_LOG.md", { cwd: repoDir, stdio: "ignore" });
    const diff = execSync("git diff --cached --name-only -- CONVERSATION_LOG.md", {
      cwd: repoDir,
    })
      .toString()
      .trim();
    if (diff) {
      execSync(`git commit -m "Auto-log: conversation update (${sessionId})"`, {
        cwd: repoDir,
        stdio: "ignore",
      });
      execSync("git push origin master", { cwd: repoDir, stdio: "ignore" });
    }
  } catch {
    // best-effort; don't fail the hook on git errors
  }
}

main();
