---
layout: default
title: "01 — Overview & Quickstart"
parent: "Project Tutorial (This Repo)"
nav_order: 1
---

# 01 — Overview & Quickstart

This chapter explains what this repository is, what it outputs, and how to run it end-to-end.

## Mental Model

Think of this project as a **documentation factory**:

- **Input**: a repo (GitHub URL) or folder (local directory)
- **Processing**: a PocketFlow workflow that calls an LLM several times
- **Output**: a folder full of Markdown tutorial pages

The workflow stages are implemented as “nodes” in [nodes.py](../../nodes.py).

## Quickstart (Local)

1. Install deps:

```bash
pip install -r requirements.txt
```

2. Configure an LLM provider (see [09 — LLM Calls](09_llm_clients_logging_and_cache.md)).

3. Run against a local directory:

```bash
python main.py --dir /path/to/codebase --include "*.py" --exclude "*test*"
```

This will create output under:

- `output/<project_name>/index.md`
- `output/<project_name>/01_*.md`, `02_*.md`, …

## Quickstart (GitHub)

```bash
python main.py --repo https://github.com/owner/repo --include "*.py" "*.md" --max-size 50000
```

Notes:
- For rate limits/private repos, set `GITHUB_TOKEN` or pass `--token`.
- The project name defaults to the repo name unless `--name` is provided.

## What Gets Generated

The generator writes:

- `index.md`
  - A short project summary
  - A Mermaid relationship diagram of the key abstractions
  - A chapter list in an LLM-determined order
- One chapter per abstraction

You can see exactly how the output is assembled in the `CombineTutorial` node in [nodes.py](../../nodes.py).

## Where To Look First In The Code

If you want to understand runtime control flow:

- [main.py](../../main.py): CLI parsing + building the shared state
- [flow.py](../../flow.py): wiring nodes into a linear pipeline
- [nodes.py](../../nodes.py): the actual “work” steps
- [utils/call_llm.py](../../utils/call_llm.py): LLM provider selection, logging, caching
- [utils/crawl_local_files.py](../../utils/crawl_local_files.py) and [utils/crawl_github_files.py](../../utils/crawl_github_files.py): input ingestion

Next chapter: [02 — CLI, Inputs, and Shared State](02_cli_and_configuration.md)
