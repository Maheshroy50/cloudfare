const workerUrl =
  "mahesh-backend-worker.maheshbhoopathi.workers.dev";

document.getElementById("btn").addEventListener("click", async () => {
  const output = document.getElementById("output");

  try {
    output.textContent = "Calling backend...";

    const res = await fetch(workerUrl);
    const text = await res.text();

    output.textContent = text;
  } catch (err) {
    output.textContent = "Error calling backend: " + err.message;
  }
});