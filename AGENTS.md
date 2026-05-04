# AGENTS.md — AI Agent Instructions

## Project Overview
This tool crawls a GitHub repo or local directory, analyzes its codebase with an LLM, and produces a beginner-friendly multi-chapter Markdown tutorial. It is itself built with [PocketFlow](https://github.com/The-Pocket/PocketFlow), a 100-line graph-based LLM framework.

## Architecture: PocketFlow Pipeline

The core pipeline is a linear 6-node Flow defined in `flow.py`:

```
FetchRepo → IdentifyAbstractions → AnalyzeRelationships → OrderChapters → WriteChapters → CombineTutorial
```

- All inter-node data travels through a single `shared` dict (Python in-memory)
- `nodes.py` contains all Node/BatchNode class definitions
- `flow.py` wires them together and returns a `Flow` object
- `main.py` is the CLI entry point; it builds `shared` and calls `flow.run(shared)`

### Key `shared` dict keys (set by nodes in order)
| Key | Set by | Type |
|-----|--------|------|
| `files` | FetchRepo | `list[(path, content)]` |
| `abstractions` | IdentifyAbstractions | `list[{name, description, files:[int]}]` |
| `relationships` | AnalyzeRelationships | `{summary: str, details: [{from, to, label}]}` |
| `chapter_order` | OrderChapters | `list[int]` (abstraction indices) |
| `chapters` | WriteChapters | `list[str]` (Markdown per chapter) |
| `final_output_dir` | CombineTutorial | `str` |

## Node Patterns
- **prep()** — reads from `shared`, returns data for exec (no side effects)
- **exec()** — pure logic, calls `call_llm()` or utility functions, no shared access
- **post()** — writes exec result back to `shared`, returns action string

`WriteChapters` is a `BatchNode`: `prep()` returns a list; `exec()` is called once per item.

LLM nodes use `max_retries=5, wait=20` (set in `flow.py`). Cache is bypassed on retries: `call_llm(prompt, use_cache=(use_cache and self.cur_retry == 0))`.

## Utility Functions (`utils/`)
- `call_llm.py` — primary LLM interface with prompt/response logging and disk-based JSON cache (`llm_cache.json`)
- `crawl_github_files.py` — fetches files from a public GitHub repo via API
- `crawl_local_files.py` — walks a local directory respecting include/exclude glob patterns

## LLM Provider Configuration (`.env`)
```
GEMINI_API_KEY=...          # Default provider; uses gemini-2.5-pro-exp-03-25
GEMINI_PROJECT_ID=...       # Alternative: Vertex AI auth
LLM_PROVIDER=XAI            # Override to use any OpenAI-compatible API
XAI_MODEL=...
XAI_BASE_URL=...
XAI_API_KEY=...
GITHUB_TOKEN=...            # Avoid GitHub API rate limits
```

## Developer Workflows

### Run a tutorial generation
```bash
# From a GitHub repo
python main.py --repo https://github.com/username/repo --include "*.py"

# From a local directory
python main.py --dir /path/to/code --exclude "*test*" --language "Chinese"

# Disable cache (forces fresh LLM calls)
python main.py --repo ... --no-cache
```

### Test LLM setup
```bash
python utils/call_llm.py
```

### Install dependencies
```bash
pip install -r requirements.txt
```

## Project-Specific Conventions
- **No try/except in node exec()** — fail fast to surface LLM or parsing errors quickly
- **YAML parsing convention** — all LLM responses are expected in fenced `\`\`\`yaml` blocks; extracted with `response.strip().split("```yaml")[1].split("```")[0].strip()`
- **File index references** — files are referenced by integer index throughout (e.g., `0 # path/to/file.py`); always use `get_content_for_indices()` to resolve them
- **Context limits** — controlled by env vars `MAX_LLM_CONTEXT_CHARS` (default 200000) and `MAX_FILE_SNIPPET_CHARS` (default 2000)
- **Output structure** — tutorials are saved to `output/<project_name>/` with `index.md` + numbered chapter files (e.g., `01_<name>.md`)
- **Docs** — `docs/` contains pre-generated tutorials for popular repos; `docs/design.md` holds the high-level system design
