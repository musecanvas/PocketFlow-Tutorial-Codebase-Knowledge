#!/usr/bin/env bash
set -euo pipefail

trap 'echo "ERROR: An error occurred on line $LINENO. Exiting..." >&2' ERR

docker run -it --rm \
  --env-file .env \
  -v "$(pwd)":/app \
  -v "$HOME/Documents/java_project/seos":/app/seos \
  -v "$(pwd)/output_tutorials":/app/output \
  pocketflow-app --dir /app/seos --language "Chinese"




#   這個 bash 腳本的主要用途是**啟動並執行 PocketFlow 的 Docker 容器，來分析你本機的 Java 專案，並自動生成一份中文的教學文件**。

# 以下是腳本內容的逐項詳細解釋：

# 1. **`set -euo pipefail`**：
#    這是一種 Bash 的安全機制。當腳本遇到錯誤（`e`）、使用到未定義的變數（`u`）或是管道（pipe）操作失敗時，會立刻停止執行，避免產生不可預期的結果。

# 2. **`docker run -it --rm`**：
#    啟動一個 Docker 容器。`-it` 代表使用互動模式並配置終端機（讓你能在中端機看到正常的輸出結果），`--rm` 代表容器執行任務結束後會**自動刪除**，不會佔用硬碟空間。

# 3. **`--env-file .env`**：
#    將當前目錄的 .env 檔案載入到容器中，通常裡面包含了執行此工具必要的 API 金鑰（例如 `GEMINI_API_KEY`）。

# 4. **`-v "$(pwd)":/app`**：
#    將你目前所在的資料夾（PocketFlow 專案根目錄）掛載到容器內的 app 目錄。

# 5. **`-v "$HOME/Documents/java_project/seos":/app/seos`**：
#    （核心步驟）將你本機的 Java 專案原始碼掛載到容器內的 `/app/seos` 目錄，這樣 AI 工具才能讀取並分析這些程式碼。

# 6. **`-v "$(pwd)/output_tutorials":/app/output`**：
#    將本地的 output_tutorials 目錄掛載為容器內的 `/app/output`。如此一來，在容器內生成的教學文件就會直接保存到你本機的這個資料夾裡。

# 7. **`pocketflow-app`**：
#    指定要執行的 Docker Image 名稱。

# 8. **`--dir /app/seos --language "Chinese"`**：
#    這是傳遞給 PocketFlow 主程式的參數。
#    * `--dir` 告訴程式要去分析剛掛載進去的那包 Java 程式碼。
#    * `--language "Chinese"` 要求模型將分析結果與教學文件以**中文**輸出。
