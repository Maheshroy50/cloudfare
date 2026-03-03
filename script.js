// 🔧 After running `terraform apply`, update this URL with the worker_url output:
//    cd terraform && terraform output worker_url
const workerUrl = "https://mahesh-backend-worker.maheshbhoopathi.workers.dev";
    "https://mahesh-backend-worker.79afe666f10f266913380978e53d07af.workers.dev";

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