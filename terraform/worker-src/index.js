export default {
  async fetch(request, env, ctx) {
    return new Response("Hello from Mahesh Worker 🚀", {
      headers: {
        "content-type": "text/plain",
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, OPTIONS",
        "Access-Control-Allow-Headers": "*"
      }
    });
  }
};
