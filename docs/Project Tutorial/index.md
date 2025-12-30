---
layout: default
title: "Project Tutorial (This Repo)"
nav_order: 2
has_children: true
---

# Project Tutorial: PocketFlow Tutorial Codebase Knowledge Builder

This section is a comprehensive, code-driven tutorial for **this repository itself** (the tool that generates tutorials for other codebases).

If you’re here because you want to *use* the tool quickly, start with [01 — Overview & Quickstart](01_overview.md).
If you want to *modify/extend* it, follow the chapters in order.

## What This Project Does

You point the tool at a **GitHub repo** or a **local directory**, and it:

1. Crawls files (include/exclude + size limit)
2. Uses an LLM to identify the most important abstractions
3. Uses an LLM to infer relationships between those abstractions
4. Orders chapters for a beginner-friendly narrative
5. Writes one chapter per abstraction (batch processing)
6. Emits a complete Markdown tutorial under `output/<project_name>/`

## Pipeline At A Glance

```mermaid
flowchart TD
  A[main.py CLI] --> B[flow.create_tutorial_flow]
  B --> C[FetchRepo]
  C --> D[IdentifyAbstractions]
  D --> E[AnalyzeRelationships]
  E --> F[OrderChapters]
  F --> G[WriteChapters (BatchNode)]
  G --> H[CombineTutorial]
  H --> I[output/<project>/index.md + chapters]
```

## Chapters

1. [01 — Overview & Quickstart](01_overview.md)
2. [02 — CLI, Inputs, and Shared State](02_cli_and_configuration.md)
3. [03 — Flow Orchestration](03_flow_orchestration.md)
4. [04 — FetchRepo: Crawling GitHub or Local](04_node_fetchrepo.md)
5. [05 — IdentifyAbstractions: Finding the “Top Concepts”](05_node_identify_abstractions.md)
6. [06 — AnalyzeRelationships + OrderChapters](06_node_relationships_and_ordering.md)
7. [07 — WriteChapters (BatchNode): Chapter Generation](07_node_write_chapters.md)
8. [08 — CombineTutorial: Turning Data into Files](08_node_combine_tutorial.md)
9. [09 — LLM Calls: Providers, Logging, Cache](09_llm_clients_logging_and_cache.md)
10. [10 — Crawlers & File Filtering Details](10_crawlers_and_file_filtering.md)
11. [11 — Extending & Troubleshooting](11_extending_and_troubleshooting.md)

---

Generated/maintained as part of this workspace’s documentation.
