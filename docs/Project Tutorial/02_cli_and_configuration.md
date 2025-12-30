---
layout: default
title: "02 — CLI, Inputs, and Shared State"
parent: "Project Tutorial (This Repo)"
nav_order: 2
---

# 02 — CLI, Inputs, and Shared State

This project is driven by a single CLI entrypoint: [main.py](../../main.py).

## The CLI Interface

The CLI is designed around **one input source**:

- `--repo <url>` for GitHub
- `--dir <path>` for local files

These are mutually exclusive.

Common flags:

- `--name`: override derived project name
- `--token`: GitHub token (or env `GITHUB_TOKEN`)
- `--output`: base output directory (default `output`)
- `--include`: file glob patterns to include
- `--exclude`: file glob patterns to exclude
- `--max-size`: max bytes per file (default 100000)
- `--language`: tutorial language (default `english`)
- `--no-cache`: disables LLM response caching
- `--max-abstractions`: cap how many abstractions the LLM should return

The defaults for include/exclude are defined in [main.py](../../main.py).

## The “Shared Store” Contract

PocketFlow nodes communicate via a shared dictionary (`shared`).

In [main.py](../../main.py), the shared store is initialized with:

- Inputs (repo URL, patterns, language, caching)
- Empty outputs to be populated by nodes (`files`, `abstractions`, …)

A simplified version (naming matches the real code):

```python
shared = {
  "repo_url": None,
  "local_dir": None,
  "project_name": None,
  "github_token": None,
  "output_dir": "output",
  "include_patterns": set(),
  "exclude_patterns": set(),
  "max_file_size": 100000,
  "language": "english",
  "use_cache": True,
  "max_abstraction_num": 10,

  "files": [],
  "abstractions": [],
  "relationships": {},
  "chapter_order": [],
  "chapters": [],
  "final_output_dir": None,
}
```

Why this matters:

- It’s the **boundary** between steps.
- It’s also the easiest extension point: add new keys, new nodes, new output types.

## Derived Project Name

If you don’t pass `--name`, the project name is derived:

- From `repo_url` last path segment
- Or from the basename of the local directory

This happens in `FetchRepo.prep()` (see [04 — FetchRepo](04_node_fetchrepo.md)).

Next chapter: [03 — Flow Orchestration](03_flow_orchestration.md)
