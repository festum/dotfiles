const HS_BASE_URL = process.env.PI_HS_BASE_URL ?? "http://10.13.0.3:8888";
const HS_BANK_ID = process.env.PI_HS_BANK_ID ?? "pi-s0";
const RETAIN_URL = `${HS_BASE_URL}/v1/default/banks/${HS_BANK_ID}/memories`;

function textOfUser(message) {
  if (!message || message.role !== "user") return "";
  if (typeof message.content === "string") return message.content.trim();
  if (!Array.isArray(message.content)) return "";
  return message.content
    .filter((block) => block?.type === "text" && typeof block?.text === "string")
    .map((block) => block.text)
    .join("\n")
    .trim();
}

function textOfAssistant(message) {
  if (!message || message.role !== "assistant") return "";
  if (typeof message.content === "string") return message.content.trim();
  if (!Array.isArray(message.content)) return "";
  return message.content
    .filter((block) => block?.type === "text" && typeof block?.text === "string")
    .map((block) => block.text)
    .join("\n")
    .trim();
}

export default function hindsightBridge(pi) {
  pi.on("agent_end", async (event, ctx) => {
    const messages = Array.isArray(event?.messages) ? event.messages : [];
    const lastAssistant = [...messages].reverse().find((m) => m?.role === "assistant");
    if (!lastAssistant) return;

    const assistantText = textOfAssistant(lastAssistant);
    if (!assistantText) return;

    const lastUser = [...messages].reverse().find((m) => m?.role === "user");
    const userText = textOfUser(lastUser);

    const happenedAt = new Date().toISOString();
    const retained = [
      `[omp-hindsight-bridge] ${happenedAt}`,
      `cwd: ${ctx?.cwd ?? ""}`,
      userText ? `user: ${userText}` : "user: <empty>",
      `assistant: ${assistantText}`,
    ].join("\n");

    const payload = {
      async: false,
      items: [
        {
          content: retained,
          context: "omp-bridge",
          tags: ["source:pi", "bridge:hindsight", `bank:${HS_BANK_ID}`],
          metadata: {
            bridge: "omp-hindsight-extension",
            cwd: String(ctx?.cwd ?? ""),
          },
        },
      ],
    };

    try {
      const controller = new AbortController();
      const timer = setTimeout(() => controller.abort(), 10000);
      await fetch(RETAIN_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
        signal: controller.signal,
      });
      clearTimeout(timer);
    } catch {
      // ignore bridge errors in non-interactive mode
    }
  });
}
