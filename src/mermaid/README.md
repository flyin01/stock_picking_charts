## Process Flow Summary (Write → Run → Debug Loop)

1. User gives task
→ “Write Python that parses a CSV and computes mean age.”

2. LLM (Qwen2.5 via Ollama) plans and writes code

3. LLM calls run_python_sandbox(code)

4. LangGraph routes the call to the sandbox executor

5. Sandbox (Docker) runs the code safely

6. Sandbox returns:

  * Output OR

  * Error message + stack trace

7. LangGraph feeds result back to the LLM

8. LLM analyzes the error, fixes code, retries

Loop continues until:
→ Code runs successfully
→ LangGraph routes final answer to the user

## Modular Architecture Layers
1. Layer 1 — Model

  * Ollama

  * Runs Qwen2.5 / Llama 3 / DeepSeek

  * Handles reasoning & code generation

2. Layer 2 — Agent Runtime

  * LangGraph

  * State machine

  * Tool routing

  * Multi-step reasoning

  * ReAct or custom workflow graphs

3. Layer 3 — Tools

  * Python execution sandbox

  * File reading/writing

  * Shell commands (optional, sandboxed)

4. Layer 4 — Sandbox

  * Docker container (preferred)

  * Provides isolation + safety

5. Layer 5 — Feedback Loop

  * Execution results

  * Error messages

  * LLM-based error correction

  * Iterative refinement